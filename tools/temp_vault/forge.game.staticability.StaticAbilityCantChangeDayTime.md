---
aliases:
  - StaticAbilityCantChangeDayTime
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityCantChangeDayTime
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityCantChangeDayTime

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityCantChangeDayTime {
        +cantChangeDay(Game game, Boolean value) boolean
        -cantChangeDayCheck(StaticAbility stAb, Boolean value) boolean
    }
    StaticAbilityCantChangeDayTime ..> Card : uses
    StaticAbilityCantChangeDayTime ..> Game : uses
    StaticAbilityCantChangeDayTime ..> StaticAbility : uses
```

## Relationships
**Uses:**
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityCantChangeDayTime.java`

```java
package forge.game.staticability;

import forge.game.Game;
import forge.game.card.Card;
import forge.game.zone.ZoneType;

public class StaticAbilityCantChangeDayTime {

    public static boolean cantChangeDay(final Game game, Boolean value) {
        if (value == null) {
            return false;
        }
        for (final Card ca : game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(StaticAbilityMode.CantChangeDayTime)) {
                    continue;
                }
                if (cantChangeDayCheck(stAb, value)) {
                    return true;
                }
            }
        }
        return false;
    }

    private static boolean cantChangeDayCheck(final StaticAbility stAb, final Boolean value) {
        if (stAb.hasParam("NewTime")) {
            switch(stAb.getParam("NewTime")) {
            case "Day":
                if (value != false) {
                    return false;
                }
            case "Night":
                if (value != true) {
                    return false;
                }
            }
        }
        return true;
    }
}
```
