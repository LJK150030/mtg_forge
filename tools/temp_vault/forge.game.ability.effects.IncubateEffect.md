---
aliases:
  - IncubateEffect
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/ability/effects
fqn: forge.game.ability.effects.IncubateEffect
package: forge.game.ability.effects
module: forge-game
kind: Class
---

# IncubateEffect

**Package:** `forge.game.ability.effects` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class IncubateEffect {
        #getStackDescription(SpellAbility sa) String
        +resolve(SpellAbility sa) void
    }
    IncubateEffect --|> TokenEffectBase : extends
    IncubateEffect ..> Card : uses
    IncubateEffect ..> CardZoneTable : uses
    IncubateEffect ..> Game : uses
    IncubateEffect ..> GameEventCombatChanged : uses
    IncubateEffect ..> GameEventTokenCreated : uses
    IncubateEffect ..> Player : uses
    IncubateEffect ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.ability.effects.TokenEffectBase|TokenEffectBase]]
**Uses:**
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.card.CardZoneTable|CardZoneTable]]
- [[forge.game.event.GameEventCombatChanged|GameEventCombatChanged]]
- [[forge.game.event.GameEventTokenCreated|GameEventTokenCreated]]
- [[forge.game.player.Player|Player]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]


## Design Description

IncubateEffect implements Magic's "Incubate" keyword action as a resolvable ability effect within the `forge.game.ability.effects` package. Extending TokenEffectBase, it reuses inherited token-creation machinery to produce colorless "Incubator" Phyrexian artifact tokens, configuring each with P1P1 counters whose amount is driven by the SpellAbility's "Amount" parameter.

The class separates presentation from execution: getStackDescription builds readable stack text, deferring to the configured SpellDescription (with reminder text trimmed) when the amount is non-numeric and hard to precompute. resolve creates tokens per targeted Player, repeated "Times" times, using a CardZoneTable to batch zone-change triggers and a MutableBoolean to detect combat shifts. It then fires GameEventTokenCreated and, only when combat changed, refreshes the combat view and fires GameEventCombatChangedâ€”keeping the Game's event bus and observers synchronized with minimal redundant updates.

## Source
`forge-game/src/main/java/forge/game/ability/effects/IncubateEffect.java`

```java
package forge.game.ability.effects;

import forge.game.Game;
import forge.game.ability.AbilityUtils;
import forge.game.card.*;
import forge.game.event.GameEventCombatChanged;
import forge.game.event.GameEventTokenCreated;
import forge.game.player.Player;
import forge.game.spellability.SpellAbility;
import forge.util.Lang;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.mutable.MutableBoolean;

public class IncubateEffect extends TokenEffectBase {

    @Override
    protected String getStackDescription(SpellAbility sa) {
        if (!StringUtils.isNumeric(sa.getParam("Amount"))) { // non-numeric too easy to miscalc, default to SpellDesc
            String desc = sa.getParamOrDefault("SpellDescription", "Please add SpellDescription for non-numeric");
            int idx = desc.indexOf("(");
            if (idx > 0) { //trim reminder text from StackDesc
                desc = desc.substring(0, desc.indexOf("(") - 1);
            }
            return desc;
        }

        final StringBuilder sb = new StringBuilder("Incubate ");
        final Card card = sa.getHostCard();
        final int amount = AbilityUtils.calculateAmount(card, sa.getParamOrDefault("Amount", "1"), sa);
        final int times = AbilityUtils.calculateAmount(card, sa.getParamOrDefault("Times", "1"), sa);

        sb.append(amount);
        if (times > 1) {
            sb.append(" ").append(times == 2 ? "twice" : Lang.nounWithNumeral(amount, "times"));
        }
        sb.append(".");

        return sb.toString();
    }

    @Override
    public void resolve(SpellAbility sa) {
        final Card host = sa.getHostCard();
        final Game game = host.getGame();
        final int times = AbilityUtils.calculateAmount(host, sa.getParamOrDefault("Times", "1"), sa);
        sa.putParam("WithCountersType", "P1P1");
        sa.putParam("WithCountersAmount", sa.getParamOrDefault("Amount", "1"));

        for (final Player p : getTargetPlayers(sa)) {
            for (int i = 0; i < times; i++) {
                CardZoneTable triggerList = new CardZoneTable();
                MutableBoolean combatChanged = new MutableBoolean(false);

                makeTokenTable(makeTokenTableInternal(p, "incubator_c_0_0_a_phyrexian", 1, sa), false,
                        triggerList, combatChanged, sa);

                triggerList.triggerChangesZoneAll(game, sa);

                game.fireEvent(new GameEventTokenCreated());

                if (combatChanged.isTrue()) {
                    game.updateCombatForView();
                    game.fireEvent(new GameEventCombatChanged());
                }
            }
        }
    }
}
```

## Python
`forge/game/ability/effects/IncubateEffect.py`

```python
package forge.game.ability.effects

from forge.game.Game import Game
from forge.game.ability.AbilityUtils import AbilityUtils
from forge.game.card.Card import Card
from forge.game.card.CardZoneTable import CardZoneTable
from forge.game.event.GameEventCombatChanged import GameEventCombatChanged
from forge.game.event.GameEventTokenCreated import GameEventTokenCreated
from forge.game.player.Player import Player
from forge.game.spellability.SpellAbility import SpellAbility
from forge.util.Lang import Lang
from forge.game.ability.effects.TokenEffectBase import TokenEffectBase

from org.apache.commons.lang3.StringUtils import StringUtils
from org.apache.commons.lang3.mutable.MutableBoolean import MutableBoolean


class IncubateEffect(TokenEffectBase):

    def getStackDescription(self, sa: SpellAbility) -> str:
        if not StringUtils.isNumeric(sa.getParam("Amount")):  # non-numeric too easy to miscalc, default to SpellDesc
            desc = sa.getParamOrDefault("SpellDescription", "Please add SpellDescription for non-numeric")
            idx = desc.find("(")
            if idx > 0:  # trim reminder text from StackDesc
                desc = desc[0:desc.find("(") - 1]
            return desc

        sb = []
        sb.append("Incubate ")
        card = sa.getHostCard()
        amount = AbilityUtils.calculateAmount(card, sa.getParamOrDefault("Amount", "1"), sa)
        times = AbilityUtils.calculateAmount(card, sa.getParamOrDefault("Times", "1"), sa)

        sb.append(str(amount))
        if times > 1:
            sb.append(" ")
            sb.append("twice" if times == 2 else Lang.nounWithNumeral(amount, "times"))
        sb.append(".")

        return "".join(sb)

    def resolve(self, sa: SpellAbility) -> None:
        host = sa.getHostCard()
        game = host.getGame()
        times = AbilityUtils.calculateAmount(host, sa.getParamOrDefault("Times", "1"), sa)
        sa.putParam("WithCountersType", "P1P1")
        sa.putParam("WithCountersAmount", sa.getParamOrDefault("Amount", "1"))

        for p in self.getTargetPlayers(sa):
            for i in range(times):
                triggerList = CardZoneTable()
                combatChanged = MutableBoolean(False)

                self.makeTokenTable(self.makeTokenTableInternal(p, "incubator_c_0_0_a_phyrexian", 1, sa), False,
                        triggerList, combatChanged, sa)

                triggerList.triggerChangesZoneAll(game, sa)

                game.fireEvent(GameEventTokenCreated())

                if combatChanged.isTrue():
                    game.updateCombatForView()
                    game.fireEvent(GameEventCombatChanged())
```
