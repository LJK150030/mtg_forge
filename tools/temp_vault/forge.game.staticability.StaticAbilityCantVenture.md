---
aliases:
  - StaticAbilityCantVenture
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityCantVenture
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityCantVenture

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityCantVenture {
        +cantVenture(Player player) boolean
        +applyCantVentureAbility(StaticAbility stAb, Player player) boolean
    }
    StaticAbilityCantVenture ..> Card : uses
    StaticAbilityCantVenture ..> Game : uses
    StaticAbilityCantVenture ..> Player : uses
    StaticAbilityCantVenture ..> StaticAbility : uses
```

## Relationships
**Uses:**
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.player.Player|Player]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityCantVenture.java`

```java
package forge.game.staticability;

import forge.game.Game;
import forge.game.card.Card;
import forge.game.player.Player;
import forge.game.zone.ZoneType;

public class StaticAbilityCantVenture {

    static public boolean cantVenture(Player player) {
        final Game game = player.getGame();
        for (final Card ca : game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(StaticAbilityMode.CantVenture)) {
                    continue;
                }
                if (applyCantVentureAbility(stAb, player)) {
                    return true;
                }
            }
        }
        return false;
    }

    static public boolean applyCantVentureAbility(StaticAbility stAb, Player player) {
        if (!stAb.matchesValidParam("ValidPlayer", player)) {
            return false;
        }
        return true;
    }
}
```
