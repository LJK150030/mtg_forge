---
aliases:
  - StaticAbilityExhaust
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityExhaust
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityExhaust

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityExhaust {
        +anyWithExhaust(Player player) boolean
        +applyWithExhaust(StaticAbility stAb, Player player) boolean
    }
    StaticAbilityExhaust ..> Card : uses
    StaticAbilityExhaust ..> Game : uses
    StaticAbilityExhaust ..> Player : uses
    StaticAbilityExhaust ..> StaticAbility : uses
```

## Relationships
**Uses:**
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.player.Player|Player]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityExhaust.java`

```java
package forge.game.staticability;

import forge.game.Game;
import forge.game.card.Card;
import forge.game.player.Player;
import forge.game.zone.ZoneType;
    
public class StaticAbilityExhaust {

    public static boolean anyWithExhaust(final Player player) {
        final Game game = player.getGame();
        for (final Card ca : game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(StaticAbilityMode.CanExhaust)) {
                    continue;
                }
                if (applyWithExhaust(stAb, player)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static boolean applyWithExhaust(final StaticAbility stAb, final Player player) {
        if (!stAb.matchesValidParam("ValidPlayer", player)) {
            return false;
        }

        return true;
    }
}
```
