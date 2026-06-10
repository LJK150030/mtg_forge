---
aliases:
  - RepeatEachEffect
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/ability/effects
fqn: forge.game.ability.effects.RepeatEachEffect
package: forge.game.ability.effects
module: forge-game
kind: Class
---

# RepeatEachEffect

**Package:** `forge.game.ability.effects` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class RepeatEachEffect {
        +resolve(SpellAbility sa) void
        -setVoteAmount(Object o, SpellAbility sa) void
    }
    RepeatEachEffect --|> SpellAbilityEffect : extends
    RepeatEachEffect ..> AbilityKey : uses
    RepeatEachEffect ..> Card : uses
    RepeatEachEffect ..> CardCollectionView : uses
    RepeatEachEffect ..> CardDamageMap : uses
    RepeatEachEffect ..> CardType : uses
    RepeatEachEffect ..> CardZoneTable : uses
    RepeatEachEffect ..> CoreType : uses
    RepeatEachEffect ..> FCollection : uses
    RepeatEachEffect ..> Game : uses
    RepeatEachEffect ..> GameCommand : uses
    RepeatEachEffect ..> GameEntityCounterTable : uses
    RepeatEachEffect ..> GameObject : uses
    RepeatEachEffect ..> Player : uses
    RepeatEachEffect ..> SpellAbility : uses
    RepeatEachEffect ..> SpellAbilityStackInstance : uses
    RepeatEachEffect ..> WrappedAbility : uses
    RepeatEachEffect ..> ZoneType : uses
```

## Relationships
**Extends:**
- [[forge.game.ability.SpellAbilityEffect|SpellAbilityEffect]]
**Uses:**
- [[forge.GameCommand|GameCommand]]
- [[forge.card.CardType|CardType]]
- [[forge.card.CardType.CoreType|CoreType]]
- [[forge.game.Game|Game]]
- [[forge.game.GameEntityCounterTable|GameEntityCounterTable]]
- [[forge.game.GameObject|GameObject]]
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.card.CardCollectionView|CardCollectionView]]
- [[forge.game.card.CardDamageMap|CardDamageMap]]
- [[forge.game.card.CardZoneTable|CardZoneTable]]
- [[forge.game.player.Player|Player]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]
- [[forge.game.spellability.SpellAbilityStackInstance|SpellAbilityStackInstance]]
- [[forge.game.trigger.WrappedAbility|WrappedAbility]]
- [[forge.game.zone.ZoneType|ZoneType]]
- [[forge.util.collect.FCollection|FCollection]]


## Design Description

RepeatEachEffect is a resolution handler implementing the "repeat a sub-ability once for each X" pattern pervasive in Magic cards. As a concrete `SpellAbilityEffect` subclass, it overrides `resolve` to read script parameters and iterate a configured "RepeatSubAbility" over a chosen collection: matching `Card`s in given `ZoneType`s, `SpellAbility`s on the stack, mixed targeted `GameObject`s, players (`FCollection<Player>`), or card `CoreType`s. For each element it temporarily marks the host as remembered (or imprinted), resolves the sub-ability via `AbilityUtils`, then cleans up â€” carefully swapping out other remembered players to avoid collisions.

The design is data-driven: every behavior is parameter-gated, supporting optional confirmation, player-chosen ordering, vote-derived amounts, and deferred next-turn execution via `GameCommand`. It accumulates side effects across iterations through shared structures (`CardDamageMap`, `CardZoneTable`, `GameEntityCounterTable`, a life-loss map), then applies batched damage, zone-change triggers, and a single `LifeLostAll` trigger only after the loop completes, so all repetitions resolve as one coordinated game event.

## Source
`forge-game/src/main/java/forge/game/ability/effects/RepeatEachEffect.java`

```java
package forge.game.ability.effects;

import java.util.*;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

import forge.GameCommand;
import forge.card.CardType;
import forge.game.Game;
import forge.game.GameEntityCounterTable;
import forge.game.GameObject;
import forge.game.ability.AbilityKey;
import forge.game.ability.AbilityUtils;
import forge.game.ability.ApiType;
import forge.game.ability.SpellAbilityEffect;
import forge.game.card.*;
import forge.game.player.Player;
import forge.game.spellability.SpellAbility;
import forge.game.spellability.SpellAbilityStackInstance;
import forge.game.trigger.TriggerType;
import forge.game.trigger.WrappedAbility;
import forge.game.zone.ZoneType;
import forge.util.IterableUtil;
import forge.util.collect.FCollection;

public class RepeatEachEffect extends SpellAbilityEffect {

    /* (non-Javadoc)
     * @see forge.card.abilityfactory.SpellEffect#resolve(forge.card.spellability.SpellAbility)
     */
    @SuppressWarnings("serial")
    @Override
    public void resolve(SpellAbility sa) {
        // Things to loop over: Cards, Players, or SAs
        final Card source = sa.getHostCard();

        final SpellAbility repeat = sa.getAdditionalAbility("RepeatSubAbility");

        final Player activator = sa.getActivatingPlayer();
        final Game game = activator.getGame();
        if (sa.hasParam("Optional") && sa.hasParam("OptionPrompt") && //for now, OptionPrompt is needed
                !activator.getController().confirmAction(sa, null, sa.getParam("OptionPrompt"), null)) {
            return;
        }

        boolean useImprinted = sa.hasParam("UseImprinted");

        CardCollectionView repeatCards = null;
        List<SpellAbility> repeatSas = null;

        if (sa.hasParam("RepeatCards")) {
            List<ZoneType> zone = Lists.newArrayList();
            if (sa.hasParam("Zone")) {
                zone = ZoneType.listValueOf(sa.getParam("Zone"));
            } else {
                zone.add(ZoneType.Battlefield);
            }
            repeatCards = CardLists.getValidCards(game.getCardsIn(zone), sa.getParam("RepeatCards"), source.getController(), source, sa);
        }
        else if (sa.hasParam(("RepeatSpellAbilities"))) {
            repeatSas = Lists.newArrayList();
            String[] restrictions = sa.getParam("RepeatSpellAbilities").split(",");
            for (SpellAbilityStackInstance stackInstance : game.getStack()) {
                if (stackInstance.getSpellAbility().isValid(restrictions, source.getController(), source, sa)) {
                    repeatSas.add(stackInstance.getSpellAbility());
                }
            }

        }
        else if (sa.hasParam("DefinedCards")) {
            repeatCards = AbilityUtils.getDefinedCards(source, sa.getParam("DefinedCards"), sa);
        }

        if (sa.hasParam("ClearRemembered")) {
            source.clearRemembered();
        }

        if (sa.hasParam("DamageMap")) {
            sa.setDamageMap(new CardDamageMap());
            sa.setPreventMap(new CardDamageMap());
            sa.setCounterTable(new GameEntityCounterTable());
        }
        if (sa.hasParam("ChangeZoneTable")) {
            sa.setChangeZoneTable(new CardZoneTable());
        }
        if (sa.hasParam("LoseLifeMap")) {
            sa.setLoseLifeMap(Maps.newHashMap());
        }

        if (repeatCards != null && !repeatCards.isEmpty()) {
            if (sa.hasParam("ChooseOrder") && repeatCards.size() > 1) {
                final Player chooser = sa.getParam("ChooseOrder").equals("True") ? activator :
                        AbilityUtils.getDefinedPlayers(source, sa.getParam("ChooseOrder"), sa).get(0);
                repeatCards = chooser.getController().orderMoveToZoneList(repeatCards, ZoneType.None, sa);
            }

            for (Card card : repeatCards) {
                if (useImprinted) {
                    source.addImprintedCard(card);
                } else {
                    source.addRemembered(card);
                }
                if (sa.hasParam("AmountFromVotes")) {
                    setVoteAmount(card, sa);
                }
                AbilityUtils.resolve(repeat);
                if (useImprinted) {
                    source.removeImprintedCard(card);
                } else {
                    source.removeRemembered(card);
                }
            }
        }
        if (repeatSas != null) {
            for (SpellAbility card : repeatSas) {
                source.addRemembered(card);
                AbilityUtils.resolve(repeat);
                source.removeRemembered(card);
            }
        }

        // for a mixed list of target permanents and players, e.g. Soulfire Eruption
        if (sa.hasParam("RepeatTargeted")) {
            for (final GameObject o : getTargets(sa)) {
                source.addRemembered(o);
                AbilityUtils.resolve(repeat);
                source.removeRemembered(o);
            }
        }

        if (sa.hasParam("RepeatTypesFrom")) {
            final Set<String> validTypes = new HashSet<>();
            final String def = sa.getParam("RepeatTypesFrom");
            final List<Card> res;
            if (def.startsWith("ThisTurnCast")) {
                final String[] workingCopy = def.split("_");
                final String validFilter = workingCopy[1];
                res = CardUtil.getThisTurnCast(validFilter, source, sa, activator);
            } else {
                res = AbilityUtils.getDefinedCards(source, def, sa);
            }
            for (final Card c : res) {
                for (CardType.CoreType type : c.getType().getCoreTypes()) {
                    validTypes.add(type.name());
                }
            }

            final String storedType = source.getChosenType();
            Player chooser = activator;
            if (sa.hasParam("ChooseOrder") && !sa.getParam("ChooseOrder").equals("True")) {
                chooser = AbilityUtils.getDefinedPlayers(source, sa.getParam("ChooseOrder"), sa).get(0);
            }
            while (!validTypes.isEmpty()) {
                String chosenT = chooser.getController().chooseSomeType("Card", sa, validTypes);
                source.setChosenType(chosenT);
                AbilityUtils.resolve(repeat);
                validTypes.remove(chosenT);
            }
            source.setChosenType(storedType);
        }

        if (sa.hasParam("RepeatPlayers")) {
            final FCollection<Player> repeatPlayers = getDefinedPlayersOrTargeted(sa, "RepeatPlayers");
            if (sa.hasParam("ClearRememberedBeforeLoop")) {
                source.clearRemembered();
            }
            boolean optional = sa.hasParam("RepeatOptionalForEachPlayer");
            boolean nextTurn = sa.hasParam("NextTurnForEachPlayer");

            for (final Player p : repeatPlayers) {
                if (optional && !p.getController().confirmAction(repeat, null, sa.getParam("RepeatOptionalMessage"), null)) {
                    continue;
                }
                if (nextTurn) {
                    game.getCleanup().addUntil(p, (GameCommand) () -> {
                        List<Object> tempRemembered = Lists.newArrayList(IterableUtil.filter(source.getRemembered(), Player.class));
                        source.removeRemembered(tempRemembered);
                        source.addRemembered(p);
                        AbilityUtils.resolve(repeat);
                        source.removeRemembered(p);
                        source.addRemembered(tempRemembered);
                    });
                } else {
                    // to avoid risk of collision with other abilities swap out other Remembered Player while resolving
                    List<Object> tempRemembered = Lists.newArrayList(IterableUtil.filter(source.getRemembered(), Player.class));
                    source.removeRemembered(tempRemembered);
                    source.addRemembered(p);
                    if (sa.hasParam("AmountFromVotes")) {
                        setVoteAmount(p, sa);
                    }
                    AbilityUtils.resolve(repeat);
                    source.removeRemembered(p);
                    source.addRemembered(tempRemembered);
                }
            }
        }

        if (sa.hasParam("DamageMap")) {
            game.getAction().dealDamage(false, sa.getDamageMap(), sa.getPreventMap(), sa.getCounterTable(), sa);
        }
        if (sa.hasParam("ChangeZoneTable")) {
            sa.getChangeZoneTable().triggerChangesZoneAll(game, sa);
            sa.setChangeZoneTable(null);
        }
        if (sa.hasParam("LoseLifeMap")) {
            Map<Player, Integer> lossMap = sa.getLoseLifeMap();
            if (!lossMap.isEmpty()) {
                final Map<AbilityKey, Object> runParams2 = AbilityKey.mapFromPIMap(lossMap);
                game.getTriggerHandler().runTrigger(TriggerType.LifeLostAll, runParams2, false);
            }
            sa.setLoseLifeMap(null);
        }
    }

    private void setVoteAmount(Object o, SpellAbility sa) {
        SpellAbility rootAbility = sa.getRootAbility();
        if (rootAbility.isWrapper()) {
            rootAbility = ((WrappedAbility) rootAbility).getWrappedAbility();
        }
        final SpellAbility saVote = rootAbility.getApi().equals(ApiType.Vote) ? rootAbility
                : rootAbility.findSubAbilityByType(ApiType.Vote);
        if (saVote == null) {
            System.err.println(sa.getHostCard() + ": Bad vote amount for " + o + ", default to 0");
            sa.setSVar("Votes", "Number$0");
        } else {
            sa.setSVar("Votes", saVote.getSVar("VoteNum" + o.toString()));
        }
    }
}
```

## Python
`forge/game/ability/effects/RepeatEachEffect.py`

```python
from forge.GameCommand import GameCommand
from forge.card.CardType import CardType
from forge.card.CardType.CoreType import CoreType
from forge.game.Game import Game
from forge.game.GameEntityCounterTable import GameEntityCounterTable
from forge.game.GameObject import GameObject
from forge.game.ability.AbilityKey import AbilityKey
from forge.game.ability.AbilityUtils import AbilityUtils
from forge.game.ability.ApiType import ApiType
from forge.game.ability.SpellAbilityEffect import SpellAbilityEffect
from forge.game.card.Card import Card
from forge.game.card.CardCollectionView import CardCollectionView
from forge.game.card.CardDamageMap import CardDamageMap
from forge.game.card.CardZoneTable import CardZoneTable
from forge.game.card.CardLists import CardLists
from forge.game.card.CardUtil import CardUtil
from forge.game.player.Player import Player
from forge.game.spellability.SpellAbility import SpellAbility
from forge.game.spellability.SpellAbilityStackInstance import SpellAbilityStackInstance
from forge.game.trigger.TriggerType import TriggerType
from forge.game.trigger.WrappedAbility import WrappedAbility
from forge.game.zone.ZoneType import ZoneType
from forge.util.IterableUtil import IterableUtil
from forge.util.collect.FCollection import FCollection


class RepeatEachEffect(SpellAbilityEffect):

    # (non-Javadoc)
    # @see forge.card.abilityfactory.SpellEffect#resolve(forge.card.spellability.SpellAbility)
    def resolve(self, sa: SpellAbility) -> None:
        # Things to loop over: Cards, Players, or SAs
        source = sa.getHostCard()

        repeat = sa.getAdditionalAbility("RepeatSubAbility")

        activator = sa.getActivatingPlayer()
        game = activator.getGame()
        if sa.hasParam("Optional") and sa.hasParam("OptionPrompt") and \
                not activator.getController().confirmAction(sa, None, sa.getParam("OptionPrompt"), None):  # for now, OptionPrompt is needed
            return

        useImprinted = sa.hasParam("UseImprinted")

        repeatCards = None
        repeatSas = None

        if sa.hasParam("RepeatCards"):
            zone = []
            if sa.hasParam("Zone"):
                zone = ZoneType.listValueOf(sa.getParam("Zone"))
            else:
                zone.append(ZoneType.Battlefield)
            repeatCards = CardLists.getValidCards(game.getCardsIn(zone), sa.getParam("RepeatCards"), source.getController(), source, sa)
        elif sa.hasParam("RepeatSpellAbilities"):
            repeatSas = []
            restrictions = sa.getParam("RepeatSpellAbilities").split(",")
            for stackInstance in game.getStack():
                if stackInstance.getSpellAbility().isValid(restrictions, source.getController(), source, sa):
                    repeatSas.append(stackInstance.getSpellAbility())
        elif sa.hasParam("DefinedCards"):
            repeatCards = AbilityUtils.getDefinedCards(source, sa.getParam("DefinedCards"), sa)

        if sa.hasParam("ClearRemembered"):
            source.clearRemembered()

        if sa.hasParam("DamageMap"):
            sa.setDamageMap(CardDamageMap())
            sa.setPreventMap(CardDamageMap())
            sa.setCounterTable(GameEntityCounterTable())
        if sa.hasParam("ChangeZoneTable"):
            sa.setChangeZoneTable(CardZoneTable())
        if sa.hasParam("LoseLifeMap"):
            sa.setLoseLifeMap({})

        if repeatCards is not None and not repeatCards.isEmpty():
            if sa.hasParam("ChooseOrder") and repeatCards.size() > 1:
                chooser = activator if sa.getParam("ChooseOrder") == "True" else \
                    AbilityUtils.getDefinedPlayers(source, sa.getParam("ChooseOrder"), sa).get(0)
                repeatCards = chooser.getController().orderMoveToZoneList(repeatCards, ZoneType.None, sa)

            for card in repeatCards:
                if useImprinted:
                    source.addImprintedCard(card)
                else:
                    source.addRemembered(card)
                if sa.hasParam("AmountFromVotes"):
                    self.setVoteAmount(card, sa)
                AbilityUtils.resolve(repeat)
                if useImprinted:
                    source.removeImprintedCard(card)
                else:
                    source.removeRemembered(card)
        if repeatSas is not None:
            for card in repeatSas:
                source.addRemembered(card)
                AbilityUtils.resolve(repeat)
                source.removeRemembered(card)

        # for a mixed list of target permanents and players, e.g. Soulfire Eruption
        if sa.hasParam("RepeatTargeted"):
            for o in self.getTargets(sa):
                source.addRemembered(o)
                AbilityUtils.resolve(repeat)
                source.removeRemembered(o)

        if sa.hasParam("RepeatTypesFrom"):
            validTypes = set()
            defn = sa.getParam("RepeatTypesFrom")
            if defn.startswith("ThisTurnCast"):
                workingCopy = defn.split("_")
                validFilter = workingCopy[1]
                res = CardUtil.getThisTurnCast(validFilter, source, sa, activator)
            else:
                res = AbilityUtils.getDefinedCards(source, defn, sa)
            for c in res:
                for type in c.getType().getCoreTypes():
                    validTypes.add(type.name())

            storedType = source.getChosenType()
            chooser = activator
            if sa.hasParam("ChooseOrder") and sa.getParam("ChooseOrder") != "True":
                chooser = AbilityUtils.getDefinedPlayers(source, sa.getParam("ChooseOrder"), sa).get(0)
            while validTypes:
                chosenT = chooser.getController().chooseSomeType("Card", sa, validTypes)
                source.setChosenType(chosenT)
                AbilityUtils.resolve(repeat)
                validTypes.remove(chosenT)
            source.setChosenType(storedType)

        if sa.hasParam("RepeatPlayers"):
            repeatPlayers = self.getDefinedPlayersOrTargeted(sa, "RepeatPlayers")
            if sa.hasParam("ClearRememberedBeforeLoop"):
                source.clearRemembered()
            optional = sa.hasParam("RepeatOptionalForEachPlayer")
            nextTurn = sa.hasParam("NextTurnForEachPlayer")

            for p in repeatPlayers:
                if optional and not p.getController().confirmAction(repeat, None, sa.getParam("RepeatOptionalMessage"), None):
                    continue
                if nextTurn:
                    def command(p=p):
                        tempRemembered = list(IterableUtil.filter(source.getRemembered(), Player))
                        source.removeRemembered(tempRemembered)
                        source.addRemembered(p)
                        AbilityUtils.resolve(repeat)
                        source.removeRemembered(p)
                        source.addRemembered(tempRemembered)
                    game.getCleanup().addUntil(p, command)
                else:
                    # to avoid risk of collision with other abilities swap out other Remembered Player while resolving
                    tempRemembered = list(IterableUtil.filter(source.getRemembered(), Player))
                    source.removeRemembered(tempRemembered)
                    source.addRemembered(p)
                    if sa.hasParam("AmountFromVotes"):
                        self.setVoteAmount(p, sa)
                    AbilityUtils.resolve(repeat)
                    source.removeRemembered(p)
                    source.addRemembered(tempRemembered)

        if sa.hasParam("DamageMap"):
            game.getAction().dealDamage(False, sa.getDamageMap(), sa.getPreventMap(), sa.getCounterTable(), sa)
        if sa.hasParam("ChangeZoneTable"):
            sa.getChangeZoneTable().triggerChangesZoneAll(game, sa)
            sa.setChangeZoneTable(None)
        if sa.hasParam("LoseLifeMap"):
            lossMap = sa.getLoseLifeMap()
            if lossMap:
                runParams2 = AbilityKey.mapFromPIMap(lossMap)
                game.getTriggerHandler().runTrigger(TriggerType.LifeLostAll, runParams2, False)
            sa.setLoseLifeMap(None)

    def setVoteAmount(self, o: object, sa: SpellAbility) -> None:
        rootAbility = sa.getRootAbility()
        if rootAbility.isWrapper():
            rootAbility = rootAbility.getWrappedAbility()
        saVote = rootAbility if rootAbility.getApi() == ApiType.Vote \
            else rootAbility.findSubAbilityByType(ApiType.Vote)
        if saVote is None:
            import sys
            print(str(sa.getHostCard()) + ": Bad vote amount for " + str(o) + ", default to 0", file=sys.stderr)
            sa.setSVar("Votes", "Number$0")
        else:
            sa.setSVar("Votes", saVote.getSVar("VoteNum" + str(o)))
```
