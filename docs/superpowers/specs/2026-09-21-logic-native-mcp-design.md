# Logic-native MCP: дизайн

Дата: 2026-09-21 · Статус: утверждён в брейншторме, ждёт ревью спека
Основа: `OBSERVATIONS.md`, `IMPROVEMENTS.md`, аудит кода upstream (c69f952…f8127c3)

## 1. Цель

Превратить сырой upstream-MCP в production-ready сервер, через который модель **видит Logic Pro как карту** и управляет
любым её узлом — невидимо для пользователя, без компьютерного зрения, экономно по токенам.

Стратегия: **хард-форк** (github.com/Terobyte/logic-pro-mcp). Интерфейс инструментов и внутренняя архитектура меняются
свободно; upstream — источник идей, не ограничение.

### Что значит «native»
- **Язык Logic.** Адреса и значения — как их видит человек в UI: номер трека из Logic, имя, слот, `-6 dB`, `38 ms`, `L12`.
- **Невидимо.** Никакой кражи фокуса, переключения Space, всплывающих окон, которые пользователь не открывал.
  Не зависит от раскладки клавиатуры.
- **macOS-нативно.** Чистый Swift, без сторонних рантаймов, подписанный бинарь со стабильным TCC-идентитетом.
- **Без зрения.** Только Accessibility, CoreMIDI, файловая система. Никаких скриншотов/OCR.

### Scope v1 — полный контроль
Сведение · «уши» (метры, баунс, анализ) · транспорт + проект · композиция/MIDI · монтаж и комп дублей.

### Вне scope v1 (запаркованно)
- Голосовой wake-word («ключевое слово → модель просыпается → запись»). Архитектура оставляет под него место:
  ядро — отдельная библиотека + шина событий (см. §4, §8), будущий демон — второй адаптер.
- Локализованный UI Logic (не английский). В v1 все AX-строки собраны в таблицу локали; другой язык = данные, не код.
- OSC-канал (требует ручной настройки Control Surface) — удаляется.

## 2. Диагноз текущего кода (почему переписываем ядро, а не латаем)

| Проблема | Где | Следствие |
|---|---|---|
| Всё строками: `Value → [String:String] → operation:String → switch` | `ChannelRouter`, все каналы | операция может быть в роутинге и отсутствовать в канале; заглушки `plugin.*` рекламируются в help |
| Нет верификации: `success` = «нажал» | `AccessibilityChannel` | `select`, `rename`, `set_volume` врут |
| Небезопасные фолбэки | `routingTable` | `transport.stop` → CGEvent `Space` (тоггл!) — может запустить воспроизведение |
| Позиционная идентичность | `allTrackHeaders()` | take-лейны сдвигают индексы, mute бьёт не в тот трек |
| Нетипизированная схема `params: object` + дефолты `?? 0` | все диспетчеры | модель угадывает параметры; ошибка → молча трек 0 |
| JSON собирается интерполяцией | `SystemDispatcher`, каналы | имя с кавычкой ломает ответ |
| `[]` вместо «не могу прочитать» | `logic://mixer` | ложные данные |
| CGEvent требует frontmost | `CGEventChannel` | нарушает «невидимо» |
| Нет офлайн-тестов AX-логики | `Tests/` | любой рефакторинг — вслепую |

Сохраняем: `MIDIEngine`/`MMCCommands` (после ревью), `PermissionChecker`, куски `AXHelpers`, `InputValidation`.

## 3. Архитектура

```
┌──────────── LogicMCP (executable, тонкий адаптер) ───────────────┐
│ Tools: logic_read · logic_set · logic_do · logic_midi            │
│ TextRenderer (компактный вывод) · ErrorMapper · Resources/Subs   │
└───────────────────────────┬──────────────────────────────────────┘
                            │ Swift API (типизированный)
┌──────────── LogicKit (library, всё знание о Logic) ──────────────┐
│ Map:      Path parser · Node kinds · Resolver · Handles          │
│ Engine:   Executor(actor) · Recipes · Primitives · Verify        │
│ UI:       ModalGuard · WindowTransaction · FocusGuard            │
│ Platform: AXNode(protocol) ← LiveAX | FixtureAX · LocaleTable    │
│ Streams:  MIDI (CoreMIDI) · EventBus · AudioAnalysis             │
└──────────────────────────────────────────────────────────────────┘
       ▲ будущее: VoiceDaemon (второй адаптер над LogicKit)
```

Пакет:
- `LogicKit` — library target. Не импортирует `MCP`.
- `LogicMCP` — executable target, зависит от `LogicKit` и `MCP`.
- `logic-ax-dump` — dev-executable: записывает живое AX-поддерево Logic в JSON-фикстуру.
- `LogicKitTests` — офлайн, на фикстурах. `LogicLiveTests` — против запущенного Logic, только при `LOGIC_LIVE=1`.

Ключевое решение для тестируемости: весь AX-доступ идёт через протокол `AXNode`
(`role`, `subrole`, `title`, `desc`, `help`, `identifier`, `value`, `valueDescription`, `children`, `perform(action)`,
`set(attr, value)`). `LiveAXNode` оборачивает `AXUIElement`; `FixtureAXNode` читает JSON и эмулирует действия
(поведение слайдеров-шагов, тоггл-кнопки, появление меню описываются в фикстуре).

## 4. Карта (Logic Object Model)

### 4.1 Дерево узлов

```
/                         project: name, tempo, sig, sample_rate, dirty, logic_version
├─ transport              state(stopped|playing|recording|paused), position, cycle{on,start,end}, metronome, count_in
├─ track:N                name, kind(audio|inst|drummer|midi|aux|bus|stack), mute, solo, arm, color, selected, has_output
│  ├─ strip               volume(dB), pan, mode(mono|stereo), input, output, setting(patch), eq_thumb
│  │  ├─ insert:K         plugin, bypass, window(open|closed)
│  │  │  └─ param:<Name>  value, unit, range, steps
│  │  ├─ send:K           bus, level(dB), pre_post, bypass
│  │  └─ meter            peak(dB), gain_reduction(dB)           — живое значение, не кэшируется
│  ├─ track:M             дети стека (реальная иерархия)
│  ├─ take:K              take-лейны (не треки)                     └─ analysis
│  └─ region:K            name, start, end, length, loop, muted, gain, fades   ├─ notes (MIDI)  └─ analysis
├─ master                 strip (как у трека)
├─ marker:K               name, position
├─ patches                список пользовательских патчей (файловая система)
├─ render:K               результат баунса: path, format, analysis{…}
├─ ui                     main window, open windows, modal (если есть)
└─ raw                    AX-люк (см. 4.6)
```

### 4.2 Адреса

Грамматика: `path := segment ("/" segment)*`, `segment := kind [":" selector]`.

Селекторы:
- `3` — **номер из UI Logic** (1-based), парсится из AXDescription заголовка (`Track 3 “…”`). Никогда не индекс AX-ребёнка.
- `"Rose Vocal"` — имя. Коллизия → `ambiguous` со списком кандидатов.
- `selected` — текущее выделение.
- `#t4f2` — хэндл (4.3).
- Для `param` — имя параметра как в Controls-виде (`param:Threshold`).

Корневые сокращения: `track:3` ≡ `/track:3`; `master`, `transport`, `ui` — корневые.

### 4.3 Хэндлы
У Logic нет стабильных ID в AX. Резолвер выдаёт хэндл = короткий хэш отпечатка
`(kind, UI-номер, имя, путь родителя)`, хранит отпечаток в сессионной таблице.
Разрешение хэндла: точное совпадение отпечатка → ок; трек переехал, имя уникально → ре-резолв по имени (вывод помечает
`moved 3→4`); иначе `stale_ref`. Промах в соседний трек невозможен по построению.

### 4.4 Значения
Вход — строки в единицах Logic, парсер по `unit` узла: `"-6 dB"`, `"-inf"`, `"38 ms"`, `"1.6 s"`, `"20%"`,
`"L12"`/`"R5"`/`"C"`, `on`/`off`/`true`/`false`, перечисления (`stereo`). Числа без единиц принимаются, если единица
однозначна. Нормализованных 0–1 нет.

`set` всегда абсолютный и возвращает **фактическое** значение после verify.

### 4.5 Чтение и формат вывода
`logic_read(path, depth=1, fields?, format="text"|"json")`. По умолчанию — компактный текст:

```
track:3 #t4f2 "Rose Vocal" stack stereo M- S- R-  in=Bus 1 out=St Out
 strip vol=-4.2dB pan=C setting="Rose Vocal"
 insert:1 Channel EQ · 2 Compressor · 3 DeEsser 2 · 4 ChromaGlow · 5 ChromaVerb(bypass)
 send:1 →Bus 2 "PreDelay" -12dB post
 ⚠ Bus 2 "PreDelay": no output — send is silent
```

Правила:
- Флаги-тогглы одной буквой (`M+ S- R-`), дефолтные значения опускаются.
- Предупреждения (`⚠`) — производные факты карты (aux без выхода, Smart Controls на удалённый плагин, модалка).
- Непрочитанный узел: `?unavailable(mixer hidden)` — никогда не пустой список вместо ошибки.
- `json` — тот же контент структурой, с `outputSchema`.

### 4.6 Raw-люк
`logic_read("track:3/insert:4/raw", depth=3)` — компактный AX-снимок поддерева
(`role desc/title value [actions]` на строку, с короткими ref `r12`). `logic_do("raw:r12", "press"|"set", …)` —
действие по ref. Только внутри уже зарезолвленного узла карты (нельзя «ходить по всей системе»), ref живёт до
следующего снимка. Результат `raw`-действий всегда `unverified`. Назначение — длинный хвост (кастомные панели,
неизвестные диалоги), и сырьё для будущих рецептов.

### 4.7 Грамматика в описаниях инструментов
Статическая таблица «kind → свойства (тип/единица, settable?) → действия» лежит в описании `logic_read` (~700 токенов).
Статична → попадает в prompt cache. Параметры плагинов динамичны и узнаются чтением `insert:K`.

## 5. Движок действий

### 5.1 Конвейер
Все мутации идут через `actor Executor` строго последовательно:

```
resolve(path) → guard → act(primitives) → verify(readback, deadline) → Outcome
```

- **resolve** — заново на каждую операцию (AX-ссылки протухают при перерисовке). Кэш карты — только подсказка.
- **guard** — Logic запущен, разрешения, отпечаток версии, **нет блокирующей модалки** (иначе `blocked(modal:…)`).
- **act** — только примитивы:
  `press`, `setText(value)`, `stepTo(target)` (цикл `AXIncrement`/`AXDecrement` с чтением `AXValueDescription`,
  бинарная остановка на ближайшем достижимом шаге), `menu(path)` (главное меню через AX), `popupPick(item)`
  (только top-level пункты — подменю в Logic не реагируют на AXPress), `window(open|close)` (тоггл-осведомлённый).
- **verify** — перечитать целевое свойство, опрос каждые 30 мс до дедлайна (по умолчанию 1 с, рецепт может задать свой).

`Outcome`: `ok(actual)` · `sent` (физически не проверяемо: MIDI-события) · ошибка (5.5).

### 5.2 Рецепты
Операция карты = `Recipe` (Swift-значение, не строка):
`precondition`, `steps: [Primitive]`, `postcondition`, `idempotent: Bool`, `focus: .never | .restores`, `deadline`.
Каждый `(kind, property|action)` из грамматики обязан иметь рецепт — проверяется тестом полноты реестра
(грамматика ↔ реестр рецептов), так что «заявлено, но не реализовано» невозможно.

### 5.3 Политика фолбэков
- Тогглы всегда через `set`: прочитать → нажать только если отличается → verify. Слепого тоггла нет.
- Переход к альтернативному рецепту — только если verify показал «состояние не изменилось» **и** операция идемпотентна.
- Неидемпотентные операции (создать трек, вставить плагин) без фолбэка: неудача = ошибка с фактическим состоянием.

### 5.4 Невидимость и UI-транзакции
- Каналы по умолчанию: AX, CoreMIDI, файловая система, AppleScript только для lifecycle (launch/open/quit —
  по природе видимые, помечены).
- CGEvent удалён из дефолта. Если спайк покажет, что без него не обойтись, он допускается только внутри рецепта с
  `focus: .restores`.
- `FocusGuard` для `.restores`: запомнить frontmost-приложение и состояние окон Logic → выполнить → восстановить → verify, что frontmost прежний.
- `WindowTransaction`: окно, открытое рецептом, рецепт закрывает; окно, открытое до нас, не трогаем.
- На время транзакции наблюдатель состояния (§6) приостановлен.

### 5.5 Батчи и ошибки
`logic_set({path: value, …})` и `logic_do(steps:[…])` — последовательно до первой ошибки,
ответ `partial(done:[…], failed:{…})`.

Таксономия (одна строка + подсказка, MCP `isError: true`):
`not_found(candidates)` · `ambiguous(candidates)` · `stale_ref` · `blocked(modal)` · `unavailable(reason)` ·
`unsupported(reason)` · `invalid_value(expected)` · `verify_failed(want, got, hint)` · `timeout` · `partial` ·
`permission(ax|automation)` · `logic_not_running` · `unknown_logic_version`.

```
✗ verify_failed track:3/strip/volume want=-6.0dB got=-5.0dB — step is 1dB here; use -5 or -7
```

## 6. Состояние и события

- Постоянный поллер удаляется. Чтение — по запросу, со свежим резолвом; микрокэш TTL 250 мс для повторов внутри одного хода модели.
- `Watcher` для транспорта и выделения: `AXObserver` (value/focus notifications) там, где Logic их шлёт, иначе опрос
  250 мс. Работает **только пока есть подписчик**.
- `EventBus` (AsyncStream) в LogicKit: `transportChanged`, `trackListChanged`, `selectionChanged`, `modalAppeared`,
  `renderFinished`. Потребители: MCP resource subscriptions, ожидания (`until`), будущий голосовой демон.
- Ожидание без поллинга со стороны модели: `logic_read("transport", until="state=stopped", timeout="60s")`.

Ресурсы MCP: одна шаблонная `logic://map/{path}` (зеркало `logic_read`) с `subscribe`. Статические 7 ресурсов upstream удаляются.

## 7. MCP-поверхность

| Tool | Назначение | Annotations |
|---|---|---|
| `logic_read(path="/", depth=1, fields?, until?, timeout?, format?)` | читать карту, ждать условие | readOnly |
| `logic_set(assign:{path:value})` | абсолютная установка свойств, батч | idempotent |
| `logic_do(path, action, args?)` / `logic_do(steps:[{path,action,args}])` | действия: load_chain/remove/bypass plugin, create/delete track, play, bounce, save_patch, write_notes, split/trim/move/comp, raw press… | destructive (действия, которые можно откатить только Undo, перечислены в описании) |
| `logic_midi(events:[…], port?)` | real-time поток: note/chord/cc/pc/bend/aftertouch/sysex/mmc | не idempotent |

- Строгие `inputSchema` (типы, required, enum для `format`/`action`-списка по kind в описании), `outputSchema` для `format=json`.
- Диагностика — узел карты `ui` и `logic_read("/system")` (health, permissions, версия Logic, отпечаток). Отдельного `logic_system` нет.
- Бюджеты (проверяются тестом): все описания инструментов ≤ 1500 токенов; `logic_read("/")` на проекте из 5 треков ≤ 300;
  трек с strip ≤ 150; ошибка ≤ 60.

## 8. Домены v1

### 8.1 Сведение
- Треки: корректная модель (номер из UI, стеки как дерево, take как дети, `has_output`, `kind` по input/иконке).
- Strip: volume/pan через `stepTo`; mode mono/stereo; input/output/send-bus через popup (top-level пункты, для вложенных — спайк);
  sends level/pre-post/bypass.
- Inserts: `load` (Mix › Search and Add Plug-in… + `setText` имени + подтверждение). Наблюдение: плагин встаёт в
  **верхний** слот. Контракт для модели: `logic_do("track:3/strip", "load_chain", {plugins:[…]})` — сервер вставляет в
  обратном порядке и проверяет итоговый порядок. Одиночный `insert:K load` поддерживается, только если спайк S7 найдёт
  способ адресовать слот; иначе возвращает `unsupported` с подсказкой использовать `load_chain`. `remove` (list-меню → `No Plug-in`),
  `bypass` (checkbox + verify), `move`, `open/close` window.
- Params: окно плагина → `View › Controls` → пары `StaticText "Name:"` + `Slider` с `AXValueDescription` в реальных
  единицах; `stepTo` до цели. Таблица шагов на плагин кэшируется.
- Патчи: `save_patch(name)` (Library › Save… → `saveAsNameTextField`), `load_patch(name)`, список из
  `~/Music/Audio Music Apps/Patches/Audio/`.
- Master strip, выделение трека с verify и честной ошибкой.

### 8.2 Транспорт и проект
- play/stop/record/pause/locate — CoreMIDI MMC (невидимо), verify через `transport.state`; без keyboard-фолбэка.
- tempo, signature, cycle range, metronome, count-in — AX control bar, `setText` + verify.
- Markers: чтение/создание/переименование/переход.
- Проект: open/new/save/save_as/close/launch/quit; `dirty` флаг.
- Треки: create (kind), delete, rename (verify), duplicate, color.

### 8.3 Композиция / MIDI
- Real-time — `logic_midi` через виртуальный CoreMIDI-источник (существующий движок, после ревью).
- Запись нот без зрения: `logic_do("track:4", "write_notes", {at:"17 1 1 1", notes:[…]})` → сервер генерирует SMF →
  импорт через File › Import › MIDI File (путь через `setText` в open-panel) на выбранный трек в позицию плейхеда.
  Фолбэк — real-time запись через виртуальный порт в record-режиме.
- Чтение нот: `region:K/notes` — экспорт региона в MIDI-файл во временную папку → парсинг SMF.
- Регионы: список/выделение/rename/loop/mute через AX арранжировки; quantize/transpose — через меню Functions на выделенных.
- Все три пути — предмет спайков (§10); если AX регионов окажется недостаточным, узел помечается `unsupported` честно.

### 8.4 «Уши»
- Метры: `strip/meter` — peak и gain reduction из AX strip'а (снимок; `logic_read(..., until=…)` для окна наблюдения).
- Баунс: `logic_do("/", "bounce", {range, stems?, format})` — File › Bounce / Export All Tracks as Audio Files,
  путь/имя через `setText`. Результат — узел `render:K`. Длинная операция — MCP progress notifications.
- Анализ (in-process, AVFoundation + Accelerate): integrated/short-term LUFS (BS.1770-4), true peak (4× oversample),
  RMS, crest factor, стерео-корреляция, спектр по 10 полосам, сравнение с референс-файлом (дельты по полосам и LUFS).
  Доступно для `render:K` и для произвольного файла (`file:/path`).

### 8.5 Монтаж и комп («франкенштейн»)
Цель: собрать лучший вариант из дублей и кусков — резать, двигать, тримить, склеивать с фейдами — невидимо.

- Позиции везде в языке Logic: `"17 3 1 1"` (такт/доля/деление/тик) или `"0:01:23.450"`; также относительно
  региона: `region:3@"2.5s"`.
- Примитивы на `region:K` (все через AX-выделение + AX-меню, verify по списку регионов трека):
  `split(at:[…])` (locate через MMC → Edit › Split at Playhead; несколько точек за вызов),
  `trim(start?, end?)`, `move(to, track?)`, `copy(to, track?)`, `delete`, `mute`, `join(with:[…])`,
  `fade(in?, out?, curve?)`, `crossfade(with)`, `gain(dB)`.
- Take folder (`track:N` c take-лейнами): `take:K` — `select` (весь дубль как активный, через меню папки),
  `unpack` (в отдельные треки), `flatten`. Свайп-комп диапазонами — `comp(ranges:[{take, from, to}])`, если S3
  подтвердит AX-доступ; иначе рецепт `comp` реализуется фолбэком: unpack → split по границам диапазонов → mute лишнего →
  (опционально) bounce-in-place. Семантика для модели одна и та же.
- «Резать по слуху»: `logic_read("region:K/analysis")` экспортирует регион во временный файл и отдаёт
  паузы (`silence:[from,to]`), транзиенты/онсеты, громкость по фразам — чтобы точки склейки выбирались по тишине и
  атакам, а не по сетке. Переиспользует движок §8.4.
- Сравнение дублей: `take:K/analysis` — LUFS/pitch-стабильность/шум по каждому дублю для выбора кандидата.

## 9. Платформа и дистрибуция
- `LocaleTable`: все AX-строки (`"volume fader"`, `"Left inspector channel strip"`, `", Take"`, пункты меню) — в одном
  месте, ключи семантические. v1: `en`.
- Отпечаток Logic: версия бандла + наличие ключевых якорей AX при старте; неизвестная версия → предупреждение в
  `/system` и в первой ошибке, а не молчаливая поломка.
- Подпись: стабильный signing identity (self-signed cert или Developer ID), чтобы TCC-гранты переживали пересборку;
  `Scripts/install.sh` собирает, подписывает, кладёт в `~/.local/bin`, печатает шаги по разрешениям.
- Логи в stderr/os_log, никогда в stdout (stdio-транспорт).

## 10. Риски и спайки (фаза 0, до кода ядра)

| # | Вопрос | Как проверить | Что меняет |
|---|---|---|---|
| S1 | Какие окна Logic крадут фокус (Search and Add, Save Patch, Import MIDI, Bounce, окно плагина) при AX-управлении с Logic на другом Space | живой прогон, логировать frontmostApplication и активный Space до/после | `focus` рецептов; нужен ли FocusGuard/CGEvent |
| S2 | Доставляются ли AXObserver-нотификации от Logic (transport, selection) | подписка + лог | Watcher: observer vs опрос |
| S3 | AX-экспозиция регионов арранжировки, take folder (выбор дубля, диапазоны комп-свайпа) и Piano Roll | axdump проекта с регионами и take folder «бело красный» | реализуемость 8.3, 8.5; нативный comp vs фолбэк |
| S4 | Import MIDI / Export region: работает ли open/save-panel через `setText` пути | живой прогон | путь write_notes/read notes |
| S5 | Вложенные popup-меню I/O (Bus › Bus 2) | живой прогон | рецепт input/output/send |
| S7 | Search and Add: куда встаёт плагин при выделенном/пустом слоте; можно ли вставить в слот K (выделение слота, перестановка) | живой прогон | `insert:K load` vs только `load_chain` |
| S6 | Шаги `stepTo` на фейдере/пане strip (линейность, скорость, максимальное число шагов) | замер | дедлайны, точность |

Результаты спайков записываются в `docs/superpowers/specs/spikes-2026-09.md`; фикстуры AX — в `Tests/Fixtures/`.

## 11. Фазы

Каждая фаза — отдельный план реализации. Фазы 2–5 можно переставлять, 0–1 обязательны первыми.

- **P0 Спайки** — §10 + `logic-ax-dump` + первые фикстуры.
- **P1 Фундамент** — split на `LogicKit`/`LogicMCP`, `AXNode` + фикстуры, LocaleTable, Path/Resolver/Handles,
  Executor/Primitives/Verify, TextRenderer, 4 инструмента; вертикальный срез: чтение `/`, `track:N`, `strip`,
  `set mute/solo/volume/pan`, `select` с verify. Старые диспетчеры, роутер, поллер, OSC удаляются в конце фазы.
- **P2 Сведение** — §8.1 полностью.
- **P3 Транспорт + проект + события** — §8.2, Watcher/EventBus/`until`, resource subscriptions.
- **P4 Композиция + монтаж** — §8.3, §8.5 (анализ регионов для «резать по слуху» подключается в P5).
- **P5 Уши** — §8.4 + analysis-узлы §8.5.
- **P6 Hardening** — отпечаток версии, подпись/установка, бюджеты токенов в CI, README, live-suite.

## 12. Критерии готовности (v1)
1. Ни одна мутация не возвращает `ok` без readback; класс `sent` — только MIDI-события.
2. После любой операции с `focus: .never` frontmost-приложение и активный Space не изменились (live-тест).
3. Все пункты `IMPROVEMENTS.md` P0–P2 закрыты или явно помечены `unsupported` с причиной.
4. Бюджеты токенов §7 проходят в тестах.
5. Реестр рецептов покрывает грамматику на 100% (тест полноты).
6. Офлайн-тесты на фикстурах покрывают резолвер, адреса, хэндлы, парсер значений, рендерер, рецепты сведения.
7. Сценарий «бело красный» воспроизводится целиком через MCP: собрать вокальную цепочку из 5 плагинов с параметрами,
   выставить уровни/посылы, сохранить патч, забаунсить и получить LUFS/спектр — без единого видимого окна.
8. Комп-сценарий: из take folder (~20 дублей) собрать вокал из кусков разных дублей по точкам, найденным анализом
   пауз, с кроссфейдами на стыках — только через MCP.
