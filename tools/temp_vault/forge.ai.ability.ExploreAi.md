---
aliases:
  - ExploreAi
tags:
  - java/class
  - module/forge-ai
  - pkg/forge/ai/ability
fqn: forge.ai.ability.ExploreAi
package: forge.ai.ability
module: forge-ai
kind: Class
---

# ExploreAi

**Package:** `forge.ai.ability` &nbsp; **Module:** `forge-ai` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class ExploreAi {
        #canPlay(Player aiPlayer, SpellAbility sa) AiAbilityDecision
        +shouldPutInGraveyard(Card topCard, Player ai) boolean
        +confirmAction(Player player, SpellAbility sa, PlayerActionConfirmMode mode, String message, Map~String,Object~ params) boolean
        #doTriggerNoCost(Player aiPlayer, SpellAbility sa, boolean mandatory) AiAbilityDecision
    }
    ExploreAi --|> SpellAbilityAi : extends
    ExploreAi ..> AiAbilityDecision : uses
    ExploreAi ..> Card : uses
    ExploreAi ..> CardCollection : uses
    ExploreAi ..> CardCollectionView : uses
    ExploreAi ..> Player : uses
    ExploreAi ..> PlayerActionConfirmMode : uses
    ExploreAi ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.ai.SpellAbilityAi|SpellAbilityAi]]
**Uses:**
- [[forge.ai.AiAbilityDecision|AiAbilityDecision]]
- [[forge.game.card.Card|Card]]
- [[forge.game.card.CardCollection|CardCollection]]
- [[forge.game.card.CardCollectionView|CardCollectionView]]
- [[forge.game.player.Player|Player]]
- [[forge.game.player.PlayerActionConfirmMode|PlayerActionConfirmMode]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

ExploreAi supplies the AI's decision logic for the Magic mechanic "explore," extending the engine's `SpellAbilityAi` base class so the engine can delegate when, how, and whether the computer plays an explore-granting ability. Through the overridden `canPlay` and `doTriggerNoCost` it evaluates the battlefield via `ComputerUtilCard` to pick the best creature target (or declines when none exists), returning weighted `AiAbilityDecision` verdicts that signal intent and confidence.

Its core domain rule lives in the static `shouldPutInGraveyard` helper, which weighs mana sources, lands in hand and play, and the revealed card's CMC against tunable `AiProps` profile thresholds to decide whether to bin a revealed non-land or keep it on top of the library; `confirmAction` simply routes the engine's reveal prompt to that heuristic. The class is stateless and collaborates loosely with `Card`, `CardCollection`, and `Player` purely through method parameters.

## Source
`forge-ai/src/main/java/forge/ai/ability/ExploreAi.java`

```java
package forge.ai.ability;


import forge.ai.*;
import forge.game.card.*;
import forge.game.player.Player;
import forge.game.player.PlayerActionConfirmMode;
import forge.game.spellability.SpellAbility;
import forge.game.zone.ZoneType;

import java.util.Map;

public class ExploreAi extends SpellAbilityAi {
    /* (non-Javadoc)
     * @see forge.card.abilityfactory.SpellAiLogic#canPlayAI(forge.game.player.Player, java.util.Map, forge.card.spellability.SpellAbility)
     */
    @Override
    protected AiAbilityDecision canPlay(Player aiPlayer, SpellAbility sa) {
        // Explore with a target (e.g. Enter the Unknown)
        if (sa.usesTargeting()) {
            Card bestCreature = ComputerUtilCard.getBestCreatureAI(aiPlayer.getCardsIn(ZoneType.Battlefield));
            if (bestCreature == null) {
                return new AiAbilityDecision(0, AiPlayDecision.CantPlayAi);
            }

            sa.resetTargets();
            sa.getTargets().add(bestCreature);
        }

        return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
    }

    public static boolean shouldPutInGraveyard(Card topCard, Player ai) {
        int predictedMana = ComputerUtilMana.getAvailableManaSources(ai, false).size();
        CardCollectionView cardsOTB = ai.getCardsIn(ZoneType.Battlefield);
        CardCollectionView cardsInHand = ai.getCardsIn(ZoneType.Hand);
        CardCollection landsOTB = CardLists.filter(cardsOTB, CardPredicates.LANDS_PRODUCING_MANA);
        CardCollection landsInHand = CardLists.filter(cardsInHand, CardPredicates.LANDS_PRODUCING_MANA);

        int maxCMCDiff = AiProfileUtil.getIntProperty(ai, AiProps.EXPLORE_MAX_CMC_DIFF_TO_PUT_IN_GRAVEYARD);
        int numLandsToStillNeedMore = AiProfileUtil.getIntProperty(ai, AiProps.EXPLORE_NUM_LANDS_TO_STILL_NEED_MORE);

        if (landsInHand.isEmpty() && landsOTB.size() <= numLandsToStillNeedMore) {
            // We need more lands to improve our mana base, explore away the non-lands
            return true;
        } else if (topCard.getCMC() - maxCMCDiff >= predictedMana && !topCard.hasSVar("DoNotDiscardIfAble")) {
            // We're not casting this in foreseeable future, put it in the graveyard
            return true;
        }

        // Put on top of the library (do not mark the card for placement in the graveyard)
        return false;
    }

    @Override
    public boolean confirmAction(Player player, SpellAbility sa, PlayerActionConfirmMode mode, String message, Map<String, Object> params) {
        return shouldPutInGraveyard((Card)params.get("RevealedCard"), player);
    }

    @Override
    protected AiAbilityDecision doTriggerNoCost(Player aiPlayer, SpellAbility sa, boolean mandatory) {
        if (sa.usesTargeting()) {
            CardCollection list = CardLists.getValidCards(aiPlayer.getGame().getCardsIn(ZoneType.Battlefield),
                    sa.getTargetRestrictions().getValidTgts(), aiPlayer, sa.getHostCard(), sa);

            if (!list.isEmpty()) {
                sa.getTargets().add(ComputerUtilCard.getBestCreatureAI(list));
                return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
            }

            return new AiAbilityDecision(0, AiPlayDecision.TargetingFailed);
        }

        if (mandatory) {
            return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
        }

        return canPlay(aiPlayer, sa);
    }
}
```
