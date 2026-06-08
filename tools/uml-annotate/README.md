# Design-description annotator

Adds a **`## Design Description`** section (between `## Relationships` and
`## Source`) to every note produced by [`tools/uml-export`](../uml-export), using
**Claude Code in headless mode** (`claude -p`, Opus 4.8) — one note per call.

Each note is self-contained (UML diagram + relationships + embedded Java source),
so each call is an independent one-shot. The script pipes the note to `claude -p`,
gets back a short design description, and inserts it.

## Prerequisites

- **Claude Code** installed and signed in (`claude` on your PATH). On Windows it
  works directly in PowerShell — no WSL needed.
- Opus 4.8 access on your Claude plan (the default `-Model claude-opus-4-8`).
- The exported vault (run `tools/uml-export` first).

## Run

PowerShell (Windows):

```powershell
# Sample ~20 first to check quality, then run the rest:
pwsh tools/uml-annotate/add-design-descriptions.ps1 -VaultPath "G:\My Files\School\sprint 2026\obsidian_valuts\mtg_forge_conversion" -Max 20

# Full run (re-runnable; skips notes already done):
pwsh tools/uml-annotate/add-design-descriptions.ps1 -VaultPath "G:\My Files\School\sprint 2026\obsidian_valuts\mtg_forge_conversion"
```

Bash (macOS/Linux/Git Bash):

```bash
MAX_FILES=20 tools/uml-annotate/add-design-descriptions.sh "/path/to/vault"   # sample
tools/uml-annotate/add-design-descriptions.sh "/path/to/vault"                # full run
```

## Resumable by design

This is built for running across ~1,300 notes against a personal usage limit:

- **Idempotent** — a note that already has `## Design Description` is skipped, so
  re-running resumes exactly where you left off. No state file to manage.
- **Clean stop on usage limit** — if Claude reports a session/weekly/Opus/credit
  limit, the loop stops immediately (exit code **2**), names the note it stopped
  on, and writes nothing for it. Re-run the same command later to continue.
- **Transient errors don't halt the run** — a one-off failure on a single note is
  logged and skipped; the loop keeps going.
- **Progress log** — every action is appended to `design-descriptions.log` in the
  vault (`OK` / `ERROR` / `STOP(limit)` with timestamps).

## How it works (and how to tweak it)

- Runs `claude --bare -p "<prompt>" --model claude-opus-4-8 --allowedTools "Read" --output-format json`,
  feeding the note on **stdin**. `--bare` skips CLAUDE.md/hooks/skills/MCP for a
  clean, identical run per file.
- The **prompt** (edit it inside the script) asks for a 1–2 paragraph description
  of the class's purpose, its role vs. its supertype/collaborators, and design
  intent visible in the source.
- Insertion is done by the script (not the model), so placement is exact and the
  rest of the note is never touched.
- `-Model` / second bash arg changes the model (e.g. `-Model sonnet` to spot-check
  a cheaper pass). `-Max` / `MAX_FILES` caps how many to do this run.

> Note: descriptions are written from each note in isolation. The note already
> lists its relationships and full source, which is enough for a solid per-class
> description. If you want the model to also open directly-linked notes for deeper
> context, allow it in the prompt and keep `--allowedTools "Read"` (it will read
> `<fqn>.md` siblings in the vault) — at the cost of more tokens per note.
