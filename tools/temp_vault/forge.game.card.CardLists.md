---
aliases:
  - CardLists
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/card
fqn: forge.game.card.CardLists
package: forge.game.card
module: forge-game
kind: Class
---

# CardLists

**Package:** `forge.game.card` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class CardLists {
        +Comparator~Card~ ToughnessComparator
        +Comparator~Card~ ToughnessComparatorInv
        +Comparator~Card~ PowerComparator
        +Comparator~Card~ CmcComparator
        +Comparator~Card~ CmcComparatorInv
        +Comparator~Card~ TextLenComparator
        +filterToughness(Iterable~Card~ in, int atLeastToughness) CardCollection
        +filterPower(Iterable~Card~ in, int atLeastPower) CardCollection
        +filterLEPower(Iterable~Card~ in, int lessthanPower) CardCollection
        +filterAnyCounters(Iterable~Card~ in, int atLeastCounters) CardCollection
        +sortByCmcDesc(List~Card~ list) void
        +sortByToughnessAsc(List~Card~ list) void
        +sortByToughnessDesc(List~Card~ list) void
        +sortByPowerAsc(List~Card~ list) void
        +sortByPowerDesc(List~Card~ list) void
        +getRandomSubList(List~Card~ c, int amount) CardCollection
        +shuffle(List~Card~ list) void
        +filterControlledBy(Iterable~Card~ cardList, Player player) CardCollection
        +filterControlledBy(Iterable~Card~ cardList, FCollectionView~Player~ player) CardCollection
        +filterControlledByAsList(Iterable~Card~ cardList, Player player) List~Card~
        +filterControlledByAsList(Iterable~Card~ cardList, FCollectionView~Player~ player) List~Card~
        +getValidCards(Iterable~Card~ cardList, String[] restrictions, Player sourceController, Card source, CardTraitBase spellAbility) CardCollection
        +getValidCards(Iterable~Card~ cardList, String restriction, Player sourceController, Card source, CardTraitBase sa) CardCollection
        +getValidCardsAsList(Iterable~Card~ cardList, String restriction, Player sourceController, Card source, CardTraitBase sa) List~Card~
        +getValidCardCount(Iterable~Card~ cardList, String restriction, Player sourceController, Card source, CardTraitBase sa) int
        +getTargetableCards(Iterable~Card~ cardList, SpellAbility source) CardCollection
        +canSubsequentlyTarget(CardCollection list, SpellAbility source) CardCollection
        +getKeyword(Iterable~Card~ cardList, String keyword) CardCollection
        +getKeyword(Iterable~Card~ cardList, Keyword keyword) CardCollection
        +getNotKeyword(Iterable~Card~ cardList, String keyword) CardCollection
        +getNotKeyword(Iterable~Card~ cardList, Keyword keyword) CardCollection
        +getAmountOfKeyword(Iterable~Card~ cardList, String keyword) int
        +getAmountOfKeyword(Iterable~Card~ cardList, Keyword keyword) int
        +getNotType(Iterable~Card~ cardList, String cardType) CardCollection
        +getType(Iterable~Card~ cardList, String cardType) CardCollection
        +getNotColor(Iterable~Card~ cardList, byte color) CardCollection
        +getColor(Iterable~Card~ cardList, byte color) CardCollection
        +filter(Iterable~Card~ cardList, Predicate~Card~ filt) CardCollection
        +filter(Iterable~Card~ cardList, Predicate~Card~ f1, Predicate~Card~ f2) CardCollection
        +filter(Iterable~Card~ cardList, Iterable~Predicate~ filt) CardCollection
        +filterAsList(Iterable~Card~ cardList, Predicate~Card~ filt) List~Card~
        +filterAsList(Iterable~Card~ cardList, Predicate~Card~ f1, Predicate~Card~ f2) List~Card~
        +filterAsList(Iterable~Card~ cardList, Iterable~Predicate~ filt) List~Card~
        +count(Iterable~Card~ cardList, Predicate~Card~ filt) int
        +getCardsWithHighestCMC(Iterable~Card~ cardList) CardCollection
        +getCardsWithLowestCMC(Iterable~Card~ cardList) CardCollection
        +getTotalPower(Iterable~Card~ cardList, CardTraitBase ctb) int
        +getTotalChroma(Iterable~Card~ cardList, byte colorCode) int
        +getTotalCMC(Iterable~Card~ cardList) int
        +cmcCanSumTo(int sum, Iterable~Card~ cardList) boolean
        +isSubsetSum(List~Integer~ numList, int sum) boolean
        +getDifferentNamesCount(Iterable~Card~ cardList) int
    }
    CardLists ..> Card : uses
    CardLists ..> CardCollection : uses
    CardLists ..> CardTraitBase : uses
    CardLists ..> FCollectionView : uses
    CardLists ..> Keyword : uses
    CardLists ..> ManaCostShard : uses
    CardLists ..> Player : uses
    CardLists ..> SpellAbility : uses
    CardLists ..> TargetRestrictions : uses
```

## Relationships
**Uses:**
- [[forge.card.mana.ManaCostShard|ManaCostShard]]
- [[forge.game.CardTraitBase|CardTraitBase]]
- [[forge.game.card.Card|Card]]
- [[forge.game.card.CardCollection|CardCollection]]
- [[forge.game.keyword.Keyword|Keyword]]
- [[forge.game.player.Player|Player]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]
- [[forge.game.spellability.TargetRestrictions|TargetRestrictions]]
- [[forge.util.collect.FCollectionView|FCollectionView]]

## Design Description

CardLists is a stateless utility class providing static helpers for querying, filtering, sorting, and aggregating collections of `Card` objects. It centralizes the common list operations the game engine needsâ€”filtering by power/toughness, controller, color, type, keyword, or game-rule validity; ranking via reusable `Comparator<Card>` constants; computing aggregates such as total power, CMC, and chroma; and answering combinatorial questions like subset-sum over mana values.

Rather than subclassing any collection type, it operates on `Iterable<Card>` inputs and typically returns `CardCollection` (or plain `List<Card>` variants for cases needing duplicates), delegating predicate construction to `CardPredicates` and collaborating with engine types like `Player`, `SpellAbility`, `CardTraitBase`, `Keyword`, and `TargetRestrictions`. The design intent is a single, reusable filtering vocabularyâ€”built atop generic `Predicate<Card>` compositionâ€”so callers across the engine express card selection declaratively instead of hand-writing loops.

## Source
`forge-game/src/main/java/forge/game/card/CardLists.java`

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
package forge.game.card;

import com.google.common.collect.Lists;
import forge.card.mana.ManaCostShard;
import forge.game.CardTraitBase;
import forge.game.keyword.Keyword;
import forge.game.player.Player;
import forge.game.spellability.SpellAbility;
import forge.game.spellability.TargetRestrictions;
import forge.game.staticability.StaticAbilityTapPowerValue;
import forge.util.IterableUtil;
import forge.util.MyRandom;
import forge.util.StreamUtil;
import forge.util.collect.FCollectionView;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.function.Predicate;
import java.util.stream.Collector;
import java.util.stream.Collectors;

/**
 * <p>
 * CardListUtil class.
 * </p>
 * 
 * @author Forge
 * @version $Id$
 */
public class CardLists {
    /**
     * <p>
     * filterToughness.
     * </p>
     *
     * @param atLeastToughness
     *            a int.
     * @return a CardCollection
     */
    public static CardCollection filterToughness(final Iterable<Card> in, final int atLeastToughness) {
        return CardLists.filter(in, c -> c.getNetToughness() <= atLeastToughness);
    }

    public static CardCollection filterPower(final Iterable<Card> in, final int atLeastPower) {
        return CardLists.filter(in, c -> c.getNetPower() >= atLeastPower);
    }

    public static CardCollection filterLEPower(final Iterable<Card> in, final int lessthanPower) {
        return CardLists.filter(in, c -> c.getNetPower() <= lessthanPower);
    }

    public static CardCollection filterAnyCounters(final Iterable<Card> in, final int atLeastCounters) {
        return CardLists.filter(in, c -> c.getNumAllCounters() >= atLeastCounters);
    }

    public static final Comparator<Card> ToughnessComparator = Comparator.comparingInt(Card::getNetToughness);
    public static final Comparator<Card> ToughnessComparatorInv = Comparator.comparingInt(Card::getNetToughness).reversed();
    public static final Comparator<Card> PowerComparator = Comparator.comparingInt(Card::getNetCombatDamage);
    public static final Comparator<Card> CmcComparator = Comparator.comparingInt(Card::getCMC);
    public static final Comparator<Card> CmcComparatorInv = Comparator.<Card>comparingInt(Card::getCMC).reversed();

    public static final Comparator<Card> TextLenComparator = Comparator.comparingInt(a -> a.getView().getText().length());

    /**
     * <p>
     * Sorts a CardCollection from highest converted mana cost to lowest.
     * </p>
     * 
     * @param list
     */
    public static void sortByCmcDesc(final List<Card> list) {
        list.sort(CmcComparatorInv);
    }

    /**
     * <p>
     * sortByToughnessAsc
     * </p>
     * 
     * @param list
     */
    public static void sortByToughnessAsc(final List<Card> list) {
        list.sort(ToughnessComparator);
    }

    /**
     * <p>
     * sortByToughnessDesc
     * </p>
     * 
     * @param list
     */
    public static void sortByToughnessDesc(final List<Card> list) {
        list.sort(ToughnessComparatorInv);
    }

    /**
     * <p>
     * sortAttackLowFirst.
     * </p>
     * 
     * @param list
     */
    public static void sortByPowerAsc(final List<Card> list) {
        list.sort(PowerComparator);
    }

    // the higher the attack the better
    /**
     * <p>
     * sortAttack.
     * </p>
     * 
     * @param list
     */
    public static void sortByPowerDesc(final List<Card> list) {
        list.sort(Collections.reverseOrder(PowerComparator));
    }

    /**
     * 
     * Given a CardCollection c, return a CardCollection that contains a random amount of cards from c.
     * 
     * @param c
     *            CardList
     * @param amount
     *            int
     * @return CardList
     */
    public static CardCollection getRandomSubList(final List<Card> c, final int amount) {
        if (c.size() < amount) {
            return null;
        }

        final CardCollection cs = new CardCollection(c);
        final CardCollection subList = new CardCollection();
        while (subList.size() < amount) {
            CardLists.shuffle(cs);
            subList.add(cs.remove(0));
        }
        return subList;
    }

    public static void shuffle(List<Card> list) {
        Collections.shuffle(list, MyRandom.getRandom());
    }

    public static CardCollection filterControlledBy(Iterable<Card> cardList, Player player) {
        return CardLists.filter(cardList, CardPredicates.isController(player));
    }

    public static CardCollection filterControlledBy(Iterable<Card> cardList, FCollectionView<Player> player) {
        return CardLists.filter(cardList, CardPredicates.isControlledByAnyOf(player));
    }

    public static List<Card> filterControlledByAsList(Iterable<Card> cardList, Player player) {
        return CardLists.filterAsList(cardList, CardPredicates.isController(player));
    }

    public static List<Card> filterControlledByAsList(Iterable<Card> cardList, FCollectionView<Player> player) {
        return CardLists.filterAsList(cardList, CardPredicates.isControlledByAnyOf(player));
    }

    public static CardCollection getValidCards(Iterable<Card> cardList, String[] restrictions, Player sourceController, Card source, CardTraitBase spellAbility) {
        return CardLists.filter(cardList, CardPredicates.restriction(restrictions, sourceController, source, spellAbility));
    }

    public static CardCollection getValidCards(Iterable<Card> cardList, String restriction, Player sourceController, Card source, CardTraitBase sa) {
        return CardLists.filter(cardList, CardPredicates.restriction(restriction.split(","), sourceController, source, sa));
    }

    public static List<Card> getValidCardsAsList(Iterable<Card> cardList, String restriction, Player sourceController, Card source, CardTraitBase sa) {
        return CardLists.filterAsList(cardList, CardPredicates.restriction(restriction.split(","), sourceController, source, sa));
    }

    public static int getValidCardCount(Iterable<Card> cardList, String restriction, Player sourceController, Card source, CardTraitBase sa) {
        return CardLists.count(cardList, CardPredicates.restriction(restriction.split(","), sourceController, source, sa));
    }

    public static CardCollection getTargetableCards(Iterable<Card> cardList, SpellAbility source) {
        final CardCollection result = CardLists.filter(cardList, CardPredicates.isTargetableBy(source));
        // Filter more cards that can only be detected along with other candidates
        if (source.getTargets().isEmpty() && source.usesTargeting() && source.getMinTargets() >= 2) {
            CardCollection removeList = new CardCollection();
            TargetRestrictions tr = source.getTargetRestrictions();
            for (final Card card : result) {
                if (tr.isSameController()) {
                    boolean found = false;
                    for (final Card card2 : result) {
                        if (card != card2 && card.getController() == card2.getController()) {
                            found = true;
                            break;
                        }
                    }
                    if (!found) {
                        removeList.add(card);
                    }
                }

                if (tr.isWithoutSameCreatureType()) {
                    boolean found = false;
                    for (final Card card2 : result) {
                        if (card != card2 && !card.sharesCreatureTypeWith(card2)) {
                            found = true;
                            break;
                        }
                    }
                    if (!found) {
                        removeList.add(card);
                    }
                }

                if (tr.isWithSameCreatureType()) {
                    boolean found = false;
                    for (final Card card2 : result) {
                        if (card != card2 && card.sharesCreatureTypeWith(card2)) {
                            found = true;
                            break;
                        }
                    }
                    if (!found) {
                        removeList.add(card);
                    }
                }

                if (tr.isWithSameCardType()) {
                    boolean found = false;
                    for (final Card card2 : result) {
                        if (card != card2 && card.sharesCardTypeWith(card2)) {
                            found = true;
                            break;
                        }
                    }
                    if (!found) {
                        removeList.add(card);
                    }
                }
            }
            result.removeAll(removeList);
        }
        return result;
    }

    public static CardCollection canSubsequentlyTarget(CardCollection list, SpellAbility source) {
        if (source.getTargets().isEmpty()) {
            return list;
        }

        return CardLists.filter(list, source::canTarget);
    }

    public static CardCollection getKeyword(Iterable<Card> cardList, final String keyword) {
        return CardLists.filter(cardList, CardPredicates.hasKeyword(keyword));
    }

    public static CardCollection getKeyword(Iterable<Card> cardList, final Keyword keyword) {
        return CardLists.filter(cardList, CardPredicates.hasKeyword(keyword));
    }

    public static CardCollection getNotKeyword(Iterable<Card> cardList, String keyword) {
        return CardLists.filter(cardList, CardPredicates.hasKeyword(keyword).negate());
    }

    public static CardCollection getNotKeyword(Iterable<Card> cardList, final Keyword keyword) {
        return CardLists.filter(cardList, CardPredicates.hasKeyword(keyword).negate());
    }

    public static int getAmountOfKeyword(final Iterable<Card> cardList, final String keyword) {
        int nKeyword = 0;
        for (final Card c : cardList) {
            nKeyword += c.getAmountOfKeyword(keyword);
        }
        return nKeyword;
    }
    public static int getAmountOfKeyword(final Iterable<Card> cardList, final Keyword keyword) {
        int nKeyword = 0;
        for (final Card c : cardList) {
            nKeyword += c.getAmountOfKeyword(keyword);
        }
        return nKeyword;
    }
    // cardType is like "Land" or "Goblin", returns a new CardCollection that is a
    // subset of current CardList
    public static CardCollection getNotType(Iterable<Card> cardList, String cardType) {
        return CardLists.filter(cardList, CardPredicates.isType(cardType).negate());
    }

    public static CardCollection getType(Iterable<Card> cardList, String cardType) {
        return CardLists.filter(cardList, CardPredicates.isType(cardType));
    }

    public static CardCollection getNotColor(Iterable<Card> cardList, byte color) {
        return CardLists.filter(cardList, CardPredicates.isColor(color).negate());
    }

    public static CardCollection getColor(Iterable<Card> cardList, byte color) {
        return CardLists.filter(cardList, CardPredicates.isColor(color));
    }

    /**
     * Create a new list of cards by applying a filter to this one.
     * 
     * @param filt
     *            determines which cards are present in the resulting list
     * 
     * @return a subset of this CardCollection whose items meet the filtering
     *         criteria; may be empty, but never null.
     */
    public static CardCollection filter(Iterable<Card> cardList, Predicate<Card> filt) {
        return new CardCollection(IterableUtil.filter(cardList, filt));
    }

    public static CardCollection filter(Iterable<Card> cardList, Predicate<Card> f1, Predicate<Card> f2) {
        return new CardCollection(IterableUtil.filter(cardList, f1.and(f2)));
    }

    public static CardCollection filter(Iterable<Card> cardList, Iterable<Predicate<Card>> filt) {
        return new CardCollection(IterableUtil.filter(cardList, IterableUtil.and(filt)));
    }

    /**
     * Create a new list of cards by applying a filter to this one.
     * (this version of filter returns an ArrayList which may contain duplicate elements, used
     * by methods that count spells cast this turn/last turn through their card object representations)
     * 
     * @param filt
     *            determines which cards are present in the resulting list
     * 
     * @return an ArrayList subset of this CardCollection whose items meet the filtering
     *         criteria; may be empty, but never null.
     */
    public static List<Card> filterAsList(Iterable<Card> cardList, Predicate<Card> filt) {
        return Lists.newArrayList(IterableUtil.filter(cardList, filt));
    }

    public static List<Card> filterAsList(Iterable<Card> cardList, Predicate<Card> f1, Predicate<Card> f2) {
        return Lists.newArrayList(IterableUtil.filter(cardList, f1.and(f2)));
    }

    public static List<Card> filterAsList(Iterable<Card> cardList, Iterable<Predicate<Card>> filt) {
        return Lists.newArrayList(IterableUtil.filter(cardList, IterableUtil.and(filt)));
    }

    public static int count(Iterable<Card> cardList, Predicate<Card> filt) {
        if (cardList == null) { return 0; }

        int count = 0;
        for (Card c : cardList) {
            if (filt.test(c)) {
                count++;
            }
        }
        return count;
    }

    /**
     * Given a CardCollection cardList, return a CardCollection that are tied for having the highest CMC.
     * 
     * @param cardList          the Card List to be filtered.
     * @return the list of Cards sharing the highest CMC.
     */
    public static CardCollection getCardsWithHighestCMC(Iterable<Card> cardList) {
        final CardCollection tiedForHighest = new CardCollection();
        int highest = 0;
        for (final Card crd : cardList) {
            // do not check for Split Card anymore
            int curCmc = crd.getCMC();

            if (curCmc > highest) {
                highest = curCmc;
                tiedForHighest.clear();
            }
            if (curCmc >= highest) {
                tiedForHighest.add(crd);
            }
        }
        return tiedForHighest;
    }

    /**
     * Given a CardCollection cardList, return a CardCollection that are tied for having the lowest CMC.
     * 
     * @param cardList          the Card List to be filtered.
     * @return the list of Cards sharing the lowest CMC.
     */
    public static CardCollection getCardsWithLowestCMC(Iterable<Card> cardList) {
        final CardCollection tiedForLowest = new CardCollection();
        int lowest = 25;
        for (final Card crd : cardList) {
            // do not check for Split Card anymore
            int curCmc = crd.getCMC();

            if (curCmc < lowest) {
                lowest = curCmc;
                tiedForLowest.clear();
            }
            if (curCmc <= lowest) {
                tiedForLowest.add(crd);
            }
        }
        return tiedForLowest;
    }

    /**
     * Given a list of cards, return their combined power
     * 
     * @param cardList the list of creature cards for which to sum the power
     */
    public static int getTotalPower(Iterable<Card> cardList, CardTraitBase ctb) {
        int total = 0;
        for (final Card crd : cardList) {
            if (StaticAbilityTapPowerValue.withToughness(crd, ctb)) {
                total += Math.max(0, crd.getNetToughness());
            } else {
                int m = StaticAbilityTapPowerValue.getMod(crd, ctb);
                total += Math.max(0, crd.getNetPower() + m);
            }
        }
        return total;
    }

    public static int getTotalChroma(Iterable<Card> cardList, byte colorCode) {
        int colorOcurrencices = 0;
        for (Card c0 : cardList) {
            for (ManaCostShard sh : c0.getManaCost()) {
                if (sh.isColor(colorCode))
                    colorOcurrencices++;
            }
        }
        return colorOcurrencices;
    }

    /**
     * Given a list of cards, return their combined mana value
     *
     * @param cardList the list of cards for which to sum the mana value
     */
    public static int getTotalCMC(Iterable<Card> cardList) {
        int total = 0;
        for (final Card crd : cardList) {
            total += Math.max(0, crd.getCMC());
        }
        return total;
    }

    public static boolean cmcCanSumTo(int sum, Iterable<Card> cardList) {
        List<Integer> numList = Lists.newArrayList();
        for (final Card c : cardList) {
            int num = c.getCMC();
            if (num == sum) return true;
            else if (num < sum) numList.add(num);
        }
        if (numList.isEmpty()) return false;
        numList.sort(null);

        return isSubsetSum(numList, sum);
    }

    public static boolean isSubsetSum(List<Integer> numList, int sum) {
        if (sum == 0) return true;
        int size = numList.size();
        if (size == 0) return false;

        Integer last = numList.get(size - 1);
        numList.remove(last);
        // If last element is greater than sum, then ignore it
        if (last > sum) {
            return isSubsetSum(numList, sum);
        }

        // Else, check if sum can be obtained by:
        // (a) excluding the last element
        // (b) including the last element
        return isSubsetSum(numList, sum) || isSubsetSum(numList, sum - last);
    }

    public static int getDifferentNamesCount(Iterable<Card> cardList) {
        // first part the ones with SpyKit, and already collect them via
        Map<Boolean, List<Card>> parted = StreamUtil.stream(cardList).collect(Collectors
                .partitioningBy(Card::hasNonLegendaryCreatureNames, Collector.of(ArrayList::new, (list, c) -> {
                    if (!c.hasNoName() && list.stream().noneMatch(c2 -> c.sharesNameWith(c2))) {
                        list.add(c);
                    }
                }, (l1, l2) -> {
                    l1.addAll(l2);
                    return l1;
                })));
        List<Card> preList = parted.get(Boolean.FALSE);

        // then try to apply the SpyKit ones
        for (Card c : parted.get(Boolean.TRUE)) {
            if (preList.stream().noneMatch(c2 -> c.sharesNameWith(c2))) {
                preList.add(c);
            }
        }
        return preList.size();
    }
}
```

## Python
`forge/game/card/CardLists.py`

```python
from forge.card.mana.ManaCostShard import ManaCostShard
from forge.game.CardTraitBase import CardTraitBase
from forge.game.card.Card import Card
from forge.game.card.CardCollection import CardCollection
from forge.game.card.CardPredicates import CardPredicates
from forge.game.keyword.Keyword import Keyword
from forge.game.player.Player import Player
from forge.game.spellability.SpellAbility import SpellAbility
from forge.game.spellability.TargetRestrictions import TargetRestrictions
from forge.game.staticability.StaticAbilityTapPowerValue import StaticAbilityTapPowerValue
from forge.util.IterableUtil import IterableUtil
from forge.util.MyRandom import MyRandom
from forge.util.StreamUtil import StreamUtil
from forge.util.collect.FCollectionView import FCollectionView

import functools
from typing import Iterable, List


def _compare_ints(x: int, y: int) -> int:
    return (x > y) - (x < y)


class CardLists:
    """
    CardListUtil class.

    Stateless utility class providing static helpers for querying, filtering,
    sorting, and aggregating collections of Card objects.

    @author Forge
    """

    @staticmethod
    def filterToughness(in_: Iterable[Card], atLeastToughness: int) -> CardCollection:
        return CardLists.filter(in_, lambda c: c.getNetToughness() <= atLeastToughness)

    @staticmethod
    def filterPower(in_: Iterable[Card], atLeastPower: int) -> CardCollection:
        return CardLists.filter(in_, lambda c: c.getNetPower() >= atLeastPower)

    @staticmethod
    def filterLEPower(in_: Iterable[Card], lessthanPower: int) -> CardCollection:
        return CardLists.filter(in_, lambda c: c.getNetPower() <= lessthanPower)

    @staticmethod
    def filterAnyCounters(in_: Iterable[Card], atLeastCounters: int) -> CardCollection:
        return CardLists.filter(in_, lambda c: c.getNumAllCounters() >= atLeastCounters)

    ToughnessComparator = functools.cmp_to_key(
        lambda a, b: _compare_ints(a.getNetToughness(), b.getNetToughness()))
    ToughnessComparatorInv = functools.cmp_to_key(
        lambda a, b: _compare_ints(b.getNetToughness(), a.getNetToughness()))
    PowerComparator = functools.cmp_to_key(
        lambda a, b: _compare_ints(a.getNetCombatDamage(), b.getNetCombatDamage()))
    CmcComparator = functools.cmp_to_key(
        lambda a, b: _compare_ints(a.getCMC(), b.getCMC()))
    CmcComparatorInv = functools.cmp_to_key(
        lambda a, b: _compare_ints(b.getCMC(), a.getCMC()))

    TextLenComparator = functools.cmp_to_key(
        lambda a, b: _compare_ints(len(a.getView().getText()), len(b.getView().getText())))

    @staticmethod
    def sortByCmcDesc(list: List[Card]) -> None:
        list.sort(key=CardLists.CmcComparatorInv)

    @staticmethod
    def sortByToughnessAsc(list: List[Card]) -> None:
        list.sort(key=CardLists.ToughnessComparator)

    @staticmethod
    def sortByToughnessDesc(list: List[Card]) -> None:
        list.sort(key=CardLists.ToughnessComparatorInv)

    @staticmethod
    def sortByPowerAsc(list: List[Card]) -> None:
        list.sort(key=CardLists.PowerComparator)

    # the higher the attack the better
    @staticmethod
    def sortByPowerDesc(list: List[Card]) -> None:
        list.sort(key=CardLists.PowerComparator, reverse=True)

    @staticmethod
    def getRandomSubList(c: List[Card], amount: int) -> CardCollection:
        if len(c) < amount:
            return None

        cs = CardCollection(c)
        subList = CardCollection()
        while subList.size() < amount:
            CardLists.shuffle(cs)
            subList.add(cs.remove(0))
        return subList

    @staticmethod
    def shuffle(list: List[Card]) -> None:
        MyRandom.getRandom().shuffle(list)

    @staticmethod
    def filterControlledBy(cardList: Iterable[Card], player) -> CardCollection:
        if isinstance(player, Player):
            return CardLists.filter(cardList, CardPredicates.isController(player))
        return CardLists.filter(cardList, CardPredicates.isControlledByAnyOf(player))

    @staticmethod
    def filterControlledByAsList(cardList: Iterable[Card], player) -> List[Card]:
        if isinstance(player, Player):
            return CardLists.filterAsList(cardList, CardPredicates.isController(player))
        return CardLists.filterAsList(cardList, CardPredicates.isControlledByAnyOf(player))

    @staticmethod
    def getValidCards(cardList: Iterable[Card], restrictions, sourceController: Player, source: Card, spellAbility: CardTraitBase) -> CardCollection:
        if isinstance(restrictions, str):
            restrictions = restrictions.split(",")
        return CardLists.filter(cardList, CardPredicates.restriction(restrictions, sourceController, source, spellAbility))

    @staticmethod
    def getValidCardsAsList(cardList: Iterable[Card], restriction: str, sourceController: Player, source: Card, sa: CardTraitBase) -> List[Card]:
        return CardLists.filterAsList(cardList, CardPredicates.restriction(restriction.split(","), sourceController, source, sa))

    @staticmethod
    def getValidCardCount(cardList: Iterable[Card], restriction: str, sourceController: Player, source: Card, sa: CardTraitBase) -> int:
        return CardLists.count(cardList, CardPredicates.restriction(restriction.split(","), sourceController, source, sa))

    @staticmethod
    def getTargetableCards(cardList: Iterable[Card], source: SpellAbility) -> CardCollection:
        result = CardLists.filter(cardList, CardPredicates.isTargetableBy(source))
        # Filter more cards that can only be detected along with other candidates
        if source.getTargets().isEmpty() and source.usesTargeting() and source.getMinTargets() >= 2:
            removeList = CardCollection()
            tr = source.getTargetRestrictions()
            for card in result:
                if tr.isSameController():
                    found = False
                    for card2 in result:
                        if card != card2 and card.getController() == card2.getController():
                            found = True
                            break
                    if not found:
                        removeList.add(card)

                if tr.isWithoutSameCreatureType():
                    found = False
                    for card2 in result:
                        if card != card2 and not card.sharesCreatureTypeWith(card2):
                            found = True
                            break
                    if not found:
                        removeList.add(card)

                if tr.isWithSameCreatureType():
                    found = False
                    for card2 in result:
                        if card != card2 and card.sharesCreatureTypeWith(card2):
                            found = True
                            break
                    if not found:
                        removeList.add(card)

                if tr.isWithSameCardType():
                    found = False
                    for card2 in result:
                        if card != card2 and card.sharesCardTypeWith(card2):
                            found = True
                            break
                    if not found:
                        removeList.add(card)
            result.removeAll(removeList)
        return result

    @staticmethod
    def canSubsequentlyTarget(list: CardCollection, source: SpellAbility) -> CardCollection:
        if source.getTargets().isEmpty():
            return list

        return CardLists.filter(list, source.canTarget)

    @staticmethod
    def getKeyword(cardList: Iterable[Card], keyword) -> CardCollection:
        return CardLists.filter(cardList, CardPredicates.hasKeyword(keyword))

    @staticmethod
    def getNotKeyword(cardList: Iterable[Card], keyword) -> CardCollection:
        return CardLists.filter(cardList, CardPredicates.hasKeyword(keyword).negate())

    @staticmethod
    def getAmountOfKeyword(cardList: Iterable[Card], keyword) -> int:
        nKeyword = 0
        for c in cardList:
            nKeyword += c.getAmountOfKeyword(keyword)
        return nKeyword

    # cardType is like "Land" or "Goblin", returns a new CardCollection that is a
    # subset of current CardList
    @staticmethod
    def getNotType(cardList: Iterable[Card], cardType: str) -> CardCollection:
        return CardLists.filter(cardList, CardPredicates.isType(cardType).negate())

    @staticmethod
    def getType(cardList: Iterable[Card], cardType: str) -> CardCollection:
        return CardLists.filter(cardList, CardPredicates.isType(cardType))

    @staticmethod
    def getNotColor(cardList: Iterable[Card], color: int) -> CardCollection:
        return CardLists.filter(cardList, CardPredicates.isColor(color).negate())

    @staticmethod
    def getColor(cardList: Iterable[Card], color: int) -> CardCollection:
        return CardLists.filter(cardList, CardPredicates.isColor(color))

    @staticmethod
    def filter(cardList: Iterable[Card], *filts) -> CardCollection:
        if len(filts) == 2:
            f1, f2 = filts
            return CardCollection(IterableUtil.filter(cardList, f1.and(f2)))
        filt = filts[0]
        if not callable(filt) and hasattr(filt, "__iter__"):
            return CardCollection(IterableUtil.filter(cardList, IterableUtil.and(filt)))
        return CardCollection(IterableUtil.filter(cardList, filt))

    @staticmethod
    def filterAsList(cardList: Iterable[Card], *filts) -> List[Card]:
        if len(filts) == 2:
            f1, f2 = filts
            return list(IterableUtil.filter(cardList, f1.and(f2)))
        filt = filts[0]
        if not callable(filt) and hasattr(filt, "__iter__"):
            return list(IterableUtil.filter(cardList, IterableUtil.and(filt)))
        return list(IterableUtil.filter(cardList, filt))

    @staticmethod
    def count(cardList: Iterable[Card], filt) -> int:
        if cardList is None:
            return 0

        count = 0
        for c in cardList:
            if filt.test(c):
                count += 1
        return count

    @staticmethod
    def getCardsWithHighestCMC(cardList: Iterable[Card]) -> CardCollection:
        tiedForHighest = CardCollection()
        highest = 0
        for crd in cardList:
            # do not check for Split Card anymore
            curCmc = crd.getCMC()

            if curCmc > highest:
                highest = curCmc
                tiedForHighest.clear()
            if curCmc >= highest:
                tiedForHighest.add(crd)
        return tiedForHighest

    @staticmethod
    def getCardsWithLowestCMC(cardList: Iterable[Card]) -> CardCollection:
        tiedForLowest = CardCollection()
        lowest = 25
        for crd in cardList:
            # do not check for Split Card anymore
            curCmc = crd.getCMC()

            if curCmc < lowest:
                lowest = curCmc
                tiedForLowest.clear()
            if curCmc <= lowest:
                tiedForLowest.add(crd)
        return tiedForLowest

    @staticmethod
    def getTotalPower(cardList: Iterable[Card], ctb: CardTraitBase) -> int:
        total = 0
        for crd in cardList:
            if StaticAbilityTapPowerValue.withToughness(crd, ctb):
                total += max(0, crd.getNetToughness())
            else:
                m = StaticAbilityTapPowerValue.getMod(crd, ctb)
                total += max(0, crd.getNetPower() + m)
        return total

    @staticmethod
    def getTotalChroma(cardList: Iterable[Card], colorCode: int) -> int:
        colorOcurrencices = 0
        for c0 in cardList:
            for sh in c0.getManaCost():
                if sh.isColor(colorCode):
                    colorOcurrencices += 1
        return colorOcurrencices

    @staticmethod
    def getTotalCMC(cardList: Iterable[Card]) -> int:
        total = 0
        for crd in cardList:
            total += max(0, crd.getCMC())
        return total

    @staticmethod
    def cmcCanSumTo(sum: int, cardList: Iterable[Card]) -> bool:
        numList = []
        for c in cardList:
            num = c.getCMC()
            if num == sum:
                return True
            elif num < sum:
                numList.append(num)
        if not numList:
            return False
        numList.sort()

        return CardLists.isSubsetSum(numList, sum)

    @staticmethod
    def isSubsetSum(numList: List[int], sum: int) -> bool:
        if sum == 0:
            return True
        size = len(numList)
        if size == 0:
            return False

        last = numList[size - 1]
        numList.remove(last)
        # If last element is greater than sum, then ignore it
        if last > sum:
            return CardLists.isSubsetSum(numList, sum)

        # Else, check if sum can be obtained by:
        # (a) excluding the last element
        # (b) including the last element
        return CardLists.isSubsetSum(numList, sum) or CardLists.isSubsetSum(numList, sum - last)

    @staticmethod
    def getDifferentNamesCount(cardList: Iterable[Card]) -> int:
        # first part the ones with SpyKit, and already collect them while deduping by name
        parted = {True: [], False: []}
        for c in cardList:
            list = parted[c.hasNonLegendaryCreatureNames()]
            if not c.hasNoName() and not any(c.sharesNameWith(c2) for c2 in list):
                list.append(c)
        preList = parted[False]

        # then try to apply the SpyKit ones
        for c in parted[True]:
            if not any(c.sharesNameWith(c2) for c2 in preList):
                preList.append(c)
        return len(preList)
```
