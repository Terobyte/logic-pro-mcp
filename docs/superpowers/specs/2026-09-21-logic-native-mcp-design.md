# Logic-native MCP: дизайн

Дата: 2026-09-21 · Версия: v4 (после двух ревью и самоаудита) · **Статус: DRAFT до завершения P0.**
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
  4. не зависим от раскладки клавиатуры (текст только через `AXValue`);
  5. **выделение трека пользователя возвращается** после операции (в Logic выделение = маршрутизация: MIDI-вход
     клавиатуры и Auto Track Enable/запись следуют за ним);
  6. **сохраняемые режимы вида возвращаются**: `View › Controls`/Editor окна плагина, позиция/размер окон, прокрутка
     и зум арранжа, показ инспектора. Окна, которых не было, закрыты; то, что Logic запоминает, — как было.
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
│ Engine:   AXExecutor(все AX)   · Recipes · Primitives · Verify │
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
│  ├─ track:M             дети стека (канонический путь сабтрека — `track:M`, см. 4.3)
│  ├─ take:7             take-лейны (№ дубля)              └─ analysis
│  └─ region@"17 1 1 1"  name, start, end, length, loop, muted, gain, fades   ├─ notes  └─ analysis
├─ master                 strip
├─ marker:"Chorus"        name, position
├─ patches · render:r3 · ui (окна, модалка, undo_title) · system (health, permissions, версия, отпечаток)
└─ raw                    AX-люк (4.7)
```

### 4.2 Strip и выделение
AX отдаёт полный channel strip только для **выделенного** трека (Left inspector channel strip). Поэтому:
- Чтение `track:N/strip`: из inspector'а, если N выделен; из Mixer-панели, если пользователь её сам открыл; иначе
  узел `?unavailable(need_select)` с кратким срезом из заголовка трека (volume/pan, если там есть слайдеры ⛳S8).
- Мутации `track:N/strip/**` и `load_chain`: рецепт выполняет **verified select** N, работает с inspector'ом и
  **возвращает исходное выделение** (verified). Такие рецепты — класс `restores` (§5.4). Если вернуть не удалось —
  ответ содержит `⚠ selection left on 3 (was 2)`; молчаливой смены выделения нет.
- Если невидимый verified select не найден (⛳S8) — мутации strip доступны только для `track:selected`, остальные
  возвращают `unsupported(need_select: select track 3 in Logic)`.
- Мы не открываем Mixer-панель сами (это изменение вида пользователя).

### 4.3 Адреса
Грамматика: `path := segment ("/" segment)*`, `segment := kind [":" selector | "@" position]`. `insert:K`/`send:K` — номер слота, как в UI Logic (слоты позиционны в самом Logic, это не AX-индекс).
Селекторы: `3` (**номер из UI Logic**, 1-based, парсится из `Track 3 “…”`), `"Rose Vocal"` (имя; коллизия →
`ambiguous` с кандидатами), `selected`, `#t4f2` (хэндл), для `param` — имя как в Controls-виде.
Корневые сокращения: `track:3` ≡ `/track:3`.
**Каноническая форма.** UI-номер трека глобален, поэтому сабтрек стека адресуется и как `track:5`, и как
`track:3/track:5`; оба входа принимаются, но вывод, хэндлы и ответы мутаций всегда используют каноническую `track:5`
(родитель стека — свойство `stack=track:3`).

Селекторы остальных коллекций (позиционных индексов нет нигде):
- `take:7` — номер дубля, как Logic подписывает его в take folder (`Take 7`); либо имя дубля.
- `region@"17 1 1 1"` — начало региона на своём треке/лейне (уникально на лейне); либо `region:"Audio 1#07"` — имя
  (коллизия → `ambiguous`); либо хэндл.
- `marker:"Chorus"` — имя (коллизия → `ambiguous`); либо `marker@"33 1 1 1"`.
- `render:r3` — ID, который выдаёт сам сервер при баунсе (стабилен в пределах сессии).

### 4.4 Хэндлы
Хэндл = короткий хэш отпечатка `(kind, UI-номер, имя, путь родителя, имена соседей prev/next)`.
Разрешение:
1. точное совпадение отпечатка → ок;
2. иначе поиск кандидатов с тем же `kind`, родителем **и** соседями; ровно один → ок, вывод помечает `moved 3→4`;
3. всё остальное (0 или >1 кандидатов, совпадение только по имени) → `stale_ref`.

После любой структурной мутации (create/delete/duplicate/unpack/flatten/undo/redo, смена проекта) таблица хэндлов
сбрасывается; старые хэндлы → `stale_ref`. Хэндлы — защита от промаха, а не гарантия; при сомнении — ошибка.

Регионы: отпечаток = (хэндл трека/лейна, start, length, name). Мутация региона (`split`, `trim`, `move`, `join`)
делает его старый хэндл и старый `region@start` недействительными (`stale_ref`), а ответ мутации **возвращает новые
адреса** получившихся кусков: `✓ split region@"17 1 1 1" → #r9a1 @17 1 1 1 (2 bars), #r9a2 @19 1 1 1 (6 bars)`.
Многошаговые рецепты (`assemble`) адресуют исходные диапазоны `(take, from, to)`, а не `region` после мутаций.

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
- **Неполная видимость AX (⛳S12).** Если AX отдаёт только видимые на экране треки/регионы, список честно говорит об
  этом: `tracks:40 (AX-visible 18)`; невидимые узлы — `?unavailable(offscreen)`. Прокрутка арранжа ради чтения —
  только как `restores`-рецепт с возвратом прокрутки (§1 п.6), и только если S12 покажет, что это возможно невидимо
  для пользователя; иначе — `unavailable(offscreen)`. Число треков берётся из источника, не зависящего от прокрутки
  (⛳S12), иначе — помечается `≥18`.
- Take-лейны свёрнуты: `takes:20 (active 7)`; раскрываются только `depth≥2` или прямым адресом.
- **Свёртка больших списков.** Список детей показывает максимум 12 строк: сначала selected/armed/soloed/с
  предупреждениями, затем по порядку; строка-итог `tracks:40 (showing 12; page:"13-24" or fields:…)`.
  Параметр `page` листает, `fields` проецирует (напр. `fields:"name,mute"` → одна короткая строка на трек).
- `json` — тот же контент структурой, с `outputSchema`.

**`until` — мини-язык условий** (не произвольные выражения): одно условие `field op value` над узлом `path`,
`op ∈ {=, !=, <, <=, >, >=}`. Парсинг: `field` — идентификатор до первого оператора; оператор — самый длинный
совпавший (`>=` раньше `>`); `value` — весь остаток строки, обрезанный по краям, парсится по `unit` поля (пробелы
внутри допустимы). Примеры: `until:"state=stopped"`, `until:"position>=17 1 1 1"`.
`timeout` обязателен: дефолт 10 s, максимум 30 s; до 120 s — только если клиент передал progress token (сервер шлёт
progress notifications раз в 5 s). По таймауту — `timeout` с последним прочитанным значением.

Микрокэш (§6) не применяется к живым узлам (`meter`, `transport.position`) — они читаются всегда заново.

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
**Все** AX-обращения идут через `AXExecutor` — **выделенный поток с собственным CFRunLoop** (на нём же живут
`AXObserver`-источники, ⛳S2). Не голый Swift `actor`: AX-вызовы синхронные и могут блокировать до таймаута, а Swift
actors реентерабельны на `await` — чужое чтение вклинилось бы в транзакцию во время ожидания verify.
- Над потоком — **явная FIFO-очередь работ** (не реентерабельная): работа — либо транзакция мутации (держит очередь
  целиком, включая ожидания verify внутри неё), либо короткий слот (одно чтение/опрос/итерация `until`).
- Ожидания **вне** транзакций (`until`, Watcher) живут снаружи: берут короткие слоты, между ними очередь свободна.
- Каждый AX-элемент получает `AXUIElementSetMessagingTimeout` (дефолт 1 s, рецепт может поднять). Таймаут вызова →
  проверка `busy`: главный поток Logic занят (offline-баунс, загрузка плагина/проекта) → ошибка
  `busy(bouncing|loading|unknown)` сразу для всех ждущих работ, **без** зависания очереди; circuit breaker повторяет
  пробу раз в 1 s. Готовность render определяется по файловой системе, не по AX.
- Чтения батчатся `AXUIElementCopyMultipleAttributeValues` (один IPC на узел, а не на атрибут).
MIDI (CoreMIDI) и анализ аудио — вне `AXExecutor`.

```
resolve(path) → guard → act(primitives) → verify(readback, deadline) → Outcome
```

- **resolve** — заново на каждую операцию; кэш карты — только подсказка.
- **guard** — Logic запущен, не `busy`, разрешения, отпечаток версии; модалка (5.4); состояние транспорта (5.4
  «Транспорт пользователя»); для destructive — чтение `dirty` и `undo_title`.
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
Значения — гипотезы до ⛳S1. Любой рецепт, меняющий выделение трека, — не ниже `restores` (§4.2).

Logic обычно живёт на **другом Space**, `AXWindows` у него бывает пустым, а модалка становится `AXMainWindow`.
Поэтому снимки строятся из источников, которые в этой среде не пустые:

`WindowSnapshot` = {
  - окна Logic: `CGWindowListCopyWindowInfo(.optionAll)` (включая off-screen и другие Space), фильтр по PID Logic,
    ключ `kCGWindowNumber` + `kCGWindowName` + layer;
  - `AXMainWindow` и `AXFocusedWindow` Logic: title, role, subrole;
  - пользователь: frontmost-приложение и набор on-screen окон (`.optionOnScreenOnly` — отражает Space пользователя)
}.

- `FocusGuard`: снимок до/после; сторона пользователя (frontmost, on-screen) обязана совпасть, кроме объявленных
  побочных эффектов.
- `WindowTransaction` трекает окна **по `kCGWindowNumber`**: закрывает только номера, появившиеся после его шагов;
  чужие окна не трогает никогда. **Teardown одинаков на success и на abort/error.**
- `WindowTransaction` также снимает и восстанавливает **сохраняемые режимы вида**, которые трогает рецепт (§1 п.6):
  режим Controls/Editor окна плагина, frame окна, прокрутку/зум арранжа, показ инспектора. Невосстановимый режим →
  рецепт не может быть `transient`/`restores` и помечается в ответе `⚠ view changed: …`.
- Live-инвариант после **любого** исхода (включая ошибку): `AXMainWindow` — снова главное окно проекта, не модалка и
  не окно плагина; набор окон Logic = исходный.

Сосуществование с пользователем (он может параллельно кликать в Logic):
- Модалка, которой не было в плане рецепта (в т.ч. пользовательская), → `blocked(modal:"…")`. Мы её не закрываем.
- **Readback контекста перед каждым мутирующим шагом** многошагового рецепта: выделенный трек всё ещё N, наше окно
  всё ещё открыто и main. Иначе → `blocked(context_changed: selection 3→1)` + teardown; уже сделанное перечисляется в `partial`.
- Рецепт записывает ожидаемые заголовки undo (`Undo Insert Plug-in`, …). ⛳S9: Cocoa обновляет заголовок и enabled
  пунктов меню в `validateMenuItem` при **открытии** меню; если AX без открытия отдаёт устаревший заголовок, чтение
  `undo_title` идёт через открытие-и-закрытие меню Edit (transient) либо undo-гарантии снимаются (`undo unsafe: unknown`). `undo_steps` в ответе и `undo` по нашей
  инициативе валидны, только пока верх undo-стека Logic совпадает с нашими заголовками; иначе ответ говорит
  `undo unsafe: top is "…"` и модель не откатывает слепо.
- Destructive-операции на `dirty`-проекте выполняются, но ответ содержит `⚠ project unsaved`.
- `logic_do("/", "undo"|"redo", {steps?})` через Edit-меню по AX, verify по `undo_title`.

**Транспорт пользователя** (глобальное правило guard):
- идёт **запись** → все мутации, кроме `transport stop`, → `blocked(recording)`;
- идёт **воспроизведение** → мутации, которым нужен locate или которые двигают плейхед (split, write_notes, locate),
  → `blocked(playing)`; mix-мутации (уровни, параметры, байпас) разрешены — это нормальная работа на лету.

### 5.5 Батчи и ошибки
`logic_set(assign:[{path, value}, …])` — **упорядоченный массив**; `logic_do(steps:[{path, action, args}])`.
Выполнение последовательно до первой ошибки → `partial(done:[…], failed:{…}, undo_steps)`. Автооткат не делаем:
модель решает, звать ли `undo`.

`Outcome`: `ok(actual[, quantized])` · `sent` (только MIDI-события) · `unverified` (только raw-действия) · ошибка.

Ошибки (одна строка + подсказка, `isError: true`):
`not_found(candidates)` · `ambiguous(candidates)` · `stale_ref` · `blocked(modal|context_changed|recording|playing)` ·
`busy(reason)` · `unavailable(reason)` ·
`unsupported(reason)` · `need_select` · `invalid_args(signature)` · `invalid_value(range)` ·
`verify_failed(want, got)` · `timeout` · `partial` · `confirm_required` · `permission(ax)` ·
`logic_not_running` · `anchor_missing(anchor)` · `need_mmc_input`.

Размер ошибки: первая строка ≤ 60 токенов; дальше при необходимости до 5 кандидатов (`ambiguous`, `not_found`) или
одна сигнатура (`invalid_args`), итого ≤ 150 токенов. Неизвестная версия Logic — **не ошибка**, а предупреждение в
`system` и в первом ответе сессии; ошибка возникает только когда конкретный нужный якорь не найден (`anchor_missing`).

### 5.6 Статус возможностей и полнота
Каждая запись грамматики `(kind, property|action)` имеет статус: `planned` → `recipe` → `live-verified`.
- Рекламируется (в индексе §4.8 и `enum` схемы) **только** `live-verified`.
- `live-verified` = запись в `Tests/Live/ledger.json`: версия Logic, дата, имя live-теста, результат. Ставится
  только прогоном `LogicLiveTests`, не руками.
- Тест полноты: каждая рекламируемая запись имеет рецепт **и** строку ledger для текущей **минорной** версии Logic
  (11.2 ≠ 11.3). При старте на новой минорной версии сервер проверяет все AX-якоря; записи, чьи якоря не найдены, в
  индекс не попадают до нового прогона live-suite.
- **Live-тесты никогда не трогают проекты пользователя.** Они открывают копию проекта из `Tests/Fixtures/projects/`
  во временной папке и закрывают её без сохранения. Перед стартом live-suite проверяет, что в Logic нет несохранённого
  проекта пользователя (`dirty`), иначе отказывается запускаться.
- Live-тесты используют якоря из `OBSERVATIONS.md`: `AXWindows` пуст, модалка = main window, `AXDescription` плагина
  обрезан (~10 символов), подменю молча «успешны», Search and Add ставит в верхний слот.

## 6. Состояние и события
- Постоянный поллер удаляется. Чтение по запросу со свежим резолвом; микрокэш TTL 250 мс.
- `Watcher` (транспорт, выделение, модалки): `AXObserver`, если Logic шлёт нотификации (⛳S2), иначе опрос 250 мс
  через AXExecutor. Работает только пока есть подписчик или активный `until`.
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
- Бюджеты измеряются тестом на **двух** фикстурах: «бело красный» (5 треков, stack, take folder ~20 дублей, цепочка
  5 плагинов с параметрами) и синтетическая «big» (40 треков, 3 стека, 2 take folder, 8 aux, 20 маркеров):
  описания всех инструментов ≤ 1500 токенов; `logic_read("/")` ≤ 350 на обеих (за счёт свёртки §4.6);
  трек со strip ≤ 200; `insert:K` с параметрами ≤ 250; ошибка ≤ 150 (§5.5). Если измерение превысит —
  пересматриваем формат, а не бюджет.
- Фикстура «big» — **записанная** `logic-ax-dump` с реального проекта (40+ треков, регионы за пределами экрана),
  не синтетическая: синтетика скрывает неполноту AX (⛳S12).
- **Бюджеты времени и AX-вызовов** (live, на «big»; цифры — стартовые, уточняются по S12):
  `logic_read("/")` ≤ 400 мс и ≤ 300 AX-сообщений; `logic_read("track:N")` ≤ 150 мс; `set mute` ≤ 300 мс;
  `set` параметра (≤ 10 шагов) ≤ 1 s; `load_chain` 5 плагинов ≤ 15 s. Замеряются live-тестом с числом AX-вызовов
  из счётчика `AXExecutor`; регресс > 30% — красный тест.

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
  Таблица шагов на плагин кэшируется на сессию. Режим вида окна возвращается (§5.4).
- **Точность параметров — потолок качества сведения.** Наблюдаемые шаги слайдеров грубые (Threshold/Make Up 5 dB,
  Wet 10%). `stepTo` — только базовый путь; ⛳S6 ищет точный: числовой ввод (`setText` в поле значения Controls/Editor),
  Controller Assignments с нашего CoreMIDI-источника (14-bit), OSC-адресация. Для каждого параметра карта отдаёт
  `step` честно; если точного пути нет, это фиксируется в спеке после P0 как ограничение v1, а не прячется за `quantized`.
- Патчи: `save_patch`, `load_patch`, список из `~/Music/Audio Music Apps/Patches/Audio/`.
- Master strip; `select` трека с verify.

### 8.2 Транспорт и проект
- play/stop/record/pause: **основной путь — AX-кнопки control bar** (`set` по состоянию, verify по `transport.state`),
  ⛳S11. **MMC — опциональный быстрый путь**: Logic слушает MMC только при включённом
  `Project Settings › Synchronization › MIDI › Listen to MMC Input` и входе с `LogicProMCP` источника. Handshake —
  при первом транспортном вызове сессии (не при старте: проверка play→stop озвучит проект): отправить команду →
  readback. Нет реакции → MMC помечается недоступным до конца сессии, `system` показывает
  `need_mmc_input (enable Listen to MMC Input)`, транспорт идёт через AX. `install.sh` печатает этот шаг.
- locate: AX-поле позиции в control bar (`setText` + verify) ⛳S11; MMC locate — только после успешного handshake.
  Keyboard-фолбэка нет.
- tempo, signature, cycle, metronome, count-in — AX control bar, `setText`/`press` + verify.
- Markers: читать/создать/переименовать/перейти.
- Проект: open/new/save/save_as/close/launch/quit; `dirty`.
- Треки: create(kind), delete, rename, duplicate, color.
- undo/redo (5.4).

### 8.3 Композиция / MIDI
- Real-time — `logic_midi` через виртуальный CoreMIDI-источник.
- `write_notes(track, at, notes)`: SMF во временный файл → verified select трека → locate `at` →
  File › Import › MIDI File (transient open-panel, путь через `setText`, ⛳S4) → verify: на треке появился регион
  с началом `at` → ответ с его адресом; `undo_steps:1`. ⛳S4 проверяет побочные эффекты импорта: создание нового
  трека вместо выделенного, диалог импорта темпа/сигнатуры (ответ всегда «нет»; темп проекта verify до/после). Real-time запись как фолбэк **исключена из v1**
  (arm + record + звук — противоречит §1). Если S4 красный — `write_notes` = `unsupported`.
- `region@…/notes`: экспорт региона в MIDI-файл во временную папку → парсинг SMF (⛳S4).
- Регионы и Functions-меню (quantize/transpose) — ⛳S3; при недостатке AX → `unsupported`.

### 8.4 «Уши»
- Метры: `strip/meter` — снимок; окно наблюдения через `until`.
- Баунс: `logic_do("/", "bounce", {range, stems?, format})` — transient-диалог, путь через `setText`; результат `render:rN`;
  MCP progress.
- Анализ (AVFoundation + Accelerate, in-process): integrated/short-term LUFS (BS.1770-4), true peak (4×), RMS, crest,
  стерео-корреляция, 10 полос спектра, сравнение с референсом. Для `render:rN` и `file:/path`.

### 8.5 Монтаж и комп («франкенштейн»)
- Позиции: `"17 3 1 1"` или `"0:01:23.450"`; относительно региона `region:3@"2.5s"`.
- `region@…`: `split(at:[…])` (locate по §8.2 → Edit › Split at Playhead), `trim`, `move`, `copy`, `delete`, `mute`,
  `join`, `fade`, `crossfade`, `gain` — AX-выделение региона + AX-меню (⛳S3), verify по списку регионов трека.
- Take folder: `take:N select` (активный дубль целиком), `unpack`, `flatten` (confirm).
- **Комп — два разных глагола, не один:**
  - `comp(ranges:[{take, from, to}])` — нативный quick-swipe комп внутри take folder. Существует, только если ⛳S3
    подтвердит AX-доступ к диапазонам. Take folder остаётся take folder.
  - `assemble(ranges:[…], crossfade?)` — фолбэк-семантика с другим результатом: **дублирует** трек, на копии
    unpack → split по границам → mute лишнего → кроссфейды. Оригинальная take folder не трогается. Отдельный глагол,
    чтобы модель и пользователь знали, что результат — не take folder.
- «Резать по слуху»: `region…/analysis`, `take:N/analysis` — паузы, онсеты, громкость по фразам, шум (движок §8.4).
  **Источник аудио** (⛳S10), в порядке предпочтения:
  1. файл региона прямо из пакета проекта (`<project>.logicx/Media/Audio Files/…`) + смещение и длина региона
     в файле — без баунса и без окон; узел `region…/file`;
  2. если смещение не читается: для take folder — на **копии** трека (как в `assemble`) unpack →
     один `Export All Tracks as Audio Files` (один transient-диалог на все дубли) → анализ файлов;
  3. иначе анализ дублей — `unsupported`; `assemble` работает по диапазонам, которые задаёт модель,
     без «резать по слуху».

## 9. Платформа и дистрибуция
- `LocaleTable`: все AX-строки в одном месте, семантические ключи; v1 — `en`.
- Отпечаток Logic при старте: версия бандла (установлено 11.2) + наличие ключевых AX-якорей; неизвестная версия →
  предупреждение (§5.5), не ошибка.
- Разрешения: **только Accessibility**. Жизненный цикл без AppleScript: launch/open — `NSWorkspace.open(_:withApplicationAt:)`,
  quit — `NSRunningApplication.terminate()`. `PermissionChecker.allGranted` перестаёт требовать Automation.
  Automation возвращается узко (Apple Event только к меню-бару через System Events), только если ⛳S9 даст исход (b).
- `install.sh`: сборка, подпись, Accessibility, и (опционально) шаг включения `Listen to MMC Input`.
- Стабильный signing identity, чтобы TCC-гранты переживали пересборку; `Scripts/install.sh` — сборка, подпись,
  установка в `~/.local/bin`, инструкции по разрешениям.
- Логи только в stderr/os_log.

## 10. Спайки (P0) — до кода ядра

| # | Вопрос | Проверка | Что решает |
|---|---|---|---|
| S1 | Какие окна Logic меняют frontmost/Space при AX-управлении с Logic на другом Space (Search and Add, Controls, Save Patch, Import MIDI, Bounce, окно плагина). **Плюс:** видны ли эти окна в `CGWindowList(.optionAll)` по PID Logic с номерами; как меняются `AXMainWindow`/`AXFocusedWindow`; закрываются ли по AX без фокуса | живой прогон + `WindowSnapshot` до/после | `visibility` рецептов; реализуемость `WindowTransaction` по `kCGWindowNumber` |
| S9 | Работает ли `menu(path)` (AXPress по меню-бару) при Logic не-frontmost и на другом Space. **Плюс:** актуальны ли заголовок и enabled пунктов (`Undo …`) без открытия меню (Cocoa валидирует при открытии) | живой прогон на Mix › Search and Add, Edit › Undo, File › Import; сравнить `undo_title` до/после открытия меню | (a) AX достаточно → Automation не нужна; (b) нужен System Events → узкий Apple Event только для меню; (c) только с frontmost → рецепты `restores`, §12.7 пересматривается |
| S10 | Источник аудио регионов/дублей: путь файла в пакете проекта, смещение и длина региона в файле (AX региона, Region Inspector, `Project Audio`) | axdump + сравнение с `Media/Audio Files` | 8.5 «резать по слуху»: вариант 1/2/3 |
| S11 | Транспорт через AX control bar: кнопки Play/Stop/Record как тогглы с читаемым состоянием; поле позиции `setText`; и реакция на MMC при включённом `Listen to MMC Input` | живой прогон | основной путь транспорта и locate |
| S2 | Шлёт ли Logic AXObserver-нотификации (transport, selection, windows) | подписка + лог | Watcher: observer vs опрос |
| S3 | AX регионов арранжировки, take folder (выбор дубля, диапазоны комп-свайпа), Piano Roll, Functions-меню. **Ключевой вопрос:** отдаёт ли AX начало/длину региона **значением** (а не только frame в пикселях); если только frame — адресация `region@position` не реализуема, монтаж идёт через Region Inspector/Event List или `unsupported` | axdump «бело красного» + прогон | 8.3, 8.5; есть ли `comp`; реализуемость §4.3 для регионов |
| S4 | Import MIDI / Export region: open/save-panel через `setText` пути | живой прогон | `write_notes`, `notes` |
| S5 | Вложенные popup-меню I/O (Bus › Bus 2) | живой прогон | input/output/send |
| S6 | Шаги и скорость `stepTo` на фейдере/пане strip и параметрах; **поиск точного пути** для параметров: числовой ввод в поле значения, Controller Assignments (CoreMIDI 14-bit), OSC; латентность, точность, требования к настройке | замер | дедлайны; точность сведения; судьба OSC |
| S7 | Search and Add: слот вставки при выделенном/пустом слоте; адресация слота; перестановка | живой прогон | `insert:K load`, `append` |
| S8 | Невидимый verified select трека (AXSelected на строке, AXPress на имени, выделение через заголовок); слайдеры volume/pan в заголовке трека. **Плюс:** возврат выделения; ставит ли select трек на запись (Auto Track Enable) и снимается ли это при возврате | живой прогон | 4.2: strip любого трека или только selected; класс `restores` |
| S12 | Полнота и цена AX: есть ли в AX треки/регионы **вне экрана** (40+ треков, регионы за краем арранжа); источник числа треков, не зависящий от прокрутки; прокрутка арранжа и её точный возврат; стоимость (мс, число сообщений) чтения `/`, трека, strip; `CopyMultipleAttributeValues`; поведение AX при playback и offline-баунсе (блокировки, таймауты) | запись «big» `logic-ax-dump` + замеры | §4.6 видимость, §5.1 таймауты/`busy`, §7 бюджеты времени |

Результаты — `docs/superpowers/specs/spikes-2026-09.md`, фикстуры — `Tests/Fixtures/`. По итогам P0 спек обновляется
(снимаются ⛳, статус → APPROVED), и только после этого пишутся планы P2+.

## 11. Фазы (строго последовательно, с зависимостями)

- **P0 Спайки** — §10 (порядок: S12 и S3 первыми — их красный исход меняет объём v1 сильнее всего; затем S6, S8,
  S9, S1, остальные), `logic-ax-dump`, фикстуры «бело красный» и записанная «big», копии проектов для live-тестов в
  `Tests/Fixtures/projects/`.
- **P1 Фундамент** — split `LogicKit`/`LogicMCP`, `AXNode` + фикстуры, `LocaleTable`, Path/Grammar/Resolver/Handles,
  AXExecutor (поток + очередь + таймауты + `busy`)/Primitives/Verify, ArgValidator, TextRenderer, ledger + тест полноты, 4 инструмента.
  Вертикальный срез до `live-verified`: чтение `/`, `track:N`, `strip` выделенного; `set mute/solo`; `select` (по S8);
  `undo/redo`; play/stop/locate по итогам S11 (AX control bar; MMC — только после handshake).
  Удаляются: старые диспетчеры, `ChannelRouter`, `StatePoller`, `CGEventChannel`, `AppleScriptChannel`
  (если S9 ≠ b — иначе остаётся только узкий menu-bar Apple Event). **OSC остаётся** опциональным каналом до решения по S6.
- **P2 Сведение** — §8.1. Зависит от P1 (select, stepTo).
- **P3 Транспорт + проект + события** — §8.2, Watcher/EventBus/`until`, subscriptions. Зависит от P1.
- **P4 Композиция + монтаж** — §8.3, §8.5. Зависит от P3 (locate, `until`).
- **P5 Уши** — §8.4, analysis-узлы §8.5. Зависит от P3 (`until` для метров) и P4 (регионы).
- **P6 Hardening** — отпечаток версии, подпись/установка, бюджеты в CI, README, полный live-suite.

## 12. Критерии готовности v1
1. Ни одна мутация не возвращает `ok` без readback. `sent` — только MIDI-события; `unverified` — только raw-действия
   (выключены по умолчанию).
2. Live-тест для **каждого** рецепта проверяет инвариант своего класса `visibility` по `WindowSnapshot` (§5.4):
   `never` — нет новых окон Logic (по `kCGWindowNumber`, включая off-screen) и смены frontmost/Space пользователя;
   `transient` — после операции набор окон Logic, `AXMainWindow` и сторона пользователя совпадают с исходными;
   `restores` — то же после восстановления. Инвариант проверяется **и на пути ошибки** (live-тест с принудительным
   abort посередине рецепта).
3. Все пункты `IMPROVEMENTS.md` P0–P2 закрыты как `live-verified` или явно `unsupported(reason)`.
4. Бюджеты §7 проходят на **обеих** фикстурах («бело красный» и «big» на 40 треков).
5. Тест полноты §5.6 зелёный; в индексе нет ни одной записи без свежей строки ledger.
6. Офлайн-тесты покрывают парсеры, резолвер, хэндлы (включая сценарии delete/unpack/одинаковые имена → `stale_ref`),
   рендерер, валидацию аргументов, планирование рецептов.
7. Сценарий сведения «бело красный» через MCP: собрать цепочку из 5 плагинов (`load_chain replace`) с параметрами,
   выставить уровни/посылы, сохранить патч, забаунсить, получить LUFS/спектр — при выполнении критерия 2
   (рабочие окна мелькают и закрываются; Space и frontmost пользователя не меняются).
8. Комп-сценарий на take folder «бело красного»: по итогам S3 — либо `comp` (нативно), либо `assemble` (на копии
   трека) собирает вокал из кусков ≥3 дублей с кроссфейдами; оригинальная take folder не изменена.
   Точки склейки: из анализа пауз, если S10 дал вариант 1 или 2; иначе — заданные моделью диапазоны, и критерий
   считается выполненным без «резать по слуху» (это фиксируется в спеке после P0, а не молча).
9. Офлайн-тесты адресов монтажа: после `split` старый `region@start`/хэндл → `stale_ref`, а не соседний кусок;
   одинаковые имена регионов → `ambiguous`.
10. Каждый рецепт, трогающий выделение или режимы вида, в live-тесте проверяет их возврат (§1 п.5–6); ни один
    рецепт не оставляет трек на записи, если он не был на записи до операции.
11. Live-suite работает только на копиях проектов (§5.6); проекты пользователя не открываются и не меняются.
12. Бюджеты времени и AX-вызовов §7 проходят на «big»; `busy` вместо зависания проверен live во время offline-баунса.
13. Глобальный guard транспорта: во время записи любая мутация, кроме `stop`, → `blocked(recording)` (live-тест).

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

## 14. Changelog v3 (второе ревью 2026-09-21)
| Замечание | Где исправлено |
|---|---|
| FocusGuard/WindowTransaction слепы при Logic на другом Space | §5.4 `WindowSnapshot` (CGWindowList `.optionAll` по PID, `kCGWindowNumber`, AXMain/FocusedWindow), teardown на abort, S1, §12.2 |
| Вставка плагина держалась на System Events | S9; §9 разрешения только AX, lifecycle через NSWorkspace/NSRunningApplication |
| Нет источника аудио для анализа дублей | S10, §8.5 три варианта, §12.8 условный |
| Позиционные region/take/marker | §4.3 селекторы, §4.4 хэндлы регионов и новые адреса после мутаций, §12.9 |
| Пользователь меняет выделение посреди рецепта; слепой undo | §5.4 readback контекста на каждом шаге, undo-заголовки |
| `until` держит актор до 300 s | §5.1 короткие слоты, §4.6 таймауты 10/30/120 s + progress |
| MMC без `Listen to MMC Input`; realtime-record фолбэк | §8.2 AX control bar основной, MMC после handshake, S11; §8.3 фолбэк удалён |
| Бюджеты на игрушке, ошибки ≤ 60 противоречат кандидатам | §4.6 свёртка/page/fields, §7 фикстура «big», §5.5 ярусы ошибок |
| Мелочи: `until` с пробелами, meter vs микрокэш, `unknown_logic_version` | §4.6, §5.5 |

## 15. Changelog v4 (самоаудит 2026-09-21)
| Проблема | Где исправлено |
|---|---|
| AX может не отдавать треки/регионы вне экрана; синтетическая «big» это прячет | S12, §4.6 видимость, §7 записанная «big», §11 P0 порядок |
| Позиция региона может быть только пиксельным frame | S3 ключевой вопрос |
| Грубые шаги параметров (5 dB) — потолок качества сведения | §8.1 точность, S6 поиск точного пути |
| Swift actor реентерабелен, AX блокирует, Logic «занят» | §5.1 `AXExecutor` (поток + RunLoop + FIFO), messaging timeout, `busy`, батч-чтения |
| Выделение трека = маршрутизация MIDI/записи | §1 п.5, §4.2 возврат выделения, S8, §12.10 |
| Заголовок undo без открытия меню может быть устаревшим | §5.4, S9 |
| Сохраняемые режимы вида (Controls, окна, прокрутка) меняются незаметно для нас | §1 п.6, §5.4 `WindowTransaction`, §12.10 |
| Live-тесты на живом проекте пользователя | §5.6 копии проектов, §12.11 |
| Нет бюджетов времени | §7 бюджеты мс/AX-сообщений, §12.12 |
| Мутации во время записи/воспроизведения | §5.4 guard транспорта, §5.5 `blocked(recording|playing)`, §12.13 |
| Два адреса у сабтрека стека | §4.3 каноническая форма |
| Импорт MIDI: новый трек, диалог темпа | §8.3, S4 |
| Ledger по мажорной версии | §5.6 минорная версия + проверка якорей |
