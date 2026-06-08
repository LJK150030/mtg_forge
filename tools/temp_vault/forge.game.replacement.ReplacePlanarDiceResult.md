---
aliases:
  - ReplacePlanarDiceResult
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/replacement
fqn: forge.game.replacement.ReplacePlanarDiceResult
package: forge.game.replacement
module: forge-game
kind: Class
---

# ReplacePlanarDiceResult

**Package:** `forge.game.replacement` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class ReplacePlanarDiceResult {
        +canReplace(Map~AbilityKey,Object~ runParams) boolean
        +setReplacingObjects(Map~AbilityKey,Object~ runParams, SpellAbility sa) void
        +ReplacePlanarDiceResult(Map~String,String~ params, Card host, boolean intrinsic)
    }
    ReplacePlanarDiceResult --|> ReplacementEffect : extends
    ReplacePlanarDiceResult ..> AbilityKey : uses
    ReplacePlanarDiceResult ..> Card : uses
    ReplacePlanarDiceResult ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.replacement.ReplacementEffect|ReplacementEffect]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Source
`forge-game/src/main/java/forge/game/replacement/ReplacePlanarDiceResult.java`

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

import forge.game.ability.AbilityKey;
import forge.game.card.Card;
import forge.game.spellability.SpellAbility;

import java.util.Map;

public class ReplacePlanarDiceResult extends ReplacementEffect {

    /**
     * Instantiates a new replace roll planar dice.
     *
     * @param params the params
     * @param host   the host
     */
    public ReplacePlanarDiceResult(final Map<String, String> params, final Card host, final boolean intrinsic) {
        super(params, host, intrinsic);
    }

    /* (non-Javadoc)
     * @see forge.card.replacement.ReplacementEffect#canReplace(java.util.HashMap)
     */
    @Override
    public boolean canReplace(Map<AbilityKey, Object> runParams) {
        if (!matchesValidParam("ValidRoll", runParams.get(AbilityKey.Result))) {
            return false;
        }
        return true;
    }

    /* (non-Javadoc)
     * @see forge.card.replacement.ReplacementEffect#setReplacingObjects(java.util.Map, forge.card.spellability.SpellAbility)
     */
    @Override
    public void setReplacingObjects(Map<AbilityKey, Object> runParams, SpellAbility sa) {
        sa.setReplacingObject(AbilityKey.Result, runParams.get(AbilityKey.Result));
    }
}
```
