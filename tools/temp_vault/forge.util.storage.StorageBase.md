---
aliases:
  - StorageBase
tags:
  - java/class
  - module/forge-core
  - pkg/forge/util/storage
fqn: forge.util.storage.StorageBase
package: forge.util.storage
module: forge-core
kind: Class
---

# StorageBase

**Package:** `forge.util.storage` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StorageBase {
        #Map~String,T~ map
        +StorageBase~Object~ emptyMap
        +String name
        +String fullPath
        +get(String name) T
        +getItemNames() Collection~String~
        +iterator() Iterator~T~
        +stream() Stream~T~
        +contains(String name) boolean
        +size() int
        +find(Predicate~T~ condition) T
        +add(String name, T item) void
        +add(T item) void
        +delete(String itemName) void
        +getFolders() IStorage~IStorage~
        +getName() String
        +getFullPath() String
        +tryGetFolder(String path) IStorage~T~
        +getFolderOrCreate(String path) IStorage~T~
        +getAllFilesList(File downloadDir, FilenameFilter filenameFilter) List~File~
        +StorageBase(String name0, IItemReader~T~ io)
        +StorageBase(String name0, String fullPath0, Map~String,T~ map0)
    }
    StorageBase ..|> IStorage : implements
    StorageBase ..> IItemReader : uses
```

## Relationships
**Implements:**
- [[forge.util.storage.IStorage|IStorage]]
**Uses:**
- [[forge.util.IItemReader|IItemReader]]

## Design Description

StorageBase is a generic, read-only implementation of the `IStorage<T>` interface, providing in-memory access to a named collection of items keyed by string. It backs its contents with a `Map<String, T>` that is either supplied directly or populated by reading from an `IItemReader<T>` at construction. It exposes lookup, iteration, streaming, containment, sizing, and predicate-based search, while deliberately rejecting all mutating operations (`add`, `delete`) with `UnsupportedOperationException` to enforce immutability.

By design it represents a flat storage with no nested folders: `getFolders` returns a shared empty singleton and the subfolder methods throw, leaving hierarchical behavior to derived classes that override them. The shared `emptyMap` constant and the recursive static `getAllFilesList` utility round out a lightweight, reusable base intended as the foundation for Forge's concrete storage variants.

## Source
`forge-core/src/main/java/forge/util/storage/StorageBase.java`

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

import forge.util.IItemReader;
import forge.util.IterableUtil;

import java.io.File;
import java.io.FilenameFilter;
import java.util.*;
import java.util.function.Predicate;
import java.util.stream.Stream;

/**
 * <p>
 * StorageBase class.
 * </p>
 *
 * @param <T> the generic type
 * @author Forge
 * @version $Id: StorageBase.java 13590 2012-01-27 20:46:27Z Max mtg $
 */
public class StorageBase<T> implements IStorage<T> {
    protected final Map<String, T> map;

    public final static StorageBase<?> emptyMap = new StorageBase<>("Empty", null, new HashMap<>());
    public final String name, fullPath;

    public StorageBase(final String name0, final IItemReader<T> io) {
        this(name0, io.getFullPath(), io.readAll());
    }

    public StorageBase(final String name0, final String fullPath0, final Map<String, T> map0) {
        name = name0;
        fullPath = fullPath0;
        map = map0;
    }

    @Override
    public T get(final String name) {
        return map.get(name);
    }

    @Override
    public final Collection<String> getItemNames() {
        return new ArrayList<>(map.keySet());
    }

    @Override
    public Iterator<T> iterator() {
        return map.values().iterator();
    }

    @Override
    public Stream<T> stream() {
        return map.values().stream();
    }

    @Override
    public boolean contains(String name) {
        return name != null && map.containsKey(name);
    }

    @Override
    public int size() {
        return map.size();
    }

    @Override
    public T find(Predicate<T> condition) {
        return IterableUtil.tryFind(map.values(), condition).orElse(null);
    }

    @Override
    public void add(String name, T item) {
        throw new UnsupportedOperationException("This is a read-only storage");
    }

    @Override
    public void add(T item) {
        throw new UnsupportedOperationException("This is a read-only storage");
    }

    @Override
    public void delete(String itemName) {
        throw new UnsupportedOperationException("This is a read-only storage");
    }

    // we don't have nested folders unless that's overridden in a derived class
    @SuppressWarnings("unchecked")
    @Override
    public IStorage<IStorage<T>> getFolders() {
        return (IStorage<IStorage<T>>) emptyMap;
    }

    @Override
    public final String getName() {
        return name;
    }

    @Override
    public final String getFullPath() {
        if (fullPath == null) {
            return name;
        }
        return fullPath;
    }

    @Override
    public IStorage<T> tryGetFolder(String path) {
        throw new UnsupportedOperationException("This storage does not support subfolders");
    }

    @Override
    public IStorage<T> getFolderOrCreate(String path) {
        throw new UnsupportedOperationException("This storage does not support subfolders");
    }

    /**
     * Return all the files in a given path tree (traversed recursively) that would match
     * the input <code>FilenameFilter</code>.
     *
     * @param downloadDir  Target root path to traverse
     * @param filenameFilter  <code>FilenameFilter</code> used to select files of interest
     * @return The <code>List</code> of all <code>File</code> objects found in the root path
     * that passed the provided <code>FilenameFilter</code>.
     * An empty list will be returned if the target path is empty, or no file matching the filter
     * will be (recursively) found.
     */
    public static List<File> getAllFilesList(File downloadDir, FilenameFilter filenameFilter){
        File[] filesList = downloadDir.listFiles(filenameFilter);
        ArrayList<File> allFilesList = new ArrayList<>();
        if (filesList != null)
            allFilesList.addAll(Arrays.asList(filesList));
        File[] subFolders = downloadDir.listFiles(File::isDirectory);
        if(subFolders != null) {
            for (File subFolder : subFolders)
                allFilesList.addAll(getAllFilesList(subFolder, filenameFilter));
        }
        return allFilesList;
    }
}
```

## Python
`forge/util/storage/StorageBase.py`

```python
from forge.util.storage.IStorage import IStorage
from forge.util.IItemReader import IItemReader
from forge.util.IterableUtil import IterableUtil

import os
from typing import Callable, Collection, Iterator, List, Optional, TypeVar

T = TypeVar("T")


class StorageBase(IStorage[T]):
    emptyMap: "StorageBase" = None  # assigned after class definition

    def __init__(self, name0, arg1, map0=None):
        if map0 is None:
            # StorageBase(name0, io): io is an IItemReader<T>
            io = arg1
            self._init_from_map(name0, io.getFullPath(), io.readAll())
        else:
            # StorageBase(name0, fullPath0, map0)
            self._init_from_map(name0, arg1, map0)

    def _init_from_map(self, name0, fullPath0, map0):
        self.name = name0
        self.fullPath = fullPath0
        self.map = map0

    def get(self, name: str) -> T:
        return self.map.get(name)

    def getItemNames(self) -> Collection[str]:
        return list(self.map.keys())

    def __iter__(self) -> Iterator[T]:
        return iter(self.map.values())

    def stream(self):
        return iter(self.map.values())

    def contains(self, name: str) -> bool:
        return name is not None and name in self.map

    def size(self) -> int:
        return len(self.map)

    def find(self, condition: Callable[[T], bool]) -> Optional[T]:
        return IterableUtil.tryFind(self.map.values(), condition).orElse(None)

    def add(self, name, item=None):
        raise NotImplementedError("This is a read-only storage")

    def delete(self, itemName: str):
        raise NotImplementedError("This is a read-only storage")

    # we don't have nested folders unless that's overridden in a derived class
    def getFolders(self) -> "IStorage[IStorage[T]]":
        return StorageBase.emptyMap

    def getName(self) -> str:
        return self.name

    def getFullPath(self) -> str:
        if self.fullPath is None:
            return self.name
        return self.fullPath

    def tryGetFolder(self, path: str) -> "IStorage[T]":
        raise NotImplementedError("This storage does not support subfolders")

    def getFolderOrCreate(self, path: str) -> "IStorage[T]":
        raise NotImplementedError("This storage does not support subfolders")

    @staticmethod
    def getAllFilesList(downloadDir, filenameFilter) -> List[str]:
        allFilesList = []
        try:
            entries = os.listdir(downloadDir)
        except OSError:
            entries = None
        if entries is not None:
            for entry in entries:
                fullName = os.path.join(downloadDir, entry)
                if not os.path.isdir(fullName) and filenameFilter(downloadDir, entry):
                    allFilesList.append(fullName)
            for entry in entries:
                fullName = os.path.join(downloadDir, entry)
                if os.path.isdir(fullName):
                    allFilesList.extend(StorageBase.getAllFilesList(fullName, filenameFilter))
        return allFilesList


StorageBase.emptyMap = StorageBase("Empty", None, {})
```
