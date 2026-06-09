# Vault annotators (Claude Code, headless)

Two passes that enrich every note produced by [`tools/uml-export`](../uml-export),
each using **Claude Code in headless mode** (`claude -p`, Opus 4.8), one note per
call. Each note is self-contained (UML + relationships + embedded Java source), so
every call is an independent one-shot — the script pipes the note to `claude -p`
and inserts the result.

Run them in order:

| Pass | Script | Adds | Where |
|------|--------|------|-------|
| 1 | `add-design-descriptions.ps1` / `.sh` | `## Design Description` | between Relationships and Source |
| 2 | `add-python-port.ps1` / `.sh` | `## Python` (a Python reengineering of the Java) | after Source |

Both share the same engine: resumable, idempotent, usage-limit-aware (see below).
Pass 2 reads the whole note — including the Design Description from pass 1 — so
run pass 1 first.

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

Then pass 2 (same flags, run after pass 1 finishes):

```powershell
pwsh tools/uml-annotate/add-python-port.ps1 -VaultPath "G:\My Files\School\sprint 2026\obsidian_valuts\mtg_forge_conversion" -Max 20
pwsh tools/uml-annotate/add-python-port.ps1 -VaultPath "G:\My Files\School\sprint 2026\obsidian_valuts\mtg_forge_conversion"
```

Bash (macOS/Linux/Git Bash):

```bash
MAX_FILES=20 tools/uml-annotate/add-design-descriptions.sh "/path/to/vault"   # sample
tools/uml-annotate/add-design-descriptions.sh "/path/to/vault"                # full run
# then:
MAX_FILES=20 tools/uml-annotate/add-python-port.sh "/path/to/vault"
tools/uml-annotate/add-python-port.sh "/path/to/vault"
```

## Pass 2: the Python port

`add-python-port.*` appends a **`## Python`** section after `## Source` containing
a Python reengineering of the Java class. The hard part is **consistency** — a
dependency imported in one note must match the class another note defines, even
though files are processed independently. The prompt fixes a deterministic rule so
they line up by construction:

- **Identifiers are preserved exactly** — same class, method, parameter, and field
  names as the Java (not snake_cased), so cross-references are stable.
- **Imports mirror fully-qualified names** — every type `forge.x.y.Name` (from the
  Java imports and the Relationships section) becomes `from forge.x.y.Name import
  Name`. The class extends the same supertype shown under **Extends**.
- The section is labelled with a suggested path derived from the note's FQN, e.g.
  `forge/ai/ability/AddPhaseAi.py`, so you can later split the `## Python` blocks
  into a real Python package.

Want PEP8 (`snake_case` methods) instead of Java-identical names? It's a one-line
change to the NAMING rule in the prompt — but identical names maximise cross-file
consistency, which is why it's the default.

## Determinism & fixing duplicates

The "already done?" decision is deterministic and **line-ending-agnostic**: a note
is processed only if it does **not** already contain the section *and* it is **not**
recorded `OK` in the log. (An earlier version used a `^...$` regex that silently
failed on CRLF files, so reruns re-appended sections — fixed.)

If a previous run left duplicate sections, clean them up (keeps the first, drops the
rest; preview with `-WhatIf` / `DRY=1`):

```powershell
pwsh tools/uml-annotate/fix-duplicate-sections.ps1 -VaultPath "G:\...\mtg_forge_conversion" -WhatIf
pwsh tools/uml-annotate/fix-duplicate-sections.ps1 -VaultPath "G:\...\mtg_forge_conversion"
pwsh tools/uml-annotate/fix-duplicate-sections.ps1 -VaultPath "G:\...\mtg_forge_conversion" -Heading "## Python"
```

```bash
DRY=1 tools/uml-annotate/fix-duplicate-sections.sh "/path/to/vault"
tools/uml-annotate/fix-duplicate-sections.sh "/path/to/vault"
```

## Resumable by design

This is built for running across ~1,300 notes against a personal usage limit:

- **Idempotent** — a note that already has the section it would add (`## Design
  Description` for pass 1, `## Python` for pass 2) is skipped, so re-running
  resumes exactly where you left off. No state file to manage, and **no duplicate
  sections** are ever written.
- **Preflight** — before the loop, each script runs one tiny `claude -p` to confirm
  headless mode works (signed in, valid model/flags). If not, it stops immediately
  with the real reason instead of erroring on all ~1,300 notes.
- **Clean stop on usage limit** — if Claude reports a session/weekly/Opus/credit
  limit, the loop stops immediately (exit code **2**), names the note it stopped
  on, and writes nothing for it. Re-run the same command later to continue.
- **Transient errors don't halt the run** — a one-off failure on a single note is
  logged and skipped; the loop keeps going.
- **Progress log** — every action is appended to a log in the vault
  (`design-descriptions.log` / `python-port.log`) with `OK` / `ERROR` /
  `STOP(limit)` and timestamps.

## How it works (and how to tweak it)

- Runs `claude -p "<prompt>" --model claude-opus-4-8 --allowedTools "Read" --output-format json`,
  feeding the note on **stdin**. (`--bare` was removed: in some setups it bypasses
  the cached-credential/refresh path and reports "Not logged in" even when
  `claude -p` works normally.)
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
