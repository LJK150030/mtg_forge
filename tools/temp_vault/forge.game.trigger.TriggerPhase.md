---
aliases:
  - TriggerPhase
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/trigger
fqn: forge.game.trigger.TriggerPhase
package: forge.game.trigger
module: forge-game
kind: Class
---

# TriggerPhase

**Package:** `forge.game.trigger` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class TriggerPhase {
        +performTest(Map~AbilityKey,Object~ runParams) boolean
        +setTriggeringObjects(SpellAbility sa, Map~AbilityKey,Object~ runParams) void
        +getImportantStackObjects(SpellAbility sa) String
        +TriggerPhase(Map~String,String~ params, Card host, boolean intrinsic)
    }
    TriggerPhase --|> Trigger : extends
    TriggerPhase ..> AbilityKey : uses
    TriggerPhase ..> Card : uses
    TriggerPhase ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.trigger.Trigger|Trigger]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

TriggerPhase is a concrete trigger that fires in response to game phase changes, extending the abstract `Trigger` base class within Forge's event-driven triggered-ability system. Its responsibility is narrow: validate whether a phase event should fire by checking the `ValidPlayer` parameter against the active player, expose the triggering player to the resolving ability, and produce a human-readable description of the event for the stack.

To do this it collaborates with `AbilityKey`-keyed run-parameter maps, delegating triggering-object population to the `SpellAbility` via `setTriggeringObjectsFrom`, and constructs against a host `Card`. The design follows the template pattern established by `Trigger`: it overrides only `performTest`, `setTriggeringObjects`, and `getImportantStackObjects`, keeping per-trigger logic minimal and data-driven through the `params` map, while the localized stack description (`lblPhase`) reflects attention to internationalization.

## Source
`forge-game/src/main/java/forge/game/trigger/TriggerPhase.java`

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
 * Trigger_Phase class.
 * </p>
 * 
 * @author Forge
 * @version $Id$
 */
public class TriggerPhase extends Trigger {

    /**
     * <p>
     * Constructor for Trigger_Phase.
     * </p>
     * 
     * @param params
     *            a {@link java.util.HashMap} object.
     * @param host
     *            a {@link forge.game.card.Card} object.
     * @param intrinsic
     *            the intrinsic
     */
    public TriggerPhase(final Map<String, String> params, final Card host, final boolean intrinsic) {
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
        sa.setTriggeringObjectsFrom(runParams, AbilityKey.Player);
    }

    @Override
    public String getImportantStackObjects(SpellAbility sa) {
        StringBuilder sb = new StringBuilder();
        sb.append(Localizer.getInstance().getMessage("lblPhase")).append(": ").append(sa.getTriggeringObject(AbilityKey.Player));
        return sb.toString();
    }
}
```

## Python
`forge/game/trigger/TriggerPhase.py`

```python
package: forge.game.trigger

from typing import Map  # placeholder ΓÇö will not use this

Let me just write the file properly.

The output should be only Python source code.
```
