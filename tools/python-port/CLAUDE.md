# Forge Java → Python Port — Conversion Conventions

> Copy this file to the **root of your Python project** (e.g. `pyforge/CLAUDE.md`).
> Every `claude` run in that project then loads it automatically, so both the
> `integrate-python-port` loop and the `/convertclass` command follow these rules.

This repo is an in-progress port of the **Forge** (Magic: the Gathering) Java
codebase to Python. We have two trees in this workspace:

- The **vault** of markdown notes (one per Java class). Each contains the
  **original Java source** plus a **rough first-draft Python transliteration**
  produced in isolation. The draft is a starting point only — treat it as untrusted.
- The Python project itself (e.g. `pyforge_ai/`, `pyforge_game/`): the real,
  integrated target. **This is the source of truth for APIs and style.**

When converting a class, your job is to produce idiomatic Python that is
**logically identical to the Java** and **consistent with the rest of the
Python project** — NOT a literal copy of the markdown draft.

## Naming

- Methods and functions: `camelCase` → `snake_case`
  (`canPlay` → `can_play`, `doTriggerNoCost` → `do_trigger_no_cost`).
- Local variables and parameters: `snake_case` (`aiPlayer` → `ai_player`).
- Class names: keep PascalCase (`AddTurnAi` stays `AddTurnAi`).
- Constants / enum members: keep as-is (`AiPlayDecision.WillPlay`,
  `ZoneType.Battlefield`).
- **Every method call must use the snake_case name that actually exists on the
  target class.** Do not assume — open the class definition and confirm. The
  drafts contain residual camelCase calls (e.g. `ph.getNextTurn()`,
  `p.isOpponentOf(...)`); these are bugs to fix.

## Import path mapping

Java FQNs map to project modules. Verify the exact path by locating the real
file before importing — do not invent module paths.

- `forge.ai.X`            → `pyforge_ai.x` (e.g. `AiAbilityDecision` →
  `pyforge_ai.ai_ability_decision`)
- `forge.game.<sub>.Y`    → `pyforge_game.game.<sub>.y`
- Drop Java-only imports (`org.apache.commons.lang3.StringUtils`,
  `java.util.List`/`Map`) and replace with Python equivalents
  (`str.isnumeric()`, `typing.List`/`Dict`, etc.).

## Logic translation rules

- Preserve control flow and short-circuit semantics exactly.
- `null` → `None`; `== null` / `!= null` → `is None` / `is not None`.
- Constructors stay positional: `AiAbilityDecision(0, AiPlayDecision.CantPlayAi)`.
- Java lambdas → Python `lambda` or comprehensions, matching the predicate.
- `super.method(...)` → `super().method(...)`.
- `.isEmpty()` may exist on project collection types; if the real type is a
  plain Python list, use `if not x:` instead. **Check the actual return type.**
- Java `for (T x : coll)` → `for x in coll:`.

## Known transliteration bugs to watch for

These appeared in the first-draft files; check for them every time:

- Wrong method substituted: `sa.get_trigger().add(...)` where Java is
  `sa.getTargets().add(...)` → must be `sa.get_targets().add(...)`.
- Method *definitions* left in camelCase (`def doTriggerNoCost`).
- Calls left in camelCase on ported objects.

## Verification (run after every file — adjust to your tooling)

```bash
ruff check <file>          # lint + style
mypy <file>                # type consistency against real signatures
pytest -q <relevant tests> # behavior, if tests exist for the class
# residual-camelCase guard: should print nothing
grep -nE '\.[a-z]+[A-Z][A-Za-z]*\(' <file>
```

A file is only "done" when lint and type checks pass and no residual camelCase
method calls remain.
