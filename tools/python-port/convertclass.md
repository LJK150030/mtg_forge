---
description: Reconcile one Forge class's markdown draft into the real Python project, verifying every API against actual class definitions.
argument-hint: [fully-qualified name, class name, or path to the class's markdown note]
allowed-tools: Read, Grep, Glob, Edit, Write, Bash
---

# Convert one class: $ARGUMENTS

> Copy this file to `.claude/commands/convertclass.md` in your Python project, then
> run `/convertclass forge.ai.ability.AddTurnAi` in an interactive `claude` session.
> This is the interactive equivalent of one iteration of `integrate-python-port`.

Follow this procedure exactly. Do not skip the verification step.

1. **Locate the markdown note.** `$ARGUMENTS` may be a fully-qualified name
   (`forge.ai.ability.AddTurnAi`), a bare class name, or a path. Notes are named by
   FQN (`forge.ai.ability.AddTurnAi.md`). If given a bare name, search the vault for
   the note whose `fqn:` frontmatter ends in that class. Read it — it contains the
   original Java source and a rough Python draft.

2. **Read the relationships.** From the note's "Relationships" section, note
   everything under `Extends:` and `Uses:` (the `[[forge.x.y.Name|...]]` wiki-links).
   These are the dependencies you must reconcile against.

3. **Open the REAL dependencies in the Python project.** For the base class and each
   used type, find the actual ported Python file (Grep/Glob; `forge.ai.X` →
   `pyforge_ai.x`, `forge.game.<s>.Y` → `pyforge_game.game.<s>.y`) and read its real
   method signatures. If a dependency has not been ported yet, STOP and report it —
   do not guess its API. (Convert dependencies first; `build_order.py` orders them.)

4. **Locate the target file** in the Python project (e.g.
   `pyforge_ai/ability/add_turn_ai.py`). If a first-draft already exists there, treat
   it as the current state to update; if none exists, create one following the
   package's layout.

5. **Reconcile.** Rewrite the target so it is:
   - logically identical to the Java in the note,
   - snake_case for all methods/vars/params (class names stay PascalCase),
   - using import paths and method names that ACTUALLY EXIST in the real dependency
     files you opened in step 3,
   - consistent in style with sibling files already in the same package.
   Fix any bug where the draft called the wrong method or kept camelCase.

6. **Verify.** Run the checks from CLAUDE.md (ruff, mypy, the residual-camelCase
   grep, and any relevant pytest). Fix anything that fails and re-run until clean.

7. **Report** a short summary: the file written, every method/import you corrected
   against the real API, and any dependency that was missing.
