---
aliases:
  - ChoosePlayerAi
tags:
  - java/class
  - module/forge-ai
  - pkg/forge/ai/ability
fqn: forge.ai.ability.ChoosePlayerAi
package: forge.ai.ability
module: forge-ai
kind: Class
---

# ChoosePlayerAi

**Package:** `forge.ai.ability` &nbsp; **Module:** `forge-ai` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class ChoosePlayerAi {
        #canPlay(Player ai, SpellAbility sa) AiAbilityDecision
        +chkDrawback(Player ai, SpellAbility sa) AiAbilityDecision
        #doTriggerNoCost(Player ai, SpellAbility sa, boolean mandatory) AiAbilityDecision
        +chooseSinglePlayer(Player ai, SpellAbility sa, Iterable~Player~ choices, Map~String,Object~ params) Player
    }
    ChoosePlayerAi --|> SpellAbilityAi : extends
    ChoosePlayerAi ..> AiAbilityDecision : uses
    ChoosePlayerAi ..> Player : uses
    ChoosePlayerAi ..> PlayerCollection : uses
    ChoosePlayerAi ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.ai.SpellAbilityAi|SpellAbilityAi]]
**Uses:**
- [[forge.ai.AiAbilityDecision|AiAbilityDecision]]
- [[forge.game.player.Player|Player]]
- [[forge.game.player.PlayerCollection|PlayerCollection]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

`ChoosePlayerAi` is the AI decision handler for spell abilities whose effect is to choose a player, extending `SpellAbilityAi` and slotting into Forge's ability-AI dispatch framework. It overrides the standard play-evaluation hooks (`canPlay`, `chkDrawback`, `doTriggerNoCost`) to unconditionally endorse the ability via an `AiAbilityDecision`, reflecting that the choice itself, rather than whether to act, carries the strategic weight.

That weight lives in `chooseSinglePlayer`, which selects a target from the candidate `Player` set according to the ability's `AILogic` parameterâ€”protecting the lowest-life ally, cursing the strongest opponent, pumping itself, or picking by board position, cards in hand, or fewest creatures. It leans on `PlayerCollection` plus `PlayerPredicates`/`AiPlayerPredicates` for filtering and comparison, and degrades gracefully to a sensible default (self or first available) when no logic matches or no good choice exists.

## Source
`forge-ai/src/main/java/forge/ai/ability/ChoosePlayerAi.java`

```java
package forge.ai.ability;

import com.google.common.collect.Iterables;

import forge.ai.AiAbilityDecision;
import forge.ai.AiPlayDecision;
import forge.ai.AiPlayerPredicates;
import forge.ai.SpellAbilityAi;
import forge.game.player.Player;
import forge.game.player.PlayerCollection;
import forge.game.player.PlayerPredicates;
import forge.game.spellability.SpellAbility;
import forge.game.zone.ZoneType;

import java.util.Map;

public class ChoosePlayerAi extends SpellAbilityAi {
    @Override
    protected AiAbilityDecision canPlay(Player ai, SpellAbility sa) {
        return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
    }

    @Override
    public AiAbilityDecision chkDrawback(Player ai, SpellAbility sa) {
        return canPlay(ai, sa);
    }

    @Override
    protected AiAbilityDecision doTriggerNoCost(Player ai, SpellAbility sa, boolean mandatory) {
        return canPlay(ai, sa);
    }

    @Override
    public Player chooseSinglePlayer(Player ai, SpellAbility sa, Iterable<Player> choices, Map<String, Object> params) {
        Player chosen = null;
        if (sa.hasParam("Protect")) {
            chosen = new PlayerCollection(choices).min(PlayerPredicates.compareByLife());
        }
        else if ("Curse".equals(sa.getParam("AILogic"))) {
            PlayerCollection curseChoices = new PlayerCollection(choices).filter(PlayerPredicates.isOpponentOf(ai));
            if (!curseChoices.isEmpty()) {
                chosen = curseChoices.max(AiPlayerPredicates.compareByBoardPosition);
            }
            if (chosen == null) {
                chosen = Iterables.getFirst(choices, null);
                System.out.println("No good curse choices. Picking first available: " + chosen);
            }
        }
        else if ("Pump".equals(sa.getParam("AILogic"))) {
            chosen = Iterables.contains(choices, ai) ? ai : Iterables.getFirst(choices, null);
        }
        else if ("BestAllyBoardPosition".equals(sa.getParam("AILogic"))) {
            PlayerCollection prefChoices = new PlayerCollection(choices);
            prefChoices.removeAll(ai.getOpponents());
            if (!prefChoices.isEmpty()) {
                chosen = prefChoices.max(AiPlayerPredicates.compareByBoardPosition);
            }
            if (chosen == null) {
                chosen = Iterables.getFirst(choices, null);
                System.out.println("No good curse choices. Picking first available: " + chosen);
            }
        } else if ("MostCardsInHand".equals(sa.getParam("AILogic"))) {
            int cardsInHand = 0;
            for (final Player p : choices) {
                int hand = p.getCardsIn(ZoneType.Hand).size();
                if (hand >= cardsInHand) {
                    chosen = p;
                    cardsInHand = hand;
                }
            }
        } else if ("LeastCreatures".equals(sa.getParam("AILogic"))) {
            int creats = 50;
            for (final Player p : choices) {
                int curr = p.getCreaturesInPlay().size();
                if (curr <= creats) {
                    chosen = p;
                    creats = curr;
                }
            }
        } else {
            System.out.println("Default player choice logic.");
            chosen = Iterables.contains(choices, ai) ? ai : Iterables.getFirst(choices, null);
        }
        return chosen;
    }
}
```

## Python
`forge/ai/ability/ChoosePlayerAi.py`

```python
from forge.ai.AiAbilityDecision import AiAbilityDecision
from forge.ai.AiPlayDecision import AiPlayDecision
from forge.ai.AiPlayerPredicates import AiPlayerPredicates
from forge.ai.SpellAbilityAi import SpellAbilityAi
from forge.game.player.Player import Player
from forge.game.player.PlayerCollection import PlayerCollection
from forge.game.player.PlayerPredicates import PlayerPredicates
from forge.game.spellability.SpellAbility import SpellAbility
from forge.game.zone.ZoneType import ZoneType

from typing import Iterable, Map


class ChoosePlayerAi(SpellAbilityAi):
    def canPlay(self, ai: Player, sa: SpellAbility) -> AiAbilityDecision:
        return AiAbilityDecision(100, AiPlayDecision.WillPlay)

    def chkDrawback(self, ai: Player, sa: SpellAbility) -> AiAbilityDecision:
        return self.canPlay(ai, sa)

    def doTriggerNoCost(self, ai: Player, sa: SpellAbility, mandatory: bool) -> AiAbilityDecision:
        return self.canPlay(ai, sa)

    def chooseSinglePlayer(self, ai: Player, sa: SpellAbility, choices: Iterable[Player], params: dict[str, object]) -> Player:
        chosen = None
        if sa.hasParam("Protect"):
            chosen = PlayerCollection(choices).min(PlayerPredicates.compareByLife())
        elif "Curse" == sa.getParam("AILogic"):
            curseChoices = PlayerCollection(choices).filter(PlayerPredicates.isOpponentOf(ai))
            if not curseChoices.isEmpty():
                chosen = curseChoices.max(AiPlayerPredicates.compareByBoardPosition)
            if chosen is None:
                chosen = next(iter(choices), None)
                print("No good curse choices. Picking first available: " + str(chosen))
        elif "Pump" == sa.getParam("AILogic"):
            chosen = ai if ai in choices else next(iter(choices), None)
        elif "BestAllyBoardPosition" == sa.getParam("AILogic"):
            prefChoices = PlayerCollection(choices)
            prefChoices.removeAll(ai.getOpponents())
            if not prefChoices.isEmpty():
                chosen = prefChoices.max(AiPlayerPredicates.compareByBoardPosition)
            if chosen is None:
                chosen = next(iter(choices), None)
                print("No good curse choices. Picking first available: " + str(chosen))
        elif "MostCardsInHand" == sa.getParam("AILogic"):
            cardsInHand = 0
            for p in choices:
                hand = p.getCardsIn(ZoneType.Hand).size()
                if hand >= cardsInHand:
                    chosen = p
                    cardsInHand = hand
        elif "LeastCreatures" == sa.getParam("AILogic"):
            creats = 50
            for p in choices:
                curr = p.getCreaturesInPlay().size()
                if curr <= creats:
                    chosen = p
                    creats = curr
        else:
            print("Default player choice logic.")
            chosen = ai if ai in choices else next(iter(choices), None)
        return chosen
```
