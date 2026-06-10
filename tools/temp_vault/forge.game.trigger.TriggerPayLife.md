---
aliases:
  - TriggerPayLife
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/trigger
fqn: forge.game.trigger.TriggerPayLife
package: forge.game.trigger
module: forge-game
kind: Class
---

# TriggerPayLife

**Package:** `forge.game.trigger` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class TriggerPayLife {
        +performTest(Map~AbilityKey,Object~ runParams) boolean
        +setTriggeringObjects(SpellAbility sa, Map~AbilityKey,Object~ runParams) void
        +getImportantStackObjects(SpellAbility sa) String
        +TriggerPayLife(Map~String,String~ params, Card host, boolean intrinsic)
    }
    TriggerPayLife --|> Trigger : extends
    TriggerPayLife ..> AbilityKey : uses
    TriggerPayLife ..> Card : uses
    TriggerPayLife ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.trigger.Trigger|Trigger]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

TriggerPayLife is a concrete trigger that fires when a player pays life, extending the abstract `Trigger` base class to plug into Forge's event-driven triggered-ability system. Its `performTest` gates activation by matching the paying player against the optional `ValidPlayer` restriction, while `setTriggeringObjects` exposes the `Player` and `LifeAmount` to the resulting `SpellAbility` so downstream effects can reference who paid and how much.

Following the established Trigger contract, it communicates entirely through the `AbilityKey`-keyed run-parameter map rather than bespoke fields, and overrides `getImportantStackObjects` to render a localized, human-readable stack summary via `Localizer`. The design is deliberately thinâ€”delegating construction and core trigger machinery to its supertype and collaborating with `Card` (the host) and `SpellAbility`â€”reflecting Forge's data-driven pattern where each trigger subclass supplies only the condition test and the binding of triggering objects.

## Source
`forge-game/src/main/java/forge/game/trigger/TriggerPayLife.java`

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
 * <p>
 * Trigger_LifeGained class.
 * </p>
 * 
 * @author Forge
 */
public class TriggerPayLife extends Trigger {

    /**
     * <p>
     * Constructor for TriggerPayLife.
     * </p>
     * 
     * @param params
     *            a {@link java.util.Map} object.
     * @param host
     *            a {@link forge.game.card.Card} object.
     * @param intrinsic
     *            the intrinsic
     */
    public TriggerPayLife(final Map<String, String> params, final Card host, final boolean intrinsic) {
        super(params, host, intrinsic);
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

    /** {@inheritDoc} */
    @Override
    public final void setTriggeringObjects(final SpellAbility sa, Map<AbilityKey, Object> runParams) {
        sa.setTriggeringObjectsFrom(runParams, AbilityKey.LifeAmount, AbilityKey.Player);
    }

    @Override
    public String getImportantStackObjects(SpellAbility sa) {
        StringBuilder sb = new StringBuilder();
        sb.append(Localizer.getInstance().getMessage("lblPlayer")).append(": ").append(sa.getTriggeringObject(AbilityKey.Player)).append(", ");
        sb.append(Localizer.getInstance().getMessage("lblPaidAmount")).append(": ").append(sa.getTriggeringObject(AbilityKey.LifeAmount));
        return sb.toString();
    }
}
```

## Python
`forge/game/trigger/TriggerPayLife.py`

```python
from forge.game.trigger.Trigger import Trigger
from forge.game.ability.AbilityKey import AbilityKey
from forge.game.card.Card import Card
from forge.game.spellability.SpellAbility import SpellAbility
from forge.util.Localizer import Localizer


class TriggerPayLife(Trigger):

    def __init__(self, params: dict[str, str], host: Card, intrinsic: bool):
        super().__init__(params, host, intrinsic)

    def performTest(self, runParams: dict[AbilityKey, object]) -> bool:
        if not self.matchesValidParam("ValidPlayer", runParams.get(AbilityKey.Player)):
            return False

        return True

    def setTriggeringObjects(self, sa: SpellAbility, runParams: dict[AbilityKey, object]) -> None:
        sa.setTriggeringObjectsFrom(runParams, AbilityKey.LifeAmount, AbilityKey.Player)

    def getImportantStackObjects(self, sa: SpellAbility) -> str:
        sb = []
        sb.append(Localizer.getInstance().getMessage("lblPlayer"))
        sb.append(": ")
        sb.append(str(sa.getTriggeringObject(AbilityKey.Player)))
        sb.append(", ")
        sb.append(Localizer.getInstance().getMessage("lblPaidAmount"))
        sb.append(": ")
        sb.append(str(sa.getTriggeringObject(AbilityKey.LifeAmount)))
        return "".join(sb)
```
