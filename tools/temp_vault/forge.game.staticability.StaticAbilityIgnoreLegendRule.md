---
aliases:
  - StaticAbilityIgnoreLegendRule
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityIgnoreLegendRule
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityIgnoreLegendRule

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityIgnoreLegendRule {
        +ignoreLegendRule(Card card) boolean
        -applyIgnoreLegendRuleAbility(StaticAbility stAb, Card card) boolean
    }
    StaticAbilityIgnoreLegendRule ..> Card : uses
    StaticAbilityIgnoreLegendRule ..> Game : uses
    StaticAbilityIgnoreLegendRule ..> StaticAbility : uses
```

## Relationships
**Uses:**
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityIgnoreLegendRule.java`

```java
package forge.game.staticability;

import forge.game.Game;
import forge.game.card.Card;
import forge.game.zone.ZoneType;

public class StaticAbilityIgnoreLegendRule {

    public static boolean ignoreLegendRule(final Card card)  {
        final Game game = card.getGame();
        for (final Card ca : game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(StaticAbilityMode.IgnoreLegendRule)) {
                    continue;
                }

                if (applyIgnoreLegendRuleAbility(stAb, card)) {
                    return true;
                }
            }
        }
        return false;
    }

    private static boolean applyIgnoreLegendRuleAbility(final StaticAbility stAb, final Card card) {
        if (!stAb.matchesValidParam("ValidCard", card)) {
            return false;
        }
        return true;
    }
}
```
