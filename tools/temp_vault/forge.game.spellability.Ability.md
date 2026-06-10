---
aliases:
  - Ability
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/spellability
fqn: forge.game.spellability.Ability
package: forge.game.spellability
module: forge-game
kind: Class
---

# Ability

**Package:** `forge.game.spellability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class Ability {
        +canPlay() boolean
        #Ability(Card sourceCard, ManaCost manaCost)
        #Ability(Card sourceCard, ManaCost manaCost, CardState state)
        #Ability(Card sourceCard, ManaCost manaCost, SpellAbilityView view0)
        #Ability(Card sourceCard, Cost cost)
        #Ability(Card sourceCard, Cost cost, SpellAbilityView view0)
    }
    Ability --|> SpellAbility : extends
    Ability ..> Card : uses
    Ability ..> CardState : uses
    Ability ..> Cost : uses
    Ability ..> Game : uses
    Ability ..> ManaCost : uses
    Ability ..> SpellAbilityView : uses
```

## Relationships
**Extends:**
- [[forge.game.spellability.SpellAbility|SpellAbility]]
**Uses:**
- [[forge.card.mana.ManaCost|ManaCost]]
- [[forge.game.Game|Game]]
- [[forge.game.card.Card|Card]]
- [[forge.game.card.CardState|CardState]]
- [[forge.game.cost.Cost|Cost]]
- [[forge.game.spellability.SpellAbilityView|SpellAbilityView]]

## Design Description

Ability is an abstract specialization of SpellAbility representing activated abilities of a card. It supplies a family of protected constructors that adapt the various ways an ability can be definedâ€”from a raw ManaCost (wrapped into a Cost) or an explicit Cost, optionally with an associated CardState or a SpellAbilityViewâ€”delegating each to the canonical SpellAbility constructor so subclasses need not duplicate this setup.

Its primary behavioral contribution is overriding canPlay() to enforce timing legality: it consults the activating player's Game to reject activation while a split-second effect is on the stack (unless the ability is a mana ability), and otherwise permits play only when the host Card is in play and not face-down. The class thus centralizes the common construction and playability rules shared by concrete ability types.

## Source
`forge-game/src/main/java/forge/game/spellability/Ability.java`

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

import forge.card.mana.ManaCost;
import forge.game.Game;
import forge.game.card.Card;
import forge.game.card.CardState;
import forge.game.cost.Cost;

/**
 * <p>
 * Abstract Ability class.
 * </p>
 * 
 * @author Forge
 * @version $Id$
 */
public abstract class Ability extends SpellAbility {

    protected Ability(final Card sourceCard, final ManaCost manaCost) {
        this(sourceCard, new Cost(manaCost, true), null);
    }
    protected Ability(final Card sourceCard, final ManaCost manaCost, final CardState state) {
        super(sourceCard, new Cost(manaCost, true), null, state);
    }
    protected Ability(final Card sourceCard, final ManaCost manaCost, SpellAbilityView view0) {
        this(sourceCard, new Cost(manaCost, true), view0);
    }
    protected Ability(final Card sourceCard, final Cost cost) {
        this(sourceCard, cost, null);
    }
    protected Ability(final Card sourceCard, final Cost cost, SpellAbilityView view0) {
        super(sourceCard, cost, view0);
    }

    /** {@inheritDoc} */
    @Override
    public boolean canPlay() {
        final Game game = getActivatingPlayer().getGame();
        if (game.getStack().isSplitSecondOnStack() && !this.isManaAbility()) {
            return false;
        }

        return this.getHostCard().isInPlay() && !this.getHostCard().isFaceDown();
    }

}
```

## Python
`forge/game/spellability/Ability.py`

```python
package forge.game.spellability

from forge.card.mana.ManaCost import ManaCost
from forge.game.Game import Game
from forge.game.card.Card import Card
from forge.game.card.CardState import CardState
from forge.game.cost.Cost import Cost
from forge.game.spellability.SpellAbility import SpellAbility
from forge.game.spellability.SpellAbilityView import SpellAbilityView


class Ability(SpellAbility):

    def __init__(self, sourceCard: Card, *args):
        if len(args) == 1 and isinstance(args[0], ManaCost):
            manaCost = args[0]
            self.__init__(sourceCard, Cost(manaCost, True), None)
        elif len(args) == 2 and isinstance(args[0], ManaCost) and isinstance(args[1], CardState):
            manaCost = args[0]
            state = args[1]
            super().__init__(sourceCard, Cost(manaCost, True), None, state)
        elif len(args) == 2 and isinstance(args[0], ManaCost):
            manaCost = args[0]
            view0 = args[1]
            self.__init__(sourceCard, Cost(manaCost, True), view0)
        elif len(args) == 1 and isinstance(args[0], Cost):
            cost = args[0]
            self.__init__(sourceCard, cost, None)
        elif len(args) == 2 and isinstance(args[0], Cost):
            cost = args[0]
            view0 = args[1]
            super().__init__(sourceCard, cost, view0)
        else:
            raise TypeError("Invalid arguments to Ability constructor")

    def canPlay(self) -> bool:
        game = self.getActivatingPlayer().getGame()
        if game.getStack().isSplitSecondOnStack() and not self.isManaAbility():
            return False

        return self.getHostCard().isInPlay() and not self.getHostCard().isFaceDown()
```
