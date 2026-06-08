---
aliases:
  - StaticAbilityUntapOtherPlayer
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityUntapOtherPlayer
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityUntapOtherPlayer

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityUntapOtherPlayer {
        +untap(Card card, Player player) boolean
        +applyUntapAbility(StaticAbility stAb, Card card, Player player) boolean
    }
    StaticAbilityUntapOtherPlayer ..> Card : uses
    StaticAbilityUntapOtherPlayer ..> Player : uses
    StaticAbilityUntapOtherPlayer ..> StaticAbility : uses
```

## Relationships
**Uses:**
- [[forge.game.card.Card|Card]]
- [[forge.game.player.Player|Player]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityUntapOtherPlayer.java`

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
package forge.game.staticability;

import forge.game.card.Card;
import forge.game.player.Player;
import forge.game.zone.ZoneType;

public class StaticAbilityUntapOtherPlayer {

    public static boolean untap(final Card card, final Player player) {
        for (final Card ca : card.getGame().getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(StaticAbilityMode.UntapOtherPlayer)) {
                    continue;
                }

                if (applyUntapAbility(stAb, card, player)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static boolean applyUntapAbility(final StaticAbility stAb, final Card card, final Player player) {
        if (!stAb.matchesValidParam("ValidCard", card)) {
            return false;
        }
        if (!stAb.matchesValidParam("ValidPlayer", player)) {
            return false;
        }
        return true;
    }
}
```
