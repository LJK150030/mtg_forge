---
aliases:
  - PredicateSearchableName
tags:
  - java/class
  - module/forge-core
  - pkg/forge/item
fqn: forge.item.PaperCardPredicates.PredicateSearchableName
package: forge.item
module: forge-core
kind: Class
---

# PredicateSearchableName

**Package:** `forge.item` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class PredicateSearchableName {
        -String operand
        +test(PaperCard paperCard) boolean
        ~PredicateSearchableName(StringOp operator, String operand)
    }
    PredicateSearchableName --|> PredicateString : extends
    PredicateSearchableName ..> PaperCard : uses
    PredicateSearchableName ..> StringOp : uses
```

## Relationships
**Extends:**
- [[forge.util.PredicateString|PredicateString]]
**Uses:**
- [[forge.item.PaperCard|PaperCard]]
- [[forge.util.PredicateString.StringOp|StringOp]]

## Source
`forge-core/src/main/java/forge/item/PaperCardPredicates.java` — declaration excerpt

```java
    private static final class PredicateSearchableName extends PredicateString<PaperCard> {
        private final String operand;

        PredicateSearchableName(final StringOp operator, final String operand) {
            super(operator);
            this.operand = operand;
        }

        @Override
        public boolean test(PaperCard paperCard) {
            return paperCard.getAllSearchableNames().stream().anyMatch(name -> this.op(name, this.operand));
        }
    }
```
