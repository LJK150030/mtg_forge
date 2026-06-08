---
aliases:
  - StaticAbilityDevotion
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityDevotion
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityDevotion

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityDevotion {
        +getDevotionMod(Player player) int
    }
    StaticAbilityDevotion ..> Card : uses
    StaticAbilityDevotion ..> Game : uses
    StaticAbilityDevotion ..> Player : uses
    StaticAbilityDevotion ..> StaticAbility : uses
```

## Relationships
**Uses:**
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.player.Player|Player]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityDevotion.java`

```java
package forge.game.staticability;

import forge.game.Game;
import forge.game.card.Card;
import forge.game.player.Player;
import forge.game.zone.ZoneType;

public class StaticAbilityDevotion {

    public static int getDevotionMod(final Player player) {
        int i = 0;
        final Game game = player.getGame();
        for (final Card ca : game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(StaticAbilityMode.Devotion)) {
                    continue;
                }
                if (!stAb.matchesValidParam("ValidPlayer", player)) {
                    continue;
                }
                int t = Integer.parseInt(stAb.getParamOrDefault("Value", "1"));
                i += t;
            }
        }
        return i;
    }
}
```
