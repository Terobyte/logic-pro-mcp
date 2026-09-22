# bugs.md

## Hunt 2026-09-21 — LogicKit Tasks 1–4 (subagents unavailable; senior hunt + red tests)

### B01 — AXStats.message accepts negative counts — MAJOR — fixed
- class: data-integrity · location: Sources/LogicKit/Platform/LiveAXNode.swift:11 · found-by: senior
- symptom: AX message budget counter can decrease or go negative
- trigger: `AXStats().message(3); message(-2)` then read `messages`
- expected vs actual: counter must not decrease (only non-negative increments); actual `messages == 1`
- test: Tests/LogicKitTests/BughuntTests.swift::test_B01_AXStatsMessageMustNotDecrease
- history: reported 09-21 → proven red (`messages` 1 ≠ 3) → fixed 09-21 (`message` ignores n ≤ 0); green, assertion untouched

### B02 — firstDescendant ignores maxDepth=0 vs “search depth zero” — MINOR — reported
- class: edge-case · location: Sources/LogicKit/Platform/AXQuery.swift:49-62
- symptom: with `maxDepth=0`, no nodes searched (immediate nil)
- trigger: any match on direct child with maxDepth 0
- expected vs actual: ambiguous API; current nil — parked until probe needs it
- test: (not written — API intent unclear)
