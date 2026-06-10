---
aliases:
  - LandAbility
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/spellability
fqn: forge.game.spellability.LandAbility
package: forge.game.spellability
module: forge-game
kind: Class
---

# LandAbility

**Package:** `forge.game.spellability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class LandAbility {
        +isLandAbility() boolean
        +isSecondary() boolean
        +canPlay() boolean
        +resolve() void
        +toUnsuppressedString() String
        +getAlternateHost(Card source) Card
        +LandAbility(Card sourceCard, CardState state)
    }
    LandAbility --|> AbilityStatic : extends
    LandAbility ..> Card : uses
    LandAbility ..> CardState : uses
    LandAbility ..> CardStateName : uses
    LandAbility ..> Localizer : uses
    LandAbility ..> Player : uses
    LandAbility ..> StaticAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.spellability.AbilityStatic|AbilityStatic]]
**Uses:**
- [[forge.card.CardStateName|CardStateName]]
- [[forge.game.card.Card|Card]]
- [[forge.game.card.CardState|CardState]]
- [[forge.game.player.Player|Player]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]
- [[forge.util.Localizer|Localizer]]

## Design Description

Land plays implemented as a static ability. LandAbility extends AbilityStatic to model the act of playing a land from hand as a no-cost, special action rather than a stack-using spell; its constructor restricts activation to the Hand zone and marks the ability as secondary and as a land ability. canPlay defers to the activating Player's canPlayLand check (resolving any alternate host first), while resolve delegates the actual land placement to Player.playLand, tracks mayplay usage, and resets a non-permanent result to its original state.

Notable design intent appears in getAlternateHost, which uses last-known-information copies (via CardCopyService) to evaluate face-down exiled cards and modal/double-faced alternate states without mutating the real Card. It collaborates with CardState/CardStateName to support modal permanents and with StaticAbility (getMayPlay) to render contextual "play land by [source]" descriptions, localized through Localizer.

## Source
`forge-game/src/main/java/forge/game/spellability/LandAbility.java`

```java
/*
 * Forge: Play Magic: the Gathering.
 * Copyright (C) 2011  Forge Team
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package forge.game.spellability;

import forge.card.CardStateName;
import forge.card.mana.ManaCost;
import forge.game.card.Card;
import forge.game.card.CardCopyService;
import forge.game.card.CardState;
import forge.game.player.Player;
import forge.game.staticability.StaticAbility;
import forge.game.zone.ZoneType;
import forge.util.CardTranslation;
import forge.util.Localizer;
import org.apache.commons.lang3.StringUtils;

import java.util.Objects;

public class LandAbility extends AbilityStatic {

    public LandAbility(Card sourceCard, CardState state) {
        super(sourceCard, ManaCost.NO_COST, state);

        getRestrictions().setZone(ZoneType.Hand);
    }

    @Override
    public boolean isLandAbility() { return true; }

    @Override
    public boolean isSecondary() {
        return true;
    }

    @Override
    public boolean canPlay() {
        Card land = this.getHostCard();
        final Player p = this.getActivatingPlayer();
        if (p == null || land.isInZone(ZoneType.Battlefield)) {
            return false;
        }
 
        land = Objects.requireNonNullElse(getAlternateHost(land), land);

        return p.canPlayLand(land, false, this);
    }

    @Override
    public void resolve() {
        getHostCard().setSplitStateToPlayAbility(this);
        final Card result = getActivatingPlayer().playLand(getHostCard(), this);

        // increase mayplay used
        if (getMayPlay() != null) {
            getMayPlay().incMayPlayTurn();
        }
        // if land isn't in battlefield try to reset the card state
        if (result != null && !result.isInPlay()) {
            result.setState(CardStateName.Original, true);
        }
    }

    @Override
    public String toUnsuppressedString() {
        Localizer localizer = Localizer.getInstance();
        StringBuilder sb = new StringBuilder(StringUtils.capitalize(localizer.getMessage("lblPlayLand")));

        if (getHostCard().isModal()) {
            sb.append(" (").append(CardTranslation.getTranslatedName(getCardState().getName())).append(")");
        }

        StaticAbility sta = getMayPlay();
        if (sta != null) {
            Card source = sta.getHostCard();
            if (!source.equals(getHostCard())) {
                sb.append(" by ");
                if (source.isImmutable() && source.getEffectSource() != null) {
                    sb.append(source.getEffectSource());
                } else {
                    sb.append(source);
                }
                if (sta.hasParam("MayPlayText")) {
                    sb.append(" (").append(sta.getParam("MayPlayText")).append(")");
                }
            }
        }
        return sb.toString();
    }

    @Override
    public Card getAlternateHost(Card source) {
        boolean lkicheck = false;

        if (source.isFaceDown() && source.isInZone(ZoneType.Exile)) {
            if (!source.isLKI()) {
                source = CardCopyService.getLKICopy(source);
            }

            source.forceTurnFaceUp();
            lkicheck = true;
        }

        if (getCardState() != null && source.getCurrentStateName() != getCardStateName()) {
            if (!source.isLKI()) {
                source = CardCopyService.getLKICopy(source);
            }
            CardStateName stateName = getCardState().getStateName();
            if (!source.hasState(stateName)) {
                source.addAlternateState(stateName, false);
                source.getState(stateName).copyFrom(getHostCard().getState(stateName), true);
            }

            source.setState(stateName, false);
            if (getHostCard().isDoubleFaced()) {
                source.setBackSide(getHostCard().getRules().getSplitType().getChangedStateName().equals(stateName));
            }

            // need to reset CMC
            source.setLKICMC(-1);
            source.setLKICMC(source.getCMC());
            lkicheck = true;
        }

        return lkicheck ? source : null;
    }
}
```

## Python
`forge/game/spellability/LandAbility.py`

```python
from forge.card.CardStateName import CardStateName
from forge.card.mana.ManaCost import ManaCost
from forge.game.card.Card import Card
from forge.game.card.CardCopyService import CardCopyService
from forge.game.card.CardState import CardState
from forge.game.player.Player import Player
from forge.game.spellability.AbilityStatic import AbilityStatic
from forge.game.staticability.StaticAbility import StaticAbility
from forge.game.zone.ZoneType import ZoneType
from forge.util.CardTranslation import CardTranslation
from forge.util.Localizer import Localizer


class LandAbility(AbilityStatic):

    def __init__(self, sourceCard: Card, state: CardState):
        super().__init__(sourceCard, ManaCost.NO_COST, state)

        self.getRestrictions().setZone(ZoneType.Hand)

    def isLandAbility(self) -> bool:
        return True

    def isSecondary(self) -> bool:
        return True

    def canPlay(self) -> bool:
        land = self.getHostCard()
        p = self.getActivatingPlayer()
        if p is None or land.isInZone(ZoneType.Battlefield):
            return False

        alternate = self.getAlternateHost(land)
        land = alternate if alternate is not None else land

        return p.canPlayLand(land, False, self)

    def resolve(self) -> None:
        self.getHostCard().setSplitStateToPlayAbility(self)
        result = self.getActivatingPlayer().playLand(self.getHostCard(), self)

        # increase mayplay used
        if self.getMayPlay() is not None:
            self.getMayPlay().incMayPlayTurn()
        # if land isn't in battlefield try to reset the card state
        if result is not None and not result.isInPlay():
            result.setState(CardStateName.Original, True)

    def toUnsuppressedString(self) -> str:
        localizer = Localizer.getInstance()
        sb = []
        sb.append(StringUtils.capitalize(localizer.getMessage("lblPlayLand")))

        if self.getHostCard().isModal():
            sb.append(" (")
            sb.append(CardTranslation.getTranslatedName(self.getCardState().getName()))
            sb.append(")")

        sta = self.getMayPlay()
        if sta is not None:
            source = sta.getHostCard()
            if not source.equals(self.getHostCard()):
                sb.append(" by ")
                if source.isImmutable() and source.getEffectSource() is not None:
                    sb.append(str(source.getEffectSource()))
                else:
                    sb.append(str(source))
                if sta.hasParam("MayPlayText"):
                    sb.append(" (")
                    sb.append(sta.getParam("MayPlayText"))
                    sb.append(")")
        return "".join(sb)

    def getAlternateHost(self, source: Card) -> Card:
        lkicheck = False

        if source.isFaceDown() and source.isInZone(ZoneType.Exile):
            if not source.isLKI():
                source = CardCopyService.getLKICopy(source)

            source.forceTurnFaceUp()
            lkicheck = True

        if self.getCardState() is not None and source.getCurrentStateName() != self.getCardStateName():
            if not source.isLKI():
                source = CardCopyService.getLKICopy(source)
            stateName = self.getCardState().getStateName()
            if not source.hasState(stateName):
                source.addAlternateState(stateName, False)
                source.getState(stateName).copyFrom(self.getHostCard().getState(stateName), True)

            source.setState(stateName, False)
            if self.getHostCard().isDoubleFaced():
                source.setBackSide(self.getHostCard().getRules().getSplitType().getChangedStateName().equals(stateName))

            # need to reset CMC
            source.setLKICMC(-1)
            source.setLKICMC(source.getCMC())
            lkicheck = True

        return source if lkicheck else None
```
