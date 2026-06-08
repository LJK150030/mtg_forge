---
aliases:
  - RearrangeTopOfLibraryAi
tags:
  - java/class
  - module/forge-ai
  - pkg/forge/ai/ability
fqn: forge.ai.ability.RearrangeTopOfLibraryAi
package: forge.ai.ability
module: forge-ai
kind: Class
---

# RearrangeTopOfLibraryAi

**Package:** `forge.ai.ability` &nbsp; **Module:** `forge-ai` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class RearrangeTopOfLibraryAi {
        #canPlay(Player aiPlayer, SpellAbility sa) AiAbilityDecision
        #doTriggerNoCost(Player ai, SpellAbility sa, boolean mandatory) AiAbilityDecision
        +confirmAction(Player player, SpellAbility sa, PlayerActionConfirmMode mode, String message, Map~String,Object~ params) boolean
    }
    RearrangeTopOfLibraryAi --|> SpellAbilityAi : extends
    RearrangeTopOfLibraryAi ..> AiAbilityDecision : uses
    RearrangeTopOfLibraryAi ..> Card : uses
    RearrangeTopOfLibraryAi ..> PhaseHandler : uses
    RearrangeTopOfLibraryAi ..> Player : uses
    RearrangeTopOfLibraryAi ..> PlayerActionConfirmMode : uses
    RearrangeTopOfLibraryAi ..> PlayerCollection : uses
    RearrangeTopOfLibraryAi ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.ai.SpellAbilityAi|SpellAbilityAi]]
**Uses:**
- [[forge.ai.AiAbilityDecision|AiAbilityDecision]]
- [[forge.game.card.Card|Card]]
- [[forge.game.phase.PhaseHandler|PhaseHandler]]
- [[forge.game.player.Player|Player]]
- [[forge.game.player.PlayerActionConfirmMode|PlayerActionConfirmMode]]
- [[forge.game.player.PlayerCollection|PlayerCollection]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

RearrangeTopOfLibraryAi supplies the AI's decision logic for abilities that let a player rearrange (and optionally shuffle) the top cards of a library, such as scry-like and library-manipulation effects. Extending SpellAbilityAi, it overrides canPlay to gate activation—respecting sorcery-speed and cost restrictions, limiting paid uses to once per turn before the AI's own turn, and selecting a target player (self, opponent, or a coin-flip between them) via PlayerCollection and life comparison—while doTriggerNoCost reuses that judgment and falls back to a mandatory play when required.

Its confirmAction implements the shuffle-or-keep choice using profile-driven heuristics (configurable land counts and uncastable-CMC thresholds) that inspect the revealed top card, mana availability, and lands in play, deciding to shuffle away uncastable or unwanted cards differently for allies versus opponents. The class collaborates with PhaseHandler, Card, and Player but delegates the actual card ordering to PlayerControllerAi, keeping itself focused purely on strategic intent.

## Source
`forge-ai/src/main/java/forge/ai/ability/RearrangeTopOfLibraryAi.java`

```java
package forge.ai.ability;

import forge.ai.*;
import forge.game.ability.AbilityUtils;
import forge.game.card.Card;
import forge.game.card.CardLists;
import forge.game.card.CardPredicates;
import forge.game.phase.PhaseHandler;
import forge.game.phase.PhaseType;
import forge.game.player.Player;
import forge.game.player.PlayerActionConfirmMode;
import forge.game.player.PlayerCollection;
import forge.game.player.PlayerPredicates;
import forge.game.spellability.SpellAbility;
import forge.game.zone.ZoneType;
import forge.util.MyRandom;

import java.util.Map;

public class RearrangeTopOfLibraryAi extends SpellAbilityAi {
    /* (non-Javadoc)
     * @see forge.card.abilityfactory.SpellAiLogic#canPlayAI(forge.game.player.Player, java.util.Map, forge.card.spellability.SpellAbility)
     */
    @Override
    protected AiAbilityDecision canPlay(Player aiPlayer, SpellAbility sa) {
        // Specific details of ordering cards are handled by PlayerControllerAi#orderMoveToZoneList
        final PhaseHandler ph = aiPlayer.getGame().getPhaseHandler();
        final Card source = sa.getHostCard();

        if (!sa.isTrigger()) {
            if (source.isPermanent() && !sa.getRestrictions().isSorcerySpeed()
                    && (sa.getPayCosts().hasTapCost() || sa.getPayCosts().hasManaCost())) {
                // If it has an associated cost, try to only do this before own turn
                if (!(ph.is(PhaseType.END_OF_TURN) && ph.getNextTurn() == aiPlayer)) {
                    return new AiAbilityDecision(0, AiPlayDecision.CantPlayAi);
                }
            }

            // Do it once per turn, generally (may be improved later)
            if (source.getAbilityActivatedThisTurn().getActivators(sa).contains(aiPlayer)) {
                return new AiAbilityDecision(0, AiPlayDecision.CantPlayAi);
            }
        }

        if (sa.usesTargeting()) {
            sa.resetTargets();

            PlayerCollection targetableOpps = aiPlayer.getOpponents().filter(PlayerPredicates.isTargetableBy(sa));
            Player opp = targetableOpps.min(PlayerPredicates.compareByLife());
            final boolean canTgtAI = sa.canTarget(aiPlayer);
            final boolean canTgtHuman = sa.canTarget(opp);

            if (canTgtHuman && canTgtAI) {
                // TODO: maybe some other consideration rather than random?
                Player preferredTarget = MyRandom.percentTrue(50) ? aiPlayer : opp;
                sa.getTargets().add(preferredTarget);
            } else if (canTgtAI) {
                sa.getTargets().add(aiPlayer);
            } else if (canTgtHuman) {
                sa.getTargets().add(opp);
            } else {
                return new AiAbilityDecision(0, AiPlayDecision.CantPlayAi); // could not find a valid target
            }
        }

        return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
    }

    /* (non-Javadoc)
     * @see forge.card.abilityfactory.SpellAiLogic#doTriggerAINoCost(forge.game.player.Player, java.util.Map, forge.card.spellability.SpellAbility, boolean)
     */
    @Override
    protected AiAbilityDecision doTriggerNoCost(Player ai, SpellAbility sa, boolean mandatory) {
        AiAbilityDecision decision = canPlay(ai, sa);
        if (decision.willingToPlay()) {
            return decision;
        }

        if (mandatory) {
            return new AiAbilityDecision(50, AiPlayDecision.MandatoryPlay);
        }

        return decision;
    }

    /* (non-Javadoc)
     * @see forge.card.ability.SpellAbilityAi#confirmAction(forge.game.player.Player, forge.card.spellability.SpellAbility, forge.game.player.PlayerActionConfirmMode, java.lang.String)
     */
    @Override
    public boolean confirmAction(Player player, SpellAbility sa, PlayerActionConfirmMode mode, String message, Map<String, Object> params) {
        // Confirming this action means shuffling the library if asked.

        // First, let's check if we can play the top card of the library
        PlayerCollection pc = sa.usesTargeting() ? new PlayerCollection(sa.getTargets().getTargetPlayers())
                : AbilityUtils.getDefinedPlayers(sa.getHostCard(), sa.getParam("Defined"), sa);

        Player p = pc.getFirst(); // currently always a single target spell
        Card top = p.getCardsIn(ZoneType.Library).isEmpty() ? null : p.getCardsIn(ZoneType.Library).getFirst();
        if (top == null) {
            return false;
        }

        int minLandsToScryLandsAway = AiProfileUtil.getIntProperty(player, AiProps.SCRY_NUM_LANDS_TO_NOT_NEED_MORE);
        int uncastableCMCThreshold = AiProfileUtil.getIntProperty(player, AiProps.SCRY_IMMEDIATELY_UNCASTABLE_CMC_DIFF);

        int landsOTB = CardLists.count(p.getCardsIn(ZoneType.Battlefield), CardPredicates.LANDS_PRODUCING_MANA);
        int cmc = top.isSplitCard() ? Math.min(top.getCMC(Card.SplitCMCMode.LeftSplitCMC), top.getCMC(Card.SplitCMCMode.RightSplitCMC))
                : top.getCMC();
        int maxCastable = ComputerUtilMana.getAvailableManaEstimate(p, false);

        if (!top.isLand() && cmc - maxCastable >= uncastableCMCThreshold) {
            // Can't cast in the foreseeable future. Shuffle if doing it to ourselves or an ally, otherwise keep it
            return !p.isOpponentOf(player);
        } else if (top.isLand() && landsOTB <= minLandsToScryLandsAway) {
            // We don't want to give the opponent a free land if his land count is low
            return p.isOpponentOf(player);
        }

        // Usually we don't want to shuffle if we arranged things carefully
        return false;
    }
}
```
