---
aliases:
  - TriggerNewGame
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/trigger
fqn: forge.game.trigger.TriggerNewGame
package: forge.game.trigger
module: forge-game
kind: Class
---

# TriggerNewGame

**Package:** `forge.game.trigger` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class TriggerNewGame {
        +performTest(Map~AbilityKey,Object~ runParams) boolean
        +setTriggeringObjects(SpellAbility sa, Map~AbilityKey,Object~ runParams) void
        +getImportantStackObjects(SpellAbility sa) String
        +TriggerNewGame(Map~String,String~ params, Card host, boolean intrinsic)
    }
    TriggerNewGame --|> Trigger : extends
    TriggerNewGame ..> AbilityKey : uses
    TriggerNewGame ..> Card : uses
    TriggerNewGame ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.trigger.Trigger|Trigger]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Source
`forge-game/src/main/java/forge/game/trigger/TriggerNewGame.java`

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

/**
 * <p>
 * Trigger_NewGame class.
 * </p>
 * 
 * @author Forge
 * @version $Id: TriggerPhase.java 17802 2012-10-31 08:05:14Z Max mtg $
 */
public class TriggerNewGame extends Trigger {

    /**
     * <p>
     * Constructor for Trigger_NewGame.
     * </p>
     * 
     * @param params
     *            a {@link java.util.HashMap} object.
     * @param host
     *            a {@link forge.game.card.Card} object.
     * @param intrinsic
     *            the intrinsic
     */
    public TriggerNewGame(final Map<String, String> params, final Card host, final boolean intrinsic) {
        super(params, host, intrinsic);
    }

    /** {@inheritDoc}
     * @param runParams*/
    @Override
    public final boolean performTest(final Map<AbilityKey, Object> runParams) {
        return true;
    }

    /** {@inheritDoc} */
    @Override
    public final void setTriggeringObjects(final SpellAbility sa, Map<AbilityKey, Object> runParams) {
    }

    @Override
    public String getImportantStackObjects(SpellAbility sa) {
        return "";
    }
}
```
