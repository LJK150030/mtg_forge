---
aliases:
  - StaticAbilityGainLifeRadiation
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityGainLifeRadiation
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityGainLifeRadiation

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityGainLifeRadiation {
        +gainLifeRadiation(Player player) boolean
        +applyGainLifeRadiation(StaticAbility stAb, Player player) boolean
    }
    StaticAbilityGainLifeRadiation ..> Card : uses
    StaticAbilityGainLifeRadiation ..> Game : uses
    StaticAbilityGainLifeRadiation ..> Player : uses
    StaticAbilityGainLifeRadiation ..> StaticAbility : uses
```

## Relationships
**Uses:**
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.player.Player|Player]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityGainLifeRadiation.java`

```java
package forge.game.staticability;

import forge.game.Game;
import forge.game.card.Card;
import forge.game.player.Player;
import forge.game.zone.ZoneType;

public class StaticAbilityGainLifeRadiation {

    static public boolean gainLifeRadiation(Player player) {
        final Game game = player.getGame();
        for (final Card ca : game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(StaticAbilityMode.GainLifeRadiation)) {
                    continue;
                }
                if (applyGainLifeRadiation(stAb, player)) {
                    return true;
                }
            }
        }
        return false;
    }

    static public boolean applyGainLifeRadiation(StaticAbility stAb, Player player) {
        if (!stAb.matchesValidParam("ValidPlayer", player)) {
            return false;
        }
        return true;
    }

}
```
