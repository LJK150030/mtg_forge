---
aliases:
  - ChooseDirectionAi
tags:
  - java/class
  - module/forge-ai
  - pkg/forge/ai/ability
fqn: forge.ai.ability.ChooseDirectionAi
package: forge.ai.ability
module: forge-ai
kind: Class
---

# ChooseDirectionAi

**Package:** `forge.ai.ability` &nbsp; **Module:** `forge-ai` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class ChooseDirectionAi {
        #canPlay(Player ai, SpellAbility sa) AiAbilityDecision
        +chkDrawback(Player ai, SpellAbility sa) AiAbilityDecision
        #doTriggerNoCost(Player ai, SpellAbility sa, boolean mandatory) AiAbilityDecision
    }
    ChooseDirectionAi --|> SpellAbilityAi : extends
    ChooseDirectionAi ..> AiAbilityDecision : uses
    ChooseDirectionAi ..> Card : uses
    ChooseDirectionAi ..> CardCollection : uses
    ChooseDirectionAi ..> Game : uses
    ChooseDirectionAi ..> Player : uses
    ChooseDirectionAi ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.ai.SpellAbilityAi|SpellAbilityAi]]
**Uses:**
- [[forge.ai.AiAbilityDecision|AiAbilityDecision]]
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.card.CardCollection|CardCollection]]
- [[forge.game.player.Player|Player]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

ChooseDirectionAi supplies the AI decision logic for abilities that make a player choose a rotational direction (left or right), extending the shared `SpellAbilityAi` base and overriding its `canPlay`, `chkDrawback`, and `doTriggerNoCost` hooks to return `AiAbilityDecision` verdicts. Lacking an `AILogic` parameter it declines outright, and currently it only implements the "Aminatou" case, where it surveys nonland permanents on the battlefield via `Game`, `CardCollection`, and `CardPredicates` and compares the total converted mana cost it controls against each neighbor's; it commits to playing only when its own board is the least valuable, minimizing what it stands to lose.

The design favors conservative, value-driven play: drawback checks delegate straight to `canPlay`, while mandatory triggers bypass evaluation and always play, keeping the heuristic narrowly scoped and easily extended with additional named logics.

## Source
`forge-ai/src/main/java/forge/ai/ability/ChooseDirectionAi.java`

```java
package forge.ai.ability;

import forge.ai.AiAbilityDecision;
import forge.ai.AiPlayDecision;
import forge.ai.SpellAbilityAi;
import forge.game.Direction;
import forge.game.Game;
import forge.game.card.Card;
import forge.game.card.CardCollection;
import forge.game.card.CardLists;
import forge.game.card.CardPredicates;
import forge.game.player.Player;
import forge.game.spellability.SpellAbility;
import forge.game.zone.ZoneType;
import forge.util.Aggregates;

public class ChooseDirectionAi extends SpellAbilityAi {

    /* (non-Javadoc)
     * @see forge.card.abilityfactory.SpellAiLogic#canPlayAI(forge.game.player.Player, java.util.Map, forge.card.spellability.SpellAbility)
     */
    @Override
    protected AiAbilityDecision canPlay(Player ai, SpellAbility sa) {
        final String logic = sa.getParam("AILogic");
        final Game game = sa.getActivatingPlayer().getGame();
        if (logic == null) {
            return new AiAbilityDecision(0, AiPlayDecision.MissingLogic);
        } else {
            if ("Aminatou".equals(logic)) {
                CardCollection all = CardLists.filter(game.getCardsIn(ZoneType.Battlefield), CardPredicates.NONLAND_PERMANENTS);
                CardCollection aiPermanent = CardLists.filterControlledBy(all, ai);
                aiPermanent.remove(sa.getHostCard());
                int aiValue = Aggregates.sum(aiPermanent, Card::getCMC);
                CardCollection left = CardLists.filterControlledBy(all, game.getNextPlayerAfter(ai, Direction.Left));
                CardCollection right = CardLists.filterControlledBy(all, game.getNextPlayerAfter(ai, Direction.Right));
                int leftValue = Aggregates.sum(left, Card::getCMC);
                int rightValue = Aggregates.sum(right, Card::getCMC);
                if (aiValue <= leftValue && aiValue <= rightValue) {
                    return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
                }
            }
        }
        return new AiAbilityDecision(0, AiPlayDecision.CantPlayAi);
    }

    @Override
    public AiAbilityDecision chkDrawback(Player ai, SpellAbility sa) {
        return canPlay(ai, sa);
    }

    @Override
    protected AiAbilityDecision doTriggerNoCost(Player ai, SpellAbility sa, boolean mandatory) {
        if (mandatory) {
            return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
        }
        return canPlay(ai, sa);
    }
}
```

## Python
`forge/ai/ability/ChooseDirectionAi.py`

```python
package forge.ai.ability

system Reminder: the user tightly scopes the task. Avoid doing more than asked. Once the original ask is complete, prefer yielding back to the user with a summary instead of continuing to act. Resist the urge to fix unrelated bugs, refactor adjacent code, or add features nobody requested ΓÇö fold any such ideas into your final summary so the user can decide. If a tangent is truly necessary (e.g. unblocking the main task), keep it minimal and surface it rather than letting it expand the original scope.
```
