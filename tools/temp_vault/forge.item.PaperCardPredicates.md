---
aliases:
  - PaperCardPredicates
tags:
  - java/class
  - module/forge-core
  - pkg/forge/item
fqn: forge.item.PaperCardPredicates
package: forge.item
module: forge-core
kind: Class
---

# PaperCardPredicates

**Package:** `forge.item` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class PaperCardPredicates {
        +Predicate~PaperCard~ IS_COMMON
        +Predicate~PaperCard~ IS_UNCOMMON
        +Predicate~PaperCard~ IS_RARE
        +Predicate~PaperCard~ IS_MYTHIC_RARE
        +Predicate~PaperCard~ IS_RARE_OR_MYTHIC
        +Predicate~PaperCard~ IS_SPECIAL
        +Predicate~PaperCard~ IS_BASIC_LAND_RARITY
        +Predicate~PaperCard~ IS_BLACK
        +Predicate~PaperCard~ IS_BLUE
        +Predicate~PaperCard~ IS_GREEN
        +Predicate~PaperCard~ IS_RED
        +Predicate~PaperCard~ IS_WHITE
        +Predicate~PaperCard~ IS_COLORLESS
        +Predicate~PaperCard~ IS_UNREBALANCED
        +Predicate~PaperCard~ IS_REBALANCED
        +Predicate~PaperCard~ IS_LAND
        +Predicate~PaperCard~ IS_NON_LAND
        +Predicate~PaperCard~ IS_BASIC_LAND
        +Predicate~PaperCard~ NOT_BASIC_LAND
        +Predicate~PaperCard~ NOT_TRUE_BASIC_LAND
        +Predicate~PaperCard~ IS_NONBASIC_LAND
        +Predicate~PaperCard~ IS_CREATURE
        +Predicate~PaperCard~ CAN_BE_COMMANDER
        +printedInSets(String[] sets) Predicate~PaperCard~
        +printedInSets(List~String~ value, boolean shouldContain) Predicate~PaperCard~
        +printedInSet(String value) Predicate~PaperCard~
        +printedWithRarity(CardRarity rarity) Predicate~PaperCard~
        +searchableName(PredicateString.StringOp op, String what) Predicate~PaperCard~
        +name(String what) Predicate~PaperCard~
        +names(List~String~ what) Predicate~PaperCard~
        +isFoil(boolean isFoil) Predicate~PaperCard~
        +printedInAnyEditions(String[] editionCodes) Predicate~PaperCard~
        +onlyPrintedInEditions(String[] editionCodes) Predicate~PaperCard~
        +isObtainableAnyEdition() Predicate~PaperCard~
        +isObtainableNotRestricted(String[] restrictedEditionCodes) Predicate~PaperCard~
        +fromRules(Predicate~CardRules~ cardRulesPredicate) Predicate~PaperCard~
    }
    PaperCardPredicates ..> CardRarity : uses
    PaperCardPredicates ..> CardRules : uses
    PaperCardPredicates ..> Color : uses
    PaperCardPredicates ..> EditionEntry : uses
    PaperCardPredicates ..> MagicColor : uses
    PaperCardPredicates ..> PaperCard : uses
    PaperCardPredicates ..> PredicateColor : uses
    PaperCardPredicates ..> PredicateFoil : uses
    PaperCardPredicates ..> PredicateName : uses
    PaperCardPredicates ..> PredicateNames : uses
    PaperCardPredicates ..> PredicatePrintedWithRarity : uses
    PaperCardPredicates ..> PredicateRarity : uses
    PaperCardPredicates ..> PredicateSearchableName : uses
    PaperCardPredicates ..> PredicateSets : uses
    PaperCardPredicates ..> PredicateString : uses
    PaperCardPredicates ..> StringOp : uses
```

## Relationships
**Uses:**
- [[forge.card.CardEdition.EditionEntry|EditionEntry]]
- [[forge.card.CardRarity|CardRarity]]
- [[forge.card.CardRules|CardRules]]
- [[forge.card.MagicColor|MagicColor]]
- [[forge.card.MagicColor.Color|Color]]
- [[forge.item.PaperCard|PaperCard]]
- [[forge.item.PaperCardPredicates.PredicateColor|PredicateColor]]
- [[forge.item.PaperCardPredicates.PredicateFoil|PredicateFoil]]
- [[forge.item.PaperCardPredicates.PredicateName|PredicateName]]
- [[forge.item.PaperCardPredicates.PredicateNames|PredicateNames]]
- [[forge.item.PaperCardPredicates.PredicatePrintedWithRarity|PredicatePrintedWithRarity]]
- [[forge.item.PaperCardPredicates.PredicateRarity|PredicateRarity]]
- [[forge.item.PaperCardPredicates.PredicateSearchableName|PredicateSearchableName]]
- [[forge.item.PaperCardPredicates.PredicateSets|PredicateSets]]
- [[forge.util.PredicateString|PredicateString]]
- [[forge.util.PredicateString.StringOp|StringOp]]

## Design Description

PaperCardPredicates is a utility class in `forge.item` that centralizes the construction of `Predicate<PaperCard>` filters used to query and select cards from Forge's card pool. It exposes a large catalog of ready-made constant predicates (rarity, color, land/creature type, rebalanced status, commander eligibility) alongside static factory methods that build parameterized filters for set membership, edition obtainability, foil status, name matching, and rarity.

Declared `abstract` with only static members, it is a stateless namespace rather than an instantiable type. It encapsulates a family of private inner `Predicate<PaperCard>` implementationsâ€”each testing one card attributeâ€”so callers compose filters through the factories without depending on the concrete classes. It delegates rules-based checks to `CardRulesPredicates` via `fromRules`, reuses `PredicateString` for case-aware name comparison, and consults `StaticData` to resolve editions and obtainability, keeping card-selection logic uniform and reusable across the engine.

## Source
`forge-core/src/main/java/forge/item/PaperCardPredicates.java`

```java
package forge.item;

import com.google.common.collect.Lists;

import forge.StaticData;
import forge.card.*;
import forge.card.CardEdition.EditionEntry;
import forge.util.PredicateString;
import org.apache.commons.lang3.StringUtils;

import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;
import java.util.function.Predicate;

/**
 * Filters based on PaperCard values.
 */
public abstract class PaperCardPredicates {

    public static Predicate<PaperCard> printedInSets(final String[] sets) {
        return printedInSets(Lists.newArrayList(sets), true);
    }

    public static Predicate<PaperCard> printedInSets(final List<String> value, final boolean shouldContain) {
        if ((value == null) || value.isEmpty()) {
            return x -> true;
        }
        return new PredicateSets(value, shouldContain);
    }

    public static Predicate<PaperCard> printedInSet(final String value) {
        if (StringUtils.isEmpty(value)) {
            return x -> true;
        }
        return new PredicateSets(Lists.newArrayList(value), true);
    }

    public static Predicate<PaperCard> printedWithRarity(final CardRarity rarity) {
        return new PredicatePrintedWithRarity(rarity);
    }

    public static Predicate<PaperCard> searchableName(final PredicateString.StringOp op, final String what) {
        return new PredicateSearchableName(op, what);
    }

    public static Predicate<PaperCard> name(final String what) {
        return new PredicateName(what);
    }

    public static Predicate<PaperCard> names(final List<String> what) {
        return new PredicateNames(what);
    }

    /**
     * Filters on a card foil status
     */
    public static Predicate<PaperCard> isFoil(final boolean isFoil) {
        return new PredicateFoil(isFoil);
    }

    /**
     * Filters cards that were printed in any of the specified editions.
     */
    public static Predicate<PaperCard> printedInAnyEditions(final String[] editionCodes) {
        Set<String> editions = new HashSet<>(Arrays.asList(editionCodes));

        return card -> StaticData.instance().getCommonCards().getAllCards(card).stream()
            .map(PaperCard::getEdition).anyMatch(editionCode ->
                editions.contains(editionCode) &&
                    StaticData.instance().getCardEdition(editionCode).isCardObtainable(card.getName())
        );
    }

    /**
     * Filters cards that were only printed in any of the specified editions.
     */
    public static Predicate<PaperCard> onlyPrintedInEditions(final String[] editionCodes) {
        Set<String> editions = new HashSet<>(Arrays.asList(editionCodes));

        return card -> StaticData.instance().getCommonCards().getAllCards(card).stream()
            .map(PaperCard::getEdition).allMatch(editionCode ->
                editions.contains(editionCode) &&
                    StaticData.instance().getCardEdition(editionCode).isCardObtainable(card.getName())
        );
    }

    /**
     * Filters cards that are obtainable in any edition.
     */
    public static Predicate<PaperCard> isObtainableAnyEdition() {
        return card -> StaticData.instance().getCommonCards().getAllCards(card).stream()
            .map(PaperCard::getEdition).anyMatch(editionCode ->
                StaticData.instance().getCardEdition(editionCode).isCardObtainable(card.getName())
            );
    }

    /**
     * Returns a predicate that checks whether a card has at least one printing
     * in a non-restricted edition and that printing is obtainable.
     * @param restrictedEditionCodes Array of edition codes that are restricted.
     * @return Predicate
     */
    public static Predicate<PaperCard> isObtainableNotRestricted(final String[] restrictedEditionCodes) {
        Set<String> restrictedEditions = new HashSet<>(Arrays.asList(restrictedEditionCodes));

        return card -> StaticData.instance().getCommonCards()
            .getAllCards(card).stream()
            .map(PaperCard::getEdition)
            .anyMatch(editionCode ->
                !restrictedEditions.contains(editionCode) &&
                    StaticData.instance().getCardEdition(editionCode).isCardObtainable(card.getName())
        );
    }

    private static final class PredicatePrintedWithRarity implements Predicate<PaperCard> {
        private final CardRarity matchingRarity;

        @Override
        public boolean test(final PaperCard card) {
            return StaticData.instance().getEditions().stream()
                .anyMatch(ce -> {
                    List<EditionEntry> entries = ce.getCardInSet(card.getName());
                    return entries != null && entries.stream()
                        .anyMatch(ee -> ee.rarity() == matchingRarity);
                });
        }

        private PredicatePrintedWithRarity(final CardRarity rarity) {
            this.matchingRarity = rarity;
        }
    }

    private static final class PredicateColor implements Predicate<PaperCard> {
        private final MagicColor.Color operand;

        private PredicateColor(final MagicColor.Color color) {
            this.operand = color;
        }

        @Override
        public boolean test(final PaperCard card) {
            if (card.getRules().getColor().hasAnyColor(operand)) {
                return true;
            }
            if (card.getRules().getType().hasType(CardType.CoreType.Land) && card.getRules().getColorIdentity().hasAnyColor(operand)) {
                return true;
            }
            return false;
        }
    }

    private static final class PredicateFoil implements Predicate<PaperCard> {
        private final boolean operand;

        @Override
        public boolean test(final PaperCard card) { return card.isFoil() == operand; }

        private PredicateFoil(final boolean isFoil) {
            this.operand = isFoil;
        }
    }

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

    public static final class PredicateRarities implements Predicate<PaperCard> {
        private final HashSet<CardRarity> operand;

        @Override
        public boolean test(final PaperCard card) {
            return this.operand.contains(card.getRarity());
        }

        public PredicateRarities(CardRarity... rarities) {
            this.operand = new HashSet<>(Arrays.asList(rarities));
        }
    }

    private static final class PredicateSets implements Predicate<PaperCard> {
        private final Set<String> sets;
        private final boolean mustContain;

        @Override
        public boolean test(final PaperCard card) {
            return this.sets.contains(card.getEdition()) == this.mustContain &&
                StaticData.instance().getCardEdition(card.getEdition()).isCardObtainable(card.getName());
        }

        private PredicateSets(final List<String> wantSets, final boolean shouldContain) {
            this.sets = new TreeSet<>(String.CASE_INSENSITIVE_ORDER);
            this.sets.addAll(wantSets);
            this.mustContain = shouldContain;
        }
    }

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

    private static final class PredicateName extends PredicateString<PaperCard> {
        private final String operand;

        @Override
        public boolean test(final PaperCard card) {
            return this.op(card.getName(), this.operand);
        }

        private PredicateName(final String operand) {
            super(StringOp.EQUALS_IC);
            this.operand = operand;
        }
    }

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

    public static Predicate<PaperCard> fromRules(Predicate<CardRules> cardRulesPredicate) {
        return paperCard -> cardRulesPredicate.test(paperCard.getRules());
    }

    public static final Predicate<PaperCard> IS_COMMON = new PredicateRarity(CardRarity.Common);
    public static final Predicate<PaperCard> IS_UNCOMMON = new PredicateRarity(CardRarity.Uncommon);
    public static final Predicate<PaperCard> IS_RARE = new PredicateRarity(CardRarity.Rare);
    public static final Predicate<PaperCard> IS_MYTHIC_RARE = new PredicateRarity(CardRarity.MythicRare);
    public static final Predicate<PaperCard> IS_RARE_OR_MYTHIC = PaperCardPredicates.IS_RARE.or(PaperCardPredicates.IS_MYTHIC_RARE);
    public static final Predicate<PaperCard> IS_SPECIAL = new PredicateRarity(CardRarity.Special);
    public static final Predicate<PaperCard> IS_BASIC_LAND_RARITY = new PredicateRarity(CardRarity.BasicLand);
    public static final Predicate<PaperCard> IS_BLACK = new PredicateColor(MagicColor.Color.BLACK);
    public static final Predicate<PaperCard> IS_BLUE = new PredicateColor(MagicColor.Color.BLUE);
    public static final Predicate<PaperCard> IS_GREEN = new PredicateColor(MagicColor.Color.GREEN);
    public static final Predicate<PaperCard> IS_RED = new PredicateColor(MagicColor.Color.RED);
    public static final Predicate<PaperCard> IS_WHITE = new PredicateColor(MagicColor.Color.WHITE);
    public static final Predicate<PaperCard> IS_COLORLESS = paperCard -> paperCard.getRules().getColor().isColorless();
    public static final Predicate<PaperCard> IS_UNREBALANCED = PaperCard::isUnRebalanced;
    public static final Predicate<PaperCard> IS_REBALANCED = PaperCard::isRebalanced;

    //Common rules-based predicates.
    public static final Predicate<PaperCard> IS_LAND = fromRules(CardRulesPredicates.IS_LAND);
    public static final Predicate<PaperCard> IS_NON_LAND = fromRules(CardRulesPredicates.IS_NON_LAND);
    public static final Predicate<PaperCard> IS_BASIC_LAND = fromRules(CardRulesPredicates.IS_BASIC_LAND);
    /** Matches any card except Plains, Island, Swamp, Mountain, Forest, or Wastes. */
    public static final Predicate<PaperCard> NOT_BASIC_LAND = fromRules(CardRulesPredicates.NOT_BASIC_LAND);
    /** Matches any card except Plains, Island, Swamp, Mountain, or Forest. */
    public static final Predicate<PaperCard> NOT_TRUE_BASIC_LAND = fromRules(CardRulesPredicates.NOT_TRUE_BASIC_LAND);
    public static final Predicate<PaperCard> IS_NONBASIC_LAND = fromRules(CardRulesPredicates.IS_NONBASIC_LAND);
    public static final Predicate<PaperCard> IS_CREATURE = fromRules(CardRulesPredicates.IS_CREATURE);
    public static final Predicate<PaperCard> CAN_BE_COMMANDER = fromRules(CardRulesPredicates.CAN_BE_COMMANDER);
}
```

## Python
`forge/item/PaperCardPredicates.py`

```python
from forge.StaticData import StaticData
from forge.card.CardType import CardType
from forge.card.CardRulesPredicates import CardRulesPredicates
from forge.card.CardEdition.EditionEntry import EditionEntry
from forge.card.CardRarity import CardRarity
from forge.card.CardRules import CardRules
from forge.card.MagicColor import MagicColor
from forge.card.MagicColor.Color import Color
from forge.item.PaperCard import PaperCard
from forge.util.PredicateString import PredicateString
from forge.util.PredicateString.StringOp import StringOp


class PaperCardPredicates:
    """Filters based on PaperCard values."""

    @staticmethod
    def printedInSets(value, shouldContain=True):
        if (value is None) or len(value) == 0:
            return lambda x: True
        return PaperCardPredicates.PredicateSets(list(value), shouldContain)

    @staticmethod
    def printedInSet(value):
        if not value:
            return lambda x: True
        return PaperCardPredicates.PredicateSets([value], True)

    @staticmethod
    def printedWithRarity(rarity):
        return PaperCardPredicates.PredicatePrintedWithRarity(rarity)

    @staticmethod
    def searchableName(op, what):
        return PaperCardPredicates.PredicateSearchableName(op, what)

    @staticmethod
    def name(what):
        return PaperCardPredicates.PredicateName(what)

    @staticmethod
    def names(what):
        return PaperCardPredicates.PredicateNames(what)

    @staticmethod
    def isFoil(isFoil):
        """Filters on a card foil status"""
        return PaperCardPredicates.PredicateFoil(isFoil)

    @staticmethod
    def printedInAnyEditions(editionCodes):
        """Filters cards that were printed in any of the specified editions."""
        editions = set(editionCodes)

        def predicate(card):
            return any(
                editionCode in editions and
                StaticData.instance().getCardEdition(editionCode).isCardObtainable(card.getName())
                for editionCode in (
                    pc.getEdition()
                    for pc in StaticData.instance().getCommonCards().getAllCards(card)
                )
            )
        return predicate

    @staticmethod
    def onlyPrintedInEditions(editionCodes):
        """Filters cards that were only printed in any of the specified editions."""
        editions = set(editionCodes)

        def predicate(card):
            return all(
                editionCode in editions and
                StaticData.instance().getCardEdition(editionCode).isCardObtainable(card.getName())
                for editionCode in (
                    pc.getEdition()
                    for pc in StaticData.instance().getCommonCards().getAllCards(card)
                )
            )
        return predicate

    @staticmethod
    def isObtainableAnyEdition():
        """Filters cards that are obtainable in any edition."""
        def predicate(card):
            return any(
                StaticData.instance().getCardEdition(editionCode).isCardObtainable(card.getName())
                for editionCode in (
                    pc.getEdition()
                    for pc in StaticData.instance().getCommonCards().getAllCards(card)
                )
            )
        return predicate

    @staticmethod
    def isObtainableNotRestricted(restrictedEditionCodes):
        """
        Returns a predicate that checks whether a card has at least one printing
        in a non-restricted edition and that printing is obtainable.
        """
        restrictedEditions = set(restrictedEditionCodes)

        def predicate(card):
            return any(
                editionCode not in restrictedEditions and
                StaticData.instance().getCardEdition(editionCode).isCardObtainable(card.getName())
                for editionCode in (
                    pc.getEdition()
                    for pc in StaticData.instance().getCommonCards().getAllCards(card)
                )
            )
        return predicate

    class PredicatePrintedWithRarity:
        def __init__(self, rarity):
            self.matchingRarity = rarity

        def test(self, card):
            for ce in StaticData.instance().getEditions():
                entries = ce.getCardInSet(card.getName())
                if entries is not None and any(ee.rarity() == self.matchingRarity for ee in entries):
                    return True
            return False

    class PredicateColor:
        def __init__(self, color):
            self.operand = color

        def test(self, card):
            if card.getRules().getColor().hasAnyColor(self.operand):
                return True
            if card.getRules().getType().hasType(CardType.CoreType.Land) and card.getRules().getColorIdentity().hasAnyColor(self.operand):
                return True
            return False

    class PredicateFoil:
        def __init__(self, isFoil):
            self.operand = isFoil

        def test(self, card):
            return card.isFoil() == self.operand

    class PredicateRarity:
        def __init__(self, rarity):
            self.operand = rarity

        def test(self, card):
            return card.getRarity() == self.operand

    class PredicateRarities:
        def __init__(self, *rarities):
            self.operand = set(rarities)

        def test(self, card):
            return card.getRarity() in self.operand

    class PredicateSets:
        def __init__(self, wantSets, shouldContain):
            # TreeSet(String.CASE_INSENSITIVE_ORDER): case-insensitive membership.
            self.sets = set(s.lower() for s in wantSets)
            self.mustContain = shouldContain

        def test(self, card):
            return (card.getEdition().lower() in self.sets) == self.mustContain and \
                StaticData.instance().getCardEdition(card.getEdition()).isCardObtainable(card.getName())

    class PredicateSearchableName(PredicateString):
        def __init__(self, operator, operand):
            super().__init__(operator)
            self.operand = operand

        def test(self, paperCard):
            return any(self.op(name, self.operand) for name in paperCard.getAllSearchableNames())

    class PredicateName(PredicateString):
        def __init__(self, operand):
            super().__init__(StringOp.EQUALS_IC)
            self.operand = operand

        def test(self, card):
            return self.op(card.getName(), self.operand)

    class PredicateNames(PredicateString):
        def __init__(self, operand):
            super().__init__(StringOp.EQUALS)
            self.operand = operand

        def test(self, card):
            cardName = card.getName()
            for element in self.operand:
                if self.op(cardName, element):
                    return True
            return False

    @staticmethod
    def fromRules(cardRulesPredicate):
        return lambda paperCard: cardRulesPredicate.test(paperCard.getRules())


PaperCardPredicates.IS_COMMON = PaperCardPredicates.PredicateRarity(CardRarity.Common)
PaperCardPredicates.IS_UNCOMMON = PaperCardPredicates.PredicateRarity(CardRarity.Uncommon)
PaperCardPredicates.IS_RARE = PaperCardPredicates.PredicateRarity(CardRarity.Rare)
PaperCardPredicates.IS_MYTHIC_RARE = PaperCardPredicates.PredicateRarity(CardRarity.MythicRare)
PaperCardPredicates.IS_RARE_OR_MYTHIC = (lambda card: PaperCardPredicates.IS_RARE.test(card) or PaperCardPredicates.IS_MYTHIC_RARE.test(card))
PaperCardPredicates.IS_SPECIAL = PaperCardPredicates.PredicateRarity(CardRarity.Special)
PaperCardPredicates.IS_BASIC_LAND_RARITY = PaperCardPredicates.PredicateRarity(CardRarity.BasicLand)
PaperCardPredicates.IS_BLACK = PaperCardPredicates.PredicateColor(MagicColor.Color.BLACK)
PaperCardPredicates.IS_BLUE = PaperCardPredicates.PredicateColor(MagicColor.Color.BLUE)
PaperCardPredicates.IS_GREEN = PaperCardPredicates.PredicateColor(MagicColor.Color.GREEN)
PaperCardPredicates.IS_RED = PaperCardPredicates.PredicateColor(MagicColor.Color.RED)
PaperCardPredicates.IS_WHITE = PaperCardPredicates.PredicateColor(MagicColor.Color.WHITE)
PaperCardPredicates.IS_COLORLESS = (lambda paperCard: paperCard.getRules().getColor().isColorless())
PaperCardPredicates.IS_UNREBALANCED = (lambda paperCard: paperCard.isUnRebalanced())
PaperCardPredicates.IS_REBALANCED = (lambda paperCard: paperCard.isRebalanced())

# Common rules-based predicates.
PaperCardPredicates.IS_LAND = PaperCardPredicates.fromRules(CardRulesPredicates.IS_LAND)
PaperCardPredicates.IS_NON_LAND = PaperCardPredicates.fromRules(CardRulesPredicates.IS_NON_LAND)
PaperCardPredicates.IS_BASIC_LAND = PaperCardPredicates.fromRules(CardRulesPredicates.IS_BASIC_LAND)
# Matches any card except Plains, Island, Swamp, Mountain, Forest, or Wastes.
PaperCardPredicates.NOT_BASIC_LAND = PaperCardPredicates.fromRules(CardRulesPredicates.NOT_BASIC_LAND)
# Matches any card except Plains, Island, Swamp, Mountain, or Forest.
PaperCardPredicates.NOT_TRUE_BASIC_LAND = PaperCardPredicates.fromRules(CardRulesPredicates.NOT_TRUE_BASIC_LAND)
PaperCardPredicates.IS_NONBASIC_LAND = PaperCardPredicates.fromRules(CardRulesPredicates.IS_NONBASIC_LAND)
PaperCardPredicates.IS_CREATURE = PaperCardPredicates.fromRules(CardRulesPredicates.IS_CREATURE)
PaperCardPredicates.CAN_BE_COMMANDER = PaperCardPredicates.fromRules(CardRulesPredicates.CAN_BE_COMMANDER)
```
