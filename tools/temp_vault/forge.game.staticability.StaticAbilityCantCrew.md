---
aliases:
  - StaticAbilityCantCrew
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityCantCrew
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityCantCrew

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityCantCrew {
        +cantCrew(Card card) boolean
        +applyCantCrew(StaticAbility stAb, Card card) boolean
    }
    StaticAbilityCantCrew ..> Card : uses
    StaticAbilityCantCrew ..> CardCollection : uses
    StaticAbilityCantCrew ..> StaticAbility : uses
```

## Relationships
**Uses:**
- [[forge.game.card.Card|Card]]
- [[forge.game.card.CardCollection|CardCollection]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityCantCrew.java`

```java
package forge.game.staticability;

import forge.game.card.Card;
import forge.game.card.CardCollection;
import forge.game.zone.ZoneType;

public class StaticAbilityCantCrew {

    public static boolean cantCrew(final Card card) {
        CardCollection list = new CardCollection(card.getGame().getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES));
        list.add(card);
        for (final Card ca : list) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(StaticAbilityMode.CantCrew)) {
                    continue;
                }
                if (applyCantCrew(stAb, card)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static boolean applyCantCrew(final StaticAbility stAb, final Card card) {
        if (!stAb.matchesValidParam("ValidCard", card)) {
            return false;
        }
        return true;
    }

}
```
