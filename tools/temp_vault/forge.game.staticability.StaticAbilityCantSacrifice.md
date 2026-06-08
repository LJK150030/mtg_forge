---
aliases:
  - StaticAbilityCantSacrifice
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityCantSacrifice
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityCantSacrifice

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityCantSacrifice {
        +cantSacrifice(Card card, SpellAbility cause, boolean effect) boolean
        +applyCantSacrificeAbility(StaticAbility stAb, Card card, SpellAbility cause, boolean effect) boolean
    }
    StaticAbilityCantSacrifice ..> Card : uses
    StaticAbilityCantSacrifice ..> Game : uses
    StaticAbilityCantSacrifice ..> SpellAbility : uses
    StaticAbilityCantSacrifice ..> StaticAbility : uses
```

## Relationships
**Uses:**
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityCantSacrifice.java`

```java
package forge.game.staticability;

import forge.game.Game;
import forge.game.card.Card;
import forge.game.spellability.SpellAbility;
import forge.game.zone.ZoneType;

public class StaticAbilityCantSacrifice {

    public static boolean cantSacrifice(final Card card, final SpellAbility cause, final boolean effect)  {
        final Game game = card.getGame();
        for (final Card ca : game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(StaticAbilityMode.CantSacrifice)) {
                    continue;
                }

                if (applyCantSacrificeAbility(stAb, card, cause, effect)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static boolean applyCantSacrificeAbility(final StaticAbility stAb, final Card card, final SpellAbility cause, final boolean effect) {
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
