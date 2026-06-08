---
aliases:
  - StaticAbilityTurnPhaseReversed
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/staticability
fqn: forge.game.staticability.StaticAbilityTurnPhaseReversed
package: forge.game.staticability
module: forge-game
kind: Class
---

# StaticAbilityTurnPhaseReversed

**Package:** `forge.game.staticability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticAbilityTurnPhaseReversed {
        +isTurnReversed(Player player) boolean
        +isPhaseReversed(Player player) boolean
        #anyTurnPhaseReversed(Player player, StaticAbilityMode mode) boolean
        #applyTurnPhaseReversed(StaticAbility stAb, Player player) boolean
    }
    StaticAbilityTurnPhaseReversed ..> Card : uses
    StaticAbilityTurnPhaseReversed ..> Game : uses
    StaticAbilityTurnPhaseReversed ..> Player : uses
    StaticAbilityTurnPhaseReversed ..> StaticAbility : uses
    StaticAbilityTurnPhaseReversed ..> StaticAbilityMode : uses
```

## Relationships
**Uses:**
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.player.Player|Player]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]
- [[forge.game.staticability.StaticAbilityMode|StaticAbilityMode]]

## Source
`forge-game/src/main/java/forge/game/staticability/StaticAbilityTurnPhaseReversed.java`

```java
package forge.game.staticability;

import forge.game.Game;
import forge.game.card.Card;
import forge.game.player.Player;
import forge.game.zone.ZoneType;

public class StaticAbilityTurnPhaseReversed {
    public static boolean isTurnReversed(Player player) {
        return anyTurnPhaseReversed(player, StaticAbilityMode.TurnReversed);
    }
    public static boolean isPhaseReversed(Player player) {
        return anyTurnPhaseReversed(player, StaticAbilityMode.PhaseReversed);
    }

    protected static boolean anyTurnPhaseReversed(Player player, final StaticAbilityMode mode)
    {
        boolean result = false;
        final Game game = player.getGame();
        for (final Card ca : game.getCardsIn(ZoneType.STATIC_ABILITIES_SOURCE_ZONES)) {
            for (final StaticAbility stAb : ca.getStaticAbilities()) {
                if (!stAb.checkConditions(mode)) {
                    continue;
                }
                if (applyTurnPhaseReversed(stAb, player)) {
                    result = !result;
                }
            }
        }
        return result;
    }

    protected static boolean applyTurnPhaseReversed(StaticAbility stAb, Player player) {
        if (!stAb.matchesValidParam("ValidPlayer", player)) {
            return false;
        }

        return true;
    }
}
```
