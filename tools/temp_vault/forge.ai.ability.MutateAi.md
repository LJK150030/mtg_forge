---
aliases:
  - MutateAi
tags:
  - java/class
  - module/forge-ai
  - pkg/forge/ai/ability
fqn: forge.ai.ability.MutateAi
package: forge.ai.ability
module: forge-ai
kind: Class
---

# MutateAi

**Package:** `forge.ai.ability` &nbsp; **Module:** `forge-ai` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class MutateAi {
        #canPlay(Player aiPlayer, SpellAbility sa) AiAbilityDecision
        #chooseSingleCard(Player ai, SpellAbility sa, Iterable~Card~ options, boolean isOptional, Player targetedPlayer, Map~String,Object~ params) Card
        +confirmAction(Player player, SpellAbility sa, PlayerActionConfirmMode mode, String message, Map~String,Object~ params) boolean
    }
    MutateAi --|> SpellAbilityAi : extends
    MutateAi ..> AiAbilityDecision : uses
    MutateAi ..> Card : uses
    MutateAi ..> CardCollectionView : uses
    MutateAi ..> Player : uses
    MutateAi ..> PlayerActionConfirmMode : uses
    MutateAi ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.ai.SpellAbilityAi|SpellAbilityAi]]
**Uses:**
- [[forge.ai.AiAbilityDecision|AiAbilityDecision]]
- [[forge.game.card.Card|Card]]
- [[forge.game.card.CardCollectionView|CardCollectionView]]
- [[forge.game.player.Player|Player]]
- [[forge.game.player.PlayerActionConfirmMode|PlayerActionConfirmMode]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

MutateAi supplies the AI decision logic for casting Mutate spells, concentrating the engine's heuristics for *when* and *how* a computer player should mutate a creature. As a concrete subclass of `SpellAbilityAi`, it overrides three hooks: `canPlay` selects a target by gathering the AI's creatures, discarding ones that are useless to mutate onto (Defenders, can't-attack/block creatures, otherwise dead weight), and committing the best survivor via `ComputerUtilCard.getBestCreatureAI`; `chooseSingleCard` decides which card ends up on top of the merged pile, favoring the highest base power or toughness; and `confirmAction` unconditionally accepts.

It collaborates with the game model (`Card`, `CardCollectionView`, `Player`, `SpellAbility`) and returns scored `AiAbilityDecision` results to the AI framework. The code is deliberately conservative and self-documented as provisionalâ€”TODO comments flag the rudimentary evaluation and invite context-aware improvementsâ€”reflecting a working-but-minimal placeholder rather than fully tuned strategy.

## Source
`forge-ai/src/main/java/forge/ai/ability/MutateAi.java`

```java
package forge.ai.ability;

import forge.ai.*;
import forge.game.card.Card;
import forge.game.card.CardCollectionView;
import forge.game.card.CardLists;
import forge.game.card.CardPredicates;
import forge.game.keyword.Keyword;
import forge.game.player.Player;
import forge.game.player.PlayerActionConfirmMode;
import forge.game.spellability.SpellAbility;

import java.util.Map;
import java.util.function.Predicate;

public class MutateAi extends SpellAbilityAi {
    @Override
    protected AiAbilityDecision canPlay(Player aiPlayer, SpellAbility sa) {
        CardCollectionView mutateTgts = CardLists.getTargetableCards(aiPlayer.getCreaturesInPlay(), sa);
        mutateTgts = ComputerUtil.getSafeTargets(aiPlayer, sa, mutateTgts);

        // Filter out some abilities that are useless
        // TODO: add other stuff useless for Mutate here
        mutateTgts = CardLists.filter(mutateTgts, Predicate.not(
                CardPredicates.hasKeyword(Keyword.DEFENDER)
                        .or(CardPredicates.hasKeyword("CARDNAME can't attack."))
                        .or(CardPredicates.hasKeyword("CARDNAME can't block."))
                        .or(card -> ComputerUtilCard.isUselessCreature(aiPlayer, card))
                )
        );

        if (mutateTgts.isEmpty()) {
            return new AiAbilityDecision(0, AiPlayDecision.CantPlayAi);
        }

        // Choose the best target
        // TODO: maybe, instead of the standard evaluator, this could inspect the abilities and decide
        // which are better in context, but that's a bit complicated for the time being (not sure if necessary?).
        Card mutateTgt = ComputerUtilCard.getBestCreatureAI(mutateTgts);
        sa.getTargets().add(mutateTgt);

        return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
    }

    @Override
    protected Card chooseSingleCard(Player ai, SpellAbility sa, Iterable<Card> options, boolean isOptional, Player targetedPlayer, Map<String, Object> params) {
        // Decide which card goes on top here. Pretty rudimentary, feel free to improve.
        Card choice = null;

        for (Card c : options) {
            if (choice == null || c.getBasePower() > choice.getBasePower() || c.getBaseToughness() > choice.getBaseToughness()) {
                choice = c;
            }
        }

        return choice;
    }

    @Override
    public boolean confirmAction(Player player, SpellAbility sa, PlayerActionConfirmMode mode, String message, Map<String, Object> params) {
        return true;
    }
}
```

## Python
`forge/ai/ability/MutateAi.py`

```python
from forge.ai.SpellAbilityAi import SpellAbilityAi
from forge.ai.AiAbilityDecision import AiAbilityDecision
from forge.ai.AiPlayDecision import AiPlayDecision
from forge.ai.ComputerUtil import ComputerUtil
from forge.ai.ComputerUtilCard import ComputerUtilCard
from forge.game.card.Card import Card
from forge.game.card.CardCollectionView import CardCollectionView
from forge.game.card.CardLists import CardLists
from forge.game.card.CardPredicates import CardPredicates
from forge.game.keyword.Keyword import Keyword
from forge.game.player.Player import Player
from forge.game.player.PlayerActionConfirmMode import PlayerActionConfirmMode
from forge.game.spellability.SpellAbility import SpellAbility

from typing import Iterable, Map


class MutateAi(SpellAbilityAi):
    def canPlay(self, aiPlayer: Player, sa: SpellAbility) -> AiAbilityDecision:
        mutateTgts = CardLists.getTargetableCards(aiPlayer.getCreaturesInPlay(), sa)
        mutateTgts = ComputerUtil.getSafeTargets(aiPlayer, sa, mutateTgts)

        # Filter out some abilities that are useless
        # TODO: add other stuff useless for Mutate here
        mutateTgts = CardLists.filter(mutateTgts, lambda card: not (
                CardPredicates.hasKeyword(Keyword.DEFENDER).test(card)
                or CardPredicates.hasKeyword("CARDNAME can't attack.").test(card)
                or CardPredicates.hasKeyword("CARDNAME can't block.").test(card)
                or ComputerUtilCard.isUselessCreature(aiPlayer, card)
        ))

        if mutateTgts.isEmpty():
            return AiAbilityDecision(0, AiPlayDecision.CantPlayAi)

        # Choose the best target
        # TODO: maybe, instead of the standard evaluator, this could inspect the abilities and decide
        # which are better in context, but that's a bit complicated for the time being (not sure if necessary?).
        mutateTgt = ComputerUtilCard.getBestCreatureAI(mutateTgts)
        sa.getTargets().add(mutateTgt)

        return AiAbilityDecision(100, AiPlayDecision.WillPlay)

    def chooseSingleCard(self, ai: Player, sa: SpellAbility, options: Iterable[Card], isOptional: bool, targetedPlayer: Player, params: Map[str, object]) -> Card:
        # Decide which card goes on top here. Pretty rudimentary, feel free to improve.
        choice = None

        for c in options:
            if choice is None or c.getBasePower() > choice.getBasePower() or c.getBaseToughness() > choice.getBaseToughness():
                choice = c

        return choice

    def confirmAction(self, player: Player, sa: SpellAbility, mode: PlayerActionConfirmMode, message: str, params: Map[str, object]) -> bool:
        return True
```
