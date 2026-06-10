---
aliases:
  - DeckGenerator4Color
tags:
  - java/class
  - module/forge-core
  - pkg/forge/deck/generation
fqn: forge.deck.generation.DeckGenerator4Color
package: forge.deck.generation
module: forge-core
kind: Class
---

# DeckGenerator4Color

**Package:** `forge.deck.generation` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class DeckGenerator4Color {
        ~List~ImmutablePair~ cmcLevels
        #getLandPercentage() float
        #getCreaturePercentage() float
        #getSpellPercentage() float
        -initialize(DeckFormat format0, String clr1, String clr2, String clr3, String clr4) void
        +getDeck(int size, boolean forAi) CardPool
        +DeckGenerator4Color(IDeckGenPool pool0, DeckFormat format0, Predicate~PaperCard~ formatFilter0, String clr1, String clr2, String clr3, String clr4)
        +DeckGenerator4Color(IDeckGenPool pool0, DeckFormat format0, String clr1, String clr2, String clr3, String clr4)
    }
    DeckGenerator4Color --|> DeckGeneratorBase : extends
    DeckGenerator4Color ..> CardPool : uses
    DeckGenerator4Color ..> ColorSet : uses
    DeckGenerator4Color ..> DeckFormat : uses
    DeckGenerator4Color ..> FilterCMC : uses
    DeckGenerator4Color ..> IDeckGenPool : uses
    DeckGenerator4Color ..> PaperCard : uses
```

## Relationships
**Extends:**
- [[forge.deck.generation.DeckGeneratorBase|DeckGeneratorBase]]
**Uses:**
- [[forge.card.ColorSet|ColorSet]]
- [[forge.deck.CardPool|CardPool]]
- [[forge.deck.DeckFormat|DeckFormat]]
- [[forge.deck.generation.DeckGeneratorBase.FilterCMC|FilterCMC]]
- [[forge.deck.generation.IDeckGenPool|IDeckGenPool]]
- [[forge.item.PaperCard|PaperCard]]


## Design Description

DeckGenerator4Color is a concrete deck-building strategy that assembles a randomized four-color deck from a supplied card pool. Extending `DeckGeneratorBase`, it overrides the abstract mana-base ratiosâ€”44% lands, 33% creatures, 23% spellsâ€”and defines a fixed mana curve (`cmcLevels`) weighted toward cheap cards, which the active `DeckFormat` may further adjust.

Its constructors take four color names plus an `IDeckGenPool` and optional format filter, then delegate to `initialize`, which converts the names to `MagicColor` bitmasks and resolves them through `ColorSet`. Notably, when fewer than three colors are supplied it randomly fills in the remainder (and a zero-color request yields a random three-color inverse), so the generator always settles on a valid multi-color identity. `getDeck` reuses inherited helpers to add creatures, spells, dual lands, and basic lands, tracing each step and returning a `CardPool` of `PaperCard`s. The design pushes shared assembly logic into the base class, leaving this subclass responsible only for color selection and ratio tuning.

## Source
`forge-core/src/main/java/forge/deck/generation/DeckGenerator4Color.java`

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
package forge.deck.generation;

import com.google.common.collect.Lists;
import forge.card.ColorSet;
import forge.card.MagicColor;
import forge.deck.CardPool;
import forge.deck.DeckFormat;
import forge.item.PaperCard;
import forge.util.MyRandom;
import org.apache.commons.lang3.tuple.ImmutablePair;

import java.util.List;
import java.util.function.Predicate;

/**
 * <p>
 * Generate3ColorDeck class.
 * </p>
 * 
 * @author Forge
 * @version $Id$
 */
public class DeckGenerator4Color extends DeckGeneratorBase {
    @Override
    protected final float getLandPercentage() {
        return 0.44f;
    }
    @Override
    protected final float getCreaturePercentage() {
        return 0.33f;
    }
    @Override
    protected final float getSpellPercentage() {
        return 0.23f;
    }

    @SuppressWarnings("unchecked")
    final List<ImmutablePair<FilterCMC, Integer>> cmcLevels = Lists.newArrayList(
        ImmutablePair.of(new FilterCMC(0, 2), 12),
        ImmutablePair.of(new FilterCMC(3, 5), 9),
        ImmutablePair.of(new FilterCMC(6, 20), 3)
    );

    public DeckGenerator4Color(IDeckGenPool pool0, DeckFormat format0, Predicate<PaperCard> formatFilter0, final String clr1, final String clr2, final String clr3, final String clr4) {
        super(pool0, format0, formatFilter0);
        initialize(format0,clr1,clr2,clr3,clr4);
    }

    public DeckGenerator4Color(IDeckGenPool pool0, DeckFormat format0, final String clr1, final String clr2, final String clr3, final String clr4) {
        super(pool0, format0);
        initialize(format0,clr1,clr2,clr3,clr4);
    }

    private void initialize(DeckFormat format0, final String clr1, final String clr2, final String clr3, final String clr4){
        format0.adjustCMCLevels(cmcLevels);

        int c1 = MagicColor.fromName(clr1);
        int c2 = MagicColor.fromName(clr2);
        int c3 = MagicColor.fromName(clr3);
        int c4 = MagicColor.fromName(clr4);

        int rc = 0;
        int combo = c1 | c2 | c3 | c4;

        ColorSet param = ColorSet.fromMask(combo);
        switch(param.countColors()) {
            case 3:
                colors = param;
                return;

            case 0:
                int color1 = MyRandom.getRandom().nextInt(5);
                int color2 = (color1 + 1 + MyRandom.getRandom().nextInt(4)) % 5;
                colors = ColorSet.fromMask(MagicColor.WHITE << color1 | MagicColor.WHITE << color2).inverse();
                return;

            case 1:
                do {
                    rc = MagicColor.WHITE << MyRandom.getRandom().nextInt(5);
                } while ( rc == combo );
                combo |= rc;

                //$FALL-THROUGH$
            case 2:
                do {
                    rc = MagicColor.WHITE << MyRandom.getRandom().nextInt(5);
                } while ( (rc & combo) != 0 );
                combo |= rc;
                break;
        }
        colors = ColorSet.fromMask(combo);
    }

    @Override
    public final CardPool getDeck(final int size, final boolean forAi) {
        addCreaturesAndSpells(size, cmcLevels, forAi);

        // Add lands
        int numLands = Math.round(size * getLandPercentage());
        adjustDeckSize(size - numLands);
        trace.append("numLands:").append(numLands).append("\n");

        // Add dual lands
        List<String> duals = getDualLandList(forAi);
        for (String s : duals) {
            this.cardCounts.put(s, 0);
        }

        int dblsAdded = addSomeStr((numLands / 4), duals);
        numLands -= dblsAdded;

        addBasicLand(numLands);
        adjustDeckSize(size);
        trace.append("DeckSize:").append(tDeck.countAll()).append("\n");
        return tDeck;
    }
}
```

## Python
`forge/deck/generation/DeckGenerator4Color.py`

```python
from forge.deck.generation.DeckGeneratorBase import DeckGeneratorBase
from forge.card.ColorSet import ColorSet
from forge.card.MagicColor import MagicColor
from forge.deck.CardPool import CardPool
from forge.deck.DeckFormat import DeckFormat
from forge.item.PaperCard import PaperCard
from forge.util.MyRandom import MyRandom
from forge.deck.generation.IDeckGenPool import IDeckGenPool
from forge.deck.generation.DeckGeneratorBase import FilterCMC

from typing import Callable, List, Tuple


class DeckGenerator4Color(DeckGeneratorBase):
    def getLandPercentage(self) -> float:
        return 0.44

    def getCreaturePercentage(self) -> float:
        return 0.33

    def getSpellPercentage(self) -> float:
        return 0.23

    def __init__(self, pool0: IDeckGenPool, format0: DeckFormat, *args):
        # Two constructors:
        #   (pool0, format0, formatFilter0, clr1, clr2, clr3, clr4)
        #   (pool0, format0, clr1, clr2, clr3, clr4)
        self.cmcLevels: List[Tuple[FilterCMC, int]] = [
            (FilterCMC(0, 2), 12),
            (FilterCMC(3, 5), 9),
            (FilterCMC(6, 20), 3),
        ]

        if len(args) == 5:
            formatFilter0, clr1, clr2, clr3, clr4 = args
            super().__init__(pool0, format0, formatFilter0)
        else:
            clr1, clr2, clr3, clr4 = args
            super().__init__(pool0, format0)

        self.initialize(format0, clr1, clr2, clr3, clr4)

    def initialize(self, format0: DeckFormat, clr1: str, clr2: str, clr3: str, clr4: str) -> None:
        format0.adjustCMCLevels(self.cmcLevels)

        c1 = MagicColor.fromName(clr1)
        c2 = MagicColor.fromName(clr2)
        c3 = MagicColor.fromName(clr3)
        c4 = MagicColor.fromName(clr4)

        rc = 0
        combo = c1 | c2 | c3 | c4

        param = ColorSet.fromMask(combo)
        count = param.countColors()
        if count == 3:
            self.colors = param
            return

        elif count == 0:
            color1 = MyRandom.getRandom().nextInt(5)
            color2 = (color1 + 1 + MyRandom.getRandom().nextInt(4)) % 5
            self.colors = ColorSet.fromMask(MagicColor.WHITE << color1 | MagicColor.WHITE << color2).inverse()
            return

        elif count == 1:
            while True:
                rc = MagicColor.WHITE << MyRandom.getRandom().nextInt(5)
                if rc != combo:
                    break
            combo |= rc

            # $FALL-THROUGH$
            while True:
                rc = MagicColor.WHITE << MyRandom.getRandom().nextInt(5)
                if (rc & combo) == 0:
                    break
            combo |= rc

        elif count == 2:
            while True:
                rc = MagicColor.WHITE << MyRandom.getRandom().nextInt(5)
                if (rc & combo) == 0:
                    break
            combo |= rc

        self.colors = ColorSet.fromMask(combo)

    def getDeck(self, size: int, forAi: bool) -> CardPool:
        self.addCreaturesAndSpells(size, self.cmcLevels, forAi)

        # Add lands
        numLands = round(size * self.getLandPercentage())
        self.adjustDeckSize(size - numLands)
        self.trace.append("numLands:").append(numLands).append("\n")

        # Add dual lands
        duals = self.getDualLandList(forAi)
        for s in duals:
            self.cardCounts.put(s, 0)

        dblsAdded = self.addSomeStr((numLands // 4), duals)
        numLands -= dblsAdded

        self.addBasicLand(numLands)
        self.adjustDeckSize(size)
        self.trace.append("DeckSize:").append(self.tDeck.countAll()).append("\n")
        return self.tDeck
```
