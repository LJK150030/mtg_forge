---
aliases:
  - RandomCollectorSingle
tags:
  - java/class
  - module/forge-core
  - pkg/forge/util
fqn: forge.util.StreamUtil.RandomCollectorSingle
package: forge.util
module: forge-core
kind: Class
---

# RandomCollectorSingle

**Package:** `forge.util` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class RandomCollectorSingle {
        +finisher() Function~RandomReservoir,Optional~
        ~RandomCollectorSingle()
    }
    RandomCollectorSingle --|> RandomCollector : extends
    RandomCollectorSingle ..> RandomReservoir : uses
```

## Relationships
**Extends:**
- [[forge.util.StreamUtil.RandomCollector|RandomCollector]]
**Uses:**
- [[forge.util.StreamUtil.RandomReservoir|RandomReservoir]]

## Source
`forge-core/src/main/java/forge/util/StreamUtil.java` — declaration excerpt

```java
    private static class RandomCollectorSingle<T> extends RandomCollector<T, Optional<T>> {
        RandomCollectorSingle() {
            super(1);
        }

        @Override
        public Function<RandomReservoir<T>, Optional<T>> finisher() {
            return (chosen) -> chosen.samples.isEmpty() ? Optional.empty() : Optional.of(chosen.samples.get(0));
        }
    }
```
