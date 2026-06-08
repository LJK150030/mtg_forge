---
aliases:
  - DelayedTriggerAi
tags:
  - java/class
  - module/forge-ai
  - pkg/forge/ai/ability
fqn: forge.ai.ability.DelayedTriggerAi
package: forge.ai.ability
module: forge-ai
kind: Class
---

# DelayedTriggerAi

**Package:** `forge.ai.ability` &nbsp; **Module:** `forge-ai` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class DelayedTriggerAi {
        +chkDrawback(Player ai, SpellAbility sa) AiAbilityDecision
        #doTriggerNoCost(Player ai, SpellAbility sa, boolean mandatory) AiAbilityDecision
        #canPlay(Player ai, SpellAbility sa) AiAbilityDecision
    }
    DelayedTriggerAi --|> SpellAbilityAi : extends
    DelayedTriggerAi ..> AbilitySub : uses
    DelayedTriggerAi ..> AiAbilityDecision : uses
    DelayedTriggerAi ..> AiController : uses
    DelayedTriggerAi ..> AiPlayDecision : uses
    DelayedTriggerAi ..> CardCollection : uses
    DelayedTriggerAi ..> Cost : uses
    DelayedTriggerAi ..> ManaCost : uses
    DelayedTriggerAi ..> Player : uses
    DelayedTriggerAi ..> PlayerControllerAi : uses
    DelayedTriggerAi ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.ai.SpellAbilityAi|SpellAbilityAi]]
**Uses:**
- [[forge.ai.AiAbilityDecision|AiAbilityDecision]]
- [[forge.ai.AiController|AiController]]
- [[forge.ai.AiPlayDecision|AiPlayDecision]]
- [[forge.ai.PlayerControllerAi|PlayerControllerAi]]
- [[forge.card.mana.ManaCost|ManaCost]]
- [[forge.game.card.CardCollection|CardCollection]]
- [[forge.game.cost.Cost|Cost]]
- [[forge.game.player.Player|Player]]
- [[forge.game.spellability.AbilitySub|AbilitySub]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

DelayedTriggerAi supplies the AI's decision logic for the DelayedTrigger ability API, extending `SpellAbilityAi` to override `chkDrawback`, `doTriggerNoCost`, and `canPlay`. Its core responsibility is to evaluate whether the AI should schedule a delayed trigger, primarily by resolving the nested "Execute" sub-ability and delegating the real judgment back through `PlayerControllerAi`/`AiController`—either recursively via `chkDrawbackWithSubs` for `AbilitySub` payloads or through `canPlaySa`/`doTrigger`. Decisions are returned as `AiAbilityDecision` values pairing a score with an `AiPlayDecision`.

The class is notably card-specific: `canPlay` branches on an `AILogic` parameter to handle special cases like `SpellCopy`, `NarsetRebound`, and `SaveCreature`, scanning hand or battlefield via `CardCollection`/`CardLists` and checking affordability with combined `ManaCost`/`Cost` calculations. Guards against infinite recursion (skipping copy-of-copy and re-entrant mana abilities) reveal deliberate intent to keep the AI's lookahead bounded and tractable.

## Source
`forge-ai/src/main/java/forge/ai/ability/DelayedTriggerAi.java`

```java
package forge.ai.ability;

import forge.ai.*;
import forge.card.mana.ManaCost;
import forge.game.ability.ApiType;
import forge.game.card.CardCollection;
import forge.game.card.CardLists;
import forge.game.cost.Cost;
import forge.game.keyword.Keyword;
import forge.game.player.Player;
import forge.game.spellability.AbilitySub;
import forge.game.spellability.SpellAbility;
import forge.game.zone.ZoneType;

public class DelayedTriggerAi extends SpellAbilityAi {

    @Override
    public AiAbilityDecision chkDrawback(Player ai, SpellAbility sa) {
        if ("Always".equals(sa.getParam("AILogic"))) {
            return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
        }
        SpellAbility trigsa = sa.getAdditionalAbility("Execute");
        if (trigsa == null) {
            return new AiAbilityDecision(0, AiPlayDecision.CantPlayAi);
        }
        trigsa.setActivatingPlayer(ai);

        if (trigsa instanceof AbilitySub) {
            return SpellApiToAi.Converter.get(trigsa).chkDrawbackWithSubs(ai, (AbilitySub)trigsa);
        } else {
            AiPlayDecision decision = ((PlayerControllerAi)ai.getController()).getAi().canPlaySa(trigsa);
            if (decision == AiPlayDecision.WillPlay) {
                return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
            } else {
                return new AiAbilityDecision(0, AiPlayDecision.CantPlayAi);
            }
        }
    }

    @Override
    protected AiAbilityDecision doTriggerNoCost(Player ai, SpellAbility sa, boolean mandatory) {
        SpellAbility trigsa = sa.getAdditionalAbility("Execute");
        if (trigsa == null) {
            return new AiAbilityDecision(0, AiPlayDecision.CantPlayAi);
        }

        AiController aic = ((PlayerControllerAi)ai.getController()).getAi();
        trigsa.setActivatingPlayer(ai);

        if (!sa.hasParam("OptionalDecider")) {
            if (aic.doTrigger(trigsa, true)) {
                // If the trigger is mandatory, we can play it
                return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
            } else {
                return new AiAbilityDecision(0, AiPlayDecision.CantPlayAi);
            }
        } else {
            if (aic.doTrigger(trigsa, !sa.getParam("OptionalDecider").equals("You"))) {
                return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
            } else {
                return new AiAbilityDecision(0, AiPlayDecision.CantPlayAi);
            }
        }
    }

    @Override
    protected AiAbilityDecision canPlay(Player ai, SpellAbility sa) {
        // Card-specific logic
        String logic = sa.getParamOrDefault("AILogic", "");
        if (logic.equals("SpellCopy")) {
            // fetch Instant or Sorcery and AI has reason to play this turn
            // does not try to get itself
            final ManaCost costSa = sa.getPayCosts().getTotalMana();
            final int count = CardLists.count(ai.getCardsIn(ZoneType.Hand), c -> {
                if (!(c.isInstant() || c.isSorcery()) || c.equals(sa.getHostCard())) {
                    return false;
                }
                for (SpellAbility ab : c.getSpellAbilities()) {
                    if (ComputerUtilAbility.getAbilitySourceName(sa).equals(ComputerUtilAbility.getAbilitySourceName(ab))
                            || ab.hasParam("AINoRecursiveCheck")) {
                        // prevent infinitely recursing mana ritual and other abilities with reentry
                        continue;
                    } else if ("SpellCopy".equals(ab.getParam("AILogic")) && ab.getApi() == ApiType.DelayedTrigger) {
                        // don't copy another copy spell, too complex for the AI
                        continue;
                    }
                    if (!ab.canPlay()) {
                        continue;
                    }
                    AiPlayDecision decision = ((PlayerControllerAi)ai.getController()).getAi().canPlaySa(ab);
                    // see if we can pay both for this spell and for the Effect spell we're considering
                    if (decision == AiPlayDecision.WillPlay || decision == AiPlayDecision.WaitForMain2) {
                        ManaCost costAb = ab.getPayCosts().getTotalMana();
                        ManaCost total = ManaCost.combine(costSa, costAb);
                        SpellAbility combinedAb = ab.copyWithDefinedCost(new Cost(total, false));
                        // can we pay both costs?
                        if (ComputerUtilMana.canPayManaCost(combinedAb, ai, 0, true)) {
                            return true;
                        }
                    }
                }
                return false;
            });

            if (count == 0) {
                return new AiAbilityDecision(0, AiPlayDecision.CantPlayAi);
            }
            return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
        } else if (logic.equals("NarsetRebound")) {
            // should be done in Main2, but it might broke for other cards
            //if (phase.getPhase().isBefore(PhaseType.MAIN2)) {
            //    return false;
            //}

            // fetch Instant or Sorcery without Rebound and AI has reason to play this turn
            // only need count, not the list
            final int count = CardLists.count(ai.getCardsIn(ZoneType.Hand), c -> {
                if (!(c.isInstant() || c.isSorcery()) || c.hasKeyword(Keyword.REBOUND)) {
                    return false;
                }
                for (SpellAbility ab : c.getSpellAbilities()) {
                    if (ComputerUtilAbility.getAbilitySourceName(sa).equals(ComputerUtilAbility.getAbilitySourceName(ab))
                            || ab.hasParam("AINoRecursiveCheck")) {
                        // prevent infinitely recursing mana ritual and other abilities with reentry
                        continue;
                    }
                    if (!ab.canPlay()) {
                        continue;
                    }
                    AiPlayDecision decision = ((PlayerControllerAi) ai.getController()).getAi().canPlaySa(ab);
                    if (decision == AiPlayDecision.WillPlay || decision == AiPlayDecision.WaitForMain2) {
                        if (ComputerUtilMana.canPayManaCost(ab, ai, 0, true)) {
                            return true;
                        }
                    }
                }
                return false;
            });

            if (count == 0) {
                return new AiAbilityDecision(0, AiPlayDecision.CantPlayAi);
            }

            return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
        } else if (logic.equals("SaveCreature")) {
            CardCollection ownCreatures = ai.getCreaturesInPlay();

            ownCreatures = CardLists.filter(ownCreatures, card -> {
                if (ComputerUtilCard.isUselessCreature(ai, card)) {
                    return false;
                }

                return ComputerUtil.predictCreatureWillDieThisTurn(ai, card, sa);
            });

            if (!ownCreatures.isEmpty()) {
                sa.getTargets().add(ComputerUtilCard.getBestAI(ownCreatures));
                return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
            }

            return new AiAbilityDecision(0, AiPlayDecision.TargetingFailed);
        }

        // Generic logic
        SpellAbility trigsa = sa.getAdditionalAbility("Execute");
        if (trigsa == null) {
            return new AiAbilityDecision(0, AiPlayDecision.CantPlayAi);
        }
        trigsa.setActivatingPlayer(ai);

        AiPlayDecision decision = ((PlayerControllerAi)ai.getController()).getAi().canPlaySa(trigsa);
        if (decision == AiPlayDecision.WillPlay) {
            return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
        } else {
            return new AiAbilityDecision(0, AiPlayDecision.CantPlayAi);
        }
    }

}
```
