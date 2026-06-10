#!/usr/bin/env python3
"""build_order.py — dependency-ordered list of classes (FQNs) to port.

Reads each markdown note's ``fqn:`` and its Relationships wiki-links, then
topologically sorts so that everything a class Extends/Uses is ported before it.
Prints one **fully-qualified name** per line to stdout (pipe to order.txt):

    python build_order.py path/to/vault > order.txt

Design notes (vs a naive version):
- Nodes and edges are keyed by **FQN**, taken from the wiki-link *target*
  (``[[forge.ai.SpellAbilityAi|...]]``), not the display name — Forge has many
  duplicate simple names (``Reader`` x6, ``Type``, ...), so simple names would
  mis-order.
- Iterative Kahn's algorithm — no recursion limit problem on ~1,300 nodes with
  deep chains.
- Deterministic: ties broken alphabetically, so the same vault always yields the
  same order.
- Dependencies without their own note (external / already-ported / stdlib-like)
  are treated as already satisfied.
- Cycles are reported on stderr and emitted last in sorted order (broken
  arbitrarily) so the run can still proceed and you can eyeball them.
"""
import re
import sys
import heapq
from pathlib import Path
from collections import defaultdict

FQN_RE = re.compile(r"^fqn:\s*(.+)$", re.M)
# Capture the wiki-link TARGET (the FQN before '|'), e.g. [[forge.ai.X|X]] -> forge.ai.X
LINK_RE = re.compile(r"\[\[([^|\]]+)\|")


def parse(md: Path):
    """Return (fqn, deps) for a note, or (None, _) if it has no ``fqn:`` line
    (e.g. CLAUDE.md or a slash-command doc that isn't a class note)."""
    text = md.read_text(encoding="utf-8", errors="replace")
    m = FQN_RE.search(text)
    if not m:
        return None, set()
    fqn = m.group(1).strip()  # .strip() drops any trailing \r
    deps = {d.strip() for d in LINK_RE.findall(text)}
    return fqn, deps


def main(root: str) -> int:
    files = sorted(Path(root).rglob("*.md"))
    deps_of = {}
    for f in files:
        fqn, deps = parse(f)
        if fqn:
            deps_of[fqn] = deps
    known = set(deps_of)
    # Keep only deps that have their own note; drop self-edges.
    deps_of = {n: {d for d in ds if d in known and d != n} for n, ds in deps_of.items()}

    indeg = {n: len(ds) for n, ds in deps_of.items()}
    dependents = defaultdict(set)
    for n, ds in deps_of.items():
        for d in ds:
            dependents[d].add(n)

    # Kahn's algorithm with a min-heap for deterministic, dependency-first output.
    ready = [n for n, k in indeg.items() if k == 0]
    heapq.heapify(ready)
    order, seen = [], set()
    while ready:
        n = heapq.heappop(ready)
        order.append(n)
        seen.add(n)
        for m in sorted(dependents[n]):
            indeg[m] -= 1
            if indeg[m] == 0:
                heapq.heappush(ready, m)

    leftover = [n for n in sorted(known) if n not in seen]
    if leftover:
        print(f"# {len(leftover)} class(es) in dependency cycles "
              f"(broken arbitrarily, emitted last):", file=sys.stderr)
        for n in leftover:
            print(f"#   {n}", file=sys.stderr)
        order.extend(leftover)

    sys.stdout.write("\n".join(order) + ("\n" if order else ""))
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1] if len(sys.argv) > 1 else "."))
