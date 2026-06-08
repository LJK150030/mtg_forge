---
aliases:
  - StaticAbilityPlotZone
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityPlotZone
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityPlotZone

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityPlotZone {
        +plotZone(Card card) boolean
        -applyPlotZoneAbility(StaticAbility stAb, Card card) boolean
    }
    StaticAbilityPlotZone ..> Card : uses
    StaticAbilityPlotZone ..> Game : uses
    StaticAbilityPlotZone ..> StaticAbility : uses
```

## Relationships
**Uses:**
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityPlotZone.java`

```java
package forge.game.staticability;

import forge.game.Game;
import forge.game.card.Card;
import forge.game.zone.ZoneType;

public class StaticAbilityPlotZone {

    public static boolean plotZone(final Card card) {
        final Game game = card.getGame();
        for (final Card ca : game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(StaticAbilityMode.PlotZone)) {
                    continue;
                }

                if (applyPlotZoneAbility(stAb, card)) {
                    return true;
                }
            }
        }
        return false;
    }

    private static boolean applyPlotZoneAbility(final StaticAbility stAb, final Card card) {
        if (!stAb.matchesValidParam("ValidCard", card)) {
            return false;
        }
        return true;
    }
}
```
