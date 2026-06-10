---
aliases:
  - StaticAbilityDisableTriggers
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityDisableTriggers
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityDisableTriggers

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityDisableTriggers {
        +disabled(Game game, Trigger regtrig, Map~AbilityKey,Object~ runParams) boolean
        +isDisabled(StaticAbility stAb, Trigger regtrig, Map~AbilityKey,Object~ runParams) boolean
    }
    StaticAbilityDisableTriggers ..> AbilityKey : uses
    StaticAbilityDisableTriggers ..> Card : uses
    StaticAbilityDisableTriggers ..> CardCollection : uses
    StaticAbilityDisableTriggers ..> CardCollectionView : uses
    StaticAbilityDisableTriggers ..> CardZoneTable : uses
    StaticAbilityDisableTriggers ..> Game : uses
    StaticAbilityDisableTriggers ..> StaticAbility : uses
    StaticAbilityDisableTriggers ..> Trigger : uses
    StaticAbilityDisableTriggers ..> TriggerType : uses
    StaticAbilityDisableTriggers ..> ZoneType : uses
```

## Relationships
**Uses:**
- [[forge.game.Game|Game]]
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.card.CardCollection|CardCollection]]
- [[forge.game.card.CardCollectionView|CardCollectionView]]
- [[forge.game.card.CardZoneTable|CardZoneTable]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]
- [[forge.game.trigger.Trigger|Trigger]]
- [[forge.game.trigger.TriggerType|TriggerType]]
- [[forge.game.zone.ZoneType|ZoneType]]

## Design Description

StaticAbilityDisableTriggers is a stateless utility that evaluates the "DisableTriggers" static-ability mode, determining whether a registered trigger should be suppressed under continuous effects such as Hushwing Gryff or Torpor Orb. Its `disabled` entry point scans static-ability sources across the battlefield (or the last-known battlefield for leaves-the-battlefield triggers), checks each ability's conditions, and delegates per-ability matching to `isDisabled`.

The class collaborates with `StaticAbility` for parameter and condition lookups, `Trigger`/`TriggerType` for the trigger under test, and `Game` for zone queries. `isDisabled` encodes considerable rules nuance: it validates the host card, trigger ability, and mode, and handles the zone-change modes speciallyâ€”filtering forbidden causes from a `CardZoneTable` and re-running the trigger's own test so partially-matched batch events still fire for the unaffected cards, while preserving the filtered set for effects like Panharmonicon. Implemented entirely with static methods, it intentionally holds no state, serving purely as rules logic invoked during trigger evaluation.

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityDisableTriggers.java`

```java
package forge.game.staticability;

import com.google.common.collect.Table.Cell;

import forge.game.Game;
import forge.game.card.*;
import forge.game.ability.AbilityKey;
import forge.game.trigger.Trigger;
import forge.game.trigger.TriggerType;
import forge.game.zone.ZoneType;
import org.apache.commons.lang3.ArrayUtils;

import java.util.Map;
import java.util.function.Predicate;

public class StaticAbilityDisableTriggers {

    public static boolean disabled(final Game game, final Trigger regtrig, final Map<AbilityKey, Object> runParams)  {
        CardCollectionView cardList = null;
        // if LTB look back
        if (regtrig.looksBackInTime()) {
            if (runParams.containsKey(AbilityKey.LastStateBattlefield)) {
                cardList = (CardCollectionView) runParams.get(AbilityKey.LastStateBattlefield);
            }
            if (cardList == null) {
                cardList = game.getLastStateBattlefield();
            }
        } else {
            cardList = game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES);
        }

        for (final Card ca : cardList) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(StaticAbilityMode.DisableTriggers)) {
                    continue;
                }

                if (isDisabled(stAb, regtrig, runParams)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static boolean isDisabled(final StaticAbility stAb, final Trigger regtrig, final Map<AbilityKey, Object> runParams) {
        final TriggerType trigMode = regtrig.getMode();

        // CR 603.2e
        if (stAb.hasParam("ValidCard") && regtrig.getSpawningAbility() != null) {
            return false;
        }

        if (!stAb.matchesValidParam("ValidCard", regtrig.getHostCard())) {
            return false;
        }

        // Trigger currently has no isValid, take Trigger Ability instead
        if (!stAb.matchesValidParam("ValidTrigger", regtrig.getOverridingAbility())) {
            return false;
        }

        if (stAb.hasParam("ValidMode")) {
            if (!ArrayUtils.contains(stAb.getParam("ValidMode").split(","), trigMode.toString())) {
                return false;
            }
        }

        if (trigMode.equals(TriggerType.ChangesZone)) {
            // Cause of the trigger Ã¢â‚¬â€œ the card changing zones
            Card moved = (Card) runParams.get(AbilityKey.Card);
            if ("Battlefield".equals(regtrig.getParam("Origin"))) {
                moved = (Card) runParams.get(AbilityKey.CardLKI);
            }
            if (!stAb.matchesValidParam("ValidCause", moved)) {
                return false;
            }
            if (!stAb.matchesValidParam("Destination", runParams.get(AbilityKey.Destination))) {
                return false;
            }
            if (!stAb.matchesValidParam("Origin", runParams.get(AbilityKey.Origin))) {
                return false;
            }
            if ("Graveyard".equals(runParams.get(AbilityKey.Destination))
                    && "Battlefield".equals(runParams.get(AbilityKey.Origin))) {
                // Allow triggered ability of a dying creature that triggers
                // only when that creature is put into a graveyard from anywhere
                if ("Card.Self".equals(regtrig.getParam("ValidCard"))
                        && (!regtrig.hasParam("Origin") || "Any".equals(regtrig.getParam("Origin")))) {
                    return false;
                }
            }
        } else if (trigMode.equals(TriggerType.ChangesZoneAll)) {
            final String origin = stAb.getParam("Origin");
            final String destination = stAb.getParam("Destination");
            // check if some causes were already ignored by a different ability, then the forbidden causes will be combined
            CardZoneTable table = (CardZoneTable) runParams.get(AbilityKey.CardsFiltered);
            if (table == null) {
                table = (CardZoneTable) runParams.get(AbilityKey.Cards);
            }
            CardZoneTable filtered = new CardZoneTable(table.getLastStateBattlefield(), table.getLastStateGraveyard());
            boolean possiblyDisabled = false;

            // purge all forbidden causes from table
            for (Cell<ZoneType, ZoneType, CardCollection> cell : table.cellSet()) {
                CardCollection changers = cell.getValue();
                if ((origin == null || cell.getRowKey() == ZoneType.valueOf(origin)) &&
                (destination == null || cell.getColumnKey() == ZoneType.valueOf(destination))) {
                    Predicate<Card> validCause = CardPredicates.restriction(stAb.getParam("ValidCause").split(","), stAb.getHostCard().getController(), stAb.getHostCard(), stAb);
                    changers = CardLists.filter(changers, validCause.negate());
                    // static will match some of the causes
                    if (changers.size() < cell.getValue().size()) {
                        possiblyDisabled = true;
                    }
                }
                filtered.put(cell.getRowKey(), cell.getColumnKey(), changers);
            }

            if (!possiblyDisabled) {
                return false;
            }

            // test if trigger would still fire when ignoring forbidden causes
            final Map<AbilityKey, Object> runParamsFiltered = AbilityKey.newMap(runParams);
            runParamsFiltered.put(AbilityKey.Cards, filtered);
            if (regtrig.performTest(runParamsFiltered)) {
                // store the filtered Cards because Panharmonicon shouldn't see the others
                runParams.put(AbilityKey.CardsFiltered, filtered);

                return false;
            }
        }
        return true;
    }
}
```

## Python
`forge/game/staticability/StaticAbilityDisableTriggers.py`

```python
from forge.game.Game import Game
from forge.game.ability.AbilityKey import AbilityKey
from forge.game.card.Card import Card
from forge.game.card.CardCollection import CardCollection
from forge.game.card.CardCollectionView import CardCollectionView
from forge.game.card.CardZoneTable import CardZoneTable
from forge.game.card.CardPredicates import CardPredicates
from forge.game.card.CardLists import CardLists
from forge.game.staticability.StaticAbility import StaticAbility
from forge.game.staticability.StaticAbilityMode import StaticAbilityMode
from forge.game.trigger.Trigger import Trigger
from forge.game.trigger.TriggerType import TriggerType
from forge.game.zone.ZoneType import ZoneType


class StaticAbilityDisableTriggers:

    @staticmethod
    def disabled(game: Game, regtrig: Trigger, runParams: dict) -> bool:
        cardList: CardCollectionView = None
        # if LTB look back
        if regtrig.looksBackInTime():
            if AbilityKey.LastStateBattlefield in runParams:
                cardList = runParams.get(AbilityKey.LastStateBattlefield)
            if cardList is None:
                cardList = game.getLastStateBattlefield()
        else:
            cardList = game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)

        for ca in cardList:
            for stAb in ca.getStaticAbilities():
                if not stAb.checkConditions(StaticAbilityMode.DisableTriggers):
                    continue

                if StaticAbilityDisableTriggers.isDisabled(stAb, regtrig, runParams):
                    return True
        return False

    @staticmethod
    def isDisabled(stAb: StaticAbility, regtrig: Trigger, runParams: dict) -> bool:
        trigMode = regtrig.getMode()

        # CR 603.2e
        if stAb.hasParam("ValidCard") and regtrig.getSpawningAbility() is not None:
            return False

        if not stAb.matchesValidParam("ValidCard", regtrig.getHostCard()):
            return False

        # Trigger currently has no isValid, take Trigger Ability instead
        if not stAb.matchesValidParam("ValidTrigger", regtrig.getOverridingAbility()):
            return False

        if stAb.hasParam("ValidMode"):
            if str(trigMode) not in stAb.getParam("ValidMode").split(","):
                return False

        if trigMode == TriggerType.ChangesZone:
            # Cause of the trigger ΓÇô the card changing zones
            moved = runParams.get(AbilityKey.Card)
            if "Battlefield" == regtrig.getParam("Origin"):
                moved = runParams.get(AbilityKey.CardLKI)
            if not stAb.matchesValidParam("ValidCause", moved):
                return False
            if not stAb.matchesValidParam("Destination", runParams.get(AbilityKey.Destination)):
                return False
            if not stAb.matchesValidParam("Origin", runParams.get(AbilityKey.Origin)):
                return False
            if "Graveyard" == runParams.get(AbilityKey.Destination) \
                    and "Battlefield" == runParams.get(AbilityKey.Origin):
                # Allow triggered ability of a dying creature that triggers
                # only when that creature is put into a graveyard from anywhere
                if "Card.Self" == regtrig.getParam("ValidCard") \
                        and (not regtrig.hasParam("Origin") or "Any" == regtrig.getParam("Origin")):
                    return False
        elif trigMode == TriggerType.ChangesZoneAll:
            origin = stAb.getParam("Origin")
            destination = stAb.getParam("Destination")
            # check if some causes were already ignored by a different ability, then the forbidden causes will be combined
            table = runParams.get(AbilityKey.CardsFiltered)
            if table is None:
                table = runParams.get(AbilityKey.Cards)
            filtered = CardZoneTable(table.getLastStateBattlefield(), table.getLastStateGraveyard())
            possiblyDisabled = False

            # purge all forbidden causes from table
            for cell in table.cellSet():
                changers = cell.getValue()
                if (origin is None or cell.getRowKey() == ZoneType.valueOf(origin)) and \
                        (destination is None or cell.getColumnKey() == ZoneType.valueOf(destination)):
                    validCause = CardPredicates.restriction(stAb.getParam("ValidCause").split(","), stAb.getHostCard().getController(), stAb.getHostCard(), stAb)
                    changers = CardLists.filter(changers, validCause.negate())
                    # static will match some of the causes
                    if changers.size() < cell.getValue().size():
                        possiblyDisabled = True
                filtered.put(cell.getRowKey(), cell.getColumnKey(), changers)

            if not possiblyDisabled:
                return False

            # test if trigger would still fire when ignoring forbidden causes
            runParamsFiltered = AbilityKey.newMap(runParams)
            runParamsFiltered[AbilityKey.Cards] = filtered
            if regtrig.performTest(runParamsFiltered):
                # store the filtered Cards because Panharmonicon shouldn't see the others
                runParams[AbilityKey.CardsFiltered] = filtered

                return False
        return True
```
