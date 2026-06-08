---
aliases:
  - LeafNumber
tags:
  - java/class
  - module/forge-core
  - pkg/forge/card
fqn: forge.card.CardRulesPredicates.LeafNumber
package: forge.card
module: forge-core
kind: Class
---

# LeafNumber

**Package:** `forge.card` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class LeafNumber {
        -LeafNumber.CardField field
        -ComparableOp operator
        -int operand
        +test(CardRules card) boolean
        -op(int op1, int op2) boolean
        +LeafNumber(LeafNumber.CardField field, ComparableOp op, int what)
    }
    LeafNumber ..|> Predicate : implements
    LeafNumber ..> CardField : uses
    LeafNumber ..> CardRules : uses
    LeafNumber ..> ComparableOp : uses
```

## Relationships
**Uses:**
- [[forge.card.CardRules|CardRules]]
- [[forge.card.CardRulesPredicates.LeafNumber.CardField|CardField]]
- [[forge.util.ComparableOp|ComparableOp]]

## Design Description

LeafNumber is a static nested `Predicate<CardRules>` that evaluates a single numeric comparison against a card's rules data. It pairs three immutable fields — a `CardField` enum selecting which numeric attribute to inspect (CMC, generic cost, power, toughness, combined P/T, or loyalty), a `ComparableOp` defining the comparison, and an integer operand — to answer whether a given `CardRules` satisfies the predicate. Its `test` method dispatches on the field to extract the relevant value, then delegates to a private `op` helper that maps each `ComparableOp` to the corresponding integer relation.

As a leaf node in `CardRulesPredicates`, it serves as the atomic building block from which larger, composable card-filtering predicates are assembled. The design favors immutability and defensive parsing: loyalty values are validated and parsed guardedly, and sentinel `Integer.MAX_VALUE` power/toughness results are treated as non-matching rather than producing spurious comparisons.

## Source
`forge-core/src/main/java/forge/card/CardRulesPredicates.java` â€” declaration excerpt

```java
    public static class LeafNumber implements Predicate<CardRules> {
        public enum CardField {
            CMC, GENERIC_COST, POWER, TOUGHNESS, PT, LOYALTY
        }

        private final LeafNumber.CardField field;
        private final ComparableOp operator;
        private final int operand;

        public LeafNumber(final LeafNumber.CardField field, final ComparableOp op, final int what) {
            this.field = field;
            this.operand = what;
            this.operator = op;
        }

        @Override
        public boolean test(final CardRules card) {
            int value;
            switch (this.field) {
            case CMC:
                return this.op(card.getManaCost().getCMC(), this.operand);
            case GENERIC_COST:
                return this.op(card.getManaCost().getGenericCost(), this.operand);
            case LOYALTY:
                String sLoyalty = card.getInitialLoyalty();
                if (StringUtils.isBlank(sLoyalty) || !sLoyalty.matches("\\d+")) {
                    return false;
                }
                try {
                    value = Integer.parseInt(sLoyalty) ;
                }
                catch (NumberFormatException ignored) {
                    return false;
                }
                return this.op(value, this.operand);
            case POWER:
                value = card.getIntPower();
                return value != Integer.MAX_VALUE && this.op(value, this.operand);
            case TOUGHNESS:
                value = card.getIntToughness();
                return value != Integer.MAX_VALUE && this.op(value, this.operand);
            case PT:
                value = card.getIntPower() + card.getIntToughness();
                return value != Integer.MAX_VALUE && this.op(value, this.operand);
            default:
                return false;
            }
        }

        private boolean op(final int op1, final int op2) {
            switch (this.operator) {
            case EQUALS:
                return op1 == op2;
            case GREATER_THAN:
                return op1 > op2;
            case GT_OR_EQUAL:
                return op1 >= op2;
            case LESS_THAN:
                return op1 < op2;
            case LT_OR_EQUAL:
                return op1 <= op2;
            case NOT_EQUALS:
                return op1 != op2;
            default:
                return false;
            }
        }
    }
```
