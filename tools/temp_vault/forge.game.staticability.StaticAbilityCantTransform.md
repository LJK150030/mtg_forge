---
aliases:
  - StaticAbilityCantTransform
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityCantTransform
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityCantTransform

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityCantTransform {
        +cantTransform(Card card, CardTraitBase cause) boolean
        +applyCantTransformAbility(StaticAbility stAb, Card card, CardTraitBase cause) boolean
    }
    StaticAbilityCantTransform ..> Card : uses
    StaticAbilityCantTransform ..> CardTraitBase : uses
    StaticAbilityCantTransform ..> Game : uses
    StaticAbilityCantTransform ..> StaticAbility : uses
```

## Relationships
**Uses:**
- [[forge.game.CardTraitBase|CardTraitBase]]
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityCantTransform.java`

```java
package forge.game.staticability;

import forge.game.CardTraitBase;
import forge.game.Game;
import forge.game.card.Card;
import forge.game.zone.ZoneType;

public class StaticAbilityCantTransform {

    static public boolean cantTransform(Card card, CardTraitBase cause) {
        final Game game = card.getGame();
        for (final Card ca : game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(StaticAbilityMode.CantTransform)) {
                    continue;
                }
                if (applyCantTransformAbility(stAb, card, cause)) {
                    return true;
                }
            }
        }
        return false;
    }

    static public boolean applyCantTransformAbility(StaticAbility stAb, Card card, CardTraitBase cause) {
        if (!stAb.matchesValidParam("ValidCard", card)) {
            return false;
        }
        if (stAb.hasParam("ExceptCause")) {
            if (stAb.matchesValidParam("ExceptCause", cause)) {
                return false;
            }
        }
        return true;
    }
}
```
