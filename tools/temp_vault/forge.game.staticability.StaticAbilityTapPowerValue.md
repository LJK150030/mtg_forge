---
aliases:
  - StaticAbilityTapPowerValue
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityTapPowerValue
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityTapPowerValue

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityTapPowerValue {
        +withToughness(Card card, CardTraitBase ctb) boolean
        +withToughness(StaticAbility stAb, Card card, CardTraitBase ctb) boolean
        +getMod(Card card, CardTraitBase ctb) int
    }
    StaticAbilityTapPowerValue ..> Card : uses
    StaticAbilityTapPowerValue ..> CardTraitBase : uses
    StaticAbilityTapPowerValue ..> Game : uses
    StaticAbilityTapPowerValue ..> StaticAbility : uses
```

## Relationships
**Uses:**
- [[forge.game.CardTraitBase|CardTraitBase]]
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityTapPowerValue.java`

```java
package forge.game.staticability;

import forge.game.CardTraitBase;
import forge.game.Game;
import forge.game.card.Card;
import forge.game.zone.ZoneType;

public class StaticAbilityTapPowerValue {

    public static boolean withToughness(final Card card, final CardTraitBase ctb) {
        final Game game = card.getGame();
        for (final Card ca : game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(StaticAbilityMode.TapPowerValue)) {
                    continue;
                }
                if (withToughness(stAb, card, ctb)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static boolean withToughness(final StaticAbility stAb, final Card card, final CardTraitBase ctb) {
        if (!stAb.getParam("Value").equals("Toughness")) {
            return false;
        }
        if (!stAb.matchesValidParam("ValidCard", card)) {
            return false;
        }
        if (!stAb.matchesValidParam("ValidSA", ctb)) {
            return false;
        }
        return true;
    }

    public static int getMod(final Card card, final CardTraitBase ctb) {
        int i = 0;
        final Game game = card.getGame();
        for (final Card ca : game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(StaticAbilityMode.TapPowerValue)) {
                    continue;
                }
                if (!stAb.matchesValidParam("ValidCard", card)) {
                    continue;
                }
                if (!stAb.matchesValidParam("ValidSA", ctb)) {
                    continue;
                }
                i += Integer.parseInt(stAb.getParam("Value"));
            }
        }
        return i;
    }

}
```
