from __future__ import annotations

from typing import Iterable, TypeVar

# TODO: (pyforge-game.trackable.trackable_object) TrackableObject not yet ported.
#       TrackableCollection should be generic over TrackableObject once available.
# TODO: (pyforge-core.util.collect.f_collection) FCollection not yet ported.
#       Java TrackableCollection extends FCollection<T> — an ordered-set/list hybrid.
#       For now we use a plain list; swap to FCollection once pyforge-core is ready.

T = TypeVar("T")


class TrackableCollection(list[T]):
    """Ordered collection of trackable objects.

    Java: forge.trackable.TrackableCollection<T extends TrackableObject>

    Currently backed by a plain ``list``.  When ``FCollection`` is ported in
    ``pyforge-core``, this should inherit from it instead.
    """

    def __init__(self, items: Iterable[T] | T | None = None) -> None:
        super().__init__()
        if items is None:
            return
        if isinstance(items, Iterable) and not isinstance(items, (str, bytes)):
            self.extend(items)
        else:
            self.append(items)
