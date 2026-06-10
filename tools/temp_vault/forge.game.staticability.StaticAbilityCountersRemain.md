---
aliases:
  - StaticAbilityCountersRemain
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityCountersRemain
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityCountersRemain

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityCountersRemain {
        +countersRemain(Card card, Zone zone) boolean
        +applyCountersRemainAbility(StaticAbility stAb, Card card) boolean
    }
    StaticAbilityCountersRemain ..> Card : uses
    StaticAbilityCountersRemain ..> CardCollection : uses
    StaticAbilityCountersRemain ..> Game : uses
    StaticAbilityCountersRemain ..> StaticAbility : uses
    StaticAbilityCountersRemain ..> Zone : uses
```

## Relationships
**Uses:**
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.card.CardCollection|CardCollection]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]
- [[forge.game.zone.Zone|Zone]]

## Design Description

Static utility class providing host-side counter-removal-prevention checks for the Forge game engine. Its `countersRemain` method determines whether counters on a given `Card` in a visible `Zone` are protected from removal by scanning every active static ability across the relevant zones â€” gathering candidate sources into a `CardCollection` from the `Game`, including the card itself, and short-circuiting as soon as one applicable `StaticAbility` matches.

As a stateless collection of `static` methods, the class is a focused helper within the `staticability` package rather than part of an inheritance hierarchy. It collaborates with `StaticAbility` to filter by `CountersRemain` mode and validate the target via the `ValidCard` parameter, while skipping hidden zones up front to limit evaluation to relevant game state. The split between condition-scanning and per-ability application keeps the matching logic isolated and reusable.

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityCountersRemain.java`

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

import forge.game.Game;
import forge.game.card.Card;
import forge.game.card.CardCollection;
import forge.game.zone.Zone;
import forge.game.zone.ZoneType;

public class StaticAbilityCountersRemain {

    public static boolean countersRemain(final Card card, final Zone zone) {
        if (zone == null || zone.getZoneType().isHidden()) {
            return false;
        }

        final Game game = card.getGame();
        final CardCollection allp = new CardCollection(game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES));
        allp.add(card);
        for (final Card ca : allp) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(StaticAbilityMode.CountersRemain)) {
                    continue;
                }
                if (applyCountersRemainAbility(stAb, card)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static boolean applyCountersRemainAbility(final StaticAbility stAb, final Card card) {
        if (!stAb.matchesValidParam("ValidCard", card)) {
            return false;
        }
        return true;
    }
}
```

## Python
`forge/game/staticability/StaticAbilityCountersRemain.py`

```python
from forge.game.Game import Game
from forge.game.card.Card import Card
from forge.game.card.CardCollection import CardCollection
from forge.game.zone.Zone import Zone
from forge.game.zone.ZoneType import ZoneType
from forge.game.staticability.StaticAbility import StaticAbility
from forge.game.staticability.StaticAbilityMode import StaticAbilityMode


class StaticAbilityCountersRemain:

    @staticmethod
    def countersRemain(card: Card, zone: Zone) -> bool:
        if zone is None or zone.getZoneType().isHidden():
            return False

        game = card.getGame()
        allp = CardCollection(game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES))
        allp.add(card)
        for ca in allp:
            for stAb in ca.getStaticAbilities():
                if not stAb.checkConditions(StaticAbilityMode.CountersRemain):
                    continue
                if StaticAbilityCountersRemain.applyCountersRemainAbility(stAb, card):
                    return True
        return False

    @staticmethod
    def applyCountersRemainAbility(stAb: StaticAbility, card: Card) -> bool:
        if not stAb.matchesValidParam("ValidCard", card):
            return False
        return True
```
