---
aliases:
  - TriggerPayCumulativeUpkeep
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/trigger
fqn: forge.game.trigger.TriggerPayCumulativeUpkeep
package: forge.game.trigger
module: forge-game
kind: Class
---

# TriggerPayCumulativeUpkeep

**Package:** `forge.game.trigger` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class TriggerPayCumulativeUpkeep {
        +performTest(Map~AbilityKey,Object~ runParams) boolean
        +setTriggeringObjects(SpellAbility sa, Map~AbilityKey,Object~ runParams) void
        +getImportantStackObjects(SpellAbility sa) String
        +TriggerPayCumulativeUpkeep(Map~String,String~ params, Card host, boolean intrinsic)
    }
    TriggerPayCumulativeUpkeep --|> Trigger : extends
    TriggerPayCumulativeUpkeep ..> AbilityKey : uses
    TriggerPayCumulativeUpkeep ..> Card : uses
    TriggerPayCumulativeUpkeep ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.trigger.Trigger|Trigger]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

TriggerPayCumulativeUpkeep is a concrete trigger type that fires in response to cumulative upkeep payment events. Extending the abstract Trigger base class, it overrides the standard trigger lifecycle hooks: performTest evaluates whether the event matches the trigger's conditionsâ€”optionally gating on whether the upkeep was actually paid (via the "Paid" parameter XORed against the CumulativeUpkeepPaid run parameter) and on a ValidCard restrictionâ€”while setTriggeringObjects exposes the relevant Card and PayingMana to the resulting SpellAbility. It collaborates with AbilityKey to read typed values from the run-parameter map and with Card for host context. getImportantStackObjects produces a localized, human-readable summary of the mana paid for stack display. The design follows the engine's data-driven trigger pattern, deriving all behavior from card-script parameters rather than hardcoded logic.

## Source
`forge-game/src/main/java/forge/game/trigger/TriggerPayCumulativeUpkeep.java`

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
 * @version $Id: TriggerLifeGained.java 17802 2012-10-31 08:05:14Z Max mtg $
 */
public class TriggerPayCumulativeUpkeep extends Trigger {

    /**
     * <p>
     * Constructor for Trigger_LifeGained.
     * </p>
     * 
     * @param params
     *            a {@link java.util.HashMap} object.
     * @param host
     *            a {@link forge.game.card.Card} object.
     * @param intrinsic
     *            the intrinsic
     */
    public TriggerPayCumulativeUpkeep(final Map<String, String> params, final Card host, final boolean intrinsic) {
        super(params, host, intrinsic);
    }

    /** {@inheritDoc}
     * @param runParams*/
    @Override
    public final boolean performTest(final Map<AbilityKey, Object> runParams) {
        if (hasParam("Paid")) {
            Boolean paid = (Boolean) runParams.get(AbilityKey.CumulativeUpkeepPaid);
            if (getParam("Paid").equals("True") ^ paid) {
                return false;
            }
        }
        if (!matchesValidParam("ValidCard", runParams.get(AbilityKey.Card))) {
            return false;
        }

        return true;
    }

    /** {@inheritDoc} */
    @Override
    public final void setTriggeringObjects(final SpellAbility sa, Map<AbilityKey, Object> runParams) {
        sa.setTriggeringObjectsFrom(runParams, AbilityKey.Card, AbilityKey.PayingMana);
    }

    @Override
    public String getImportantStackObjects(SpellAbility sa) {
        StringBuilder sb = new StringBuilder();
        sb.append(Localizer.getInstance().getMessage("lblMana")).append(": ").append(sa.getTriggeringObject(AbilityKey.PayingMana));
        return sb.toString();
    }
}
```

## Python
`forge/game/trigger/TriggerPayCumulativeUpkeep.py`

```python
from forge.game.trigger.Trigger import Trigger
from forge.game.ability.AbilityKey import AbilityKey
from forge.game.card.Card import Card
from forge.game.spellability.SpellAbility import SpellAbility
from forge.util.Localizer import Localizer


class TriggerPayCumulativeUpkeep(Trigger):

    def __init__(self, params: dict[str, str], host: Card, intrinsic: bool):
        super().__init__(params, host, intrinsic)

    def performTest(self, runParams: dict[AbilityKey, object]) -> bool:
        if self.hasParam("Paid"):
            paid = runParams.get(AbilityKey.CumulativeUpkeepPaid)
            if (self.getParam("Paid") == "True") ^ paid:
                return False
        if not self.matchesValidParam("ValidCard", runParams.get(AbilityKey.Card)):
            return False

        return True

    def setTriggeringObjects(self, sa: SpellAbility, runParams: dict[AbilityKey, object]) -> None:
        sa.setTriggeringObjectsFrom(runParams, AbilityKey.Card, AbilityKey.PayingMana)

    def getImportantStackObjects(self, sa: SpellAbility) -> str:
        sb = []
        sb.append(Localizer.getInstance().getMessage("lblMana"))
        sb.append(": ")
        sb.append(str(sa.getTriggeringObject(AbilityKey.PayingMana)))
        return "".join(sb)
```
