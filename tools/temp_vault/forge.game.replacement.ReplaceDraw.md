---
aliases:
  - ReplaceDraw
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/replacement
fqn: forge.game.replacement.ReplaceDraw
package: forge.game.replacement
module: forge-game
kind: Class
---

# ReplaceDraw

**Package:** `forge.game.replacement` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class ReplaceDraw {
        +canReplace(Map~AbilityKey,Object~ runParams) boolean
        +setReplacingObjects(Map~AbilityKey,Object~ runParams, SpellAbility sa) void
        +ReplaceDraw(Map~String,String~ params, Card host, boolean intrinsic)
    }
    ReplaceDraw --|> ReplacementEffect : extends
    ReplaceDraw ..> AbilityKey : uses
    ReplaceDraw ..> Card : uses
    ReplaceDraw ..> Game : uses
    ReplaceDraw ..> Player : uses
    ReplaceDraw ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.replacement.ReplacementEffect|ReplacementEffect]]
**Uses:**
- [[forge.game.Game|Game]]
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.player.Player|Player]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Source
`forge-game/src/main/java/forge/game/replacement/ReplaceDraw.java`

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

import forge.game.Game;
import forge.game.ability.AbilityKey;
import forge.game.card.Card;
import forge.game.phase.PhaseType;
import forge.game.player.Player;
import forge.game.spellability.SpellAbility;

/**
 * TODO: Write javadoc for this type.
 *
 */
public class ReplaceDraw extends ReplacementEffect {

    /**
     * Instantiates a new replace draw.
     *
     * @param params the params
     * @param host the host
     */
    public ReplaceDraw(final Map<String, String> params, final Card host, final boolean intrinsic) {
        super(params, host, intrinsic);
    }

    /* (non-Javadoc)
     * @see forge.card.replacement.ReplacementEffect#canReplace(java.util.HashMap)
     */
    @Override
    public boolean canReplace(Map<AbilityKey, Object> runParams) {
        if (!matchesValidParam("ValidPlayer", runParams.get(AbilityKey.Affected))) {
            return false;
        }
        if (!matchesValidParam("ValidCause", runParams.get(AbilityKey.Cause))) {
            return false;
        }

        if (hasParam("NotFirstCardInDrawStep")) {
            final Game game = getHostCard().getGame();

            final Player p = (Player)runParams.get(AbilityKey.Affected);
            if (p.numDrawnThisDrawStep() == 0 && game.getPhaseHandler().is(PhaseType.DRAW, p)) {
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
        sa.setReplacingObject(AbilityKey.Player, runParams.get(AbilityKey.Affected));
        if (runParams.containsKey(AbilityKey.Cause)) {
            SpellAbility cause = (SpellAbility) runParams.get(AbilityKey.Cause);
            if (cause != null) {
                sa.setReplacingObject(AbilityKey.Cause, cause);
                sa.setReplacingObject(AbilityKey.Source, cause.getHostCard());
            }
        }
    }
}
```
