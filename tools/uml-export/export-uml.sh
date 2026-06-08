#!/usr/bin/env bash
#
# Export Forge's forge-core / forge-game / forge-ai modules to an Obsidian
# vault of Mermaid UML notes (one note per Java type, FQN-keyed, cross-linked).
#
# Usage:
#   tools/uml-export/export-uml.sh [OUTPUT_DIR]
#
#   OUTPUT_DIR  Where notes are written. Default: <repo>/uml-vault
#               Point this straight at an Obsidian vault folder to write in place,
#               e.g.  tools/uml-export/export-uml.sh ~/ObsidianVaults/Forge
#
# All three module source roots are parsed AND added to the symbol solver, so
# cross-module references (forge-ai -> forge-game -> forge-core) resolve to the
# correct fully-qualified names.
#
set -euo pipefail

# Resolve repo root from this script's location (tools/uml-export/ -> repo root).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Output dir: arg 1, or default. Make it absolute (relative resolves vs repo root).
OUT="${1:-$REPO_ROOT/uml-vault}"
case "$OUT" in
  /*) : ;;                       # already absolute
  *)  OUT="$REPO_ROOT/$OUT" ;;
esac

ROOTS=(
  "forge-core/src/main/java"
  "forge-game/src/main/java"
  "forge-ai/src/main/java"
)

# Run from the repo root so the repo's .mvn/maven.config settings path resolves,
# and so the relative module roots below are found.
cd "$REPO_ROOT"

echo "Repo root : $REPO_ROOT"
echo "Output    : $OUT"
echo "Modules   : ${ROOTS[*]}"
echo

# -Xmx: full-project symbol resolution over ~1100 files is memory-hungry.
MAVEN_OPTS="${MAVEN_OPTS:--Xmx3g}" \
  mvn -B -q -f tools/uml-export/pom.xml compile exec:java \
  -Dexec.args="$OUT ${ROOTS[*]}"

echo
echo "Done. Open '$OUT' as an Obsidian vault (or a folder inside one)."
