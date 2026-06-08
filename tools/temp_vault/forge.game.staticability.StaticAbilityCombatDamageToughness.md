---
aliases:
  - StaticAbilityCombatDamageToughness
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityCombatDamageToughness
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityCombatDamageToughness

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityCombatDamageToughness {
        +combatDamageToughness(Card card) boolean
        +applyCombatDamageToughnessAbility(StaticAbility stAb, Card card) boolean
    }
    StaticAbilityCombatDamageToughness ..> Card : uses
    StaticAbilityCombatDamageToughness ..> Game : uses
    StaticAbilityCombatDamageToughness ..> StaticAbility : uses
```

## Relationships
**Uses:**
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityCombatDamageToughness.java`

```java
package forge.game.staticability;

import forge.game.Game;
import forge.game.card.Card;
import forge.game.zone.ZoneType;

public class StaticAbilityCombatDamageToughness {

    public static boolean combatDamageToughness(final Card card)  {
        final Game game = card.getGame();
        for (final Card ca : game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(StaticAbilityMode.CombatDamageToughness)) {
                    continue;
                }

                if (applyCombatDamageToughnessAbility(stAb, card)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static boolean applyCombatDamageToughnessAbility(final StaticAbility stAb, final Card card) {
        if (!stAb.matchesValidParam("ValidCard", card)) {
            return false;
        }
        return true;
    }
}
```
