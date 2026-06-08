---
aliases:
  - HoustonMulligan
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/mulligan
fqn: forge.game.mulligan.HoustonMulligan
package: forge.game.mulligan
module: forge-game
kind: Class
---

# HoustonMulligan

**Package:** `forge.game.mulligan` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class HoustonMulligan {
        -int TUCK_COUNT
        +handSizeAfterNextMulligan() int
        +tuckCardsDuringMulligan() int
        +beforeFirstMulligan() void
        +keep() void
        +canMulligan() boolean
        +HoustonMulligan(Player p, boolean firstMullFree)
    }
    HoustonMulligan --|> AbstractMulligan : extends
    HoustonMulligan ..> Card : uses
    HoustonMulligan ..> CardCollection : uses
    HoustonMulligan ..> Player : uses
```

## Relationships
**Extends:**
- [[forge.game.mulligan.AbstractMulligan|AbstractMulligan]]
**Uses:**
- [[forge.game.card.Card|Card]]
- [[forge.game.card.CardCollection|CardCollection]]
- [[forge.game.player.Player|Player]]

## Source
`forge-game/src/main/java/forge/game/mulligan/HoustonMulligan.java`

```java
package forge.game.mulligan;

import forge.game.card.Card;
import forge.game.card.CardCollection;
import forge.game.player.Player;
import forge.game.zone.ZoneType;

public class HoustonMulligan extends AbstractMulligan {

    private static final int TUCK_COUNT = 3;

    @Override
    public int handSizeAfterNextMulligan() {
        return player.getMaxHandSize();
    }

    public HoustonMulligan(Player p, boolean firstMullFree) {
        super(p, firstMullFree);
    }

    public int tuckCardsDuringMulligan() {
        return TUCK_COUNT;
    }

    public void beforeFirstMulligan() {
        player.drawCards(TUCK_COUNT);
    }

    @Override
    public void keep() {
        super.keep();
        CardCollection hand = new CardCollection(player.getCardsIn(ZoneType.Hand));
        for (final Card c : player.getController().tuckCardsViaMulligan(hand, tuckCardsDuringMulligan())) {
            player.getGame().getAction().moveToLibrary(c, -1, null);
        }
    }

    @Override
    public boolean canMulligan() {
        return false;
    }
}
```
