---
aliases:
  - FCollectionView
tags:
  - java/interface
  - module/forge-core
  - pkg/forge/util/collect
fqn: forge.util.collect.FCollectionView
package: forge.util.collect
module: forge-core
kind: Interface
---

# FCollectionView

**Package:** `forge.util.collect` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Interface

```mermaid
classDiagram
    class FCollectionView {
        <<interface>>
        ~isEmpty() boolean
        ~size() int
        ~get(int index) T
        ~getFirst() T
        ~getLast() T
        ~indexOf(Object o) int
        ~lastIndexOf(Object o) int
        ~contains(Object o) boolean
        ~subList(int fromIndex, int toIndex) List~T~
        ~threadSafeIterable() Iterable~T~
        ~get(T obj) T
        ~stream() Stream~T~
        ~anyMatch(Predicate~T~ test) boolean
        ~allMatch(Predicate~T~ test) boolean
    }
    FCollectionView --|> Collection : extends
```

## Design Description

Read-only interface exposing safe, query-only access to an `FCollection`, parameterized over its element type `T`. It extends `java.util.Collection<T>` but deliberately omits any mutating operations, surfacing only positional reads (`get`, `getFirst`, `getLast`), search operations (`indexOf`, `lastIndexOf`, `contains`), range views (`subList`), and functional queries (`stream`, `anyMatch`, `allMatch`).

The design intent is to publish a collection's contents to clients without exposing its mutability, letting `FCollection` serve itself wherever read-only views are needed. Notable touches include `getFirst`/`getLast` that throw `NoSuchElementException` on empty collections, an identity-style `get(T obj)` for retrieving the stored equivalent of a candidate, and `threadSafeIterable`, which returns a snapshot Iterable decoupled from the live collection so concurrent iteration is safe and read-only.

## Source
`forge-core/src/main/java/forge/util/collect/FCollectionView.java`

```java
package forge.util.collect;

import java.util.Collection;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.function.Predicate;
import java.util.stream.Stream;

/**
 * Read-only interface to an {@link FCollection}.
 */
public interface FCollectionView<T> extends Collection<T> {
    /**
     * @see Collection#isEmpty()
     */
    boolean isEmpty();

    /**
     * @see Collection#size()
     */
    int size();

    /**
     * @see List#get(int)
     */
    T get(int index);

    /**
     * Get the first object in this {@link FCollectionView}.
     *
     * @throws NoSuchElementException
     *             if the collection is empty.
     */
    T getFirst();

    /**
     * Get the last object in this {@link FCollectionView}.
     *
     * @throws NoSuchElementException
     *             if the collection is empty.
     */
    T getLast();

    /**
     * @see List#indexOf(Object)
     */
    int indexOf(Object o);

    /**
     * @see List#lastIndexOf(Object)
     */
    int lastIndexOf(Object o);

    /**
     * @see Collection#contains(Object)
     */
    boolean contains(Object o);

    /**
     * Return an unmodifiable list with shallow copies of the elements in a
     * particular range of this collection.
     *
     * @param fromIndex
     *            the first index to appear in the list.
     * @param toIndex
     *            the lowest index not to appear in the list.
     * @return a sublist.
     */
    List<T> subList(int fromIndex, int toIndex);

    /**
     * Get a thread-safe {@link Iterable}, ie. one that is not backed by this
     * collection, but rather represents the state at the time this method is
     * called. The iterator is read-only (does not support
     * {@link Iterator#remove()}), as such an operation would have no meaning.
     */
    Iterable<T> threadSafeIterable();

    T get(final T obj);

    Stream<T> stream();

    /**
     * Returns true if any member of this collection matches the given predicate.
     */
    boolean anyMatch(Predicate<? super T> test);

    /**
     * Returns true if each member of this collection matches the given predicate.
     */
    boolean allMatch(Predicate<? super T> test);
}
```

## Python
`forge/util/collect/FCollectionView.py`

```python
from __future__ import annotations

from typing import Iterable, Iterator, List, TypeVar
from collections.abc import Collection
from forge.util.collect.FCollection import FCollection

T = TypeVar("T")


class FCollectionView(Collection[T]):
    """Read-only interface to an FCollection."""

    def isEmpty(self) -> bool:
        """@see Collection#isEmpty()"""
        raise NotImplementedError

    def size(self) -> int:
        """@see Collection#size()"""
        raise NotImplementedError

    def get(self, index_or_obj):
        """
        Either get the object at a positional index (see List#get(int)),
        or get the stored equivalent of a candidate object (T get(final T obj)).
        """
        raise NotImplementedError

    def getFirst(self) -> T:
        """
        Get the first object in this FCollectionView.

        Raises NoSuchElementException if the collection is empty.
        """
        raise NotImplementedError

    def getLast(self) -> T:
        """
        Get the last object in this FCollectionView.

        Raises NoSuchElementException if the collection is empty.
        """
        raise NotImplementedError

    def indexOf(self, o) -> int:
        """@see List#indexOf(Object)"""
        raise NotImplementedError

    def lastIndexOf(self, o) -> int:
        """@see List#lastIndexOf(Object)"""
        raise NotImplementedError

    def contains(self, o) -> bool:
        """@see Collection#contains(Object)"""
        raise NotImplementedError

    def subList(self, fromIndex: int, toIndex: int) -> List[T]:
        """
        Return an unmodifiable list with shallow copies of the elements in a
        particular range of this collection.
        """
        raise NotImplementedError

    def threadSafeIterable(self) -> Iterable[T]:
        """
        Get a thread-safe Iterable, ie. one that is not backed by this
        collection, but rather represents the state at the time this method is
        called. The iterator is read-only (does not support remove()), as such
        an operation would have no meaning.
        """
        raise NotImplementedError

    def stream(self) -> Iterator[T]:
        raise NotImplementedError

    def anyMatch(self, test) -> bool:
        """Returns true if any member of this collection matches the given predicate."""
        raise NotImplementedError

    def allMatch(self, test) -> bool:
        """Returns true if each member of this collection matches the given predicate."""
        raise NotImplementedError
```
