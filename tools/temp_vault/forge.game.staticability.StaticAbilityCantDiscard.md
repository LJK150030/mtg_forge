---
aliases:
  - StaticAbilityCantDiscard
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityCantDiscard
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityCantDiscard

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityCantDiscard {
        +cantDiscard(Player player, SpellAbility cause, boolean effect) boolean
        +applyCantDiscardAbility(StaticAbility stAb, Player player, SpellAbility cause, boolean effect) boolean
    }
    StaticAbilityCantDiscard ..> Card : uses
    StaticAbilityCantDiscard ..> Game : uses
    StaticAbilityCantDiscard ..> Player : uses
    StaticAbilityCantDiscard ..> SpellAbility : uses
    StaticAbilityCantDiscard ..> StaticAbility : uses
```

## Relationships
**Uses:**
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.player.Player|Player]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityCantDiscard.java`

```java
package forge.game.staticability;

import forge.game.Game;
import forge.game.card.Card;
import forge.game.player.Player;
import forge.game.spellability.SpellAbility;
import forge.game.zone.ZoneType;

public class StaticAbilityCantDiscard {

    public static boolean cantDiscard(final Player player, final SpellAbility cause, final boolean effect)  {
        final Game game = player.getGame();
        for (final Card ca : game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(StaticAbilityMode.CantDiscard)) {
                    continue;
                }

                if (applyCantDiscardAbility(stAb, player, cause, effect)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static boolean applyCantDiscardAbility(final StaticAbility stAb, final Player player, final SpellAbility cause, final boolean effect) {
        if (!stAb.matchesValidParam("ValidPlayer", player)) {
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
