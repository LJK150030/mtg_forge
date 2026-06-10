---
aliases:
  - TriggerFlippedCoin
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/trigger
fqn: forge.game.trigger.TriggerFlippedCoin
package: forge.game.trigger
module: forge-game
kind: Class
---

# TriggerFlippedCoin

**Package:** `forge.game.trigger` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class TriggerFlippedCoin {
        +performTest(Map~AbilityKey,Object~ runParams) boolean
        +setTriggeringObjects(SpellAbility sa, Map~AbilityKey,Object~ runParams) void
        +getImportantStackObjects(SpellAbility sa) String
        +TriggerFlippedCoin(Map~String,String~ params, Card host, boolean intrinsic)
    }
    TriggerFlippedCoin --|> Trigger : extends
    TriggerFlippedCoin ..> AbilityKey : uses
    TriggerFlippedCoin ..> Card : uses
    TriggerFlippedCoin ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.trigger.Trigger|Trigger]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

TriggerFlippedCoin is a concrete trigger that fires when a player flips a coin, encapsulating the conditions under which a coin-flip event activates an associated ability. Extending the abstract Trigger base class, it overrides the standard trigger lifecycle hooks: performTest gates activation by validating the flipping player against the ValidPlayer parameter and, optionally, matching the flip outcome to a ValidResult ("Win"/loss) condition; setTriggeringObjects exposes the responsible Player to the firing SpellAbility; and getImportantStackObjects produces a localized stack description. It collaborates with AbilityKey to read run-time event parameters (Player, Result) from the supplied runParams map, with Card as its host, and with SpellAbility as the ability being triggered. The design follows the engine's data-driven trigger pattern, keeping all variability in string parameters so coin-flip cards are defined declaratively rather than in code.

## Source
`forge-game/src/main/java/forge/game/trigger/TriggerFlippedCoin.java`

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
 * Trigger_Flipped class.
 * </p>
 * 
 * @author Forge
 * @version $Id: TriggerFlipped.java 17802 2012-10-31 08:05:14Z Max mtg $
 */
public class TriggerFlippedCoin extends Trigger {

    /**
     * <p>
     * Constructor for Trigger_Flipped.
     * </p>
     * 
     * @param params
     *            a {@link java.util.HashMap} object.
     * @param host
     *            a {@link forge.game.card.Card} object.
     * @param intrinsic
     *            the intrinsic
     */
    public TriggerFlippedCoin(final Map<String, String> params, final Card host, final boolean intrinsic) {
        super(params, host, intrinsic);
    }

    /** {@inheritDoc}
     * @param runParams*/
    @Override
    public final boolean performTest(final Map<AbilityKey, Object> runParams) {
        if (!matchesValidParam("ValidPlayer", runParams.get(AbilityKey.Player))) {
            return false;
        }
        if (hasParam("ValidResult")) {
            final boolean result = (Boolean) runParams.get(AbilityKey.Result);
            final boolean valid = "Win".equals(getParam("ValidResult"));
            if (result ^ valid) {
                return false;
            }
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
        sb.append(Localizer.getInstance().getMessage("lblPlayer")).append(": ").append(sa.getTriggeringObject(AbilityKey.Player));
        return sb.toString();
    }
}
```

## Python
`forge/game/trigger/TriggerFlippedCoin.py`

```python
from forge.game.ability.AbilityKey import AbilityKey
from forge.game.card.Card import Card
from forge.game.spellability.SpellAbility import SpellAbility
from forge.util.Localizer import Localizer

from forge.game.trigger.Trigger import Trigger


class TriggerFlippedCoin(Trigger):
    """
    Trigger_Flipped class.

    @author Forge
    @version $Id: TriggerFlipped.java 17802 2012-10-31 08:05:14Z Max mtg $
    """

    def __init__(self, params: dict[str, str], host: Card, intrinsic: bool):
        """
        Constructor for Trigger_Flipped.

        @param params a HashMap object.
        @param host a Card object.
        @param intrinsic the intrinsic
        """
        super().__init__(params, host, intrinsic)

    def performTest(self, runParams: dict[AbilityKey, object]) -> bool:
        if not self.matchesValidParam("ValidPlayer", runParams.get(AbilityKey.Player)):
            return False
        if self.hasParam("ValidResult"):
            result = bool(runParams.get(AbilityKey.Result))
            valid = "Win" == self.getParam("ValidResult")
            if result ^ valid:
                return False

        return True

    def setTriggeringObjects(self, sa: SpellAbility, runParams: dict[AbilityKey, object]) -> None:
        sa.setTriggeringObjectsFrom(runParams, AbilityKey.Player)

    def getImportantStackObjects(self, sa: SpellAbility) -> str:
        sb = []
        sb.append(Localizer.getInstance().getMessage("lblPlayer"))
        sb.append(": ")
        sb.append(str(sa.getTriggeringObject(AbilityKey.Player)))
        return "".join(sb)
```
