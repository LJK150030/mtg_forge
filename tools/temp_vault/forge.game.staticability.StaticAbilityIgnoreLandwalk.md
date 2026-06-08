---
aliases:
  - StaticAbilityIgnoreLandwalk
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityIgnoreLandwalk
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityIgnoreLandwalk

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityIgnoreLandwalk {
        +ignoreLandWalk(Card attacker, Card blocker, KeywordInterface k) boolean
        +ignoreLandWalkAbility(StaticAbility stAb, Card attacker, Card blocker, KeywordInterface k) boolean
    }
    StaticAbilityIgnoreLandwalk ..> Card : uses
    StaticAbilityIgnoreLandwalk ..> Game : uses
    StaticAbilityIgnoreLandwalk ..> KeywordInterface : uses
    StaticAbilityIgnoreLandwalk ..> StaticAbility : uses
```

## Relationships
**Uses:**
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.keyword.KeywordInterface|KeywordInterface]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityIgnoreLandwalk.java`

```java
package forge.game.staticability;

import forge.game.Game;
import forge.game.card.Card;
import forge.game.keyword.KeywordInterface;
import forge.game.zone.ZoneType;

public class StaticAbilityIgnoreLandwalk {

    public static boolean ignoreLandWalk(Card attacker, Card blocker, KeywordInterface k) {
        final Game game = attacker.getGame();
        for (final Card ca : game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(StaticAbilityMode.IgnoreLandwalk)) {
                    continue;
                }

                if (ignoreLandWalkAbility(stAb, attacker, blocker, k)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static boolean ignoreLandWalkAbility(final StaticAbility stAb, Card attacker, Card blocker, KeywordInterface k) {
        if (!stAb.matchesValidParam("ValidAttacker", attacker)) {
            return false;
        }
        if (!stAb.matchesValidParam("ValidBlocker", blocker)) {
            return false;
        }
        if (!stAb.matchesValidParam("ValidKeyword", k.getOriginal())) {
            return false;
        }

        return true;
    }
}
```
