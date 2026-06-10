# Stage 4: integrate the Python port into the live project

The annotation passes (`tools/uml-annotate`) gave every note a `## Python` *draft*
written in isolation. This stage takes each class and **reconciles it into the real
Python project** — codebase-aware (the agent opens already-ported dependency files
and matches their real `snake_case` signatures), in dependency order, and verified.

This is where Claude Code earns its keep over a plain API call: the agent uses
**Read/Grep/Glob** to look up the actual project APIs and **Edit/Bash** to update the
file and run `ruff`/`mypy` until it's clean — exactly the cross-file work the
isolated draft couldn't do.

## The pipeline

```
build_order.py  →  order.txt  →  integrate-python-port.ps1  →  pyforge_*/**.py
 (topological)     (FQNs)         (codebase-aware + verify)      (live project)
```

1. **Order the work** so a class's dependencies are ported before it:

   ```powershell
   python tools\python-port\build_order.py "G:\...\mtg_forge_conversion" > order.txt
   ```

   FQN-keyed (collision-proof), iterative (no recursion limit at ~1,300 nodes),
   deterministic. Dependency cycles are reported on stderr and emitted last.

2. **Integrate** (sample a few first, then drop `-Max`):

   ```powershell
   pwsh tools\python-port\integrate-python-port.ps1 `
     -VaultPath "G:\...\mtg_forge_conversion" `
     -ProjectRoot "C:\code\pyforge" `
     -OrderFile order.txt -Max 5
   ```

   For each FQN it runs `claude -p` **from the project** with Read/Grep/Glob/Edit/
   Write/Bash, feeding the note on stdin and telling the agent the target path. The
   agent reconciles (or creates) the file, then runs `ruff`/`mypy`/a residual-
   camelCase grep and fixes until clean. The harness then re-runs `ruff` as a final
   gate.

   Bash twin: `integrate-python-port.sh <vault> <project> order.txt`.

## Run it on Claude Code **desktop**, not the web

This stage touches three local things at once — your Obsidian vault (`G:\`), your
Python project, and the `claude` CLI — and the agent needs live filesystem
read/write across the project. The **desktop/CLI** does that directly. Claude Code
on the **web** runs in a cloud sandbox tied to a single GitHub repo, so you'd have to
push *both* the vault and the Python project to GitHub and reconcile branches — much
more friction for no benefit here. (The earlier passes were desktop too, for the
same reason.)

## Resumable & safe

Same spine as the annotation passes: a preflight `claude -p`, resume via
`integrate-port.log` (a class logged `OK` is skipped), and clean exits you can just
re-run from:

| exit | meaning |
|------|---------|
| 2 | usage limit hit — re-run later to resume |
| 4 | session expired — re-authenticate, then re-run |
| 5 | a dependency isn't ported yet (`MISSING:`) — check ordering, port it first |
| 3 | `ruff` gate failed on a file — fix/inspect, then re-run |

## Adjust to your project

- **`fqn_to_path` / `Convert-FqnToPath`** map `forge.*` FQNs to your real layout
  (`forge.ai.ability.AddTurnAi` → `pyforge_ai/ability/add_turn_ai.py`). Edit the
  three roots in the script if your package names differ.
- **`CLAUDE.md`** (in this folder) holds the conversion conventions — naming, import
  mapping, logic rules, known draft bugs, and the verification commands. **Copy it to
  the root of your Python project** so every `claude` run in that project picks it up
  automatically.
- **`convertclass.md`** is a Claude Code **slash command** for doing one class
  interactively (great for spot-fixes or eyeballing the procedure). **Copy it to
  `.claude/commands/convertclass.md` in your Python project**, then run
  `/convertclass forge.ai.ability.AddTurnAi` in an interactive `claude` session. The
  loop above is the bulk version of the same procedure.

## Two ways to drive it

- **Bulk:** `integrate-python-port.ps1` over `order.txt` — unattended, resumable,
  dependency-ordered. Best for the full ~1,300 classes.
- **Interactive:** `/convertclass <fqn>` per class — when you want to watch the agent
  reason, or fix a specific file the gate flagged.
