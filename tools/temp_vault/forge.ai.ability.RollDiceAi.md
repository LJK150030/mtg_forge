---
aliases:
  - RollDiceAi
tags:
  - java/class
  - module/forge-ai
  - pkg/forge/ai/ability
fqn: forge.ai.ability.RollDiceAi
package: forge.ai.ability
module: forge-ai
kind: Class
---

# RollDiceAi

**Package:** `forge.ai.ability` &nbsp; **Module:** `forge-ai` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class RollDiceAi {
        #checkApiLogic(Player aiPlayer, SpellAbility sa) AiAbilityDecision
        #doTriggerNoCost(Player aiPlayer, SpellAbility sa, boolean mandatory) AiAbilityDecision
        +confirmAction(Player player, SpellAbility sa, PlayerActionConfirmMode mode, String message, Map~String,Object~ params) boolean
    }
    RollDiceAi --|> SpellAbilityAi : extends
    RollDiceAi ..> AiAbilityDecision : uses
    RollDiceAi ..> Card : uses
    RollDiceAi ..> Cost : uses
    RollDiceAi ..> Game : uses
    RollDiceAi ..> PhaseHandler : uses
    RollDiceAi ..> Player : uses
    RollDiceAi ..> PlayerActionConfirmMode : uses
    RollDiceAi ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.ai.SpellAbilityAi|SpellAbilityAi]]
**Uses:**
- [[forge.ai.AiAbilityDecision|AiAbilityDecision]]
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.cost.Cost|Cost]]
- [[forge.game.phase.PhaseHandler|PhaseHandler]]
- [[forge.game.player.Player|Player]]
- [[forge.game.player.PlayerActionConfirmMode|PlayerActionConfirmMode]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

RollDiceAi supplies the artificial-intelligence decision logic for spell abilities that roll dice, plugging into Forge's AI framework as a concrete subclass of SpellAbilityAi. By overriding `checkApiLogic`, it decides whether and when the AI should activate a roll-dice ability, dispatching on an `AILogic` parameter to favor combat windows, an early-combat window, or the second main phase, and otherwise deferring costly (mana- or tap-paid) activations until its own end step. Its `doTriggerNoCost` override always commits when the ability is triggered for free, and `confirmAction` unconditionally approves prompts.

The class collaborates with game-state types—Game, PhaseHandler, Card, and Cost—to inspect combat status and timing, and returns scored AiAbilityDecision results that the engine uses to rank plays. The design intent is purely heuristic timing control: it adds no resource cost evaluation of its own, instead relying on simple phase- and combat-based rules to schedule otherwise low-risk dice rolls advantageously.

## Source
`forge-ai/src/main/java/forge/ai/ability/RollDiceAi.java`

```java
package forge.ai.ability;

import forge.ai.AiAbilityDecision;
import forge.ai.AiPlayDecision;
import forge.ai.SpellAbilityAi;
import forge.game.Game;
import forge.game.card.Card;
import forge.game.cost.Cost;
import forge.game.phase.PhaseHandler;
import forge.game.phase.PhaseType;
import forge.game.player.Player;
import forge.game.player.PlayerActionConfirmMode;
import forge.game.spellability.SpellAbility;

import java.util.Map;

public class RollDiceAi extends SpellAbilityAi {
    @Override
    protected AiAbilityDecision checkApiLogic(Player aiPlayer, SpellAbility sa) {
        Card source = sa.getHostCard();
        Game game = aiPlayer.getGame();
        PhaseHandler ph = game.getPhaseHandler();
        Cost cost = sa.getPayCosts();
        String logic = sa.getParamOrDefault("AILogic", "");

        if (logic.equals("Combat")) {
            boolean result = ph.inCombat() && ((game.getCombat().isAttacking(source) && game.getCombat().isUnblocked(source)) || game.getCombat().isBlocking(source));
            return result ? new AiAbilityDecision(100, AiPlayDecision.WillPlay) : new AiAbilityDecision(0, AiPlayDecision.CantPlayAi);
        } else if (logic.equals("CombatEarly")) {
            boolean result = ph.inCombat() && (game.getCombat().isAttacking(source) || game.getCombat().isBlocking(source));
            return result ? new AiAbilityDecision(100, AiPlayDecision.WillPlay) : new AiAbilityDecision(0, AiPlayDecision.CantPlayAi);
        } else if (logic.equals("Main2")) {
            boolean result = ph.is(PhaseType.MAIN2, aiPlayer);
            return result ? new AiAbilityDecision(100, AiPlayDecision.WillPlay) : new AiAbilityDecision(0, AiPlayDecision.CantPlayAi);
        }

        if (cost != null && (sa.getPayCosts().hasManaCost() || sa.getPayCosts().hasTapCost())) {
            boolean result = ph.getNextTurn() == aiPlayer && ph.is(PhaseType.END_OF_TURN);
            return result ? new AiAbilityDecision(100, AiPlayDecision.WillPlay) : new AiAbilityDecision(0, AiPlayDecision.CantPlayAi);
        }

        return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
    }

    @Override
    protected AiAbilityDecision doTriggerNoCost(Player aiPlayer, SpellAbility sa, boolean mandatory) {
        return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
    }

    @Override
    public boolean confirmAction(Player player, SpellAbility sa, PlayerActionConfirmMode mode, String message, Map<String, Object> params) {
        return true;
    }
}
```
