#!/usr/bin/env bash
#
# add-python-port.sh — add a "## Python" section (a Python reengineering of the
# Java class) AFTER the "## Source" section of every note in the UML vault.
#
# Run this AFTER add-design-descriptions.sh, so each note already has its UML,
# Relationships, Design Description, and Java source — all of which are fed to
# Claude (headless `claude -p`, Opus 4.8) to produce a faithful Python port.
#
# Consistency: the prompt fixes a deterministic naming rule so that ports of
# different classes line up — a dependency imported here matches the class
# another note defines. Class/method/param names stay identical to Java; every
# type forge.x.y.Name becomes `from forge.x.y.Name import Name`.
#
# Resumable & idempotent: a note that already has a "## Python" heading is
# skipped; a usage-limit stops the loop cleanly (exit 2); transient per-file
# errors are logged and skipped. Progress -> python-port.log in the vault.
#
# Usage:
#   tools/uml-annotate/add-python-port.sh <vault-dir> [model]
#   MAX_FILES=20 tools/uml-annotate/add-python-port.sh <vault-dir>   # sample first
#
set -uo pipefail

VAULT="${1:-}"
MODEL="${2:-claude-opus-4-8}"
MAX_FILES="${MAX_FILES:-0}"

if [ -z "$VAULT" ] || [ ! -d "$VAULT" ]; then
  echo "Usage: $0 <vault-dir> [model]   (set MAX_FILES=N to sample)"; exit 1
fi
command -v claude >/dev/null 2>&1 || { echo "ERROR: 'claude' CLI not on PATH"; exit 1; }
command -v jq     >/dev/null 2>&1 || { echo "ERROR: 'jq' not on PATH"; exit 1; }

LOG="$VAULT/python-port.log"

PROMPT="$(cat <<'EOF'
You are reengineering ONE Java class from the Forge MTG engine into Python. The input (stdin) is
an Obsidian note: YAML frontmatter (fqn/package/module/kind), a Mermaid UML diagram, a Relationships
section of [[wiki-links]] (Extends / Implements / Uses) with fully-qualified names, a Design
Description, and the class's raw Java source.

Produce a faithful Python port. Follow these rules EXACTLY so that ports of different classes stay
mutually consistent (another note may import what this one defines):

NAMING — keep identifiers identical to the Java (do NOT rename to snake_case):
- Class name identical to the Java class. Method, parameter, and field names identical to the Java.
- This module corresponds to the note's `fqn` (e.g. forge.ai.ability.AddPhaseAi -> the Python
  module forge/ai/ability/AddPhaseAi.py defining `class AddPhaseAi`).

IMPORTS / DEPENDENCIES — make them deterministic so files agree:
- For EVERY dependency type with fully-qualified name forge.x.y.Name (taken from the Java `import`
  statements and the Relationships section), import it as exactly:
        from forge.x.y.Name import Name
  i.e. the module path is the type's FQN and the imported symbol is its simple name.
- For Java wildcard imports (e.g. `import forge.ai.*;`), do NOT use a wildcard; import the specific
  symbols actually used — their fully-qualified names are listed in the Relationships section.
- Extend the same supertype(s) shown under Extends. Do NOT stub or redefine dependency classes —
  assume their Python ports already exist at those module paths.
- Map JDK types idiomatically: String->str, boolean->bool, int->int, List<X>->list[X] (or
  typing.List[X]), Map<K,V>->dict[K,V]. If you add type hints, keep them consistent throughout.

FAITHFULNESS:
- Translate method bodies to equivalent Python, preserving control flow and intent.
- Java @Override methods become ordinary Python method overrides (no decorator). Keep constructors
  as __init__. Preserve TODO comments.

OUTPUT:
- Output ONLY the Python source code. No markdown, no code fences, no prose, no explanation.
EOF
)"

LIMIT_RE='hit your (session|weekly|opus|usage) limit|rate.?limit|\(429\)|credit balance is too low|usage limit'
AUTH_RE='not logged in|please run /login|/login|unauthorized|authentication_error|invalid (x-)?api key|(oauth|session|token) (has )?expired|please re-?log ?in'

strip_and_trim() {  # strip a wrapping code fence and leading/trailing blank lines
  awk '
    { lines[n++]=$0 }
    END{
      s=0; e=n-1;
      if (s<=e && lines[s] ~ /^```/)        s++;
      if (e>=s && lines[e] ~ /^```[ \t]*$/) e--;
      while (s<=e && lines[s] ~ /^[ \t]*$/) s++;
      while (e>=s && lines[e] ~ /^[ \t]*$/) e--;
      for (i=s; i<=e; i++) print lines[i];
    }'
}

# Preflight: confirm headless claude works before looping.
pf_err="$(mktemp)"
pf_out="$(printf 'ping' | claude --bare -p "Reply with exactly: OK" --model "$MODEL" --allowedTools "Read" --output-format json 2>"$pf_err")"
pf_code=$?
if [ "$pf_code" -ne 0 ]; then
  echo "Preflight failed: 'claude -p' exited $pf_code and can't run headless yet." >&2
  echo "Details: $(printf '%s %s' "$(cat "$pf_err")" "$pf_out" | tr '\n' ' ' | cut -c1-300)" >&2
  echo "Fixes: run 'claude' once to sign in; try model arg 'opus'; check 'claude --help' for flag names." >&2
  rm -f "$pf_err"; exit 1
fi
rm -f "$pf_err"
echo "Preflight OK - claude headless is working. Starting..."

# Second guard: files already recorded OK in the log are skipped (bash 3.2+).
oklist="$(mktemp)"
if [ -f "$LOG" ]; then
  awk '/[[:space:]]OK[[:space:]]/ && $NF ~ /\.md$/ { print $NF }' "$LOG" | sort -u > "$oklist"
else
  : > "$oklist"
fi

shopt -s nullglob
files=("$VAULT"/*.md)
total=${#files[@]}
idx=0; done_n=0; skip_n=0; err_n=0

for f in "${files[@]}"; do
  idx=$((idx+1))
  base="$(basename "$f")"

  if grep -Fxq "$base" "$oklist"; then skip_n=$((skip_n+1)); continue; fi
  if grep -qE '^##[[:space:]]+Python[[:space:]]*$' "$f"; then
    skip_n=$((skip_n+1)); continue
  fi
  if ! grep -qE '^##[[:space:]]+Source[[:space:]]*$' "$f"; then
    echo "[$idx/$total] skip (no ## Source): $base"; continue
  fi

  errf="$(mktemp)"
  raw="$(claude --bare -p "$PROMPT" --model "$MODEL" --allowedTools "Read" --output-format json < "$f" 2>"$errf")"
  code=$?
  errtxt="$(cat "$errf")"; rm -f "$errf"

  is_err=0
  [ "$code" -ne 0 ] && is_err=1
  if printf '%s' "$raw" | jq -e '.is_error == true' >/dev/null 2>&1; then is_err=1; fi

  if [ "$is_err" -eq 1 ]; then
    if printf '%s\n%s' "$raw" "$errtxt" | grep -qiE "$LIMIT_RE"; then
      echo ""
      echo "Reached your usage limit at: $base"
      echo "Stopped cleanly. Re-run the same command later to resume from here."
      printf '%s  STOP(limit)  %s\n' "$(date -Iseconds)" "$base" >> "$LOG"
      exit 2
    fi
    if printf '%s\n%s' "$raw" "$errtxt" | grep -qiE "$AUTH_RE"; then
      echo ""
      echo "Lost authentication at: $base"
      echo "Session expired. Re-authenticate ('claude setup-token' + CLAUDE_CODE_OAUTH_TOKEN, or run 'claude' and /login), then re-run to resume."
      printf '%s  STOP(auth)  %s\n' "$(date -Iseconds)" "$base" >> "$LOG"
      exit 4
    fi
    echo "[$idx/$total] ERROR (exit $code): $base  $(printf '%s' "$errtxt" | tr '\n' ' ' | cut -c1-200)"
    printf '%s  ERROR  %s  %s\n' "$(date -Iseconds)" "$base" "$(printf '%s' "$errtxt" | tr '\n' ' ')" >> "$LOG"
    err_n=$((err_n+1)); continue
  fi

  code_py="$(printf '%s' "$raw" | jq -r '.result // empty' | strip_and_trim)"
  if [ -z "${code_py//[[:space:]]/}" ]; then
    echo "[$idx/$total] empty result: $base"; err_n=$((err_n+1)); continue
  fi

  # Suggested python path from the note's FQN (filename without .md): a.b.C -> a/b/C.py
  fqn="${base%.md}"
  pypath="$(printf '%s' "$fqn" | tr '.' '/').py"

  # Fence longer than any backtick run in the code (Python virtually never has ```).
  maxticks="$(grep -oE '`+' <<<"$code_py" | awk '{ if (length > m) m = length } END { print m+0 }')"
  n=3; [ "$maxticks" -ge 3 ] && n=$((maxticks + 1))
  fence="$(printf '%*s' "$n" '' | tr ' ' '`')"

  body="$(cat "$f")"   # command substitution strips trailing newlines
  {
    printf '%s\n\n## Python\n`%s`\n\n' "$body" "$pypath"
    printf '%spython\n%s\n%s\n' "$fence" "$code_py" "$fence"
  } > "$f.tmp" && mv "$f.tmp" "$f"

  done_n=$((done_n+1))
  echo "[$idx/$total] done: $base"
  printf '%s  OK     %s\n' "$(date -Iseconds)" "$base" >> "$LOG"
  echo "$base" >> "$oklist"

  if [ "$MAX_FILES" != "0" ] && [ "$done_n" -ge "$MAX_FILES" ]; then
    echo "Reached MAX_FILES=$MAX_FILES for this run. Re-run to continue."; break
  fi
done

rm -f "$oklist"
echo ""
echo "Summary: $done_n written, $skip_n already-done, $err_n errors, of $total notes."
