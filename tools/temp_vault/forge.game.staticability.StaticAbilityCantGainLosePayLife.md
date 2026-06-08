---
aliases:
  - StaticAbilityCantGainLosePayLife
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityCantGainLosePayLife
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityCantGainLosePayLife

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityCantGainLosePayLife {
        +anyCantGainLife(Player player) boolean
        +anyCantLoseLife(Player player) boolean
        +anyCantPayLife(Player player, boolean effect, SpellAbility cause) boolean
        +applyCommonAbility(StaticAbility stAb, Player player) boolean
    }
    StaticAbilityCantGainLosePayLife ..> Card : uses
    StaticAbilityCantGainLosePayLife ..> Game : uses
    StaticAbilityCantGainLosePayLife ..> Player : uses
    StaticAbilityCantGainLosePayLife ..> SpellAbility : uses
    StaticAbilityCantGainLosePayLife ..> StaticAbility : uses
```

## Relationships
**Uses:**
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.player.Player|Player]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityCantGainLosePayLife.java`

```java
package forge.game.staticability;

import forge.game.Game;
import forge.game.card.Card;
import forge.game.player.Player;
import forge.game.spellability.SpellAbility;
import forge.game.zone.ZoneType;

public class StaticAbilityCantGainLosePayLife {

    public static boolean anyCantGainLife(final Player player) {
        final Game game = player.getGame();
        for (final Card ca : game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!(stAb.checkMode(StaticAbilityMode.CantGainLife) || stAb.checkMode(StaticAbilityMode.CantChangeLife))) {
                    continue;
                }

                if (!stAb.checkConditions()) {
                    continue;
                }

                if (applyCommonAbility(stAb, player)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static boolean anyCantLoseLife(final Player player)  {
        final Game game = player.getGame();
        for (final Card ca : game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!(stAb.checkMode(StaticAbilityMode.CantLoseLife) || stAb.checkMode(StaticAbilityMode.CantChangeLife))) {
                    continue;
                }

                if (!stAb.checkConditions()) {
                    continue;
                }

                if (applyCommonAbility(stAb, player)) {
                    return true;
                }
            }
        }

        return false;
    }

    public static boolean anyCantPayLife(final Player player, final boolean effect, final SpellAbility cause)  {
        final Game game = player.getGame();
        for (final Card ca : game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!(stAb.checkMode(StaticAbilityMode.CantPayLife) || stAb.checkMode(StaticAbilityMode.CantLoseLife) || stAb.checkMode(StaticAbilityMode.CantChangeLife))) {
                    continue;
                }

                if (!stAb.checkConditions()) {
                    continue;
                }

                if (stAb.hasParam("ForCost")) {
                    if ("True".equalsIgnoreCase(stAb.getParam("ForCost")) == effect) {
                        continue;
                    }
                }

                if (!stAb.matchesValidParam("ValidCause", cause)) {
                    continue;
                }

                if (applyCommonAbility(stAb, player)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static boolean applyCommonAbility(final StaticAbility stAb, final Player player) {
        if (!stAb.matchesValidParam("ValidPlayer", player)) {
            return false;
        }
        return true;
    }
}
```
