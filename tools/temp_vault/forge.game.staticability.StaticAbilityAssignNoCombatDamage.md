---
aliases:
  - StaticAbilityAssignNoCombatDamage
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityAssignNoCombatDamage
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityAssignNoCombatDamage

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityAssignNoCombatDamage {
        +assignNoCombatDamage(Card card) boolean
        +applyAssignNoCombatDamage(StaticAbility stAb, Card card) boolean
    }
    StaticAbilityAssignNoCombatDamage ..> Card : uses
    StaticAbilityAssignNoCombatDamage ..> CardCollection : uses
    StaticAbilityAssignNoCombatDamage ..> StaticAbility : uses
```

## Relationships
**Uses:**
- [[forge.game.card.Card|Card]]
- [[forge.game.card.CardCollection|CardCollection]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityAssignNoCombatDamage.java`

```java
package forge.game.staticability;

import forge.game.card.Card;
import forge.game.card.CardCollection;
import forge.game.zone.ZoneType;

public class StaticAbilityAssignNoCombatDamage {

    public static boolean assignNoCombatDamage(final Card card) {
        CardCollection list = new CardCollection(card.getGame().getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES));
        list.add(card);
        for (final Card ca : list) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(StaticAbilityMode.AssignNoCombatDamage)) {
                    continue;
                }
                if (applyAssignNoCombatDamage(stAb, card)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static boolean applyAssignNoCombatDamage(final StaticAbility stAb, final Card card) {
        if (!stAb.matchesValidParam("ValidCard", card)) {
            return false;
        }
        return true;
    }

}
```
