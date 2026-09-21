# Что улучшить в logic-pro-mcp

Найдено в живой сессии (Logic Pro, проект с track stack + take folder, русская раскладка, UAD без карты), 2026-09-21.
Каждый пункт: что сломано → где в коде → как чинить (рецепт уже проверен руками через AX).

---

## P0 — заявлено, но не работает

### 1. Плагины: `insert_plugin` / `bypass_plugin` / `plugin.list` / `plugin.remove` — заглушки
- **Где:** `Sources/LogicProMCP/Channels/AccessibilityChannel.swift:105` → `.error("Plugin operations not yet implemented via AX")`.
  При этом `MixerDispatcher.swift:116` и help в `SystemDispatcher.swift:145` рекламируют команду как рабочую.
- **Рецепты, которые работают:**
  - **list** — в инспекторном channel strip (`AXLayoutItem`, AXHelp начинается с `Left inspector channel strip`)
    каждый плагин — `AXGroup` с `AXDescription` = имя (обрезано до ~10 символов, напр. `UAD Pure P`), внутри `AXCheckBox d=bypass`, `AXButton d=open`, `AXButton d=list`.
  - **bypass** — `AXPress` на `AXCheckBox d=bypass` внутри группы, читать обратно `AXValue` (1 = bypassed).
  - **remove** — `AXPress` на `AXButton d=list` → появляется `AXMenu`, top-level item `No Plug-in` → `AXPress`. Работает.
  - **insert** — меню пустого слота открывается, но `AXPress` на пунктах **подменю** (`EQ > Channel EQ`) молча ничего не делает.
    Надёжный путь: меню-бар `Mix > Search and Add Plug-in…` → в появившемся окне `AXTextField` выставить `AXValue` = имя плагина
    (не печатать! см. п.6) → Return. Нюанс: плагин встаёт **в верхний слот**, поэтому цепочку надо добавлять в обратном порядке
    или потом переставлять.
- **Параметры плагинов:** в дефолтном Editor-виде у стоковых плагинов слайдеры без подписей (только `%`), у ChromaVerb вообще нет AX-контролов.
  Переключить окно в `View > Controls` (`AXMenuButton d=view` → item `Controls`) — появляются `AXStaticText "Threshold:"` + следующий `AXSlider`
  с `AXValueDescription` в реальных единицах (`-20.0 dB`, `38 ms`, `1.60 s`). Это даёт полноценный `plugin.set_param`.

### 2. `set_*` через `AXValue` на слайдерах Logic — не абсолютное значение
- Запись `AXValue` на слайдер плагина двигает его **на один шаг** (0→1→2…), а не в заданное значение.
- **Как надо:** цикл `AXIncrement`/`AXDecrement` с проверкой `AXValueDescription` до цели. Стоит проверить и `mixer.set_volume`/`set_pan`
  — если они пишут `AXValue` напрямую, то, вероятно, тоже промахиваются.

### 3. `logic_tracks select` возвращает успех, но трек не выделяется
- **Где:** `AccessibilityChannel.swift:207` `selectTrack` — `AXPress` на `AXLayoutItem` заголовка трека; Logic его игнорирует,
  а функция всё равно отвечает `{"selected":N}` без проверки.
- **Фикс:** после действия перечитать `isTrackSelected` / radio `Has Focus`; если не сменилось — фолбэк (клик по имени трека через CGEvent
  или `AXSelected`), а при неудаче честно возвращать ошибку. Тот же паттерн «успех без проверки» — в `renameTrack` (`:239`).

---

## P1 — неверные данные

### 4. Take-лейны и подтреки считаются отдельными треками → индексы съезжают
- **Где:** `AXLogicProElements.swift:92` `allTrackHeaders()` берёт все дети контейнера заголовков.
- **Симптом:** в проекте 5 реальных треков, `logic://tracks` отдаёт 26 (20 строк `Track 3 “Warm Vocal”, Take`). Индекс MCP ≠ номер трека в UI,
  а у take-строк нет Mute/Solo, так что `mute/solo/arm` по индексу бьют мимо.
- **Фикс:** фильтровать по `AXDescription` (`…, Take` — лейн), парсить номер из `Track N “…”`, отдавать его как `number`;
  добавить поля `isStack` (есть `AXDisclosureTriangle`), `parent`, `hasOutput` (`…, no output` в описании).

### 5. `volume` / `pan` / `type` в `logic://tracks` всегда 0 / 0 / unknown
- **Где:** `AXValueExtractors.swift:109-110` — `volume: 0.0, pan: 0.0` захардкожены.
- **Фикс:** в заголовке есть `AXSlider d=Volume` (сырое 0–~200, 173 ≈ 0 dB) и `AXSlider` пан (64 = центр) + `AXValueDescription`.
  Тип: инспекторный strip показывает input (`Bus 1` → aux/summing stack), `channel mode` Mono/Stereo.

### 6. `logic://mixer` пустой, если не открыт Mixer
- **Где:** `AXLogicProElements.swift:100` `getMixerArea()` ищет только оконную панель Mixer.
- **Фикс:** фолбэк на инспекторный strip (выделенный трек) — там есть всё: fader, pan, sends, output, input, inserts, setting (`Vocal light`).

---

## P2 — надёжность / среда

### 7. Ввод текста ломается на не-английской раскладке
- `keystroke "Channel EQ"` при русской раскладке печатает `ффф…`. Любой ввод текста — только через `AXValue` у текстового поля.
  Хоткеи через CGEvent (виртуальные keycodes) — ок, но стоит проверить модификаторные шорткаты на ЙЦУКЕН.

### 8. Логика «окна» и multi-Space
- `AXWindows` у Logic иногда пустой — работает только `AXMainWindow`. Модальные окна (Search and Add, Save Patch) становятся main-окном,
  и все поиски strip'а после них ломаются до закрытия модалки — нужен явный «ждать/закрыть модалку».
- Кнопка `open` у плагина — **тоггл**: если окно уже открыто (скрыто через Hide All), нажатие его закрывает.

### 9. Нет сохранения/загрузки пресетов канала
- Работает: `AXButton t="Save…"` в панели Library → окно `Save Patch as…` → `AXTextField` с `AXIdentifier=saveAsNameTextField` → `Save`.
  Файл ложится в `~/Music/Audio Music Apps/Patches/Audio/<name>.patch`. Можно добавить `logic_mixer("save_patch", {name})`.

### 10. Каналы для «ушей»
- Нет способа снять метрики: `peak level meter` (`AXTitle "peak level meter, -4.7 dB"`) и `gain reduction meter` уже читаются из strip'а —
  стоит отдать ресурсом. Плюс `project.bounce` со стемами → внешний анализ (LUFS, спектр) для сведения по цифрам.

---

## С чего начать
1. п.1 (плагины) + п.2 (абсолютные значения) — это превращает MCP из «транспорт-пульта» в инструмент сведения.
2. п.4–5 — без правильных индексов всё остальное бьёт не в тот трек.
3. п.3 — честные ошибки вместо ложного успеха.
