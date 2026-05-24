from __future__ import annotations

from typing import Protocol, runtime_checkable


@runtime_checkable
class GameCommand(Protocol):
    """Callback interface for game actions (Java: forge.GameCommand)."""

    def run(self) -> None: ...


def blank_command() -> GameCommand:
    """Return a no-op GameCommand, equivalent to Java GameCommand.BLANK."""

    class _Blank:
        def run(self) -> None:
            pass

    return _Blank()


BLANK: GameCommand = blank_command()
