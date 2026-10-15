#!/bin/bash
# Run Roomer with a scripted playtest driving it.
#
#   playtests/run.sh playtests/soak.lua [path/to/petrichor64]
#
# Copies the game to a temp dir, adds the test as scripts/zz_test.lua (it
# defines TEST_HOOK(dt), which main.lua calls every frame), and runs it.
# Watch the console output for its print()s and for any Lua errors.
set -e
here="$(cd "$(dirname "$0")/.." && pwd)"
test="$1"
engine="${2:-petrichor64}"
tmp="$(mktemp -d)"
cp -r "$here/scripts" "$here/assets" "$tmp/"
cp "$test" "$tmp/scripts/zz_test.lua"
"$engine" "$tmp"
