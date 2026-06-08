---
aliases:
  - StaticAbilityCantBecomeMonarch
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityCantBecomeMonarch
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityCantBecomeMonarch

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityCantBecomeMonarch {
        +anyCantBecomeMonarch(Player player) boolean
        -applyCantBecomeMonarchAbility(StaticAbility stAb, Player player) boolean
    }
    StaticAbilityCantBecomeMonarch ..> Card : uses
    StaticAbilityCantBecomeMonarch ..> Game : uses
    StaticAbilityCantBecomeMonarch ..> Player : uses
    StaticAbilityCantBecomeMonarch ..> StaticAbility : uses
```

## Relationships
**Uses:**
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.player.Player|Player]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityCantBecomeMonarch.java`

```java
package forge.game.staticability;

import forge.game.Game;
import forge.game.card.Card;
import forge.game.player.Player;
import forge.game.zone.ZoneType;

public class StaticAbilityCantBecomeMonarch {

    public static boolean anyCantBecomeMonarch(final Player player) {
        final Game game = player.getGame();
        for (final Card ca : game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(StaticAbilityMode.CantBecomeMonarch)) {
                    continue;
                }
                if (applyCantBecomeMonarchAbility(stAb, player)) {
                    return true;
                }
            }
        }
        return false;
    }

    private static boolean applyCantBecomeMonarchAbility(final StaticAbility stAb, final Player player) {
        if (!stAb.matchesValidParam("ValidPlayer", player)) {
            return false;
        }
        return true;
    }
}
```
