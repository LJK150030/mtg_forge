#!/usr/bin/env bash
#
# fix-duplicate-sections.sh — remove DUPLICATE "## <Heading>" sections from vault
# notes, keeping the first. One-time cleanup for notes an earlier run double-added.
#
# Usage:
#   tools/uml-annotate/fix-duplicate-sections.sh <vault-dir> ["## Heading"]
# Default heading is "## Design Description". Set DRY=1 to preview without writing.
#
set -uo pipefail
VAULT="${1:-}"
HEADING="${2:-## Design Description}"
DRY="${DRY:-0}"

[ -n "$VAULT" ] && [ -d "$VAULT" ] || { echo "Usage: $0 <vault-dir> [\"## Heading\"]"; exit 1; }

scanned=0; fixed=0
shopt -s nullglob
for f in "$VAULT"/*.md; do
  scanned=$((scanned + 1))
  cnt="$(awk -v h="$HEADING" '{ l=$0; sub(/\r$/,"",l); gsub(/^[ \t]+|[ \t]+$/,"",l); if (l==h) c++ } END { print c+0 }' "$f")"
  [ "$cnt" -le 1 ] && continue

  if [ "$DRY" = "1" ]; then
    echo "[would fix] $(basename "$f"): remove $((cnt - 1)) duplicate section(s)"
    fixed=$((fixed + 1)); continue
  fi

  tmp="$(mktemp)"
  awk -v h="$HEADING" '
    function trim(s){ sub(/\r$/,"",s); gsub(/^[ \t]+|[ \t]+$/,"",s); return s }
    { lines[n++] = $0 }
    END{
      seen=0; dropping=0; m=0;
      for (i=0; i<n; i++) {
        t = trim(lines[i]);
        if (t == h) {
          if (!seen) { seen=1; dropping=0; out[m++]=lines[i]; continue }
          else { dropping=1; continue }
        }
        if (dropping) {
          if (t ~ /^##[ \t]/) {
            dropping=0;
            while (m>0 && trim(out[m-1])=="") m--;
            out[m++]="";
            out[m++]=lines[i];
          }
          continue;
        }
        out[m++]=lines[i];
      }
      for (i=0; i<m; i++) print out[i];
    }
  ' "$f" > "$tmp" && mv "$tmp" "$f"
  echo "[fixed] $(basename "$f"): removed $((cnt - 1)) duplicate section(s)"
  fixed=$((fixed + 1))
done

echo ""
echo "Scanned $scanned notes; $fixed had duplicate '$HEADING' sections."
