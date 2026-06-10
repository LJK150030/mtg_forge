---
aliases:
  - TriggerAttackerUnblockedOnce
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/trigger
fqn: forge.game.trigger.TriggerAttackerUnblockedOnce
package: forge.game.trigger
module: forge-game
kind: Class
---

# TriggerAttackerUnblockedOnce

**Package:** `forge.game.trigger` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class TriggerAttackerUnblockedOnce {
        +performTest(Map~AbilityKey,Object~ runParams) boolean
        +setTriggeringObjects(SpellAbility sa, Map~AbilityKey,Object~ runParams) void
        +getImportantStackObjects(SpellAbility sa) String
        +TriggerAttackerUnblockedOnce(Map~String,String~ params, Card host, boolean intrinsic)
    }
    TriggerAttackerUnblockedOnce --|> Trigger : extends
    TriggerAttackerUnblockedOnce ..> AbilityKey : uses
    TriggerAttackerUnblockedOnce ..> Card : uses
    TriggerAttackerUnblockedOnce ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.trigger.Trigger|Trigger]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

TriggerAttackerUnblockedOnce is a concrete trigger that fires when an attacking creature goes unblocked, encapsulating the matching and event-binding logic for that combat condition. As a subclass of Trigger, it overrides `performTest` to gate firing on the optional `ValidDefenders` and `ValidAttackingPlayer` parameters, and `setTriggeringObjects` to expose the attacking player and defenders to the resulting SpellAbility through AbilityKey-keyed run parameters.

Its design follows the engine's data-driven trigger pattern: behavior is configured from a string parameter map and a host Card supplied at construction, while AbilityKey provides a typed vocabulary for combat state. The overridden `getImportantStackObjects` builds a localized, human-readable summary of the attacking player and defenders for stack display, keeping presentation concerns within the trigger and delegating validation to the inherited `matchesValidParam` helper.

## Source
`forge-game/src/main/java/forge/game/trigger/TriggerAttackerUnblockedOnce.java`

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
 * Trigger_AttackerUnblockedOnce class.
 * </p>
 * 
 * @author Forge
 * @version $Id$
 */
public class TriggerAttackerUnblockedOnce extends Trigger {

    /**
     * <p>
     * Constructor for Trigger_AttackerUnblocked.
     * </p>
     * 
     * @param params
     *            a {@link java.util.HashMap} object.
     * @param host
     *            a {@link forge.game.card.Card} object.
     * @param intrinsic
     *            the intrinsic
     */
    public TriggerAttackerUnblockedOnce(final Map<String, String> params, final Card host, final boolean intrinsic) {
        super(params, host, intrinsic);
    }

    /** {@inheritDoc}
     * @param runParams*/
    @Override
    public final boolean performTest(final Map<AbilityKey, Object> runParams) {
        if (!matchesValidParam("ValidDefenders", runParams.get(AbilityKey.Defenders))) {
            return false;
        }
        if (!matchesValidParam("ValidAttackingPlayer", runParams.get(AbilityKey.AttackingPlayer))) {
            return false;
        }
        return true;
    }

    /** {@inheritDoc} */
    @Override
    public final void setTriggeringObjects(final SpellAbility sa, Map<AbilityKey, Object> runParams) {
        sa.setTriggeringObjectsFrom(runParams, AbilityKey.AttackingPlayer, AbilityKey.Defenders);
    }

    @Override
    public String getImportantStackObjects(SpellAbility sa) {
        StringBuilder sb = new StringBuilder();
        sb.append(Localizer.getInstance().getMessage("lblAttackingPlayer")).append(": ").append(sa.getTriggeringObject(AbilityKey.AttackingPlayer));
        sb.append(Localizer.getInstance().getMessage("lblDefenders")).append(": ").append(sa.getTriggeringObject(AbilityKey.Defenders));
        return sb.toString();
    }
}
```

## Python
`forge/game/trigger/TriggerAttackerUnblockedOnce.py`

```python
from typing import Map  # placeholder removed below

from forge.game.ability.AbilityKey import AbilityKey
from forge.game.card.Card import Card
from forge.game.spellability.SpellAbility import SpellAbility
from forge.game.trigger.Trigger import Trigger
from forge.util.Localizer import Localizer


class TriggerAttackerUnblockedOnce(Trigger):
    def __init__(self, params: dict[str, str], host: Card, intrinsic: bool):
        super().__init__(params, host, intrinsic)

    def performTest(self, runParams: dict[AbilityKey, object]) -> bool:
        if not self.matchesValidParam("ValidDefenders", runParams.get(AbilityKey.Defenders)):
            return False
        if not self.matchesValidParam("ValidAttackingPlayer", runParams.get(AbilityKey.AttackingPlayer)):
            return False
        return True

    def setTriggeringObjects(self, sa: SpellAbility, runParams: dict[AbilityKey, object]) -> None:
        sa.setTriggeringObjectsFrom(runParams, AbilityKey.AttackingPlayer, AbilityKey.Defenders)

    def getImportantStackObjects(self, sa: SpellAbility) -> str:
        sb = []
        sb.append(Localizer.getInstance().getMessage("lblAttackingPlayer"))
        sb.append(": ")
        sb.append(str(sa.getTriggeringObject(AbilityKey.AttackingPlayer)))
        sb.append(Localizer.getInstance().getMessage("lblDefenders"))
        sb.append(": ")
        sb.append(str(sa.getTriggeringObject(AbilityKey.Defenders)))
        return "".join(sb)
```
