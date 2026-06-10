---
aliases:
  - CardArtPreference
tags:
  - java/enum
  - module/forge-core
  - pkg/forge/card
fqn: forge.card.CardDb.CardArtPreference
package: forge.card
module: forge-core
kind: Enum
---

# CardArtPreference

**Package:** `forge.card` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Enum

```mermaid
classDiagram
    class CardArtPreference {
        <<enumeration>>
        LATEST_ART_ALL_EDITIONS
        LATEST_ART_CORE_EXPANSIONS_REPRINT_ONLY
        ORIGINAL_ART_ALL_EDITIONS
        ORIGINAL_ART_CORE_EXPANSIONS_REPRINT_ONLY
        +boolean filterSets
        +boolean latestFirst
        -EnumSet~Type~ ALLOWED_SET_TYPES
        +accept(CardEdition ed) boolean
        +compare(CardEdition o1, CardEdition o2) int
        ~CardArtPreference(boolean filterIrregularSets, boolean latestSetFirst)
    }
    CardArtPreference ..|> Comparator : implements
    CardArtPreference ..> CardEdition : uses
    CardArtPreference ..> Type : uses
```

## Relationships
**Uses:**
- [[forge.card.CardEdition|CardEdition]]
- [[forge.card.CardEdition.Type|Type]]

## Design Description

CardArtPreference is a self-contained enum within CardDb that encodes a user's policy for selecting which printing of a card to use when a card appears across multiple editions. Each of its four constants combines two boolean flagsâ€”`filterSets`, which restricts selection to regular Core, Expansion, and Reprint sets, and `latestFirst`, which controls whether newer or original printings are preferredâ€”giving the cross product of "latest vs. original art" and "all editions vs. core/expansion/reprint only."

By implementing `Comparator<CardEdition>`, the enum serves as a pluggable ordering strategy that callers pass to edition-selection logic: `compare` first segregates allowed set types ahead of irregular ones when filtering is enabled, then orders by release date in the configured direction. The companion `accept` predicate exposes the same filtering rule for membership tests. It collaborates only with `CardEdition` and its `Type`, keeping art-preference policy cohesively expressed as data plus behavior on each constant rather than scattered conditional logic.

## Source
`forge-core/src/main/java/forge/card/CardDb.java` Ã¢â‚¬â€ declaration excerpt

```java
    public enum CardArtPreference implements Comparator<CardEdition> {
        LATEST_ART_ALL_EDITIONS(false, true),
        LATEST_ART_CORE_EXPANSIONS_REPRINT_ONLY(true, true),
        ORIGINAL_ART_ALL_EDITIONS(false, false),
        ORIGINAL_ART_CORE_EXPANSIONS_REPRINT_ONLY(true, false);

        public final boolean filterSets;
        public final boolean latestFirst;

        CardArtPreference(boolean filterIrregularSets, boolean latestSetFirst) {
            filterSets = filterIrregularSets;
            latestFirst = latestSetFirst;
        }

        private static final EnumSet<Type> ALLOWED_SET_TYPES = EnumSet.of(Type.CORE, Type.EXPANSION, Type.REPRINT);

        public boolean accept(CardEdition ed) {
            if (ed == null) return false;
            return !filterSets || ALLOWED_SET_TYPES.contains(ed.getType());
        }

        @Override
        public int compare(CardEdition o1, CardEdition o2) {
            if (o1 == o2)
                return 0;
            if(filterSets && (ALLOWED_SET_TYPES.contains(o1.getType()) != ALLOWED_SET_TYPES.contains(o2.getType())))
                return ALLOWED_SET_TYPES.contains(o1.getType()) ? -1 : 1;
            return (latestFirst ? -1 : 1) * o1.getDate().compareTo(o2.getDate());
        }
    }
```

## Python
`forge/card/CardDb/CardArtPreference.py`

```python
from typing import List

from forge.card.CardEdition import CardEdition
from forge.card.CardEdition.Type import Type


class CardArtPreference:
    LATEST_ART_ALL_EDITIONS = None
    LATEST_ART_CORE_EXPANSIONS_REPRINT_ONLY = None
    ORIGINAL_ART_ALL_EDITIONS = None
    ORIGINAL_ART_CORE_EXPANSIONS_REPRINT_ONLY = None

    ALLOWED_SET_TYPES = frozenset({Type.CORE, Type.EXPANSION, Type.REPRINT})

    def __init__(self, filterIrregularSets: bool, latestSetFirst: bool):
        self.filterSets = filterIrregularSets
        self.latestFirst = latestSetFirst

    def accept(self, ed: CardEdition) -> bool:
        if ed is None:
            return False
        return not self.filterSets or ed.getType() in CardArtPreference.ALLOWED_SET_TYPES

    def compare(self, o1: CardEdition, o2: CardEdition) -> int:
        if o1 is o2:
            return 0
        if self.filterSets and (
            (o1.getType() in CardArtPreference.ALLOWED_SET_TYPES)
            != (o2.getType() in CardArtPreference.ALLOWED_SET_TYPES)
        ):
            return -1 if o1.getType() in CardArtPreference.ALLOWED_SET_TYPES else 1
        return (-1 if self.latestFirst else 1) * _cmp(o1.getDate(), o2.getDate())


def _cmp(a, b) -> int:
    return (a > b) - (a < b)


CardArtPreference.LATEST_ART_ALL_EDITIONS = CardArtPreference(False, True)
CardArtPreference.LATEST_ART_CORE_EXPANSIONS_REPRINT_ONLY = CardArtPreference(True, True)
CardArtPreference.ORIGINAL_ART_ALL_EDITIONS = CardArtPreference(False, False)
CardArtPreference.ORIGINAL_ART_CORE_EXPANSIONS_REPRINT_ONLY = CardArtPreference(True, False)
```
