---
aliases:
  - StaticAbilityWitherDamage
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityWitherDamage
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityWitherDamage

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityWitherDamage {
        +isWitherDamage(Card source) boolean
        +applyWitherDamageAbility(StaticAbility stAb, Card source) boolean
    }
    StaticAbilityWitherDamage ..> Card : uses
    StaticAbilityWitherDamage ..> Game : uses
    StaticAbilityWitherDamage ..> StaticAbility : uses
```

## Relationships
**Uses:**
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityWitherDamage.java`

```java
package forge.game.staticability;

import forge.game.Game;
import forge.game.card.Card;
import forge.game.zone.ZoneType;

public class StaticAbilityWitherDamage {

    static public boolean isWitherDamage(Card source) {
        final Game game = source.getGame();
        for (final Card ca : game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(StaticAbilityMode.WitherDamage)) {
                    continue;
                }
                if (applyWitherDamageAbility(stAb, source)) {
                    return true;
                }
            }
        }
        return false;
    }

    static public boolean applyWitherDamageAbility(StaticAbility stAb, Card source) {
        if (!stAb.matchesValidParam("ValidCard", source)) {
            return false;
        }
        return true;
    }
}
```
