# Fixtures
- `ax/*.json` — AX snapshots (`AXFixture`). `mini.json` is hand-written; the others are recorded with `logic-ax-dump` from live Logic.
- `projects/` — Logic project copies (`fixture-*.logicx`), gitignored. Live code only touches projects whose name starts with `fixture-`.
Fixtures are static snapshots: they do not emulate Logic behaviour (spec §3).
