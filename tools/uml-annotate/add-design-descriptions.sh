#!/usr/bin/env bash
#
# add-design-descriptions.sh — annotate an Obsidian UML vault with design descriptions.
#
# For every <type>.md note produced by tools/uml-export, this asks Claude Code
# (headless `claude -p`, Opus 4.8) to read the note (its UML diagram, Relationships,
# and embedded Java source) and write a short Software Design Description, which is
# inserted as a new "## Design Description" section immediately BEFORE "## Source"
# (i.e. between Relationships and Source).
#
# Resumable & idempotent:
#   * A note that already has a "## Design Description" heading is skipped, so you
#     can stop and re-run freely — it picks up where it left off.
#   * If you hit your Claude usage limit, the loop stops cleanly (exit 2) and tells
#     you the note it stopped on. Re-run the same command later to resume.
#
# Usage:
#   tools/uml-annotate/add-design-descriptions.sh <vault-dir> [model]
#   MAX_FILES=20 tools/uml-annotate/add-design-descriptions.sh <vault-dir>   # sample first
#
set -uo pipefail

VAULT="${1:-}"
MODEL="${2:-claude-opus-4-8}"
MAX_FILES="${MAX_FILES:-0}"   # 0 = process all; e.g. 20 to sample

if [ -z "$VAULT" ] || [ ! -d "$VAULT" ]; then
  echo "Usage: $0 <vault-dir> [model]   (set MAX_FILES=N to sample)"; exit 1
fi
command -v claude >/dev/null 2>&1 || { echo "ERROR: 'claude' CLI not on PATH (install Claude Code)"; exit 1; }
command -v jq     >/dev/null 2>&1 || { echo "ERROR: 'jq' not on PATH"; exit 1; }

LOG="$VAULT/design-descriptions.log"

PROMPT="$(cat <<'EOF'
You are writing a Software Design Description for a Java class in the Forge MTG engine.
The input (stdin) is an Obsidian note documenting one class: a Mermaid UML class diagram,
a Relationships section of [[wiki-links]], and the class's raw Java source.

Using the UML, the relationships, and the source, write a concise Software Design Description
(1-2 short paragraphs, ~60-150 words) covering: the class's purpose and responsibility; its role
relative to its supertype/interfaces and the types it collaborates with; and any notable design
intent visible in the code.

Output ONLY the description prose: no heading, no preamble such as "Here is", no bullet list,
no code fences.
EOF
)"

# Matches the messages Claude Code emits when a usage/rate/credit limit is hit.
LIMIT_RE='hit your (session|weekly|opus|usage) limit|rate.?limit|\(429\)|credit balance is too low|usage limit'

strip_and_trim() {  # strip a wrapping code fence and leading/trailing blank lines
  awk '
    { lines[n++]=$0 }
    END{
      s=0; e=n-1;
      if (s<=e && lines[s] ~ /^```/)           s++;
      if (e>=s && lines[e] ~ /^```[ \t]*$/)    e--;
      while (s<=e && lines[s] ~ /^[ \t]*$/)    s++;
      while (e>=s && lines[e] ~ /^[ \t]*$/)    e--;
      for (i=s; i<=e; i++) print lines[i];
    }'
}

shopt -s nullglob
files=("$VAULT"/*.md)
total=${#files[@]}
idx=0; done_n=0; skip_n=0; err_n=0

for f in "${files[@]}"; do
  idx=$((idx+1))
  base="$(basename "$f")"

  if grep -qE '^##[[:space:]]+Design Description[[:space:]]*$' "$f"; then
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
    echo "[$idx/$total] ERROR (exit $code): $base  $(printf '%s' "$errtxt" | tr '\n' ' ' | cut -c1-160)"
    printf '%s  ERROR  %s  %s\n' "$(date -Iseconds)" "$base" "$(printf '%s' "$errtxt" | tr '\n' ' ')" >> "$LOG"
    err_n=$((err_n+1)); continue
  fi

  desc="$(printf '%s' "$raw" | jq -r '.result // empty' | strip_and_trim)"
  if [ -z "${desc//[[:space:]]/}" ]; then
    echo "[$idx/$total] empty result: $base"
    err_n=$((err_n+1)); continue
  fi

  # Insert "## Design Description" + prose immediately before the first "## Source".
  descf="$(mktemp)"; printf '%s\n' "$desc" > "$descf"
  outf="$(mktemp)"
  awk -v df="$descf" '
    function slurp(file,   s,l){ while ((getline l < file) > 0) s = s l "\n"; close(file); return s }
    BEGIN { d = slurp(df) }
    (!ins && /^##[ \t]+Source[ \t]*$/) { printf "## Design Description\n\n%s\n", d; ins=1 }
    { print }
  ' "$f" > "$outf"
  mv "$outf" "$f"; rm -f "$descf"

  done_n=$((done_n+1))
  echo "[$idx/$total] done: $base"
  printf '%s  OK     %s\n' "$(date -Iseconds)" "$base" >> "$LOG"

  if [ "$MAX_FILES" != "0" ] && [ "$done_n" -ge "$MAX_FILES" ]; then
    echo "Reached MAX_FILES=$MAX_FILES for this run. Re-run to continue."; break
  fi
done

echo ""
echo "Summary: $done_n written, $skip_n already-done, $err_n errors, of $total notes."
