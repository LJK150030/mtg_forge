---
aliases:
  - StaticAbilityAssignCombatDamageAsUnblocked
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityAssignCombatDamageAsUnblocked
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityAssignCombatDamageAsUnblocked

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityAssignCombatDamageAsUnblocked {
        +assignCombatDamageAsUnblocked(Card card) boolean
        +assignCombatDamageAsUnblocked(Card card, boolean optional) boolean
        -applyAssignCombatDamageAsUnblocked(StaticAbility stAb, Card card) boolean
    }
    StaticAbilityAssignCombatDamageAsUnblocked ..> Card : uses
    StaticAbilityAssignCombatDamageAsUnblocked ..> Game : uses
    StaticAbilityAssignCombatDamageAsUnblocked ..> StaticAbility : uses
```

## Relationships
**Uses:**
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityAssignCombatDamageAsUnblocked.java`

```java
package forge.game.staticability;

import forge.game.Game;
import forge.game.card.Card;
import forge.game.zone.ZoneType;

public class StaticAbilityAssignCombatDamageAsUnblocked {

    public static boolean assignCombatDamageAsUnblocked(final Card card) {
        return assignCombatDamageAsUnblocked(card, true);
    }

    public static boolean assignCombatDamageAsUnblocked(final Card card, final boolean optional)  {
        final Game game = card.getGame();
        for (final Card ca : game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(StaticAbilityMode.AssignCombatDamageAsUnblocked)) {
                    continue;
                }

                if (stAb.hasParam("Optional") != optional) {
                    continue;
                }

                if (applyAssignCombatDamageAsUnblocked(stAb, card)) {
                    return true;
                }
            }
        }
        return false;
    }

    private static boolean applyAssignCombatDamageAsUnblocked(final StaticAbility stAb, final Card card) {
        if (!stAb.matchesValidParam("ValidCard", card)) {
            return false;
        }
        return true;
    }
}
```
