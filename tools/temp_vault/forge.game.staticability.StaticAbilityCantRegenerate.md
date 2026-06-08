---
aliases:
  - StaticAbilityCantRegenerate
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityCantRegenerate
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityCantRegenerate

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityCantRegenerate {
        +cantRegenerate(Card card) boolean
        +applyCantRegenerateAbility(StaticAbility stAb, Card card) boolean
    }
    StaticAbilityCantRegenerate ..> Card : uses
    StaticAbilityCantRegenerate ..> Game : uses
    StaticAbilityCantRegenerate ..> StaticAbility : uses
```

## Relationships
**Uses:**
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityCantRegenerate.java`

```java
package forge.game.staticability;

import forge.game.Game;
import forge.game.card.Card;
import forge.game.zone.ZoneType;

public class StaticAbilityCantRegenerate {

    public static boolean cantRegenerate(final Card card)  {
        final Game game = card.getGame();
        for (final Card ca : game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(StaticAbilityMode.CantRegenerate)) {
                    continue;
                }

                if (applyCantRegenerateAbility(stAb, card)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static boolean applyCantRegenerateAbility(final StaticAbility stAb, final Card card) {
        if (!stAb.matchesValidParam("ValidCard", card)) {
            return false;
        }
        return true;
    }
}
```
