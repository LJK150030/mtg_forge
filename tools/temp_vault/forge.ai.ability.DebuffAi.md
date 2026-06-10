---
aliases:
  - DebuffAi
tags:
  - java/class
  - module/forge-ai
  - pkg/forge/ai/ability
fqn: forge.ai.ability.DebuffAi
package: forge.ai.ability
module: forge-ai
kind: Class
---

# DebuffAi

**Package:** `forge.ai.ability` &nbsp; **Module:** `forge-ai` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class DebuffAi {
        #canPlay(Player ai, SpellAbility sa) AiAbilityDecision
        +chkDrawback(Player ai, SpellAbility sa) AiAbilityDecision
        -debuffTgtAI(Player ai, SpellAbility sa, List~String~ kws, boolean mandatory) boolean
        -getCurseCreatures(Player ai, SpellAbility sa, List~String~ kws) CardCollection
        -debuffMandatoryTarget(Player ai, SpellAbility sa, boolean mandatory) boolean
        #doTriggerNoCost(Player ai, SpellAbility sa, boolean mandatory) AiAbilityDecision
    }
    DebuffAi --|> SpellAbilityAi : extends
    DebuffAi ..> AiAbilityDecision : uses
    DebuffAi ..> Card : uses
    DebuffAi ..> CardCollection : uses
    DebuffAi ..> Combat : uses
    DebuffAi ..> Cost : uses
    DebuffAi ..> Game : uses
    DebuffAi ..> PhaseHandler : uses
    DebuffAi ..> Player : uses
    DebuffAi ..> SpellAbility : uses
    DebuffAi ..> TargetRestrictions : uses
```

## Relationships
**Extends:**
- [[forge.ai.SpellAbilityAi|SpellAbilityAi]]
**Uses:**
- [[forge.ai.AiAbilityDecision|AiAbilityDecision]]
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.card.CardCollection|CardCollection]]
- [[forge.game.combat.Combat|Combat]]
- [[forge.game.cost.Cost|Cost]]
- [[forge.game.phase.PhaseHandler|PhaseHandler]]
- [[forge.game.player.Player|Player]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]
- [[forge.game.spellability.TargetRestrictions|TargetRestrictions]]

## Design Description

Beyond targeting, `DebuffAi` is a `SpellAbilityAi` subclass that drives the AI's decision-making for "debuff" effectsâ€”spells and abilities that strip keywords (typically evasion such as Flying, Horsemanship, or Shadow, or protective keywords like Indestructible and Persist) from creatures. It overrides the standard AI hooksâ€”`canPlay`, `chkDrawback`, and `doTriggerNoCost`â€”to decide when activation is worthwhile, layering in cost checks (sacrifice, life, counter removal via `ComputerUtilCost`) and phase restrictions that confine instant-speed use to combat.

Its private helpers encode the core intent: `getCurseCreatures` collects an opponent's targetable creatures that actually bear the keywords being removed (avoiding wasted, duplicate debuffs), `debuffTgtAI` greedily picks the best such creatures via `ComputerUtilCard`, and `debuffMandatoryTarget` handles forced-targeting fallbacks, preferring opponents' permanents but conceding own-controlled ones when required. It collaborates with `Game`, `PhaseHandler`, and `Combat` to time decisions around the combat phase, and returns `AiAbilityDecision` verdicts throughout.

## Source
`forge-ai/src/main/java/forge/ai/ability/DebuffAi.java`

```java
package forge.ai.ability;

import com.google.common.collect.Lists;
import forge.ai.*;
import forge.game.Game;
import forge.game.ability.AbilityUtils;
import forge.game.card.Card;
import forge.game.card.CardCollection;
import forge.game.card.CardLists;
import forge.game.card.CardUtil;
import forge.game.combat.Combat;
import forge.game.cost.Cost;
import forge.game.phase.PhaseHandler;
import forge.game.phase.PhaseType;
import forge.game.player.Player;
import forge.game.spellability.SpellAbility;
import forge.game.spellability.TargetRestrictions;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class DebuffAi extends SpellAbilityAi {

    @Override
    protected AiAbilityDecision canPlay(final Player ai, final SpellAbility sa) {
        // if there is no target and host card isn't in play, don't activate
        final Card source = sa.getHostCard();
        final Game game = ai.getGame(); 
        if (!sa.usesTargeting() && !source.isInPlay()) {
            return new AiAbilityDecision(0, AiPlayDecision.CantPlayAi);
        }

        final Cost cost = sa.getPayCosts();

        // temporarily disabled until AI is improved
        if (!ComputerUtilCost.checkCreatureSacrificeCost(ai, cost, source, sa)) {
            return new AiAbilityDecision(0, AiPlayDecision.CantAfford);
        }

        if (!ComputerUtilCost.checkLifeCost(ai, cost, source, 40, sa)) {
            return new AiAbilityDecision(0, AiPlayDecision.CantAfford);
        }

        if (!ComputerUtilCost.checkRemoveCounterCost(cost, source, sa)) {
            return new AiAbilityDecision(0, AiPlayDecision.CantAfford);
        }

        final PhaseHandler ph =  game.getPhaseHandler();

        // Phase Restrictions
        if (ph.getPhase().isBefore(PhaseType.COMBAT_DECLARE_ATTACKERS)
                || ph.getPhase().isAfter(PhaseType.COMBAT_DECLARE_BLOCKERS)
                || !game.getStack().isEmpty()) {
            // Instant-speed pumps should not be cast outside of combat when the
            // stack is empty, unless there are specific activation phase requirements
            if (!isSorcerySpeed(sa, ai) && !sa.hasParam("ActivationPhases")) {
                return new AiAbilityDecision(0, AiPlayDecision.AnotherTime);
            }
        }

        if (!sa.usesTargeting()) {
            List<Card> cards = AbilityUtils.getDefinedCards(source, sa.getParam("Defined"), sa);

            final Combat combat = game.getCombat();
            if (cards.stream().anyMatch(c -> {
                if (c.getController().equals(sa.getActivatingPlayer()) || combat == null)
                    return false;

                if (!combat.isBlocking(c) && !combat.isAttacking(c)) {
                    return false;
                }
                // don't add duplicate negative keywords
                return sa.hasParam("Keywords") && c.hasAnyKeyword(Arrays.asList(sa.getParam("Keywords").split(" & ")));
            })) {
                return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
            } else {
                return new AiAbilityDecision(0, AiPlayDecision.CantPlayAi);
            }
        } else {
            if (debuffTgtAI(ai, sa, sa.hasParam("Keywords") ? Arrays.asList(sa.getParam("Keywords").split(" & ")) : null, false)) {
                return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
            } else {
                return new AiAbilityDecision(0, AiPlayDecision.TargetingFailed);
            }
        }
    }

    @Override
    public AiAbilityDecision chkDrawback(Player ai, SpellAbility sa) {
        if (!sa.usesTargeting()) {
            // TODO - copied from AF_Pump.pumpDrawbackAI() - what should be here?
        } else {
            if (debuffTgtAI(ai, sa, sa.hasParam("Keywords") ? Arrays.asList(sa.getParam("Keywords").split(" & ")) : null, false)) {
                return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
            } else {
                return new AiAbilityDecision(0, AiPlayDecision.TargetingFailed);
            }
        }

        return new AiAbilityDecision(100, AiPlayDecision.WillPlay);

    } // debuffDrawbackAI()

    /**
     * <p>
     * debuffTgtAI.
     * </p>
     *
     * @param sa
     *            a {@link forge.game.spellability.SpellAbility} object.
     * @param kws
     *            a {@link java.util.ArrayList} object.
     * @param mandatory
     *            a boolean.
     * @return a boolean.
     */
    private boolean debuffTgtAI(final Player ai, final SpellAbility sa, final List<String> kws, final boolean mandatory) {
        // this would be for evasive things like Flying, Unblockable, etc
        if (!mandatory && ai.getGame().getPhaseHandler().getPhase().isAfter(PhaseType.COMBAT_DECLARE_BLOCKERS)) {
            return false;
        }

        final TargetRestrictions tgt = sa.getTargetRestrictions();
        sa.resetTargets();
        CardCollection list = getCurseCreatures(ai, sa, kws == null ? Lists.newArrayList() : kws);

        // several uses here:
        // 1. make human creatures lose evasion when they are attacking
        // 2. make human creatures lose Flying/Horsemanship/Shadow/etc. when
        // Comp is attacking
        // 3. remove Indestructible keyword so it can be destroyed?
        // 3a. remove Persist?

        if (list.isEmpty()) {
            return mandatory && debuffMandatoryTarget(ai, sa, mandatory);
        }

        while (sa.canAddMoreTarget()) {
            Card t = null;

            if (list.isEmpty()) {
                if (sa.getTargets().size() < sa.getMinTargets() || sa.getTargets().size() == 0) {
                    if (mandatory) {
                        return debuffMandatoryTarget(ai, sa, mandatory);
                    }

                    sa.resetTargets();
                    return false;
                } else {
                    // TODO is this good enough? for up to amounts?
                    break;
                }
            }

            t = ComputerUtilCard.getBestCreatureAI(list);
            sa.getTargets().add(t);
            list.remove(t);
        }

        return true;
    } // pumpTgtAI()

    /**
     * <p>
     * getCurseCreatures.
     * </p>
     *
     * @param sa
     *            a {@link forge.game.spellability.SpellAbility} object.
     * @param kws
     *            a {@link java.util.ArrayList} object.
     * @return a CardCollection.
     */
    private CardCollection getCurseCreatures(final Player ai, final SpellAbility sa, final List<String> kws) {
        final Player opp = AiAttackController.choosePreferredDefenderPlayer(ai);
        CardCollection list = CardLists.getTargetableCards(opp.getCreaturesInPlay(), sa);
        if (!list.isEmpty()) {
            list = CardLists.filter(list, c -> {
                return c.hasAnyKeyword(kws); // don't add duplicate negative keywords
            });
        }
        return list;
    }

    /**
     * <p>
     * debuffMandatoryTarget.
     * </p>
     *
     * @param sa
     *            a {@link forge.game.spellability.SpellAbility} object.
     * @param mandatory
     *            a boolean.
     * @return a boolean.
     */
    private boolean debuffMandatoryTarget(final Player ai, final SpellAbility sa, final boolean mandatory) {
        List<Card> list = CardUtil.getValidCardsToTarget(sa);

        if (list.size() < sa.getMinTargets()) {
            sa.resetTargets();
            return false;
        }

        final CardCollection pref = CardLists.filterControlledBy(list, ai.getOpponents());
        final CardCollection forced = CardLists.filterControlledBy(list, ai);
        final Card source = sa.getHostCard();

        while (sa.canAddMoreTarget()) {
            if (pref.isEmpty()) {
                break;
            }

            Card c = ComputerUtilCard.getBestAI(pref);
            pref.remove(c);
            sa.getTargets().add(c);
        }

        while (!sa.isMinTargetChosen()) {
            if (forced.isEmpty()) {
                break;
            }

            // TODO - if forced targeting, just pick something without the given keyword
            Card c;
            if (CardLists.getNotType(forced, "Creature").size() == 0) {
                c = ComputerUtilCard.getWorstCreatureAI(forced);
            } else {
                c = ComputerUtilCard.getCheapestPermanentAI(forced, sa, false);
            }

            forced.remove(c);

            sa.getTargets().add(c);
        }

        if (!sa.isMinTargetChosen()) {
            sa.resetTargets();
            return false;
        }

        return true;
    }

    @Override
    protected AiAbilityDecision doTriggerNoCost(Player ai, SpellAbility sa, boolean mandatory) {
        final List<String> kws = sa.hasParam("Keywords") ? Arrays.asList(sa.getParam("Keywords").split(" & ")) : new ArrayList<>();

        if (!sa.usesTargeting()) {
            if (mandatory) {
                return new AiAbilityDecision(100, AiPlayDecision.WillPlay);

            }
        } else {
            if (debuffTgtAI(ai, sa, kws, mandatory)) {
                return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
            } else {
                return new AiAbilityDecision(0, AiPlayDecision.TargetingFailed);
            }
        }

        return new AiAbilityDecision(100, AiPlayDecision.WillPlay);

    }

}
```

## Python
`forge/ai/ability/DebuffAi.py`

```python
from forge.ai.SpellAbilityAi import SpellAbilityAi
from forge.ai.AiAbilityDecision import AiAbilityDecision
from forge.ai.AiPlayDecision import AiPlayDecision
from forge.ai.ComputerUtilCost import ComputerUtilCost
from forge.ai.ComputerUtilCard import ComputerUtilCard
from forge.ai.AiAttackController import AiAttackController
from forge.game.Game import Game
from forge.game.ability.AbilityUtils import AbilityUtils
from forge.game.card.Card import Card
from forge.game.card.CardCollection import CardCollection
from forge.game.card.CardLists import CardLists
from forge.game.card.CardUtil import CardUtil
from forge.game.combat.Combat import Combat
from forge.game.cost.Cost import Cost
from forge.game.phase.PhaseHandler import PhaseHandler
from forge.game.phase.PhaseType import PhaseType
from forge.game.player.Player import Player
from forge.game.spellability.SpellAbility import SpellAbility
from forge.game.spellability.TargetRestrictions import TargetRestrictions


class DebuffAi(SpellAbilityAi):

    def canPlay(self, ai: Player, sa: SpellAbility) -> AiAbilityDecision:
        # if there is no target and host card isn't in play, don't activate
        source = sa.getHostCard()
        game = ai.getGame()
        if not sa.usesTargeting() and not source.isInPlay():
            return AiAbilityDecision(0, AiPlayDecision.CantPlayAi)

        cost = sa.getPayCosts()

        # temporarily disabled until AI is improved
        if not ComputerUtilCost.checkCreatureSacrificeCost(ai, cost, source, sa):
            return AiAbilityDecision(0, AiPlayDecision.CantAfford)

        if not ComputerUtilCost.checkLifeCost(ai, cost, source, 40, sa):
            return AiAbilityDecision(0, AiPlayDecision.CantAfford)

        if not ComputerUtilCost.checkRemoveCounterCost(cost, source, sa):
            return AiAbilityDecision(0, AiPlayDecision.CantAfford)

        ph = game.getPhaseHandler()

        # Phase Restrictions
        if (ph.getPhase().isBefore(PhaseType.COMBAT_DECLARE_ATTACKERS)
                or ph.getPhase().isAfter(PhaseType.COMBAT_DECLARE_BLOCKERS)
                or not game.getStack().isEmpty()):
            # Instant-speed pumps should not be cast outside of combat when the
            # stack is empty, unless there are specific activation phase requirements
            if not self.isSorcerySpeed(sa, ai) and not sa.hasParam("ActivationPhases"):
                return AiAbilityDecision(0, AiPlayDecision.AnotherTime)

        if not sa.usesTargeting():
            cards = AbilityUtils.getDefinedCards(source, sa.getParam("Defined"), sa)

            combat = game.getCombat()

            def matches(c: Card) -> bool:
                if c.getController().equals(sa.getActivatingPlayer()) or combat is None:
                    return False

                if not combat.isBlocking(c) and not combat.isAttacking(c):
                    return False
                # don't add duplicate negative keywords
                return sa.hasParam("Keywords") and c.hasAnyKeyword(sa.getParam("Keywords").split(" & "))

            if any(matches(c) for c in cards):
                return AiAbilityDecision(100, AiPlayDecision.WillPlay)
            else:
                return AiAbilityDecision(0, AiPlayDecision.CantPlayAi)
        else:
            if self.debuffTgtAI(ai, sa, sa.getParam("Keywords").split(" & ") if sa.hasParam("Keywords") else None, False):
                return AiAbilityDecision(100, AiPlayDecision.WillPlay)
            else:
                return AiAbilityDecision(0, AiPlayDecision.TargetingFailed)

    def chkDrawback(self, ai: Player, sa: SpellAbility) -> AiAbilityDecision:
        if not sa.usesTargeting():
            # TODO - copied from AF_Pump.pumpDrawbackAI() - what should be here?
            pass
        else:
            if self.debuffTgtAI(ai, sa, sa.getParam("Keywords").split(" & ") if sa.hasParam("Keywords") else None, False):
                return AiAbilityDecision(100, AiPlayDecision.WillPlay)
            else:
                return AiAbilityDecision(0, AiPlayDecision.TargetingFailed)

        return AiAbilityDecision(100, AiPlayDecision.WillPlay)

    # debuffDrawbackAI()

    def debuffTgtAI(self, ai: Player, sa: SpellAbility, kws: list[str], mandatory: bool) -> bool:
        # this would be for evasive things like Flying, Unblockable, etc
        if not mandatory and ai.getGame().getPhaseHandler().getPhase().isAfter(PhaseType.COMBAT_DECLARE_BLOCKERS):
            return False

        tgt = sa.getTargetRestrictions()
        sa.resetTargets()
        list = self.getCurseCreatures(ai, sa, [] if kws is None else kws)

        # several uses here:
        # 1. make human creatures lose evasion when they are attacking
        # 2. make human creatures lose Flying/Horsemanship/Shadow/etc. when
        # Comp is attacking
        # 3. remove Indestructible keyword so it can be destroyed?
        # 3a. remove Persist?

        if list.isEmpty():
            return mandatory and self.debuffMandatoryTarget(ai, sa, mandatory)

        while sa.canAddMoreTarget():
            t = None

            if list.isEmpty():
                if sa.getTargets().size() < sa.getMinTargets() or sa.getTargets().size() == 0:
                    if mandatory:
                        return self.debuffMandatoryTarget(ai, sa, mandatory)

                    sa.resetTargets()
                    return False
                else:
                    # TODO is this good enough? for up to amounts?
                    break

            t = ComputerUtilCard.getBestCreatureAI(list)
            sa.getTargets().add(t)
            list.remove(t)

        return True

    # pumpTgtAI()

    def getCurseCreatures(self, ai: Player, sa: SpellAbility, kws: list[str]) -> CardCollection:
        opp = AiAttackController.choosePreferredDefenderPlayer(ai)
        list = CardLists.getTargetableCards(opp.getCreaturesInPlay(), sa)
        if not list.isEmpty():
            list = CardLists.filter(list, lambda c: c.hasAnyKeyword(kws))  # don't add duplicate negative keywords
        return list

    def debuffMandatoryTarget(self, ai: Player, sa: SpellAbility, mandatory: bool) -> bool:
        list = CardUtil.getValidCardsToTarget(sa)

        if list.size() < sa.getMinTargets():
            sa.resetTargets()
            return False

        pref = CardLists.filterControlledBy(list, ai.getOpponents())
        forced = CardLists.filterControlledBy(list, ai)
        source = sa.getHostCard()

        while sa.canAddMoreTarget():
            if pref.isEmpty():
                break

            c = ComputerUtilCard.getBestAI(pref)
            pref.remove(c)
            sa.getTargets().add(c)

        while not sa.isMinTargetChosen():
            if forced.isEmpty():
                break

            # TODO - if forced targeting, just pick something without the given keyword
            if CardLists.getNotType(forced, "Creature").size() == 0:
                c = ComputerUtilCard.getWorstCreatureAI(forced)
            else:
                c = ComputerUtilCard.getCheapestPermanentAI(forced, sa, False)

            forced.remove(c)

            sa.getTargets().add(c)

        if not sa.isMinTargetChosen():
            sa.resetTargets()
            return False

        return True

    def doTriggerNoCost(self, ai: Player, sa: SpellAbility, mandatory: bool) -> AiAbilityDecision:
        kws = sa.getParam("Keywords").split(" & ") if sa.hasParam("Keywords") else []

        if not sa.usesTargeting():
            if mandatory:
                return AiAbilityDecision(100, AiPlayDecision.WillPlay)
        else:
            if self.debuffTgtAI(ai, sa, kws, mandatory):
                return AiAbilityDecision(100, AiPlayDecision.WillPlay)
            else:
                return AiAbilityDecision(0, AiPlayDecision.TargetingFailed)

        return AiAbilityDecision(100, AiPlayDecision.WillPlay)
```
