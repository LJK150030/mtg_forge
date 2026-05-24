from __future__ import annotations

from typing import Protocol, runtime_checkable


@runtime_checkable
class IIdentifiable(Protocol):
    """Something that has a unique integer id (Java: forge.game.IIdentifiable)."""

    @property
    def id(self) -> int: ...
