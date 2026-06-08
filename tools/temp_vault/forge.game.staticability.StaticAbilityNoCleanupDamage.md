---
aliases:
  - StaticAbilityNoCleanupDamage
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityNoCleanupDamage
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityNoCleanupDamage

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityNoCleanupDamage {
        +damageNotRemoved(Card card) boolean
        +damageNotRemovedApplies(StaticAbility stAb, Card card) boolean
    }
    StaticAbilityNoCleanupDamage ..> Card : uses
    StaticAbilityNoCleanupDamage ..> Game : uses
    StaticAbilityNoCleanupDamage ..> StaticAbility : uses
```

## Relationships
**Uses:**
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityNoCleanupDamage.java`

```java
package forge.game.staticability;

import forge.game.Game;
import forge.game.card.Card;
import forge.game.zone.ZoneType;

public class StaticAbilityNoCleanupDamage {

    static public boolean damageNotRemoved(Card card) {
        final Game game = card.getGame();
        for (final Card ca : game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(StaticAbilityMode.NoCleanupDamage)) {
                    continue;
                }
                if (damageNotRemovedApplies(stAb, card)) {
                    return true;
                }
            }
        }
        return false;
    }

    static public boolean damageNotRemovedApplies(StaticAbility stAb, Card card) {
        if (!stAb.matchesValidParam("ValidCard", card)) {
            return false;
        }
        return true;
    }
}
```
