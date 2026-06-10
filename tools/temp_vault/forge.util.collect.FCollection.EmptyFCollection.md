---
aliases:
  - EmptyFCollection
tags:
  - java/class
  - module/forge-core
  - pkg/forge/util/collect
fqn: forge.util.collect.FCollection.EmptyFCollection
package: forge.util.collect
module: forge-core
kind: Class
---

# EmptyFCollection

**Package:** `forge.util.collect` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class EmptyFCollection {
        -long serialVersionUID
        +add(int index, T element) void
        +add(T e) boolean
        +addAll(Collection~T~ c) boolean
        +addAll(int index, Collection~T~ c) boolean
        +addAll(Iterable~T~ i) boolean
        +addAll(T[] c) boolean
        +clear() void
        +contains(Object o) boolean
        +containsAll(Collection~Object~ c) boolean
        +get(int index) T
        +getFirst() T
        +getLast() T
        +indexOf(Object o) int
        +isEmpty() boolean
        +iterator() Iterator~T~
        +lastIndexOf(Object o) int
        +listIterator() ListIterator~T~
        +listIterator(int index) ListIterator~T~
        +remove(int index) T
        +remove(Object o) boolean
        +removeAll(Collection~Object~ c) boolean
        +removeAll(Iterable~Object~ c) boolean
        +retainAll(Collection~Object~ c) boolean
        +set(int index, T element) T
        +size() int
        +sort() void
        +sort(Comparator~T~ comparator) void
        +subList(int fromIndex, int toIndex) List~T~
        +threadSafeIterable() Iterable~T~
        +toArray() Object[]
        +toArray(T[] a) T[]
        +stream() Stream~T~
        +anyMatch(Predicate~T~ test) boolean
        +allMatch(Predicate~T~ test) boolean
        +toString() String
        +EmptyFCollection()
    }
    EmptyFCollection --|> FCollection : extends
```

## Relationships
**Extends:**
- [[forge.util.collect.FCollection|FCollection]]

## Design Description

The EmptyFCollection class is a static nested subclass of FCollection that represents an immutable, permanently empty collection. Its responsibility is to provide a specialized, zero-element implementation that overrides every mutating and accessing method with constant-time behavior tailored to emptinessâ€”mutators silently no-op or return false, size queries return 0, accessors throw IndexOutOfBoundsException or NoSuchElementException, and iterators delegate to the JDK's shared empty instances.

By extending FCollection, it remains substitutable wherever its supertype is expected while collaborating with standard Collection, Iterator, ListIterator, Stream, and Comparator types. The design intent is performance and safety: methods are declared final to lock down the empty contract, allocation is avoided by reusing shared empty iterators and ArrayUtils.EMPTY_OBJECT_ARRAY, and the singleton-friendly instance serves as a lightweight, reusable sentinel for absent collections.

## Source
`forge-core/src/main/java/forge/util/collect/FCollection.java` Ã¢â‚¬â€ declaration excerpt

```java
    /**
     * An unmodifiable, empty {@link FCollection}. Overrides all methods with
     * default implementations suitable for an empty collection, to improve
     * performance.
     */
    public static class EmptyFCollection<T> extends FCollection<T> {
        private static final long serialVersionUID = 8667965158891635997L;
        public EmptyFCollection() {
            super();
        }
        @Override public final void add(final int index, final T element) {
        }
        @Override public final boolean add(final T e) {
            return false;
        }
        @Override public final boolean addAll(final Collection<? extends T> c) {
            return false;
        }
        @Override public final boolean addAll(final int index, final Collection<? extends T> c) {
            return false;
        }
        @Override public final boolean addAll(final Iterable<? extends T> i) {
            return false;
        }
        @Override public final boolean addAll(final T[] c) {
            return false;
        }
        @Override public final void clear() {
        }
        @Override public final boolean contains(final Object o) {
            return false;
        }
        @Override public final boolean containsAll(final Collection<?> c) {
            return c.isEmpty();
        }
        @Override public final T get(final int index) {
            throw new IndexOutOfBoundsException("Any index is out of bounds for an empty collection");
        }
        @Override public final T getFirst() {
            throw new NoSuchElementException("Collection is empty");
        }
        @Override public final T getLast() {
            throw new NoSuchElementException("Collection is empty");
        }
        @Override public final int indexOf(final Object o) {
            return -1;
        }
        @Override public final boolean isEmpty() {
            return true;
        }
        @Override public final Iterator<T> iterator() {
            return Collections.emptyIterator();
        }
        @Override public final int lastIndexOf(final Object o) {
            return -1;
        }
        @Override public final ListIterator<T> listIterator() {
            return Collections.emptyListIterator();
        }
        @Override public final ListIterator<T> listIterator(final int index) {
            return Collections.emptyListIterator();
        }
        @Override public final T remove(final int index) {
            throw new IndexOutOfBoundsException("Any index is out of bounds for an empty collection");
        }
        @Override public final boolean remove(final Object o) {
            return false;
        }
        @Override public boolean removeAll(final Collection<?> c) {
            return false;
        }
        @Override public final boolean removeAll(final Iterable<?> c) {
            return false;
        }
        @Override public final boolean retainAll(final Collection<?> c) {
            return false;
        }
        @Override public final T set(final int index, final T element) {
            throw new IndexOutOfBoundsException("Any index is out of bounds for an empty collection");
        }
        @Override public final int size() {
            return 0;
        }
        @Override public final void sort() {
        }
        @Override public final void sort(final Comparator<? super T> comparator) {
        }
        @Override public final List<T> subList(final int fromIndex, final int toIndex) {
            if (fromIndex == 0 && toIndex == 0) {
                return this;
            }
            throw new IndexOutOfBoundsException("Any index is out of bounds for an empty collection");
        }
        @Override public final Iterable<T> threadSafeIterable() {
            return this;
        }
        @Override public final Object[] toArray() { return ArrayUtils.EMPTY_OBJECT_ARRAY; }
        @Override
        @SuppressWarnings("hiding")
        public final <T> T[] toArray(final T[] a) {
            if (a.length > 0) {
                a[0] = null;
            }
            return a;
        }

        @Override public Stream<T> stream() {return Stream.empty();}
        @Override public boolean anyMatch(Predicate<? super T> test) {return false;}
        @Override public boolean allMatch(Predicate<? super T> test) {return true;}

        @Override
        public final String toString() {
            return "[]";
        }
    }
```

## Python
`forge/util/collect/FCollection/EmptyFCollection.py`

```python
from forge.util.collect.FCollection import FCollection


class EmptyFCollection(FCollection):
    """
    An unmodifiable, empty FCollection. Overrides all methods with
    default implementations suitable for an empty collection, to improve
    performance.
    """

    serialVersionUID = 8667965158891635997

    def __init__(self):
        super().__init__()

    def add(self, index, element=None):
        if element is None:
            # add(T e) -> boolean
            return False
        # add(int index, T element) -> void
        return None

    def addAll(self, *args):
        return False

    def clear(self):
        pass

    def contains(self, o):
        return False

    def containsAll(self, c):
        return c.isEmpty()

    def get(self, index):
        raise IndexError("Any index is out of bounds for an empty collection")

    def getFirst(self):
        raise StopIteration("Collection is empty")

    def getLast(self):
        raise StopIteration("Collection is empty")

    def indexOf(self, o):
        return -1

    def isEmpty(self):
        return True

    def iterator(self):
        return iter(())

    def lastIndexOf(self, o):
        return -1

    def listIterator(self, index=None):
        return iter(())

    def remove(self, arg):
        if isinstance(arg, int):
            raise IndexError("Any index is out of bounds for an empty collection")
        return False

    def removeAll(self, c):
        return False

    def retainAll(self, c):
        return False

    def set(self, index, element):
        raise IndexError("Any index is out of bounds for an empty collection")

    def size(self):
        return 0

    def sort(self, comparator=None):
        pass

    def subList(self, fromIndex, toIndex):
        if fromIndex == 0 and toIndex == 0:
            return self
        raise IndexError("Any index is out of bounds for an empty collection")

    def threadSafeIterable(self):
        return self

    def toArray(self, a=None):
        if a is None:
            return []
        if len(a) > 0:
            a[0] = None
        return a

    def stream(self):
        return iter(())

    def anyMatch(self, test):
        return False

    def allMatch(self, test):
        return True

    def __str__(self):
        return "[]"

    def toString(self):
        return "[]"
```
