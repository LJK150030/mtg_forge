---
aliases:
  - BlightAi
tags:
  - java/class
  - module/forge-ai
  - pkg/forge/ai/ability
fqn: forge.ai.ability.BlightAi
package: forge.ai.ability
module: forge-ai
kind: Class
---

# BlightAi

**Package:** `forge.ai.ability` &nbsp; **Module:** `forge-ai` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class BlightAi {
        #checkApiLogic(Player ai, SpellAbility sa) AiAbilityDecision
        #doTriggerNoCost(Player ai, SpellAbility sa, boolean mandatory) AiAbilityDecision
        -canPlayWithTargeting(Player ai, SpellAbility sa, boolean mandatory) AiAbilityDecision
        -hasBlightableCreatures(Player player) boolean
        -canKillWorstCreature(Player player, int blightAmount) boolean
        #chooseSingleCard(Player ai, SpellAbility sa, Iterable~Card~ options, boolean isOptional, Player targetedPlayer, Map~String,Object~ params) Card
    }
    BlightAi --|> SpellAbilityAi : extends
    BlightAi ..> AiAbilityDecision : uses
    BlightAi ..> Card : uses
    BlightAi ..> CardCollection : uses
    BlightAi ..> Player : uses
    BlightAi ..> PlayerCollection : uses
    BlightAi ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.ai.SpellAbilityAi|SpellAbilityAi]]
**Uses:**
- [[forge.ai.AiAbilityDecision|AiAbilityDecision]]
- [[forge.game.card.Card|Card]]
- [[forge.game.card.CardCollection|CardCollection]]
- [[forge.game.player.Player|Player]]
- [[forge.game.player.PlayerCollection|PlayerCollection]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

BlightAi is the AI decision-making strategy for "Blight"-style abilities that place -1/-1 counters on opponents' creatures. Extending `SpellAbilityAi`, it overrides the standard hooksâ€”`checkApiLogic` and `doTriggerNoCost`â€”routing both through a shared `canPlayWithTargeting` helper so that proactive casting and forced triggers share identical target-selection logic, expressed through the `AiAbilityDecision`/`AiPlayDecision` protocol.

Its design intent is value-maximizing target selection: it filters opponents to those holding counter-eligible creatures and prefers the one whose worst creature the blight amount would actually kill, falling back to an arbitrary targetable opponent only when the effect is mandatory. Collaborating with `Player`/`PlayerCollection` and `Card`/`CardCollection` and leaning on `ComputerUtilCard` for "worst creature" evaluation, it also overrides `chooseSingleCard` to favor sacrificing low-value Undying creatures that survive the countersâ€”heuristics that reflect deliberate play-quality reasoning rather than arbitrary choices.

## Source
`forge-ai/src/main/java/forge/ai/ability/BlightAi.java`

```java
package forge.ai.ability;

import forge.ai.AiAbilityDecision;
import forge.ai.AiPlayDecision;
import forge.ai.ComputerUtilCard;
import forge.ai.SpellAbilityAi;
import forge.game.ability.AbilityUtils;
import forge.game.card.Card;
import forge.game.card.CardCollection;
import forge.game.card.CardLists;
import forge.game.card.CounterEnumType;
import forge.game.keyword.Keyword;
import forge.game.player.Player;
import forge.game.player.PlayerCollection;
import forge.game.player.PlayerPredicates;
import forge.game.spellability.SpellAbility;

import java.util.Map;
import java.util.Optional;

public class BlightAi extends SpellAbilityAi {

    @Override
    protected AiAbilityDecision checkApiLogic(Player ai, SpellAbility sa) {
        return canPlayWithTargeting(ai, sa, false);
    }

    @Override
    protected AiAbilityDecision doTriggerNoCost(final Player ai, final SpellAbility sa, final boolean mandatory) {
        return canPlayWithTargeting(ai, sa, mandatory);
    }

    private AiAbilityDecision canPlayWithTargeting(Player ai, SpellAbility sa, boolean mandatory) {
        if (!sa.usesTargeting()) {
            return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
        }

        sa.resetTargets();
        PlayerCollection opponents = ai.getOpponents().filter(PlayerPredicates.isTargetableBy(sa));
        int blightAmount = AbilityUtils.calculateAmount(
                sa.getHostCard(), sa.getParamOrDefault("Num", "1"), sa);

        // Prioritize opponents whose worst blightable creature would die
        Optional<Player> target = opponents.stream()
                .filter(this::hasBlightableCreatures).min((a, b) -> Boolean.compare(
                        canKillWorstCreature(b, blightAmount),
                        canKillWorstCreature(a, blightAmount)));

        if (target.isPresent()) {
            sa.getTargets().add(target.get());
            return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
        }

        if (mandatory && !opponents.isEmpty()) {
            sa.getTargets().add(opponents.getFirst());
            return new AiAbilityDecision(100, AiPlayDecision.WillPlay);
        }

        return new AiAbilityDecision(0, AiPlayDecision.TargetingFailed);
    }

    private boolean hasBlightableCreatures(Player player) {
        return player.getCreaturesInPlay().stream()
                .anyMatch(c -> c.canReceiveCounters(CounterEnumType.M1M1));
    }

    private boolean canKillWorstCreature(Player player, int blightAmount) {
        Card worst = ComputerUtilCard.getWorstCreatureAI(
                CardLists.filter(player.getCreaturesInPlay(),
                        c -> c.canReceiveCounters(CounterEnumType.M1M1)));
        return worst != null && worst.getNetToughness() <= blightAmount;
    }

    @Override
    protected Card chooseSingleCard(Player ai, SpellAbility sa, Iterable<Card> options, boolean isOptional, Player targetedPlayer, Map<String, Object> params) {
        // Prefer creatures with Undying that won't die from the counters
        int amount = AbilityUtils.calculateAmount(sa.getHostCard(), sa.getParamOrDefault("Num", "1"), sa);
        CardCollection undying = CardLists.filter(options, c ->
                c.hasKeyword(Keyword.UNDYING)
                && c.getCounters(CounterEnumType.P1P1) <= amount
                && c.getNetToughness() > amount);

        if (!undying.isEmpty()) {
            return ComputerUtilCard.getWorstCreatureAI(undying);
        }

        return ComputerUtilCard.getWorstCreatureAI(options);
    }
}
```

## Python
`forge/ai/ability/BlightAi.py`

```python
from forge.ai.AiAbilityDecision import AiAbilityDecision
from forge.ai.AiPlayDecision import AiPlayDecision
from forge.ai.ComputerUtilCard import ComputerUtilCard
from forge.ai.SpellAbilityAi import SpellAbilityAi
from forge.game.ability.AbilityUtils import AbilityUtils
from forge.game.card.Card import Card
from forge.game.card.CardCollection import CardCollection
from forge.game.card.CardLists import CardLists
from forge.game.card.CounterEnumType import CounterEnumType
from forge.game.keyword.Keyword import Keyword
from forge.game.player.Player import Player
from forge.game.player.PlayerCollection import PlayerCollection
from forge.game.player.PlayerPredicates import PlayerPredicates
from forge.game.spellability.SpellAbility import SpellAbility

from typing import Iterable, Optional


class BlightAi(SpellAbilityAi):

    def checkApiLogic(self, ai: Player, sa: SpellAbility) -> AiAbilityDecision:
        return self.canPlayWithTargeting(ai, sa, False)

    def doTriggerNoCost(self, ai: Player, sa: SpellAbility, mandatory: bool) -> AiAbilityDecision:
        return self.canPlayWithTargeting(ai, sa, mandatory)

    def canPlayWithTargeting(self, ai: Player, sa: SpellAbility, mandatory: bool) -> AiAbilityDecision:
        if not sa.usesTargeting():
            return AiAbilityDecision(100, AiPlayDecision.WillPlay)

        sa.resetTargets()
        opponents: PlayerCollection = ai.getOpponents().filter(PlayerPredicates.isTargetableBy(sa))
        blightAmount: int = AbilityUtils.calculateAmount(
                sa.getHostCard(), sa.getParamOrDefault("Num", "1"), sa)

        # Prioritize opponents whose worst blightable creature would die
        blightable = [p for p in opponents if self.hasBlightableCreatures(p)]
        target: Optional[Player] = None
        if blightable:
            target = min(blightable, key=lambda p: 0 if self.canKillWorstCreature(p, blightAmount) else 1)

        if target is not None:
            sa.getTargets().add(target)
            return AiAbilityDecision(100, AiPlayDecision.WillPlay)

        if mandatory and not opponents.isEmpty():
            sa.getTargets().add(opponents.getFirst())
            return AiAbilityDecision(100, AiPlayDecision.WillPlay)

        return AiAbilityDecision(0, AiPlayDecision.TargetingFailed)

    def hasBlightableCreatures(self, player: Player) -> bool:
        return any(c.canReceiveCounters(CounterEnumType.M1M1)
                   for c in player.getCreaturesInPlay())

    def canKillWorstCreature(self, player: Player, blightAmount: int) -> bool:
        worst: Card = ComputerUtilCard.getWorstCreatureAI(
                CardLists.filter(player.getCreaturesInPlay(),
                        lambda c: c.canReceiveCounters(CounterEnumType.M1M1)))
        return worst is not None and worst.getNetToughness() <= blightAmount

    def chooseSingleCard(self, ai: Player, sa: SpellAbility, options: Iterable[Card], isOptional: bool, targetedPlayer: Player, params: dict[str, object]) -> Card:
        # Prefer creatures with Undying that won't die from the counters
        amount: int = AbilityUtils.calculateAmount(sa.getHostCard(), sa.getParamOrDefault("Num", "1"), sa)
        undying: CardCollection = CardLists.filter(options, lambda c:
                c.hasKeyword(Keyword.UNDYING)
                and c.getCounters(CounterEnumType.P1P1) <= amount
                and c.getNetToughness() > amount)

        if not undying.isEmpty():
            return ComputerUtilCard.getWorstCreatureAI(undying)

        return ComputerUtilCard.getWorstCreatureAI(options)
```
