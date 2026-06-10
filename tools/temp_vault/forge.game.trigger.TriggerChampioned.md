---
aliases:
  - TriggerChampioned
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/trigger
fqn: forge.game.trigger.TriggerChampioned
package: forge.game.trigger
module: forge-game
kind: Class
---

# TriggerChampioned

**Package:** `forge.game.trigger` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class TriggerChampioned {
        +performTest(Map~AbilityKey,Object~ runParams) boolean
        +setTriggeringObjects(SpellAbility sa, Map~AbilityKey,Object~ runParams) void
        +getImportantStackObjects(SpellAbility sa) String
        +TriggerChampioned(Map~String,String~ params, Card host, boolean intrinsic)
    }
    TriggerChampioned --|> Trigger : extends
    TriggerChampioned ..> AbilityKey : uses
    TriggerChampioned ..> Card : uses
    TriggerChampioned ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.trigger.Trigger|Trigger]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

TriggerChampioned is a concrete trigger that fires when a creature is championed (the keyword mechanic where a creature exiles another creature as it enters). Extending the abstract Trigger base class, it specializes the inherited event-handling contract by overriding `performTest` to gate firing on the `ValidCard` (the championed creature) and `ValidSource` (the championing card) parameters, and `setTriggeringObjects` to expose those objects to the resolving SpellAbility via AbilityKey-keyed run parameters. It collaborates with Card (its host), SpellAbility (the triggered ability it populates), and AbilityKey (the typed keys, notably `Championed` and `Card`, used to read and bind triggering objects). The override of `getImportantStackObjects` builds a localized, human-readable stack description, reflecting the engine's intent to keep trigger subclasses thin, data-driven matchers while delegating shared lifecycle logic to the superclass.

## Source
`forge-game/src/main/java/forge/game/trigger/TriggerChampioned.java`

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
 * Trigger_Championed class.
 * </p>
 * 
 * @author Forge
 * @version $Id$
 * @since 1.0.15
 */
public class TriggerChampioned extends Trigger {

    /**
     * <p>
     * Constructor for Trigger_Championed.
     * </p>
     * 
     * @param params
     *            a {@link java.util.HashMap} object.
     * @param host
     *            a {@link forge.game.card.Card} object.
     * @param intrinsic
     *            the intrinsic
     */
    public TriggerChampioned(final Map<String, String> params, final Card host, final boolean intrinsic) {
        super(params, host, intrinsic);
    }

    /** {@inheritDoc}
     * @param runParams*/
    @Override
    public final boolean performTest(final Map<AbilityKey, Object> runParams) {
        if (!matchesValidParam("ValidCard", runParams.get(AbilityKey.Championed))) {
            return false;
        }

        if (!matchesValidParam("ValidSource", runParams.get(AbilityKey.Card))) {
            return false;
        }

        return true;
    }

    /** {@inheritDoc} */
    @Override
    public final void setTriggeringObjects(final SpellAbility sa, Map<AbilityKey, Object> runParams) {
        sa.setTriggeringObjectsFrom(runParams, AbilityKey.Championed, AbilityKey.Card);
    }

    @Override
    public String getImportantStackObjects(SpellAbility sa) {
        StringBuilder sb = new StringBuilder();
        sb.append(Localizer.getInstance().getMessage("lblChampioned")).append(": ").append(sa.getTriggeringObject(AbilityKey.Championed));
        return sb.toString();
    }
}
```

## Python
`forge/game/trigger/TriggerChampioned.py`

```python
from forge.game.trigger.Trigger import Trigger
from forge.game.ability.AbilityKey import AbilityKey
from forge.game.card.Card import Card
from forge.game.spellability.SpellAbility import SpellAbility
from forge.util.Localizer import Localizer


class TriggerChampioned(Trigger):
    def __init__(self, params: dict[str, str], host: Card, intrinsic: bool):
        super().__init__(params, host, intrinsic)

    def performTest(self, runParams: dict[AbilityKey, object]) -> bool:
        if not self.matchesValidParam("ValidCard", runParams.get(AbilityKey.Championed)):
            return False

        if not self.matchesValidParam("ValidSource", runParams.get(AbilityKey.Card)):
            return False

        return True

    def setTriggeringObjects(self, sa: SpellAbility, runParams: dict[AbilityKey, object]) -> None:
        sa.setTriggeringObjectsFrom(runParams, AbilityKey.Championed, AbilityKey.Card)

    def getImportantStackObjects(self, sa: SpellAbility) -> str:
        sb = []
        sb.append(Localizer.getInstance().getMessage("lblChampioned"))
        sb.append(": ")
        sb.append(str(sa.getTriggeringObject(AbilityKey.Championed)))
        return "".join(sb)
```
