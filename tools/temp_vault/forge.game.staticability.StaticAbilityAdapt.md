---
aliases:
  - StaticAbilityAdapt
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityAdapt
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityAdapt

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityAdapt {
        +anyWithAdapt(SpellAbility sa, Card card) boolean
        +applyWithAdapt(StaticAbility stAb, SpellAbility sa, Card card) boolean
    }
    StaticAbilityAdapt ..> Card : uses
    StaticAbilityAdapt ..> Game : uses
    StaticAbilityAdapt ..> SpellAbility : uses
    StaticAbilityAdapt ..> StaticAbility : uses
```

## Relationships
**Uses:**
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityAdapt.java`

```java
package forge.game.staticability;

import forge.game.Game;
import forge.game.card.Card;
import forge.game.spellability.SpellAbility;
import forge.game.zone.ZoneType;

public class StaticAbilityAdapt {

    public static boolean anyWithAdapt(final SpellAbility sa, final Card card) {
        final Game game = card.getGame();
        for (final Card ca : game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(StaticAbilityMode.CanAdapt)) {
                    continue;
                }
                if (applyWithAdapt(stAb, sa, card)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static boolean applyWithAdapt(final StaticAbility stAb, final SpellAbility sa, final Card card) {
        if (!stAb.matchesValidParam("ValidCard", card)) {
            return false;
        }

        if (!stAb.matchesValidParam("ValidSA", sa)) {
            return false;
        }
        return true;
    }
}
```
