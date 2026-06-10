---
aliases:
  - ReplaceLoseMana
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/replacement
fqn: forge.game.replacement.ReplaceLoseMana
package: forge.game.replacement
module: forge-game
kind: Class
---

# ReplaceLoseMana

**Package:** `forge.game.replacement` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class ReplaceLoseMana {
        +canReplace(Map~AbilityKey,Object~ runParams) boolean
        +setReplacingObjects(Map~AbilityKey,Object~ runParams, SpellAbility sa) void
        +ReplaceLoseMana(Map~String,String~ map, Card host, boolean intrinsic)
    }
    ReplaceLoseMana --|> ReplacementEffect : extends
    ReplaceLoseMana ..> AbilityKey : uses
    ReplaceLoseMana ..> Card : uses
    ReplaceLoseMana ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.replacement.ReplacementEffect|ReplacementEffect]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

ReplaceLoseMana is a concrete replacement effect that intercepts mana-loss events, allowing card scripts to substitute or modify what happens when a player would lose mana. It specializes the abstract ReplacementEffect base class by supplying the two hooks the replacement framework drives: canReplace, which gates the effect by testing the affected player against the script's ValidPlayer condition, and setReplacingObjects, which exposes the affected Player and the Mana amount to the triggered SpellAbility for downstream resolution. It collaborates with AbilityKey to read and write typed entries in the runtime parameter map, and with Card as its host. The class deliberately holds no state of its own beyond what the superclass tracks, keeping all configuration data-driven through the constructor's string map so that game behavior is defined declaratively in card scripts rather than in code.

## Source
`forge-game/src/main/java/forge/game/replacement/ReplaceLoseMana.java`

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

public class ReplaceLoseMana extends ReplacementEffect {

    public ReplaceLoseMana(Map<String, String> map, Card host, boolean intrinsic) {
        super(map, host, intrinsic);
    }

    /* (non-Javadoc)
     * @see forge.card.replacement.ReplacementEffect#canReplace(java.util.HashMap)
     */
    @Override
    public boolean canReplace(Map<AbilityKey, Object> runParams) {
        if (!matchesValidParam("ValidPlayer", runParams.get(AbilityKey.Affected))) {
            return false;
        }

        return true;
    }

    /* (non-Javadoc)
     * @see forge.card.replacement.ReplacementEffect#setReplacingObjects(java.util.HashMap, forge.card.spellability.SpellAbility)
     */
    @Override
    public void setReplacingObjects(Map<AbilityKey, Object> runParams, SpellAbility sa) {
        sa.setReplacingObject(AbilityKey.Player, runParams.get(AbilityKey.Affected));
        sa.setReplacingObject(AbilityKey.Mana, runParams.get(AbilityKey.Mana));
    }

}
```

## Python
`forge/game/replacement/ReplaceLoseMana.py`

```python
from forge.game.replacement.ReplacementEffect import ReplacementEffect
from forge.game.ability.AbilityKey import AbilityKey
from forge.game.card.Card import Card
from forge.game.spellability.SpellAbility import SpellAbility


class ReplaceLoseMana(ReplacementEffect):

    def __init__(self, map: dict[str, str], host: Card, intrinsic: bool):
        super().__init__(map, host, intrinsic)

    def canReplace(self, runParams: dict[AbilityKey, object]) -> bool:
        if not self.matchesValidParam("ValidPlayer", runParams.get(AbilityKey.Affected)):
            return False

        return True

    def setReplacingObjects(self, runParams: dict[AbilityKey, object], sa: SpellAbility) -> None:
        sa.setReplacingObject(AbilityKey.Player, runParams.get(AbilityKey.Affected))
        sa.setReplacingObject(AbilityKey.Mana, runParams.get(AbilityKey.Mana))
```
