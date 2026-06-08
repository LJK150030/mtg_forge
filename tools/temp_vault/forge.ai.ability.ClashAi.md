---
aliases:
  - ClashAi
tags:
  - java/class
  - module/forge-ai
  - pkg/forge/ai/ability
fqn: forge.ai.ability.ClashAi
package: forge.ai.ability
module: forge-ai
kind: Class
---

# ClashAi

**Package:** `forge.ai.ability` &nbsp; **Module:** `forge-ai` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class ClashAi {
        #doTriggerNoCost(Player aiPlayer, SpellAbility sa, boolean mandatory) AiAbilityDecision
        #checkApiLogic(Player ai, SpellAbility sa) AiAbilityDecision
        #chooseSinglePlayer(Player ai, SpellAbility sa, Iterable~Player~ options, Map~String,Object~ params) Player
        -selectTarget(Player ai, SpellAbility sa) boolean
    }
    ClashAi --|> SpellAbilityAi : extends
    ClashAi ..> AiAbilityDecision : uses
    ClashAi ..> Card : uses
    ClashAi ..> CardCollectionView : uses
    ClashAi ..> Player : uses
    ClashAi ..> PlayerCollection : uses
    ClashAi ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.ai.SpellAbilityAi|SpellAbilityAi]]
**Uses:**
- [[forge.ai.AiAbilityDecision|AiAbilityDecision]]
- [[forge.game.card.Card|Card]]
- [[forge.game.card.CardCollectionView|CardCollectionView]]
- [[forge.game.player.Player|Player]]
- [[forge.game.player.PlayerCollection|PlayerCollection]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

ClashAi provides the AI decision logic for resolving "Clash" abilities, a Magic mechanic in which players compare the top cards of their libraries. As a concrete subtype of `SpellAbilityAi`, it overrides the framework's hook methods—`doTriggerNoCost` and `checkApiLogic`—to decide whether the computer should play the ability, returning an `AiAbilityDecision` that pairs a confidence score with a play verdict (e.g., `WillPlay` or `TargetingFailed`). When the ability targets, it delegates to `selectTarget`, which narrows the field to targetable opponents and, for creature-targeting variants, picks the best friendly or worst enemy creature via `ComputerUtilCard`.

Its core heuristic lives in `chooseSinglePlayer`, which prefers an opponent with an empty library, then—if the AI may look at library tops—an opponent whose top card has lower converted mana cost, maximizing the AI's chance of winning the clash. The design keeps targeting and player-selection concerns separate and reuses the shared decision/scoring conventions of the AI framework, while inline TODOs flag known gaps (split cards, trickier clash variants).

## Source
`forge-ai/src/main/java/forge/ai/ability/ClashAi.java`

```java
package forge.ai.ability;


import com.google.common.collect.Iterables;
import forge.ai.AiAbilityDecision;
import forge.ai.AiPlayDecision;
import forge.ai.ComputerUtilCard;
import forge.ai.SpellAbilityAi;
import forge.game.card.Card;
import forge.game.card.CardCollectionView;
import forge.game.card.CardLists;
import forge.game.card.CardPredicates;
import forge.game.player.Player;
import forge.game.player.PlayerCollection;
import forge.game.player.PlayerPredicates;
import forge.game.spellability.SpellAbility;
import forge.game.zone.ZoneType;

import java.util.Map;

public class ClashAi extends SpellAbilityAi {

    /* (non-Javadoc)
     * @see forge.card.abilityfactory.SpellAiLogic#doTriggerAINoCost(forge.game.player.Player, java.util.Map, forge.card.spellability.SpellAbility, boolean)
     */
    @Override
    protected AiAbilityDecision doTriggerNoCost(Player aiPlayer, SpellAbility sa, boolean mandatory) {
        boolean legalAction = true;

        if (sa.usesTargeting()) {
            legalAction = selectTarget(aiPlayer, sa);
        }

        return legalAction ? new AiAbilityDecision(100, AiPlayDecision.WillPlay)
                : new AiAbilityDecision(0, AiPlayDecision.TargetingFailed);
    }

    /*
     * (non-Javadoc)
     * 
     * @see forge.ai.SpellAbilityAi#checkApiLogic(forge.game.player.Player,
     * forge.game.spellability.SpellAbility)
     */
    @Override
    protected AiAbilityDecision checkApiLogic(Player ai, SpellAbility sa) {
        boolean legalAction = true;

        if (sa.usesTargeting()) {
            legalAction = selectTarget(ai, sa);
            if (!legalAction) {
                return new AiAbilityDecision(0, AiPlayDecision.TargetingFailed);
            }
        }

        return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
    }

    /*
     * (non-Javadoc)
     * 
     * @see forge.ai.SpellAbilityAi#chooseSinglePlayer(forge.game.player.Player,
     * forge.game.spellability.SpellAbility, java.lang.Iterable)
     */
    @Override
    protected Player chooseSinglePlayer(Player ai, SpellAbility sa, Iterable<Player> options, Map<String, Object> params) {
        for (Player p : options) {
            if (p.getCardsIn(ZoneType.Library).isEmpty())
                return p;
        }

    	CardCollectionView col = ai.getCardsIn(ZoneType.Library);
        if (!col.isEmpty() && col.getFirst().mayPlayerLook(ai)) {
            final Card top = col.get(0);
            for (Player p : options) {
                final Card oppTop = p.getCardsIn(ZoneType.Library).getFirst();
                // TODO add logic for SplitCards
                if (top.getCMC() > oppTop.getCMC()) {
                    return p;
                }
            }
        }

        return Iterables.getFirst(options, null);
    }

    private boolean selectTarget(Player ai, SpellAbility sa) {
        String valid = sa.getParam("ValidTgts");

        PlayerCollection players = ai.getOpponents().filter(PlayerPredicates.isTargetableBy(sa));
        // use chooseSinglePlayer function to the select player
        Player chosen = chooseSinglePlayer(ai, sa, players, null);
        if (chosen != null) {
            sa.resetTargets();
            sa.getTargets().add(chosen);
        }

        if ("Creature".equals(valid)) {
            // Springjack Knight
            // TODO: Whirlpool Whelm also uses creature targeting but it's trickier to support
            CardCollectionView aiCreats = ai.getCreaturesInPlay();
            CardCollectionView oppCreats = CardLists.filter(ai.getOpponents().getCardsIn(ZoneType.Battlefield), CardPredicates.CREATURES);

            Card tgt = aiCreats.isEmpty() ? ComputerUtilCard.getWorstCreatureAI(oppCreats) : ComputerUtilCard.getBestCreatureAI(aiCreats);

            if (tgt != null) {
                sa.resetTargets();
                sa.getTargets().add(tgt);
            } else {
                return false; // cut short if this part of the clause is not satisfiable (with current card pool should never get here)
            }
        }

        return !sa.getTargets().isEmpty();
    }
}
```
