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
