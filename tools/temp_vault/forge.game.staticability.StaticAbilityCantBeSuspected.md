---
aliases:
  - StaticAbilityCantBeSuspected
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityCantBeSuspected
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityCantBeSuspected

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityCantBeSuspected {
        +cantBeSuspected(Card c) boolean
        -cantBeSuspectedCheck(StaticAbility stAb, Card card) boolean
    }
    StaticAbilityCantBeSuspected ..> Card : uses
    StaticAbilityCantBeSuspected ..> Game : uses
    StaticAbilityCantBeSuspected ..> StaticAbility : uses
```

## Relationships
**Uses:**
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityCantBeSuspected.java`

```java
package forge.game.staticability;

import forge.game.Game;
import forge.game.card.Card;
import forge.game.zone.ZoneType;

public class StaticAbilityCantBeSuspected {

    public static boolean cantBeSuspected(final Card c) {
        final Game game = c.getGame();
        for (final Card ca : game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(StaticAbilityMode.CantBeSuspected)) {
                    continue;
                }
                if (cantBeSuspectedCheck(stAb, c)) {
                    return true;
                }
            }
        }
        return false;
    }

    private static boolean cantBeSuspectedCheck(final StaticAbility stAb, final Card card) {
        if (stAb.matchesValidParam("ValidCard", card)) {
            return true;
        }
        return false;
    }
}
```
