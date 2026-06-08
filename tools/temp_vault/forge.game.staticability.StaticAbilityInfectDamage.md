---
aliases:
  - StaticAbilityInfectDamage
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityInfectDamage
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityInfectDamage

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityInfectDamage {
        +isInfectDamage(Player target) boolean
        +applyInfectDamageAbility(StaticAbility stAb, Player target) boolean
    }
    StaticAbilityInfectDamage ..> Card : uses
    StaticAbilityInfectDamage ..> Game : uses
    StaticAbilityInfectDamage ..> Player : uses
    StaticAbilityInfectDamage ..> StaticAbility : uses
```

## Relationships
**Uses:**
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.player.Player|Player]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityInfectDamage.java`

```java
package forge.game.staticability;

import forge.game.Game;
import forge.game.card.Card;
import forge.game.player.Player;
import forge.game.zone.ZoneType;

public class StaticAbilityInfectDamage {

    static public boolean isInfectDamage(Player target) {
        final Game game = target.getGame();
        for (final Card ca : game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(StaticAbilityMode.InfectDamage)) {
                    continue;
                }
                if (applyInfectDamageAbility(stAb, target)) {
                    return true;
                }
            }
        }
        return false;
    }

    static public boolean applyInfectDamageAbility(StaticAbility stAb, Player target) {
        if (!stAb.matchesValidParam("ValidTarget", target)) {
            return false;
        }
        return true;
    }
}
```
