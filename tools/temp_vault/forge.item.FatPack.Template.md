---
aliases:
  - Template
tags:
  - java/class
  - module/forge-core
  - pkg/forge/item
fqn: forge.item.FatPack.Template
package: forge.item
module: forge-core
kind: Class
---

# Template

**Package:** `forge.item` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class Template {
        -int cntBoosters
        +getCntBoosters() int
        +toString() String
        -Template(CardEdition edition)
    }
    Template --|> SealedTemplate : extends
    Template ..> CardEdition : uses
```

## Relationships
**Extends:**
- [[forge.item.SealedTemplate|SealedTemplate]]
**Uses:**
- [[forge.card.CardEdition|CardEdition]]

## Design Description

`FatPack.Template` is a small, immutable value type nested within `FatPack` that describes the contents of a Magic: The Gathering fat pack for a specific set. Extending `SealedTemplate`, it inherits the notion of card slots while adding a single `cntBoosters` field, initialized from a `CardEdition`'s fat-pack configuration via its private constructorâ€”a design that confines instantiation to the enclosing class and guarantees the booster count and slot layout always derive from authoritative edition data. Its overridden `toString()` builds a human-readable summary, enumerating each slot's quantity and appending the booster-pack count, gracefully reporting "no cards" when empty. The class thus serves purely as a descriptive, edition-driven blueprint rather than a mutable container, collaborating with `CardEdition` only at construction time.

## Source
`forge-core/src/main/java/forge/item/FatPack.java` Ã¢â‚¬â€ declaration excerpt

```java
    public static class Template extends SealedTemplate {
        private final int cntBoosters;

        public int getCntBoosters() { return cntBoosters; }

        private Template(CardEdition edition) {
            super(edition.getCode(), edition.getFatPackExtraSlots());

            cntBoosters = edition.getFatPackCount();
        }
        
        @Override
        public String toString() {
            if (0 >= cntBoosters) {
                return "no cards";
            }

            StringBuilder s = new StringBuilder();
            for(Pair<String, Integer> p : slots) {
                s.append(p.getRight()).append(" ").append(p.getLeft()).append(", ");
            }
            // trim the last comma and space
            if( s.length() > 0 )
                s.replace(s.length() - 2, s.length(), "");

            if (0 < cntBoosters) {
                if( s.length() > 0 )
                    s.append(" and ");
                    
                s.append(cntBoosters).append(" booster packs ");
            }
            return s.toString();
        }
    }
```

## Python
`forge/item/FatPack/Template.py`

```python
from forge.item.SealedTemplate import SealedTemplate
from forge.card.CardEdition import CardEdition


class Template(SealedTemplate):
    def __init__(self, edition: CardEdition):
        super().__init__(edition.getCode(), edition.getFatPackExtraSlots())

        self.cntBoosters = edition.getFatPackCount()

    def getCntBoosters(self) -> int:
        return self.cntBoosters

    def toString(self) -> str:
        if 0 >= self.cntBoosters:
            return "no cards"

        s = []
        for p in self.slots:
            s.append(str(p.getRight()) + " " + p.getLeft() + ", ")

        result = "".join(s)
        # trim the last comma and space
        if len(result) > 0:
            result = result[:len(result) - 2]

        if 0 < self.cntBoosters:
            if len(result) > 0:
                result += " and "

            result += str(self.cntBoosters) + " booster packs "
        return result

    def __str__(self) -> str:
        return self.toString()
```
