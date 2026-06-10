---
aliases:
  - TriggerTokenCreated
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/trigger
fqn: forge.game.trigger.TriggerTokenCreated
package: forge.game.trigger
module: forge-game
kind: Class
---

# TriggerTokenCreated

**Package:** `forge.game.trigger` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class TriggerTokenCreated {
        +getImportantStackObjects(SpellAbility sa) String
        +setTriggeringObjects(SpellAbility sa, Map~AbilityKey,Object~ runParams) void
        +performTest(Map~AbilityKey,Object~ runParams) boolean
        +TriggerTokenCreated(Map~String,String~ params, Card host, boolean intrinsic)
    }
    TriggerTokenCreated --|> Trigger : extends
    TriggerTokenCreated ..> AbilityKey : uses
    TriggerTokenCreated ..> Card : uses
    TriggerTokenCreated ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.trigger.Trigger|Trigger]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

TriggerTokenCreated is a concrete trigger that fires when one or more tokens are created, responding to the game's token-creation event. As a subclass of Trigger, it implements the framework's template methods: performTest gates activation by validating the creating player (ValidPlayer), the created token (ValidToken), and an optional OnlyFirst condition that restricts firing to single-token events via the Num parameter; setTriggeringObjects exposes the Player and Card to the resolving SpellAbility through AbilityKey-keyed run parameters; and getImportantStackObjects supplies a localized stack description.

It collaborates with Card as its host, SpellAbility as the triggered effect, and AbilityKey as the typed event-data vocabulary. The design follows Forge's data-driven trigger patternâ€”behavior is configured by string params rather than subclass logicâ€”keeping this class a thin, declarative adapter between a raw game event and the engine's ability-resolution machinery.

## Source
`forge-game/src/main/java/forge/game/trigger/TriggerTokenCreated.java`

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
 * Trigger_LandPlayed class.
 * </p>
 *
 * @author Forge
 * @version $Id: TriggerInvestigated.java 30294 2015-10-16 01:53:32Z friarsol $
 */
public class TriggerTokenCreated extends Trigger {

    /**
     * <p>
     * Constructor for Trigger_Investigated.
     * </p>
     *
     * @param params
     *            a {@link java.util.HashMap} object.
     * @param host
     *            a {@link forge.game.card.Card} object.
     * @param intrinsic
     *            the intrinsic
     */
    public TriggerTokenCreated(final Map<String, String> params, final Card host, final boolean intrinsic) {
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
        sa.setTriggeringObjectsFrom(runParams, AbilityKey.Player, AbilityKey.Card);
    }

    /** {@inheritDoc}
     * @param runParams*/
    @Override
    public final boolean performTest(final Map<AbilityKey, Object> runParams) {
        if (!matchesValidParam("ValidPlayer", runParams.get(AbilityKey.Player))) {
            return false;
        }

        if (!matchesValidParam("ValidToken", runParams.get(AbilityKey.Card))) {
            return false;
        }

        if (hasParam("OnlyFirst")) {
            if ((int) runParams.get(AbilityKey.Num) != 1) {
                return false;
            }
        }
        return true;
    }

}
```

## Python
`forge/game/trigger/TriggerTokenCreated.py`

```python
from forge.game.trigger.Trigger import Trigger
from forge.game.ability.AbilityKey import AbilityKey
from forge.game.card.Card import Card
from forge.game.spellability.SpellAbility import SpellAbility
from forge.util.Localizer import Localizer

from typing import Map


class TriggerTokenCreated(Trigger):

    def __init__(self, params: dict[str, str], host: Card, intrinsic: bool):
        super().__init__(params, host, intrinsic)

    def getImportantStackObjects(self, sa: SpellAbility) -> str:
        sb = []
        sb.append(Localizer.getInstance().getMessage("lblPlayer"))
        sb.append(": ")
        sb.append(str(sa.getTriggeringObject(AbilityKey.Player)))
        return "".join(sb)

    def setTriggeringObjects(self, sa: SpellAbility, runParams: dict[AbilityKey, object]) -> None:
        sa.setTriggeringObjectsFrom(runParams, AbilityKey.Player, AbilityKey.Card)

    def performTest(self, runParams: dict[AbilityKey, object]) -> bool:
        if not self.matchesValidParam("ValidPlayer", runParams.get(AbilityKey.Player)):
            return False

        if not self.matchesValidParam("ValidToken", runParams.get(AbilityKey.Card)):
            return False

        if self.hasParam("OnlyFirst"):
            if int(runParams.get(AbilityKey.Num)) != 1:
                return False
        return True
```
