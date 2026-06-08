---
aliases:
  - TriggerManaExpend
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/trigger
fqn: forge.game.trigger.TriggerManaExpend
package: forge.game.trigger
module: forge-game
kind: Class
---

# TriggerManaExpend

**Package:** `forge.game.trigger` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class TriggerManaExpend {
        +performTest(Map~AbilityKey,Object~ runParams) boolean
        +setTriggeringObjects(SpellAbility sa, Map~AbilityKey,Object~ runParams) void
        +getImportantStackObjects(SpellAbility sa) String
        +TriggerManaExpend(Map~String,String~ params, Card host, boolean intrinsic)
    }
    TriggerManaExpend --|> Trigger : extends
    TriggerManaExpend ..> AbilityKey : uses
    TriggerManaExpend ..> Card : uses
    TriggerManaExpend ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.trigger.Trigger|Trigger]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Source
`forge-game/src/main/java/forge/game/trigger/TriggerManaExpend.java`

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

import forge.game.ability.AbilityKey;
import forge.game.card.Card;
import forge.game.spellability.SpellAbility;

import java.util.Map;

/**
 * <p>
 * TriggerManaExpend class.
 * </p>
 *
 * @author Forge
 * @version $Id$
 */
public class TriggerManaExpend extends Trigger {
    public TriggerManaExpend(final Map<String, String> params, final Card host, final boolean intrinsic) {
        super(params, host, intrinsic);
    }

    /** {@inheritDoc}
     * @param runParams*/
    @Override
    public final boolean performTest(final Map<AbilityKey, Object> runParams) {
        if (!matchesValidParam("Player", runParams.get(AbilityKey.Player))) {
            return false;
        }

        int targetAmount = Integer.parseInt(mapParams.get("Amount"));
        int actualAmount = (int) runParams.get(AbilityKey.Amount);
        return targetAmount == actualAmount;
    }

    /** {@inheritDoc} */
    @Override
    public final void setTriggeringObjects(final SpellAbility sa, Map<AbilityKey, Object> runParams) {
        sa.setTriggeringObjectsFrom(runParams, AbilityKey.Amount, AbilityKey.Player);
    }

    @Override
    public String getImportantStackObjects(SpellAbility sa) {
        return sa.getTriggeringObject(AbilityKey.Player) + " expended " + sa.getTriggeringObject(AbilityKey.Amount) + " mana";
    }
}
```
