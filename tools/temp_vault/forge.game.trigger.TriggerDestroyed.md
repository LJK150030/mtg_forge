---
aliases:
  - TriggerDestroyed
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/trigger
fqn: forge.game.trigger.TriggerDestroyed
package: forge.game.trigger
module: forge-game
kind: Class
---

# TriggerDestroyed

**Package:** `forge.game.trigger` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class TriggerDestroyed {
        +performTest(Map~AbilityKey,Object~ runParams) boolean
        +setTriggeringObjects(SpellAbility sa, Map~AbilityKey,Object~ runParams) void
        +getImportantStackObjects(SpellAbility sa) String
        +TriggerDestroyed(Map~String,String~ params, Card host, boolean intrinsic)
    }
    TriggerDestroyed --|> Trigger : extends
    TriggerDestroyed ..> AbilityKey : uses
    TriggerDestroyed ..> Card : uses
    TriggerDestroyed ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.trigger.Trigger|Trigger]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

Trigger fired when one or more permanents are destroyed. As a concrete subclass of `Trigger`, it specializes the trigger framework's template-method contract: `performTest` gates firing by matching the configured `ValidCauser` and `ValidCard` parameters against the destroyed card and its destroyer, while `setTriggeringObjects` binds the `Card` and `Causer` from the run parameters onto the resolving `SpellAbility`. It collaborates with `AbilityKey` to look up triggering data in the run-parameter map, `Card` as the trigger host, and `SpellAbility` as the ability it populates. `getImportantStackObjects` produces a localized stack summary naming the destroyed permanent and its destroyer, reflecting a design intent of data-driven, parameter-keyed trigger conditions consistent with Forge's broader trigger hierarchy.

## Source
`forge-game/src/main/java/forge/game/trigger/TriggerDestroyed.java`

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
 * Trigger_Destroyed class.
 * </p>
 * 
 * @author Forge
 * @version $Id: TriggerDestroyed.java 17802 2012-10-31 08:05:14Z Max mtg $
 */
public class TriggerDestroyed extends Trigger {

    /**
     * <p>
     * Constructor for Trigger_Destroyed.
     * </p>
     * 
     * @param params
     *            a {@link java.util.HashMap} object.
     * @param host
     *            a {@link forge.game.card.Card} object.
     * @param intrinsic
     *            the intrinsic
     */
    public TriggerDestroyed(final Map<String, String> params, final Card host, final boolean intrinsic) {
        super(params, host, intrinsic);
    }

    /** {@inheritDoc}
     * @param runParams*/
    @Override
    public final boolean performTest(final Map<AbilityKey, Object> runParams) {
        if (!matchesValidParam("ValidCauser", runParams.get(AbilityKey.Causer))) {
            return false;
        }
        if (!matchesValidParam("ValidCard", runParams.get(AbilityKey.Card))) {
            return false;
        }
        return true;
    }

    /** {@inheritDoc} */
    @Override
    public final void setTriggeringObjects(final SpellAbility sa, Map<AbilityKey, Object> runParams) {
        sa.setTriggeringObjectsFrom(runParams, AbilityKey.Card, AbilityKey.Causer);
    }

    @Override
    public String getImportantStackObjects(SpellAbility sa) {
        StringBuilder sb = new StringBuilder();
        sb.append(Localizer.getInstance().getMessage("lblDestroyed")).append(": ").append(sa.getTriggeringObject(AbilityKey.Card)).append(", ");
        sb.append(Localizer.getInstance().getMessage("lblDestroyer")).append(": ").append(sa.getTriggeringObject(AbilityKey.Causer));
        return sb.toString();
    }
}
```

## Python
`forge/game/trigger/TriggerDestroyed.py`

```python
from forge.game.trigger.Trigger import Trigger
from forge.game.ability.AbilityKey import AbilityKey
from forge.game.card.Card import Card
from forge.game.spellability.SpellAbility import SpellAbility
from forge.util.Localizer import Localizer


class TriggerDestroyed(Trigger):
    """
    Trigger_Destroyed class.

    @author Forge
    @version $Id: TriggerDestroyed.java 17802 2012-10-31 08:05:14Z Max mtg $
    """

    def __init__(self, params: dict[str, str], host: Card, intrinsic: bool):
        super().__init__(params, host, intrinsic)

    def performTest(self, runParams: dict[AbilityKey, object]) -> bool:
        if not self.matchesValidParam("ValidCauser", runParams.get(AbilityKey.Causer)):
            return False
        if not self.matchesValidParam("ValidCard", runParams.get(AbilityKey.Card)):
            return False
        return True

    def setTriggeringObjects(self, sa: SpellAbility, runParams: dict[AbilityKey, object]) -> None:
        sa.setTriggeringObjectsFrom(runParams, AbilityKey.Card, AbilityKey.Causer)

    def getImportantStackObjects(self, sa: SpellAbility) -> str:
        sb = []
        sb.append(Localizer.getInstance().getMessage("lblDestroyed"))
        sb.append(": ")
        sb.append(str(sa.getTriggeringObject(AbilityKey.Card)))
        sb.append(", ")
        sb.append(Localizer.getInstance().getMessage("lblDestroyer"))
        sb.append(": ")
        sb.append(str(sa.getTriggeringObject(AbilityKey.Causer)))
        return "".join(sb)
```
