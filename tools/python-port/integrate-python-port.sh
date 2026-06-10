#!/usr/bin/env bash
#
# integrate-python-port.sh — STAGE 4. Port each vault note's Java class into the
# LIVE Python project (codebase-aware, verified), in dependency order.
#
# Mirrors integrate-python-port.ps1. The agent runs FROM the project with
# Read/Grep/Glob/Edit/Write/Bash so it opens already-ported dependency files,
# matches their real snake_case signatures, reconciles the target in place, and
# verifies (ruff/mypy/residual-camelCase) until clean. Resumable via the log;
# clean stops on usage limit (2), auth loss (4), missing dependency (5), or a
# failed verification gate (3).
#
# Usage:
#   python build_order.py <vault> > order.txt
#   integrate-python-port.sh <vault> <project-root> <order.txt> [model]
#   MAX_FILES=5 integrate-python-port.sh <vault> <project-root> order.txt
#
set -uo pipefail

VAULT="${1:?usage: <vault> <project-root> <order.txt> [model]}"
PROJECT="${2:?need project root}"
ORDER="${3:?need order.txt from build_order.py}"
MODEL="${4:-claude-opus-4-8}"
MAX_FILES="${MAX_FILES:-0}"
LOG="$VAULT/integrate-port.log"

[ -d "$VAULT" ]   || { echo "no vault: $VAULT"; exit 1; }
[ -d "$PROJECT" ] || { echo "no project: $PROJECT"; exit 1; }
[ -f "$ORDER" ]   || { echo "no order file: $ORDER"; exit 1; }
command -v claude >/dev/null 2>&1 || { echo "ERROR: 'claude' not on PATH"; exit 1; }
command -v jq     >/dev/null 2>&1 || { echo "ERROR: 'jq' not on PATH"; exit 1; }

LIMIT_RE='hit your (session|weekly|opus|usage) limit|rate.?limit|\(429\)|credit balance is too low|usage limit'
AUTH_RE='not logged in|please run /login|/login|unauthorized|authentication_error|invalid (x-)?api key|(oauth|session|token) (has )?expired|please re-?log ?in'

# forge FQN -> live project relative path. ADJUST the three roots to your layout.
fqn_to_path() {
  local fqn="$1" rest file dir cls pkg
  case "$fqn" in
    forge.ai.*)   rest="${fqn#forge.ai.}";   dir="pyforge_ai" ;;
    forge.game.*) rest="${fqn#forge.game.}"; dir="pyforge_game/game" ;;
    forge.*)      rest="${fqn#forge.}";      dir="pyforge_core" ;;
    *)            rest="$fqn";               dir="." ;;
  esac
  cls="${rest##*.}"; pkg="${rest%.*}"; [ "$pkg" = "$rest" ] && pkg=""
  file="$(printf '%s' "$cls" | sed -E 's/([a-z0-9])([A-Z])/\1_\2/g; s/([A-Z]+)([A-Z][a-z])/\1_\2/g' | tr 'A-Z' 'a-z')"
  printf '%s/%s/%s.py\n' "$dir" "${pkg//./\/}" "$file" | sed 's#/\{2,\}#/#g'
}

PROMPT="$(cat <<'EOF'
You are porting ONE Java class from the Forge MTG engine into the LIVE Python project
(your current working directory), which uses snake_case and the pyforge_ai /
pyforge_game / pyforge_core namespaces. You have Read, Grep, Glob, Edit, Write, and
Bash on the project -- USE THEM. This codebase-awareness is the whole point.

stdin is the class's vault note: a UML diagram, a Relationships section of
[[forge.x.y.Name|...]] wiki-links (Extends / Uses), a Design Description, the original
Java source, and a rough first-draft Python port. Treat the draft as UNTRUSTED -- it
was written in isolation and contains wrong method names and leftover camelCase.

TARGET FILE: __DEST__
Create it if missing; if it already exists, treat it as the current draft and
reconcile/update it in place.

Procedure:
1. The Java source in the note is the source of truth for LOGIC. Read it.
2. Read __DEST__ if it exists -- that is the current project draft to update.
3. For the base class (Extends) and every collaborator (Uses), find its REAL
   already-ported file (Grep/Glob by class name; imports map forge.ai.X ->
   pyforge_ai.x, forge.game.<s>.Y -> pyforge_game.game.<s>.y) and read its real
   snake_case method names and signatures. Match the style of sibling files.
   - If a dependency has NOT been ported yet (no real file exists), output exactly
     "MISSING: <its.fully.qualified.Name>" on its own line and STOP. Do not guess.
4. Write/Edit __DEST__ so it is: logically identical to the Java; snake_case for all
   methods/params/locals; class names PascalCase; constants/enums as-is; imports and
   method names that ACTUALLY EXIST in the files you opened (fix draft guesses such as
   get_trigger -> get_targets); null -> None; super().method(...). Idiomatic Python.
5. Verify with Bash and FIX until clean (re-run after each edit):
     ruff check __DEST__
     grep -nE '\.[a-z]+[A-Z][A-Za-z]*\(' __DEST__     (must print nothing)
   Also run `mypy __DEST__` if available and address real signature mismatches.
6. Output a short report: the file written, each method/import you corrected, and any
   missing dependency.
EOF
)"

# preflight (no --bare)
pf_err="$(mktemp)"
printf 'ping' | claude -p "Reply with exactly: OK" --model "$MODEL" --allowedTools "Read" --output-format json >/dev/null 2>"$pf_err" \
  || { echo "Preflight failed: $(tr '\n' ' ' <"$pf_err" | cut -c1-300)"; echo "Fix auth ('claude setup-token' + CLAUDE_CODE_OAUTH_TOKEN, or 'claude' then /login), then re-run."; rm -f "$pf_err"; exit 1; }
rm -f "$pf_err"
have_ruff=0; command -v ruff >/dev/null 2>&1 && have_ruff=1
echo "Preflight OK. Project: $PROJECT  (final ruff gate: $([ $have_ruff -eq 1 ] && echo on || echo 'off - ruff not found'))"

oklist="$(mktemp)"
[ -f "$LOG" ] && awk '/[[:space:]]OK[[:space:]]/ {print $NF}' "$LOG" | sort -u > "$oklist" || : > "$oklist"

mapfile -t fqns < <(grep -vE '^\s*(#|$)' "$ORDER" | sed 's/[[:space:]]*$//')
total=${#fqns[@]}; idx=0; done_n=0; skip_n=0; err_n=0

for fqn in "${fqns[@]}"; do
  idx=$((idx+1))
  grep -Fxq "$fqn" "$oklist" && { skip_n=$((skip_n+1)); continue; }

  note="$VAULT/$fqn.md"
  [ -f "$note" ] || { echo "[$idx/$total] no note for $fqn"; continue; }
  rel="$(fqn_to_path "$fqn")"
  prompt="${PROMPT//__DEST__/$rel}"

  errf="$(mktemp)"
  raw="$(cd "$PROJECT" && claude -p "$prompt" --model "$MODEL" \
          --allowedTools "Read,Grep,Glob,Edit,Write,Bash" --output-format json < "$note" 2>"$errf")"
  code=$?; errtxt="$(cat "$errf")"; rm -f "$errf"

  if [ "$code" -ne 0 ] || printf '%s' "$raw" | jq -e '.is_error==true' >/dev/null 2>&1; then
    if printf '%s\n%s' "$raw" "$errtxt" | grep -qiE "$LIMIT_RE"; then
      echo; echo "Usage limit at: $fqn - re-run to resume."
      printf '%s  STOP(limit)  %s\n' "$(date -Iseconds)" "$fqn" >> "$LOG"; exit 2; fi
    if printf '%s\n%s' "$raw" "$errtxt" | grep -qiE "$AUTH_RE"; then
      echo; echo "Auth lost at: $fqn - re-authenticate, then re-run."
      printf '%s  STOP(auth)  %s\n' "$(date -Iseconds)" "$fqn" >> "$LOG"; exit 4; fi
    echo "[$idx/$total] ERROR: $fqn"
    printf '%s  ERROR  %s\n' "$(date -Iseconds)" "$fqn" >> "$LOG"; err_n=$((err_n+1)); continue
  fi

  result="$(printf '%s' "$raw" | jq -r '.result // empty')"
  if printf '%s' "$result" | grep -qE '^[[:space:]]*MISSING:'; then
    miss="$(printf '%s' "$result" | grep -E '^[[:space:]]*MISSING:' | head -1)"
    echo "[$idx/$total] $fqn needs a dependency ported first: $miss  (check ordering)"
    printf '%s  MISSING  %s  %s\n' "$(date -Iseconds)" "$fqn" "$miss" >> "$LOG"; exit 5
  fi

  dest="$PROJECT/$rel"
  [ -s "$dest" ] || { echo "[$idx/$total] agent produced no file: $rel"; printf '%s  ERROR  %s  (no file)\n' "$(date -Iseconds)" "$fqn" >> "$LOG"; err_n=$((err_n+1)); continue; }

  if [ $have_ruff -eq 1 ] && ! ( cd "$PROJECT" && ruff check "$rel" >/dev/null 2>&1 ); then
    echo "[$idx/$total] VERIFY FAILED (ruff): $rel - stopping for review."
    printf '%s  VERIFY  %s\n' "$(date -Iseconds)" "$fqn" >> "$LOG"; exit 3
  fi

  done_n=$((done_n+1)); echo "[$idx/$total] done: $fqn -> $rel"
  printf '%s  OK     %s\n' "$(date -Iseconds)" "$fqn" >> "$LOG"; echo "$fqn" >> "$oklist"
  [ "$MAX_FILES" != "0" ] && [ "$done_n" -ge "$MAX_FILES" ] && { echo "MAX_FILES reached."; break; }
done

rm -f "$oklist"
echo; echo "Summary: $done_n ported, $skip_n skipped, $err_n errors, of $total classes."
