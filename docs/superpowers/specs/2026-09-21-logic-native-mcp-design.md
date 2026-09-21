# Logic-native MCP: дизайн

Дата: 2026-09-21 · Версия: v2 (после ревью) · **Статус: DRAFT до завершения P0.**
Архитектура (§3–§7) утверждена в брейншторме; всё, что помечено ⛳S*, — гипотеза до соответствующего спайка
и может измениться по его итогам. Основа: `OBSERVATIONS.md`, `IMPROVEMENTS.md`, аудит кода upstream (c69f952…f8127c3).

## 1. Цель

Превратить сырой upstream-MCP в production-ready сервер, через который модель **видит Logic Pro как карту** и управляет
её узлами — незаметно для пользователя, без компьютерного зрения, экономно по токенам.

Стратегия: **хард-форк** (github.com/Terobyte/logic-pro-mcp). Интерфейс и внутренности меняются свободно.

### Что значит «native»
- **Язык Logic.** Адреса и значения как в UI: номер трека из Logic, имя, слот, `-6 dB`, `38 ms`, `L12`.
- **Незаметно (точное определение):**
  1. не меняем активный Space и frontmost-приложение пользователя (или восстанавливаем их в пределах операции);
  2. не оставляем после операции окон, которых не было до неё;
  3. рабочие окна Logic (Search and Add, Controls, Save, Bounce) **могут мелькать** внутри операции — это допустимо и
     помечается в грамматике (§5.4);
  4. не зависим от раскладки клавиатуры (текст только через `AXValue`).
- **macOS-нативно.** Чистый Swift, без сторонних рантаймов, подписанный бинарь со стабильным TCC-идентитетом.
- **Без зрения.** Accessibility, CoreMIDI, файловая система. Никаких скриншотов/OCR.

### Scope v1 — полный контроль
Сведение · «уши» · транспорт + проект · композиция/MIDI · монтаж и комп дублей.
Каждая возможность попадает в рекламируемую грамматику только со статусом `live-verified` (§5.6).
То, что спайк признает нереализуемым невидимо, возвращает `unsupported(reason)` — это допустимый итог v1, а не провал.

### Вне scope v1 (запаркованно)
- Голосовой wake-word. Место оставлено: ядро — библиотека + шина событий; будущий демон — второй адаптер.
- Локализованный UI Logic. В v1 все AX-строки в `LocaleTable`; другой язык = данные.

## 2. Диагноз текущего кода

| Проблема | Где | Следствие |
|---|---|---|
| Всё строками: `Value → [String:String] → operation:String → switch` | `ChannelRouter`, каналы | операция в роутинге без реализации; `plugin.*` рекламируются в help и сразу `not yet implemented` |
| Нет верификации: `success` = «нажал» | `AccessibilityChannel` | `select` отвечает `{"selected":N}` без readback; `rename`, `set_volume` врут |
| Небезопасные фолбэки | `routingTable` | `transport.stop` → CGEvent `Space` (тоггл) |
| Позиционная идентичность | `allTrackHeaders()` | take-лейны сдвигают индексы |
| Нетипизированная схема `params: object` + дефолты `?? 0` | диспетчеры | ошибка параметра → молча трек 0 |
| JSON интерполяцией | `SystemDispatcher`, каналы | имя с кавычкой ломает ответ |
| `[]` вместо «не могу прочитать» | `logic://mixer` | ложные данные |
| CGEvent требует frontmost | `CGEventChannel` | нарушает незаметность |
| Нет офлайн-тестов AX-логики | `Tests/` | рефакторинг вслепую |

Сохраняем после ревью: `MIDIEngine`/`MMCCommands`, `PermissionChecker`, куски `AXHelpers`, `InputValidation`.
OSC-канал **сохраняется** до решения по итогам S6 (§10).

## 3. Архитектура

```
┌──────────── LogicMCP (executable, тонкий адаптер) ───────────────┐
│ Tools: logic_read · logic_set · logic_do · logic_midi            │
│ ArgValidator · TextRenderer · ErrorMapper · Resources/Subs       │
└───────────────────────────┬──────────────────────────────────────┘
                            │ Swift API (типизированный)
┌──────────── LogicKit (library, всё знание о Logic) ──────────────┐
│ Map:      Path parser · Grammar(+status) · Resolver · Handles    │
│ Engine:   AXActor(все AX-вызовы) · Recipes · Primitives · Verify │
│ UI:       ModalGuard · WindowTransaction · FocusGuard            │
│ Platform: AXNode(protocol) ← LiveAX | FixtureAX · LocaleTable    │
│ Streams:  MIDI (CoreMIDI) · EventBus · AudioAnalysis · OSC(opt)  │
└──────────────────────────────────────────────────────────────────┘
       ▲ будущее: VoiceDaemon (второй адаптер над LogicKit)
```

Пакет:
- `LogicKit` — library, не импортирует `MCP`.
- `LogicMCP` — executable, зависит от `LogicKit` и `MCP`.
- `logic-ax-dump` — dev-executable: записывает AX-поддерево Logic в JSON-фикстуру.
- `LogicKitTests` — офлайн, на фикстурах. `LogicLiveTests` — против запущенного Logic, при `LOGIC_LIVE=1`.

`AXNode` — протокол всего AX-доступа (`role`, `subrole`, `title`, `desc`, `help`, `identifier`, `value`,
`valueDescription`, `children`, `perform`, `set`). `LiveAXNode` оборачивает `AXUIElement`; `FixtureAXNode` читает JSON.

**Граница фикстур (жёсткая):** `FixtureAXNode` — статический снимок. Он **не эмулирует** поведение Logic (шаги слайдеров,
тогглы, появление меню, модалки). Офлайн-тесты проверяют: парсер путей и значений, резолвер и хэндлы, рендерер,
грамматику, валидацию аргументов, **последовательность примитивов**, которую рецепт планирует для данного снимка.
Что рецепт *работает*, доказывает только live-тест (§5.6).

## 4. Карта (Logic Object Model)

### 4.1 Дерево узлов

```
/                         project: name, tempo, sig, sample_rate, dirty, logic_version
├─ transport              state(stopped|playing|recording|paused), position, cycle{on,start,end}, metronome, count_in
├─ track:N                name, kind, mute, solo, arm, color, selected, has_output
│  ├─ strip               ⚑ inspector-узел, см. 4.2
│  │  ├─ insert:K         plugin, bypass, window(open|closed)
│  │  │  └─ param:<Name>  value, unit, range, step
│  │  ├─ send:K           bus, level(dB), pre_post, bypass
│  │  └─ meter            peak(dB), gain_reduction(dB)      — живое значение, не кэшируется
│  ├─ track:M             дети стека
│  ├─ take:K              take-лейны                        └─ analysis
│  └─ region:K            name, start, end, length, loop, muted, gain, fades   ├─ notes  └─ analysis
├─ master                 strip
├─ marker:K               name, position
├─ patches · render:K · ui (окна, модалка, undo_title) · system (health, permissions, версия, отпечаток)
└─ raw                    AX-люк (4.7)
```

### 4.2 Strip и выделение
AX отдаёт полный channel strip только для **выделенного** трека (Left inspector channel strip). Поэтому:
- Чтение `track:N/strip`: из inspector'а, если N выделен; из Mixer-панели, если пользователь её сам открыл; иначе
  узел `?unavailable(need_select)` с кратким срезом из заголовка трека (volume/pan, если там есть слайдеры ⛳S8).
- Мутации `track:N/strip/**` и `load_chain`: рецепт сначала выполняет **verified select** N, затем работает с inspector'ом.
  Смена выделения — видимый побочный эффект и явно отдаётся в ответе: `selection 2→3`.
- Если невидимый verified select не найден (⛳S8) — мутации strip доступны только для `track:selected`, остальные
  возвращают `unsupported(need_select: select track 3 in Logic)`.
- Мы не открываем Mixer-панель сами (это изменение вида пользователя).

### 4.3 Адреса
Грамматика: `path := segment ("/" segment)*`, `segment := kind [":" selector]`.
Селекторы: `3` (**номер из UI Logic**, 1-based, парсится из `Track 3 “…”`), `"Rose Vocal"` (имя; коллизия →
`ambiguous` с кандидатами), `selected`, `#t4f2` (хэндл), для `param` — имя как в Controls-виде.
Корневые сокращения: `track:3` ≡ `/track:3`.

### 4.4 Хэндлы
Хэндл = короткий хэш отпечатка `(kind, UI-номер, имя, путь родителя, имена соседей prev/next)`.
Разрешение:
1. точное совпадение отпечатка → ок;
2. иначе поиск кандидатов с тем же `kind`, родителем **и** соседями; ровно один → ок, вывод помечает `moved 3→4`;
3. всё остальное (0 или >1 кандидатов, совпадение только по имени) → `stale_ref`.

После любой структурной мутации (create/delete/duplicate/unpack/flatten/undo/redo, смена проекта) таблица хэндлов
сбрасывается; старые хэндлы → `stale_ref`. Хэндлы — защита от промаха, а не гарантия; при сомнении — ошибка.

### 4.5 Значения
Вход — строки в единицах Logic по `unit` узла: `"-6 dB"`, `"-inf"`, `"38 ms"`, `"1.6 s"`, `"20%"`, `"L12"`/`"R5"`/`"C"`,
`on`/`off`, перечисления. Число без единиц — если единица однозначна. Нормализованных 0–1 нет.

### 4.6 Чтение и вывод
`logic_read(path, depth=1, fields?, until?, timeout?, format="text"|"json")`. Компактный текст по умолчанию:

```
track:3 #t4f2 "Rose Vocal" stack stereo M- S- R-  in=Bus 1 out=St Out  [selected]
 strip vol=-4.2dB pan=C setting="Rose Vocal"
 insert:1 Channel EQ · 2 Compressor · 3 DeEsser 2 · 4 ChromaGlow · 5 ChromaVerb(bypass)
 send:1 →Bus 2 "PreDelay" -12dB post
 ⚠ Bus 2 "PreDelay": no output — send is silent
```

- Тогглы одной буквой, дефолты опускаются, предупреждения `⚠` — производные факты карты.
- Непрочитанный узел — `?unavailable(reason)`, никогда пустой список.
- Take-лейны свёрнуты: `takes:20 (active 7)`; раскрываются только `depth≥2` или прямым адресом.
- `json` — тот же контент структурой, с `outputSchema`.

**`until` — мини-язык условий** (не произвольные выражения): одно условие `field op value` над узлом `path`,
`op ∈ {=, !=, <, <=, >, >=}`, значения в единицах узла. Пример: `until:"state=stopped"`, `until:"position>=17 1 1 1"`.
`timeout` обязателен, максимум 300 s.

### 4.7 Raw-люк
`logic_read("track:3/insert:4/raw", depth=3)` — компактный AX-снимок поддерева (`role desc/title value [actions]`,
ref `r12`), только внутри уже зарезолвленного узла карты. **По умолчанию только чтение.** Действия по ref
(`logic_do("raw:r12", "press"|"set")`) включаются флагом сервера `--allow-raw-actions`, возвращают `unverified` и не
считаются частью рекламируемой грамматики. Назначение — диагностика и сырьё для новых рецептов.

### 4.8 Грамматика в описаниях инструментов
Двухуровневая:
- в описании `logic_read` — **индекс**: список kinds, их свойства (одним словом) и действия, только `live-verified`;
- детали (типы, единицы, сигнатуры `args`) — по запросу `logic_read("system/schema/<kind>")` и в тексте ошибки
  `invalid_args`, чтобы модель исправлялась за один шаг.
Бюджет индекса измеряется тестом (§7), а не предполагается.

## 5. Движок действий

### 5.1 Конвейер и сериализация
**Все** AX-обращения — чтения, мутации, Watcher, `until` — идут через один `actor AXActor`. Мутации выполняются
транзакциями; чтения между шагами транзакции других клиентов не вклиниваются. MIDI (CoreMIDI) и анализ аудио —
вне AXActor.

```
resolve(path) → guard → act(primitives) → verify(readback, deadline) → Outcome
```

- **resolve** — заново на каждую операцию; кэш карты — только подсказка.
- **guard** — Logic запущен, разрешения, отпечаток версии; модалка (5.4); для destructive — чтение `dirty` и `undo_title`.
- **act** — только примитивы: `press`, `setText`, `stepTo(target)`, `menu(path)`, `popupPick(item)` (top-level пункты;
  вложенные — ⛳S5), `window(open|close)` (тоггл-осведомлённый), `select(track)` (⛳S8).
- **verify** — перечитать целевое свойство, опрос каждые 30 мс до дедлайна (дефолт 1 s, рецепт задаёт свой, ⛳S6).

### 5.2 Контракт set / stepTo (единый для всех дискретных контролов)
`stepTo` двигает контрол `AXIncrement`/`AXDecrement`, читая `AXValueDescription`, и останавливается на ближайшем
к цели достижимом значении. Результат:
- `ok(actual)` — контрол сдвинулся в сторону цели и `|want − actual| ≤ step` в этой точке шкалы; если `actual ≠ want`,
  ответ помечен `quantized` и сообщает шаг:
  `✓ track:3/insert:2/param:Threshold = -20dB (want -22dB, step 5dB)`;
- `verify_failed(want, got)` — только если контрол **не сдвинулся**, сдвинулся **не в ту сторону**, или остановился
  дальше одного шага от цели (упёрся в ограничение/сломанный рецепт);
- `invalid_value(range)` — цель вне диапазона контрола, до любых действий.
Шаг и скорость — предмет ⛳S6; S6 определяет дедлайны и выбор канала (AX vs OSC), но не семантику выше.

### 5.3 Рецепты и фолбэки
Операция карты = `Recipe` (Swift-значение): `precondition`, `steps`, `postcondition`, `idempotent`,
`visibility` (5.4), `reversible` (есть ли Logic-undo), `deadline`.
- Тогглы всегда через `set`: прочитать → нажать, только если отличается → verify. Слепого тоггла нет.
- Альтернативный рецепт — только если verify показал «состояние не изменилось» **и** операция идемпотентна.
- Неидемпотентные операции без фолбэка; частичный провал возвращает `partial` + фактическое состояние + `undo_steps`.

### 5.4 Незаметность, окна, сосуществование с пользователем
Каждый рецепт имеет `visibility`:
- `never` — ни одного окна, ни смены фокуса;
- `transient` — рецепт открывает рабочее окно Logic и закрывает его сам (Search and Add, Controls, Save Patch, Bounce);
- `restores` — рецепту приходится менять frontmost/Space; FocusGuard восстанавливает их.
Значения — гипотезы до ⛳S1.

`FocusGuard` снимает до/после: frontmost-приложение, набор on-screen окон (`CGWindowListCopyWindowInfo`,
on-screen only — отражает активный Space), список окон Logic. Любое отличие после операции (кроме объявленных
побочных эффектов, напр. выделение) — ошибка рецепта в live-тесте.

Сосуществование с пользователем (он может параллельно кликать в Logic):
- `WindowTransaction` закрывает только окна, которые открыл сам (идентификация по снимку до/после); чужие окна
  не трогаем никогда.
- Модалка, которой не было в плане рецепта (в т.ч. пользовательская), → `blocked(modal:"…")`. Мы её не закрываем.
- Destructive-операции на `dirty`-проекте выполняются, но ответ содержит `undo_steps` и `⚠ project unsaved`.
- `logic_do("/", "undo"|"redo", {steps?})` через Edit-меню по AX (невидимо), с verify по `undo_title`.

### 5.5 Батчи и ошибки
`logic_set(assign:[{path, value}, …])` — **упорядоченный массив**; `logic_do(steps:[{path, action, args}])`.
Выполнение последовательно до первой ошибки → `partial(done:[…], failed:{…}, undo_steps)`. Автооткат не делаем:
модель решает, звать ли `undo`.

`Outcome`: `ok(actual[, quantized])` · `sent` (только MIDI-события) · `unverified` (только raw-действия) · ошибка.

Ошибки (одна строка + подсказка, `isError: true`):
`not_found(candidates)` · `ambiguous(candidates)` · `stale_ref` · `blocked(modal)` · `unavailable(reason)` ·
`unsupported(reason)` · `need_select` · `invalid_args(signature)` · `invalid_value(range)` ·
`verify_failed(want, got)` · `timeout` · `partial` · `confirm_required` · `permission(ax|automation)` ·
`logic_not_running` · `unknown_logic_version`.

### 5.6 Статус возможностей и полнота
Каждая запись грамматики `(kind, property|action)` имеет статус: `planned` → `recipe` → `live-verified`.
- Рекламируется (в индексе §4.8 и `enum` схемы) **только** `live-verified`.
- `live-verified` = запись в `Tests/Live/ledger.json`: версия Logic, дата, имя live-теста, результат. Ставится
  только прогоном `LogicLiveTests`, не руками.
- Тест полноты: каждая рекламируемая запись имеет рецепт **и** свежую строку ledger для текущей мажорной версии Logic.
- Live-тесты используют якоря из `OBSERVATIONS.md`: `AXWindows` пуст, модалка = main window, `AXDescription` плагина
  обрезан (~10 символов), подменю молча «успешны», Search and Add ставит в верхний слот.

## 6. Состояние и события
- Постоянный поллер удаляется. Чтение по запросу со свежим резолвом; микрокэш TTL 250 мс.
- `Watcher` (транспорт, выделение, модалки): `AXObserver`, если Logic шлёт нотификации (⛳S2), иначе опрос 250 мс
  через AXActor. Работает только пока есть подписчик или активный `until`.
- `EventBus` (AsyncStream): `transportChanged`, `trackListChanged`, `selectionChanged`, `modalAppeared`,
  `renderFinished`. Потребители: resource subscriptions, `until`, будущий голосовой демон.
- Ресурс `logic://map/{path}` (зеркало `logic_read`) с `subscribe`. Статические ресурсы upstream удаляются.

## 7. MCP-поверхность

| Tool | Вход | Annotations |
|---|---|---|
| `logic_read` | `path="/"`, `depth`, `fields`, `until`, `timeout`, `format` | readOnly |
| `logic_set` | `assign: [{path, value}]` (упорядоченно) | idempotent, не destructive |
| `logic_do` | `path, action, args?, confirm?` или `steps:[…]` | destructive |
| `logic_midi` | `events:[…]`, `port?` | не idempotent, не destructive |

- `action` — `enum` из `live-verified` действий; `args` валидируются сервером по сигнатуре действия,
  ошибка `invalid_args` содержит точную сигнатуру.
- **Необратимые** действия (нет Logic-undo: `quit`, `close` без сохранения, удаление файлов рендера/патчей,
  `flatten` take folder) требуют `confirm: true`, иначе `confirm_required` с описанием последствий.
- `outputSchema` для `format=json`.
- Бюджеты (тест, на фикстуре «бело красный»: 5 треков, stack, take folder с ~20 дублями, цепочка 5 плагинов с таблицей
  параметров): описания всех инструментов ≤ 1500 токенов; `logic_read("/")` ≤ 350; трек со strip ≤ 200;
  `insert:K` с параметрами ≤ 250; ошибка ≤ 60. Если измерение превысит — пересматриваем формат, а не бюджет.

## 8. Домены v1
Все рецепты ниже — гипотезы до спайков; итоговый список `live-verified` определяется P2–P5.

### 8.1 Сведение
- Треки: номер из UI, стеки деревом, take как дети, `has_output`, `kind`.
- Strip (через 4.2): volume/pan (`stepTo` или OSC по итогам ⛳S6), mode, input/output/send-bus (`popupPick`, ⛳S5),
  sends level/pre-post/bypass.
- Inserts:
  - `logic_do("track:3/strip", "load_chain", {plugins:[…], mode:"replace"|"prepend"})`.
    Search and Add ставит плагин в **верхний** слот (наблюдение; ⛳S7), поэтому:
    `replace` — снять все существующие inserts (verify пусто) → вставить список в обратном порядке;
    `prepend` — вставить список в обратном порядке поверх существующих. `append` в v1 нет, если S7 не найдёт адресацию слота.
  - Частичный провал: стоп, `partial(inserted:[…], failed:{plugin, reason}, undo_steps)`, без автоотката.
  - Verify имени: `AXDescription` в strip обрезан (~10 символов), поэтому сверка по префиксу **плюс** заголовку окна
    плагина (полное имя) при неоднозначном префиксе. Окно открывается transient и закрывается.
  - `remove` (list-меню → `No Plug-in`), `bypass` (checkbox + verify), `window open/close`.
  - Одиночный `insert:K load` — только если S7 найдёт адресацию слота, иначе не рекламируется.
- Params: окно плагина → `View › Controls` → пары `"Name:"` + `Slider` с `AXValueDescription` → `stepTo` (5.2).
  Таблица шагов на плагин кэшируется на сессию.
- Патчи: `save_patch`, `load_patch`, список из `~/Music/Audio Music Apps/Patches/Audio/`.
- Master strip; `select` трека с verify.

### 8.2 Транспорт и проект
- play/stop/record/pause/locate — CoreMIDI MMC, verify по `transport.state`/`position`; без keyboard-фолбэка.
- tempo, signature, cycle, metronome, count-in — AX control bar, `setText`/`press` + verify.
- Markers: читать/создать/переименовать/перейти.
- Проект: open/new/save/save_as/close/launch/quit; `dirty`.
- Треки: create(kind), delete, rename, duplicate, color.
- undo/redo (5.4).

### 8.3 Композиция / MIDI
- Real-time — `logic_midi` через виртуальный CoreMIDI-источник.
- `write_notes`: SMF → File › Import › MIDI File (путь через `setText`, ⛳S4) на выбранный трек в позицию locate.
  Фолбэк — real-time запись через виртуальный порт.
- `region:K/notes`: экспорт региона в MIDI-файл во временную папку → парсинг SMF (⛳S4).
- Регионы и Functions-меню (quantize/transpose) — ⛳S3; при недостатке AX → `unsupported`.

### 8.4 «Уши»
- Метры: `strip/meter` — снимок; окно наблюдения через `until`.
- Баунс: `logic_do("/", "bounce", {range, stems?, format})` — transient-диалог, путь через `setText`; результат `render:K`;
  MCP progress.
- Анализ (AVFoundation + Accelerate, in-process): integrated/short-term LUFS (BS.1770-4), true peak (4×), RMS, crest,
  стерео-корреляция, 10 полос спектра, сравнение с референсом. Для `render:K` и `file:/path`.

### 8.5 Монтаж и комп («франкенштейн»)
- Позиции: `"17 3 1 1"` или `"0:01:23.450"`; относительно региона `region:3@"2.5s"`.
- `region:K`: `split(at:[…])` (MMC locate → Edit › Split at Playhead), `trim`, `move`, `copy`, `delete`, `mute`,
  `join`, `fade`, `crossfade`, `gain` — AX-выделение региона + AX-меню (⛳S3), verify по списку регионов трека.
- Take folder: `take:K select` (активный дубль целиком), `unpack`, `flatten` (confirm).
- **Комп — два разных глагола, не один:**
  - `comp(ranges:[{take, from, to}])` — нативный quick-swipe комп внутри take folder. Существует, только если ⛳S3
    подтвердит AX-доступ к диапазонам. Take folder остаётся take folder.
  - `assemble(ranges:[…], crossfade?)` — фолбэк-семантика с другим результатом: **дублирует** трек, на копии
    unpack → split по границам → mute лишнего → кроссфейды. Оригинальная take folder не трогается. Отдельный глагол,
    чтобы модель и пользователь знали, что результат — не take folder.
- «Резать по слуху»: `region:K/analysis`, `take:K/analysis` — паузы, онсеты, громкость по фразам, шум (движок §8.4).

## 9. Платформа и дистрибуция
- `LocaleTable`: все AX-строки в одном месте, семантические ключи; v1 — `en`.
- Отпечаток Logic при старте: версия бандла (установлено 11.2) + наличие ключевых AX-якорей; неизвестная версия →
  предупреждение в `system` и в первой ошибке.
- Стабильный signing identity, чтобы TCC-гранты переживали пересборку; `Scripts/install.sh` — сборка, подпись,
  установка в `~/.local/bin`, инструкции по разрешениям.
- Логи только в stderr/os_log.

## 10. Спайки (P0) — до кода ядра

| # | Вопрос | Проверка | Что решает |
|---|---|---|---|
| S1 | Какие окна Logic меняют frontmost/Space при AX-управлении с Logic на другом Space (Search and Add, Controls, Save Patch, Import MIDI, Bounce, окно плагина) | живой прогон + снимки FocusGuard до/после | `visibility` каждого рецепта; нужен ли `restores` |
| S2 | Шлёт ли Logic AXObserver-нотификации (transport, selection, windows) | подписка + лог | Watcher: observer vs опрос |
| S3 | AX регионов арранжировки, take folder (выбор дубля, диапазоны комп-свайпа), Piano Roll, Functions-меню | axdump «бело красного» + прогон | 8.3, 8.5; есть ли `comp` |
| S4 | Import MIDI / Export region: open/save-panel через `setText` пути | живой прогон | `write_notes`, `notes` |
| S5 | Вложенные popup-меню I/O (Bus › Bus 2) | живой прогон | input/output/send |
| S6 | Шаги и скорость `stepTo` на фейдере/пане strip и параметрах; сравнение с OSC (латентность, точность, требования к настройке) | замер | дедлайны; судьба OSC |
| S7 | Search and Add: слот вставки при выделенном/пустом слоте; адресация слота; перестановка | живой прогон | `insert:K load`, `append` |
| S8 | Невидимый verified select трека (AXSelected на строке, AXPress на имени, выделение через заголовок); слайдеры volume/pan в заголовке трека | живой прогон | 4.2: strip любого трека или только selected |

Результаты — `docs/superpowers/specs/spikes-2026-09.md`, фикстуры — `Tests/Fixtures/`. По итогам P0 спек обновляется
(снимаются ⛳, статус → APPROVED), и только после этого пишутся планы P2+.

## 11. Фазы (строго последовательно, с зависимостями)

- **P0 Спайки** — §10, `logic-ax-dump`, фикстура «бело красный».
- **P1 Фундамент** — split `LogicKit`/`LogicMCP`, `AXNode` + фикстуры, `LocaleTable`, Path/Grammar/Resolver/Handles,
  AXActor/Primitives/Verify, ArgValidator, TextRenderer, ledger + тест полноты, 4 инструмента.
  Вертикальный срез до `live-verified`: чтение `/`, `track:N`, `strip` выделенного; `set mute/solo`; `select` (по S8);
  `undo/redo`; MMC play/stop/locate с verify.
  Удаляются: старые диспетчеры, `ChannelRouter`, `StatePoller`, `CGEventChannel`. **OSC остаётся** опциональным каналом до решения по S6.
- **P2 Сведение** — §8.1. Зависит от P1 (select, stepTo).
- **P3 Транспорт + проект + события** — §8.2, Watcher/EventBus/`until`, subscriptions. Зависит от P1.
- **P4 Композиция + монтаж** — §8.3, §8.5. Зависит от P3 (locate, `until`).
- **P5 Уши** — §8.4, analysis-узлы §8.5. Зависит от P3 (`until` для метров) и P4 (регионы).
- **P6 Hardening** — отпечаток версии, подпись/установка, бюджеты в CI, README, полный live-suite.

## 12. Критерии готовности v1
1. Ни одна мутация не возвращает `ok` без readback. `sent` — только MIDI-события; `unverified` — только raw-действия
   (выключены по умолчанию).
2. Live-тест для **каждого** рецепта проверяет FocusGuard-инвариант своего класса `visibility`: `never` — нет новых
   окон и смены frontmost/Space; `transient` — после операции набор окон и frontmost/Space совпадают с исходными;
   `restores` — то же после восстановления.
3. Все пункты `IMPROVEMENTS.md` P0–P2 закрыты как `live-verified` или явно `unsupported(reason)`.
4. Бюджеты §7 проходят на фикстуре «бело красный».
5. Тест полноты §5.6 зелёный; в индексе нет ни одной записи без свежей строки ledger.
6. Офлайн-тесты покрывают парсеры, резолвер, хэндлы (включая сценарии delete/unpack/одинаковые имена → `stale_ref`),
   рендерер, валидацию аргументов, планирование рецептов.
7. Сценарий сведения «бело красный» через MCP: собрать цепочку из 5 плагинов (`load_chain replace`) с параметрами,
   выставить уровни/посылы, сохранить патч, забаунсить, получить LUFS/спектр — при выполнении критерия 2
   (рабочие окна мелькают и закрываются; Space и frontmost пользователя не меняются).
8. Комп-сценарий на take folder «бело красного»: по итогам S3 — либо `comp` (нативно), либо `assemble` (на копии
   трека) собирает вокал из кусков ≥3 дублей по точкам из анализа пауз, с кроссфейдами; оригинальная take folder
   не изменена.

## 13. Changelog v2 (ревью 2026-09-21)
| # | Замечание | Где исправлено |
|---|---|---|
| 1 | «Ни одного окна» противоречит рецептам | §1 определение, §5.4 `visibility`, §12.2, §12.7 |
| 2 | Комп-DoD до спайков; фолбэк ≠ комп | §8.5 `comp` vs `assemble`, §12.8 |
| 3 | strip любого трека при inspector-only AX | §4.2, S8 |
| 4 | stepTo nearest vs verify_failed | §5.2 единый контракт |
| 5 | Нетипизированный `{path, action, args}` | §7 enum, `invalid_args(signature)`, упорядоченный `assign`, `confirm` |
| 6 | Хэндл-хайджек по имени | §4.4 |
| 7 | Архитектура до спайков; OSC режется в P1 | статус DRAFT, ⛳-маркеры, §10 S6, §11 |
| 8 | Фикстуры зеленят рецепты вслепую | §3 граница фикстур, §5.6 ledger |
| 9 | `load_chain` без семантики, обрезанные имена | §8.1 |
| 10 | Нет undo, чужие окна/модалки | §5.4, §8.2 |
| + | Сериализация только мутаций | §5.1 AXActor для всех AX-вызовов |
| + | `until`/raw превращают MCP в AX-REPL | §4.6 мини-язык, §4.7 raw read-only по умолчанию |
| + | Бюджеты на игрушечном проекте | §7 фикстура «бело красный» |
| + | Фазы «можно переставлять» | §11 зависимости |
| + | `unverified` отсутствовал в Outcome | §5.5 |
