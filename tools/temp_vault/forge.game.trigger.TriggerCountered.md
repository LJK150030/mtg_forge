---
aliases:
  - TriggerCountered
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/trigger
fqn: forge.game.trigger.TriggerCountered
package: forge.game.trigger
module: forge-game
kind: Class
---

# TriggerCountered

**Package:** `forge.game.trigger` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class TriggerCountered {
        +performTest(Map~AbilityKey,Object~ runParams) boolean
        +setTriggeringObjects(SpellAbility sa, Map~AbilityKey,Object~ runParams) void
        +getImportantStackObjects(SpellAbility sa) String
        +TriggerCountered(Map~String,String~ params, Card host, boolean intrinsic)
    }
    TriggerCountered --|> Trigger : extends
    TriggerCountered ..> AbilityKey : uses
    TriggerCountered ..> Card : uses
    TriggerCountered ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.trigger.Trigger|Trigger]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

TriggerCountered is a concrete trigger that fires when a spell or ability is countered. Extending the abstract `Trigger` base class, it specializes the template by implementing `performTest` to gate firing against the trigger's configured `ValidCard`, `ValidCause`, and `ValidSA` parameters, and `setTriggeringObjects` to bind the corresponding `Card`, `Cause`, and `SpellAbility` values from the runtime parameter map onto the firing `SpellAbility`. It identifies the relevant objects through the type-safe `AbilityKey` enum rather than raw string keys, and is constructed from a parameter map alongside a host `Card` and an intrinsic flag.

The class reflects Forge's data-driven trigger design, where each subclass supplies only the matching and binding logic specific to one game event while inheriting the firing lifecycle from `Trigger`. Its `getImportantStackObjects` override builds a localized, human-readable summary of the countered card and its cause via `Localizer`, keeping presentation strings out of the engine core and supporting internationalization.

## Source
`forge-game/src/main/java/forge/game/trigger/TriggerCountered.java`

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
 * Trigger_Countered class.
 * </p>
 * 
 * @author Forge
 * @version $Id: TriggerCountered.java 17802 2012-10-31 08:05:14Z Max mtg $
 */
public class TriggerCountered extends Trigger {

    /**
     * <p>
     * Constructor for Trigger_Countered.
     * </p>
     * 
     * @param params
     *            a {@link java.util.HashMap} object.
     * @param host
     *            a {@link forge.game.card.Card} object.
     * @param intrinsic
     *            the intrinsic
     */
    public TriggerCountered(final Map<String, String> params, final Card host, final boolean intrinsic) {
        super(params, host, intrinsic);
    }

    /** {@inheritDoc}
     * @param runParams*/
    @Override
    public final boolean performTest(final Map<AbilityKey, Object> runParams) {
        if (!matchesValidParam("ValidCard", runParams.get(AbilityKey.Card))) {
            return false;
        }
        if (!matchesValidParam("ValidCause", runParams.get(AbilityKey.Cause))) {
            return false;
        }
        if (!matchesValidParam("ValidSA", runParams.get(AbilityKey.SpellAbility))) {
            return false;
        }
        return true;
    }

    /** {@inheritDoc} */
    @Override
    public final void setTriggeringObjects(final SpellAbility sa, Map<AbilityKey, Object> runParams) {
        sa.setTriggeringObjectsFrom(
            runParams,
            AbilityKey.Card,
            AbilityKey.Cause,
            AbilityKey.SpellAbility
        );
    }

    @Override
    public String getImportantStackObjects(SpellAbility sa) {
        StringBuilder sb = new StringBuilder();
        sb.append(Localizer.getInstance().getMessage("lblCountered")).append(": ").append(sa.getTriggeringObject(AbilityKey.Card)).append(", ");
        sb.append(Localizer.getInstance().getMessage("lblCause")).append(": ").append(sa.getTriggeringObject(AbilityKey.Cause));
        return sb.toString();
    }
}
```

## Python
`forge/game/trigger/TriggerCountered.py`

```python
from forge.game.trigger.Trigger import Trigger
from forge.game.ability.AbilityKey import AbilityKey
from forge.game.card.Card import Card
from forge.game.spellability.SpellAbility import SpellAbility
from forge.util.Localizer import Localizer


class TriggerCountered(Trigger):
    """
    Trigger_Countered class.

    @author Forge
    @version $Id: TriggerCountered.java 17802 2012-10-31 08:05:14Z Max mtg $
    """

    def __init__(self, params: dict[str, str], host: Card, intrinsic: bool):
        super().__init__(params, host, intrinsic)

    def performTest(self, runParams: dict[AbilityKey, object]) -> bool:
        if not self.matchesValidParam("ValidCard", runParams.get(AbilityKey.Card)):
            return False
        if not self.matchesValidParam("ValidCause", runParams.get(AbilityKey.Cause)):
            return False
        if not self.matchesValidParam("ValidSA", runParams.get(AbilityKey.SpellAbility)):
            return False
        return True

    def setTriggeringObjects(self, sa: SpellAbility, runParams: dict[AbilityKey, object]) -> None:
        sa.setTriggeringObjectsFrom(
            runParams,
            AbilityKey.Card,
            AbilityKey.Cause,
            AbilityKey.SpellAbility
        )

    def getImportantStackObjects(self, sa: SpellAbility) -> str:
        sb = []
        sb.append(Localizer.getInstance().getMessage("lblCountered"))
        sb.append(": ")
        sb.append(str(sa.getTriggeringObject(AbilityKey.Card)))
        sb.append(", ")
        sb.append(Localizer.getInstance().getMessage("lblCause"))
        sb.append(": ")
        sb.append(str(sa.getTriggeringObject(AbilityKey.Cause)))
        return "".join(sb)
```
