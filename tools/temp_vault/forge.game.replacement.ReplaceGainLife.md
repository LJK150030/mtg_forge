---
aliases:
  - ReplaceGainLife
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/replacement
fqn: forge.game.replacement.ReplaceGainLife
package: forge.game.replacement
module: forge-game
kind: Class
---

# ReplaceGainLife

**Package:** `forge.game.replacement` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class ReplaceGainLife {
        +canReplace(Map~AbilityKey,Object~ runParams) boolean
        +setReplacingObjects(Map~AbilityKey,Object~ runParams, SpellAbility sa) void
        +ReplaceGainLife(Map~String,String~ map, Card host, boolean intrinsic)
    }
    ReplaceGainLife --|> ReplacementEffect : extends
    ReplaceGainLife ..> AbilityKey : uses
    ReplaceGainLife ..> Card : uses
    ReplaceGainLife ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.replacement.ReplacementEffect|ReplacementEffect]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

ReplaceGainLife is a concrete replacement effect that intercepts life-gain events, allowing card behavior to modify or prevent a player from gaining life under specified conditions. As a subclass of ReplacementEffect, it overrides `canReplace` to gate activationâ€”requiring a positive LifeGained amount and validating the affected player and source spell against the effect's `ValidPlayer`, `ValidSource`, and `SourceController` parametersâ€”and overrides `setReplacingObjects` to expose the gained amount and affected player back to the responding SpellAbility. It collaborates with AbilityKey to read and write typed entries in the runtime parameter map, with Card as its host, and with SpellAbility to resolve the triggering source and publish replacement objects. The design follows the engine's template-method pattern, keeping matching logic declarative and data-driven through inherited parameter helpers.

## Source
`forge-game/src/main/java/forge/game/replacement/ReplaceGainLife.java`

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
package forge.game.replacement;

import java.util.Map;

import forge.game.ability.AbilityKey;
import forge.game.card.Card;
import forge.game.spellability.SpellAbility;

/** 
 * TODO: Write javadoc for this type.
 *
 */
public class ReplaceGainLife extends ReplacementEffect {

    /**
     * Instantiates a new replace gain life.
     *
     * @param map the map
     * @param host the host
     */
    public ReplaceGainLife(Map<String, String> map, Card host, boolean intrinsic) {
        super(map, host, intrinsic);
    }

    /* (non-Javadoc)
     * @see forge.card.replacement.ReplacementEffect#canReplace(java.util.HashMap)
     */
    @Override
    public boolean canReplace(Map<AbilityKey, Object> runParams) {
        if (((int)runParams.get(AbilityKey.LifeGained)) <= 0) {
            return false;
        }
        if (!matchesValidParam("ValidPlayer", runParams.get(AbilityKey.Affected))) {
            return false;
        }
        if (!matchesValidParam("ValidSource", runParams.get(AbilityKey.SourceSA))) {
            return false;
        }
        if ("True".equals(getParam("SourceController"))) {
            if (runParams.get(AbilityKey.SourceSA) == null || !runParams.get(AbilityKey.Affected).equals(((SpellAbility)runParams.get(AbilityKey.SourceSA)).getActivatingPlayer())) {
                return false;
            }
        }

        return true;
    }

    /* (non-Javadoc)
     * @see forge.card.replacement.ReplacementEffect#setReplacingObjects(java.util.HashMap, forge.card.spellability.SpellAbility)
     */
    @Override
    public void setReplacingObjects(Map<AbilityKey, Object> runParams, SpellAbility sa) {
        sa.setReplacingObject(AbilityKey.LifeGained, runParams.get(AbilityKey.LifeGained));
        sa.setReplacingObject(AbilityKey.Player, runParams.get(AbilityKey.Affected));
    }

}
```

## Python
`forge/game/replacement/ReplaceGainLife.py`

```python
from forge.game.replacement.ReplacementEffect import ReplacementEffect
from forge.game.ability.AbilityKey import AbilityKey
from forge.game.card.Card import Card
from forge.game.spellability.SpellAbility import SpellAbility


# TODO: Write javadoc for this type.
class ReplaceGainLife(ReplacementEffect):

    def __init__(self, map: dict[str, str], host: Card, intrinsic: bool):
        super().__init__(map, host, intrinsic)

    def canReplace(self, runParams: dict[AbilityKey, object]) -> bool:
        if int(runParams.get(AbilityKey.LifeGained)) <= 0:
            return False
        if not self.matchesValidParam("ValidPlayer", runParams.get(AbilityKey.Affected)):
            return False
        if not self.matchesValidParam("ValidSource", runParams.get(AbilityKey.SourceSA)):
            return False
        if "True" == self.getParam("SourceController"):
            if runParams.get(AbilityKey.SourceSA) is None or runParams.get(AbilityKey.Affected) != runParams.get(AbilityKey.SourceSA).getActivatingPlayer():
                return False

        return True

    def setReplacingObjects(self, runParams: dict[AbilityKey, object], sa: SpellAbility) -> None:
        sa.setReplacingObject(AbilityKey.LifeGained, runParams.get(AbilityKey.LifeGained))
        sa.setReplacingObject(AbilityKey.Player, runParams.get(AbilityKey.Affected))
```
