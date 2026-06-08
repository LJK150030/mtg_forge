---
aliases:
  - DeckGenerator3Color
tags:
  - java/class
  - module/forge-core
  - pkg/forge/deck/generation
fqn: forge.deck.generation.DeckGenerator3Color
package: forge.deck.generation
module: forge-core
kind: Class
---

# DeckGenerator3Color

**Package:** `forge.deck.generation` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class DeckGenerator3Color {
        ~List~ImmutablePair~ cmcLevels
        #getLandPercentage() float
        #getCreaturePercentage() float
        #getSpellPercentage() float
        -initialize(DeckFormat format0, String clr1, String clr2, String clr3) void
        +getDeck(int size, boolean forAi) CardPool
        +DeckGenerator3Color(IDeckGenPool pool0, DeckFormat format0, Predicate~PaperCard~ formatFilter0, String clr1, String clr2, String clr3)
        +DeckGenerator3Color(IDeckGenPool pool0, DeckFormat format0, String clr1, String clr2, String clr3)
    }
    DeckGenerator3Color --|> DeckGeneratorBase : extends
    DeckGenerator3Color ..> CardPool : uses
    DeckGenerator3Color ..> ColorSet : uses
    DeckGenerator3Color ..> DeckFormat : uses
    DeckGenerator3Color ..> FilterCMC : uses
    DeckGenerator3Color ..> IDeckGenPool : uses
    DeckGenerator3Color ..> PaperCard : uses
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

DeckGenerator3Color generates a randomized three-color Constructed deck from a supplied card pool, specializing the abstract `DeckGeneratorBase` for the tri-color archetype. It pins the archetype's mana-base proportions by overriding `getLandPercentage`, `getCreaturePercentage`, and `getSpellPercentage` to 44/33/23%, and declares a fixed mana-curve template in `cmcLevels` (via `FilterCMC` buckets) that weights low-cost cards most heavily.

During construction its `initialize` routine resolves the three requested color names into a concrete `ColorSet`, using `MagicColor` bitmask arithmetic and `MyRandom` to randomly fill in or substitute colors whenever fewer than three valid, distinct ones are given. Collaborating with `IDeckGenPool`, `DeckFormat`, and `PaperCard`, the overridden `getDeck` delegates creature and spell selection to the base class, then layers in dual and basic lands and trims to the requested size, returning a populated `CardPool`. The design isolates archetype-specific tuning while reusing the shared generation pipeline.

## Source
`forge-core/src/main/java/forge/deck/generation/DeckGenerator3Color.java`

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
public class DeckGenerator3Color extends DeckGeneratorBase {
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

    public DeckGenerator3Color(IDeckGenPool pool0, DeckFormat format0, Predicate<PaperCard> formatFilter0, final String clr1, final String clr2, final String clr3) {
        super(pool0, format0, formatFilter0);
        initialize(format0,clr1,clr2,clr3);
    }

    public DeckGenerator3Color(IDeckGenPool pool0, DeckFormat format0, final String clr1, final String clr2, final String clr3) {
        super(pool0, format0);
        initialize(format0,clr1,clr2,clr3);
    }

    private void initialize(DeckFormat format0, final String clr1, final String clr2, final String clr3){
        format0.adjustCMCLevels(cmcLevels);

        int c1 = MagicColor.fromName(clr1);
        int c2 = MagicColor.fromName(clr2);
        int c3 = MagicColor.fromName(clr3);

        int rc = 0;
        int combo = c1 | c2 | c3;

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
