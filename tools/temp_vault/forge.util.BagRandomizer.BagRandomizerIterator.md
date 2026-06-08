---
aliases:
  - BagRandomizerIterator
tags:
  - java/class
  - module/forge-core
  - pkg/forge/util
fqn: forge.util.BagRandomizer.BagRandomizerIterator
package: forge.util
module: forge-core
kind: Class
---

# BagRandomizerIterator

**Package:** `forge.util` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class BagRandomizerIterator {
        +hasNext() boolean
        +next() T
    }
    BagRandomizerIterator ..|> Iterator : implements
```

## Source
`forge-core/src/main/java/forge/util/BagRandomizer.java` — declaration excerpt

```java
    private class BagRandomizerIterator<T> implements Iterator<T> {

        @Override
        public boolean hasNext() {
            return bag.length > 0;
        }

        @Override
        public T next() {
            return (T) BagRandomizer.this.getNextItem();
        }
    }
```
