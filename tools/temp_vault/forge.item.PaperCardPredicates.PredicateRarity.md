---
aliases:
  - PredicateRarity
tags:
  - java/class
  - module/forge-core
  - pkg/forge/item
fqn: forge.item.PaperCardPredicates.PredicateRarity
package: forge.item
module: forge-core
kind: Class
---

# PredicateRarity

**Package:** `forge.item` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class PredicateRarity {
        -CardRarity operand
        +test(PaperCard card) boolean
        -PredicateRarity(CardRarity rarity)
    }
    PredicateRarity ..|> Predicate : implements
    PredicateRarity ..> CardRarity : uses
    PredicateRarity ..> PaperCard : uses
```

## Relationships
**Uses:**
- [[forge.card.CardRarity|CardRarity]]
- [[forge.item.PaperCard|PaperCard]]

## Source
`forge-core/src/main/java/forge/item/PaperCardPredicates.java` — declaration excerpt

```java
    private static final class PredicateRarity implements Predicate<PaperCard> {
        private final CardRarity operand;

        @Override
        public boolean test(final PaperCard card) {
            return card.getRarity() == this.operand;
        }

        private PredicateRarity(final CardRarity rarity) {
            this.operand = rarity;
        }
    }
```
