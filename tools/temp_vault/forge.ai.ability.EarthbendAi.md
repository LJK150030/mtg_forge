---
aliases:
  - EarthbendAi
tags:
  - java/class
  - module/forge-ai
  - pkg/forge/ai/ability
fqn: forge.ai.ability.EarthbendAi
package: forge.ai.ability
module: forge-ai
kind: Class
---

# EarthbendAi

**Package:** `forge.ai.ability` &nbsp; **Module:** `forge-ai` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class EarthbendAi {
        #canPlay(Player aiPlayer, SpellAbility sa) AiAbilityDecision
        #doTriggerNoCost(Player aiPlayer, SpellAbility sa, boolean mandatory) AiAbilityDecision
    }
    EarthbendAi --|> SpellAbilityAi : extends
    EarthbendAi ..> AiAbilityDecision : uses
    EarthbendAi ..> Card : uses
    EarthbendAi ..> CardCollection : uses
    EarthbendAi ..> Cost : uses
    EarthbendAi ..> CostPart : uses
    EarthbendAi ..> CostSacrifice : uses
    EarthbendAi ..> Player : uses
    EarthbendAi ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.ai.SpellAbilityAi|SpellAbilityAi]]
**Uses:**
- [[forge.ai.AiAbilityDecision|AiAbilityDecision]]
- [[forge.game.card.Card|Card]]
- [[forge.game.card.CardCollection|CardCollection]]
- [[forge.game.cost.Cost|Cost]]
- [[forge.game.cost.CostPart|CostPart]]
- [[forge.game.cost.CostSacrifice|CostSacrifice]]
- [[forge.game.player.Player|Player]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

EarthbendAi is the AI decision module for the "earthbend" mechanic, determining whether and how the computer should activate a SpellÂ­Ability that animates a land into a creature. As a concrete subclass of `SpellAbilityAi`, it overrides `canPlay` to choose a target and `doTriggerNoCost` to handle triggered or mandatory resolutions, returning `AiAbilityDecision` values that encode both a numeric score and an `AiPlayDecision` verdict.

Its core responsibility is target selection: it surveys the AI's lands via `CardCollection`, then inspects each land's activated abilitiesâ€”drilling into the `Cost`/`CostPart` model to find affordable self-sacrifice (`CostSacrifice`) effectsâ€”so it can prefer fetchlands that retain later value. It delegates the final pick to `ComputerUtilCard.getBestLandToAnimate`, sets the chosen `Card` as the spell's target, and bails to `AnotherTime` when no lands exist. The design keeps all collaboration with the game model read-only until a viable play is confirmed.

## Source
`forge-ai/src/main/java/forge/ai/ability/EarthbendAi.java`

```java
package forge.ai.ability;

import forge.ai.*;
import forge.game.card.Card;
import forge.game.card.CardCollection;
import forge.game.card.CardLists;
import forge.game.cost.Cost;
import forge.game.cost.CostPart;
import forge.game.cost.CostSacrifice;
import forge.game.player.Player;
import forge.game.spellability.SpellAbility;

public class EarthbendAi extends SpellAbilityAi {
    @Override
    protected AiAbilityDecision canPlay(Player aiPlayer, SpellAbility sa) {
        CardCollection lands = aiPlayer.getLandsInPlay();
        if (lands.isEmpty()) {
            return new AiAbilityDecision(0, AiPlayDecision.AnotherTime);
        }
        CardCollection fetchLands = CardLists.filter(lands, c -> {
                    for (final SpellAbility ability : c.getAllSpellAbilities()) {
                        if (ability.isActivatedAbility()) {
                            final Cost cost = ability.getPayCosts();
                            for (final CostPart part : cost.getCostParts()) {
                                if (!(part instanceof CostSacrifice)) {
                                    continue;
                                }
                                CostSacrifice sacCost = (CostSacrifice) part;
                                if (sacCost.payCostFromSource() && ComputerUtilCost.canPayCost(ability, c.getController(), false)) {
                                    return true;
                                }
                            }
                        }
                    }
                    return false;
                });

        Card tgtLand;
        if (!fetchLands.isEmpty()) {
            // Prioritize fetchlands as they can be reused later
            tgtLand = ComputerUtilCard.getBestLandToAnimate(fetchLands);
        } else {
            tgtLand = ComputerUtilCard.getBestLandToAnimate(lands);
        }

        sa.resetTargets();
        sa.getTargets().add(tgtLand);

        return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
    }

    @Override
    protected AiAbilityDecision doTriggerNoCost(Player aiPlayer, SpellAbility sa, boolean mandatory) {
        AiAbilityDecision decision = canPlay(aiPlayer, sa);
        if (decision.willingToPlay() || mandatory) {
            return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
        }
        return new AiAbilityDecision(0, AiPlayDecision.CantPlayAi);
    }

}
```

## Python
`forge/ai/ability/EarthbendAi.py`

```python
from forge.ai.SpellAbilityAi import SpellAbilityAi
from forge.ai.AiAbilityDecision import AiAbilityDecision
from forge.ai.AiPlayDecision import AiPlayDecision
from forge.ai.ComputerUtilCard import ComputerUtilCard
from forge.ai.ComputerUtilCost import ComputerUtilCost
from forge.game.card.Card import Card
from forge.game.card.CardCollection import CardCollection
from forge.game.card.CardLists import CardLists
from forge.game.cost.Cost import Cost
from forge.game.cost.CostPart import CostPart
from forge.game.cost.CostSacrifice import CostSacrifice
from forge.game.player.Player import Player
from forge.game.spellability.SpellAbility import SpellAbility


class EarthbendAi(SpellAbilityAi):
    def canPlay(self, aiPlayer: Player, sa: SpellAbility) -> AiAbilityDecision:
        lands = aiPlayer.getLandsInPlay()
        if lands.isEmpty():
            return AiAbilityDecision(0, AiPlayDecision.AnotherTime)

        def _isFetchLand(c):
            for ability in c.getAllSpellAbilities():
                if ability.isActivatedAbility():
                    cost = ability.getPayCosts()
                    for part in cost.getCostParts():
                        if not isinstance(part, CostSacrifice):
                            continue
                        sacCost = part
                        if sacCost.payCostFromSource() and ComputerUtilCost.canPayCost(ability, c.getController(), False):
                            return True
            return False

        fetchLands = CardLists.filter(lands, _isFetchLand)

        if not fetchLands.isEmpty():
            # Prioritize fetchlands as they can be reused later
            tgtLand = ComputerUtilCard.getBestLandToAnimate(fetchLands)
        else:
            tgtLand = ComputerUtilCard.getBestLandToAnimate(lands)

        sa.resetTargets()
        sa.getTargets().add(tgtLand)

        return AiAbilityDecision(100, AiPlayDecision.WillPlay)

    def doTriggerNoCost(self, aiPlayer: Player, sa: SpellAbility, mandatory: bool) -> AiAbilityDecision:
        decision = self.canPlay(aiPlayer, sa)
        if decision.willingToPlay() or mandatory:
            return AiAbilityDecision(100, AiPlayDecision.WillPlay)
        return AiAbilityDecision(0, AiPlayDecision.CantPlayAi)
```
