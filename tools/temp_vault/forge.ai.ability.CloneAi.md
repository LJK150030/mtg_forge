---
aliases:
  - CloneAi
tags:
  - java/class
  - module/forge-ai
  - pkg/forge/ai/ability
fqn: forge.ai.ability.CloneAi
package: forge.ai.ability
module: forge-ai
kind: Class
---

# CloneAi

**Package:** `forge.ai.ability` &nbsp; **Module:** `forge-ai` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class CloneAi {
        #checkApiLogic(Player ai, SpellAbility sa) AiAbilityDecision
        +chkDrawback(Player aiPlayer, SpellAbility sa) AiAbilityDecision
        #doTriggerNoCost(Player aiPlayer, SpellAbility sa, boolean mandatory) AiAbilityDecision
        -cloneTgtAI(SpellAbility sa, boolean mandatory) boolean
        +confirmAction(Player player, SpellAbility sa, PlayerActionConfirmMode mode, String message, Map~String,Object~ params) boolean
        #chooseSingleCard(Player ai, SpellAbility sa, Iterable~Card~ options, boolean isOptional, Player targetedPlayer, Map~String,Object~ params) Card
        #getCloneTarget(SpellAbility sa) Card
        #checkPhaseRestrictions(Player ai, SpellAbility sa, PhaseHandler ph) boolean
    }
    CloneAi --|> SpellAbilityAi : extends
    CloneAi ..> AiAbilityDecision : uses
    CloneAi ..> Card : uses
    CloneAi ..> CardCollection : uses
    CloneAi ..> CardCollectionView : uses
    CloneAi ..> Game : uses
    CloneAi ..> PhaseHandler : uses
    CloneAi ..> Player : uses
    CloneAi ..> PlayerActionConfirmMode : uses
    CloneAi ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.ai.SpellAbilityAi|SpellAbilityAi]]
**Uses:**
- [[forge.ai.AiAbilityDecision|AiAbilityDecision]]
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.card.CardCollection|CardCollection]]
- [[forge.game.card.CardCollectionView|CardCollectionView]]
- [[forge.game.phase.PhaseHandler|PhaseHandler]]
- [[forge.game.player.Player|Player]]
- [[forge.game.player.PlayerActionConfirmMode|PlayerActionConfirmMode]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

CloneAi supplies the AI decision logic for clone-style spell abilities, deciding whether the computer should cast or activate an effect that copies a creature or permanent. As a concrete subclass of `SpellAbilityAi`, it overrides the framework's hook methods—`checkApiLogic`, `chkDrawback`, `doTriggerNoCost`, `confirmAction`, `chooseSingleCard`, and `checkPhaseRestrictions`—returning `AiAbilityDecision` verdicts that the engine consumes. It collaborates with the game model (`Card`, `Player`, `Game`, `PhaseHandler`, `SpellAbility`) to inspect targets and timing, and delegates creature valuation to `ComputerUtilCard` so it clones the best available target (or the worst, when copying an opponent's permanent).

Notable design intent: it gates instant-speed clones to sensible combat phases, guards against infinite ETB-replacement loops when a cloned source re-triggers, and branches on card-specific `AILogic`/name cases (e.g. Vesuva, Sculpting Steel) to avoid degenerate self-copies. Several TODOs mark the heuristics as deliberately conservative placeholders.

## Source
`forge-ai/src/main/java/forge/ai/ability/CloneAi.java`

```java
package forge.ai.ability;

import forge.ai.AiAbilityDecision;
import forge.ai.AiPlayDecision;
import forge.ai.ComputerUtilCard;
import forge.ai.SpellAbilityAi;
import forge.game.Game;
import forge.game.ability.AbilityUtils;
import forge.game.card.*;
import forge.game.phase.PhaseHandler;
import forge.game.phase.PhaseType;
import forge.game.player.Player;
import forge.game.player.PlayerActionConfirmMode;
import forge.game.spellability.SpellAbility;
import forge.game.zone.ZoneType;

import java.util.List;
import java.util.Map;

public class CloneAi extends SpellAbilityAi {

    @Override
    protected AiAbilityDecision checkApiLogic(Player ai, SpellAbility sa) {
        final Card source = sa.getHostCard();
        final Game game = source.getGame();

        boolean useAbility = true;

        // TODO - add some kind of check to answer
        // "Am I going to attack with this?"
        // TODO - add some kind of check for during human turn to answer
        // "Can I use this to block something?"

        PhaseHandler phase = game.getPhaseHandler();

        if (sa.usesTargeting()) {
            sa.resetTargets();
            useAbility &= cloneTgtAI(sa, false);
        } else {
            final List<Card> defined = AbilityUtils.getDefinedCards(source, sa.getParam("Defined"), sa);

            boolean bFlag = false;
            for (final Card c : defined) {
                bFlag |= !c.isCreature() && !c.isTapped() && !(c.getTurnInZone() == phase.getTurn());

                // for creatures that could be improved (like Figure of Destiny)
                if (c.isCreature() && (!sa.hasParam("Duration") || (!c.isTapped() && !c.isSick()))) {
                    int power = -5;
                    if (sa.hasParam("Power")) {
                        power = AbilityUtils.calculateAmount(source, sa.getParam("Power"), sa);
                    }
                    int toughness = -5;
                    if (sa.hasParam("Toughness")) {
                        toughness = AbilityUtils.calculateAmount(source, sa.getParam("Toughness"), sa);
                    }
                    if ((power + toughness) > (c.getCurrentPower() + c.getCurrentToughness())) {
                        bFlag = true;
                    }
                }
            }

            if (!bFlag) { // All of the defined stuff is cloned, not very useful
                return new AiAbilityDecision(0, AiPlayDecision.MissingNeededCards);
            }
        }

        return useAbility ? new AiAbilityDecision(100, AiPlayDecision.WillPlay)
                : new AiAbilityDecision(0, AiPlayDecision.CantPlayAi);
    }

    @Override
    public AiAbilityDecision chkDrawback(Player aiPlayer, SpellAbility sa) {
        // AI should only activate this during Human's turn
        boolean chance = true;

        if (sa.usesTargeting()) {
            chance = cloneTgtAI(sa, false);
        }

        return chance ? new AiAbilityDecision(100, AiPlayDecision.WillPlay)
                : new AiAbilityDecision(0, AiPlayDecision.CantPlayAi);
    }

    @Override
    protected AiAbilityDecision doTriggerNoCost(Player aiPlayer, SpellAbility sa, boolean mandatory) {
        Card host = sa.getHostCard();
        boolean chance = true;

        if (sa.usesTargeting()) {
            chance = cloneTgtAI(sa, mandatory);
        } else {
            if (sa.isReplacementAbility() && host.isCloned()) {
                // prevent StackOverflow from infinite loop copying another ETB RE
                return new AiAbilityDecision(0, AiPlayDecision.StopRunawayActivations);
            }
            if (sa.hasParam("Choices")) {
                CardCollectionView choices = CardLists.getValidCards(host.getGame().getCardsIn(ZoneType.Battlefield),
                        sa.getParam("Choices"), host.getController(), host, sa);

                chance = !choices.isEmpty();
            }
        }

        // Improve AI for triggers. If source is a creature with:
        // When ETB, sacrifice a creature. Check to see if the AI has something
        // to sacrifice

        // Eventually, we can call the trigger of ETB abilities with
        // not mandatory as part of the checks to cast something

        if (mandatory || chance) {
            return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
        }

        return new AiAbilityDecision(0, AiPlayDecision.CantPlayAi);
    }

    /**
     * <p>
     * cloneTgtAI.
     * </p>
     *
     * @param sa
     *            a {@link forge.game.spellability.SpellAbility} object.
     * @return a boolean.
     */
    private boolean cloneTgtAI(final SpellAbility sa, boolean mandatory) {
        // Specific logic for cards
        List<Card> targets = CardUtil.getValidCardsToTarget(sa);
        if (mandatory && targets.isEmpty()) {
            return false;
        }

        if (mandatory || "CloneBestCreature".equals(sa.getParam("AILogic"))) {
            sa.getTargets().add(ComputerUtilCard.getBestCreatureAI(targets));
            return true;
        }

        // Default:
        // This is reasonable for now. Kamahl, Fist of Krosa and a sorcery or
        // two are the only things that clone a target. Those can just use
        // AI:RemoveDeck:All until this can do a reasonably good job of picking
        // a good target
        return false;
    }

    /* (non-Javadoc)
     * @see forge.card.ability.SpellAbilityAi#confirmAction(forge.game.player.Player, forge.card.spellability.SpellAbility, forge.game.player.PlayerActionConfirmMode, java.lang.String)
     */
    @Override
    public boolean confirmAction(Player player, SpellAbility sa, PlayerActionConfirmMode mode, String message, Map<String, Object> params) {
        if (sa.hasParam("AILogic") && (!sa.usesTargeting() || sa.isTargetNumberValid())) {
            // Had a special logic for it and managed to target, so confirm if viable
            if ("CloneBestCreature".equals(sa.getParam("AILogic"))) {
                return ComputerUtilCard.evaluateCreature(sa.getTargetCard()) > ComputerUtilCard.evaluateCreature(sa.getHostCard());
            } else if ("IfDefinedCreatureIsBetter".equals(sa.getParam("AILogic"))) {
                List<Card> defined = AbilityUtils.getDefinedCards(sa.getHostCard(), sa.getParam("Defined"), sa);
                Card bestDefined = ComputerUtilCard.getBestCreatureAI(defined);
                return ComputerUtilCard.evaluateCreature(bestDefined) > ComputerUtilCard.evaluateCreature(sa.getHostCard());
            }
        }

        // Currently doesn't confirm anything that's not defined by AI logic
        return false;
    }

    /*
     * (non-Javadoc)
     *
     * @see forge.ai.SpellAbilityAi#chooseSingleCard(forge.game.player.Player,
     * forge.game.spellability.SpellAbility, java.lang.Iterable, boolean,
     * forge.game.player.Player)
     */
    @Override
    protected Card chooseSingleCard(Player ai, SpellAbility sa, Iterable<Card> options, boolean isOptional,
            Player targetedPlayer, Map<String, Object> params) {
        final Card host = sa.getHostCard();
        final String name = host.getName();
        final Player ctrl = host.getController();

        final Card cloneTarget = getCloneTarget(sa);
        final boolean isOpp = cloneTarget.getController().isOpponentOf(sa.getActivatingPlayer());

        final boolean isVesuva = "Vesuva".equals(name) || "Sculpting Steel".equals(name);
        final boolean canCloneLegendary = "True".equalsIgnoreCase(sa.getParam("NonLegendary"));

        String filter = !isVesuva ? "Permanent.YouDontCtrl,Permanent.nonLegendary"
                : "Permanent.YouDontCtrl+!named" + name + ",Permanent.nonLegendary+!named" + name;

        // TODO: rewrite this block so that this is done somehow more elegantly
        if (canCloneLegendary) {
            filter = filter.replace(".nonLegendary+", ".").replace(".nonLegendary", "");
        }

        CardCollection newOptions = CardLists.getValidCards(options, filter, ctrl, host, sa);
        if (!newOptions.isEmpty()) {
            options = newOptions;
        }

        if (sa.hasParam("AiChoiceLogic")) {
            final String logic = sa.getParam("AiChoiceLogic");
            if ("BestOppCtrl".equals(logic)) {
                options = CardLists.filterControlledBy(options, ctrl.getOpponents());
            }
        }

        // prevent loop of choosing copy of same card
        if (isVesuva) {
            options = CardLists.filter(options, CardPredicates.sharesNameWith(host).negate());
        }

        Card choice = isOpp ? ComputerUtilCard.getWorstAI(options) : ComputerUtilCard.getBestAI(options);

        return choice;
    }

    protected Card getCloneTarget(final SpellAbility sa) {
        final Card host = sa.getHostCard();
        Card tgtCard = host;
        if (sa.hasParam("CloneTarget")) {
            final List<Card> cloneTargets = AbilityUtils.getDefinedCards(host, sa.getParam("CloneTarget"), sa);
            if (!cloneTargets.isEmpty()) {
                tgtCard = cloneTargets.get(0);
            }
        } else if (sa.hasParam("Choices") && sa.usesTargeting()) {
            tgtCard = sa.getTargetCard();
        }

        return tgtCard;
    }

    /*
     * (non-Javadoc)
     * @see forge.ai.SpellAbilityAi#checkPhaseRestrictions(forge.game.player.Player, forge.game.spellability.SpellAbility, forge.game.phase.PhaseHandler)
     */
    protected boolean checkPhaseRestrictions(final Player ai, final SpellAbility sa, final PhaseHandler ph) {
        // don't use instant speed clone abilities outside computers
        // Combat_Begin step
        if (!ph.is(PhaseType.COMBAT_BEGIN)
                && ph.isPlayerTurn(ai) && !isSorcerySpeed(sa, ai)
                && !sa.hasParam("ActivationPhases") && sa.hasParam("Duration")) {
            return false;
        }

        // don't use instant speed clone abilities outside humans
        // Combat_Declare_Attackers_InstantAbility step
        if (!ph.is(PhaseType.COMBAT_DECLARE_ATTACKERS) || ph.isPlayerTurn(ai) || ph.getCombat().getAttackers().isEmpty()) {
            return false;
        }

        // don't activate during main2 unless this effect is permanent
        return !ph.is(PhaseType.MAIN2) || !sa.hasParam("Duration");
    }
}
```
