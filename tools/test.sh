#!/bin/sh
set -eu

root=$(CDPATH='' cd -- "$(dirname "$0")/.." && pwd)
zap=${ZAP:-zap}

# Scaffold phase: no library sources yet. The first-slice PR (see the Tier-1
# epic) adds src/*.zap and tests/*.zap, at which point the full suite below runs.
# Until then, exit cleanly so CI is green on the scaffold.
if [ -z "$(find "$root/src" -name '*.zap' -print -quit 2>/dev/null)" ]; then
	echo "prometheus: no .zap sources yet (scaffold phase) — skipping tests."
	exit 0
fi

scratch=$(mktemp -d)
trap 'rm -rf "$scratch"' EXIT
trap 'exit 1' HUP INT TERM
export ZAP_CACHE="$scratch/cache"
unset ZAP_ZENV

"$zap" fmt --check "$root/src" "$root/tests"

# Exercise the public API from a consumer with prometheus installed as a dependency.
cd "$scratch"
ln -s "$root" prometheus
cat > zap.toml <<'MANIFEST'
[package]
name = "prometheus_tests"
version = "0.0.0"

[dependencies]
prometheus = { path = "prometheus" }
MANIFEST
"$zap" zenv create --no-venv
cp -R "$root/tests" tests
ZAP_ZENV="$scratch/zenv" "$zap" test tests/
