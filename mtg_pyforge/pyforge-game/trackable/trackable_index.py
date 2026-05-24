from __future__ import annotations

from typing import TypeVar

# TODO: (pyforge-game.trackable.trackable_object) TrackableObject not yet ported.
#       TrackableIndex should be generic over TrackableObject once available.

T = TypeVar("T")


class TrackableIndex(dict[int, T]):
    """Maps integer ids to trackable objects.

    Java: forge.trackable.TrackableIndex<T extends TrackableObject>

    A thin wrapper around ``dict[int, T]``.
    """
