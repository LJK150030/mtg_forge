---
aliases:
  - PredicateNames
tags:
  - java/class
  - module/forge-core
  - pkg/forge/item
fqn: forge.item.PaperCardPredicates.PredicateNames
package: forge.item
module: forge-core
kind: Class
---

# PredicateNames

**Package:** `forge.item` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class PredicateNames {
        -List~String~ operand
        +test(PaperCard card) boolean
        -PredicateNames(List~String~ operand)
    }
    PredicateNames --|> PredicateString : extends
    PredicateNames ..> PaperCard : uses
```

## Relationships
**Extends:**
- [[forge.util.PredicateString|PredicateString]]
**Uses:**
- [[forge.item.PaperCard|PaperCard]]

## Source
`forge-core/src/main/java/forge/item/PaperCardPredicates.java` — declaration excerpt

```java
    private static final class PredicateNames extends PredicateString<PaperCard> {
        private final List<String> operand;

        @Override
        public boolean test(final PaperCard card) {
            final String cardName = card.getName();
            for (final String element : this.operand) {
                if (this.op(cardName, element)) {
                    return true;
                }
            }
            return false;
        }

        private PredicateNames(final List<String> operand) {
            super(StringOp.EQUALS);
            this.operand = operand;
        }
    }
```
