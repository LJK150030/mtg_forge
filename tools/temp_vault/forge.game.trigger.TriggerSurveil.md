---
aliases:
  - TriggerSurveil
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/trigger
fqn: forge.game.trigger.TriggerSurveil
package: forge.game.trigger
module: forge-game
kind: Class
---

# TriggerSurveil

**Package:** `forge.game.trigger` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class TriggerSurveil {
        +getImportantStackObjects(SpellAbility sa) String
        +setTriggeringObjects(SpellAbility sa, Map~AbilityKey,Object~ runParams) void
        +performTest(Map~AbilityKey,Object~ runParams) boolean
        +TriggerSurveil(Map~String,String~ params, Card host, boolean intrinsic)
    }
    TriggerSurveil --|> Trigger : extends
    TriggerSurveil ..> AbilityKey : uses
    TriggerSurveil ..> Card : uses
    TriggerSurveil ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.trigger.Trigger|Trigger]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

TriggerSurveil is a concrete trigger that fires in response to a surveil event, extending the abstract `Trigger` base class to plug into Forge's event-driven triggered-ability system. It specializes the framework for surveil by binding the surveilling `Player` as the triggering object, gating activation through `performTest` (honoring optional `ValidPlayer` and `FirstTime` constraints), and rendering a localized stack description.

Its responsibilities stay narrow: it collaborates with `SpellAbility` to set and read triggering objects keyed by `AbilityKey`, and takes its host `Card` and parameter map through the constructor to the superclass. Marking `setTriggeringObjects` and `performTest` as `final` signals these override points are fixed, and the use of `Localizer` reflects deliberate support for internationalized UI text, keeping all surveil-specific logic isolated from the generic trigger machinery.

## Source
`forge-game/src/main/java/forge/game/trigger/TriggerSurveil.java`

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
 * 
 * @author Forge
 */
public class TriggerSurveil extends Trigger {

    /**
     * <p>
     * Constructor for TriggerSurveil
     * </p>
     * 
     * @param params
     *            a {@link java.util.Map} object.
     * @param host
     *            a {@link forge.game.card.Card} object.
     * @param intrinsic
     *            the intrinsic
     */
    public TriggerSurveil(final Map<String, String> params, final Card host, final boolean intrinsic) {
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

        if (hasParam("FirstTime")) {
            if (!(boolean) runParams.get(AbilityKey.FirstTime)) {
                return false;
            }
        }

        return true;
    }

}
```

## Python
`forge/game/trigger/TriggerSurveil.py`

```python
package forge.game.trigger

from typing import Map

from forge.game.trigger.Trigger import Trigger
from forge.game.ability.AbilityKey import AbilityKey
from forge.game.card.Card import Card
from forge.game.spellability.SpellAbility import SpellAbility
from forge.util.Localizer import Localizer


class TriggerSurveil(Trigger):
    """
    @author Forge
    """

    def __init__(self, params: dict[str, str], host: Card, intrinsic: bool):
        """
        Constructor for TriggerSurveil

        :param params: a Map object.
        :param host: a Card object.
        :param intrinsic: the intrinsic
        """
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

        if self.hasParam("FirstTime"):
            if not bool(runParams.get(AbilityKey.FirstTime)):
                return False

        return True
```
