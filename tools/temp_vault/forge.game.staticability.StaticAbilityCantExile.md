---
aliases:
  - StaticAbilityCantExile
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityCantExile
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityCantExile

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityCantExile {
        +cantExile(Card card, SpellAbility cause, boolean effect) boolean
        +applyCantExileAbility(StaticAbility stAb, Card card, SpellAbility cause, boolean effect) boolean
    }
    StaticAbilityCantExile ..> Card : uses
    StaticAbilityCantExile ..> Game : uses
    StaticAbilityCantExile ..> SpellAbility : uses
    StaticAbilityCantExile ..> StaticAbility : uses
```

## Relationships
**Uses:**
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityCantExile.java`

```java
package forge.game.staticability;

import forge.game.Game;
import forge.game.card.Card;
import forge.game.spellability.SpellAbility;
import forge.game.zone.ZoneType;

public class StaticAbilityCantExile {

    public static boolean cantExile(final Card card, final SpellAbility cause, final boolean effect)  {
        final Game game = card.getGame();
        for (final Card ca : game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(StaticAbilityMode.CantExile)) {
                    continue;
                }

                if (applyCantExileAbility(stAb, card, cause, effect)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static boolean applyCantExileAbility(final StaticAbility stAb, final Card card, final SpellAbility cause, final boolean effect) {
        if (!stAb.matchesValidParam("ValidCard", card)) {
            return false;
        }
        if (stAb.hasParam("ForCost")) {
            if ("True".equalsIgnoreCase(stAb.getParam("ForCost")) == effect) {
                return false;
            }
        }
        if (!stAb.matchesValidParam("ValidCause", cause)) {
            return false;
        }
        return true;
    }
}
```
