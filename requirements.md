# requirements.md — logic-native MCP: P0 (спайки) + P1 (фундамент)

Источник: `docs/superpowers/plans/2026-09-21-p0-p1-spikes-and-foundation.md` (копия ниже). Спек: `docs/superpowers/specs/2026-09-21-logic-native-mcp-design.md`.

Правила прогона (tero):
  - Исполняемые шаги — только 32 чекбокса ниже, строго по порядку, по одному исполнителю за раз.
  - Каждый шаг = одна задача плана; player читает её раздел «### Task N» в этом файле, coach проверяет по нему же.
  - Коммиты делает senior после SHIP, не player: шаги «Commit» в плане = сообщение коммита для senior, player их не выполняет.
  - Global Constraints плана действуют для каждого шага.
  - Пометка 👤 — нужен пользователь/живой Logic; без этого ответ BLOCKED, никаких выдуманных наблюдений.

## Чек-лист

- [x] Task 1 — Таргет LogicKit рядом со старым кодом. Выполни раздел «### Task 1» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть.
- [x] Task 2 — AXNode, фикстуры и поиск по дереву. Выполни раздел «### Task 2» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть.
- [x] Task 3 — Живой AX, счётчик сообщений, LogicApp, live-таргет. Выполни раздел «### Task 3» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть.
- [x] Task 4 — logic-ax-dump. Выполни раздел «### Task 4» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть.
- [x] Task 5 — WindowSnapshot. Выполни раздел «### Task 5» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть.
- [x] Task 6 — AXExecutor. Выполни раздел «### Task 6» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть.
- [x] Task 7 — logic-probe, локатор, меню-пути, копии проектов. Выполни раздел «### Task 7» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть. [👤 частично: шаг 8 — копия проекта пользователя] Если живой Logic с fixture- проектом недоступен — сделай всё офлайн и ответь BLOCKED по live-части, не подделывая результат.
- [ ] Task 8 — S12 — полнота и цена AX; запись фикстур. Выполни раздел «### Task 8» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть. [👤 НУЖЕН ПОЛЬЗОВАТЕЛЬ И ЖИВОЙ LOGIC] Не выдумывай наблюдения: если fixture-проект не открыт или 👤-шаг не сделан — остановись и ответь BLOCKED с тем, чего ждёшь.
- [ ] Task 9 — S3 — регионы, take folder, Region Inspector. Выполни раздел «### Task 9» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть. [👤 НУЖЕН ПОЛЬЗОВАТЕЛЬ И ЖИВОЙ LOGIC] Не выдумывай наблюдения: если fixture-проект не открыт или 👤-шаг не сделан — остановись и ответь BLOCKED с тем, чего ждёшь.
- [ ] Task 10 — S6 — шаги, скорость и точный путь параметров. Выполни раздел «### Task 10» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть. [👤 НУЖЕН ПОЛЬЗОВАТЕЛЬ И ЖИВОЙ LOGIC] Не выдумывай наблюдения: если fixture-проект не открыт или 👤-шаг не сделан — остановись и ответь BLOCKED с тем, чего ждёшь.
- [ ] Task 11 — S8 — невидимый verified select и возврат выделения. Выполни раздел «### Task 11» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть. [👤 НУЖЕН ПОЛЬЗОВАТЕЛЬ И ЖИВОЙ LOGIC] Не выдумывай наблюдения: если fixture-проект не открыт или 👤-шаг не сделан — остановись и ответь BLOCKED с тем, чего ждёшь.
- [ ] Task 12 — S9 — меню-бар без фокуса и свежесть заголовка undo. Выполни раздел «### Task 12» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть. [👤 НУЖЕН ПОЛЬЗОВАТЕЛЬ И ЖИВОЙ LOGIC] Не выдумывай наблюдения: если fixture-проект не открыт или 👤-шаг не сделан — остановись и ответь BLOCKED с тем, чего ждёшь.
- [ ] Task 13 — S1 — окна и фокус по рабочим окнам Logic. Выполни раздел «### Task 13» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть. [👤 НУЖЕН ПОЛЬЗОВАТЕЛЬ И ЖИВОЙ LOGIC] Не выдумывай наблюдения: если fixture-проект не открыт или 👤-шаг не сделан — остановись и ответь BLOCKED с тем, чего ждёшь.
- [ ] Task 14 — S11 и S2 — транспорт и нотификации. Выполни раздел «### Task 14» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть. [👤 НУЖЕН ПОЛЬЗОВАТЕЛЬ И ЖИВОЙ LOGIC] Не выдумывай наблюдения: если fixture-проект не открыт или 👤-шаг не сделан — остановись и ответь BLOCKED с тем, чего ждёшь.
- [ ] Task 15 — S4, S5, S7, S10 — вопросы для P2+. Выполни раздел «### Task 15» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть. [👤 НУЖЕН ПОЛЬЗОВАТЕЛЬ И ЖИВОЙ LOGIC] Не выдумывай наблюдения: если fixture-проект не открыт или 👤-шаг не сделан — остановись и ответь BLOCKED с тем, чего ждёшь.
- [ ] Task 16 — Синтез P0 → спек APPROVED, гейт. Выполни раздел «### Task 16» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть. [👤 НУЖЕН ПОЛЬЗОВАТЕЛЬ И ЖИВОЙ LOGIC] Не выдумывай наблюдения: если fixture-проект не открыт или 👤-шаг не сделан — остановись и ответь BLOCKED с тем, чего ждёшь. ГЕЙТ: если S12 или S3 🔴 — стоп, BLOCKED до решения пользователя.
- [x] Task 17 — Ошибки, исходы, оценка токенов. Выполни раздел «### Task 17» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть.
- [x] Task 18 — Значения в единицах Logic. Выполни раздел «### Task 18» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть.
- [x] Task 19 — Пути. Выполни раздел «### Task 19» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть.
- [x] Task 20 — LocaleTable. Выполни раздел «### Task 20» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть.
- [x] Task 21 — Модель и ридеры. Выполни раздел «### Task 21» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть.
- [x] Task 22 — Хэндлы. Выполни раздел «### Task 22» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть.
- [x] Task 23 — Резолвер. Выполни раздел «### Task 23» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть.
- [x] Task 24 — Рендер и бюджеты токенов. Выполни раздел «### Task 24» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть.
- [ ] Task 25 — Примитивы, verify, контракт stepTo. Выполни раздел «### Task 25» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть.
- [ ] Task 26 — Рецепты и раннер. Выполни раздел «### Task 26» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть.
- [ ] Task 27 — Грамматика и ledger. Выполни раздел «### Task 27» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть.
- [ ] Task 28 — Рецепты среза P1 и их live-тесты. Выполни раздел «### Task 28» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть. [👤 частично: шаг 6 — live-тесты] Если живой Logic с fixture- проектом недоступен — сделай всё офлайн и ответь BLOCKED по live-части, не подделывая результат.
- [ ] Task 29 — LogicSession — фасад для адаптеров. Выполни раздел «### Task 29» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть. [👤 частично: шаг 5 — live-тесты] Если живой Logic с fixture- проектом недоступен — сделай всё офлайн и ответь BLOCKED по live-части, не подделывая результат.
- [ ] Task 30 — Адаптер LogicMCP. Выполни раздел «### Task 30» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть.
- [ ] Task 31 — Переключение: MIDI в LogicKit, logic_midi, удаление upstream-кода. Выполни раздел «### Task 31» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть.
- [ ] Task 32 — Приёмка P1. Выполни раздел «### Task 32» из requirements.md (ниже в этом файле) целиком и по порядку: Files/Interfaces — контракт, шаги — TDD с указанными командами; Expected должен совпасть. [👤 частично: шаги 2–3 и 6] Если живой Logic с fixture- проектом недоступен — сделай всё офлайн и ответь BLOCKED по live-части, не подделывая результат.

---

# Детальный план (исполняется по пунктам чек-листа выше)

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** ответить на все ⛳-вопросы спека живыми спайками (P0) и построить на их ответах фундамент нового сервера (P1): `LogicKit` + тонкий `LogicMCP` с четырьмя инструментами и вертикальным срезом до `live-verified`.

**Architecture:** сначала строится ровно та часть фундамента, которая нужна спайкам (AXNode, фикстуры, живой AX, снимки окон, `AXExecutor`) и dev-инструменты `logic-ax-dump`/`logic-probe`. Затем спайки S1–S12 на **копиях** проектов с записью результатов в `spikes-2026-09.md` и go/no-go-гейтом. Затем остальной P1: значения, пути, карта, хэндлы, рендер, примитивы, рецепты, ledger, MCP-адаптер, удаление upstream-кода.

**Tech Stack:** Swift 6.2.3, SwiftPM (tools 6.0), macOS 14+, ApplicationServices (AX), CoreGraphics (CGWindowList), AppKit (NSWorkspace/NSRunningApplication), CoreMIDI, `modelcontextprotocol/swift-sdk` 0.12.1, XCTest.

**Spec:** `docs/superpowers/specs/2026-09-21-logic-native-mcp-design.md` (v4). Исполнитель читает спек и этот план вместе.

## Global Constraints

  - SwiftPM `swift-tools-version: 6.0`, `platforms: [.macOS(.v14)]`, тулчейн Swift 6.2.3.
  - Единственная внешняя зависимость: `https://github.com/modelcontextprotocol/swift-sdk.git` `from: "0.12.1"`.
  - `LogicKit` **не** импортирует `MCP`.
  - Разрешения: **только Accessibility**. Никаких AppleScript/System Events, CGEvent-клавиатуры, скриншотов/OCR (исключение — только если S9 даст исход (b): узкий Apple Event к меню-бару).
  - Текст в Logic — только через `AXValue`, никогда keystroke.
  - Все AX-вызовы рантайма (`LogicKit`, `LogicMCP`) идут через `AXExecutor`. Dev-инструменты (`logic-ax-dump`, `logic-probe`) и live-тесты зовут AX напрямую с главного потока.
  - stdout — только JSON-RPC; логи — stderr (`Log`).
  - Значения на интерфейсе — в единицах Logic (`"-6 dB"`, `"L12"`, `"38 ms"`); нормализованных 0–1 нет.
  - Любая мутация Logic из probe/live-тестов разрешена, **только если заголовок главного окна Logic начинается с `fixture-`** (`FixtureGuard`). Живые тесты — только при `LOGIC_LIVE=1`.
  - Бюджеты токенов (спек §7): описания всех инструментов ≤ 1500; `logic_read("/")` ≤ 350 на обеих фикстурах; трек со strip ≤ 200; ошибка ≤ 150 (первая строка ≤ 60).
  - Тесты — XCTest (как существующие). Офлайн-тесты никогда не трогают AX.
  - Коммиты: короткие, строчными, без префиксов `feat:`/`fix:`, без эмодзи, **без `Co-Authored-By` и любой AI-атрибуции**.
  - Исполнение: один исполнитель за раз, задачи строго по порядку (никаких параллельных «игроков»).
  - **Гейт после Task 16:** если S12 или S3 красные — стоп, обсудить с пользователем до Phase C.
  - Шаги с 👤 выполняет пользователь в Logic (исполнитель просит и ждёт). Всё остальное исполнитель делает сам, включая запуск `logic-probe` против открытой копии проекта.

---

## Файловая структура

```
Package.swift                                   # + LogicKit, LogicMCP, logic-ax-dump, logic-probe, тестовые таргеты
Sources/
  LogicKit/
    LogicKit.swift                              # версия библиотеки
    Support/Log.swift                           # stderr-логгер (public-копия upstream Log)
    Support/TokenEstimate.swift                 # консервативная оценка токенов
    Platform/AXNode.swift                       # AXScalar, AXAttrs, AXCallError, AXNode, AXRoot
    Platform/AXSnapshot.swift                   # AXSnapshotNode, AXFixture, AXCapture
    Platform/FixtureAXNode.swift                # FixtureAXNode, FixtureAXRoot
    Platform/AXQuery.swift                      # AXMatch, поиск по дереву, AXAttrs.compactLine
    Platform/AXLocator.swift                    # строковый локатор для probe/raw
    Platform/MenuPath.swift                     # "Edit>^Undo" → пункт меню
    Platform/LiveAXNode.swift                   # AXUIElement-обёртка, AXStats, LiveAXRoot
    Platform/LogicApp.swift                     # pid, версия, FixtureGuard, Permissions
    Platform/WindowSnapshot.swift               # CGWindowList + AXMain/Focused + сторона пользователя
    Platform/LocaleTable.swift                  # Anchor + строки en
    Engine/AXExecutor.swift                     # поток + RunLoop + FIFO + busy
    Engine/Errors.swift                         # LogicError, Outcome, Quantization, рендер ошибок
    Engine/Primitives.swift                     # Clock, Verify.poll, press/setText/menu/stepTo, StepContract
    Engine/Recipe.swift                         # Visibility, RecipeSpec, Recipe, RecipeContext, RecipeRunner
    Engine/Recipes/TrackToggle.swift            # mute/solo как set
    Engine/Recipes/SelectTrack.swift            # verified select (стратегия из S8)
    Engine/Recipes/UndoRedo.swift               # Edit-меню + undo_title
    Engine/Recipes/Transport.swift              # play/stop/locate через control bar (S11)
    Map/Values.swift                            # ValueUnit, LogicValue, BarPosition, ValueParser
    Map/Path.swift                              # NodeKind, Selector, PathSegment, LPath
    Map/Model.swift                             # TrackInfo, StripInfo, InsertInfo, TransportInfo, ProjectInfo
    Map/Readers.swift                           # TrackRowDesc, TrackReader, StripReader, TransportReader, ModalGuard
    Map/Handles.swift                           # Fingerprint, HandleTable
    Map/Resolver.swift                          # селекторы → TrackInfo, каноническая форма
    Map/Grammar.swift                           # Capability, Grammar, Ledger
    Render/TextRenderer.swift                   # компактный текст, свёртка, fields/page
    Session/LogicSession.swift                  # фасад для адаптеров: read/set/do
    Resources/ledger.json                       # live-ledger (пишут только LogicLiveTests)
    Streams/MIDI/…                              # MIDIEngine, MIDIFeedback, MMCCommands (переезд в Task 31)
  LogicMCP/                                     # новый исполняемый адаптер (Task 30)
    main.swift · Server.swift · ToolDefs.swift · ArgValidator.swift
  logic-ax-dump/main.swift                      # запись AX-фикстур
  logic-probe/main.swift · Observe.swift · MMC.swift   # спайковый зонд
  LogicProMCP/                                  # upstream — удаляется целиком в Task 31
Tests/
  Fixtures/README.md
  Fixtures/ax/mini.json                         # ручная мини-фикстура
  Fixtures/ax/belo-krasny.json · big.json       # записанные с живого Logic (Task 8)
  Fixtures/projects/README.md                   # копии .logicx (gitignored)
  LogicKitTests/…                               # офлайн
  LogicLiveTests/…                              # LOGIC_LIVE=1
Scripts/fixture-open.sh · Scripts/make-big-midi.py
docs/superpowers/specs/spikes-2026-09.md        # результаты P0
```

Отклонение от спека, которое фиксируется в Task 16: ledger лежит в `Sources/LogicKit/Resources/ledger.json`, а не в `Tests/Live/ledger.json`. SwiftPM не встраивает ресурсы из-за пределов таргета, а рантайму ledger нужен, чтобы решать, что рекламировать.

---

# Phase A — фундамент, нужный спайкам

### Task 1: Таргет LogicKit рядом со старым кодом

**Files:**
  - Modify: `Package.swift`
  - Create: `Sources/LogicKit/LogicKit.swift`, `Sources/LogicKit/Support/Log.swift`
  - Create: `Tests/LogicKitTests/Support/Fixtures.swift`, `Tests/LogicKitTests/SmokeTests.swift`, `Tests/Fixtures/README.md`

**Interfaces:**
  - Produces: `LogicKitInfo.version: String`; `Log.debug/info/warn/error(_:subsystem:)` (public); тестовый хелпер `Fixtures.url(_ relative: String) -> URL` (указывает на `Tests/Fixtures/…`).

  - [ ] **Step 1: Добавить таргеты в `Package.swift`**

```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "LogicProMCP",
    platforms: [.macOS(.v14)],
    products: [
        .executable(name: "LogicProMCP", targets: ["LogicProMCP"]),
        .library(name: "LogicKit", targets: ["LogicKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/modelcontextprotocol/swift-sdk.git", from: "0.12.1"),
    ],
    targets: [
        .target(
            name: "LogicKit",
            path: "Sources/LogicKit",
            linkerSettings: [
                .linkedFramework("CoreMIDI"),
                .linkedFramework("ApplicationServices"),
                .linkedFramework("CoreGraphics"),
                .linkedFramework("AppKit"),
            ]
        ),
        .executableTarget(
            name: "LogicProMCP",
            dependencies: [
                .product(name: "MCP", package: "swift-sdk"),
            ],
            path: "Sources/LogicProMCP",
            linkerSettings: [
                .linkedFramework("CoreMIDI"),
                .linkedFramework("ApplicationServices"),
                .linkedFramework("CoreGraphics"),
            ]
        ),
        .testTarget(
            name: "LogicProMCPTests",
            dependencies: ["LogicProMCP"],
            path: "Tests/LogicProMCPTests"
        ),
        .testTarget(
            name: "LogicKitTests",
            dependencies: ["LogicKit"],
            path: "Tests/LogicKitTests"
        ),
    ]
)
```

  - [ ] **Step 2: Написать падающий тест**

`Tests/LogicKitTests/Support/Fixtures.swift`:
```swift
import Foundation

/// Fixtures live in Tests/Fixtures (outside the target), found relative to this file.
enum Fixtures {
    static let root = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()   // Support
        .deletingLastPathComponent()   // LogicKitTests
        .deletingLastPathComponent()   // Tests
        .appendingPathComponent("Fixtures")

    static func url(_ relative: String) -> URL {
        root.appendingPathComponent(relative)
    }
}
```

`Tests/LogicKitTests/SmokeTests.swift`:
```swift
import XCTest
import LogicKit

final class SmokeTests: XCTestCase {
    func testLibraryVersionIsSet() {
        XCTAssertFalse(LogicKitInfo.version.isEmpty)
    }

    func testFixturesDirectoryIsFound() {
        XCTAssertTrue(FileManager.default.fileExists(atPath: Fixtures.url("README.md").path))
    }
}
```

`Tests/Fixtures/README.md`:
```markdown
# Fixtures
- `ax/*.json` — AX snapshots (`AXFixture`). `mini.json` is hand-written; the others are recorded with `logic-ax-dump` from live Logic.
- `projects/` — Logic project copies (`fixture-*.logicx`), gitignored. Live code only touches projects whose name starts with `fixture-`.
Fixtures are static snapshots: they do not emulate Logic behaviour (spec §3).
```

  - [ ] **Step 3: Прогнать — должен упасть на компиляции**

Run: `swift test --filter LogicKitTests 2>&1 | tail -5`
Expected: FAIL — `cannot find 'LogicKitInfo' in scope` (или «no such module», пока нет исходников).

  - [ ] **Step 4: Минимальная реализация**

`Sources/LogicKit/LogicKit.swift`:
```swift
public enum LogicKitInfo {
    public static let version = "0.2.0-dev"
}
```

`Sources/LogicKit/Support/Log.swift` — копия `Sources/LogicProMCP/Utilities/Logger.swift`, где `enum Log`, `enum Level`, `minLevel` и все статические функции помечены `public`. Больше ничего не меняется. Внутри старого таргета собственный `Log` модуля затеняет импортированный, поэтому конфликта нет.

  - [ ] **Step 5: Прогнать все тесты**

Run: `swift build 2>&1 | tail -3 && swift test 2>&1 | tail -5`
Expected: сборка успешна; `LogicKitTests` 2 теста PASS; старые `LogicProMCPTests` PASS.

  - [ ] **Step 6: Commit**

```bash
git add Package.swift Sources/LogicKit Tests/LogicKitTests Tests/Fixtures/README.md
git commit -m "logickit target next to upstream code"
```

---

### Task 2: AXNode, фикстуры и поиск по дереву

**Files:**
  - Create: `Sources/LogicKit/Platform/AXNode.swift`, `Sources/LogicKit/Platform/AXSnapshot.swift`, `Sources/LogicKit/Platform/FixtureAXNode.swift`, `Sources/LogicKit/Platform/AXQuery.swift`
  - Create: `Tests/Fixtures/ax/mini.json`
  - Test: `Tests/LogicKitTests/AXNodeTests.swift`

**Interfaces:**
  - Produces:
  - `enum AXScalar: Codable, Equatable, Sendable { case string(String), number(Double), bool(Bool) }` + `stringValue: String`
  - `struct AXAttrs: Codable, Equatable, Sendable` — поля `role, subrole, title, desc, help, identifier: String?`, `value: AXScalar?`, `valueDescription: String?`, `enabled: Bool?`, `selected: Bool?`, `actions: [String]`
  - `enum AXCallError: Error, Equatable, Sendable { case timeout, invalidElement, notSupported(String), failure(Int32), readOnlyFixture }`
  - `protocol AXNode: AnyObject, Sendable { func attrs() throws -> AXAttrs; func children() throws -> [any AXNode]; func perform(_ action: String) throws; func set(_ attribute: String, _ value: AXScalar) throws; var identityToken: Int { get } }`
  - `protocol AXRoot: Sendable { func mainWindow() throws -> (any AXNode)?; func focusedWindow() throws -> (any AXNode)?; func menuBar() throws -> (any AXNode)? }`
  - `struct AXSnapshotNode: Codable { a: AXAttrs; c: [AXSnapshotNode]; truncated: Bool? }`
  - `struct AXFixture: Codable { meta: Meta; roots: [String: AXSnapshotNode] }`, `AXFixture.load(_:)`, `write(to:)`
  - `struct CaptureStats { nodes, truncatedAt, skipped: Int }`, `AXCapture.capture(_:depth:stats:) throws -> AXSnapshotNode`
  - `final class FixtureAXNode: AXNode`, `struct FixtureAXRoot: AXRoot` (`init(_ fixture: AXFixture)`)
  - `struct AXMatch` с `enum Op { equals, prefix, contains }` и `matches(_ a: AXAttrs) -> Bool`
  - `extension AXNode { firstChild(_:), firstDescendant(_:maxDepth:), allDescendants(_:maxDepth:descendIntoMatches:) }`
  - `AXAttrs.compactLine: String`

  - [ ] **Step 1: Мини-фикстура**

`Tests/Fixtures/ax/mini.json` (скобки `“ ”` — U+201C/U+201D, как у Logic):
```json
{"meta":{"logicVersion":"11.2","capturedAt":"2026-09-21T00:00:00Z","project":"fixture-mini"},
 "roots":{
  "mainWindow":{"a":{"role":"AXWindow","subrole":"AXStandardWindow","title":"fixture-mini - Tracks","actions":[]},"c":[
   {"a":{"role":"AXGroup","desc":"Tracks header","actions":[]},"c":[
    {"a":{"role":"AXLayoutItem","desc":"Track 1 “Beat”","selected":false,"actions":["AXPress"]},"c":[
      {"a":{"role":"AXCheckBox","desc":"Mute","value":0,"actions":["AXPress"]},"c":[]},
      {"a":{"role":"AXCheckBox","desc":"Solo","value":1,"actions":["AXPress"]},"c":[]},
      {"a":{"role":"AXSlider","desc":"Volume","value":173,"valueDescription":"0.0 dB","actions":["AXIncrement","AXDecrement"]},"c":[]}]},
    {"a":{"role":"AXLayoutItem","desc":"Track 2 “Rose Vocal”","selected":true,"actions":["AXPress"]},"c":[
      {"a":{"role":"AXDisclosureTriangle","value":1,"actions":["AXPress"]},"c":[]},
      {"a":{"role":"AXCheckBox","desc":"Mute","value":0,"actions":["AXPress"]},"c":[]}]},
    {"a":{"role":"AXLayoutItem","desc":"Track 3 “Warm Vocal”","selected":false,"actions":["AXPress"]},"c":[]},
    {"a":{"role":"AXLayoutItem","desc":"Track 3 “Warm Vocal”, Take","actions":[]},"c":[]},
    {"a":{"role":"AXLayoutItem","desc":"Track 3 “Warm Vocal”, Take","actions":[]},"c":[]},
    {"a":{"role":"AXLayoutItem","desc":"Track 4 “PreDelay”, no output","selected":false,"actions":["AXPress"]},"c":[]}]},
   {"a":{"role":"AXGroup","desc":"Control Bar","actions":[]},"c":[
    {"a":{"role":"AXCheckBox","desc":"Play","value":0,"actions":["AXPress"]},"c":[]},
    {"a":{"role":"AXCheckBox","desc":"Record","value":0,"actions":["AXPress"]},"c":[]}]},
   {"a":{"role":"AXLayoutItem","help":"Left inspector channel strip","actions":[]},"c":[
    {"a":{"role":"AXSlider","desc":"volume fader","valueDescription":"-4.2 dB","actions":["AXIncrement","AXDecrement"]},"c":[]},
    {"a":{"role":"AXSlider","desc":"pan","valueDescription":"0","actions":["AXIncrement","AXDecrement"]},"c":[]},
    {"a":{"role":"AXGroup","actions":[]},"c":[
     {"a":{"role":"AXGroup","desc":"Channel EQ","actions":[]},"c":[
      {"a":{"role":"AXCheckBox","desc":"bypass","value":0,"actions":["AXPress"]},"c":[]}]},
     {"a":{"role":"AXGroup","desc":"ChromaVerb","actions":[]},"c":[
      {"a":{"role":"AXCheckBox","desc":"bypass","value":1,"actions":["AXPress"]},"c":[]}]}]},
    {"a":{"role":"AXStaticText","title":"peak level meter, -4.7 dB","actions":[]},"c":[]}]}]},
  "menuBar":{"a":{"role":"AXMenuBar","actions":[]},"c":[
   {"a":{"role":"AXMenuBarItem","title":"Edit","actions":["AXPress"]},"c":[
    {"a":{"role":"AXMenu","actions":[]},"c":[
     {"a":{"role":"AXMenuItem","title":"Undo Insert Plug-in","enabled":true,"actions":["AXPress"]},"c":[]},
     {"a":{"role":"AXMenuItem","title":"Redo","enabled":false,"actions":["AXPress"]},"c":[]}]}]}]}}}
```

  - [ ] **Step 2: Написать падающие тесты**

`Tests/LogicKitTests/AXNodeTests.swift`:
```swift
import XCTest
@testable import LogicKit

final class AXNodeTests: XCTestCase {
    func mini() throws -> FixtureAXRoot {
        FixtureAXRoot(try AXFixture.load(Fixtures.url("ax/mini.json")))
    }

    func testScalarDecodesBoolNumberString() throws {
        let data = #"[true, 3, 2.5, "x"]"#.data(using: .utf8)!
        let v = try JSONDecoder().decode([AXScalar].self, from: data)
        XCTAssertEqual(v, [.bool(true), .number(3), .number(2.5), .string("x")])
        XCTAssertEqual(AXScalar.number(3).stringValue, "3")
        XCTAssertEqual(AXScalar.number(2.5).stringValue, "2.5")
    }

    func testFixtureLoadsRootsAndAttrs() throws {
        let root = try mini()
        let main = try XCTUnwrap(root.mainWindow())
        XCTAssertEqual(try main.attrs().title, "fixture-mini - Tracks")
        XCTAssertEqual(try main.children().count, 3)
        XCTAssertNil(try root.focusedWindow())
    }

    func testFixtureIsReadOnly() throws {
        let main = try XCTUnwrap(try mini().mainWindow())
        XCTAssertThrowsError(try main.perform("AXPress")) { XCTAssertEqual($0 as? AXCallError, .readOnlyFixture) }
    }

    func testFixtureChildIdentityIsStable() throws {
        let main = try XCTUnwrap(try mini().mainWindow())
        XCTAssertEqual(try main.children()[0].identityToken, try main.children()[0].identityToken)
    }

    func testFirstDescendantIsBreadthFirst() throws {
        let main = try XCTUnwrap(try mini().mainWindow())
        let mute = try XCTUnwrap(main.firstDescendant(AXMatch(role: "AXCheckBox", desc: .equals("Mute"))))
        // BFS: the first Mute belongs to Track 1
        XCTAssertEqual(try mute.attrs().value, .number(0))
        let row = try XCTUnwrap(main.firstDescendant(AXMatch(desc: .prefix("Track 4"))))
        XCTAssertEqual(try row.attrs().desc, "Track 4 “PreDelay”, no output")
    }

    func testAllDescendantsStopsAtMatchesByDefault() throws {
        let main = try XCTUnwrap(try mini().mainWindow())
        let groups = try main.allDescendants(AXMatch(role: "AXGroup"))
        XCTAssertEqual(groups.count, 3) // Tracks header, Control Bar, plugin container
        let deep = try main.allDescendants(AXMatch(role: "AXGroup"), descendIntoMatches: true)
        XCTAssertEqual(deep.count, 5)
    }

    func testMatchOps() {
        let a = AXAttrs(role: "AXButton", title: "Undo Insert", desc: "open")
        XCTAssertTrue(AXMatch(role: "AXButton", title: .prefix("Undo")).matches(a))
        XCTAssertTrue(AXMatch(title: .contains("Insert")).matches(a))
        XCTAssertFalse(AXMatch(desc: .equals("list")).matches(a))
        XCTAssertFalse(AXMatch(help: .prefix("x")).matches(a)) // nil never matches an op
    }

    func testCaptureRoundTripsFixture() throws {
        let fx = try AXFixture.load(Fixtures.url("ax/mini.json"))
        let main = FixtureAXNode(try XCTUnwrap(fx.roots["mainWindow"]))
        var stats = CaptureStats()
        let snap = try AXCapture.capture(main, depth: 50, stats: &stats)
        XCTAssertEqual(snap, fx.roots["mainWindow"])
        XCTAssertEqual(stats.nodes, 25)
        var shallow = CaptureStats()
        let cut = try AXCapture.capture(main, depth: 1, stats: &shallow)
        XCTAssertEqual(cut.c.count, 3)
        XCTAssertEqual(cut.c[0].truncated, true)
    }

    func testCompactLine() {
        let a = AXAttrs(role: "AXSlider", desc: "volume fader", value: .number(173), valueDescription: "-4.2 dB",
                        actions: ["AXIncrement", "AXDecrement", "AXShowMenu"])
        XCTAssertEqual(a.compactLine, #"AXSlider d="volume fader" v="173" vd="-4.2 dB" {Increment,Decrement}"#)
    }
}
```

  - [ ] **Step 3: Прогнать — падает на компиляции**

Run: `swift test --filter AXNodeTests 2>&1 | tail -5`
Expected: FAIL — `cannot find 'FixtureAXRoot' in scope`.

  - [ ] **Step 4: Реализация**

`Sources/LogicKit/Platform/AXNode.swift`:
```swift
import Foundation

/// A scalar AX value. Encoded in fixtures as a bare JSON bool/number/string.
public enum AXScalar: Codable, Equatable, Sendable {
    case string(String)
    case number(Double)
    case bool(Bool)

    public var stringValue: String {
        switch self {
        case .string(let s): return s
        case .bool(let b): return b ? "1" : "0"
        case .number(let d):
            if d == d.rounded(), abs(d) < 1e15 { return String(Int64(d)) }
            return String(d)
        }
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if let b = try? c.decode(Bool.self) { self = .bool(b); return }
        if let d = try? c.decode(Double.self) { self = .number(d); return }
        self = .string(try c.decode(String.self))
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.singleValueContainer()
        switch self {
        case .string(let s): try c.encode(s)
        case .number(let d): try c.encode(d)
        case .bool(let b): try c.encode(b)
        }
    }
}

/// The attribute set read in one batch per node.
public struct AXAttrs: Codable, Equatable, Sendable {
    public var role: String?
    public var subrole: String?
    public var title: String?
    public var desc: String?
    public var help: String?
    public var identifier: String?
    public var value: AXScalar?
    public var valueDescription: String?
    public var enabled: Bool?
    public var selected: Bool?
    public var actions: [String]

    public init(role: String? = nil, subrole: String? = nil, title: String? = nil, desc: String? = nil,
                help: String? = nil, identifier: String? = nil, value: AXScalar? = nil,
                valueDescription: String? = nil, enabled: Bool? = nil, selected: Bool? = nil,
                actions: [String] = []) {
        self.role = role; self.subrole = subrole; self.title = title; self.desc = desc
        self.help = help; self.identifier = identifier; self.value = value
        self.valueDescription = valueDescription; self.enabled = enabled; self.selected = selected
        self.actions = actions
    }

    enum CodingKeys: String, CodingKey {
        case role, subrole, title, desc, help, identifier, value, valueDescription, enabled, selected, actions
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        role = try c.decodeIfPresent(String.self, forKey: .role)
        subrole = try c.decodeIfPresent(String.self, forKey: .subrole)
        title = try c.decodeIfPresent(String.self, forKey: .title)
        desc = try c.decodeIfPresent(String.self, forKey: .desc)
        help = try c.decodeIfPresent(String.self, forKey: .help)
        identifier = try c.decodeIfPresent(String.self, forKey: .identifier)
        value = try c.decodeIfPresent(AXScalar.self, forKey: .value)
        valueDescription = try c.decodeIfPresent(String.self, forKey: .valueDescription)
        enabled = try c.decodeIfPresent(Bool.self, forKey: .enabled)
        selected = try c.decodeIfPresent(Bool.self, forKey: .selected)
        actions = try c.decodeIfPresent([String].self, forKey: .actions) ?? []
    }
}

public enum AXCallError: Error, Equatable, Sendable {
    /// kAXErrorCannotComplete or the messaging timeout: Logic's main thread did not answer.
    case timeout
    case invalidElement
    case notSupported(String)
    case failure(Int32)
    case readOnlyFixture
}

/// All AX access goes through this protocol (spec §3). Live and fixture implementations.
public protocol AXNode: AnyObject, Sendable {
    func attrs() throws -> AXAttrs
    func children() throws -> [any AXNode]
    func perform(_ action: String) throws
    func set(_ attribute: String, _ value: AXScalar) throws
    /// Equal for the same UI element within one AX session.
    var identityToken: Int { get }
}

public protocol AXRoot: Sendable {
    func mainWindow() throws -> (any AXNode)?
    func focusedWindow() throws -> (any AXNode)?
    func menuBar() throws -> (any AXNode)?
}
```

`Sources/LogicKit/Platform/AXSnapshot.swift`:
```swift
import Foundation

public struct AXSnapshotNode: Codable, Equatable, Sendable {
    public var a: AXAttrs
    public var c: [AXSnapshotNode]
    /// true when capture stopped at the depth limit; the node may have had children.
    public var truncated: Bool?

    public init(a: AXAttrs, c: [AXSnapshotNode], truncated: Bool? = nil) {
        self.a = a; self.c = c; self.truncated = truncated
    }
}

public struct AXFixture: Codable, Sendable {
    public struct Meta: Codable, Sendable {
        public var logicVersion: String
        public var capturedAt: String
        public var project: String
        public var note: String?
        public init(logicVersion: String, capturedAt: String, project: String, note: String? = nil) {
            self.logicVersion = logicVersion; self.capturedAt = capturedAt; self.project = project; self.note = note
        }
    }

    public var meta: Meta
    /// Keys: "mainWindow", "menuBar", "focusedWindow".
    public var roots: [String: AXSnapshotNode]

    public init(meta: Meta, roots: [String: AXSnapshotNode]) {
        self.meta = meta; self.roots = roots
    }

    public static func load(_ url: URL) throws -> AXFixture {
        try JSONDecoder().decode(AXFixture.self, from: Data(contentsOf: url))
    }

    public func write(to url: URL) throws {
        let e = JSONEncoder()
        e.outputFormatting = [.sortedKeys, .withoutEscapingSlashes]
        try e.encode(self).write(to: url)
    }
}

public struct CaptureStats: Sendable {
    public var nodes = 0
    public var truncatedAt = 0
    public var skipped = 0
    public init() {}
}

public enum AXCapture {
    /// Depth-first capture. Vanished children are skipped; timeouts propagate.
    public static func capture(_ node: any AXNode, depth: Int, stats: inout CaptureStats) throws -> AXSnapshotNode {
        let a = try node.attrs()
        stats.nodes += 1
        guard depth > 0 else {
            stats.truncatedAt += 1
            return AXSnapshotNode(a: a, c: [], truncated: true)
        }
        var kids: [AXSnapshotNode] = []
        for child in try node.children() {
            do {
                kids.append(try capture(child, depth: depth - 1, stats: &stats))
            } catch AXCallError.invalidElement {
                stats.skipped += 1
            }
        }
        return AXSnapshotNode(a: a, c: kids)
    }
}
```

`Sources/LogicKit/Platform/FixtureAXNode.swift`:
```swift
import Foundation

/// Static snapshot node. Never emulates Logic behaviour: every mutation throws.
public final class FixtureAXNode: AXNode, @unchecked Sendable {
    public let snapshot: AXSnapshotNode
    private let kids: [FixtureAXNode]

    public init(_ snapshot: AXSnapshotNode) {
        self.snapshot = snapshot
        self.kids = snapshot.c.map(FixtureAXNode.init)
    }

    public func attrs() throws -> AXAttrs { snapshot.a }
    public func children() throws -> [any AXNode] { kids }
    public func perform(_ action: String) throws { throw AXCallError.readOnlyFixture }
    public func set(_ attribute: String, _ value: AXScalar) throws { throw AXCallError.readOnlyFixture }
    public var identityToken: Int { ObjectIdentifier(self).hashValue }
}

public struct FixtureAXRoot: AXRoot, @unchecked Sendable {
    private let main: FixtureAXNode?
    private let focused: FixtureAXNode?
    private let menu: FixtureAXNode?
    public let meta: AXFixture.Meta

    public init(_ fixture: AXFixture) {
        main = fixture.roots["mainWindow"].map(FixtureAXNode.init)
        focused = fixture.roots["focusedWindow"].map(FixtureAXNode.init)
        menu = fixture.roots["menuBar"].map(FixtureAXNode.init)
        meta = fixture.meta
    }

    public func mainWindow() throws -> (any AXNode)? { main }
    public func focusedWindow() throws -> (any AXNode)? { focused }
    public func menuBar() throws -> (any AXNode)? { menu }
}
```

`Sources/LogicKit/Platform/AXQuery.swift`:
```swift
import Foundation

public struct AXMatch: Sendable, Equatable {
    public enum Op: Sendable, Equatable {
        case equals(String), prefix(String), contains(String)

        public func test(_ s: String?) -> Bool {
            guard let s else { return false }
            switch self {
            case .equals(let v): return s == v
            case .prefix(let v): return s.hasPrefix(v)
            case .contains(let v): return s.contains(v)
            }
        }
    }

    public var role: String?
    public var subrole: String?
    public var title: Op?
    public var desc: Op?
    public var help: Op?
    public var identifier: String?
    public var value: Op?

    public init(role: String? = nil, subrole: String? = nil, title: Op? = nil, desc: Op? = nil,
                help: Op? = nil, identifier: String? = nil, value: Op? = nil) {
        self.role = role; self.subrole = subrole; self.title = title; self.desc = desc
        self.help = help; self.identifier = identifier; self.value = value
    }

    public func matches(_ a: AXAttrs) -> Bool {
        if let role, a.role != role { return false }
        if let subrole, a.subrole != subrole { return false }
        if let identifier, a.identifier != identifier { return false }
        if let title, !title.test(a.title) { return false }
        if let desc, !desc.test(a.desc) { return false }
        if let help, !help.test(a.help) { return false }
        if let value, !value.test(a.value?.stringValue) { return false }
        return true
    }
}

extension AXNode {
    public func firstChild(_ m: AXMatch) throws -> (any AXNode)? {
        try children().first { try m.matches($0.attrs()) }
    }

    /// Breadth-first: the shallowest match wins.
    public func firstDescendant(_ m: AXMatch, maxDepth: Int = 12) throws -> (any AXNode)? {
        var frontier: [any AXNode] = [self]
        var depth = 0
        while !frontier.isEmpty && depth < maxDepth {
            var next: [any AXNode] = []
            for node in frontier {
                for child in try node.children() {
                    if m.matches(try child.attrs()) { return child }
                    next.append(child)
                }
            }
            frontier = next
            depth += 1
        }
        return nil
    }

    /// Depth-first pre-order. By default does not look inside a match.
    public func allDescendants(_ m: AXMatch, maxDepth: Int = 12, descendIntoMatches: Bool = false) throws -> [any AXNode] {
        var out: [any AXNode] = []
        func walk(_ node: any AXNode, _ depth: Int) throws {
            guard depth < maxDepth else { return }
            for child in try node.children() {
                let hit = m.matches(try child.attrs())
                if hit { out.append(child) }
                if !hit || descendIntoMatches { try walk(child, depth + 1) }
            }
        }
        try walk(self, 0)
        return out
    }
}

extension AXAttrs {
    /// One line per node: `role (subrole) t= d= h= id= v= vd= [sel] {Actions}` — probe output and the raw hatch (§4.7).
    public var compactLine: String {
        var parts = [role ?? "?"]
        if let subrole { parts.append("(\(subrole))") }
        if let title, !title.isEmpty { parts.append("t=\(Self.q(title))") }
        if let desc, !desc.isEmpty { parts.append("d=\(Self.q(desc))") }
        if let help, !help.isEmpty { parts.append("h=\(Self.q(String(help.prefix(60))))") }
        if let identifier, !identifier.isEmpty { parts.append("id=\(identifier)") }
        if let value { parts.append("v=\(Self.q(value.stringValue))") }
        if let valueDescription, !valueDescription.isEmpty { parts.append("vd=\(Self.q(valueDescription))") }
        if selected == true { parts.append("[sel]") }
        if enabled == false { parts.append("[disabled]") }
        let acts = actions.filter { $0 != "AXShowMenu" && $0 != "AXScrollToVisible" }
        if !acts.isEmpty {
            parts.append("{" + acts.map { $0.replacingOccurrences(of: "AX", with: "") }.joined(separator: ",") + "}")
        }
        return parts.joined(separator: " ")
    }

    static func q(_ s: String) -> String {
        "\"" + s.replacingOccurrences(of: "\"", with: "\\\"") + "\""
    }
}
```

  - [ ] **Step 5: Прогнать тесты**

Run: `swift test --filter AXNodeTests 2>&1 | tail -5`
Expected: PASS, 9 тестов. Если `stats.nodes` ≠ 25 — пересчитать узлы `mainWindow` в `mini.json` (считается каждый объект `{"a":…}` под `mainWindow`, включая его самого) и исправить число в тесте, а не код.

  - [ ] **Step 6: Commit**

```bash
git add Sources/LogicKit/Platform Tests/Fixtures/ax/mini.json Tests/LogicKitTests/AXNodeTests.swift
git commit -m "axnode protocol, fixtures, tree queries"
```

---

### Task 3: Живой AX, счётчик сообщений, LogicApp, live-таргет

**Files:**
  - Create: `Sources/LogicKit/Platform/LiveAXNode.swift`, `Sources/LogicKit/Platform/LogicApp.swift`
  - Create: `Tests/LogicLiveTests/Live.swift`, `Tests/LogicLiveTests/LiveSmokeTests.swift`
  - Modify: `Package.swift` (таргет `LogicLiveTests`)
  - Test: `Tests/LogicKitTests/LiveAXUnitTests.swift`

**Interfaces:**
  - Consumes: `AXNode`, `AXRoot`, `AXAttrs`, `AXScalar`, `AXCallError` (Task 2).
  - Produces:
  - `final class AXStats: Sendable { static let shared; func message(_ n: Int = 1); func timeout(); var messages: Int; var timeouts: Int; func reset() }`
  - `func axCheck(_ err: AXError) throws` (internal)
  - `final class LiveAXNode: AXNode` — `init(_ element: AXUIElement, timeout: Float = 1.0)`, `element`, `static func scalar(_ obj: AnyObject) -> AXScalar?`
  - `struct LiveAXRoot: AXRoot` — `init(pid: pid_t, timeout: Float = 1.0)`, `pid`, `appNode: LiveAXNode`
  - `enum LogicApp { bundleID; running(); pid; version(); minor(_:); axTrusted }`
  - `enum FixtureGuard { static let prefix = "fixture-"; static func allows(mainWindowTitle: String?) -> Bool }`
  - live-хелпер `Live.require() throws -> LiveAXRoot`

  - [ ] **Step 1: Падающие офлайн-тесты**

`Tests/LogicKitTests/LiveAXUnitTests.swift`:
```swift
import XCTest
@testable import LogicKit

final class LiveAXUnitTests: XCTestCase {
    func testScalarConversionDistinguishesBoolFromNumber() {
        XCTAssertEqual(LiveAXNode.scalar(kCFBooleanTrue), .bool(true))
        XCTAssertEqual(LiveAXNode.scalar(NSNumber(value: 173)), .number(173))
        XCTAssertEqual(LiveAXNode.scalar("x" as NSString), .string("x"))
        XCTAssertNil(LiveAXNode.scalar(NSArray()))
    }

    func testMinorVersion() {
        XCTAssertEqual(LogicApp.minor("11.2.1"), "11.2")
        XCTAssertEqual(LogicApp.minor("11.2"), "11.2")
    }

    func testFixtureGuard() {
        XCTAssertTrue(FixtureGuard.allows(mainWindowTitle: "fixture-big - Tracks"))
        XCTAssertFalse(FixtureGuard.allows(mainWindowTitle: "бело красный - Tracks"))
        XCTAssertFalse(FixtureGuard.allows(mainWindowTitle: nil))
    }

    func testStatsCount() {
        let s = AXStats()
        s.message(); s.message(2); s.timeout()
        XCTAssertEqual(s.messages, 3)
        XCTAssertEqual(s.timeouts, 1)
        s.reset()
        XCTAssertEqual(s.messages, 0)
    }
}
```

  - [ ] **Step 2: Прогнать — падает**

Run: `swift test --filter LiveAXUnitTests 2>&1 | tail -5`
Expected: FAIL — `cannot find 'LiveAXNode' in scope`.

  - [ ] **Step 3: Реализация**

`Sources/LogicKit/Platform/LiveAXNode.swift`:
```swift
import ApplicationServices
import Foundation
import os

/// Counts AX IPC messages (spec §7 time/AX budgets).
public final class AXStats: Sendable {
    public static let shared = AXStats()
    private let state = OSAllocatedUnfairLock(initialState: (messages: 0, timeouts: 0))

    public init() {}
    public func message(_ n: Int = 1) { state.withLock { $0.messages += n } }
    public func timeout() { state.withLock { $0.timeouts += 1 } }
    public var messages: Int { state.withLock { $0.messages } }
    public var timeouts: Int { state.withLock { $0.timeouts } }
    public func reset() { state.withLock { $0 = (0, 0) } }
}

func axCheck(_ err: AXError) throws {
    switch err {
    case .success: return
    case .cannotComplete:
        AXStats.shared.timeout()
        throw AXCallError.timeout
    case .invalidUIElement: throw AXCallError.invalidElement
    case .attributeUnsupported, .actionUnsupported, .noValue, .parameterizedAttributeUnsupported:
        throw AXCallError.notSupported("AXError \(err.rawValue)")
    default: throw AXCallError.failure(err.rawValue)
    }
}

public final class LiveAXNode: AXNode, @unchecked Sendable {
    public let element: AXUIElement
    let timeout: Float

    public init(_ element: AXUIElement, timeout: Float = 1.0) {
        self.element = element
        self.timeout = timeout
        AXUIElementSetMessagingTimeout(element, timeout)
    }

    static let batchNames: [String] = [
        kAXRoleAttribute, kAXSubroleAttribute, kAXTitleAttribute, kAXDescriptionAttribute,
        kAXHelpAttribute, kAXIdentifierAttribute, kAXValueAttribute, "AXValueDescription",
        kAXEnabledAttribute, kAXSelectedAttribute,
    ]

    /// One IPC for all attributes (AXUIElementCopyMultipleAttributeValues) + one for actions.
    public func attrs() throws -> AXAttrs {
        var raw: CFArray?
        AXStats.shared.message()
        try axCheck(AXUIElementCopyMultipleAttributeValues(
            element, Self.batchNames as CFArray, AXCopyMultipleAttributeOptions(rawValue: 0), &raw))
        let v = (raw as? [AnyObject]) ?? []
        func at(_ i: Int) -> AnyObject? { i < v.count ? v[i] : nil }
        var names: CFArray?
        AXStats.shared.message()
        let actions = AXUIElementCopyActionNames(element, &names) == .success ? ((names as? [String]) ?? []) : []
        return AXAttrs(
            role: at(0) as? String, subrole: at(1) as? String, title: at(2) as? String,
            desc: at(3) as? String, help: at(4) as? String, identifier: at(5) as? String,
            value: at(6).flatMap(Self.scalar), valueDescription: at(7) as? String,
            enabled: (at(8) as? NSNumber)?.boolValue, selected: (at(9) as? NSNumber)?.boolValue,
            actions: actions)
    }

    /// Missing attributes come back as AXValue error objects and map to nil.
    public static func scalar(_ obj: AnyObject) -> AXScalar? {
        if let s = obj as? String { return .string(s) }
        if let n = obj as? NSNumber {
            return CFGetTypeID(n) == CFBooleanGetTypeID() ? .bool(n.boolValue) : .number(n.doubleValue)
        }
        return nil
    }

    public func children() throws -> [any AXNode] {
        var raw: AnyObject?
        AXStats.shared.message()
        let err = AXUIElementCopyAttributeValue(element, kAXChildrenAttribute as CFString, &raw)
        if err == .noValue || err == .attributeUnsupported { return [] }
        try axCheck(err)
        guard let arr = raw as? [AXUIElement] else { return [] }
        return arr.map { LiveAXNode($0, timeout: timeout) }
    }

    public func perform(_ action: String) throws {
        AXStats.shared.message()
        try axCheck(AXUIElementPerformAction(element, action as CFString))
    }

    public func set(_ attribute: String, _ value: AXScalar) throws {
        let cf: CFTypeRef
        switch value {
        case .string(let s): cf = s as CFString
        case .number(let d): cf = NSNumber(value: d)
        case .bool(let b): cf = (b ? kCFBooleanTrue : kCFBooleanFalse)!
        }
        AXStats.shared.message()
        try axCheck(AXUIElementSetAttributeValue(element, attribute as CFString, cf))
    }

    public var identityToken: Int { Int(truncatingIfNeeded: CFHash(element)) }
}

public struct LiveAXRoot: AXRoot, @unchecked Sendable {
    public let pid: pid_t
    let app: AXUIElement
    let timeout: Float

    public init(pid: pid_t, timeout: Float = 1.0) {
        self.pid = pid
        self.app = AXUIElementCreateApplication(pid)
        self.timeout = timeout
        AXUIElementSetMessagingTimeout(app, timeout)
    }

    public var appNode: LiveAXNode { LiveAXNode(app, timeout: timeout) }

    func element(_ attr: String) throws -> (any AXNode)? {
        var raw: AnyObject?
        AXStats.shared.message()
        let err = AXUIElementCopyAttributeValue(app, attr as CFString, &raw)
        if err == .noValue || err == .attributeUnsupported { return nil }
        try axCheck(err)
        guard let raw, CFGetTypeID(raw) == AXUIElementGetTypeID() else { return nil }
        return LiveAXNode(raw as! AXUIElement, timeout: timeout)
    }

    public func mainWindow() throws -> (any AXNode)? { try element(kAXMainWindowAttribute) }
    public func focusedWindow() throws -> (any AXNode)? { try element(kAXFocusedWindowAttribute) }
    public func menuBar() throws -> (any AXNode)? { try element(kAXMenuBarAttribute) }
}
```

`Sources/LogicKit/Platform/LogicApp.swift`:
```swift
import AppKit
import ApplicationServices

public enum LogicApp {
    public static let bundleID = "com.apple.logic10"

    public static func running() -> NSRunningApplication? {
        NSRunningApplication.runningApplications(withBundleIdentifier: bundleID).first
    }

    public static var pid: pid_t? { running()?.processIdentifier }

    public static func version() -> String? {
        guard let url = running()?.bundleURL, let bundle = Bundle(url: url) else { return nil }
        return bundle.infoDictionary?["CFBundleShortVersionString"] as? String
    }

    /// "11.2.1" → "11.2". The ledger is keyed by minor version (spec §5.6).
    public static func minor(_ version: String) -> String {
        version.split(separator: ".").prefix(2).joined(separator: ".")
    }

    public static var axTrusted: Bool { AXIsProcessTrusted() }
}

/// Live mutations only against project copies named `fixture-*` (spec §5.6).
public enum FixtureGuard {
    public static let prefix = "fixture-"

    public static func allows(mainWindowTitle: String?) -> Bool {
        mainWindowTitle?.hasPrefix(prefix) ?? false
    }
}
```

  - [ ] **Step 4: Live-таргет**

В `Package.swift` в `targets` добавить:
```swift
        .testTarget(
            name: "LogicLiveTests",
            dependencies: ["LogicKit"],
            path: "Tests/LogicLiveTests"
        ),
```

`Tests/LogicLiveTests/Live.swift`:
```swift
import XCTest
import LogicKit

/// Gate for every live test: LOGIC_LIVE=1, Accessibility, Logic running, a fixture- project in front.
enum Live {
    static func require() throws -> LiveAXRoot {
        guard ProcessInfo.processInfo.environment["LOGIC_LIVE"] == "1" else { throw XCTSkip("LOGIC_LIVE != 1") }
        guard LogicApp.axTrusted else { throw XCTSkip("Accessibility not granted to the test runner") }
        guard let pid = LogicApp.pid else { throw XCTSkip("Logic Pro is not running") }
        let root = LiveAXRoot(pid: pid)
        let title = try root.mainWindow()?.attrs().title
        guard FixtureGuard.allows(mainWindowTitle: title) else {
            XCTFail("open a fixture- project copy first (Scripts/fixture-open.sh); main window is \(title ?? "nil")")
            throw XCTSkip("not a fixture project")
        }
        return root
    }
}
```

`Tests/LogicLiveTests/LiveSmokeTests.swift`:
```swift
import XCTest
import LogicKit

final class LiveSmokeTests: XCTestCase {
    func testMainWindowIsReadable() throws {
        let root = try Live.require()
        AXStats.shared.reset()
        let a = try XCTUnwrap(root.mainWindow()).attrs()
        XCTAssertEqual(a.role, "AXWindow")
        XCTAssertGreaterThan(AXStats.shared.messages, 0)
    }
}
```

  - [ ] **Step 5: Прогнать**

Run: `swift test --filter LiveAXUnitTests 2>&1 | tail -3 && swift test --filter LogicLiveTests 2>&1 | tail -3`
Expected: `LiveAXUnitTests` PASS (4); `LogicLiveTests` — skipped (нет `LOGIC_LIVE`).

  - [ ] **Step 6: Commit**

```bash
git add Package.swift Sources/LogicKit/Platform/LiveAXNode.swift Sources/LogicKit/Platform/LogicApp.swift Tests/LogicKitTests/LiveAXUnitTests.swift Tests/LogicLiveTests
git commit -m "live ax node with batched reads, message stats, fixture guard"
```

---

### Task 4: `logic-ax-dump`

**Files:**
  - Create: `Sources/logic-ax-dump/main.swift`
  - Modify: `Package.swift` (продукт + таргет)

**Interfaces:**
  - Consumes: `LiveAXRoot`, `AXCapture`, `CaptureStats`, `AXFixture`, `AXStats`, `LogicApp` (Tasks 2–3).
  - Produces: CLI `logic-ax-dump --out file.json [--depth 40] [--roots mainWindow,menuBar,focusedWindow] [--project name] [--note text] [--timeout 2]`. В stderr — строка статистики на каждый корень: `<root>: nodes=N truncated=N skipped=N ax_messages=N timeouts=N ms=N`.

  - [ ] **Step 1: Добавить таргет**

В `products`: `.executable(name: "logic-ax-dump", targets: ["logic-ax-dump"]),`
В `targets`:
```swift
        .executableTarget(
            name: "logic-ax-dump",
            dependencies: ["LogicKit"],
            path: "Sources/logic-ax-dump"
        ),
```

  - [ ] **Step 2: Реализация**

`Sources/logic-ax-dump/main.swift`:
```swift
import Foundation
import LogicKit

func err(_ s: String) { FileHandle.standardError.write(Data((s + "\n").utf8)) }

let usage = "usage: logic-ax-dump --out file.json [--depth 40] [--roots mainWindow,menuBar,focusedWindow] [--project name] [--note text] [--timeout 2]"

var out: String?
var depth = 40
var roots = ["mainWindow", "menuBar"]
var project = ""
var note: String?
var timeout: Float = 2.0

var args = Array(CommandLine.arguments.dropFirst())
while !args.isEmpty {
    let flag = args.removeFirst()
    guard let value = args.first else { err(usage); exit(2) }
    args.removeFirst()
    switch flag {
    case "--out": out = value
    case "--depth": depth = Int(value) ?? depth
    case "--roots": roots = value.split(separator: ",").map(String.init)
    case "--project": project = value
    case "--note": note = value
    case "--timeout": timeout = Float(value) ?? timeout
    default: err(usage); exit(2)
    }
}

guard let out else { err(usage); exit(2) }
guard LogicApp.axTrusted else { err("Accessibility is not granted to this terminal"); exit(1) }
guard let pid = LogicApp.pid else { err("Logic Pro is not running"); exit(1) }

let root = LiveAXRoot(pid: pid, timeout: timeout)
var captured: [String: AXSnapshotNode] = [:]
do {
    for name in roots {
        let node: (any AXNode)?
        switch name {
        case "mainWindow": node = try root.mainWindow()
        case "menuBar": node = try root.menuBar()
        case "focusedWindow": node = try root.focusedWindow()
        default: err("unknown root \(name)"); exit(2)
        }
        guard let node else { err("\(name): none"); continue }
        AXStats.shared.reset()
        var stats = CaptureStats()
        let t0 = Date()
        captured[name] = try AXCapture.capture(node, depth: depth, stats: &stats)
        let ms = Int(Date().timeIntervalSince(t0) * 1000)
        err("\(name): nodes=\(stats.nodes) truncated=\(stats.truncatedAt) skipped=\(stats.skipped) ax_messages=\(AXStats.shared.messages) timeouts=\(AXStats.shared.timeouts) ms=\(ms)")
    }
    let fixture = AXFixture(
        meta: .init(logicVersion: LogicApp.version() ?? "unknown",
                    capturedAt: ISO8601DateFormatter().string(from: Date()),
                    project: project, note: note),
        roots: captured)
    try fixture.write(to: URL(fileURLWithPath: out))
    err("wrote \(out)")
} catch {
    err("dump failed: \(error)")
    exit(1)
}
```

  - [ ] **Step 3: Проверка сборки и usage**

Run: `swift build --product logic-ax-dump 2>&1 | tail -2 && .build/debug/logic-ax-dump; echo "exit=$?"`
Expected: сборка ок; печатается usage, `exit=2`.

  - [ ] **Step 4: Проверка против живого Logic (только чтение, безопасно на любом проекте)**

Run: `.build/debug/logic-ax-dump --out /tmp/axdump-smoke.json --depth 3 --roots mainWindow`
Expected: строка `mainWindow: nodes=… ax_messages=…` и `wrote /tmp/axdump-smoke.json`. Если Logic не запущен — `Logic Pro is not running`, exit 1: это тоже корректное поведение. Файл после проверки удалить.

  - [ ] **Step 5: Commit**

```bash
git add Package.swift Sources/logic-ax-dump
git commit -m "logic-ax-dump dev tool"
```

---

### Task 5: WindowSnapshot

**Files:**
  - Create: `Sources/LogicKit/Platform/WindowSnapshot.swift`
  - Test: `Tests/LogicKitTests/WindowSnapshotTests.swift`

**Interfaces:**
  - Consumes: `AXRoot`, `AXAttrs`.
  - Produces:
  - `struct CGWindowRecord: Codable, Hashable, Sendable { number: Int; name: String?; layer: Int; onScreen: Bool; ownerPID: Int32 }`
  - `struct WindowSnapshot: Codable, Equatable, Sendable` — `logicWindows: [CGWindowRecord]`, `mainWindowTitle`, `mainWindowSubrole`, `focusedWindowTitle`, `userFrontmostBundleID: String?`, `userOnScreenWindowNumbers: [Int]`; `static func records(from: [[String: Any]]) -> [CGWindowRecord]`; `static func assemble(all:onScreen:logicPID:main:focused:frontmostBundleID:) -> WindowSnapshot`; `static func capture(logicPID:root:) throws -> WindowSnapshot`; `func diff(to:) -> WindowDiff`
  - `struct WindowDiff: Equatable, Sendable` — `newLogicWindows`, `closedLogicWindows`, `mainWindowChanged`, `userFrontmostChanged`, `userSpaceChanged`, `isClean: Bool`, `summary: String`

  - [ ] **Step 1: Падающие тесты**

`Tests/LogicKitTests/WindowSnapshotTests.swift`:
```swift
import XCTest
import CoreGraphics
@testable import LogicKit

final class WindowSnapshotTests: XCTestCase {
    func win(_ n: Int, pid: Int32, name: String? = nil, layer: Int = 0, on: Bool = true) -> [String: Any] {
        var d: [String: Any] = [kCGWindowNumber as String: n, kCGWindowOwnerPID as String: pid,
                                kCGWindowLayer as String: layer, kCGWindowIsOnscreen as String: on]
        if let name { d[kCGWindowName as String] = name }
        return d
    }

    func testRecordsParseAndSkipMalformed() {
        let recs = WindowSnapshot.records(from: [win(10, pid: 5, name: "Tracks"), [kCGWindowNumber as String: 3]])
        XCTAssertEqual(recs, [CGWindowRecord(number: 10, name: "Tracks", layer: 0, onScreen: true, ownerPID: 5)])
    }

    func testAssembleSplitsLogicAndUserSides() {
        let all = WindowSnapshot.records(from: [win(10, pid: 5), win(11, pid: 5, on: false), win(12, pid: 5, layer: 25), win(20, pid: 9)])
        let on = WindowSnapshot.records(from: [win(10, pid: 5), win(20, pid: 9), win(21, pid: 9, layer: 25)])
        let s = WindowSnapshot.assemble(all: all, onScreen: on, logicPID: 5,
                                        main: AXAttrs(subrole: "AXStandardWindow", title: "fixture-x - Tracks"),
                                        focused: nil, frontmostBundleID: "com.apple.Terminal")
        XCTAssertEqual(s.logicWindows.map(\.number), [10, 11])   // layer-0 only, any Space
        XCTAssertEqual(s.userOnScreenWindowNumbers, [20])        // layer-0, not Logic
        XCTAssertEqual(s.mainWindowTitle, "fixture-x - Tracks")
    }

    func testDiffDetectsNewWindowAndFocusSteal() {
        let before = WindowSnapshot(logicWindows: [CGWindowRecord(number: 10, name: nil, layer: 0, onScreen: false, ownerPID: 5)],
                                    mainWindowTitle: "p", mainWindowSubrole: "AXStandardWindow", focusedWindowTitle: "p",
                                    userFrontmostBundleID: "com.apple.Terminal", userOnScreenWindowNumbers: [20, 21])
        var after = before
        XCTAssertTrue(before.diff(to: after).isClean)
        after.logicWindows.append(CGWindowRecord(number: 44, name: "Search", layer: 0, onScreen: true, ownerPID: 5))
        after.userFrontmostBundleID = LogicApp.bundleID
        after.userOnScreenWindowNumbers = [44]
        let d = before.diff(to: after)
        XCTAssertEqual(d.newLogicWindows.map(\.number), [44])
        XCTAssertTrue(d.userFrontmostChanged)
        XCTAssertTrue(d.userSpaceChanged)
        XCTAssertFalse(d.isClean)
        XCTAssertTrue(d.summary.contains("new logic window 44"))
    }
}
```

  - [ ] **Step 2: Прогнать — падает**

Run: `swift test --filter WindowSnapshotTests 2>&1 | tail -3`
Expected: FAIL — `cannot find 'WindowSnapshot'`.

  - [ ] **Step 3: Реализация**

`Sources/LogicKit/Platform/WindowSnapshot.swift`:
```swift
import AppKit
import CoreGraphics

public struct CGWindowRecord: Codable, Hashable, Sendable {
    public var number: Int
    public var name: String?
    public var layer: Int
    public var onScreen: Bool
    public var ownerPID: Int32

    public init(number: Int, name: String?, layer: Int, onScreen: Bool, ownerPID: Int32) {
        self.number = number; self.name = name; self.layer = layer; self.onScreen = onScreen; self.ownerPID = ownerPID
    }
}

/// Spec §5.4. Logic lives on another Space and AXWindows is often empty, so Logic's windows come from
/// CGWindowList(.optionAll) filtered by PID; the user side comes from on-screen windows of the user's Space.
/// Only layer-0 windows count (tooltips/menus live on higher layers) — ⛳S1 confirms this filter.
public struct WindowSnapshot: Codable, Equatable, Sendable {
    public var logicWindows: [CGWindowRecord]
    public var mainWindowTitle: String?
    public var mainWindowSubrole: String?
    public var focusedWindowTitle: String?
    public var userFrontmostBundleID: String?
    public var userOnScreenWindowNumbers: [Int]

    public init(logicWindows: [CGWindowRecord], mainWindowTitle: String?, mainWindowSubrole: String?,
                focusedWindowTitle: String?, userFrontmostBundleID: String?, userOnScreenWindowNumbers: [Int]) {
        self.logicWindows = logicWindows; self.mainWindowTitle = mainWindowTitle
        self.mainWindowSubrole = mainWindowSubrole; self.focusedWindowTitle = focusedWindowTitle
        self.userFrontmostBundleID = userFrontmostBundleID; self.userOnScreenWindowNumbers = userOnScreenWindowNumbers
    }

    public static func records(from list: [[String: Any]]) -> [CGWindowRecord] {
        list.compactMap { d in
            guard let n = d[kCGWindowNumber as String] as? Int,
                  let pid = d[kCGWindowOwnerPID as String] as? Int32 else { return nil }
            return CGWindowRecord(number: n, name: d[kCGWindowName as String] as? String,
                                  layer: d[kCGWindowLayer as String] as? Int ?? 0,
                                  onScreen: d[kCGWindowIsOnscreen as String] as? Bool ?? false,
                                  ownerPID: pid)
        }
    }

    public static func assemble(all: [CGWindowRecord], onScreen: [CGWindowRecord], logicPID: pid_t,
                                main: AXAttrs?, focused: AXAttrs?, frontmostBundleID: String?) -> WindowSnapshot {
        WindowSnapshot(
            logicWindows: all.filter { $0.ownerPID == logicPID && $0.layer == 0 }.sorted { $0.number < $1.number },
            mainWindowTitle: main?.title, mainWindowSubrole: main?.subrole,
            focusedWindowTitle: focused?.title, userFrontmostBundleID: frontmostBundleID,
            userOnScreenWindowNumbers: onScreen.filter { $0.ownerPID != logicPID && $0.layer == 0 }.map(\.number).sorted())
    }

    /// Live capture. Reads AXMainWindow/AXFocusedWindow, so call it where AX calls are allowed.
    public static func capture(logicPID: pid_t, root: any AXRoot) throws -> WindowSnapshot {
        let all = records(from: CGWindowListCopyWindowInfo([.optionAll], kCGNullWindowID) as? [[String: Any]] ?? [])
        let on = records(from: CGWindowListCopyWindowInfo([.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID) as? [[String: Any]] ?? [])
        return assemble(all: all, onScreen: on, logicPID: logicPID,
                        main: try root.mainWindow()?.attrs(), focused: try root.focusedWindow()?.attrs(),
                        frontmostBundleID: NSWorkspace.shared.frontmostApplication?.bundleIdentifier)
    }

    public func diff(to after: WindowSnapshot) -> WindowDiff {
        let before = Set(logicWindows.map(\.number))
        let now = Set(after.logicWindows.map(\.number))
        let userBefore = Set(userOnScreenWindowNumbers)
        let userAfter = Set(after.userOnScreenWindowNumbers)
        return WindowDiff(
            newLogicWindows: after.logicWindows.filter { !before.contains($0.number) },
            closedLogicWindows: logicWindows.filter { !now.contains($0.number) },
            mainWindowChanged: mainWindowTitle != after.mainWindowTitle || mainWindowSubrole != after.mainWindowSubrole,
            userFrontmostChanged: userFrontmostBundleID != after.userFrontmostBundleID,
            // Heuristic: the user's on-screen windows were fully replaced → their Space changed.
            userSpaceChanged: !userBefore.isEmpty && !userAfter.isEmpty && userBefore.isDisjoint(with: userAfter))
    }
}

public struct WindowDiff: Equatable, Sendable {
    public var newLogicWindows: [CGWindowRecord]
    public var closedLogicWindows: [CGWindowRecord]
    public var mainWindowChanged: Bool
    public var userFrontmostChanged: Bool
    public var userSpaceChanged: Bool

    public var isClean: Bool {
        newLogicWindows.isEmpty && closedLogicWindows.isEmpty && !mainWindowChanged && !userFrontmostChanged && !userSpaceChanged
    }

    public var summary: String {
        var parts: [String] = []
        parts += newLogicWindows.map { "new logic window \($0.number) \($0.name ?? "")" }
        parts += closedLogicWindows.map { "closed logic window \($0.number) \($0.name ?? "")" }
        if mainWindowChanged { parts.append("main window changed") }
        if userFrontmostChanged { parts.append("user frontmost app changed") }
        if userSpaceChanged { parts.append("user space changed") }
        return parts.isEmpty ? "clean" : parts.joined(separator: "; ")
    }
}
```

  - [ ] **Step 4: Прогнать**

Run: `swift test --filter WindowSnapshotTests 2>&1 | tail -3`
Expected: PASS (3).

  - [ ] **Step 5: Commit**

```bash
git add Sources/LogicKit/Platform/WindowSnapshot.swift Tests/LogicKitTests/WindowSnapshotTests.swift
git commit -m "window snapshot across spaces with diff"
```

---

### Task 6: AXExecutor

**Files:**
  - Create: `Sources/LogicKit/Engine/AXExecutor.swift`
  - Test: `Tests/LogicKitTests/AXExecutorTests.swift`

**Interfaces:**
  - Consumes: `AXCallError.timeout` (Task 2).
  - Produces:
  - `enum ExecutorError: Error, Equatable, Sendable { case busy, shutDown }`
  - `final class AXExecutor: Sendable` — `init(config: Config = .init(), now: @escaping @Sendable () -> Double = …, healthProbe: @escaping @Sendable () -> Bool)`; `func read<T: Sendable>(_ body: @escaping @Sendable () throws -> T) async throws -> T`; `func transaction<T: Sendable>(_ body: @escaping @Sendable () throws -> T) async throws -> T`; `var isBusy: Bool`; `var runLoop: CFRunLoop`; `func shutdown()`
  - `AXExecutor.threadName == "logickit.ax"`

Почему не Swift `actor` (спек §5.1): actor реентерабелен на `await`, а AX-вызовы синхронные и блокирующие. Тела работ здесь синхронные и выполняются целиком на одном потоке, поэтому транзакции не перемежаются по построению.

  - [ ] **Step 1: Падающие тесты**

`Tests/LogicKitTests/AXExecutorTests.swift`:
```swift
import XCTest
import os
@testable import LogicKit

final class AXExecutorTests: XCTestCase {
    func expectBusy(_ op: () async throws -> Void, file: StaticString = #filePath, line: UInt = #line) async {
        do { try await op(); XCTFail("expected busy", file: file, line: line) }
        catch ExecutorError.busy {}
        catch { XCTFail("unexpected \(error)", file: file, line: line) }
    }

    func testJobsRunOneAtATimeOnTheAXThread() async throws {
        let ex = AXExecutor(healthProbe: { true })
        let log = OSAllocatedUnfairLock(initialState: [(name: String, start: Double, end: Double)]())
        try await withThrowingTaskGroup(of: Void.self) { group in
            for _ in 0..<8 {
                group.addTask {
                    try await ex.transaction {
                        let s = ProcessInfo.processInfo.systemUptime
                        Thread.sleep(forTimeInterval: 0.01)
                        let e = ProcessInfo.processInfo.systemUptime
                        log.withLock { $0.append((Thread.current.name ?? "", s, e)) }
                    }
                }
            }
            try await group.waitForAll()
        }
        let entries = log.withLock { $0 }.sorted { $0.start < $1.start }
        XCTAssertEqual(entries.count, 8)
        XCTAssertTrue(entries.allSatisfy { $0.name == AXExecutor.threadName })
        for (a, b) in zip(entries, entries.dropFirst()) { XCTAssertLessThanOrEqual(a.end, b.start) }
    }

    func testReturnsValuesAndRethrowsOtherErrors() async throws {
        let ex = AXExecutor(healthProbe: { true })
        let v = try await ex.read { 42 }
        XCTAssertEqual(v, 42)
        do { _ = try await ex.read { () -> Int in throw AXCallError.invalidElement }; XCTFail() }
        catch { XCTAssertEqual(error as? AXCallError, .invalidElement) }
        XCTAssertFalse(ex.isBusy)
    }

    func testTimeoutTurnsBusyUntilProbePasses() async throws {
        let clock = OSAllocatedUnfairLock(initialState: 0.0)
        let healthy = OSAllocatedUnfairLock(initialState: false)
        let ran = OSAllocatedUnfairLock(initialState: 0)
        let ex = AXExecutor(now: { clock.withLock { $0 } }, healthProbe: { healthy.withLock { $0 } })

        await expectBusy { _ = try await ex.read { () -> Int in throw AXCallError.timeout } }
        XCTAssertTrue(ex.isBusy)

        clock.withLock { $0 = 0.5 }                      // before next probe: rejected, body not run
        await expectBusy { _ = try await ex.read { ran.withLock { $0 += 1 } } }
        clock.withLock { $0 = 1.5 }                      // probe runs and fails
        await expectBusy { _ = try await ex.read { ran.withLock { $0 += 1 } } }
        healthy.withLock { $0 = true }
        clock.withLock { $0 = 2.0 }                      // healthy, but next probe is at 2.5
        await expectBusy { _ = try await ex.read { ran.withLock { $0 += 1 } } }
        clock.withLock { $0 = 2.6 }
        let v = try await ex.read { () -> Int in ran.withLock { $0 += 1 }; return 7 }
        XCTAssertEqual(v, 7)
        XCTAssertEqual(ran.withLock { $0 }, 1)
        XCTAssertFalse(ex.isBusy)
    }
}
```

  - [ ] **Step 2: Прогнать — падает**

Run: `swift test --filter AXExecutorTests 2>&1 | tail -3`
Expected: FAIL — `cannot find 'AXExecutor'`.

  - [ ] **Step 3: Реализация**

`Sources/LogicKit/Engine/AXExecutor.swift`:
```swift
import Foundation
import os

public enum ExecutorError: Error, Equatable, Sendable {
    case busy
    case shutDown
}

/// Spec §5.1: every AX call runs on one dedicated thread with its own CFRunLoop (AXObserver sources
/// attach here later). Jobs are synchronous closures executed FIFO, so a transaction — including its
/// verify waits — can never interleave with another job. A call that times out marks Logic busy:
/// later jobs fail fast with `.busy` until a health probe (at most once per `busyProbeInterval`) passes.
public final class AXExecutor: @unchecked Sendable {
    public static let threadName = "logickit.ax"

    public struct Config: Sendable {
        public var busyProbeInterval: Double = 1.0
        public init() {}
    }

    private final class AXThread: Thread, @unchecked Sendable {
        var runLoop: CFRunLoop?
        let ready = DispatchSemaphore(value: 0)

        override func main() {
            runLoop = CFRunLoopGetCurrent()
            var ctx = CFRunLoopSourceContext()
            let keepAlive = CFRunLoopSourceCreate(nil, 0, &ctx)
            CFRunLoopAddSource(runLoop, keepAlive, .defaultMode)
            ready.signal()
            while !isCancelled {
                _ = CFRunLoopRunInMode(.defaultMode, 0.5, false)
            }
        }
    }

    private struct BusyState {
        var busy = false
        var nextProbe = 0.0
    }

    private let thread = AXThread()
    private let config: Config
    private let probe: @Sendable () -> Bool
    private let now: @Sendable () -> Double
    private let state = OSAllocatedUnfairLock(initialState: BusyState())

    public init(config: Config = .init(),
                now: @escaping @Sendable () -> Double = { ProcessInfo.processInfo.systemUptime },
                healthProbe: @escaping @Sendable () -> Bool) {
        self.config = config
        self.probe = healthProbe
        self.now = now
        thread.name = Self.threadName
        thread.start()
        thread.ready.wait()
    }

    public var runLoop: CFRunLoop { thread.runLoop! }
    public var isBusy: Bool { state.withLock { $0.busy } }

    /// Short slot: a single read (or one poll iteration).
    public func read<T: Sendable>(_ body: @escaping @Sendable () throws -> T) async throws -> T {
        try await submit(body)
    }

    /// Mutation transaction: runs to completion on the AX thread; nothing else runs in between.
    public func transaction<T: Sendable>(_ body: @escaping @Sendable () throws -> T) async throws -> T {
        try await submit(body)
    }

    public func shutdown() {
        thread.cancel()
        CFRunLoopWakeUp(runLoop)
    }

    private func submit<T: Sendable>(_ body: @escaping @Sendable () throws -> T) async throws -> T {
        guard !thread.isCancelled else { throw ExecutorError.shutDown }
        let loop = runLoop
        return try await withCheckedThrowingContinuation { (cont: CheckedContinuation<T, Error>) in
            CFRunLoopPerformBlock(loop, CFRunLoopMode.defaultMode.rawValue) {
                cont.resume(with: Result { try self.run(body) })
            }
            CFRunLoopWakeUp(loop)
        }
    }

    private func run<T>(_ body: () throws -> T) throws -> T {
        let t = now()
        let interval = config.busyProbeInterval
        // nil → run normally; false → reject; true → probe first
        let gate: Bool? = state.withLock { s in
            guard s.busy else { return nil }
            if t < s.nextProbe { return false }
            s.nextProbe = t + interval
            return true
        }
        if gate == false { throw ExecutorError.busy }
        if gate == true {
            guard probe() else { throw ExecutorError.busy }
            state.withLock { $0.busy = false }
        }
        do {
            return try body()
        } catch AXCallError.timeout {
            let t2 = now()
            state.withLock { $0.busy = true; $0.nextProbe = t2 + interval }
            throw ExecutorError.busy
        }
    }
}
```

  - [ ] **Step 4: Прогнать**

Run: `swift test --filter AXExecutorTests 2>&1 | tail -3`
Expected: PASS (3). Предупреждения Swift 6 о `Sendable` у замыканий `CFRunLoopPerformBlock` допустимы; ошибки — нет.

  - [ ] **Step 5: Commit**

```bash
git add Sources/LogicKit/Engine/AXExecutor.swift Tests/LogicKitTests/AXExecutorTests.swift
git commit -m "ax executor: dedicated runloop thread, fifo jobs, busy breaker"
```

---

# Phase B — P0: спайки

Общие правила спайков:
  - Любая мутация — только в копии `fixture-*` (probe сам откажется иначе). Свой проект пользователь перед спайками сохраняет и закрывает (👤).
  - Каждый спайк записывается в `docs/superpowers/specs/spikes-2026-09.md` в своём разделе по шаблону: **Вопрос → Команды → Наблюдения (сырой вывод, сокращённо) → Ответ (🟢/🟡/🔴) → Решение для спека → Якоря** (точные AX-строки, найденные в спайке).
  - Спайковый код, кроме `logic-probe`, не сохраняется. Сам `logic-probe` остаётся dev-инструментом для будущих рецептов.
  - Сборка перед спайками: `swift build --product logic-probe --product logic-ax-dump`.

### Task 7: `logic-probe`, локатор, меню-пути, копии проектов

**Files:**
  - Create: `Sources/LogicKit/Platform/AXLocator.swift`, `Sources/LogicKit/Platform/MenuPath.swift`
  - Modify: `Sources/LogicKit/Platform/LiveAXNode.swift` (добавить `attributeNames()`, `rawAttribute(_:)`, `setRaw(_:bool:)`)
  - Create: `Sources/logic-probe/main.swift`, `Sources/logic-probe/Observe.swift`, `Sources/logic-probe/MIDIProbe.swift`
  - Create: `Scripts/fixture-open.sh`, `Scripts/make-big-midi.py`, `Tests/Fixtures/projects/README.md`, `docs/superpowers/specs/spikes-2026-09.md`
  - Modify: `.gitignore`, `Package.swift`
  - Test: `Tests/LogicKitTests/AXLocatorTests.swift`

**Interfaces:**
  - Consumes: `AXMatch`, `AXNode.allDescendants`, `AXNode.firstChild`, `LiveAXRoot`, `WindowSnapshot`, `FixtureGuard`, `AXStats`, `AXCapture` (Tasks 2–5).
  - Produces:
  - `struct AXLocator: Equatable, Sendable { struct Step { match: AXMatch; index: Int }; steps: [Step]; static func parse(_:) throws -> AXLocator; func resolve(from:maxDepth:) throws -> (any AXNode)?; func resolveAll(from:maxDepth:) throws -> [any AXNode] }`
  - `struct LocatorError: Error, Equatable, CustomStringConvertible { message: String }`
  - `enum MenuPath { static func split(_:) -> [String]; static func resolve(menuBar:path:) throws -> (any AXNode)? }`, где `^` в начале компонента означает префикс заголовка
  - `LiveAXNode.attributeNames() throws -> [String]`, `rawAttribute(_ name: String) throws -> String?`, `setRaw(_ name: String, bool: Bool) throws`
  - CLI `logic-probe` (команды в `usage` ниже)

Синтаксис локатора: шаги разделены `" > "`. Шаг — поля `key OP value`, разделённые `;`. Опциональный суффикс `[N]` — N-е совпадение (с 0). Ключи: `role subrole title desc help id value`. OP: `=` (равно), `^=` (префикс), `~=` (содержит). Каждый шаг ищет в потомках предыдущего совпадения. `;` и `[N]` выбраны потому, что запятые и `#` встречаются в описаниях Logic (`Track 3 “Warm Vocal”, Take`, `Audio 1#07`).

  - [ ] **Step 1: Падающие тесты локатора и меню**

`Tests/LogicKitTests/AXLocatorTests.swift`:
```swift
import XCTest
@testable import LogicKit

final class AXLocatorTests: XCTestCase {
    func root() throws -> FixtureAXRoot { FixtureAXRoot(try AXFixture.load(Fixtures.url("ax/mini.json"))) }

    func testParseStepsOpsAndIndex() throws {
        let loc = try AXLocator.parse("role=AXGroup;desc=Tracks header > desc^=Track 3 “Warm Vocal”, Take[1]")
        XCTAssertEqual(loc.steps.count, 2)
        XCTAssertEqual(loc.steps[0].match, AXMatch(role: "AXGroup", desc: .equals("Tracks header")))
        XCTAssertEqual(loc.steps[1].match, AXMatch(desc: .prefix("Track 3 “Warm Vocal”, Take")))
        XCTAssertEqual(loc.steps[1].index, 1)
        XCTAssertEqual(try AXLocator.parse("title~=Undo").steps[0].match, AXMatch(title: .contains("Undo")))
    }

    func testParseRejectsBadFields() {
        XCTAssertThrowsError(try AXLocator.parse("colour=red"))
        XCTAssertThrowsError(try AXLocator.parse("role"))
        XCTAssertThrowsError(try AXLocator.parse("role^=AX"))   // role/subrole/id accept only '='
    }

    func testResolve() throws {
        let main = try XCTUnwrap(try root().mainWindow())
        let row = try XCTUnwrap(AXLocator.parse("desc=Tracks header > desc^=Track 2").resolve(from: main))
        XCTAssertEqual(try row.attrs().desc, "Track 2 “Rose Vocal”")
        let mutes = try AXLocator.parse("desc=Tracks header > desc=Mute").resolveAll(from: main)
        XCTAssertEqual(mutes.count, 2)
        XCTAssertNil(try AXLocator.parse("desc=Nope").resolve(from: main))
        XCTAssertNil(try AXLocator.parse("desc=Mute[5]").resolve(from: main))
    }

    func testMenuPath() throws {
        let bar = try XCTUnwrap(try root().menuBar())
        XCTAssertEqual(MenuPath.split("Edit > ^Undo"), ["Edit", "^Undo"])
        let undo = try XCTUnwrap(MenuPath.resolve(menuBar: bar, path: ["Edit", "^Undo"]))
        XCTAssertEqual(try undo.attrs().title, "Undo Insert Plug-in")
        let redo = try XCTUnwrap(MenuPath.resolve(menuBar: bar, path: ["Edit", "Redo"]))
        XCTAssertEqual(try redo.attrs().enabled, false)
        XCTAssertNil(try MenuPath.resolve(menuBar: bar, path: ["File", "Open"]))
    }
}
```

  - [ ] **Step 2: Прогнать — падает**

Run: `swift test --filter AXLocatorTests 2>&1 | tail -3`
Expected: FAIL — `cannot find 'AXLocator'`.

  - [ ] **Step 3: Реализация LogicKit-частей**

`Sources/LogicKit/Platform/AXLocator.swift`:
```swift
import Foundation

public struct LocatorError: Error, Equatable, CustomStringConvertible {
    public let message: String
    public init(_ message: String) { self.message = message }
    public var description: String { message }
}

public struct AXLocator: Equatable, Sendable {
    public struct Step: Equatable, Sendable {
        public var match: AXMatch
        public var index: Int
    }

    public var steps: [Step]

    public static func parse(_ s: String) throws -> AXLocator {
        var steps: [Step] = []
        for raw in s.components(separatedBy: " > ") {
            var text = raw.trimmingCharacters(in: .whitespaces)
            var index = 0
            if let r = text.range(of: #"\[(\d+)\]$"#, options: .regularExpression) {
                index = Int(text[r].dropFirst().dropLast())!
                text.removeSubrange(r)
            }
            var m = AXMatch()
            for field in text.split(separator: ";") {
                let (key, op, value) = try split(String(field))
                let o: AXMatch.Op = op == "^=" ? .prefix(value) : op == "~=" ? .contains(value) : .equals(value)
                switch key {
                case "role", "subrole", "id":
                    guard op == "=" else { throw LocatorError("\(key) accepts only '='") }
                    if key == "role" { m.role = value } else if key == "subrole" { m.subrole = value } else { m.identifier = value }
                case "title": m.title = o
                case "desc": m.desc = o
                case "help": m.help = o
                case "value": m.value = o
                default: throw LocatorError("unknown key \(key)")
                }
            }
            steps.append(Step(match: m, index: index))
        }
        return AXLocator(steps: steps)
    }

    private static func split(_ field: String) throws -> (String, String, String) {
        for op in ["^=", "~=", "="] {
            if let r = field.range(of: op) {
                let key = field[..<r.lowerBound].trimmingCharacters(in: .whitespaces)
                return (key, op, String(field[r.upperBound...]))
            }
        }
        throw LocatorError("bad field '\(field)': expected key=value, key^=value or key~=value")
    }

    public func resolve(from root: any AXNode, maxDepth: Int = 12) throws -> (any AXNode)? {
        var current: any AXNode = root
        for step in steps {
            let hits = try current.allDescendants(step.match, maxDepth: maxDepth)
            guard step.index < hits.count else { return nil }
            current = hits[step.index]
        }
        return current
    }

    /// All matches of the last step under the node chosen by the previous steps.
    public func resolveAll(from root: any AXNode, maxDepth: Int = 12) throws -> [any AXNode] {
        guard let last = steps.last else { return [] }
        guard let parent = try AXLocator(steps: Array(steps.dropLast())).resolve(from: root, maxDepth: maxDepth) else { return [] }
        return try parent.allDescendants(last.match, maxDepth: maxDepth)
    }
}
```

`Sources/LogicKit/Platform/MenuPath.swift`:
```swift
import Foundation

/// "Edit>^Undo": menu-bar title, then item titles; a leading "^" matches a title prefix.
public enum MenuPath {
    public static func split(_ s: String) -> [String] {
        s.split(separator: ">").map { $0.trimmingCharacters(in: .whitespaces) }
    }

    public static func resolve(menuBar: any AXNode, path: [String]) throws -> (any AXNode)? {
        var current: any AXNode = menuBar
        for (i, component) in path.enumerated() {
            let op: AXMatch.Op = component.hasPrefix("^") ? .prefix(String(component.dropFirst())) : .equals(component)
            let items: [any AXNode]
            if i == 0 {
                items = try current.children()
            } else {
                guard let menu = try current.firstChild(AXMatch(role: "AXMenu")) else { return nil }
                items = try menu.children()
            }
            guard let next = try items.first(where: { op.test(try $0.attrs().title) }) else { return nil }
            current = next
        }
        return current
    }
}
```

В `LiveAXNode` (перед `identityToken`) добавить:
```swift
    public func attributeNames() throws -> [String] {
        var names: CFArray?
        AXStats.shared.message()
        try axCheck(AXUIElementCopyAttributeNames(element, &names))
        return (names as? [String]) ?? []
    }

    /// Any attribute rendered with `String(describing:)` — for spikes (AXFrame, AXPosition, …).
    public func rawAttribute(_ name: String) throws -> String? {
        var raw: AnyObject?
        AXStats.shared.message()
        let err = AXUIElementCopyAttributeValue(element, name as CFString, &raw)
        if err == .noValue || err == .attributeUnsupported { return nil }
        try axCheck(err)
        return raw.map { String(describing: $0) }
    }

    public func setRaw(_ name: String, bool: Bool) throws {
        AXStats.shared.message()
        try axCheck(AXUIElementSetAttributeValue(element, name as CFString, (bool ? kCFBooleanTrue : kCFBooleanFalse)!))
    }
```

  - [ ] **Step 4: Тесты локатора проходят**

Run: `swift test --filter AXLocatorTests 2>&1 | tail -3`
Expected: PASS (4).

  - [ ] **Step 5: Таргет `logic-probe`**

В `Package.swift`: в `products` добавить `.executable(name: "logic-probe", targets: ["logic-probe"]),`, в `targets`:
```swift
        .executableTarget(
            name: "logic-probe",
            dependencies: ["LogicKit"],
            path: "Sources/logic-probe",
            linkerSettings: [.linkedFramework("CoreMIDI")]
        ),
```

`Sources/logic-probe/main.swift`:
```swift
import ApplicationServices
import Foundation
import LogicKit

func err(_ s: String) { FileHandle.standardError.write(Data((s + "\n").utf8)) }
func fail(_ s: String, code: Int32 = 1) -> Never { err(s); exit(code) }

let usage = """
usage: logic-probe <command> [args] [--root main|menubar|focused|app] [--timeout 1]
 read-only:
  tree [--at LOC] [--depth 3]      subtree, one compactLine per node
  find LOC                         all matches of LOC's last step, with [index]
  attrs LOC                        compactLine + all attribute names
  raw LOC NAME                     any attribute (AXFrame, AXPosition, AXDocument…)
  windows                          WindowSnapshot JSON
  stats [--depth 40]               capture: nodes, ms, AX messages, timeouts
  menu PATH                        "Edit>^Undo": print the item (no press)
  observe [--at LOC] [--for 10] [--notifications a,b]
 mutating (only when the main window is a fixture- project):
  press LOC · set LOC TEXT · setnum LOC NUMBER · setbool LOC ATTR true|false
  inc LOC [N] · dec LOC [N] · menu PATH --press · action LOC AXName
  mmc play|stop|locate HH:MM:SS:FF · cc CHANNEL CONTROLLER VALUE
LOC: steps joined by " > "; step = key OP value;…[N]; keys role subrole title desc help id value; OP = ^= ~=
"""

var args = Array(CommandLine.arguments.dropFirst())
guard !args.isEmpty else { fail(usage, code: 2) }
let cmd = args.removeFirst()

func option(_ name: String) -> String? {
    guard let i = args.firstIndex(of: name), i + 1 < args.count else { return nil }
    let v = args[i + 1]
    args.removeSubrange(i...(i + 1))
    return v
}
func flag(_ name: String) -> Bool {
    guard let i = args.firstIndex(of: name) else { return false }
    args.remove(at: i)
    return true
}
func arg(_ i: Int) -> String {
    guard i < args.count else { fail(usage, code: 2) }
    return args[i]
}

guard LogicApp.axTrusted else { fail("Accessibility is not granted to this terminal") }
guard let pid = LogicApp.pid else { fail("Logic Pro is not running") }
let rootName = option("--root")
let root = LiveAXRoot(pid: pid, timeout: Float(option("--timeout") ?? "") ?? 1.0)

func base() throws -> any AXNode {
    switch rootName ?? "main" {
    case "main": guard let n = try root.mainWindow() else { fail("no main window") }; return n
    case "menubar": guard let n = try root.menuBar() else { fail("no menu bar") }; return n
    case "focused": guard let n = try root.focusedWindow() else { fail("no focused window") }; return n
    case "app": return root.appNode
    default: fail("unknown root \(rootName ?? "")", code: 2)
    }
}
func locate(_ loc: String) throws -> LiveAXNode {
    guard let n = try AXLocator.parse(loc).resolve(from: try base()) as? LiveAXNode else { fail("not found: \(loc)") }
    return n
}
func requireFixture() throws {
    let title = try root.mainWindow()?.attrs().title
    guard FixtureGuard.allows(mainWindowTitle: title) else {
        fail("refusing to mutate: main window is \(title ?? "nil"), expected a fixture- project")
    }
}
func ms(_ t0: Date) -> Int { Int(Date().timeIntervalSince(t0) * 1000) }
func shown(_ n: any AXNode) -> String? {
    guard let a = try? n.attrs() else { return "<gone>" }
    return a.valueDescription ?? a.value?.stringValue
}
/// Polls every 10 ms until the displayed value differs from `old` (or 1 s passes).
func waitChange(_ n: any AXNode, from old: String?) -> (String?, Int) {
    let t0 = Date()
    while Date().timeIntervalSince(t0) < 1.0 {
        let now = shown(n)
        if now != old { return (now, ms(t0)) }
        Thread.sleep(forTimeInterval: 0.01)
    }
    return (old, ms(t0))
}
func printTree(_ n: any AXNode, depth: Int, indent: Int = 0) throws {
    print(String(repeating: "  ", count: indent) + (try n.attrs().compactLine))
    guard depth > 0 else { return }
    for c in try n.children() { try printTree(c, depth: depth - 1, indent: indent + 1) }
}

do {
    switch cmd {
    case "tree":
        let depth = Int(option("--depth") ?? "") ?? 3
        let node: any AXNode = try option("--at").map { try locate($0) } ?? (try base())
        try printTree(node, depth: depth)
    case "find":
        let hits = try AXLocator.parse(arg(0)).resolveAll(from: try base())
        for (i, h) in hits.enumerated() { print("[\(i)] " + (try h.attrs().compactLine)) }
        print("matches: \(hits.count)")
    case "attrs":
        let n = try locate(arg(0))
        print(try n.attrs().compactLine)
        print("attributes: " + (try n.attributeNames()).joined(separator: ", "))
    case "raw":
        print(try locate(arg(0)).rawAttribute(arg(1)) ?? "<none>")
    case "windows":
        let e = JSONEncoder()
        e.outputFormatting = [.prettyPrinted, .sortedKeys]
        print(String(decoding: try e.encode(try WindowSnapshot.capture(logicPID: pid, root: root)), as: UTF8.self))
    case "stats":
        let depth = Int(option("--depth") ?? "") ?? 40
        AXStats.shared.reset()
        var s = CaptureStats()
        let t0 = Date()
        _ = try AXCapture.capture(try base(), depth: depth, stats: &s)
        print("nodes=\(s.nodes) truncated=\(s.truncatedAt) skipped=\(s.skipped) ax_messages=\(AXStats.shared.messages) timeouts=\(AXStats.shared.timeouts) ms=\(ms(t0))")
    case "menu":
        let press = flag("--press")
        guard let bar = try root.menuBar(),
              let item = try MenuPath.resolve(menuBar: bar, path: MenuPath.split(arg(0))) else { fail("menu not found: \(arg(0))") }
        print(try item.attrs().compactLine)
        if press {
            try requireFixture()
            let t0 = Date()
            try item.perform("AXPress")
            print("pressed in \(ms(t0)) ms")
        }
    case "press", "action":
        try requireFixture()
        let n = try locate(arg(0))
        let name = cmd == "press" ? "AXPress" : arg(1)
        let before = shown(n)
        let t0 = Date()
        try n.perform(name)
        let (after, waited) = waitChange(n, from: before)
        print("\(name): \(before ?? "-") → \(after ?? "-") (call \(ms(t0)) ms, change seen after \(waited) ms)")
    case "set", "setnum":
        try requireFixture()
        let n = try locate(arg(0))
        if cmd == "setnum" && Double(arg(1)) == nil { fail("not a number: \(arg(1))") }
        let value: AXScalar = cmd == "setnum" ? .number(Double(arg(1))!) : .string(arg(1))
        let before = shown(n)
        let t0 = Date()
        try n.set(kAXValueAttribute, value)
        if cmd == "set", (try n.attrs().actions).contains("AXConfirm") { try n.perform("AXConfirm") }
        let (after, waited) = waitChange(n, from: before)
        print("set \(value.stringValue): \(before ?? "-") → \(after ?? "-") (\(ms(t0)) ms, change after \(waited) ms)")
    case "setbool":
        try requireFixture()
        let n = try locate(arg(0))
        try n.setRaw(arg(1), bool: arg(2) == "true")
        print("\(arg(1)) := \(arg(2)); now \(try n.rawAttribute(arg(1)) ?? "<none>")")
    case "inc", "dec":
        try requireFixture()
        let n = try locate(arg(0))
        let count = args.count > 1 ? Int(arg(1)) ?? 1 : 1
        for i in 1...count {
            let before = shown(n)
            try n.perform(cmd == "inc" ? "AXIncrement" : "AXDecrement")
            let (after, waited) = waitChange(n, from: before)
            print("\(i): \(before ?? "-") → \(after ?? "-") (\(waited) ms)")
        }
    case "observe":
        let seconds = Double(option("--for") ?? "") ?? 10
        let names = option("--notifications")?.split(separator: ",").map(String.init)
        let target = try option("--at").map { try locate($0).element } ?? root.appNode.element
        try observe(pid: pid, target: target, names: names, seconds: seconds)
    case "mmc":
        try requireFixture()
        try sendMMC(Array(args))
    case "cc":
        try requireFixture()
        try sendCC(channel: UInt8(arg(0)) ?? 1, controller: UInt8(arg(1)) ?? 0, value: UInt8(arg(2)) ?? 0)
    default:
        fail(usage, code: 2)
    }
} catch {
    fail("error: \(error)")
}
```

`Sources/logic-probe/Observe.swift`:
```swift
import ApplicationServices
import Foundation
import LogicKit

/// Spike S2: which AX notifications Logic actually sends.
func observe(pid: pid_t, target: AXUIElement, names: [String]?, seconds: Double) throws {
    let wanted = names ?? [
        kAXValueChangedNotification, kAXFocusedUIElementChangedNotification, kAXFocusedWindowChangedNotification,
        kAXMainWindowChangedNotification, kAXWindowCreatedNotification, kAXUIElementDestroyedNotification,
        kAXTitleChangedNotification, kAXSelectedChildrenChangedNotification, kAXSelectedRowsChangedNotification,
        kAXLayoutChangedNotification, kAXCreatedNotification,
    ]
    var observer: AXObserver?
    let status = AXObserverCreate(pid, { _, element, name, _ in
        let line = (try? LiveAXNode(element).attrs())?.compactLine ?? "?"
        print(String(format: "%.3f ", Date().timeIntervalSince1970) + (name as String) + " " + line)
        fflush(stdout)
    }, &observer)
    guard status == .success, let observer else { throw AXCallError.failure(status.rawValue) }
    for n in wanted {
        let r = AXObserverAddNotification(observer, target, n as CFString, nil)
        print("subscribe \(n): \(r == .success ? "ok" : "AXError \(r.rawValue)")")
    }
    CFRunLoopAddSource(CFRunLoopGetCurrent(), AXObserverGetRunLoopSource(observer), .defaultMode)
    print("observing for \(Int(seconds)) s…")
    fflush(stdout)
    CFRunLoopRunInMode(.defaultMode, seconds, false)
}
```

`Sources/logic-probe/MIDIProbe.swift`:
```swift
import CoreMIDI
import Foundation

/// Spikes S6/S11: a virtual source with the same name the server uses.
private func withSource(_ body: (MIDIEndpointRef) -> Void) throws {
    var client = MIDIClientRef()
    var status = MIDIClientCreate("logic-probe" as CFString, nil, nil, &client)
    guard status == noErr else { throw NSError(domain: "midi", code: Int(status)) }
    var source = MIDIEndpointRef()
    status = MIDISourceCreate(client, "LogicProMCP-Out" as CFString, &source)
    guard status == noErr else { throw NSError(domain: "midi", code: Int(status)) }
    Thread.sleep(forTimeInterval: 1.0)   // let Logic notice the new source
    body(source)
    Thread.sleep(forTimeInterval: 0.5)
    MIDIEndpointDispose(source)
    MIDIClientDispose(client)
}

private func send(_ bytes: [UInt8], via source: MIDIEndpointRef) {
    var list = MIDIPacketList()
    let packet = MIDIPacketListInit(&list)
    _ = MIDIPacketListAdd(&list, MemoryLayout<MIDIPacketList>.size, packet, 0, bytes.count, bytes)
    MIDIReceived(source, &list)
}

func sendMMC(_ args: [String]) throws {
    guard let command = args.first else { throw NSError(domain: "usage: mmc play|stop|locate HH:MM:SS:FF", code: 2) }
    let bytes: [UInt8]
    switch command {
    case "play": bytes = [0xF0, 0x7F, 0x7F, 0x06, 0x02, 0xF7]
    case "stop": bytes = [0xF0, 0x7F, 0x7F, 0x06, 0x01, 0xF7]
    case "locate":
        let parts = (args.dropFirst().first ?? "00:00:00:00").split(separator: ":").compactMap { UInt8($0) }
        guard parts.count == 4 else { throw NSError(domain: "locate expects HH:MM:SS:FF", code: 2) }
        bytes = [0xF0, 0x7F, 0x7F, 0x06, 0x44, 0x06, 0x01, parts[0], parts[1], parts[2], parts[3], 0x00, 0xF7]
    default: throw NSError(domain: "unknown mmc command \(command)", code: 2)
    }
    try withSource { send(bytes, via: $0) }
    print("sent MMC \(command): " + bytes.map { String(format: "%02X", $0) }.joined(separator: " "))
}

func sendCC(channel: UInt8, controller: UInt8, value: UInt8) throws {
    let status = 0xB0 | ((max(channel, 1) - 1) & 0x0F)
    try withSource { send([status, controller & 0x7F, value & 0x7F], via: $0) }
    print("sent CC ch\(channel) #\(controller) = \(value)")
}
```

  - [ ] **Step 6: Скрипты фикстур и gitignore**

В `.gitignore` добавить:
```
/Tests/Fixtures/projects/*
!/Tests/Fixtures/projects/README.md
```

`Tests/Fixtures/projects/README.md`:
```markdown
# Project fixtures (gitignored)
- `fixture-belo-krasny.logicx` — копия «бело красный» (5 треков, стек, take folder ~20 дублей, цепочка 5 плагинов).
- `fixture-big.logicx` — 40+ треков, 3 стека, 2 take folder, 8 aux, 20 маркеров, регионы за правым краем экрана.
Не открывать напрямую: `Scripts/fixture-open.sh <name>` копирует во временную папку и открывает копию.
```

`Scripts/fixture-open.sh`:
```bash
#!/bin/zsh
# usage: Scripts/fixture-open.sh belo-krasny|big — opens a throwaway copy of a fixture project
set -euo pipefail
name="fixture-$1"
repo="$(cd "$(dirname "$0")/.." && pwd)"
src="$repo/Tests/Fixtures/projects/$name.logicx"
[[ -d "$src" ]] || { echo "missing $src" >&2; exit 1; }
work="${TMPDIR:-/tmp}/logic-fixtures"
mkdir -p "$work"
rm -rf "$work/$name.logicx"
ditto "$src" "$work/$name.logicx"
open -a "Logic Pro" "$work/$name.logicx"
echo "$work/$name.logicx"
```

`Scripts/make-big-midi.py`:
```python
#!/usr/bin/env python3
"""40-track SMF for the 'big' fixture.
Tracks T01-T20 play bars 1-4; T21-T40 play bars 180-183 (right of the screen at default zoom).
The conductor track has 20 markers (M1..M20), one every 8 bars."""
import struct
import sys

PPQ = 480
BAR = PPQ * 4


def vlq(n):
    out = [n & 0x7F]
    n >>= 7
    while n:
        out.insert(0, (n & 0x7F) | 0x80)
        n >>= 7
    return bytes(out)


def meta(kind, payload):
    return bytes([0xFF, kind]) + vlq(len(payload)) + payload


def track(events):
    events.sort(key=lambda e: e[0])
    data, last = b"", 0
    for tick, ev in events:
        data += vlq(tick - last) + ev
        last = tick
    data += vlq(0) + b"\xff\x2f\x00"
    return b"MTrk" + struct.pack(">I", len(data)) + data


conductor = [(0, meta(0x51, (500000).to_bytes(3, "big"))), (0, meta(0x58, bytes([4, 2, 24, 8])))]
conductor += [(m * 8 * BAR, meta(0x06, f"M{m + 1}".encode())) for m in range(20)]
tracks = [track(conductor)]
for i in range(40):
    ch, note = i % 16, 48 + (i % 24)
    first_bar = 0 if i < 20 else 179
    ev = [(0, meta(0x03, f"T{i + 1:02d}".encode()))]
    for b in range(first_bar, first_bar + 4):
        ev.append((b * BAR, bytes([0x90 | ch, note, 96])))
        ev.append((b * BAR + BAR - 1, bytes([0x80 | ch, note, 0])))
    tracks.append(track(ev))

out = sys.argv[1] if len(sys.argv) > 1 else "big.mid"
with open(out, "wb") as f:
    f.write(b"MThd" + struct.pack(">IHHH", 6, 1, len(tracks), PPQ) + b"".join(tracks))
print(out)
```

Run: `chmod +x Scripts/fixture-open.sh Scripts/make-big-midi.py && python3 Scripts/make-big-midi.py /tmp/big.mid && xxd /tmp/big.mid | head -2`
Expected: `/tmp/big.mid`; первая строка дампа начинается с `4d54 6864` (`MThd`).

  - [ ] **Step 7: Документ спайков**

`docs/superpowers/specs/spikes-2026-09.md`:
```markdown
# P0 спайки — результаты (2026-09)

Logic Pro: <версия из `LogicApp.version()`> · macOS 15 · Logic на отдельном Space, пользователь в Terminal.
Шаблон раздела: Вопрос → Команды → Наблюдения → Ответ (🟢/🟡/🔴) → Решение для спека → Якоря.

## Сводка
| Спайк | Ответ | Решение |
|---|---|---|

## S12 Полнота и цена AX
## S3 Регионы и take folder
## S6 Шаги и точность параметров
## S8 Невидимый select и возврат
## S9 Меню-бар и заголовок undo
## S1 Окна и фокус
## S11 Транспорт через control bar и MMC
## S2 AXObserver
## S4 Импорт/экспорт MIDI
## S5 Вложенные popup
## S7 Слот Search and Add
## S10 Источник аудио

## Ground truth «бело красного» (по UI Logic, глазами)
| № | Имя в UI | Тип | Выход есть? | Дублей |
|---|---|---|---|---|

## Якоря (вход для LocaleTable.en)
| Anchor | Строка | Где (роль/атрибут) | Спайк |
|---|---|---|---|
```

  - [ ] **Step 8: Сборка, smoke-проверка, копия проекта**

Run: `swift build --product logic-probe 2>&1 | tail -2 && .build/debug/logic-probe 2>&1 | head -3`
Expected: сборка ок; печатается usage.

👤 Пользователь сохраняет и закрывает свой проект. Исполнитель находит оригинал «бело красный»:
Run: `mdfind 'kMDItemFSName == "*.logicx"c' | grep -i -E "бело|красн|baby|бэйби"`
Для найденного пути `P`: `ditto "P" Tests/Fixtures/projects/fixture-belo-krasny.logicx`. Если найдено несколько кандидатов — спросить пользователя, какой из них.

Run: `Scripts/fixture-open.sh belo-krasny && sleep 15 && .build/debug/logic-probe tree --depth 0`
Expected: строка `AXWindow … t="fixture-belo-krasny…"`. Если заголовок другой (Logic берёт имя из самого проекта) — 👤 в копии: File › Save As… → `fixture-belo-krasny` в `Tests/Fixtures/projects/` (перезаписать), затем повторить.

Run: `.build/debug/logic-probe find 'desc=Tracks header > desc^=Track '`
Expected: список строк треков; ни одной мутации.

  - [ ] **Step 9: Commit**

```bash
git add Package.swift .gitignore Sources/LogicKit/Platform Sources/logic-probe Scripts Tests/Fixtures/projects/README.md Tests/LogicKitTests/AXLocatorTests.swift docs/superpowers/specs/spikes-2026-09.md
git commit -m "logic-probe, locator, menu paths, fixture scripts"
```

---

### Task 8: S12 — полнота и цена AX; запись фикстур

**Files:**
  - Create: `Tests/Fixtures/ax/big.json`, `Tests/Fixtures/ax/belo-krasny.json`
  - Modify: `docs/superpowers/specs/spikes-2026-09.md` (раздел S12, ground truth, якоря)

**Interfaces:**
  - Produces: записанные фикстуры (их потребляют Tasks 21, 24); ответ S12 (§4.6, §5.1, §7).

  - [ ] **Step 1: 👤 Создать «big»**

Исполнитель запускает `python3 Scripts/make-big-midi.py /tmp/big.mid` и даёт пользователю чек-лист:
  1. File › New → Empty Project → один Software Instrument трек.
  2. File › Import › MIDI File… → `/tmp/big.mid`. Появятся 40 треков `T01…T40` (и маркеры `M1…M20`, если Logic их импортирует).
  3. Три стека: выделить T01–T04 → Track › Create Track Stack (Summing); то же для T05–T08 и T09–T12 (Folder).
  4. Восемь aux-треков (любым способом, например посылы с T13–T20 на Bus 1…8 и затем Mix › Create Tracks for Selected Channel Strips).
  5. Два take folder: audio-трек, cycle на такты 1–3, записать три прохода подряд (тишина подойдёт); повторить на втором audio-треке.
  6. Если маркеры не импортировались — 20 маркеров вручную (Navigate › Create Marker) на тактах 1, 9, 17, …
  7. File › Save As… → `Tests/Fixtures/projects/fixture-big.logicx`, с копированием аудио.

  - [ ] **Step 2: Цена полного чтения**

Run: `Scripts/fixture-open.sh big && sleep 20 && for i in 1 2 3; do .build/debug/logic-probe stats --depth 40; done`
Записать в S12: nodes, ms, ax_messages по трём прогонам и медиану.

  - [ ] **Step 3: Полнота треков**

Run: `.build/debug/logic-probe find 'desc=Tracks header > desc^=Track ' | tail -3`
Записать число совпадений и есть ли строки треков, которые сейчас за нижним краем окна (номера > видимых). Если «Tracks header» не находится — `logic-probe tree --depth 4 | grep -i track | head` и записать реальный якорь.

  - [ ] **Step 4: Полнота регионов**

Run:
```bash
.build/debug/logic-ax-dump --out /tmp/big-live.json --depth 40 --roots mainWindow
jq -r '.. | objects | select(has("a")) | .a | [.role, (.desc // ""), (.title // ""), (.help // "")] | @tsv' /tmp/big-live.json | grep -i -E "region|T2[1-9]|T3[0-9]|T40" | head -40
```
Записать: есть ли узлы регионов вообще (роль, desc), есть ли регионы треков T21–T40 (такт 180, за экраном), в каком виде позиция.

  - [ ] **Step 5: Прокрутка и её возврат**

Run: `.build/debug/logic-probe find 'role=AXScrollBar'` → выбрать вертикальный скроллбар списка треков (индекс K) и записать его `v`.
Run: `.build/debug/logic-probe windows > /tmp/w0.json && .build/debug/logic-probe setnum 'role=AXScrollBar[K]' 1 && .build/debug/logic-probe find 'desc=Tracks header > desc^=Track ' | tail -1 && .build/debug/logic-probe setnum 'role=AXScrollBar[K]' <исходное v> && .build/debug/logic-probe windows > /tmp/w1.json && diff <(jq -S 'del(.userOnScreenWindowNumbers)' /tmp/w0.json) <(jq -S 'del(.userOnScreenWindowNumbers)' /tmp/w1.json)`
Записать: поменялся ли набор строк после прокрутки, вернулась ли прокрутка точно, пустой ли diff окон. То же для горизонтального скроллбара арранжа и регионов T21–T40 (Step 4 после прокрутки вправо).

  - [ ] **Step 6: Источник числа треков, не зависящий от прокрутки**

Проверить и записать кандидатов: (a) строки «Tracks header», если Step 3 показал полноту; (b) `logic-probe raw 'desc=Tracks header' AXVisibleChildren` против `AXChildren`; (c) `logic-probe attrs 'desc=Tracks header'` — нет ли `AXRows`/count-атрибута.

  - [ ] **Step 7: Logic занят**

👤 Запустить offline-баунс «big» (File › Bounce › Project or Section…, Offline, Bounce). Пока идёт:
Run: `.build/debug/logic-probe stats --depth 3 --timeout 1; .build/debug/logic-probe stats --depth 3 --timeout 1`
👤 После баунса нажать Play. Во время воспроизведения:
Run: `.build/debug/logic-probe stats --depth 40`
Записать timeouts/ms при баунсе и ms при воспроизведении против остановленного (Step 2). 👤 Stop.

  - [ ] **Step 8: Записать фикстуры**

При остановленном «big» (трек 1 выделен, зум по умолчанию):
Run: `.build/debug/logic-ax-dump --out Tests/Fixtures/ax/big.json --roots mainWindow,menuBar --project fixture-big --note "stopped, default zoom, track 1 selected"`
Затем: `Scripts/fixture-open.sh belo-krasny`. 👤 Выделить стек «Rose Vocal», чтобы инспектор показал его цепочку.
Run: `.build/debug/logic-ax-dump --out Tests/Fixtures/ax/belo-krasny.json --roots mainWindow,menuBar --project fixture-belo-krasny --note "Rose Vocal selected, stopped"`
Run: `ls -lh Tests/Fixtures/ax/`
Expected: оба файла есть, каждый < 10 MB. Если больше — перезаписать с `--depth 25` и записать это в S12.

  - [ ] **Step 9: 👤 Ground truth и вердикт**

Пользователь по UI Logic заполняет таблицу «Ground truth «бело красного»» (номер, имя, тип, есть ли выход, число дублей).
Вердикт S12: 🟢 — все строки треков и регионы за экраном есть в AX; 🟡 — треки полные, регионы только видимые (или прокрутка возвращается точно и невидимо); 🔴 — строк треков только видимые и прокрутку нельзя вернуть невидимо. Записать решение для §4.6 и §7, найденные якоря — в таблицу «Якоря».

  - [ ] **Step 10: Commit**

```bash
git add Tests/Fixtures/ax/big.json Tests/Fixtures/ax/belo-krasny.json docs/superpowers/specs/spikes-2026-09.md
git commit -m "spike s12: ax completeness and cost, recorded fixtures"
```

---

### Task 9: S3 — регионы, take folder, Region Inspector

**Files:** Modify: `docs/superpowers/specs/spikes-2026-09.md` (S3)

  - [ ] **Step 1: Узлы регионов в фикстуре**

Run: `jq -r '.. | objects | select(has("a")) | .a | select((.desc // "" | test("Region|Take|Audio|Warm"; "i")) or (.role == "AXLayoutItem")) | [.role, (.desc // ""), (.title // ""), (.value // "" | tostring)] | @tsv' Tests/Fixtures/ax/belo-krasny.json | head -60`
Записать роли и описания узлов регионов и дублей.

  - [ ] **Step 2: Позиция региона значением или только геометрией**

На живом `fixture-belo-krasny` для одного региона (локатор L из Step 1):
Run: `.build/debug/logic-probe attrs 'L' && .build/debug/logic-probe raw 'L' AXPosition && .build/debug/logic-probe raw 'L' AXSize`
Записать, есть ли среди атрибутов позиция и длина в тактах (в desc/title/value или отдельным атрибутом) или только `AXPosition`/`AXSize` в пикселях.

  - [ ] **Step 3: Выделение региона и Region Inspector**

Run: `.build/debug/logic-probe press 'L' && .build/debug/logic-probe raw 'L' AXSelected && .build/debug/logic-probe find 'desc~=Region'`
Записать: выделяется ли регион по AXPress, появляются ли в инспекторе поля Position/Length с текстом в тактах, можно ли их читать и писать (`set`).

  - [ ] **Step 4: Take folder**

Run: `.build/debug/logic-probe find 'desc=Tracks header > desc~=Take' | tail -3` и `jq` из Step 1 по регионам дублей.
Записать: видны ли дубли по отдельности, есть ли номер дубля (`Take 7`), активный дубль, диапазоны комп-свайпа (любые узлы с `Comp`), выбор дубля (AXPress на строку дубля → `raw … AXSelected`).

  - [ ] **Step 5: Меню редактирования**

Run: `.build/debug/logic-probe tree --root menubar --depth 2 | grep -i -E "split|join|quantize|transpose|take|comp|flatten|unpack|function"`
Записать точные пути (`Edit>…`), которые понадобятся split/join/flatten/unpack/quantize.

  - [ ] **Step 6: Вердикт и commit**

🟢 — позиция и длина читаются значением (в узле региона или в Region Inspector без открытия окон); 🟡 — только через выделение региона + Region Inspector (выделение региона — видимый побочный эффект, его надо возвращать); 🔴 — только пиксели: `region@position` нереализуем, монтаж по позициям → `unsupported` в v1. Отдельно: есть ли `comp` (диапазоны свайпа) или только `assemble`.

```bash
git add docs/superpowers/specs/spikes-2026-09.md
git commit -m "spike s3: regions and take folders"
```

---

### Task 10: S6 — шаги, скорость и точный путь параметров

**Files:** Modify: `docs/superpowers/specs/spikes-2026-09.md` (S6)

  - [ ] **Step 1: Фейдер и пан inspector-strip**

На `fixture-belo-krasny` (выделен «Rose Vocal»):
Run: `.build/debug/logic-probe inc 'help^=Left inspector channel strip > desc=volume fader' 5 && .build/debug/logic-probe dec 'help^=Left inspector channel strip > desc=volume fader' 5`
Run: то же для `desc=pan`.
Записать последовательность `vd`, шаг в dB, ms на шаг и формат отображения пана (`+12`/`L12`/…).

  - [ ] **Step 2: Абсолютная запись AXValue**

Run: `.build/debug/logic-probe attrs 'help^=Left inspector channel strip > desc=volume fader'` → текущее `v` = X.
Run: `.build/debug/logic-probe setnum 'help^=Left inspector channel strip > desc=volume fader' <X+10.37>`
Записать: сдвиг на заданную величину или на один шаг (в OBSERVATIONS для слайдеров плагинов записано «+1 шаг»). После проверки вернуть значение через `dec`/`inc`.

  - [ ] **Step 3: Окно плагина в режиме Controls**

Run: `.build/debug/logic-probe press 'help^=Left inspector channel strip > desc^=Compr > desc=open'`
Run: `.build/debug/logic-probe tree --root focused --depth 3 | head -40` → найти `AXMenuButton d=view`.
Run: `.build/debug/logic-probe press 'role=AXMenuButton;desc=view' --root focused && .build/debug/logic-probe find 'role=AXMenuItem;title=Controls' --root focused`, затем `press` на найденный пункт.
Run: `.build/debug/logic-probe find 'role=AXSlider' --root focused` и `find 'role=AXTextField' --root focused`
Записать пары «подпись → слайдер» и есть ли текстовые поля или инкременторы значений.

  - [ ] **Step 4: Шаги параметров и числовой ввод**

Для Threshold (слайдер с индексом K):
Run: `.build/debug/logic-probe inc 'role=AXSlider[K]' 4 --root focused && .build/debug/logic-probe dec 'role=AXSlider[K]' 4 --root focused`
Если в Step 3 есть текстовое поле значения (индекс J): `.build/debug/logic-probe set 'role=AXTextField[J]' "-22" --root focused` и прочитать `vd` слайдера.
Записать шаги (dB/%/ms) и сработал ли числовой ввод.

  - [ ] **Step 5: Controller Assignments (только если Step 4 не дал точного пути)**

👤 Logic Pro › Control Surfaces › Controller Assignments… → Learn Mode; тронуть Threshold мышью.
Run: `.build/debug/logic-probe cc 1 20 64`, затем `cc 1 20 70`. Смотреть, как меняется Threshold (`vd` через `find` из Step 3).
Записать: сколько шагов даёт CC 0–127 на этом параметре, нужна ли видимая настройка, переживает ли она перезапуск.

  - [ ] **Step 6: OSC**

Run: `grep -n -E '"/|address' Sources/LogicProMCP/Channels/OSCChannel.swift | head -20`
Записать, какие адреса поддерживает upstream-канал и какая настройка Logic (Control Surfaces) для него нужна. Если настройка видимая или адресации параметров плагинов нет — OSC удаляется в Task 31.

  - [ ] **Step 7: Закрыть окно плагина, вердикт, commit**

Run: `.build/debug/logic-probe press 'help^=Left inspector channel strip > desc^=Compr > desc=open'` (тоггл закрывает) и `logic-probe windows`, чтобы убедиться, что окно закрылось.
🟢 — точный путь для параметров есть (числовой ввод или CC с достаточным разрешением без видимой перенастройки); 🟡 — только `stepTo` с грубыми шагами: ограничение v1 записывается в §8.1; OSC — оставить или удалить.

```bash
git add docs/superpowers/specs/spikes-2026-09.md
git commit -m "spike s6: parameter steps and precision"
```

---

### Task 11: S8 — невидимый verified select и возврат выделения

**Files:** Modify: `docs/superpowers/specs/spikes-2026-09.md` (S8)

  - [ ] **Step 1: Исходное состояние**

Run: `.build/debug/logic-probe find 'desc=Tracks header > desc^=Track ' | grep -n sel` (сейчас выделен трек S) и `.build/debug/logic-probe find 'desc=Tracks header > desc^=Track 1 > desc=Record Enable'` (arm трека 1 = A0).
Run: `.build/debug/logic-probe windows > /tmp/s8-w0.json`

  - [ ] **Step 2: Перебрать стратегии на треке 1**

После каждой попытки: `find … | grep sel`, `attrs 'help^=Left inspector channel strip > desc=volume fader'` (поменялся ли inspector) и arm трека 1.
  - A: `.build/debug/logic-probe setbool 'desc=Tracks header > desc^=Track 1 “' AXSelected true`
  - B: `.build/debug/logic-probe press 'desc=Tracks header > desc^=Track 1 “'` (по OBSERVATIONS не работает — перепроверить)
  - C: `.build/debug/logic-probe press 'desc=Tracks header > desc^=Track 1 “ > role=AXStaticText'` (и `role=AXTextField`)
  - D: `.build/debug/logic-probe find 'desc=Tracks header > desc^=Track 1 “ > role=AXRadioButton'` → если есть, `press`

Записать для каждой: выделение сменилось? inspector показал трек 1? трек встал на запись (Auto Track Enable)?

  - [ ] **Step 3: Возврат**

Той же стратегией выделить обратно трек S. Проверить: выделен S, arm трека 1 = A0 (если select его армировал — снимается ли arm сам при уходе выделения).
Run: `.build/debug/logic-probe windows > /tmp/s8-w1.json && diff <(jq -S 'del(.userOnScreenWindowNumbers)' /tmp/s8-w0.json) <(jq -S 'del(.userOnScreenWindowNumbers)' /tmp/s8-w1.json)`

  - [ ] **Step 4: Слайдеры в заголовке трека**

Run: `.build/debug/logic-probe find 'desc=Tracks header > desc^=Track 1 “ > role=AXSlider'`
Записать `desc`/`vd` громкости и пана в заголовке (краткий срез для `?unavailable(need_select)`).

  - [ ] **Step 5: Вердикт и commit**

🟢 — есть невидимая стратегия, verify по `AXSelected`/inspector, возврат точный, arm не меняется; 🟡 — select армирует трек: возврат обязан восстановить arm (дополнительный шаг рецепта); 🔴 — невидимого select нет: мутации strip только для `track:selected`. Записать выбранную стратегию (A/B/C/D) и якоря.

```bash
git add docs/superpowers/specs/spikes-2026-09.md
git commit -m "spike s8: invisible select and restore"
```

---

### Task 12: S9 — меню-бар без фокуса и свежесть заголовка undo

**Files:** Modify: `docs/superpowers/specs/spikes-2026-09.md` (S9)

Условие для всех шагов: 👤 пользователь в Terminal на своём Space, Logic на другом.

  - [ ] **Step 1: Исходные значения**

Run: `.build/debug/logic-probe menu 'Edit>^Undo' && .build/debug/logic-probe find 'desc=Tracks header > desc^=Track ' | tail -1 && .build/debug/logic-probe windows > /tmp/s9-w0.json`
Записать заголовок T0 и число треков N0.

  - [ ] **Step 2: AXPress по меню без фокуса**

Run: `.build/debug/logic-probe tree --root menubar --depth 3 | grep -i "new audio track"` → точный путь P (например `Track>New Audio Track`).
Run: `.build/debug/logic-probe menu 'P' --press && sleep 1 && .build/debug/logic-probe find 'desc=Tracks header > desc^=Track ' | tail -1`
Записать: стало ли треков N0+1, сменился ли frontmost/Space пользователя (`windows` → diff с `/tmp/s9-w0.json`).

  - [ ] **Step 3: Свежесть заголовка undo**

Run: `.build/debug/logic-probe menu 'Edit>^Undo'` → T1 (меню закрыто).
Run: `.build/debug/logic-probe press 'title=Edit' --root menubar && .build/debug/logic-probe menu 'Edit>^Undo' && .build/debug/logic-probe action 'title=Edit' AXCancel --root menubar` → T2 (меню открыто, затем закрыто). Если `AXCancel` не закрывает — повторный `press 'title=Edit'`.
Записать T1 и T2. T1 = T2 = «Undo New Track…» → заголовок свежий без открытия; T1 устаревший, а T2 свежий → нужен transient open/close.

  - [ ] **Step 4: Undo через меню**

Run: `.build/debug/logic-probe menu 'Edit>^Undo' --press && sleep 1 && .build/debug/logic-probe find 'desc=Tracks header > desc^=Track ' | tail -1`
Expected: снова N0 треков. Записать.

  - [ ] **Step 5: Окно из меню без фокуса**

Run: `.build/debug/logic-probe menu 'Mix>^Search and Add' --press && sleep 1 && .build/debug/logic-probe windows > /tmp/s9-w2.json && .build/debug/logic-probe tree --root focused --depth 2 | head`
Закрыть окно: `.build/debug/logic-probe find 'subrole=AXCloseButton' --root focused`, затем `press`. Если кнопки нет — `action 'role=AXTextField' AXCancel --root focused`.
Записать: открылось ли окно, стал ли Logic frontmost, закрылось ли по AX.

  - [ ] **Step 6: Вердикт и commit**

(a) 🟢 AX-меню работает без фокуса → Automation не нужна; (a′) то же, но заголовок undo свежий только при открытом меню → чтение `undo_title` через transient open/close; (b) AXPress не срабатывает → проверить `osascript -e 'tell application "System Events" to click menu item "Undo" of menu "Edit" of menu bar 1 of process "Logic Pro"'` (нужен Automation-грант) → узкий Apple Event; (c) работает только с Logic на переднем плане → рецепты меню класса `restores`, §12.7 пересматривается.

```bash
git add docs/superpowers/specs/spikes-2026-09.md
git commit -m "spike s9: menu bar without focus, undo title freshness"
```

---

### Task 13: S1 — окна и фокус по рабочим окнам Logic

**Files:** Modify: `docs/superpowers/specs/spikes-2026-09.md` (S1)

Для каждого окна W из списка — одна и та же процедура на `fixture-belo-krasny`:
`windows > /tmp/s1-W-0.json` → открыть → `windows > /tmp/s1-W-1.json` → закрыть по AX → `windows > /tmp/s1-W-2.json` → `diff` 0↔1 и 0↔2.

  - [ ] **Step 1: Окно плагина**

Открыть: `.build/debug/logic-probe press 'help^=Left inspector channel strip > desc^=Channel > desc=open'`; закрыть тем же `press` (тоггл) и отдельно — через `subrole=AXCloseButton` в `--root focused`.
Записать: номер окна в CGWindowList, `onScreen`, main/focused, frontmost и Space пользователя, закрытие по AX.

  - [ ] **Step 2: Режим Controls сохраняется?**

Переключить окно Channel EQ в Controls (как в Task 10 Step 3), закрыть, открыть снова, проверить `tree --root focused --depth 2`: открылось в Controls или Editor. Записать и вернуть Editor.

  - [ ] **Step 3: Search and Add, Save Patch, Import MIDI, Bounce**

Открыть и закрыть:
  - Search and Add: `menu 'Mix>^Search and Add' --press`;
  - Save Patch: `find 'role=AXButton;title=Save…'` → `press`, закрыть `Cancel`;
  - Import MIDI: путь из `tree --root menubar --depth 3 | grep -i "MIDI File"` → `menu … --press`, закрыть `Cancel`;
  - Bounce: `menu 'File>^Bounce>^Project or Section' --press`, закрыть `Cancel`.
Для каждого записать то же, что в Step 1, плюс `mainWindowSubrole` модалки (`AXDialog`/`AXSystemDialog`/…) — это правило `ModalGuard`.

  - [ ] **Step 4: Вердикт и commit**

Таблица «окно → `visibility` (never/transient/restores)», правило распознавания модалки, закрывается ли каждое окно по AX. 🔴 — окно нельзя закрыть по AX или оно всегда переключает Space пользователя.

```bash
git add docs/superpowers/specs/spikes-2026-09.md
git commit -m "spike s1: windows, focus and modal detection"
```

---

### Task 14: S11 и S2 — транспорт и нотификации

**Files:** Modify: `docs/superpowers/specs/spikes-2026-09.md` (S11, S2)

  - [ ] **Step 1: Control bar**

Run: `.build/debug/logic-probe find 'desc=Control Bar > role=AXCheckBox' && .build/debug/logic-probe find 'desc=Control Bar > role=AXTextField' && .build/debug/logic-probe find 'desc=Control Bar > role=AXStaticText' | head -20`
Записать якоря Play/Stop/Record/Pause/Cycle/Metronome, поле позиции, темп.

  - [ ] **Step 2: Play/Stop как состояние**

Run: `.build/debug/logic-probe press 'desc=Control Bar > desc=Play' && sleep 2 && .build/debug/logic-probe find 'desc=Control Bar > desc=Play' && .build/debug/logic-probe press 'desc=Control Bar > desc=Stop'`
Записать: значение Play во время воспроизведения, задержку, возврат после Stop, двигается ли позиция. Record **не нажимать**, только читать.

  - [ ] **Step 3: Locate**

Run: `.build/debug/logic-probe set 'desc=Control Bar > <якорь поля позиции>' "5 1 1 1"` и прочитать позицию.
Записать: принимает ли поле текст, нужен ли AXConfirm, формат значения.

  - [ ] **Step 4: MMC**

Без настройки: `.build/debug/logic-probe mmc play` → Play не должен измениться (записать).
👤 File › Project Settings › Synchronization › MIDI → включить «Listen to MMC Input».
Run: `.build/debug/logic-probe mmc play && sleep 1 && .build/debug/logic-probe find 'desc=Control Bar > desc=Play' && .build/debug/logic-probe mmc stop && .build/debug/logic-probe mmc locate 00:00:10:00`
Записать реакцию и задержку.

  - [ ] **Step 5: S2 — нотификации**

Run (в фоне на 20 с): `.build/debug/logic-probe observe --for 20 > /tmp/s2.log &`
За эти 20 с выполнить: `press Play`, `press Stop`, выбор трека стратегией из S8, открыть и закрыть окно плагина.
Run: `cut -d' ' -f2 /tmp/s2.log | sort | uniq -c`
Записать, какие нотификации пришли на какие события.

  - [ ] **Step 6: Вердикт и commit**

S11: 🟢 AX play/stop/state/locate работают → основной путь; 🟡 только часть (например, locate только через MMC); 🔴 состояние транспорта не читается → транспорт выпадает из среза P1. S2: 🟢 нотификации покрывают transport/selection/windows → Watcher на AXObserver; иначе опрос 250 мс.

```bash
git add docs/superpowers/specs/spikes-2026-09.md
git commit -m "spikes s11 s2: transport and ax notifications"
```

---

### Task 15: S4, S5, S7, S10 — вопросы для P2+

**Files:** Modify: `docs/superpowers/specs/spikes-2026-09.md` (S4, S5, S7, S10)

Этим спайкам достаточно записать наблюдения и вердикт; P1 от них не зависит.

  - [ ] **Step 1: S4 — импорт MIDI через open-panel**

Run: `python3 - <<'EOF'
import struct
d = b'\x00\xff\x03\x03one' + b'\x00\x90\x3c\x60' + b'\x83\x60\x80\x3c\x00' + b'\x00\xff\x2f\x00'
open('/tmp/one-note.mid', 'wb').write(b'MThd' + struct.pack('>IHHH', 6, 0, 1, 480) + b'MTrk' + struct.pack('>I', len(d)) + d)
EOF`
Выделить трек 1 (стратегия S8), locate `9 1 1 1`, открыть Import MIDI (путь из Task 13), затем `find 'role=AXTextField' --root focused`. Попробовать: `set` полного пути в поле; если поля нет — `action '<панель>' AXShowGoTo`/поиск sheet «Go to folder». Нажать Open.
Записать: удалось ли задать путь без клавиатуры, где лёг регион (выделенный трек или новый, на `9 1 1 1`?), был ли диалог темпа, изменился ли темп проекта. Экспорт: File › Export › Selection as MIDI File… — есть ли `saveAsNameTextField`.

  - [ ] **Step 2: S5 — вложенные popup**

В inspector-strip найти кнопку выхода: `find 'help^=Left inspector channel strip > role=AXPopUpButton'` (или `AXMenuButton`), `press` → `find 'role=AXMenuItem' --root app | head -30` → пункт `Bus` → попробовать на подпункте `Bus 2`: `press`, `action … AXShowMenu`, `setbool … AXSelected true`. После каждой попытки прочитать выход strip. Закрыть меню `AXCancel`.
Записать, что сработало.

  - [ ] **Step 3: S7 — слот Search and Add**

Выделить пустой слот (`press` на пустом слоте в strip), затем `menu 'Mix>^Search and Add' --press`, `set 'role=AXTextField' "Gain" --root focused` + AXConfirm. Прочитать, в какой слот встал Gain; повторить без выделенного слота. Удалить плагин (`list` → `No Plug-in`).
Записать правило вставки и есть ли адресация слота.

  - [ ] **Step 4: S10 — источник аудио**

Run: `ls "$TMPDIR/logic-fixtures/fixture-belo-krasny.logicx/Media/Audio Files" | head` (и `find … -name "*.wav" -o -name "*.aif"`).
Для региона дубля (локатор из S3): `attrs` и `raw … AXDocument`/`AXURL`/`AXFilename`; Region Inspector — есть ли смещение в файле (anchor/offset).
Записать вариант 1/2/3 из §8.5.

  - [ ] **Step 5: Commit**

```bash
git add docs/superpowers/specs/spikes-2026-09.md
git commit -m "spikes s4 s5 s7 s10"
```

---

### Task 16: Синтез P0 → спек APPROVED, гейт

**Files:**
  - Modify: `docs/superpowers/specs/spikes-2026-09.md` (сводка, якоря)
  - Modify: `docs/superpowers/specs/2026-09-21-logic-native-mcp-design.md`

  - [ ] **Step 1: Сводка и якоря**

Заполнить таблицу «Сводка» (12 строк: ответ + решение) и таблицу «Якоря». В «Якорях» должна быть строка для **каждого** значения `Anchor` из Task 20: `tracksHeader, trackRowDescPrefix, takeLaneSuffix, noOutputFlag, mute, solo, recordEnable, headerVolume, headerPan, inspectorStripHelpPrefix, stripVolume, stripPan, pluginBypass, pluginOpen, pluginList, peakMeterTitlePrefix, controlBar, play, stop, record, pause, cycle, positionField, menuEdit, menuUndoPrefix, menuRedoPrefix, modalSubroles`. Якорь, которого нет в UI, записывается как «нет» с последствием.

  - [ ] **Step 2: Гейт**

Если S12 или S3 🔴: **остановиться**, показать пользователю сводку и последствия для объёма v1 (карта только видимого; монтаж по позициям → `unsupported`) и дождаться решения. Phase C не начинать.

  - [ ] **Step 3: Обновить спек**

  - Снять все ⛳, на которые есть ответ, и переписать затронутые места: §4.2 (S8), §4.6 (S12), §5.1 (S12: таймауты), §5.4 (S1, S9), §6 (S2), §8.1 (S5, S6, S7), §8.2 (S11), §8.3 (S4), §8.5 (S3, S10), §9 (S9: разрешения).
  - §5.6: ledger — `Sources/LogicKit/Resources/ledger.json` (почему — см. «Файловая структура» этого плана).
  - Статус → `APPROVED (после P0)`; в §1 Scope явно перечислить, что стало `unsupported`.
  - §16 Changelog v5: «спайк → раздел → изменение».

  - [ ] **Step 4: Решения для P1 (записать в конец spikes-2026-09.md)**

```markdown
## Решения для P1
- select: стратегия <A|B|C|D|нет> (S8); возврат выделения: <да/нет>, arm: <не меняется|нужен возврат>
- транспорт: play/stop <AX|MMC|нет>, locate <AX-поле|MMC|нет> (S11)
- undo_title: <читается без открытия меню | transient open/close | недоступен> (S9)
- menu: <AX без фокуса | Apple Event | restores> (S9)
- модалка: main window subrole ∈ {…} (S1)
- OSC: <остаётся | удаляется в Task 31> (S6)
```

  - [ ] **Step 5: Commit**

```bash
git add docs/superpowers/specs
git commit -m "p0 synthesis: spec approved after spikes"
```

---

# Phase C — P1: фундамент

Перед каждой задачей Phase C исполнитель читает раздел «Решения для P1» и таблицу «Якоря» в `spikes-2026-09.md`. Строки AX-якорей в коде ниже — гипотезы из `OBSERVATIONS.md`/`IMPROVEMENTS.md`. Если спайк нашёл другую строку, меняется **только** `LocaleTable.en` (Task 20), а тесты остаются прежними.

### Task 17: Ошибки, исходы, оценка токенов

**Files:**
  - Create: `Sources/LogicKit/Engine/Errors.swift`, `Sources/LogicKit/Support/TokenEstimate.swift`
  - Test: `Tests/LogicKitTests/ErrorsTests.swift`

**Interfaces:**
  - Produces:
  - `enum TokenEstimate { static func count(_ s: String) -> Int }`: ASCII ≈ 4 символа на токен, каждый не-ASCII скаляр = 1 токен (консервативно для кириллицы).
  - `enum BlockReason: Equatable, Sendable { case modal(String), contextChanged(String), recording, playing }`
  - `enum LogicError: Error, Equatable, Sendable` — варианты: `notFound(String, candidates: [String])`, `ambiguous(String, candidates: [String])`, `staleRef(String)`, `blocked(BlockReason)`, `busy(String)`, `unavailable(String)`, `unsupported(String)`, `needSelect(track: Int)`, `invalidArgs(signature: String, detail: String)`, `invalidValue(want: String, range: String)`, `verifyFailed(want: String, got: String)`, `timeout(last: String?)`, `partial(done: [String], failed: String, undoSteps: Int?)`, `confirmRequired(String)`, `permissionAX`, `logicNotRunning`, `anchorMissing(String)`, `needMMCInput`. Плюс `code: String` и `text: String` (≤ 150 токенов, первая строка ≤ 60).
  - `struct Quantization: Equatable, Sendable { want: String; step: String }`
  - `enum Outcome: Equatable, Sendable { case ok(path: String, actual: String, quantized: Quantization? = nil, notes: [String] = []), sent(String), unverified(String) }`, `text: String`, `appending(notes:) -> Outcome`

  - [ ] **Step 1: Падающие тесты**

`Tests/LogicKitTests/ErrorsTests.swift`:
```swift
import XCTest
@testable import LogicKit

final class ErrorsTests: XCTestCase {
    func testTokenEstimateIsConservativeForCyrillic() {
        XCTAssertEqual(TokenEstimate.count("abcd"), 1)
        XCTAssertEqual(TokenEstimate.count("abcde"), 2)
        XCTAssertEqual(TokenEstimate.count("бело"), 4)
    }

    func testCodes() {
        XCTAssertEqual(LogicError.staleRef("#t1").code, "stale_ref")
        XCTAssertEqual(LogicError.blocked(.recording).code, "blocked")
        XCTAssertEqual(LogicError.needMMCInput.code, "need_mmc_input")
    }

    func testErrorTextShapes() {
        XCTAssertEqual(LogicError.blocked(.modal("Save Patch as…")).text,
                       "blocked: modal \"Save Patch as…\" is open — close it in Logic or wait")
        XCTAssertEqual(LogicError.verifyFailed(want: "on", got: "off").text, "verify_failed: want on, got off")
        let amb = LogicError.ambiguous("track:\"Vox\"", candidates: ["track:2 \"Vox\"", "track:7 \"Vox\""]).text
        XCTAssertEqual(amb, "ambiguous: track:\"Vox\" matches 2\ncandidates: track:2 \"Vox\" · track:7 \"Vox\"")
    }

    func testErrorBudgets() {
        let many = (1...40).map { "track:\($0) \"Очень длинное имя трека номер \($0) с хвостом\"" }
        let t = LogicError.notFound("track:\"Вокал\"", candidates: many).text
        XCTAssertLessThanOrEqual(TokenEstimate.count(t), 150)
        XCTAssertLessThanOrEqual(TokenEstimate.count(t.components(separatedBy: "\n")[0]), 60)
        XCTAssertLessThanOrEqual(t.components(separatedBy: " · ").count, 5)
        let long = LogicError.unavailable(String(repeating: "очень долго ", count: 40)).text
        XCTAssertLessThanOrEqual(TokenEstimate.count(long), 60)
    }

    func testOutcomeText() {
        let q = Outcome.ok(path: "track:3/insert:2/param:Threshold", actual: "-20 dB",
                           quantized: Quantization(want: "-22 dB", step: "5 dB"))
        XCTAssertEqual(q.text, "✓ track:3/insert:2/param:Threshold = -20 dB (want -22 dB, step 5 dB)")
        XCTAssertEqual(Outcome.ok(path: "track:1/mute", actual: "on").appending(notes: ["⚠ project unsaved"]).text,
                       "✓ track:1/mute = on\n⚠ project unsaved")
        XCTAssertEqual(Outcome.sent("3 events").text, "→ sent 3 events")
    }
}
```

  - [ ] **Step 2: Прогнать — падает**

Run: `swift test --filter ErrorsTests 2>&1 | tail -3` → FAIL (`cannot find 'TokenEstimate'`).

  - [ ] **Step 3: Реализация**

`Sources/LogicKit/Support/TokenEstimate.swift`:
```swift
/// Conservative token estimate used by budget tests (spec §7): ASCII ≈ 4 chars/token, non-ASCII scalar = 1 token.
public enum TokenEstimate {
    public static func count(_ s: String) -> Int {
        var ascii = 0, other = 0
        for u in s.unicodeScalars { if u.isASCII { ascii += 1 } else { other += 1 } }
        return (ascii + 3) / 4 + other
    }
}
```

`Sources/LogicKit/Engine/Errors.swift`:
```swift
import Foundation

public enum BlockReason: Equatable, Sendable {
    case modal(String), contextChanged(String), recording, playing
}

public enum LogicError: Error, Equatable, Sendable {
    case notFound(String, candidates: [String])
    case ambiguous(String, candidates: [String])
    case staleRef(String)
    case blocked(BlockReason)
    case busy(String)
    case unavailable(String)
    case unsupported(String)
    case needSelect(track: Int)
    case invalidArgs(signature: String, detail: String)
    case invalidValue(want: String, range: String)
    case verifyFailed(want: String, got: String)
    case timeout(last: String?)
    case partial(done: [String], failed: String, undoSteps: Int?)
    case confirmRequired(String)
    case permissionAX
    case logicNotRunning
    case anchorMissing(String)
    case needMMCInput

    public var code: String {
        switch self {
        case .notFound: return "not_found"
        case .ambiguous: return "ambiguous"
        case .staleRef: return "stale_ref"
        case .blocked: return "blocked"
        case .busy: return "busy"
        case .unavailable: return "unavailable"
        case .unsupported: return "unsupported"
        case .needSelect: return "need_select"
        case .invalidArgs: return "invalid_args"
        case .invalidValue: return "invalid_value"
        case .verifyFailed: return "verify_failed"
        case .timeout: return "timeout"
        case .partial: return "partial"
        case .confirmRequired: return "confirm_required"
        case .permissionAX: return "permission"
        case .logicNotRunning: return "logic_not_running"
        case .anchorMissing: return "anchor_missing"
        case .needMMCInput: return "need_mmc_input"
        }
    }

    /// Spec §5.5: first line ≤ 60 tokens, whole text ≤ 150, at most 5 candidates.
    public var text: String {
        let (head, extra) = parts
        var lines = [Self.clip(head, tokens: 60)] + extra.map { Self.clip($0, tokens: 90) }
        while lines.count > 1 && TokenEstimate.count(lines.joined(separator: "\n")) > 150 { lines.removeLast() }
        return lines.joined(separator: "\n")
    }

    private var parts: (String, [String]) {
        switch self {
        case .notFound(let what, let c): return ("not_found: \(what)", Self.candidates(c))
        case .ambiguous(let what, let c): return ("ambiguous: \(what) matches \(c.count)", Self.candidates(c))
        case .staleRef(let h): return ("stale_ref: \(h) — re-read the parent and use the new address", [])
        case .blocked(.modal(let t)): return ("blocked: modal \"\(t)\" is open — close it in Logic or wait", [])
        case .blocked(.contextChanged(let s)): return ("blocked: context changed (\(s)) — operation stopped", [])
        case .blocked(.recording): return ("blocked: Logic is recording — only transport stop is allowed", [])
        case .blocked(.playing): return ("blocked: Logic is playing — stop transport first", [])
        case .busy(let r): return ("busy: \(r) — retry later", [])
        case .unavailable(let r): return ("unavailable: \(r)", [])
        case .unsupported(let r): return ("unsupported: \(r)", [])
        case .needSelect(let n): return ("need_select: select track \(n) first (logic_do track:\(n) select)", [])
        case .invalidArgs(let sig, let detail): return ("invalid_args: \(detail)", ["signature: \(sig)"])
        case .invalidValue(let want, let range): return ("invalid_value: \(want) outside \(range)", [])
        case .verifyFailed(let want, let got): return ("verify_failed: want \(want), got \(got)", [])
        case .timeout(let last): return ("timeout" + (last.map { " (last: \($0))" } ?? ""), [])
        case .partial(let done, let failed, let undo):
            var extra = ["done: " + done.joined(separator: "; ")]
            if let undo { extra.append("undo_steps: \(undo)") }
            return ("partial: \(done.count) done, failed: \(failed)", extra)
        case .confirmRequired(let c): return ("confirm_required: \(c) — repeat with confirm:true", [])
        case .permissionAX: return ("permission: Accessibility not granted — System Settings › Privacy & Security › Accessibility", [])
        case .logicNotRunning: return ("logic_not_running: start Logic Pro", [])
        case .anchorMissing(let a): return ("anchor_missing: \(a) — this Logic UI differs; capability disabled", [])
        case .needMMCInput: return ("need_mmc_input: enable Project Settings › Synchronization › MIDI › Listen to MMC Input", [])
        }
    }

    static func candidates(_ c: [String]) -> [String] {
        c.isEmpty ? [] : ["candidates: " + c.prefix(5).map { String($0.prefix(40)) }.joined(separator: " · ")]
    }

    static func clip(_ s: String, tokens: Int) -> String {
        guard TokenEstimate.count(s) > tokens else { return s }
        var out = s
        while TokenEstimate.count(out + "…") > tokens { out.removeLast() }
        return out + "…"
    }
}

public struct Quantization: Equatable, Sendable {
    public var want: String
    public var step: String
    public init(want: String, step: String) { self.want = want; self.step = step }
}

public enum Outcome: Equatable, Sendable {
    case ok(path: String, actual: String, quantized: Quantization? = nil, notes: [String] = [])
    case sent(String)
    case unverified(String)

    public var text: String {
        switch self {
        case .ok(let path, let actual, let q, let notes):
            var s = "✓ \(path) = \(actual)"
            if let q { s += " (want \(q.want), step \(q.step))" }
            return ([s] + notes).joined(separator: "\n")
        case .sent(let s): return "→ sent \(s)"
        case .unverified(let s): return "? unverified \(s)"
        }
    }

    public func appending(notes more: [String]) -> Outcome {
        guard !more.isEmpty, case .ok(let p, let a, let q, let n) = self else { return self }
        return .ok(path: p, actual: a, quantized: q, notes: n + more)
    }
}
```

  - [ ] **Step 4: Прогнать** — `swift test --filter ErrorsTests 2>&1 | tail -3` → PASS (5).

  - [ ] **Step 5: Commit** — `git add Sources/LogicKit/Engine/Errors.swift Sources/LogicKit/Support/TokenEstimate.swift Tests/LogicKitTests/ErrorsTests.swift && git commit -m "error taxonomy, outcomes, token estimate"`

---

### Task 18: Значения в единицах Logic

**Files:** Create `Sources/LogicKit/Map/Values.swift`; Test `Tests/LogicKitTests/ValuesTests.swift`

**Interfaces:**
  - Produces: `enum ValueUnit: String, Codable, Sendable { case dB, pan, ms, seconds, percent, onOff, number, text, position }`; `struct BarPosition: Comparable, Sendable, CustomStringConvertible { bar, beat, division, tick: Int; init(bar:beat:division:tick:); static func parse(_:) -> BarPosition? }`; `enum LogicValue: Equatable, Sendable { dB(Double), pan(Int), ms(Double), seconds(Double), percent(Double), bool(Bool), number(Double), text(String), position(BarPosition) }`; `struct ValueError: Error, Equatable { message }`; `enum ValueParser { parse(_:unit:) throws -> LogicValue; parseDisplay(_:unit:) -> LogicValue?; format(_:) -> String; magnitude(_:) -> Double? }`.

  - [ ] **Step 1: Падающие тесты**

```swift
import XCTest
@testable import LogicKit

final class ValuesTests: XCTestCase {
    func p(_ s: String, _ u: ValueUnit) throws -> LogicValue { try ValueParser.parse(s, unit: u) }

    func testDecibels() throws {
        XCTAssertEqual(try p("-6 dB", .dB), .dB(-6))
        XCTAssertEqual(try p("-4.2dB", .dB), .dB(-4.2))
        XCTAssertEqual(try p("-inf", .dB), .dB(-.infinity))
        XCTAssertEqual(try p("3", .dB), .dB(3))
        XCTAssertThrowsError(try p("loud", .dB))
        XCTAssertEqual(ValueParser.format(.dB(-.infinity)), "-inf dB")
        XCTAssertEqual(ValueParser.format(.dB(-4.2)), "-4.2 dB")
    }

    func testPan() throws {
        XCTAssertEqual(try p("L12", .pan), .pan(-12))
        XCTAssertEqual(try p("R5", .pan), .pan(5))
        XCTAssertEqual(try p("C", .pan), .pan(0))
        XCTAssertEqual(try p("+7", .pan), .pan(7))
        XCTAssertThrowsError(try p("L99", .pan))
        XCTAssertEqual(ValueParser.format(.pan(-12)), "L12")
        XCTAssertEqual(ValueParser.parseDisplay("-3.0", unit: .pan), .pan(-3))
    }

    func testTimesPercentToggles() throws {
        XCTAssertEqual(try p("38 ms", .ms), .ms(38))
        XCTAssertEqual(try p("1.6 s", .ms), .ms(1600))
        XCTAssertEqual(try p("1.6 s", .seconds), .seconds(1.6))
        XCTAssertEqual(try p("20%", .percent), .percent(20))
        XCTAssertEqual(try p("on", .onOff), .bool(true))
        XCTAssertEqual(try p("0", .onOff), .bool(false))
        XCTAssertThrowsError(try p("maybe", .onOff))
        XCTAssertEqual(ValueParser.format(.ms(38)), "38 ms")
    }

    func testPositions() throws {
        XCTAssertEqual(try p("17 1 1 1", .position), .position(BarPosition(bar: 17, beat: 1, division: 1, tick: 1)))
        XCTAssertEqual(try p("17", .position), .position(BarPosition(bar: 17, beat: 1, division: 1, tick: 1)))
        XCTAssertEqual(try p("17.3.1.1", .position), .position(BarPosition(bar: 17, beat: 3, division: 1, tick: 1)))
        XCTAssertThrowsError(try p("x 1", .position))
        XCTAssertLessThan(BarPosition.parse("9 4 4 240")!, BarPosition.parse("10")!)
    }

    func testDisplayAndMagnitude() {
        XCTAssertEqual(ValueParser.parseDisplay("-20.0 dB", unit: .dB).flatMap(ValueParser.magnitude), -20)
        XCTAssertNil(ValueParser.parseDisplay("garbage", unit: .dB))
    }
}
```

  - [ ] **Step 2: Прогнать** → FAIL.

  - [ ] **Step 3: Реализация** `Sources/LogicKit/Map/Values.swift`:
```swift
import Foundation

public enum ValueUnit: String, Codable, Sendable {
    case dB, pan, ms, seconds, percent, onOff, number, text, position
}

public struct BarPosition: Comparable, Sendable, CustomStringConvertible {
    public var bar: Int, beat: Int, division: Int, tick: Int

    public init(bar: Int, beat: Int = 1, division: Int = 1, tick: Int = 1) {
        self.bar = bar; self.beat = beat; self.division = division; self.tick = tick
    }

    /// "17 1 1 1", "17.3.1.1" or "17"; missing trailing parts default to 1.
    public static func parse(_ s: String) -> BarPosition? {
        let parts = s.split(whereSeparator: { $0 == " " || $0 == "." })
        guard (1...4).contains(parts.count) else { return nil }
        var nums = parts.compactMap { Int($0) }
        guard nums.count == parts.count, nums.dropFirst().allSatisfy({ $0 >= 1 }) else { return nil }
        while nums.count < 4 { nums.append(1) }
        return BarPosition(bar: nums[0], beat: nums[1], division: nums[2], tick: nums[3])
    }

    public var description: String { "\(bar) \(beat) \(division) \(tick)" }

    public static func < (a: BarPosition, b: BarPosition) -> Bool {
        (a.bar, a.beat, a.division, a.tick) < (b.bar, b.beat, b.division, b.tick)
    }
}

public enum LogicValue: Equatable, Sendable {
    case dB(Double), pan(Int), ms(Double), seconds(Double), percent(Double)
    case bool(Bool), number(Double), text(String), position(BarPosition)
}

public struct ValueError: Error, Equatable {
    public let message: String
    public init(_ m: String) { message = m }
}

public enum ValueParser {
    public static func parse(_ raw: String, unit: ValueUnit) throws -> LogicValue {
        let s = raw.trimmingCharacters(in: .whitespaces)
        let low = s.lowercased()
        func num(_ t: some StringProtocol) -> Double? {
            Double(t.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: ",", with: "."))
        }
        switch unit {
        case .dB:
            let body = (low.hasSuffix("db") ? String(low.dropLast(2)) : low).trimmingCharacters(in: .whitespaces)
            if ["-inf", "-∞", "inf", "-infinity"].contains(body) { return .dB(-.infinity) }
            guard let v = num(body) else { throw ValueError("expected dB like \"-6 dB\" or \"-inf\", got \"\(raw)\"") }
            return .dB(v)
        case .pan:
            if ["c", "center", "centre", "0"].contains(low) { return .pan(0) }
            let v: Int?
            if low.hasPrefix("l") { v = Int(low.dropFirst()).map { -$0 } }
            else if low.hasPrefix("r") { v = Int(low.dropFirst()) }
            else { v = Int(low.hasPrefix("+") ? String(low.dropFirst()) : low) }
            guard let p = v, (-64...63).contains(p) else { throw ValueError("expected pan L64…C…R63, got \"\(raw)\"") }
            return .pan(p)
        case .ms:
            if low.hasSuffix("ms"), let v = num(low.dropLast(2)) { return .ms(v) }
            if low.hasSuffix("s"), let v = num(low.dropLast(1)) { return .ms(v * 1000) }
            if let v = num(low) { return .ms(v) }
            throw ValueError("expected time like \"38 ms\", got \"\(raw)\"")
        case .seconds:
            if low.hasSuffix("ms"), let v = num(low.dropLast(2)) { return .seconds(v / 1000) }
            if low.hasSuffix("s"), let v = num(low.dropLast(1)) { return .seconds(v) }
            if let v = num(low) { return .seconds(v) }
            throw ValueError("expected time like \"1.6 s\", got \"\(raw)\"")
        case .percent:
            guard let v = num(low.hasSuffix("%") ? String(low.dropLast()) : low) else { throw ValueError("expected percent like \"20%\", got \"\(raw)\"") }
            return .percent(v)
        case .onOff:
            if ["on", "true", "1", "yes"].contains(low) { return .bool(true) }
            if ["off", "false", "0", "no"].contains(low) { return .bool(false) }
            throw ValueError("expected on|off, got \"\(raw)\"")
        case .number:
            guard let v = num(low) else { throw ValueError("expected a number, got \"\(raw)\"") }
            return .number(v)
        case .text:
            return .text(s)
        case .position:
            guard let p = BarPosition.parse(s) else { throw ValueError("expected position like \"17 1 1 1\", got \"\(raw)\"") }
            return .position(p)
        }
    }

    /// Lenient parse of an AXValueDescription.
    public static func parseDisplay(_ raw: String, unit: ValueUnit) -> LogicValue? {
        if let v = try? parse(raw, unit: unit) { return v }
        if unit == .pan, let d = Double(raw.trimmingCharacters(in: .whitespaces)) { return .pan(Int(d.rounded())) }
        return nil
    }

    public static func format(_ v: LogicValue) -> String {
        switch v {
        case .dB(let d): return d == -.infinity ? "-inf dB" : "\(trim(d)) dB"
        case .pan(let p): return p == 0 ? "C" : p < 0 ? "L\(-p)" : "R\(p)"
        case .ms(let d): return "\(trim(d)) ms"
        case .seconds(let d): return "\(trim(d)) s"
        case .percent(let d): return "\(trim(d))%"
        case .bool(let b): return b ? "on" : "off"
        case .number(let d): return trim(d)
        case .text(let s): return s
        case .position(let p): return p.description
        }
    }

    public static func magnitude(_ v: LogicValue) -> Double? {
        switch v {
        case .dB(let d), .ms(let d), .seconds(let d), .percent(let d), .number(let d): return d
        case .pan(let p): return Double(p)
        case .bool(let b): return b ? 1 : 0
        case .text, .position: return nil
        }
    }

    static func trim(_ d: Double) -> String {
        if d == d.rounded(), abs(d) < 1e12 { return String(Int(d)) }
        return String(format: "%.2f", d).replacingOccurrences(of: #"0+$"#, with: "", options: .regularExpression)
    }
}
```

  - [ ] **Step 4: Прогнать** → PASS (5). **Step 5: Commit** — `git add Sources/LogicKit/Map/Values.swift Tests/LogicKitTests/ValuesTests.swift && git commit -m "logic-unit value parsing"`

---

### Task 19: Пути

**Files:** Create `Sources/LogicKit/Map/Path.swift`; Test `Tests/LogicKitTests/PathTests.swift`

**Interfaces:**
  - Consumes: `LogicError.invalidArgs`.
  - Produces: `enum NodeKind: String, CaseIterable, Sendable` (`root="/"`, transport, track, strip, insert, param, send, meter, take, region, master, marker, patches, render, ui, system, schema, raw); `enum Selector: Equatable, Sendable { number(Int), name(String), selected, handle(String), id(String) }`; `struct PathSegment: Equatable, Sendable { kind; selector: Selector?; position: String?; init(_:_:position:) }`; `struct LPath: Equatable, Sendable, CustomStringConvertible { segments; property: String?; static func parse(_:) throws -> LPath }`; `LPath.grammar: String`.

  - [ ] **Step 1: Падающие тесты**

```swift
import XCTest
@testable import LogicKit

final class PathTests: XCTestCase {
    func testRootForms() throws {
        XCTAssertEqual(try LPath.parse("/"), LPath(segments: []))
        XCTAssertEqual(try LPath.parse(""), LPath(segments: []))
        XCTAssertEqual(try LPath.parse("/track:3"), try LPath.parse("track:3"))
    }

    func testSelectors() throws {
        XCTAssertEqual(try LPath.parse("track:3").segments, [PathSegment(.track, .number(3))])
        XCTAssertEqual(try LPath.parse(#"track:"Rose \"V\"""#).segments, [PathSegment(.track, .name("Rose \"V\""))])
        XCTAssertEqual(try LPath.parse("track:selected/strip").segments, [PathSegment(.track, .selected), PathSegment(.strip)])
        XCTAssertEqual(try LPath.parse("#t4f2").segments, [PathSegment(.track, .handle("#t4f2"))])
        XCTAssertEqual(try LPath.parse("track:3/insert:2/param:Make Up").segments.last, PathSegment(.param, .name("Make Up")))
        XCTAssertEqual(try LPath.parse("render:r3").segments, [PathSegment(.render, .id("r3"))])
        XCTAssertEqual(try LPath.parse(#"track:3/region@"17 1 1 1""#).segments.last, PathSegment(.region, position: "17 1 1 1"))
    }

    func testPropertyAndSchema() throws {
        let p = try LPath.parse("track:3/mute")
        XCTAssertEqual(p.segments, [PathSegment(.track, .number(3))])
        XCTAssertEqual(p.property, "mute")
        XCTAssertEqual(try LPath.parse("system/schema/track").segments, [PathSegment(.system), PathSegment(.schema, .id("track"))])
    }

    func testErrors() {
        for bad in ["track", "transport:1", "bogus:1", #"track:"open"#, "track:3/mute/solo", "region"] {
            XCTAssertThrowsError(try LPath.parse(bad), bad) { e in
                guard case LogicError.invalidArgs = e else { return XCTFail("\(bad): \(e)") }
            }
        }
    }

    func testCanonicalDescription() throws {
        for s in ["/", "track:3", #"track:"Rose Vocal"/strip"#, "track:selected/insert:2/param:\"Make Up\"", "transport/position",
                  "system/schema/track", #"track:3/region@"17 1 1 1""#] {
            XCTAssertEqual(try LPath.parse(s).description, s)
        }
    }
}
```

  - [ ] **Step 2: Прогнать** → FAIL.

  - [ ] **Step 3: Реализация** `Sources/LogicKit/Map/Path.swift`:
```swift
import Foundation

public enum NodeKind: String, CaseIterable, Sendable {
    case root = "/", transport, track, strip, insert, param, send, meter, take, region, master, marker, patches, render, ui, system, schema, raw

    var needsSelector: Bool { [.track, .insert, .param, .send, .take, .marker, .render, .schema].contains(self) }
    var forbidsSelector: Bool { [.transport, .strip, .meter, .master, .patches, .ui, .system].contains(self) }
    /// Bare selector words are ids for these kinds, names otherwise.
    var bareIsID: Bool { [.render, .raw, .schema].contains(self) }
    static let handlePrefixes: [Character: NodeKind] = ["t": .track, "i": .insert, "s": .send, "k": .take, "r": .region, "m": .marker]
}

public enum Selector: Equatable, Sendable {
    case number(Int), name(String), selected, handle(String), id(String)
}

public struct PathSegment: Equatable, Sendable {
    public var kind: NodeKind
    public var selector: Selector?
    public var position: String?

    public init(_ kind: NodeKind, _ selector: Selector? = nil, position: String? = nil) {
        self.kind = kind; self.selector = selector; self.position = position
    }

    var text: String {
        if kind == .schema, case .id(let k)? = selector { return "schema/\(k)" }
        var s = kind.rawValue
        switch selector {
        case .number(let n)?: s += ":\(n)"
        case .name(let n)?: s += ":\"\(n.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\\\""))\""
        case .selected?: s += ":selected"
        case .handle(let h)?: s += ":\(h)"
        case .id(let i)?: s += ":\(i)"
        case nil: break
        }
        if let position { s += "@\"\(position)\"" }
        return s
    }
}

public struct LPath: Equatable, Sendable, CustomStringConvertible {
    public var segments: [PathSegment]
    public var property: String?

    public init(segments: [PathSegment] = [], property: String? = nil) {
        self.segments = segments; self.property = property
    }

    public static let grammar = #"path := segment ("/" segment)* ["/" property]; segment := kind[:selector|@position]; selector := N | "name" | selected | #handle"#

    public var description: String {
        var parts = segments.map(\.text)
        if let property { parts.append(property) }
        return parts.isEmpty ? "/" : parts.joined(separator: "/")
    }

    static func bad(_ detail: String) -> LogicError { .invalidArgs(signature: grammar, detail: detail) }

    public static func parse(_ input: String) throws -> LPath {
        var s = input.trimmingCharacters(in: .whitespaces)
        if s.hasPrefix("/") { s.removeFirst() }
        if s.isEmpty { return LPath() }
        let tokens = try split(s)
        var out = LPath()
        var i = 0
        while i < tokens.count {
            let tok = tokens[i]
            let isLast = i == tokens.count - 1
            if tok.hasPrefix("#") {
                guard let c = tok.dropFirst().first, let kind = NodeKind.handlePrefixes[c] else { throw bad("unknown handle \(tok)") }
                out.segments.append(PathSegment(kind, .handle(tok)))
                i += 1; continue
            }
            let name = String(tok.prefix(while: { $0.isLetter || $0 == "_" }))
            let rest = tok.dropFirst(name.count)
            guard let kind = NodeKind(rawValue: name), kind != .root else {
                if isLast, rest.isEmpty, !name.isEmpty, !out.segments.isEmpty {
                    out.property = name; i += 1; continue
                }
                throw bad("unknown kind '\(name)' in \(input)")
            }
            var seg = PathSegment(kind)
            if kind == .schema {
                guard rest.isEmpty, i + 1 < tokens.count, NodeKind(rawValue: tokens[i + 1]) != nil else { throw bad("expected system/schema/<kind>") }
                seg.selector = .id(tokens[i + 1])
                out.segments.append(seg); i += 2; continue
            }
            if rest.hasPrefix(":") {
                seg.selector = try selector(String(rest.dropFirst()), kind: kind)
            } else if rest.hasPrefix("@") {
                seg.position = try unquote(String(rest.dropFirst()))
            } else if !rest.isEmpty {
                throw bad("unexpected '\(rest)' after \(name)")
            }
            if kind.forbidsSelector && (seg.selector != nil || seg.position != nil) { throw bad("\(name) takes no selector") }
            if kind.needsSelector && seg.selector == nil { throw bad("\(name) needs a selector, e.g. \(name):3 or \(name):\"Name\"") }
            if kind == .region && seg.selector == nil && seg.position == nil { throw bad("region needs @\"bar beat div tick\" or :\"name\"") }
            out.segments.append(seg)
            i += 1
        }
        if out.property != nil, out.segments.isEmpty { throw bad("property without a node") }
        return out
    }

    /// Splits on "/" outside double quotes.
    static func split(_ s: String) throws -> [String] {
        var tokens: [String] = [], cur = "", inQuote = false, escape = false
        for ch in s {
            if escape { cur.append(ch); escape = false; continue }
            if ch == "\\" && inQuote { cur.append(ch); escape = true; continue }
            if ch == "\"" { inQuote.toggle() }
            if ch == "/" && !inQuote { tokens.append(cur); cur = ""; continue }
            cur.append(ch)
        }
        guard !inQuote else { throw bad("unterminated quote in \(s)") }
        tokens.append(cur)
        guard !tokens.contains(where: \.isEmpty) else { throw bad("empty segment in \(s)") }
        return tokens
    }

    static func unquote(_ s: String) throws -> String {
        guard s.hasPrefix("\"") else { return s }
        guard s.count >= 2, s.hasSuffix("\"") else { throw bad("unterminated quote") }
        var out = "", escape = false
        for ch in s.dropFirst().dropLast() {
            if escape { out.append(ch); escape = false } else if ch == "\\" { escape = true } else { out.append(ch) }
        }
        return out
    }

    static func selector(_ raw: String, kind: NodeKind) throws -> Selector {
        guard !raw.isEmpty else { throw bad("empty selector for \(kind.rawValue)") }
        if raw.hasPrefix("\"") { return .name(try unquote(raw)) }
        if let n = Int(raw) { return .number(n) }
        if raw == "selected" { return .selected }
        if raw.hasPrefix("#") { return .handle(raw) }
        return kind.bareIsID ? .id(raw) : .name(raw)
    }
}
```
`transport/position` — `property` у синглтона `transport`; свойство без узла (`"mute"`) — ошибка.

  - [ ] **Step 4: Прогнать** → PASS (5). **Step 5: Commit** — `git add Sources/LogicKit/Map/Path.swift Tests/LogicKitTests/PathTests.swift && git commit -m "map path grammar"`

---

### Task 20: LocaleTable

**Files:** Create `Sources/LogicKit/Platform/LocaleTable.swift`; Test `Tests/LogicKitTests/LocaleTableTests.swift`

**Interfaces:** Produces `enum Anchor: String, CaseIterable, Sendable` (ровно список из Task 16 Step 1); `struct LocaleTable: Sendable { language: String; subscript(_ a: Anchor) -> String; func list(_ a: Anchor) -> [String]; static let en }`.

  - [ ] **Step 1: Тест**
```swift
import XCTest
@testable import LogicKit

final class LocaleTableTests: XCTestCase {
    func testEveryAnchorHasAString() {
        for a in Anchor.allCases { XCTAssertFalse(LocaleTable.en[a].isEmpty, a.rawValue) }
    }
    func testListAnchor() {
        XCTAssertTrue(LocaleTable.en.list(.modalSubroles).contains("AXDialog"))
    }
}
```
  - [ ] **Step 2: Прогнать** → FAIL.
  - [ ] **Step 3: Реализация**. Строки берутся из таблицы «Якоря» `spikes-2026-09.md`. Ниже — гипотезы, которые заменяются найденными значениями:
```swift
public enum Anchor: String, CaseIterable, Sendable {
    case tracksHeader, trackRowDescPrefix, takeLaneSuffix, noOutputFlag
    case mute, solo, recordEnable, headerVolume, headerPan
    case inspectorStripHelpPrefix, stripVolume, stripPan, pluginBypass, pluginOpen, pluginList, peakMeterTitlePrefix
    case controlBar, play, stop, record, pause, cycle, positionField
    case menuEdit, menuUndoPrefix, menuRedoPrefix
    case modalSubroles
}

/// Every AX string Logic shows lives here (spec §9). Another UI language = another table.
public struct LocaleTable: Sendable {
    public let language: String
    private let strings: [Anchor: String]

    public subscript(_ a: Anchor) -> String { strings[a] ?? "" }
    public func list(_ a: Anchor) -> [String] { self[a].split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) } }

    public static let en = LocaleTable(language: "en", strings: [
        .tracksHeader: "Tracks header", .trackRowDescPrefix: "Track ", .takeLaneSuffix: "Take", .noOutputFlag: "no output",
        .mute: "Mute", .solo: "Solo", .recordEnable: "Record Enable", .headerVolume: "Volume", .headerPan: "Pan",
        .inspectorStripHelpPrefix: "Left inspector channel strip", .stripVolume: "volume fader", .stripPan: "pan",
        .pluginBypass: "bypass", .pluginOpen: "open", .pluginList: "list", .peakMeterTitlePrefix: "peak level meter",
        .controlBar: "Control Bar", .play: "Play", .stop: "Stop", .record: "Record", .pause: "Pause", .cycle: "Cycle",
        .positionField: "Position",
        .menuEdit: "Edit", .menuUndoPrefix: "Undo", .menuRedoPrefix: "Redo",
        .modalSubroles: "AXDialog, AXSystemDialog",
    ])
}
```
  - [ ] **Step 4: PASS. Step 5: Commit** — `git commit -am` не использовать; `git add Sources/LogicKit/Platform/LocaleTable.swift Tests/LogicKitTests/LocaleTableTests.swift && git commit -m "locale table with spike anchors"`

---

### Task 21: Модель и ридеры

**Files:** Create `Sources/LogicKit/Map/Model.swift`, `Sources/LogicKit/Map/Readers.swift`; Test `Tests/LogicKitTests/ReadersTests.swift`

**Interfaces:**
  - Consumes: `AXRoot`, `AXMatch`, `LocaleTable`, `LogicError`.
  - Produces:
  - `enum TrackKind: String, Sendable { audio, instrument, aux, stack, unknown }` (в P1 заполняются только `stack`/`unknown`; тип по inspector — P2)
  - `struct TrackInfo: Equatable, Sendable { number, name, kind, mute: Bool?, solo: Bool?, arm: Bool?, selected: Bool, hasOutput: Bool, takeLanes: Int, volume: String?, pan: String? }` + memberwise `public init` с дефолтами
  - `struct InsertInfo { slot: Int; name: String; bypassed: Bool? }`, `struct StripInfo { volume, pan: String?; inserts: [InsertInfo]; peak: String? }`
  - `enum TransportState: String { stopped, playing, recording, paused }`, `struct TransportInfo { state: TransportState?; position: String?; cycle: Bool? }`, `struct ProjectInfo { name: String; logicVersion: String? }`
  - `func boolValue(_ v: AXScalar?) -> Bool?` (internal)
  - `struct TrackRowDesc { number, name, flags; static func parse(_:locale:) -> TrackRowDesc? }`
  - `enum TrackReader { header(_:_:), read(_:_:) -> [TrackInfo], row(number:_:_:) -> any AXNode, selectedNumber(_:_:) -> Int? }`
  - `enum StripReader { inspector(_:_:) -> StripInfo? }`, `enum TransportReader { controlBar(_:_:) -> any AXNode; read(_:_:) -> TransportInfo }`, `enum ModalGuard { modalTitle(_:_:) -> String? }`, `enum ProjectReader { read(_:version:) -> ProjectInfo }`, `enum AnchorProbe { missing(_:_:) -> [Anchor] }`

  - [ ] **Step 1: Падающие тесты** (имена для «бело красного» — из ground truth в `spikes-2026-09.md`; ниже факты из `OBSERVATIONS.md`, они должны совпасть)

```swift
import XCTest
@testable import LogicKit

final class ReadersTests: XCTestCase {
    let L = LocaleTable.en
    func root(_ name: String) throws -> FixtureAXRoot { FixtureAXRoot(try AXFixture.load(Fixtures.url("ax/\(name).json"))) }

    func testRowDesc() {
        XCTAssertEqual(TrackRowDesc.parse("Track 4 “PreDelay”, no output", locale: L),
                       TrackRowDesc(number: 4, name: "PreDelay", flags: ["no output"]))
        XCTAssertEqual(TrackRowDesc.parse("Track 3 “Warm, Vocal”, Take", locale: L)?.name, "Warm, Vocal")
        XCTAssertNil(TrackRowDesc.parse("Region 1", locale: L))
    }

    func testMiniTracks() throws {
        let tracks = try TrackReader.read(try root("mini"), L)
        XCTAssertEqual(tracks.map(\.number), [1, 2, 3, 4])
        XCTAssertEqual(tracks[0].solo, true)
        XCTAssertEqual(tracks[0].mute, false)
        XCTAssertEqual(tracks[0].volume, "0.0 dB")
        XCTAssertEqual(tracks[1].kind, .stack)
        XCTAssertEqual(tracks[2].takeLanes, 2)
        XCTAssertFalse(tracks[3].hasOutput)
        XCTAssertEqual(try TrackReader.selectedNumber(try root("mini"), L), 2)
        XCTAssertEqual(try TrackReader.row(number: 3, try root("mini"), L).attrs().desc, "Track 3 “Warm Vocal”")
    }

    func testMiniStripTransportModal() throws {
        let r = try root("mini")
        let strip = try XCTUnwrap(StripReader.inspector(r, L))
        XCTAssertEqual(strip.volume, "-4.2 dB")
        XCTAssertEqual(strip.inserts, [InsertInfo(slot: 1, name: "Channel EQ", bypassed: false),
                                       InsertInfo(slot: 2, name: "ChromaVerb", bypassed: true)])
        XCTAssertEqual(strip.peak, "-4.7 dB")
        XCTAssertEqual(try TransportReader.read(r, L).state, .stopped)
        XCTAssertNil(try ModalGuard.modalTitle(r, L))
        XCTAssertEqual(try ProjectReader.read(r, version: "11.2").name, "fixture-mini")
        XCTAssertEqual(try AnchorProbe.missing(r, L), [])
    }

    func testBeloKrasnyMatchesGroundTruth() throws {
        let r = try root("belo-krasny")
        let tracks = try TrackReader.read(r, L)
        XCTAssertEqual(tracks.count, 5)
        let names = Set(tracks.map(\.name))
        for n in ["Rose Vocal", "PreDelay", "Warmth"] { XCTAssertTrue(names.contains(n), n) }
        XCTAssertEqual(tracks.first { $0.name == "PreDelay" }?.hasOutput, false)
        XCTAssertGreaterThanOrEqual(tracks.map(\.takeLanes).max() ?? 0, 15)
        XCTAssertEqual(tracks.filter(\.selected).map(\.name), ["Rose Vocal"])
        let strip = try XCTUnwrap(StripReader.inspector(r, L))
        XCTAssertEqual(strip.inserts.count, 5)
        XCTAssertTrue(strip.inserts[0].name.hasPrefix("Channel"))
    }

    func testBigHasAllTracks() throws {
        // S12 🟢: AX exposes every track row. If S12 was not green, replace with the spec §4.6 rule recorded in Task 16.
        XCTAssertGreaterThanOrEqual(try TrackReader.read(try root("big"), L).count, 40)
    }
}
```

  - [ ] **Step 2: Прогнать** → FAIL.

  - [ ] **Step 3: Реализация**

`Sources/LogicKit/Map/Model.swift`:
```swift
public enum TrackKind: String, Sendable { case audio, instrument, aux, stack, unknown }

public struct TrackInfo: Equatable, Sendable {
    public var number: Int
    public var name: String
    public var kind: TrackKind
    public var mute: Bool?
    public var solo: Bool?
    public var arm: Bool?
    public var selected: Bool
    public var hasOutput: Bool
    public var takeLanes: Int
    public var volume: String?
    public var pan: String?

    public init(number: Int, name: String, kind: TrackKind = .unknown, mute: Bool? = nil, solo: Bool? = nil,
                arm: Bool? = nil, selected: Bool = false, hasOutput: Bool = true, takeLanes: Int = 0,
                volume: String? = nil, pan: String? = nil) {
        self.number = number; self.name = name; self.kind = kind; self.mute = mute; self.solo = solo; self.arm = arm
        self.selected = selected; self.hasOutput = hasOutput; self.takeLanes = takeLanes; self.volume = volume; self.pan = pan
    }
}

public struct InsertInfo: Equatable, Sendable {
    public var slot: Int
    public var name: String
    public var bypassed: Bool?
    public init(slot: Int, name: String, bypassed: Bool?) { self.slot = slot; self.name = name; self.bypassed = bypassed }
}

public struct StripInfo: Equatable, Sendable {
    public var volume: String?
    public var pan: String?
    public var inserts: [InsertInfo]
    public var peak: String?
}

public enum TransportState: String, Sendable { case stopped, playing, recording, paused }

public struct TransportInfo: Equatable, Sendable {
    public var state: TransportState?
    public var position: String?
    public var cycle: Bool?
}

public struct ProjectInfo: Equatable, Sendable {
    public var name: String
    public var logicVersion: String?
}
```

`Sources/LogicKit/Map/Readers.swift`:
```swift
import Foundation

func boolValue(_ v: AXScalar?) -> Bool? {
    switch v {
    case .bool(let b)?: return b
    case .number(let d)?: return d != 0
    case .string(let s)?: return s == "1"
    case nil: return nil
    }
}

/// `Track 3 “Warm Vocal”, Take` → number 3, name, flags ["Take"].
public struct TrackRowDesc: Equatable, Sendable {
    public var number: Int
    public var name: String
    public var flags: [String]

    public static func parse(_ desc: String, locale: LocaleTable) -> TrackRowDesc? {
        guard desc.hasPrefix(locale[.trackRowDescPrefix]) else { return nil }
        let rest = desc.dropFirst(locale[.trackRowDescPrefix].count)
        guard let number = Int(rest.prefix(while: \.isNumber)),
              let open = rest.firstIndex(of: "“"), let close = rest.lastIndex(of: "”"), open < close else { return nil }
        let name = String(rest[rest.index(after: open)..<close])
        let flags = rest[rest.index(after: close)...].split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
        return TrackRowDesc(number: number, name: name, flags: flags)
    }
}

public enum TrackReader {
    public static func header(_ root: any AXRoot, _ L: LocaleTable) throws -> any AXNode {
        guard let main = try root.mainWindow() else { throw LogicError.unavailable("Logic has no main window") }
        guard let h = try main.firstDescendant(AXMatch(role: "AXGroup", desc: .equals(L[.tracksHeader]))) else {
            throw LogicError.anchorMissing("tracksHeader")
        }
        return h
    }

    public static func read(_ root: any AXRoot, _ L: LocaleTable) throws -> [TrackInfo] {
        var result: [TrackInfo] = []
        for row in try header(root, L).children() {
            let a = try row.attrs()
            guard let d = a.desc, let p = TrackRowDesc.parse(d, locale: L) else { continue }
            if p.flags.contains(L[.takeLaneSuffix]) {
                if let i = result.lastIndex(where: { $0.number == p.number }) { result[i].takeLanes += 1 }
                continue
            }
            func toggle(_ anchor: Anchor) throws -> Bool? {
                boolValue(try row.firstDescendant(AXMatch(role: "AXCheckBox", desc: .equals(L[anchor])), maxDepth: 4)?.attrs().value)
            }
            func slider(_ anchor: Anchor) throws -> String? {
                try row.firstDescendant(AXMatch(role: "AXSlider", desc: .equals(L[anchor])), maxDepth: 4)?.attrs().valueDescription
            }
            let triangle = try row.firstDescendant(AXMatch(role: "AXDisclosureTriangle"), maxDepth: 3) != nil
            result.append(TrackInfo(number: p.number, name: p.name, kind: triangle ? .stack : .unknown,
                                    mute: try toggle(.mute), solo: try toggle(.solo), arm: try toggle(.recordEnable),
                                    selected: a.selected ?? false, hasOutput: !p.flags.contains(L[.noOutputFlag]),
                                    volume: try slider(.headerVolume), pan: try slider(.headerPan)))
        }
        // A take folder also has a disclosure triangle: it is not a stack.
        for i in result.indices where result[i].takeLanes > 0 && result[i].kind == .stack { result[i].kind = .unknown }
        return result
    }

    public static func row(number: Int, _ root: any AXRoot, _ L: LocaleTable) throws -> any AXNode {
        for row in try header(root, L).children() {
            guard let d = try row.attrs().desc, let p = TrackRowDesc.parse(d, locale: L),
                  p.number == number, !p.flags.contains(L[.takeLaneSuffix]) else { continue }
            return row
        }
        throw LogicError.notFound("track:\(number)", candidates: [])
    }

    public static func selectedNumber(_ root: any AXRoot, _ L: LocaleTable) throws -> Int? {
        for row in try header(root, L).children() {
            let a = try row.attrs()
            guard a.selected == true, let d = a.desc, let p = TrackRowDesc.parse(d, locale: L),
                  !p.flags.contains(L[.takeLaneSuffix]) else { continue }
            return p.number
        }
        return nil
    }
}

public enum StripReader {
    /// Spec §4.2: the full strip exists only for the selected track (Left inspector channel strip).
    /// Slot numbers follow plugin order; gaps between slots are checked from P2 (S7).
    public static func inspector(_ root: any AXRoot, _ L: LocaleTable) throws -> StripInfo? {
        guard let main = try root.mainWindow(),
              let strip = try main.firstDescendant(AXMatch(role: "AXLayoutItem", help: .prefix(L[.inspectorStripHelpPrefix]))) else { return nil }
        let volume = try strip.firstDescendant(AXMatch(role: "AXSlider", desc: .equals(L[.stripVolume])))?.attrs().valueDescription
        let pan = try strip.firstDescendant(AXMatch(role: "AXSlider", desc: .equals(L[.stripPan])))?.attrs().valueDescription
        var inserts: [InsertInfo] = []
        for group in try strip.allDescendants(AXMatch(role: "AXGroup"), descendIntoMatches: true) {
            guard let bypass = try group.firstChild(AXMatch(role: "AXCheckBox", desc: .equals(L[.pluginBypass]))),
                  let name = try group.attrs().desc, !name.isEmpty else { continue }
            inserts.append(InsertInfo(slot: inserts.count + 1, name: name, bypassed: boolValue(try bypass.attrs().value)))
        }
        let peakTitle = try strip.firstDescendant(AXMatch(title: .prefix(L[.peakMeterTitlePrefix])))?.attrs().title
        let peak = peakTitle.flatMap { t in t.range(of: ", ").map { String(t[$0.upperBound...]) } }
        return StripInfo(volume: volume, pan: pan, inserts: inserts, peak: peak)
    }
}

public enum TransportReader {
    public static func controlBar(_ root: any AXRoot, _ L: LocaleTable) throws -> any AXNode {
        guard let main = try root.mainWindow() else { throw LogicError.unavailable("Logic has no main window") }
        guard let bar = try main.firstDescendant(AXMatch(role: "AXGroup", desc: .equals(L[.controlBar]))) else {
            throw LogicError.anchorMissing("controlBar")
        }
        return bar
    }

    public static func read(_ root: any AXRoot, _ L: LocaleTable) throws -> TransportInfo {
        let bar = try controlBar(root, L)
        func on(_ a: Anchor) throws -> Bool? {
            boolValue(try bar.firstDescendant(AXMatch(role: "AXCheckBox", desc: .equals(L[a])), maxDepth: 5)?.attrs().value)
        }
        let rec = try on(.record), play = try on(.play), pause = try on(.pause)
        let state: TransportState? = rec == true ? .recording : pause == true ? .paused : play == true ? .playing
            : play == nil ? nil : .stopped
        let pos = try bar.firstDescendant(AXMatch(desc: .equals(L[.positionField])), maxDepth: 6)?.attrs()
        return TransportInfo(state: state, position: pos?.valueDescription ?? pos?.value?.stringValue, cycle: try on(.cycle))
    }
}

public enum ModalGuard {
    /// Spec §5.4: a modal becomes AXMainWindow; its subrole tells it apart (rule from S1).
    public static func modalTitle(_ root: any AXRoot, _ L: LocaleTable) throws -> String? {
        guard let a = try root.mainWindow()?.attrs(), let sub = a.subrole else { return nil }
        return L.list(.modalSubroles).contains(sub) ? (a.title ?? "untitled") : nil
    }
}

public enum ProjectReader {
    public static func read(_ root: any AXRoot, version: String?) throws -> ProjectInfo {
        let title = try root.mainWindow()?.attrs().title ?? ""
        return ProjectInfo(name: title.components(separatedBy: " - ").first ?? title, logicVersion: version)
    }
}

public enum AnchorProbe {
    /// Version fingerprint (spec §9): anchors the P1 slice cannot work without.
    public static func missing(_ root: any AXRoot, _ L: LocaleTable) throws -> [Anchor] {
        var out: [Anchor] = []
        do { _ = try TrackReader.header(root, L) } catch LogicError.anchorMissing { out.append(.tracksHeader) }
        do { _ = try TransportReader.controlBar(root, L) } catch LogicError.anchorMissing { out.append(.controlBar) }
        return out
    }
}
```

  - [ ] **Step 4: Прогнать** — `swift test --filter ReadersTests`. Если «бело красный» расходится с ground truth, поправить якорь в `LocaleTable.en` или разбор, но не ожидания теста.
  - [ ] **Step 5: Commit** — `git add Sources/LogicKit/Map/Model.swift Sources/LogicKit/Map/Readers.swift Tests/LogicKitTests/ReadersTests.swift && git commit -m "track, strip, transport readers over ax"`

---

### Task 22: Хэндлы

**Files:** Create `Sources/LogicKit/Map/Handles.swift`; Test `Tests/LogicKitTests/HandlesTests.swift`

**Interfaces:** Produces `struct Fingerprint: Hashable, Sendable { kind: NodeKind; number: Int?; name: String; parent: String; prev: String?; next: String? }`; `enum HandleMatch: Equatable { exact(Int), moved(Int), stale }`; `final class HandleTable: Sendable { handle(for:) -> String; fingerprint(_:) -> Fingerprint?; reset(); static func match(_:in:) -> HandleMatch }`.

  - [ ] **Step 1: Тесты**
```swift
import XCTest
@testable import LogicKit

final class HandlesTests: XCTestCase {
    func fp(_ n: Int, _ name: String, _ prev: String?, _ next: String?) -> Fingerprint {
        Fingerprint(kind: .track, number: n, name: name, parent: "/", prev: prev, next: next)
    }

    func testHandleIsStableShortAndPrefixed() {
        let t = HandleTable()
        let h = t.handle(for: fp(3, "C", "B", "D"))
        XCTAssertEqual(h, t.handle(for: fp(3, "C", "B", "D")))
        XCTAssertTrue(h.hasPrefix("#t"))
        XCTAssertEqual(h.count, 6)
        XCTAssertEqual(t.fingerprint(h), fp(3, "C", "B", "D"))
        t.reset()
        XCTAssertNil(t.fingerprint(h))
    }

    func testMatchRules() {
        let c = fp(3, "C", "B", "D")
        XCTAssertEqual(HandleTable.match(c, in: [fp(1, "A", nil, "B"), fp(2, "B", "A", "C"), c]), .exact(2))
        // A track inserted at the top: C is now 4, neighbours unchanged → moved
        XCTAssertEqual(HandleTable.match(c, in: [fp(1, "X", nil, "A"), fp(2, "A", "X", "B"), fp(3, "B", "A", "C"), fp(4, "C", "B", "D")]), .moved(3))
        // C deleted: B and D are now neighbours
        XCTAssertEqual(HandleTable.match(c, in: [fp(2, "B", "A", "D"), fp(3, "D", "B", nil)]), .stale)
        // same name only → stale, never a hijack
        XCTAssertEqual(HandleTable.match(c, in: [fp(9, "C", "Q", "R")]), .stale)
    }
}
```
  - [ ] **Step 2: FAIL. Step 3: Реализация**
```swift
import Foundation
import os

public struct Fingerprint: Hashable, Sendable {
    public var kind: NodeKind
    public var number: Int?
    public var name: String
    public var parent: String
    public var prev: String?
    public var next: String?
    public init(kind: NodeKind, number: Int?, name: String, parent: String, prev: String?, next: String?) {
        self.kind = kind; self.number = number; self.name = name; self.parent = parent; self.prev = prev; self.next = next
    }
}

public enum HandleMatch: Equatable, Sendable { case exact(Int), moved(Int), stale }

/// Spec §4.4. Handles guard against hitting the wrong node; they are not a guarantee.
public final class HandleTable: Sendable {
    private struct State { var byHandle: [String: Fingerprint] = [:]; var byPrint: [Fingerprint: String] = [:] }
    private let state = OSAllocatedUnfairLock(initialState: State())

    public init() {}

    public func handle(for fp: Fingerprint) -> String {
        state.withLock { s in
            if let h = s.byPrint[fp] { return h }
            let prefix = NodeKind.handlePrefixes.first { $0.value == fp.kind }.map { String($0.key) } ?? "n"
            let hex = String(Self.fnv1a("\(fp.kind.rawValue)|\(fp.number ?? -1)|\(fp.name)|\(fp.parent)|\(fp.prev ?? "")|\(fp.next ?? "")"), radix: 16)
            var len = 4
            var h = "#" + prefix + String(hex.prefix(len))
            while let other = s.byHandle[h], other != fp, len < hex.count { len += 2; h = "#" + prefix + String(hex.prefix(len)) }
            s.byHandle[h] = fp
            s.byPrint[fp] = h
            return h
        }
    }

    public func fingerprint(_ handle: String) -> Fingerprint? { state.withLock { $0.byHandle[handle] } }

    /// After any structural mutation (create/delete/undo/redo/project change).
    public func reset() { state.withLock { $0 = State() } }

    public static func match(_ fp: Fingerprint, in candidates: [Fingerprint]) -> HandleMatch {
        if let i = candidates.firstIndex(of: fp) { return .exact(i) }
        let same = candidates.indices.filter {
            let c = candidates[$0]
            return c.kind == fp.kind && c.parent == fp.parent && c.prev == fp.prev && c.next == fp.next
        }
        return same.count == 1 ? .moved(same[0]) : .stale
    }

    static func fnv1a(_ s: String) -> UInt64 {
        var h: UInt64 = 0xcbf29ce484222325
        for b in s.utf8 { h = (h ^ UInt64(b)) &* 0x100000001b3 }
        return h
    }
}
```
Хэш FNV-1a 64 выводится в hex; если число начинается с нулей, hex короче 16 символов, но `prefix(4)` всё равно берёт 4 символа.
  - [ ] **Step 4: PASS. Step 5: Commit** — `git add Sources/LogicKit/Map/Handles.swift Tests/LogicKitTests/HandlesTests.swift && git commit -m "handles with fingerprint matching"`

---

### Task 23: Резолвер

**Files:** Create `Sources/LogicKit/Map/Resolver.swift`; Test `Tests/LogicKitTests/ResolverTests.swift`

**Interfaces:** Produces `enum Resolver { trackFingerprints(_:) -> [Fingerprint]; handles(for:table:) -> [String]; track(_ selector: Selector, in: [TrackInfo], table: HandleTable) throws -> (TrackInfo, note: String?); canonical(_ path: LPath) -> LPath; label(_:) -> String }`.

  - [ ] **Step 1: Тесты**
```swift
import XCTest
@testable import LogicKit

final class ResolverTests: XCTestCase {
    let tracks = [TrackInfo(number: 1, name: "Beat"), TrackInfo(number: 2, name: "Vox", selected: true),
                  TrackInfo(number: 3, name: "Vox"), TrackInfo(number: 4, name: "PreDelay")]

    func testNumberNameSelected() throws {
        let t = HandleTable()
        XCTAssertEqual(try Resolver.track(.number(4), in: tracks, table: t).0.name, "PreDelay")
        XCTAssertEqual(try Resolver.track(.name("Beat"), in: tracks, table: t).0.number, 1)
        XCTAssertEqual(try Resolver.track(.selected, in: tracks, table: t).0.number, 2)
        XCTAssertThrowsError(try Resolver.track(.name("Vox"), in: tracks, table: t)) {
            XCTAssertEqual($0 as? LogicError, .ambiguous("track:\"Vox\"", candidates: ["track:2 \"Vox\"", "track:3 \"Vox\""]))
        }
        XCTAssertThrowsError(try Resolver.track(.name("pre"), in: tracks, table: t)) {
            XCTAssertEqual($0 as? LogicError, .notFound("track:\"pre\"", candidates: ["track:4 \"PreDelay\""]))
        }
        XCTAssertThrowsError(try Resolver.track(.number(9), in: tracks, table: t))
    }

    func testHandlesExactMovedStale() throws {
        let t = HandleTable()
        let h = Resolver.handles(for: tracks, table: t)[3]   // PreDelay: prev Vox, next nil
        XCTAssertEqual(try Resolver.track(.handle(h), in: tracks, table: t).1, nil)
        let shifted = [TrackInfo(number: 1, name: "New")] + tracks.map { var x = $0; x.number += 1; return x }
        let (moved, note) = try Resolver.track(.handle(h), in: shifted, table: t)
        XCTAssertEqual(moved.number, 5)
        XCTAssertEqual(note, "moved 4→5")
        XCTAssertThrowsError(try Resolver.track(.handle(h), in: Array(tracks.dropLast()), table: t)) {
            XCTAssertEqual($0 as? LogicError, .staleRef(h))
        }
        XCTAssertThrowsError(try Resolver.track(.handle("#t0000"), in: tracks, table: t))
    }

    func testCanonicalStackPath() throws {
        XCTAssertEqual(Resolver.canonical(try LPath.parse("track:3/track:5/strip")).description, "track:5/strip")
    }
}
```
  - [ ] **Step 2: FAIL. Step 3: Реализация**
```swift
public enum Resolver {
    public static func label(_ t: TrackInfo) -> String { "track:\(t.number) \"\(t.name)\"" }

    public static func trackFingerprints(_ tracks: [TrackInfo]) -> [Fingerprint] {
        tracks.indices.map { i in
            Fingerprint(kind: .track, number: tracks[i].number, name: tracks[i].name, parent: "/",
                        prev: i > 0 ? tracks[i - 1].name : nil, next: i + 1 < tracks.count ? tracks[i + 1].name : nil)
        }
    }

    public static func handles(for tracks: [TrackInfo], table: HandleTable) -> [String] {
        trackFingerprints(tracks).map(table.handle(for:))
    }

    public static func track(_ selector: Selector, in tracks: [TrackInfo], table: HandleTable) throws -> (TrackInfo, note: String?) {
        switch selector {
        case .number(let n):
            if let t = tracks.first(where: { $0.number == n }) { return (t, nil) }
            let near = tracks.sorted { abs($0.number - n) < abs($1.number - n) }.prefix(5).map(label)
            throw LogicError.notFound("track:\(n)", candidates: Array(near))
        case .name(let name):
            let hits = tracks.filter { $0.name == name }
            if hits.count == 1 { return (hits[0], nil) }
            if hits.count > 1 { throw LogicError.ambiguous("track:\"\(name)\"", candidates: hits.map(label)) }
            throw LogicError.notFound("track:\"\(name)\"", candidates: tracks.filter { $0.name.localizedCaseInsensitiveContains(name) }.map(label))
        case .selected:
            let sel = tracks.filter(\.selected)
            guard sel.count == 1 else { throw LogicError.unavailable(sel.isEmpty ? "no track is selected" : "\(sel.count) tracks are selected") }
            return (sel[0], nil)
        case .handle(let h):
            guard let fp = table.fingerprint(h) else { throw LogicError.staleRef(h) }
            switch HandleTable.match(fp, in: trackFingerprints(tracks)) {
            case .exact(let i): return (tracks[i], nil)
            case .moved(let i): return (tracks[i], "moved \(fp.number.map(String.init) ?? "?")→\(tracks[i].number)")
            case .stale: throw LogicError.staleRef(h)
            }
        case .id(let s):
            throw LogicError.invalidArgs(signature: "track:<number>|\"<name>\"|selected|#handle", detail: "bad track selector \(s)")
        }
    }

    /// UI track numbers are global (spec §4.3): track:3/track:5 → track:5. Stack membership is checked from P2.
    public static func canonical(_ path: LPath) -> LPath {
        var segs = path.segments
        while segs.count >= 2, segs[0].kind == .track, segs[1].kind == .track { segs.removeFirst() }
        return LPath(segments: segs, property: path.property)
    }
}
```
  - [ ] **Step 4: PASS. Step 5: Commit** — `git add Sources/LogicKit/Map/Resolver.swift Tests/LogicKitTests/ResolverTests.swift && git commit -m "track resolver with handles and canonical paths"`

---

### Task 24: Рендер и бюджеты токенов

**Files:** Create `Sources/LogicKit/Render/TextRenderer.swift`; Test `Tests/LogicKitTests/RenderTests.swift`

**Interfaces:** Produces `struct RenderOptions: Equatable, Sendable { page: ClosedRange<Int>?; fields: [String]?; maxRows = 12; init(page:fields:); static func parsePage(_:) throws -> ClosedRange<Int> }`; `enum TextRenderer { trackLine(_:handle:), fields(_:_:), fieldNames, fold(_:priority:options:), root(project:transport:tracks:handles:options:warnings:), strip(_:), transport(_:), track(_:handle:strip:) }`.

  - [ ] **Step 1: Тесты**
```swift
import XCTest
@testable import LogicKit

final class RenderTests: XCTestCase {
    func fixtureRoot(_ name: String) throws -> String {
        let r = FixtureAXRoot(try AXFixture.load(Fixtures.url("ax/\(name).json")))
        let tracks = try TrackReader.read(r, .en)
        return TextRenderer.root(project: try ProjectReader.read(r, version: "11.2"), transport: try? TransportReader.read(r, .en),
                                 tracks: tracks, handles: Resolver.handles(for: tracks, table: HandleTable()), options: RenderOptions())
    }

    func testTrackLine() {
        let t = TrackInfo(number: 4, name: "PreDelay", mute: true, selected: true, hasOutput: false, volume: "-4.2 dB")
        XCTAssertEqual(TextRenderer.trackLine(t, handle: "#t1a2b"), "track:4 #t1a2b \"PreDelay\" M vol=-4.2dB [selected] ⚠ no output")
    }

    func testFoldingKeepsPriorityRowsAndOffersPaging() {
        let tracks = (1...40).map { TrackInfo(number: $0, name: "T\($0)", selected: $0 == 33) }
        let text = TextRenderer.root(project: ProjectInfo(name: "big", logicVersion: nil), transport: nil, tracks: tracks,
                                     handles: tracks.map { "#t\($0.number)" }, options: RenderOptions())
        XCTAssertTrue(text.contains("tracks:40 (showing 12; page:\"13-24\" or fields:\"name,mute\")"))
        XCTAssertTrue(text.contains("track:33"))
        XCTAssertEqual(text.components(separatedBy: "\n").filter { $0.hasPrefix(" track:") }.count, 12)
        let page = TextRenderer.root(project: ProjectInfo(name: "big", logicVersion: nil), transport: nil, tracks: tracks,
                                     handles: tracks.map { "#t\($0.number)" }, options: RenderOptions(page: 13...24))
        XCTAssertTrue(page.contains(" track:13 ") && page.contains(" track:24 ") && !page.contains(" track:25 "))
        let f = TextRenderer.root(project: ProjectInfo(name: "big", logicVersion: nil), transport: nil, tracks: tracks,
                                  handles: tracks.map { "#t\($0.number)" }, options: RenderOptions(fields: ["name", "mute"]))
        XCTAssertTrue(f.contains(" track:40 \"T40\" mute=?"))
    }

    func testBudgets() throws {
        XCTAssertLessThanOrEqual(TokenEstimate.count(try fixtureRoot("belo-krasny")), 350)
        XCTAssertLessThanOrEqual(TokenEstimate.count(try fixtureRoot("big")), 350)
        let r = FixtureAXRoot(try AXFixture.load(Fixtures.url("ax/belo-krasny.json")))
        let tracks = try TrackReader.read(r, .en)
        let sel = try XCTUnwrap(tracks.first(where: \.selected))
        let text = TextRenderer.track(sel, handle: "#t1a2b", strip: try StripReader.inspector(r, .en))
        XCTAssertLessThanOrEqual(TokenEstimate.count(text), 200)
    }
}
```
  - [ ] **Step 2: FAIL. Step 3: Реализация**
```swift
import Foundation

public struct RenderOptions: Equatable, Sendable {
    public var page: ClosedRange<Int>?
    public var fields: [String]?
    public var maxRows = 12
    public init(page: ClosedRange<Int>? = nil, fields: [String]? = nil) { self.page = page; self.fields = fields }

    public static func parsePage(_ s: String) throws -> ClosedRange<Int> {
        let p = s.split(separator: "-").compactMap { Int($0) }
        guard p.count == 2, p[0] >= 1, p[0] <= p[1] else {
            throw LogicError.invalidArgs(signature: "page: \"FROM-TO\", e.g. \"13-24\"", detail: "bad page \(s)")
        }
        return p[0]...p[1]
    }
}

public enum TextRenderer {
    public static let fieldNames = ["name", "kind", "mute", "solo", "arm", "selected", "volume", "pan", "takes"]

    static func compact(_ s: String) -> String { s.replacingOccurrences(of: " ", with: "") }
    static func onOff(_ b: Bool?) -> String { b.map { $0 ? "on" : "off" } ?? "?" }

    public static func trackLine(_ t: TrackInfo, handle: String) -> String {
        var s = "track:\(t.number) \(handle) \"\(t.name)\""
        if t.kind != .unknown { s += " \(t.kind.rawValue)" }
        let toggles = [t.mute == true ? "M" : "", t.solo == true ? "S" : "", t.arm == true ? "R" : ""].joined()
        if !toggles.isEmpty { s += " \(toggles)" }
        if let v = t.volume { s += " vol=\(compact(v))" }
        if let p = t.pan, !["0", "C", "0.0"].contains(p) { s += " pan=\(compact(p))" }
        if t.takeLanes > 0 { s += " takes:\(t.takeLanes)" }
        if t.selected { s += " [selected]" }
        if !t.hasOutput { s += " ⚠ no output" }
        return s
    }

    public static func fields(_ t: TrackInfo, _ f: [String]) -> String {
        var parts = ["track:\(t.number)"]
        for name in f {
            switch name {
            case "name": parts.append("\"\(t.name)\"")
            case "kind": parts.append("kind=\(t.kind.rawValue)")
            case "mute": parts.append("mute=\(onOff(t.mute))")
            case "solo": parts.append("solo=\(onOff(t.solo))")
            case "arm": parts.append("arm=\(onOff(t.arm))")
            case "selected": parts.append("selected=\(onOff(t.selected))")
            case "volume": parts.append("vol=\(t.volume.map(compact) ?? "?")")
            case "pan": parts.append("pan=\(t.pan.map(compact) ?? "?")")
            case "takes": parts.append("takes=\(t.takeLanes)")
            default: break
            }
        }
        return parts.joined(separator: " ")
    }

    /// Spec §4.6: at most maxRows; priority rows first, then in order. Returns rows in original order.
    public static func fold<T>(_ items: [T], priority: (T) -> Bool, options: RenderOptions) -> (shown: [T], hidden: Int) {
        if let page = options.page {
            let lo = page.lowerBound - 1, hi = min(page.upperBound, items.count)
            return lo < hi ? (Array(items[lo..<hi]), items.count - (hi - lo)) : ([], items.count)
        }
        guard items.count > options.maxRows else { return (items, 0) }
        var chosen = Array(items.indices.filter { priority(items[$0]) }.prefix(options.maxRows))
        for i in items.indices where chosen.count < options.maxRows && !chosen.contains(i) { chosen.append(i) }
        return (chosen.sorted().map { items[$0] }, items.count - chosen.count)
    }

    public static func transport(_ t: TransportInfo?) -> String {
        guard let t, let state = t.state else { return "transport ?unavailable" }
        return "transport \(state.rawValue) pos=\(t.position ?? "?")" + (t.cycle == true ? " cycle" : "")
    }

    public static func root(project: ProjectInfo, transport t: TransportInfo?, tracks: [TrackInfo], handles: [String],
                            options: RenderOptions, warnings: [String] = []) -> String {
        var lines = ["/ \"\(project.name)\"" + (project.logicVersion.map { " logic=\($0)" } ?? ""), transport(t)]
        lines += warnings.map { "⚠ \($0)" }
        let pairs = Array(zip(tracks, handles))
        if let f = options.fields {
            lines.append("tracks:\(tracks.count)")
            lines += pairs.map { " " + fields($0.0, f) }
            return lines.joined(separator: "\n")
        }
        let (shown, hidden) = fold(pairs, priority: { $0.0.selected || $0.0.arm == true || $0.0.solo == true || !$0.0.hasOutput }, options: options)
        if hidden > 0 {
            let start = (options.page?.upperBound ?? options.maxRows) + 1
            let end = min(start + options.maxRows - 1, tracks.count)
            let hint = start <= tracks.count ? "page:\"\(start)-\(end)\" or " : ""
            lines.append("tracks:\(tracks.count) (showing \(shown.count); \(hint)fields:\"name,mute\")")
        } else {
            lines.append("tracks:\(tracks.count)")
        }
        lines += shown.map { " " + trackLine($0.0, handle: $0.1) }
        return lines.joined(separator: "\n")
    }

    public static func strip(_ s: StripInfo) -> String {
        var head = " strip"
        if let v = s.volume { head += " vol=\(compact(v))" }
        if let p = s.pan { head += " pan=\(compact(p))" }
        if let pk = s.peak { head += " peak=\(compact(pk))" }
        let inserts = s.inserts.isEmpty ? " insert: none"
            : " insert:" + s.inserts.map { "\($0.slot) \($0.name)" + ($0.bypassed == true ? "(bypass)" : "") }.joined(separator: " · ")
        return head + "\n" + inserts
    }

    /// `strip` is nil when the track is not selected (spec §4.2).
    public static func track(_ t: TrackInfo, handle: String, strip s: StripInfo?) -> String {
        let body = t.selected && s != nil ? strip(s!) : " strip ?unavailable(need_select: logic_do track:\(t.number) select)"
        return trackLine(t, handle: handle) + "\n" + body
    }
}
```
  - [ ] **Step 4: PASS** (при превышении бюджета меняется формат, а не бюджет; спек §7). **Step 5: Commit** — `git add Sources/LogicKit/Render Tests/LogicKitTests/RenderTests.swift && git commit -m "compact text renderer with folding and budgets"`

---

### Task 25: Примитивы, verify, контракт stepTo

**Files:** Create `Sources/LogicKit/Engine/Primitives.swift`; Test `Tests/LogicKitTests/PrimitivesTests.swift`

**Interfaces:** Produces `struct Clock: Sendable { now: @Sendable () -> Double; sleep: @Sendable (Double) -> Void; static let system }`; `enum Verify { static func poll<T>(deadline:interval:clock:read:done:) throws -> (value: T, ok: Bool) }`; `enum Primitives { press(_:), setText(_:_:), menu(_ bar:_ path:), stepTo(_:target:parse:clock:perStepDeadline:maxSteps:) -> StepResult }`; `struct StepResult: Equatable { start, actual: Double; actualText: String; lastStep: Double?; steps: Int }`; `enum StepContract { static func judge(want:wantText:result:format:) throws -> Quantization? }`.

  - [ ] **Step 1: Тесты** (`ScriptedSlider` — тестовый дублёр алгоритма, а не эмуляция Logic)
```swift
import XCTest
@testable import LogicKit

final class ScriptedSlider: AXNode, @unchecked Sendable {
    var ladder: [Double], index: Int, inverted = false
    init(_ ladder: [Double], at index: Int) { self.ladder = ladder; self.index = index }
    func attrs() throws -> AXAttrs { AXAttrs(role: "AXSlider", valueDescription: "\(ValueParser.trim(ladder[index])) dB") }
    func children() throws -> [any AXNode] { [] }
    func perform(_ a: String) throws {
        var up = a == "AXIncrement"
        if inverted { up.toggle() }
        index = up ? min(index + 1, ladder.count - 1) : max(index - 1, 0)
    }
    func set(_ attribute: String, _ value: AXScalar) throws { throw AXCallError.notSupported("set") }
    var identityToken: Int { 1 }
}

final class FakeTime: @unchecked Sendable { var t = 0.0 }

final class PrimitivesTests: XCTestCase {
    let ft = FakeTime()
    lazy var clock = Clock(now: { [ft] in ft.t }, sleep: { [ft] in ft.t += $0 })
    let dB: (String) -> Double? = { ValueParser.parseDisplay($0, unit: .dB).flatMap(ValueParser.magnitude) }
    let fmt: (Double) -> String = { "\(ValueParser.trim($0)) dB" }
    let ladder = [-30.0, -25, -20, -15, -10]

    func testReachesExactTarget() throws {
        let s = ScriptedSlider(ladder, at: 2)
        let r = try Primitives.stepTo(s, target: -10, parse: dB, clock: clock)
        XCTAssertEqual(r.actual, -10); XCTAssertEqual(r.steps, 2)
        XCTAssertNil(try StepContract.judge(want: -10, wantText: "-10 dB", result: r, format: fmt))
    }

    func testQuantizesToNearestWithBackStep() throws {
        let s = ScriptedSlider(ladder, at: 4)
        let r = try Primitives.stepTo(s, target: -22, parse: dB, clock: clock)
        XCTAssertEqual(r.actual, -20)
        XCTAssertEqual(try StepContract.judge(want: -22, wantText: "-22 dB", result: r, format: fmt),
                       Quantization(want: "-22 dB", step: "5 dB"))
    }

    func testStuckAtLimitFarFromTargetFails() throws {
        let s = ScriptedSlider(ladder, at: 2)
        let r = try Primitives.stepTo(s, target: -40, parse: dB, clock: clock)
        XCTAssertEqual(r.actual, -30)
        XCTAssertThrowsError(try StepContract.judge(want: -40, wantText: "-40 dB", result: r, format: fmt)) {
            XCTAssertEqual($0 as? LogicError, .verifyFailed(want: "-40 dB", got: "-30 dB"))
        }
    }

    func testWrongDirectionFails() {
        let s = ScriptedSlider(ladder, at: 2); s.inverted = true
        XCTAssertThrowsError(try Primitives.stepTo(s, target: -10, parse: dB, clock: clock))
    }

    func testPollTimesOutWithLastValue() throws {
        let r = try Verify.poll(deadline: clock.now() + 0.1, clock: clock, read: { 1 }, done: { $0 == 2 })
        XCTAssertFalse(r.ok); XCTAssertEqual(r.value, 1)
    }
}
```
  - [ ] **Step 2: FAIL. Step 3: Реализация**
```swift
import Foundation

public struct Clock: Sendable {
    public var now: @Sendable () -> Double
    public var sleep: @Sendable (Double) -> Void
    public init(now: @escaping @Sendable () -> Double, sleep: @escaping @Sendable (Double) -> Void) { self.now = now; self.sleep = sleep }
    public static let system = Clock(now: { ProcessInfo.processInfo.systemUptime }, sleep: { Thread.sleep(forTimeInterval: $0) })
}

public enum Verify {
    /// Spec §5.1: re-read every 30 ms until `done` or the deadline. Never throws on timeout; returns the last value.
    public static func poll<T>(deadline: Double, interval: Double = 0.03, clock: Clock,
                               read: () throws -> T, done: (T) -> Bool) throws -> (value: T, ok: Bool) {
        var v = try read()
        while !done(v) {
            guard clock.now() < deadline else { return (v, false) }
            clock.sleep(interval)
            v = try read()
        }
        return (v, true)
    }
}

public struct StepResult: Equatable, Sendable {
    public var start: Double
    public var actual: Double
    public var actualText: String
    public var lastStep: Double?
    public var steps: Int
}

public enum Primitives {
    public static func press(_ n: any AXNode) throws { try n.perform("AXPress") }

    /// Text only through AXValue (spec §1: independent of keyboard layout).
    public static func setText(_ n: any AXNode, _ text: String) throws {
        try n.set("AXValue", .string(text))
        if try n.attrs().actions.contains("AXConfirm") { try n.perform("AXConfirm") }
    }

    public static func menu(_ bar: any AXNode, _ path: [String]) throws {
        guard let item = try MenuPath.resolve(menuBar: bar, path: path) else { throw LogicError.anchorMissing("menu " + path.joined(separator: ">")) }
        guard try item.attrs().enabled != false else { throw LogicError.unavailable("menu \(path.joined(separator: ">")) is disabled") }
        try item.perform("AXPress")
    }

    /// Spec §5.2: AXIncrement/AXDecrement reading AXValueDescription; stops at the reachable value nearest the target.
    public static func stepTo(_ n: any AXNode, target: Double, parse: (String) -> Double?, clock: Clock,
                              perStepDeadline: Double = 0.5, maxSteps: Int = 400) throws -> StepResult {
        func read() throws -> (Double, String) {
            guard let t = try n.attrs().valueDescription, let v = parse(t) else { throw LogicError.unavailable("control value is unreadable") }
            return (v, t)
        }
        var (cur, curText) = try read()
        let start = cur
        if cur == target { return StepResult(start: start, actual: cur, actualText: curText, lastStep: nil, steps: 0) }
        let up = target > cur
        var lastStep: Double?
        var steps = 0
        while steps < maxSteps {
            try n.perform(up ? "AXIncrement" : "AXDecrement")
            steps += 1
            let before = cur
            let r = try Verify.poll(deadline: clock.now() + perStepDeadline, clock: clock, read: read, done: { $0.0 != before })
            guard r.ok else { break }   // did not move: at the control's limit
            let (nv, nt) = r.value
            if (nv > cur) != up { throw LogicError.verifyFailed(want: "move \(up ? "up" : "down")", got: nt) }
            lastStep = abs(nv - cur)
            if up ? nv >= target : nv <= target {
                if abs(cur - target) < abs(nv - target) {
                    try n.perform(up ? "AXDecrement" : "AXIncrement")
                    steps += 1
                    let back = try Verify.poll(deadline: clock.now() + perStepDeadline, clock: clock, read: read, done: { $0.0 != nv })
                    return StepResult(start: start, actual: back.value.0, actualText: back.value.1, lastStep: lastStep, steps: steps)
                }
                return StepResult(start: start, actual: nv, actualText: nt, lastStep: lastStep, steps: steps)
            }
            cur = nv; curText = nt
        }
        return StepResult(start: start, actual: cur, actualText: curText, lastStep: lastStep, steps: steps)
    }
}

public enum StepContract {
    /// ok if the control moved and ended within one step of the target; quantized when not exact.
    public static func judge(want: Double, wantText: String, result: StepResult, format: (Double) -> String) throws -> Quantization? {
        if result.actual == want { return nil }
        guard let step = result.lastStep, abs(want - result.actual) <= step + 1e-9 else {
            throw LogicError.verifyFailed(want: wantText, got: result.actualText)
        }
        return Quantization(want: wantText, step: format(step))
    }
}
```
  - [ ] **Step 4: PASS. Step 5: Commit** — `git add Sources/LogicKit/Engine/Primitives.swift Tests/LogicKitTests/PrimitivesTests.swift && git commit -m "primitives, verify polling, stepTo contract"`

---

### Task 26: Рецепты и раннер

**Files:** Create `Sources/LogicKit/Engine/Recipe.swift`; Test `Tests/LogicKitTests/RecipeRunnerTests.swift`

**Interfaces:** Produces `enum Visibility`; `struct RecipeSpec { name, visibility, idempotent, reversible, deadline, allowWhilePlaying, allowWhileRecording, changesSelection }` + init с дефолтами; `struct RecipeEnv { root: any AXRoot; locale; clock; logicPID: pid_t? }`; `protocol Recipe: Sendable { var spec: RecipeSpec { get }; func run(_ ctx: RecipeContext) throws -> Outcome }`; `protocol TrackSelecting: Sendable { func select(_ number: Int, ctx: RecipeContext) throws }`; `final class RecipeContext { env; notes; expectedSelection: Int?; note(_:); checkpoint() throws }`; `enum RecipeRunner { static func run(_:env:restorer:) throws -> Outcome; static func map(_ e: Error) -> Error }`.

  - [ ] **Step 1: Тесты**
```swift
import XCTest
@testable import LogicKit

struct FakeRecipe: Recipe {
    var spec: RecipeSpec
    var body: @Sendable (RecipeContext) throws -> Outcome
    func run(_ ctx: RecipeContext) throws -> Outcome { try body(ctx) }
}

final class FakeRestorer: TrackSelecting, @unchecked Sendable {
    var calls: [Int] = []
    func select(_ number: Int, ctx: RecipeContext) throws { calls.append(number) }
}

final class RecipeRunnerTests: XCTestCase {
    func env(_ edit: (inout AXFixture) -> Void = { _ in }) throws -> RecipeEnv {
        var fx = try AXFixture.load(Fixtures.url("ax/mini.json"))
        edit(&fx)
        return RecipeEnv(root: FixtureAXRoot(fx), locale: .en)
    }
    let okBody: @Sendable (RecipeContext) throws -> Outcome = { _ in .ok(path: "x", actual: "y") }

    func testSuccess() throws {
        XCTAssertEqual(try RecipeRunner.run(FakeRecipe(spec: RecipeSpec(name: "t"), body: okBody), env: env()), .ok(path: "x", actual: "y"))
    }

    func testModalBlocks() throws {
        let e = try env { $0.roots["mainWindow"]!.a.subrole = "AXDialog"; $0.roots["mainWindow"]!.a.title = "Save Patch as…" }
        XCTAssertThrowsError(try RecipeRunner.run(FakeRecipe(spec: RecipeSpec(name: "t"), body: okBody), env: e)) {
            XCTAssertEqual($0 as? LogicError, .blocked(.modal("Save Patch as…")))
        }
    }

    func testRecordingBlocksUnlessAllowed() throws {
        let e = try env { $0.roots["mainWindow"]!.c[1].c[1].a.value = .number(1) }   // Control Bar › Record = 1
        XCTAssertThrowsError(try RecipeRunner.run(FakeRecipe(spec: RecipeSpec(name: "t"), body: okBody), env: e)) {
            XCTAssertEqual($0 as? LogicError, .blocked(.recording))
        }
        XCTAssertNoThrow(try RecipeRunner.run(FakeRecipe(spec: RecipeSpec(name: "stop", allowWhileRecording: true), body: okBody), env: e))
    }

    func testCheckpointDetectsSelectionChange() throws {
        let r = FakeRecipe(spec: RecipeSpec(name: "t")) { ctx in ctx.expectedSelection = 3; try ctx.checkpoint(); return .ok(path: "x", actual: "y") }
        XCTAssertThrowsError(try RecipeRunner.run(r, env: env())) {
            XCTAssertEqual($0 as? LogicError, .blocked(.contextChanged("selection 3→2")))
        }
    }

    func testVanishedElementMapsToContextChanged() throws {
        let r = FakeRecipe(spec: RecipeSpec(name: "t")) { _ in throw AXCallError.invalidElement }
        XCTAssertThrowsError(try RecipeRunner.run(r, env: env())) {
            XCTAssertEqual($0 as? LogicError, .blocked(.contextChanged("UI element vanished during the operation")))
        }
    }

    func testSelectionRestoredOnSuccessAndFailure() throws {
        let restorer = FakeRestorer()
        let spec = RecipeSpec(name: "t", visibility: .restores, changesSelection: true)
        _ = try RecipeRunner.run(FakeRecipe(spec: spec, body: okBody), env: env(), restorer: restorer)
        _ = try? RecipeRunner.run(FakeRecipe(spec: spec) { _ in throw LogicError.unavailable("x") }, env: env(), restorer: restorer)
        XCTAssertEqual(restorer.calls, [2, 2])
    }
}
```
  - [ ] **Step 2: FAIL. Step 3: Реализация**
```swift
import Foundation

public enum Visibility: String, Sendable, Codable { case never, transient, restores }

public struct RecipeSpec: Sendable {
    public var name: String
    public var visibility: Visibility
    public var idempotent: Bool
    public var reversible: Bool
    public var deadline: Double
    public var allowWhilePlaying: Bool
    public var allowWhileRecording: Bool
    public var changesSelection: Bool

    public init(name: String, visibility: Visibility = .never, idempotent: Bool = true, reversible: Bool = true,
                deadline: Double = 1.0, allowWhilePlaying: Bool = true, allowWhileRecording: Bool = false,
                changesSelection: Bool = false) {
        self.name = name; self.visibility = visibility; self.idempotent = idempotent; self.reversible = reversible
        self.deadline = deadline; self.allowWhilePlaying = allowWhilePlaying
        self.allowWhileRecording = allowWhileRecording; self.changesSelection = changesSelection
    }
}

public struct RecipeEnv: Sendable {
    public var root: any AXRoot
    public var locale: LocaleTable
    public var clock: Clock
    public var logicPID: pid_t?
    public init(root: any AXRoot, locale: LocaleTable, clock: Clock = .system, logicPID: pid_t? = nil) {
        self.root = root; self.locale = locale; self.clock = clock; self.logicPID = logicPID
    }
}

public protocol Recipe: Sendable {
    var spec: RecipeSpec { get }
    /// Runs on the AX thread inside one transaction and verifies its own postcondition.
    func run(_ ctx: RecipeContext) throws -> Outcome
}

public protocol TrackSelecting: Sendable {
    func select(_ number: Int, ctx: RecipeContext) throws
}

public final class RecipeContext {
    public let env: RecipeEnv
    public private(set) var notes: [String] = []
    public var expectedSelection: Int?

    init(env: RecipeEnv) { self.env = env }

    public func note(_ s: String) { notes.append(s) }

    /// Spec §5.4: context readback before every mutating step.
    public func checkpoint() throws {
        if let title = try ModalGuard.modalTitle(env.root, env.locale) { throw LogicError.blocked(.modal(title)) }
        if let want = expectedSelection {
            let now = try TrackReader.selectedNumber(env.root, env.locale)
            if now != want { throw LogicError.blocked(.contextChanged("selection \(want)→\(now.map(String.init) ?? "none")")) }
        }
    }
}

public enum RecipeRunner {
    public static func run(_ recipe: any Recipe, env: RecipeEnv, restorer: (any TrackSelecting)? = nil) throws -> Outcome {
        let spec = recipe.spec
        let ctx = RecipeContext(env: env)
        if let title = try ModalGuard.modalTitle(env.root, env.locale) { throw LogicError.blocked(.modal(title)) }
        if !spec.allowWhilePlaying || !spec.allowWhileRecording {
            let state = (try? TransportReader.read(env.root, env.locale))?.state
            if state == .recording && !spec.allowWhileRecording { throw LogicError.blocked(.recording) }
            if state == .playing && !spec.allowWhilePlaying { throw LogicError.blocked(.playing) }
        }
        let before = try env.logicPID.map { try WindowSnapshot.capture(logicPID: $0, root: env.root) }
        let original = spec.changesSelection ? try TrackReader.selectedNumber(env.root, env.locale) : nil

        let result: Result<Outcome, Error>
        do { result = .success(try recipe.run(ctx)) } catch { result = .failure(error) }

        // Teardown is identical on success and on error (spec §5.4).
        if spec.changesSelection, let original, let restorer {
            ctx.expectedSelection = nil
            do { try restorer.select(original, ctx: ctx) } catch {
                let now = (try? TrackReader.selectedNumber(env.root, env.locale)) ?? nil
                ctx.note("⚠ selection left on \(now.map(String.init) ?? "none") (was \(original))")
                Log.warn("selection restore failed: \(error)", subsystem: "recipe")
            }
        }
        if let before, let pid = env.logicPID, let after = try? WindowSnapshot.capture(logicPID: pid, root: env.root) {
            let diff = before.diff(to: after)
            if spec.visibility == .never && !diff.isClean { ctx.note("⚠ window side effect: \(diff.summary)") }
        }
        switch result {
        case .success(let outcome): return outcome.appending(notes: ctx.notes)
        case .failure(let error): throw map(error)
        }
    }

    public static func map(_ e: Error) -> Error {
        switch e {
        case let e as LogicError: return e
        case AXCallError.timeout: return AXCallError.timeout   // AXExecutor turns this into busy
        case AXCallError.invalidElement: return LogicError.blocked(.contextChanged("UI element vanished during the operation"))
        case AXCallError.readOnlyFixture: return LogicError.unsupported("fixture is read-only")
        case let e as AXCallError: return LogicError.unavailable("AX error: \(e)")
        default: return e
        }
    }
}
```
Если `AXSnapshotNode.c`/`a` не мутируемы через `var` в тесте — они объявлены `var` в Task 2, и доступ по индексу `c[1].c[1]` (Control Bar › Record в `mini.json`) работает.
  - [ ] **Step 4: PASS. Step 5: Commit** — `git add Sources/LogicKit/Engine/Recipe.swift Tests/LogicKitTests/RecipeRunnerTests.swift && git commit -m "recipe runner with guards, checkpoints, identical teardown"`

---

### Task 27: Грамматика и ledger

**Files:** Create `Sources/LogicKit/Map/Grammar.swift`, `Sources/LogicKit/Resources/ledger.json`; Modify `Package.swift` (ресурс); Test `Tests/LogicKitTests/GrammarTests.swift`

**Interfaces:** Produces `enum CapabilityStatus: String, Codable { planned, recipe }`; `struct Capability: Hashable, Sendable { enum Form { read, property(ValueUnit), action(signature: String) }; kind; name; form; status; liveTest: String?; key: String }`; `enum Grammar { static let all; find(_:_:); advertised(ledger:logicMinor:); index(_:) -> String; schema(_ kind: NodeKind, caps:) -> String }`; `struct LedgerEntry: Codable, Equatable { capability, logicVersion, date, test, result }`; `struct Ledger: Codable { entries; static func bundled(); load(_:); write(to:); passed(_:minor:) -> Bool; latestMinor; mutating record(_:version:date:) }`.

  - [ ] **Step 1: Ресурс** — в таргете `LogicKit` в `Package.swift` добавить `resources: [.copy("Resources/ledger.json")]`. Файл `Sources/LogicKit/Resources/ledger.json`: `{"entries":[]}`.

  - [ ] **Step 2: Тесты**
```swift
import XCTest
@testable import LogicKit

final class GrammarTests: XCTestCase {
    func testAdvertisedNeedsLedgerRowForMinor() throws {
        let mute = try XCTUnwrap(Grammar.find(.track, "mute"))
        var l = Ledger(entries: [])
        XCTAssertTrue(Grammar.advertised(ledger: l, logicMinor: "11.2").isEmpty)
        l.record(mute, version: "11.2.1", date: "2026-09-21")
        XCTAssertEqual(Grammar.advertised(ledger: l, logicMinor: "11.2").map(\.key), ["track.mute"])
        XCTAssertTrue(Grammar.advertised(ledger: l, logicMinor: "11.3").isEmpty)
        XCTAssertEqual(Grammar.advertised(ledger: l, logicMinor: nil).map(\.key), ["track.mute"]) // Logic not running → newest minor
        l.record(mute, version: "11.2.2", date: "2026-09-22")
        XCTAssertEqual(l.entries.count, 1)
    }

    func testBundledLedgerReferencesKnownCapabilities() {
        for e in Ledger.bundled().entries { XCTAssertNotNil(Grammar.all.first { $0.key == e.capability }, e.capability) }
    }

    func testIndexIsCompact() {
        let idx = Grammar.index(Grammar.all)
        XCTAssertTrue(idx.contains("track: read, mute=on|off"))
        XCTAssertLessThanOrEqual(TokenEstimate.count(idx), 150)
        XCTAssertTrue(Grammar.schema(.track, caps: Grammar.all).contains("logic_set track:N/mute"))
    }
}
```
  - [ ] **Step 3: FAIL. Step 4: Реализация**
```swift
import Foundation

public enum CapabilityStatus: String, Codable, Sendable { case planned, recipe }

public struct Capability: Hashable, Sendable {
    public enum Form: Hashable, Sendable { case read, property(ValueUnit), action(signature: String) }
    public var kind: NodeKind
    public var name: String
    public var form: Form
    public var status: CapabilityStatus
    public var liveTest: String?
    public var key: String { "\(kind == .root ? "root" : kind.rawValue).\(name)" }
}

public enum Grammar {
    /// P1 slice (spec §11). Entries whose spike was red are set to `.planned` in Task 16/28.
    public static let all: [Capability] = [
        .init(kind: .root, name: "read", form: .read, status: .recipe, liveTest: "LiveReadTests/testReadRoot"),
        .init(kind: .track, name: "read", form: .read, status: .recipe, liveTest: "LiveReadTests/testReadTrack"),
        .init(kind: .strip, name: "read", form: .read, status: .recipe, liveTest: "LiveReadTests/testReadSelectedStrip"),
        .init(kind: .transport, name: "read", form: .read, status: .recipe, liveTest: "LiveReadTests/testReadTransport"),
        .init(kind: .track, name: "mute", form: .property(.onOff), status: .recipe, liveTest: "LiveTrackTests/testMuteRoundTrip"),
        .init(kind: .track, name: "solo", form: .property(.onOff), status: .recipe, liveTest: "LiveTrackTests/testSoloRoundTrip"),
        .init(kind: .track, name: "select", form: .action(signature: "select"), status: .recipe, liveTest: "LiveTrackTests/testSelectAndRestore"),
        .init(kind: .root, name: "undo", form: .action(signature: "undo {steps?: 1..10}"), status: .recipe, liveTest: "LiveUndoTests/testUndoRedoNewTrack"),
        .init(kind: .root, name: "redo", form: .action(signature: "redo {steps?: 1..10}"), status: .recipe, liveTest: "LiveUndoTests/testUndoRedoNewTrack"),
        .init(kind: .transport, name: "play", form: .action(signature: "play"), status: .recipe, liveTest: "LiveTransportTests/testPlayStop"),
        .init(kind: .transport, name: "stop", form: .action(signature: "stop"), status: .recipe, liveTest: "LiveTransportTests/testPlayStop"),
        .init(kind: .transport, name: "position", form: .property(.position), status: .recipe, liveTest: "LiveTransportTests/testLocate"),
    ]

    public static func find(_ kind: NodeKind, _ name: String) -> Capability? {
        all.first { $0.kind == kind && $0.name == name }
    }

    public static func advertised(ledger: Ledger, logicMinor: String?) -> [Capability] {
        guard let minor = logicMinor ?? ledger.latestMinor else { return [] }
        return all.filter { $0.status == .recipe && ledger.passed($0, minor: minor) }
    }

    /// One line per kind for the logic_read description (spec §4.8).
    public static func index(_ caps: [Capability]) -> String {
        var order: [NodeKind] = []
        var byKind: [NodeKind: [String]] = [:]
        for c in caps {
            if byKind[c.kind] == nil { order.append(c.kind) }
            let word: String
            switch c.form {
            case .read: word = "read"
            case .property(.onOff): word = "\(c.name)=on|off"
            case .property(let u): word = "\(c.name)=<\(u.rawValue)>"
            case .action: word = "\(c.name)()"
            }
            byKind[c.kind, default: []].append(word)
        }
        return order.map { "\($0.rawValue): " + byKind[$0]!.joined(separator: ", ") }.joined(separator: " · ")
    }

    public static func schema(_ kind: NodeKind, caps: [Capability]) -> String {
        let lines = caps.filter { $0.kind == kind }.map { c -> String in
            let node = kind == .root ? "/" : kind == .track ? "track:N" : kind.rawValue
            switch c.form {
            case .read: return "\(c.key): logic_read \(node)"
            case .property(let u): return "\(c.key): logic_set \(node)/\(c.name) = <\(u.rawValue)>"
            case .action(let sig): return "\(c.key): logic_do \(node) \(sig)"
            }
        }
        return lines.isEmpty ? "schema \(kind.rawValue): no live-verified capabilities" : lines.joined(separator: "\n")
    }
}

public struct LedgerEntry: Codable, Equatable, Sendable {
    public var capability: String
    public var logicVersion: String
    public var date: String
    public var test: String
    public var result: String
}

/// Spec §5.6: written only by LogicLiveTests; read at runtime to decide what is advertised.
public struct Ledger: Codable, Sendable {
    public var entries: [LedgerEntry]
    public init(entries: [LedgerEntry]) { self.entries = entries }

    public static func bundled() -> Ledger {
        guard let url = Bundle.module.url(forResource: "ledger", withExtension: "json") else { return Ledger(entries: []) }
        return (try? load(url)) ?? Ledger(entries: [])
    }

    public static func load(_ url: URL) throws -> Ledger { try JSONDecoder().decode(Ledger.self, from: Data(contentsOf: url)) }

    public func write(to url: URL) throws {
        let e = JSONEncoder()
        e.outputFormatting = [.prettyPrinted, .sortedKeys]
        try e.encode(self).write(to: url)
    }

    public var latestMinor: String? {
        entries.map { LogicApp.minor($0.logicVersion) }.max { a, b in
            a.split(separator: ".").compactMap { Int($0) }.lexicographicallyPrecedes(b.split(separator: ".").compactMap { Int($0) })
        }
    }

    public func passed(_ c: Capability, minor: String) -> Bool {
        entries.contains { $0.capability == c.key && LogicApp.minor($0.logicVersion) == minor && $0.result == "pass" }
    }

    public mutating func record(_ c: Capability, version: String, date: String) {
        entries.removeAll { $0.capability == c.key && LogicApp.minor($0.logicVersion) == LogicApp.minor(version) }
        entries.append(LedgerEntry(capability: c.key, logicVersion: version, date: date, test: c.liveTest ?? "", result: "pass"))
        entries.sort { ($0.capability, $0.logicVersion) < ($1.capability, $1.logicVersion) }
    }
}
```
  - [ ] **Step 5: PASS. Step 6: Commit** — `git add Package.swift Sources/LogicKit/Map/Grammar.swift Sources/LogicKit/Resources Tests/LogicKitTests/GrammarTests.swift && git commit -m "grammar with capability status and live ledger"`

---

### Task 28: Рецепты среза P1 и их live-тесты

**Files:**
  - Create: `Sources/LogicKit/Engine/Recipes/TrackToggle.swift`, `SelectTrack.swift`, `UndoRedo.swift`, `Transport.swift`, `Registry.swift`
  - Create: `Tests/LogicLiveTests/LiveLedger.swift`, `LiveTrackTests.swift`, `LiveUndoTests.swift`, `LiveTransportTests.swift`
  - Test: `Tests/LogicKitTests/CompletenessTests.swift`

**Interfaces:**
  - Consumes: всё из Tasks 17–27.
  - Produces: `TrackToggle(track:which:on:)`, `SelectTrack(track:)` (+ `TrackSelecting`), `UndoRedo(mode:steps:)`, `TransportCommand(command:)`, `Locate(position:)`; `enum RecipeRegistry { action(_:_:track:args:) throws -> any Recipe; property(_:_:track:value:) throws -> any Recipe; has(_:) -> Bool }`.

Решения из «Решений для P1»: стратегия select (S8) → `SelectTrack.strategy`; свежесть заголовка undo (S9) → `UndoRedo.titleFreshWithoutOpening`. Если S8 🔴 — `strategy = .unsupported` и `track.select` в `Grammar.all` получает `.planned`. Если S11 🔴 — `transport.play/stop/position` получают `.planned`.

  - [ ] **Step 1: Падающий тест полноты**
```swift
import XCTest
@testable import LogicKit

final class CompletenessTests: XCTestCase {
    /// Spec §5.6: every recipe capability has a recipe AND an existing live test.
    func testEveryRecipeCapabilityHasRecipeAndLiveTest() throws {
        let dir = Fixtures.root.deletingLastPathComponent().appendingPathComponent("LogicLiveTests")
        let sources = try FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil)
            .filter { $0.pathExtension == "swift" }.map { try String(contentsOf: $0, encoding: .utf8) }.joined()
        for c in Grammar.all where c.status == .recipe {
            let test = try XCTUnwrap(c.liveTest, c.key)
            let parts = test.split(separator: "/")
            XCTAssertTrue(sources.contains("class \(parts[0])"), test)
            XCTAssertTrue(sources.contains("func \(parts[1])("), test)
            XCTAssertTrue(RecipeRegistry.has(c), c.key)
        }
    }
}
```
  - [ ] **Step 2: FAIL. Step 3: Рецепты**

`TrackToggle.swift`:
```swift
/// Toggles are always a set (spec §5.3): read → press only if different → verify.
public struct TrackToggle: Recipe {
    public enum Which: String, Sendable { case mute, solo }
    public let track: Int, which: Which, on: Bool
    public init(track: Int, which: Which, on: Bool) { self.track = track; self.which = which; self.on = on }
    public var spec: RecipeSpec { RecipeSpec(name: "track.\(which.rawValue)") }

    public func run(_ ctx: RecipeContext) throws -> Outcome {
        let L = ctx.env.locale
        let path = "track:\(track)/\(which.rawValue)"
        let want = on ? "on" : "off"
        let row = try TrackReader.row(number: track, ctx.env.root, L)
        guard let box = try row.firstDescendant(AXMatch(role: "AXCheckBox", desc: .equals(L[which == .mute ? .mute : .solo])), maxDepth: 4) else {
            throw LogicError.unavailable("track:\(track) has no \(which.rawValue) button")
        }
        if boolValue(try box.attrs().value) == on { return .ok(path: path, actual: want) }
        try ctx.checkpoint()
        try Primitives.press(box)
        let r = try Verify.poll(deadline: ctx.env.clock.now() + spec.deadline, clock: ctx.env.clock,
                                read: { boolValue(try box.attrs().value) }, done: { $0 == on })
        guard r.ok else { throw LogicError.verifyFailed(want: want, got: r.value.map { $0 ? "on" : "off" } ?? "?") }
        return .ok(path: path, actual: want)
    }
}
```

`SelectTrack.swift`:
```swift
public enum SelectStrategy: String, Sendable { case setSelected, pressRow, pressName, pressRadio, unsupported }

public struct SelectTrack: Recipe, TrackSelecting {
    /// From spikes-2026-09.md «Решения для P1» (S8).
    public static let strategy: SelectStrategy = .setSelected
    /// S8: true if selecting a track record-arms it (Auto Track Enable) and the arm must be put back.
    public static let restoresArm = false

    public let track: Int
    public init(track: Int) { self.track = track }
    public var spec: RecipeSpec { RecipeSpec(name: "track.select", reversible: false) }

    public func run(_ ctx: RecipeContext) throws -> Outcome {
        try select(track, ctx: ctx)
        return .ok(path: "track:\(track)", actual: "selected")
    }

    public func select(_ number: Int, ctx: RecipeContext) throws {
        let L = ctx.env.locale, root = ctx.env.root
        if try TrackReader.selectedNumber(root, L) == number { return }
        let row = try TrackReader.row(number: number, root, L)
        let armBox = try row.firstDescendant(AXMatch(role: "AXCheckBox", desc: .equals(L[.recordEnable])), maxDepth: 4)
        let armBefore = try armBox.map { boolValue(try $0.attrs().value) } ?? nil
        switch Self.strategy {
        case .setSelected: try row.set("AXSelected", .bool(true))
        case .pressRow: try Primitives.press(row)
        case .pressName:
            guard let name = try row.firstDescendant(AXMatch(role: "AXStaticText"), maxDepth: 3)
                    ?? row.firstDescendant(AXMatch(role: "AXTextField"), maxDepth: 3) else { throw LogicError.anchorMissing("track name field") }
            try Primitives.press(name)
        case .pressRadio:
            guard let radio = try row.firstDescendant(AXMatch(role: "AXRadioButton"), maxDepth: 3) else { throw LogicError.anchorMissing("track focus radio") }
            try Primitives.press(radio)
        case .unsupported:
            throw LogicError.unsupported("invisible track select is unavailable; select track \(number) in Logic")
        }
        let r = try Verify.poll(deadline: ctx.env.clock.now() + 1.0, clock: ctx.env.clock,
                                read: { try TrackReader.selectedNumber(root, L) }, done: { $0 == number })
        guard r.ok else { throw LogicError.verifyFailed(want: "track:\(number) selected", got: r.value.map { "track:\($0) selected" } ?? "none selected") }
        if Self.restoresArm, let armBox, let armBefore, boolValue(try armBox.attrs().value) != armBefore {
            try Primitives.press(armBox)
        }
    }
}
```

`UndoRedo.swift`:
```swift
public struct UndoRedo: Recipe {
    public enum Mode: Sendable { case undo, redo }
    /// From S9: whether AX shows a fresh "Undo …" title without opening the Edit menu.
    public static let titleFreshWithoutOpening = true

    public let mode: Mode, steps: Int
    public init(mode: Mode, steps: Int) { self.mode = mode; self.steps = steps }
    public var spec: RecipeSpec {
        RecipeSpec(name: mode == .undo ? "undo" : "redo", visibility: Self.titleFreshWithoutOpening ? .never : .transient,
                   idempotent: false, deadline: 2.0, allowWhilePlaying: false)
    }

    public func run(_ ctx: RecipeContext) throws -> Outcome {
        let L = ctx.env.locale
        guard let bar = try ctx.env.root.menuBar() else { throw LogicError.unavailable("no menu bar") }
        let (mine, other) = mode == .undo ? (L[.menuUndoPrefix], L[.menuRedoPrefix]) : (L[.menuRedoPrefix], L[.menuUndoPrefix])
        func item(_ prefix: String) throws -> (any AXNode)? {
            if !Self.titleFreshWithoutOpening, let edit = try bar.firstChild(AXMatch(title: .equals(L[.menuEdit]))) {
                try edit.perform("AXPress")
                defer { try? edit.perform("AXCancel") }
                return try MenuPath.resolve(menuBar: bar, path: [L[.menuEdit], "^" + prefix])
            }
            return try MenuPath.resolve(menuBar: bar, path: [L[.menuEdit], "^" + prefix])
        }
        var done: [String] = []
        for _ in 0..<steps {
            guard let it = try item(mine) else { throw LogicError.anchorMissing("Edit>\(mine)") }
            let a = try it.attrs()
            guard a.enabled != false, let title = a.title else {
                if done.isEmpty { throw LogicError.unavailable("nothing to \(mine.lowercased())") }
                break
            }
            let action = String(title.dropFirst(mine.count)).trimmingCharacters(in: .whitespaces)
            try ctx.checkpoint()
            try Primitives.press(it)
            // Verify: the opposite item now names the same action ("Undo X" → "Redo X").
            let r = try Verify.poll(deadline: ctx.env.clock.now() + spec.deadline, clock: ctx.env.clock,
                                    read: { try item(other)?.attrs().title ?? "" },
                                    done: { $0.trimmingCharacters(in: .whitespaces) == "\(other) \(action)".trimmingCharacters(in: .whitespaces) })
            guard r.ok else { throw LogicError.verifyFailed(want: "\(other) \(action)", got: r.value) }
            done.append(action)
        }
        let top = (try? item(L[.menuUndoPrefix])?.attrs().title) ?? nil
        return .ok(path: "/", actual: "\(mine.lowercased()) " + done.map { "\"\($0)\"" }.joined(separator: ", "),
                   notes: ["undo_title: \(top ?? "?")"])
    }
}
```

`Transport.swift`:
```swift
public struct TransportCommand: Recipe {
    public enum Command: String, Sendable { case play, stop }
    public let command: Command
    public init(command: Command) { self.command = command }
    public var spec: RecipeSpec {
        RecipeSpec(name: "transport.\(command.rawValue)", reversible: false, deadline: 1.5, allowWhileRecording: command == .stop)
    }

    public func run(_ ctx: RecipeContext) throws -> Outcome {
        let L = ctx.env.locale, root = ctx.env.root
        let want: TransportState = command == .play ? .playing : .stopped
        if try TransportReader.read(root, L).state == want { return .ok(path: "transport", actual: want.rawValue) }
        guard let button = try TransportReader.controlBar(root, L)
                .firstDescendant(AXMatch(desc: .equals(L[command == .play ? .play : .stop])), maxDepth: 5) else {
            throw LogicError.anchorMissing(command.rawValue)
        }
        try ctx.checkpoint()
        try Primitives.press(button)
        let r = try Verify.poll(deadline: ctx.env.clock.now() + spec.deadline, clock: ctx.env.clock,
                                read: { try TransportReader.read(root, L).state }, done: { $0 == want })
        guard r.ok else { throw LogicError.verifyFailed(want: want.rawValue, got: r.value?.rawValue ?? "?") }
        return .ok(path: "transport", actual: want.rawValue)
    }
}

public struct Locate: Recipe {
    public let position: BarPosition
    public init(position: BarPosition) { self.position = position }
    public var spec: RecipeSpec { RecipeSpec(name: "transport.position", reversible: false, allowWhilePlaying: false) }

    public func run(_ ctx: RecipeContext) throws -> Outcome {
        let L = ctx.env.locale, root = ctx.env.root
        guard let field = try TransportReader.controlBar(root, L).firstDescendant(AXMatch(desc: .equals(L[.positionField])), maxDepth: 6) else {
            throw LogicError.anchorMissing("positionField")
        }
        try ctx.checkpoint()
        try Primitives.setText(field, position.description)
        let r = try Verify.poll(deadline: ctx.env.clock.now() + spec.deadline, clock: ctx.env.clock,
                                read: { try TransportReader.read(root, L).position ?? "" },
                                done: { BarPosition.parse($0) == position })
        guard r.ok else { throw LogicError.verifyFailed(want: position.description, got: r.value) }
        return .ok(path: "transport/position", actual: position.description)
    }
}
```
(`BarPosition` — `Equatable` через `Comparable`.)

`Registry.swift`:
```swift
public enum RecipeRegistry {
    static func need(_ track: Int?) throws -> Int {
        guard let track else { throw LogicError.invalidArgs(signature: "track:N", detail: "this action needs a track") }
        return track
    }

    public static func action(_ kind: NodeKind, _ name: String, track: Int?, args: [String: String]) throws -> any Recipe {
        switch (kind, name) {
        case (.track, "select"): return SelectTrack(track: try need(track))
        case (.root, "undo"), (.root, "redo"):
            guard let steps = Int(args["steps"] ?? "1"), (1...10).contains(steps) else {
                throw LogicError.invalidArgs(signature: "\(name) {steps?: 1..10}", detail: "bad steps \(args["steps"] ?? "")")
            }
            return UndoRedo(mode: name == "undo" ? .undo : .redo, steps: steps)
        case (.transport, "play"): return TransportCommand(command: .play)
        case (.transport, "stop"): return TransportCommand(command: .stop)
        default: throw LogicError.unsupported("\(kind.rawValue) has no action \(name)")
        }
    }

    public static func property(_ kind: NodeKind, _ name: String, track: Int?, value: LogicValue) throws -> any Recipe {
        switch (kind, name, value) {
        case (.track, "mute", .bool(let b)): return TrackToggle(track: try need(track), which: .mute, on: b)
        case (.track, "solo", .bool(let b)): return TrackToggle(track: try need(track), which: .solo, on: b)
        case (.transport, "position", .position(let p)): return Locate(position: p)
        default: throw LogicError.unsupported("\(kind.rawValue)/\(name) cannot be set")
        }
    }

    public static func has(_ c: Capability) -> Bool {
        switch c.form {
        case .read: return true
        case .action: return (try? action(c.kind, c.name, track: 1, args: [:])) != nil
        case .property(let unit):
            let sample: LogicValue = unit == .onOff ? .bool(true) : unit == .position ? .position(BarPosition(bar: 1)) : .number(0)
            return (try? property(c.kind, c.name, track: 1, value: sample)) != nil
        }
    }
}
```

  - [ ] **Step 4: Live-тесты**

`Tests/LogicLiveTests/LiveLedger.swift`:
```swift
import XCTest
import LogicKit

enum LiveLedger {
    static let url = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        .appendingPathComponent("Sources/LogicKit/Resources/ledger.json")

    /// Call as the last line of a live test, after all assertions (continueAfterFailure = false).
    static func pass(_ kind: NodeKind, _ name: String) throws {
        let cap = try XCTUnwrap(Grammar.find(kind, name))
        var l = try Ledger.load(url)
        l.record(cap, version: LogicApp.version() ?? "unknown", date: ISO8601DateFormatter().string(from: Date()))
        try l.write(to: url)
    }
}

class LiveCase: XCTestCase {
    override func setUp() { continueAfterFailure = false }
    func env(_ root: LiveAXRoot) -> RecipeEnv { RecipeEnv(root: root, locale: .en, logicPID: root.pid) }
}
```

`Tests/LogicLiveTests/LiveTrackTests.swift`:
```swift
import XCTest
import LogicKit

final class LiveTrackTests: LiveCase {
    func roundTrip(_ which: TrackToggle.Which) throws {
        let root = try Live.require()
        let t = try XCTUnwrap(TrackReader.read(root, .en).first)
        let original = (which == .mute ? t.mute : t.solo) ?? false
        let path = "track:\(t.number)/\(which.rawValue)"
        XCTAssertEqual(try RecipeRunner.run(TrackToggle(track: t.number, which: which, on: !original), env: env(root)),
                       .ok(path: path, actual: !original ? "on" : "off"))   // no notes = no window side effects
        let now = try XCTUnwrap(TrackReader.read(root, .en).first)
        XCTAssertEqual(which == .mute ? now.mute : now.solo, !original)
        _ = try RecipeRunner.run(TrackToggle(track: t.number, which: which, on: original), env: env(root))
        XCTAssertEqual(try RecipeRunner.run(TrackToggle(track: t.number, which: which, on: original), env: env(root)),
                       .ok(path: path, actual: original ? "on" : "off"))   // idempotent no-op
    }

    func testMuteRoundTrip() throws { try roundTrip(.mute); try LiveLedger.pass(.track, "mute") }
    func testSoloRoundTrip() throws { try roundTrip(.solo); try LiveLedger.pass(.track, "solo") }

    func testSelectAndRestore() throws {
        let root = try Live.require()
        let tracks = try TrackReader.read(root, .en)
        let original = try XCTUnwrap(tracks.first(where: \.selected))
        let other = try XCTUnwrap(tracks.first { !$0.selected })
        XCTAssertEqual(try RecipeRunner.run(SelectTrack(track: other.number), env: env(root)), .ok(path: "track:\(other.number)", actual: "selected"))
        XCTAssertEqual(try TrackReader.selectedNumber(root, .en), other.number)
        _ = try RecipeRunner.run(SelectTrack(track: original.number), env: env(root))
        let after = try TrackReader.read(root, .en)
        XCTAssertEqual(after.first(where: \.selected)?.number, original.number)
        XCTAssertEqual(after.first { $0.number == other.number }?.arm, other.arm)   // arm unchanged (S8)
        try LiveLedger.pass(.track, "select")
    }

    /// §12.2: the invariant holds on the error path too.
    func testAbortLeavesNoWindowSideEffects() throws {
        let root = try Live.require()
        let before = try WindowSnapshot.capture(logicPID: root.pid, root: root)
        struct Boom: Recipe {
            var spec: RecipeSpec { RecipeSpec(name: "boom") }
            func run(_ ctx: RecipeContext) throws -> Outcome { throw LogicError.unavailable("forced abort") }
        }
        XCTAssertThrowsError(try RecipeRunner.run(Boom(), env: env(root)))
        XCTAssertTrue(before.diff(to: try WindowSnapshot.capture(logicPID: root.pid, root: root)).isClean)
    }
}
```

`Tests/LogicLiveTests/LiveUndoTests.swift`:
```swift
import XCTest
import LogicKit

final class LiveUndoTests: LiveCase {
    /// Menu path for "new audio track" as recorded in S9 Step 2.
    let newTrackMenu = ["Track", "New Audio Track"]

    func testUndoRedoNewTrack() throws {
        let root = try Live.require()
        let n0 = try TrackReader.read(root, .en).count
        try Primitives.menu(try XCTUnwrap(root.menuBar()), newTrackMenu)
        let r = try Verify.poll(deadline: Clock.system.now() + 2, clock: .system, read: { try TrackReader.read(root, .en).count }, done: { $0 == n0 + 1 })
        XCTAssertTrue(r.ok)
        _ = try RecipeRunner.run(UndoRedo(mode: .undo, steps: 1), env: env(root))
        XCTAssertEqual(try TrackReader.read(root, .en).count, n0)
        _ = try RecipeRunner.run(UndoRedo(mode: .redo, steps: 1), env: env(root))
        XCTAssertEqual(try TrackReader.read(root, .en).count, n0 + 1)
        _ = try RecipeRunner.run(UndoRedo(mode: .undo, steps: 1), env: env(root))
        XCTAssertEqual(try TrackReader.read(root, .en).count, n0)
        try LiveLedger.pass(.root, "undo")
        try LiveLedger.pass(.root, "redo")
    }
}
```

`Tests/LogicLiveTests/LiveTransportTests.swift`:
```swift
import XCTest
import LogicKit

final class LiveTransportTests: LiveCase {
    func testPlayStop() throws {
        let root = try Live.require()
        XCTAssertEqual(try RecipeRunner.run(TransportCommand(command: .play), env: env(root)), .ok(path: "transport", actual: "playing"))
        XCTAssertEqual(try RecipeRunner.run(TransportCommand(command: .stop), env: env(root)), .ok(path: "transport", actual: "stopped"))
        try LiveLedger.pass(.transport, "play")
        try LiveLedger.pass(.transport, "stop")
    }

    func testLocate() throws {
        let root = try Live.require()
        let target = BarPosition(bar: 5)
        XCTAssertEqual(try RecipeRunner.run(Locate(position: target), env: env(root)), .ok(path: "transport/position", actual: "5 1 1 1"))
        _ = try RecipeRunner.run(Locate(position: BarPosition(bar: 1)), env: env(root))
        try LiveLedger.pass(.transport, "position")
    }
}
```

  - [ ] **Step 5: Офлайн** — `swift test --filter LogicKitTests 2>&1 | tail -3` → PASS, включая `CompletenessTests` (падает, пока `LiveReadTests` нет: этот класс появляется в Task 29, поэтому в этой задаче проверять `CompletenessTests` только после Task 29 или временно удостовериться, что падение — ровно `LiveReadTests`).

  - [ ] **Step 6: Live** — `Scripts/fixture-open.sh belo-krasny`, затем `LOGIC_LIVE=1 swift test --filter 'LiveTrackTests|LiveUndoTests|LiveTransportTests' 2>&1 | tail -15`. Expected: PASS; `git diff Sources/LogicKit/Resources/ledger.json` показывает новые строки. Упавший тест чинится через рецепт или якорь; ledger руками не правится.

  - [ ] **Step 7: Commit** — `git add Sources/LogicKit/Engine/Recipes Tests/LogicLiveTests Tests/LogicKitTests/CompletenessTests.swift Sources/LogicKit/Resources/ledger.json && git commit -m "p1 recipes: mute, solo, select, undo, transport; live tests and ledger"`

---

### Task 29: LogicSession — фасад для адаптеров

**Files:** Create `Sources/LogicKit/Session/LogicSession.swift`; Test `Tests/LogicKitTests/SessionTests.swift`; Create `Tests/LogicLiveTests/LiveReadTests.swift`

**Interfaces:** Produces `final class LogicSession: Sendable` — `init(locale:executor:ledger:rootFactory:pidProvider:)`, `static func live() -> LogicSession`, `read(_ path: String, depth: Int = 1, fields: [String]? = nil, page: String? = nil) async throws -> String`, `set(_ assigns: [(path: String, value: String)]) async throws -> String`, `perform(steps: [(path: String, action: String, args: [String: String])]) async throws -> String`. Все ошибки — `LogicError`.

  - [ ] **Step 1: Тесты**
```swift
import XCTest
@testable import LogicKit

final class SessionTests: XCTestCase {
    func session(_ fixture: String = "mini", ledger: Ledger = Ledger(entries: [])) throws -> LogicSession {
        let root = FixtureAXRoot(try AXFixture.load(Fixtures.url("ax/\(fixture).json")))
        return LogicSession(locale: .en, executor: AXExecutor(healthProbe: { true }), ledger: ledger,
                            rootFactory: { root }, pidProvider: { nil })
    }

    func testReadRootTrackStrip() async throws {
        let s = try session()
        let root = try await s.read("/")
        XCTAssertTrue(root.contains("tracks:4"))
        XCTAssertTrue(root.contains("[selected]"))
        let t2 = try await s.read("track:2")
        XCTAssertTrue(t2.contains(" strip vol=-4.2dB"))
        XCTAssertTrue(t2.contains("insert:1 Channel EQ · 2 ChromaVerb(bypass)"))
        let t1 = try await s.read("track:1")
        XCTAssertTrue(t1.contains("?unavailable(need_select"))
        let viaStack = try await s.read("track:2/track:1")
        XCTAssertEqual(viaStack, t1)
        let raw = try await s.read("track:1/raw")
        XCTAssertTrue(raw.contains("AXCheckBox d=\"Mute\""))
    }

    func testReadErrorsAndSchema() async throws {
        let s = try session()
        do { _ = try await s.read("track:\"Nope\""); XCTFail() } catch let e as LogicError { XCTAssertEqual(e.code, "not_found") }
        let schema = try await s.read("system/schema/track")
        XCTAssertTrue(schema.contains("no live-verified"))   // empty ledger → nothing advertised
    }

    func testSetRequiresAdvertisedAndValidValue() async throws {
        do { _ = try await session().set([("track:1/mute", "on")]); XCTFail() }
        catch let e as LogicError { XCTAssertEqual(e.code, "unsupported") }
        var l = Ledger(entries: [])
        l.record(Grammar.find(.track, "mute")!, version: "11.2", date: "x")
        do { _ = try await session(ledger: l).set([("track:1/mute", "maybe")]); XCTFail() }
        catch let e as LogicError { XCTAssertEqual(e.code, "invalid_value") }
        // fixture is read-only: a real attempt fails as unsupported, proving the recipe ran through the runner
        do { _ = try await session(ledger: l).set([("track:1/mute", "on")]); XCTFail() }
        catch let e as LogicError { XCTAssertEqual(e, .unsupported("fixture is read-only")) }
    }
}
```
Для `testSetRequiresAdvertisedAndValidValue` у `mini.json` версия `11.2`; `LogicSession` в офлайн-режиме берёт minor из `ledger.latestMinor`, потому что `LogicApp.version()` вернёт версию запущенного Logic (или nil). Поэтому сессия получает параметр `logicMinor: @Sendable () -> String?` с дефолтом `{ LogicApp.version().map(LogicApp.minor) }`, а тест передаёт `{ nil }`. Добавить его в `init` и в вызов `session(...)`.

  - [ ] **Step 2: FAIL. Step 3: Реализация**
```swift
import Foundation

public final class LogicSession: @unchecked Sendable {
    public let executor: AXExecutor
    public let locale: LocaleTable
    public let handles = HandleTable()
    let ledger: Ledger
    let rootFactory: @Sendable () throws -> any AXRoot
    let pidProvider: @Sendable () -> pid_t?
    let logicMinor: @Sendable () -> String?

    public init(locale: LocaleTable = .en, executor: AXExecutor, ledger: Ledger = .bundled(),
                rootFactory: @escaping @Sendable () throws -> any AXRoot, pidProvider: @escaping @Sendable () -> pid_t?,
                logicMinor: @escaping @Sendable () -> String? = { LogicApp.version().map(LogicApp.minor) }) {
        self.locale = locale; self.executor = executor; self.ledger = ledger
        self.rootFactory = rootFactory; self.pidProvider = pidProvider; self.logicMinor = logicMinor
    }

    public static func live(locale: LocaleTable = .en) -> LogicSession {
        LogicSession(
            locale: locale,
            executor: AXExecutor(healthProbe: {
                guard let pid = LogicApp.pid else { return false }
                return (try? LiveAXRoot(pid: pid, timeout: 0.25).mainWindow()) != nil
            }),
            rootFactory: {
                guard LogicApp.axTrusted else { throw LogicError.permissionAX }
                guard let pid = LogicApp.pid else { throw LogicError.logicNotRunning }
                return LiveAXRoot(pid: pid)
            },
            pidProvider: { LogicApp.pid })
    }

    var advertised: [Capability] { Grammar.advertised(ledger: ledger, logicMinor: logicMinor()) }

    func onAX<T: Sendable>(_ transaction: Bool = false, _ body: @escaping @Sendable (any AXRoot) throws -> T) async throws -> T {
        let factory = rootFactory
        do {
            let job: @Sendable () throws -> T = { try body(try factory()) }
            return transaction ? try await executor.transaction(job) : try await executor.read(job)
        } catch ExecutorError.busy {
            throw LogicError.busy("Logic is not responding (bounce or loading?)")
        } catch let e as LogicError {
            throw e
        } catch {
            throw RecipeRunner.map(error)
        }
    }

    // MARK: read

    public func read(_ path: String, depth: Int = 1, fields: [String]? = nil, page: String? = nil) async throws -> String {
        let p = Resolver.canonical(try LPath.parse(path))
        let options = RenderOptions(page: try page.map(RenderOptions.parsePage), fields: fields)
        if let bad = fields?.first(where: { !TextRenderer.fieldNames.contains($0) }) {
            throw LogicError.invalidArgs(signature: "fields: " + TextRenderer.fieldNames.joined(separator: ","), detail: "unknown field \(bad)")
        }
        let caps = advertised
        let L = locale, handles = handles, version = LogicApp.version()
        return try await onAX { root in
            let kinds = p.segments.map(\.kind)
            switch kinds {
            case []:
                let tracks = try TrackReader.read(root, L)
                var warnings: [String] = []
                if let modal = try ModalGuard.modalTitle(root, L) { warnings.append("modal \"\(modal)\" is open") }
                return TextRenderer.root(project: try ProjectReader.read(root, version: version),
                                         transport: try? TransportReader.read(root, L), tracks: tracks,
                                         handles: Resolver.handles(for: tracks, table: handles), options: options, warnings: warnings)
            case [.transport]:
                return TextRenderer.transport(try TransportReader.read(root, L))
            case [.system]:
                let missing = try AnchorProbe.missing(root, L).map(\.rawValue)
                var s = "system logic=\(version ?? "?") ax=granted advertised=\(caps.count)"
                if !missing.isEmpty { s += "\n⚠ anchors missing: " + missing.joined(separator: ", ") }
                if caps.isEmpty { s += "\n⚠ this Logic version has no live-verified capabilities" }
                return s
            case [.system, .schema]:
                guard case .id(let k)? = p.segments[1].selector, let kind = NodeKind(rawValue: k) else { throw LogicError.invalidArgs(signature: "system/schema/<kind>", detail: "bad kind") }
                return Grammar.schema(kind, caps: caps)
            case [.track], [.track, .strip], [.track, .raw]:
                let tracks = try TrackReader.read(root, L)
                let (t, note) = try Resolver.track(p.segments[0].selector!, in: tracks, table: handles)
                let hs = Resolver.handles(for: tracks, table: handles)
                let handle = hs[tracks.firstIndex(of: t)!]
                if kinds.last == .raw {
                    return try Self.raw(TrackReader.row(number: t.number, root, L), depth: max(depth, 1))
                }
                let strip = t.selected ? try StripReader.inspector(root, L) : nil
                var text = kinds.last == .strip
                    ? (t.selected && strip != nil ? String(TextRenderer.strip(strip!).dropFirst()) : "?unavailable(need_select: logic_do track:\(t.number) select)")
                    : TextRenderer.track(t, handle: handle, strip: strip)
                if let note { text += "\n\(note)" }
                return text
            default:
                throw LogicError.unsupported("reading \(p) is not available yet")
            }
        }
    }

    static func raw(_ node: any AXNode, depth: Int) throws -> String {
        var lines: [String] = []
        func walk(_ n: any AXNode, _ d: Int, _ indent: Int) throws {
            guard lines.count < 60 else { return }
            lines.append(String(repeating: " ", count: indent) + (try n.attrs().compactLine))
            guard d > 0 else { return }
            for c in try n.children() { try walk(c, d - 1, indent + 1) }
        }
        try walk(node, depth, 0)
        if lines.count >= 60 { lines.append("… (truncated at 60 nodes; read a deeper path)") }
        return lines.joined(separator: "\n")
    }

    // MARK: set / do

    func resolveTarget(_ p: LPath, root: any AXRoot) throws -> (kind: NodeKind, track: Int?) {
        guard let first = p.segments.first else { return (.root, nil) }
        if first.kind == .track {
            let (t, _) = try Resolver.track(first.selector!, in: try TrackReader.read(root, locale), table: handles)
            return (.track, t.number)
        }
        return (p.segments.last!.kind, nil)
    }

    func env(_ root: any AXRoot) -> RecipeEnv { RecipeEnv(root: root, locale: locale, logicPID: pidProvider()) }

    public func set(_ assigns: [(path: String, value: String)]) async throws -> String {
        var done: [String] = []
        for (path, raw) in assigns {
            do {
                let p = Resolver.canonical(try LPath.parse(path))
                guard let name = p.property else { throw LogicError.invalidArgs(signature: "assign: [{path: \"track:N/mute\", value: \"on\"}]", detail: "path must end with a property") }
                let kind = p.segments.last?.kind ?? .root
                guard let cap = advertised.first(where: { $0.kind == kind && $0.name == name }), case .property(let unit) = cap.form else {
                    throw LogicError.unsupported("\(kind.rawValue)/\(name) is not live-verified")
                }
                let value: LogicValue
                do { value = try ValueParser.parse(raw, unit: unit) }
                catch let e as ValueError { throw LogicError.invalidValue(want: raw, range: e.message) }
                let text = try await onAX(true) { [self] root in
                    let target = try self.resolveTarget(p, root: root)
                    let recipe = try RecipeRegistry.property(kind, name, track: target.track, value: value)
                    return try RecipeRunner.run(recipe, env: self.env(root), restorer: SelectTrack(track: 0)).text
                }
                done.append(text)
            } catch let e as LogicError {
                if done.isEmpty { throw e }
                throw LogicError.partial(done: done, failed: "\(path): \(e.code)", undoSteps: nil)
            }
        }
        return done.joined(separator: "\n")
    }

    public func perform(steps: [(path: String, action: String, args: [String: String])]) async throws -> String {
        var done: [String] = []
        for (path, action, args) in steps {
            do {
                let p = Resolver.canonical(try LPath.parse(path))
                let kind = p.segments.last?.kind ?? .root
                guard advertised.contains(where: { $0.kind == kind && $0.name == action }) else {
                    throw LogicError.unsupported("\(kind.rawValue) \(action) is not live-verified")
                }
                let text = try await onAX(true) { [self] root in
                    let target = try self.resolveTarget(p, root: root)
                    let recipe = try RecipeRegistry.action(kind, action, track: target.track, args: args)
                    return try RecipeRunner.run(recipe, env: self.env(root), restorer: SelectTrack(track: 0)).text
                }
                if action == "undo" || action == "redo" { handles.reset() }   // structural change (spec §4.4)
                done.append(text)
            } catch let e as LogicError {
                if done.isEmpty { throw e }
                throw LogicError.partial(done: done, failed: "\(path) \(action): \(e.code)", undoSteps: nil)
            }
        }
        return done.joined(separator: "\n")
    }
}
```
`restorer: SelectTrack(track: 0)` — `SelectTrack.select(_:ctx:)` берёт номер из аргумента, поле `track` для восстановления не используется. В P1 ни один рецепт не имеет `changesSelection`, поэтому restorer пока не вызывается. Он подключён, чтобы рецепты P2 сразу получили возврат выделения.

  - [ ] **Step 4: Live-чтение** — `Tests/LogicLiveTests/LiveReadTests.swift`:
```swift
import XCTest
import LogicKit

final class LiveReadTests: LiveCase {
    func session() throws -> LogicSession { _ = try Live.require(); return LogicSession.live() }

    func testReadRoot() async throws {
        let text = try await session().read("/")
        XCTAssertTrue(text.contains("tracks:"))
        XCTAssertLessThanOrEqual(TokenEstimate.count(text), 350)
        try LiveLedger.pass(.root, "read")
    }

    func testReadTrack() async throws {
        let text = try await session().read("track:1")
        XCTAssertTrue(text.hasPrefix("track:1 #t"))
        try LiveLedger.pass(.track, "read")
    }

    func testReadSelectedStrip() async throws {
        let text = try await session().read("track:selected/strip")
        XCTAssertTrue(text.contains("insert"))
        try LiveLedger.pass(.strip, "read")
    }

    func testReadTransport() async throws {
        let text = try await session().read("transport")
        XCTAssertTrue(text.hasPrefix("transport stopped") || text.hasPrefix("transport playing"))
        try LiveLedger.pass(.transport, "read")
    }
}
```
  - [ ] **Step 5: Прогнать** — `swift test --filter 'SessionTests|CompletenessTests'` → PASS. Затем live: `LOGIC_LIVE=1 swift test --filter LiveReadTests` на `fixture-belo-krasny` → PASS, ledger дополнен.
  - [ ] **Step 6: Commit** — `git add Sources/LogicKit/Session Tests/LogicKitTests/SessionTests.swift Tests/LogicLiveTests/LiveReadTests.swift Sources/LogicKit/Resources/ledger.json && git commit -m "logic session facade: read, set, do over the executor"`

---

### Task 30: Адаптер LogicMCP

**Files:** Create `Sources/LogicMCP/main.swift`, `Server.swift`, `ToolDefs.swift`, `ArgValidator.swift`; Modify `Package.swift`; Test `Tests/LogicMCPTests/ArgValidatorTests.swift`, `Tests/LogicMCPTests/ToolBudgetTests.swift`

**Interfaces:** Consumes `LogicSession`, `Grammar`, `Ledger`, `LogicError`, `TokenEstimate`. Produces исполняемый таргет `LogicMCP`, `ToolDefs.all(advertised:) -> [Tool]`, `ArgValidator.read/set/perform`, `Handlers.call(_:session:) async -> CallTool.Result`.

`confirm` в P1 в схему не входит: необратимых действий (quit, close без сохранения, flatten) в срезе нет. Появится вместе с ними в P3/P4.

  - [ ] **Step 1: Package.swift** — добавить:
```swift
        .executableTarget(
            name: "LogicMCP",
            dependencies: ["LogicKit", .product(name: "MCP", package: "swift-sdk")],
            path: "Sources/LogicMCP"
        ),
        .testTarget(name: "LogicMCPTests", dependencies: ["LogicMCP", "LogicKit"], path: "Tests/LogicMCPTests"),
```

  - [ ] **Step 2: Тесты**
```swift
import XCTest
import MCP
import LogicKit
@testable import LogicMCP

final class ArgValidatorTests: XCTestCase {
    func testReadDefaultsAndChecks() throws {
        let a = try ArgValidator.read(nil)
        XCTAssertEqual(a.path, "/"); XCTAssertEqual(a.depth, 1)
        XCTAssertEqual(try ArgValidator.read(["path": .string("track:3"), "fields": .string("name,mute")]).fields, ["name", "mute"])
        XCTAssertThrowsError(try ArgValidator.read(["depth": .int(9)]))
        XCTAssertThrowsError(try ArgValidator.read(["bogus": .string("x")]))
    }

    func testSetAndDo() throws {
        let s = try ArgValidator.set(["assign": .array([.object(["path": .string("track:1/mute"), "value": .string("on")])])])
        XCTAssertEqual(s.first?.path, "track:1/mute")
        XCTAssertThrowsError(try ArgValidator.set(["assign": .array([])]))
        let d = try ArgValidator.perform(["path": .string("/"), "action": .string("undo"), "args": .object(["steps": .int(2)])])
        XCTAssertEqual(d.first?.args["steps"], "2")
        let multi = try ArgValidator.perform(["steps": .array([.object(["path": .string("transport"), "action": .string("play")])])])
        XCTAssertEqual(multi.count, 1)
        XCTAssertThrowsError(try ArgValidator.perform(["path": .string("/")]))
    }
}

final class ToolBudgetTests: XCTestCase {
    func testAllToolDescriptionsFitBudget() throws {
        let tools = ToolDefs.all(advertised: Grammar.all.filter { $0.status == .recipe })
        let json = String(decoding: try JSONEncoder().encode(tools), as: UTF8.self)
        XCTAssertLessThanOrEqual(TokenEstimate.count(json), 1500)
    }
}
```
  - [ ] **Step 3: FAIL. Step 4: Реализация**

`Sources/LogicMCP/ArgValidator.swift`:
```swift
import LogicKit
import MCP

struct ReadArgs { var path: String; var depth: Int; var fields: [String]?; var page: String? }

enum ArgValidator {
    static func bad(_ sig: String, _ detail: String) -> LogicError { .invalidArgs(signature: sig, detail: detail) }

    static func string(_ v: Value?) -> String? {
        switch v {
        case .string(let s)?: return s
        case .int(let i)?: return String(i)
        case .double(let d)?: return String(d)
        case .bool(let b)?: return b ? "on" : "off"
        default: return nil
        }
    }

    static func onlyKeys(_ a: [String: Value], _ allowed: Set<String>, _ sig: String) throws {
        if let k = a.keys.first(where: { !allowed.contains($0) }) { throw bad(sig, "unknown argument \(k)") }
    }

    static let readSig = #"logic_read {path?: "/", depth?: 0..3, fields?: "name,mute", page?: "13-24"}"#
    static func read(_ args: [String: Value]?) throws -> ReadArgs {
        let a = args ?? [:]
        try onlyKeys(a, ["path", "depth", "fields", "page"], readSig)
        let depth = a["depth"].flatMap { $0.intValue } ?? 1
        guard (0...3).contains(depth) else { throw bad(readSig, "depth \(depth) out of 0..3") }
        return ReadArgs(path: string(a["path"]) ?? "/", depth: depth,
                        fields: string(a["fields"]).map { $0.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) } },
                        page: string(a["page"]))
    }

    static let setSig = #"logic_set {assign: [{path: "track:1/mute", value: "on"}, …]} (1..32, in order)"#
    static func set(_ args: [String: Value]?) throws -> [(path: String, value: String)] {
        let a = args ?? [:]
        try onlyKeys(a, ["assign"], setSig)
        guard let items = a["assign"]?.arrayValue, (1...32).contains(items.count) else { throw bad(setSig, "assign must be a non-empty array") }
        return try items.map { item in
            guard let o = item.objectValue, let p = string(o["path"]), let v = string(o["value"]) else { throw bad(setSig, "each item needs path and value") }
            return (p, v)
        }
    }

    static let doSig = #"logic_do {path, action, args?} or {steps: [{path, action, args?}]}"#
    static func perform(_ args: [String: Value]?) throws -> [(path: String, action: String, args: [String: String])] {
        let a = args ?? [:]
        try onlyKeys(a, ["path", "action", "args", "steps"], doSig)
        func one(_ o: [String: Value]) throws -> (path: String, action: String, args: [String: String]) {
            guard let p = string(o["path"]), let act = string(o["action"]) else { throw bad(doSig, "path and action are required") }
            var extra: [String: String] = [:]
            for (k, v) in o["args"]?.objectValue ?? [:] {
                guard let s = string(v) else { throw bad(doSig, "args.\(k) must be a scalar") }
                extra[k] = s
            }
            return (p, act, extra)
        }
        if let steps = a["steps"]?.arrayValue {
            guard (1...32).contains(steps.count) else { throw bad(doSig, "steps must have 1..32 items") }
            return try steps.map { guard let o = $0.objectValue else { throw bad(doSig, "each step is an object") }; return try one(o) }
        }
        return [try one(a)]
    }
}
```

`Sources/LogicMCP/ToolDefs.swift`:
```swift
import LogicKit
import MCP

enum ToolDefs {
    static func prop(_ type: String, _ desc: String) -> Value { .object(["type": .string(type), "description": .string(desc)]) }

    static func all(advertised caps: [Capability]) -> [Tool] {
        let actions = Array(Set(caps.compactMap { c -> String? in if case .action = c.form { return c.name }; return nil })).sorted()
        return [
            Tool(name: "logic_read",
                 description: "Read Logic Pro as a map, in Logic units. Paths: / · track:3|track:\"Name\"|track:selected|#handle [/strip|/raw] · transport · system · system/schema/<kind>. Long lists fold; use page or fields. Live: \(Grammar.index(caps))",
                 inputSchema: .object(["type": .string("object"), "additionalProperties": .bool(false), "properties": .object([
                    "path": prop("string", "default /"), "depth": prop("integer", "0..3"),
                    "fields": prop("string", "name,kind,mute,solo,arm,selected,volume,pan,takes"), "page": prop("string", "e.g. 13-24"),
                 ])]),
                 annotations: .init(readOnlyHint: true, destructiveHint: false, idempotentHint: true, openWorldHint: false)),
            Tool(name: "logic_set",
                 description: "Set properties in order, each verified by readback. Stops at the first error (partial). Example: {assign:[{path:\"track:2/mute\",value:\"on\"}]}",
                 inputSchema: .object(["type": .string("object"), "required": .array([.string("assign")]), "properties": .object([
                    "assign": .object(["type": .string("array"), "items": .object(["type": .string("object"), "required": .array([.string("path"), .string("value")]),
                        "properties": .object(["path": prop("string", "node/property"), "value": prop("string", "Logic units, e.g. on, -6 dB, 17 1 1 1")])])]),
                 ])]),
                 annotations: .init(readOnlyHint: false, destructiveHint: false, idempotentHint: true, openWorldHint: false)),
            Tool(name: "logic_do",
                 description: "Run a verified action on a node, or ordered steps. Details: logic_read system/schema/<kind>.",
                 inputSchema: .object(["type": .string("object"), "properties": .object([
                    "path": prop("string", "node, e.g. track:3, /, transport"),
                    "action": .object(["type": .string("string"), "enum": .array(actions.map { .string($0) })]),
                    "args": prop("object", "action arguments"),
                    "steps": prop("array", "[{path, action, args?}]"),
                 ])]),
                 annotations: .init(readOnlyHint: false, destructiveHint: true, idempotentHint: false, openWorldHint: false)),
        ]
    }
}
```

`Sources/LogicMCP/Server.swift`:
```swift
import LogicKit
import MCP

enum Handlers {
    static func call(_ p: CallTool.Parameters, session: LogicSession) async -> CallTool.Result {
        do {
            let text: String
            switch p.name {
            case "logic_read":
                let a = try ArgValidator.read(p.arguments)
                text = try await session.read(a.path, depth: a.depth, fields: a.fields, page: a.page)
            case "logic_set":
                text = try await session.set(try ArgValidator.set(p.arguments))
            case "logic_do":
                text = try await session.perform(steps: try ArgValidator.perform(p.arguments))
            default:
                throw LogicError.invalidArgs(signature: "tools: logic_read, logic_set, logic_do", detail: "unknown tool \(p.name)")
            }
            return CallTool.Result(content: [.text(text)], isError: false)
        } catch let e as LogicError {
            return CallTool.Result(content: [.text(e.text)], isError: true)
        } catch {
            return CallTool.Result(content: [.text("unavailable: \(error)")], isError: true)
        }
    }
}

actor MCPServer {
    let session: LogicSession
    init(session: LogicSession) { self.session = session }

    func start() async throws {
        let server = Server(name: "logic-pro-mcp", version: LogicKitInfo.version,
                            capabilities: .init(tools: .init(listChanged: false)))
        let caps = Grammar.advertised(ledger: .bundled(), logicMinor: LogicApp.version().map(LogicApp.minor))
        let tools = ToolDefs.all(advertised: caps)
        let session = self.session
        await server.withMethodHandler(ListTools.self) { _ in ListTools.Result(tools: tools) }
        await server.withMethodHandler(CallTool.self) { params in await Handlers.call(params, session: session) }
        Log.info("logic-pro-mcp \(LogicKitInfo.version): \(caps.count) live-verified capabilities", subsystem: "server")
        try await server.start(transport: StdioTransport())
        await server.waitUntilCompleted()
    }
}
```

`Sources/LogicMCP/main.swift`:
```swift
import Foundation
import LogicKit

if CommandLine.arguments.contains("--check-permissions") {
    let ok = LogicApp.axTrusted
    FileHandle.standardError.write(Data("Accessibility: \(ok ? "granted" : "NOT GRANTED — System Settings › Privacy & Security › Accessibility")\n".utf8))
    exit(ok ? 0 : 1)
}

do {
    try await MCPServer(session: .live()).start()
} catch {
    Log.error("server failed: \(error)", subsystem: "main")
    exit(1)
}
```
  - [ ] **Step 5: Прогнать** — `swift test --filter LogicMCPTests` → PASS. Если бюджет 1500 превышен, сократить описания, а не бюджет.
  - [ ] **Step 6: Commit** — `git add Package.swift Sources/LogicMCP Tests/LogicMCPTests && git commit -m "thin mcp adapter: logic_read, logic_set, logic_do"`

---

### Task 31: Переключение: MIDI в LogicKit, `logic_midi`, удаление upstream-кода

**Files:**
  - Move: `Sources/LogicProMCP/MIDI/{MIDIEngine,MIDIFeedback,MMCCommands}.swift` → `Sources/LogicKit/Streams/MIDI/`
  - Create: `Sources/LogicKit/Streams/MIDI/MIDIConfig.swift`, `Sources/LogicKit/Streams/MIDI/MIDIEvent.swift`
  - Modify: `Sources/LogicKit/Session/LogicSession.swift` (`midi`), `Sources/LogicMCP/{ToolDefs,ArgValidator,Server}.swift`, `Package.swift`, `Scripts/install.sh`, `manifest.json`
  - Delete: `Sources/LogicProMCP/`, `Tests/LogicProMCPTests/`
  - Test: `Tests/LogicKitTests/MIDIEventTests.swift`, дополнить `ArgValidatorTests`

**Interfaces:** Produces `enum MIDIConfig { sourceName = "LogicProMCP-Out"; sinkName = "LogicProMCP-In"; mmcDeviceID: UInt8 = 0x7F }`; `enum MIDIEvent: Equatable, Sendable { note(ch: Int, note: Int, vel: Int, durMs: Int), cc(ch: Int, cc: Int, value: Int), pc(ch: Int, program: Int), pitchBend(ch: Int, value: Int) }` + `func validate() throws`, `var onBytes: [UInt8]`, `var offBytes: [UInt8]?`; `LogicSession.midi(_ events: [MIDIEvent]) async throws -> String` → `→ sent N events`.

  - [ ] **Step 1: Тест событий**
```swift
import XCTest
@testable import LogicKit

final class MIDIEventTests: XCTestCase {
    func testBytesAndValidation() throws {
        XCTAssertEqual(MIDIEvent.note(ch: 1, note: 60, vel: 100, durMs: 250).onBytes, [0x90, 60, 100])
        XCTAssertEqual(MIDIEvent.note(ch: 2, note: 60, vel: 100, durMs: 250).offBytes, [0x81, 60, 0])
        XCTAssertEqual(MIDIEvent.cc(ch: 16, cc: 7, value: 127).onBytes, [0xBF, 7, 127])
        XCTAssertEqual(MIDIEvent.pitchBend(ch: 1, value: 8192).onBytes, [0xE0, 0x00, 0x40])
        XCTAssertThrowsError(try MIDIEvent.note(ch: 17, note: 60, vel: 1, durMs: 1).validate())
        XCTAssertThrowsError(try MIDIEvent.cc(ch: 1, cc: 128, value: 0).validate())
    }
}
```
  - [ ] **Step 2: Перенос MIDI**

Run: `mkdir -p Sources/LogicKit/Streams/MIDI && git mv Sources/LogicProMCP/MIDI/MIDIEngine.swift Sources/LogicProMCP/MIDI/MIDIFeedback.swift Sources/LogicProMCP/MIDI/MMCCommands.swift Sources/LogicKit/Streams/MIDI/`

`MIDIConfig.swift`:
```swift
public enum MIDIConfig {
    public static let sourceName = "LogicProMCP-Out"
    public static let sinkName = "LogicProMCP-In"
    public static let mmcDeviceID: UInt8 = 0x7F
}
```
В перенесённых файлах: `ServerConfig.virtualMIDISourceName` → `MIDIConfig.sourceName`, `ServerConfig.virtualMIDISinkName` → `MIDIConfig.sinkName`, `ServerConfig.mmcDeviceID` → `MIDIConfig.mmcDeviceID` (`sed -i '' …` по трём файлам). `actor MIDIEngine`, его `init`, `start`, `stop`, `sendNoteOn/Off`, `sendCC`, `sendProgramChange`, `sendPitchBend`, `sendSysEx` пометить `public`. `enum MMCCommands` и его функции — `public`. Если `swift build` требует `public` у типов из сигнатур (например `MIDIFeedback.Event` у `inboundMessages`), добавить `public` и туда.

`MIDIEvent.swift`:
```swift
public enum MIDIEvent: Equatable, Sendable {
    case note(ch: Int, note: Int, vel: Int, durMs: Int)
    case cc(ch: Int, cc: Int, value: Int)
    case pc(ch: Int, program: Int)
    case pitchBend(ch: Int, value: Int)

    var channel: Int {
        switch self { case .note(let c, _, _, _), .cc(let c, _, _), .pc(let c, _), .pitchBend(let c, _): return c }
    }

    public func validate() throws {
        func r(_ v: Int, _ range: ClosedRange<Int>, _ what: String) throws {
            guard range.contains(v) else { throw LogicError.invalidValue(want: "\(what)=\(v)", range: "\(range.lowerBound)…\(range.upperBound)") }
        }
        try r(channel, 1...16, "ch")
        switch self {
        case .note(_, let n, let v, let d): try r(n, 0...127, "note"); try r(v, 1...127, "vel"); try r(d, 1...60000, "dur_ms")
        case .cc(_, let c, let v): try r(c, 0...127, "cc"); try r(v, 0...127, "value")
        case .pc(_, let p): try r(p, 0...127, "program")
        case .pitchBend(_, let v): try r(v, 0...16383, "value")
        }
    }

    public var onBytes: [UInt8] {
        let ch = UInt8(channel - 1)
        switch self {
        case .note(_, let n, let v, _): return [0x90 | ch, UInt8(n), UInt8(v)]
        case .cc(_, let c, let v): return [0xB0 | ch, UInt8(c), UInt8(v)]
        case .pc(_, let p): return [0xC0 | ch, UInt8(p)]
        case .pitchBend(_, let v): return [0xE0 | ch, UInt8(v & 0x7F), UInt8(v >> 7)]
        }
    }

    public var offBytes: [UInt8]? {
        guard case .note(let c, let n, _, _) = self else { return nil }
        return [0x80 | UInt8(c - 1), UInt8(n), 0]
    }
}
```

В `LogicSession` добавить:
```swift
    let midiEngine = MIDIEngine()

    /// `sent`, never `ok`: Logic's receipt of MIDI is not verifiable (spec §5.5).
    public func midi(_ events: [MIDIEvent]) async throws -> String {
        for e in events { try e.validate() }
        do { try await midiEngine.start() } catch { throw LogicError.unavailable("CoreMIDI: \(error)") }
        for e in events {
            _ = await midiEngine.sendRawBytes(e.onBytes)
            if case .note(_, _, _, let dur) = e, let off = e.offBytes {
                let engine = midiEngine
                Task { try? await Task.sleep(for: .milliseconds(dur)); _ = await engine.sendRawBytes(off) }
            }
        }
        return Outcome.sent("\(events.count) events to \(MIDIConfig.sourceName)").text
    }
```
(`sendRawBytes` тоже сделать `public`.)

  - [ ] **Step 3: `logic_midi` в адаптере**

В `ArgValidator`:
```swift
    static let midiSig = #"logic_midi {events: [{type: note|cc|pc|pitchbend, ch: 1..16, note, vel, dur_ms, cc, value, program}]}"#
    static func midi(_ args: [String: Value]?) throws -> [MIDIEvent] {
        let a = args ?? [:]
        try onlyKeys(a, ["events"], midiSig)
        guard let items = a["events"]?.arrayValue, (1...256).contains(items.count) else { throw bad(midiSig, "events must have 1..256 items") }
        return try items.map { item in
            guard let o = item.objectValue, let type = string(o["type"]) else { throw bad(midiSig, "each event needs type") }
            func i(_ k: String, _ d: Int? = nil) throws -> Int {
                if let v = o[k]?.intValue { return v }
                if let d { return d }
                throw bad(midiSig, "\(type) needs \(k)")
            }
            switch type {
            case "note": return .note(ch: try i("ch", 1), note: try i("note"), vel: try i("vel", 100), durMs: try i("dur_ms", 250))
            case "cc": return .cc(ch: try i("ch", 1), cc: try i("cc"), value: try i("value"))
            case "pc": return .pc(ch: try i("ch", 1), program: try i("program"))
            case "pitchbend": return .pitchBend(ch: try i("ch", 1), value: try i("value", 8192))
            default: throw bad(midiSig, "unknown type \(type)")
            }
        }
    }
```
Тест в `ArgValidatorTests`:
```swift
    func testMidi() throws {
        let e = try ArgValidator.midi(["events": .array([.object(["type": .string("note"), "note": .int(60)])])])
        XCTAssertEqual(e, [.note(ch: 1, note: 60, vel: 100, durMs: 250)])
        XCTAssertThrowsError(try ArgValidator.midi(["events": .array([.object(["type": .string("cc")])])]))
    }
```
В `ToolDefs.all` четвёртый инструмент:
```swift
            Tool(name: "logic_midi",
                 description: "Send realtime MIDI from the LogicProMCP-Out source. Result is 'sent' (not verified).",
                 inputSchema: .object(["type": .string("object"), "required": .array([.string("events")]), "properties": .object([
                    "events": prop("array", "[{type: note|cc|pc|pitchbend, ch?, note, vel?, dur_ms?, cc, value, program}]"),
                 ])]),
                 annotations: .init(readOnlyHint: false, destructiveHint: false, idempotentHint: false, openWorldHint: false)),
```
В `Handlers.call`: `case "logic_midi": text = try await session.midi(try ArgValidator.midi(p.arguments))`, а в сообщении об ошибке неизвестного инструмента добавить `logic_midi`.

  - [ ] **Step 4: Удалить upstream и переключить продукт**

OSC — по решению S6. Если «удаляется»: ничего не переносить. Если «остаётся»: `git mv Sources/LogicProMCP/OSC Sources/LogicKit/Streams/OSC && git mv Sources/LogicProMCP/Utilities/OnceFlag.swift Sources/LogicKit/Support/` и заменить в этих файлах ссылки `ServerConfig.osc*` на константы в новом `Sources/LogicKit/Streams/OSC/OSCConfig.swift` (значения портов/хоста взять из `ServerConfig.swift` до удаления).

Run: `git rm -r -q Sources/LogicProMCP Tests/LogicProMCPTests`

`Package.swift`: удалить таргеты `LogicProMCP` и `LogicProMCPTests`; продукт `.executable(name: "LogicProMCP", targets: ["LogicMCP"])` (имя бинаря прежнее, регистрация в Claude не меняется).

`Scripts/install.sh`: строку `echo "Done. Ensure Accessibility + Automation permissions are granted."` заменить на
```bash
echo "Done. Grant Accessibility to your terminal/Claude app: System Settings › Privacy & Security › Accessibility."
echo "Optional (faster transport): in each Logic project enable Project Settings › Synchronization › MIDI › Listen to MMC Input."
```
`manifest.json`: `"permissions": ["accessibility"]`, `"tools": ["logic_read", "logic_set", "logic_do", "logic_midi"]`, `"resources": []`, описание — `"Logic Pro as a verified map: read, set, do, midi. Accessibility only."`. README переписывается в P6.

  - [ ] **Step 5: Сборка и все офлайн-тесты**

Run: `swift build 2>&1 | tail -3 && swift test 2>&1 | tail -5 && grep -rn "ChannelRouter\|StatePoller\|AppleScript\|CGEvent" Sources || echo clean`
Expected: сборка ок, все тесты PASS, `clean`.

  - [ ] **Step 6: Commit** — `git add -A Sources Tests Package.swift Scripts/install.sh manifest.json && git commit -m "switch binary to logickit adapter, move midi, drop upstream dispatchers"`

---

### Task 32: Приёмка P1

**Files:** Create `Tests/LogicLiveTests/LiveGuardTests.swift`, `Tests/LogicLiveTests/LiveBudgetTests.swift`; Modify `Sources/LogicKit/Resources/ledger.json`, `docs/superpowers/specs/spikes-2026-09.md` (раздел «Приёмка P1»)

  - [ ] **Step 1: Guard записи (§12.13) и бюджеты времени (§7, §12.12)**
```swift
import XCTest
import LogicKit

final class LiveGuardTests: LiveCase {
    func testMutationBlockedWhileRecording() throws {
        let root = try Live.require()
        let bar = try TransportReader.controlBar(root, .en)
        let record = try XCTUnwrap(bar.firstDescendant(AXMatch(desc: .equals(LocaleTable.en[.record])), maxDepth: 5))
        try Primitives.press(record)
        defer { _ = try? RecipeRunner.run(TransportCommand(command: .stop), env: env(root)) }
        _ = try Verify.poll(deadline: Clock.system.now() + 2, clock: .system,
                            read: { try TransportReader.read(root, .en).state }, done: { $0 == .recording })
        XCTAssertThrowsError(try RecipeRunner.run(TrackToggle(track: 1, which: .mute, on: true), env: env(root))) {
            XCTAssertEqual($0 as? LogicError, .blocked(.recording))
        }
        XCTAssertNoThrow(try RecipeRunner.run(TransportCommand(command: .stop), env: env(root)))
    }
}

final class LiveBudgetTests: LiveCase {
    /// Needs fixture-big in front (Scripts/fixture-open.sh big).
    func testReadRootOnBigWithinTimeAndAXBudget() async throws {
        let root = try Live.require()
        guard try root.mainWindow()?.attrs().title?.hasPrefix("fixture-big") == true else { throw XCTSkip("open fixture-big") }
        let session = LogicSession.live()
        _ = try await session.read("/")   // warm-up
        AXStats.shared.reset()
        let t0 = Date()
        let text = try await session.read("/")
        let ms = Date().timeIntervalSince(t0) * 1000
        XCTAssertLessThanOrEqual(ms, 400)
        XCTAssertLessThanOrEqual(AXStats.shared.messages, 300)
        XCTAssertLessThanOrEqual(TokenEstimate.count(text), 350)
    }
}
```
Если бюджет не проходит, записать фактические цифры в «Приёмка P1» и поднять вопрос пользователю. По спеку меняется реализация чтения (меньше AX-сообщений), а не бюджет.

  - [ ] **Step 2: Полный live-прогон**

Run: `Scripts/fixture-open.sh belo-krasny && sleep 20 && LOGIC_LIVE=1 swift test --filter LogicLiveTests 2>&1 | tail -20`
Run: `Scripts/fixture-open.sh big && sleep 20 && LOGIC_LIVE=1 swift test --filter LiveBudgetTests 2>&1 | tail -5`
Expected: всё PASS (или skip там, где спайк вывел capability в `planned`).

  - [ ] **Step 3: Smoke через stdio**

Run:
```bash
swift build --product LogicProMCP && printf '%s\n' \
 '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"smoke","version":"0"}}}' \
 '{"jsonrpc":"2.0","method":"notifications/initialized"}' \
 '{"jsonrpc":"2.0","id":2,"method":"tools/list"}' \
 '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"logic_read","arguments":{"path":"/"}}}' \
 | .build/debug/LogicProMCP 2>/dev/null | head -c 4000
```
Expected: ответ `initialize`, 4 инструмента в `tools/list`, текст карты «бело красного» в ответе id 3.

  - [ ] **Step 4: Чек-лист приёмки P1** (записать в `spikes-2026-09.md` → «Приёмка P1»)
  - спек §12.1: ни одна мутация среза не отвечает `ok` без readback (рецепты Task 28);
  - §12.5: `CompletenessTests` зелёный, в ledger нет строк без capability;
  - §12.6: офлайн-тесты покрывают парсеры, резолвер, хэндлы, рендер, аргументы, раннер;
  - §12.11: live-suite трогал только `fixture-*` (гард `Live.require`);
  - §12.12–13: `LiveBudgetTests` и `LiveGuardTests` зелёные;
  - в `Sources` нет `ChannelRouter`, `StatePoller`, `CGEventChannel`, `AppleScriptChannel`.

  - [ ] **Step 5: Commit** — `git add Tests/LogicLiveTests Sources/LogicKit/Resources/ledger.json docs/superpowers/specs/spikes-2026-09.md && git commit -m "p1 acceptance: live suite, budgets, recording guard"`

  - [ ] **Step 6: 👤 Установка** — **только с явного «да» пользователя**: `Scripts/install.sh` заменяет бинарь `LogicProMCP`, который сейчас зарегистрирован в Claude как upstream-сборка. До этого новый сервер проверяется только через `.build/debug/LogicProMCP`.

---

## Self-review (сделан при написании)

  - **Покрытие спека для P0/P1:** все спайки S1–S12 (Tasks 8–15), синтез и гейт (16); P1 из §11: split LogicKit/LogicMCP (1, 30, 31), AXNode + фикстуры (2–4, 8), LocaleTable (20), Path/Grammar/Resolver/Handles (19, 27, 23, 22), AXExecutor/Primitives/Verify (6, 25), ArgValidator/TextRenderer (30, 24), ledger + тест полноты (27–28), 4 инструмента (30–31), вертикальный срез (28–29, 32), удаление upstream (31). Отложено по спеку: `until`/Watcher/subscriptions (P3), `WindowTransaction` с закрытием окон и восстановлением режимов вида (P2 — первые `transient`-рецепты), стеки деревом и `kind` (P2), `confirm` (появится с необратимыми действиями), `--allow-raw-actions` (raw в P1 только читает).
  - **Типы сверены между задачами:** `Verify.poll → (value, ok)`, `RecipeRunner.run(_:env:restorer:)`, `TrackReader.row(number:_:_:)`, `Ledger.record(_:version:date:)`, `Grammar.advertised(ledger:logicMinor:)`, `LogicSession(…, logicMinor:)`.
  - **Известные места для решения по спайкам:** `LocaleTable.en` (строки), `SelectTrack.strategy/restoresArm`, `UndoRedo.titleFreshWithoutOpening`, `LiveUndoTests.newTrackMenu`, статусы в `Grammar.all`, `ReadersTests.testBigHasAllTracks`. Все заполняются из «Решений для P1» (Task 16), а не угадываются.
