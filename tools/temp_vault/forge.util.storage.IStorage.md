---
aliases:
  - IStorage
tags:
  - java/interface
  - module/forge-core
  - pkg/forge/util/storage
fqn: forge.util.storage.IStorage
package: forge.util.storage
module: forge-core
kind: Interface
---

# IStorage

**Package:** `forge.util.storage` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Interface

```mermaid
classDiagram
    class IStorage {
        <<interface>>
        ~getFullPath() String
        ~get(String name) T
        ~find(Predicate~T~ condition) T
        ~getItemNames() Collection~String~
        ~contains(String name) boolean
        ~size() int
        ~add(T item) void
        ~add(String name, T item) void
        ~delete(String deckName) void
        ~getFolders() IStorage~IStorage~
        ~tryGetFolder(String path) IStorage~T~
        ~getFolderOrCreate(String path) IStorage~T~
        ~stream() Stream~T~
    }
    IStorage --|> Iterable : extends
    IStorage --|> IHasName : extends
```

## Relationships
**Extends:**
- [[forge.util.IHasName|IHasName]]

## Design Description

The IStorage interface defines a generic, name-keyed persistence and retrieval contract for collections of items (decks, quests, and similar user data) within the forge-core module. Parameterized over an item type `T`, it exposes lookup operations (`get`, `find`, `contains`, `getItemNames`), mutation operations (`add`, `delete`), and metadata such as `size` and `getFullPath`. By extending `Iterable<T>` and offering a `stream()` method, it integrates with standard Java iteration and functional pipelines, while extending `IHasName` gives each store its own identity.

A distinctive design intent is its recursive, filesystem-like structure: `getFolders()` returns an `IStorage<IStorage<T>>`, and `tryGetFolder`/`getFolderOrCreate` resolve nested stores by path, letting items be organized into hierarchical folders. This abstraction decouples callers from the concrete storage backend, enabling interchangeable in-memory or file-based implementations.

## Source
`forge-core/src/main/java/forge/util/storage/IStorage.java`

```java
/*
 * Forge: Play Magic: the Gathering.
 * Copyright (C) 2011  Forge Team
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package forge.util.storage;

import forge.util.IHasName;

import java.util.Collection;
import java.util.function.Predicate;
import java.util.stream.Stream;

public interface IStorage<T> extends Iterable<T>, IHasName {
    String getFullPath();
    T get(String name);
    T find(Predicate<T> condition);
    Collection<String> getItemNames();
    boolean contains(String name);
    int size();
    void add(T item);
    void add(String name, T item);
    void delete(String deckName);
    IStorage<IStorage<T>> getFolders();
    IStorage<T> tryGetFolder(String path);
    IStorage<T> getFolderOrCreate(String path);
    Stream<T> stream();
}
```

## Python
`forge/util/storage/IStorage.py`

```python
from abc import abstractmethod
from typing import Collection, Generic, Iterable, Iterator, TypeVar
from collections.abc import Callable

from forge.util.IHasName import IHasName

T = TypeVar("T")


class IStorage(Iterable[T], IHasName, Generic[T]):
    @abstractmethod
    def getFullPath(self) -> str:
        ...

    @abstractmethod
    def get(self, name: str) -> T:
        ...

    @abstractmethod
    def find(self, condition: Callable[[T], bool]) -> T:
        ...

    @abstractmethod
    def getItemNames(self) -> Collection[str]:
        ...

    @abstractmethod
    def contains(self, name: str) -> bool:
        ...

    @abstractmethod
    def size(self) -> int:
        ...

    @abstractmethod
    def add(self, name, item=None) -> None:
        ...

    @abstractmethod
    def delete(self, deckName: str) -> None:
        ...

    @abstractmethod
    def getFolders(self) -> "IStorage[IStorage[T]]":
        ...

    @abstractmethod
    def tryGetFolder(self, path: str) -> "IStorage[T]":
        ...

    @abstractmethod
    def getFolderOrCreate(self, path: str) -> "IStorage[T]":
        ...

    @abstractmethod
    def stream(self) -> Iterator[T]:
        ...
```
