---
aliases:
  - TriggerGiveGift
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/trigger
fqn: forge.game.trigger.TriggerGiveGift
package: forge.game.trigger
module: forge-game
kind: Class
---

# TriggerGiveGift

**Package:** `forge.game.trigger` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class TriggerGiveGift {
        +getImportantStackObjects(SpellAbility sa) String
        +setTriggeringObjects(SpellAbility sa, Map~AbilityKey,Object~ runParams) void
        +performTest(Map~AbilityKey,Object~ runParams) boolean
        +TriggerGiveGift(Map~String,String~ params, Card host, boolean intrinsic)
    }
    TriggerGiveGift --|> Trigger : extends
    TriggerGiveGift ..> AbilityKey : uses
    TriggerGiveGift ..> Card : uses
    TriggerGiveGift ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.trigger.Trigger|Trigger]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

TriggerGiveGift is a concrete trigger that fires when a player is given a "gift" (a mechanic granting an opponent some benefit in exchange). As a subclass of Trigger, it specializes the base trigger framework for this specific event by overriding the hook methods the engine invokes during trigger evaluation: setTriggeringObjects copies the relevant Player from the run parameters into the firing SpellAbility, performTest gates activation through the ValidPlayer restriction, and getImportantStackObjects produces a localized, player-facing summary of the triggering player.

The design follows the engine's template-method convention, keeping all trigger-type knowledge in small, focused overrides while delegating construction and shared behavior to the superclass. It collaborates with AbilityKey to key its single triggering object (the Player), with Card as the trigger's host, and with SpellAbility as the carrier of triggering state, and it relies on Localizer to keep displayed text translatable.

## Source
`forge-game/src/main/java/forge/game/trigger/TriggerGiveGift.java`

```java
/*
 * Forge: Play Magic: the Gathering.
 * Copyright (C) 2011  Forge Team
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package forge.game.trigger;

import java.util.Map;

import forge.game.ability.AbilityKey;
import forge.game.card.Card;
import forge.game.spellability.SpellAbility;
import forge.util.Localizer;

/**
 * @author Forge
 */
public class TriggerGiveGift extends Trigger {

    /**
     *
     * @param params
     *            a {@link java.util.HashMap} object.
     * @param host
     *            a {@link forge.game.card.Card} object.
     * @param intrinsic
     *            the intrinsic
     */
    public TriggerGiveGift(final Map<String, String> params, final Card host, final boolean intrinsic) {
        super(params, host, intrinsic);
    }

    @Override
    public String getImportantStackObjects(SpellAbility sa) {
        StringBuilder sb = new StringBuilder();
        sb.append(Localizer.getInstance().getMessage("lblPlayer")).append(": ").append(sa.getTriggeringObject(AbilityKey.Player));
        return sb.toString();
    }

    /** {@inheritDoc} */
    @Override
    public final void setTriggeringObjects(final SpellAbility sa, Map<AbilityKey, Object> runParams) {
        sa.setTriggeringObjectsFrom(runParams, AbilityKey.Player);
    }

    /** {@inheritDoc}
     * @param runParams*/
    @Override
    public final boolean performTest(final Map<AbilityKey, Object> runParams) {
        if (!matchesValidParam("ValidPlayer", runParams.get(AbilityKey.Player))) {
            return false;
        }

        return true;
    }

}
```

## Python
`forge/game/trigger/TriggerGiveGift.py`

```python
from forge.game.trigger.Trigger import Trigger
from forge.game.ability.AbilityKey import AbilityKey
from forge.game.card.Card import Card
from forge.game.spellability.SpellAbility import SpellAbility
from forge.util.Localizer import Localizer


class TriggerGiveGift(Trigger):

    def __init__(self, params: dict[str, str], host: Card, intrinsic: bool):
        super().__init__(params, host, intrinsic)

    def getImportantStackObjects(self, sa: SpellAbility) -> str:
        sb = []
        sb.append(Localizer.getInstance().getMessage("lblPlayer"))
        sb.append(": ")
        sb.append(str(sa.getTriggeringObject(AbilityKey.Player)))
        return "".join(sb)

    def setTriggeringObjects(self, sa: SpellAbility, runParams: dict[AbilityKey, object]) -> None:
        sa.setTriggeringObjectsFrom(runParams, AbilityKey.Player)

    def performTest(self, runParams: dict[AbilityKey, object]) -> bool:
        if not self.matchesValidParam("ValidPlayer", runParams.get(AbilityKey.Player)):
            return False

        return True
```
