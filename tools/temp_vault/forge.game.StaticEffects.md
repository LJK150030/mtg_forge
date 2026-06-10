---
aliases:
  - StaticEffects
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game
fqn: forge.game.StaticEffects
package: forge.game
module: forge-game
kind: Class
---

# StaticEffects

**Package:** `forge.game` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StaticEffects {
        -Map~StaticAbility,StaticEffect~ staticEffects
        +clearStaticEffects(Set~Card~ affectedCards, Map~StaticAbilityLayer,Set~ affectedPerLayer) void
        +getStaticEffect(StaticAbility staticAbility) StaticEffect
        +getEffects() Iterable~StaticEffect~
        +removeStaticEffect(StaticAbility staticAbility, StaticAbilityLayer layer, boolean removeFull) boolean
        -updateCaches(Map~StaticAbilityLayer,Set~ affectedPerLayer) void
    }
    StaticEffects ..> Card : uses
    StaticEffects ..> CardCollection : uses
    StaticEffects ..> StaticAbility : uses
    StaticEffects ..> StaticAbilityLayer : uses
    StaticEffects ..> StaticEffect : uses
```

## Relationships
**Uses:**
- [[forge.game.StaticEffect|StaticEffect]]
- [[forge.game.card.Card|Card]]
- [[forge.game.card.CardCollection|CardCollection]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]
- [[forge.game.staticability.StaticAbilityLayer|StaticAbilityLayer]]

## Design Description

StaticEffects is a registry that owns the per-game collection of active static abilities, holding a one-to-one `Map<StaticAbility, StaticEffect>` and acting as the central bookkeeping point for Forge's continuous-effect (static ability) system. It lazily creates a StaticEffect on demand via `getStaticEffect`, exposes the live set through `getEffects`, and supports removing effects either wholesale (`clearStaticEffects`) or per-layer (`removeStaticEffect`), delegating the actual unwind work to each StaticEffect.

A notable design intent is the layer-aware cache maintenance: removal operations accumulate the affected Cards keyed by StaticAbilityLayer, and `updateCaches` refreshes each Card's keyword cache for the TEXT, TYPE, and ABILITIES layers. This keeps the engine's keyword state consistent with Magic's layered continuous-effect rules, collaborating with Card and CardCollection while leaving layer semantics to StaticAbilityLayer.

## Source
`forge-game/src/main/java/forge/game/StaticEffects.java`

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
package forge.game;

import java.util.Map;
import java.util.Set;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

import forge.game.card.Card;
import forge.game.card.CardCollection;
import forge.game.staticability.StaticAbility;
import forge.game.staticability.StaticAbilityLayer;

/**
 * <p>
 * StaticEffects class.
 * </p>
 * 
 * @author Forge
 * @version $Id$
 */
public class StaticEffects {

    // **************** StaticAbility system **************************
    private final Map<StaticAbility, StaticEffect> staticEffects = Maps.newHashMap();

    public final void clearStaticEffects(final Set<Card> affectedCards, Map<StaticAbilityLayer, Set<Card>> affectedPerLayer) {
        // remove all static effects
        for (final StaticEffect se : staticEffects.values()) {
            se.remove(affectedPerLayer).forEach(affectedCards::add);
        }
        this.staticEffects.clear();
        updateCaches(affectedPerLayer);
    }

    /**
     * Add a static effect to the list of static effects.
     * 
     * @param staticAbility
     *            a {@link StaticAbility}.
     */
    public final StaticEffect getStaticEffect(final StaticAbility staticAbility) {
        final StaticEffect currentEffect = staticEffects.get(staticAbility);
        if (currentEffect != null) {
            return currentEffect;
        }

        final StaticEffect newEffect = new StaticEffect(staticAbility);
        this.staticEffects.put(staticAbility, newEffect);
        return newEffect;
    }

    public Iterable<StaticEffect> getEffects() {
        return staticEffects.values();
    }

    public boolean removeStaticEffect(final StaticAbility staticAbility, final StaticAbilityLayer layer, final boolean removeFull) {
        final StaticEffect currentEffect;
        if (removeFull) {
            currentEffect = staticEffects.remove(staticAbility);
        } else {
            currentEffect = staticEffects.get(staticAbility);
        }
        if (currentEffect == null) {
            return false;
        }
        Map<StaticAbilityLayer, Set<Card>> affectedPerLayer = Maps.newHashMap();
        currentEffect.remove(affectedPerLayer, Lists.newArrayList(layer));
        updateCaches(affectedPerLayer);
        return true;
    }

    private void updateCaches(Map<StaticAbilityLayer, Set<Card>> affectedPerLayer) {
        CardCollection affectedKeywordsBefore = new CardCollection();
        if (affectedPerLayer.containsKey(StaticAbilityLayer.TEXT)) {
            affectedKeywordsBefore.addAll(affectedPerLayer.get(StaticAbilityLayer.TEXT));
        }
        if (affectedPerLayer.containsKey(StaticAbilityLayer.TYPE)) {
            // setting Basic Land Type case
            affectedKeywordsBefore.addAll(affectedPerLayer.get(StaticAbilityLayer.TYPE));
        }
        if (affectedPerLayer.containsKey(StaticAbilityLayer.ABILITIES)) {
            affectedKeywordsBefore.addAll(affectedPerLayer.get(StaticAbilityLayer.ABILITIES));
        }
        affectedKeywordsBefore.forEach(Card::updateKeywordsCache);
    }
}
```

## Python
`forge/game/StaticEffects.py`

```python
from typing import Iterable

from forge.game.StaticEffect import StaticEffect
from forge.game.card.Card import Card
from forge.game.card.CardCollection import CardCollection
from forge.game.staticability.StaticAbility import StaticAbility
from forge.game.staticability.StaticAbilityLayer import StaticAbilityLayer


class StaticEffects:

    # **************** StaticAbility system **************************
    def __init__(self):
        self.staticEffects: dict[StaticAbility, StaticEffect] = {}

    def clearStaticEffects(self, affectedCards: set[Card], affectedPerLayer: dict[StaticAbilityLayer, set[Card]]) -> None:
        # remove all static effects
        for se in self.staticEffects.values():
            for c in se.remove(affectedPerLayer):
                affectedCards.add(c)
        self.staticEffects.clear()
        self.updateCaches(affectedPerLayer)

    def getStaticEffect(self, staticAbility: StaticAbility) -> StaticEffect:
        currentEffect = self.staticEffects.get(staticAbility)
        if currentEffect is not None:
            return currentEffect

        newEffect = StaticEffect(staticAbility)
        self.staticEffects[staticAbility] = newEffect
        return newEffect

    def getEffects(self) -> Iterable[StaticEffect]:
        return self.staticEffects.values()

    def removeStaticEffect(self, staticAbility: StaticAbility, layer: StaticAbilityLayer, removeFull: bool) -> bool:
        if removeFull:
            currentEffect = self.staticEffects.pop(staticAbility, None)
        else:
            currentEffect = self.staticEffects.get(staticAbility)
        if currentEffect is None:
            return False
        affectedPerLayer: dict[StaticAbilityLayer, set[Card]] = {}
        currentEffect.remove(affectedPerLayer, [layer])
        self.updateCaches(affectedPerLayer)
        return True

    def updateCaches(self, affectedPerLayer: dict[StaticAbilityLayer, set[Card]]) -> None:
        affectedKeywordsBefore = CardCollection()
        if StaticAbilityLayer.TEXT in affectedPerLayer:
            affectedKeywordsBefore.addAll(affectedPerLayer[StaticAbilityLayer.TEXT])
        if StaticAbilityLayer.TYPE in affectedPerLayer:
            # setting Basic Land Type case
            affectedKeywordsBefore.addAll(affectedPerLayer[StaticAbilityLayer.TYPE])
        if StaticAbilityLayer.ABILITIES in affectedPerLayer:
            affectedKeywordsBefore.addAll(affectedPerLayer[StaticAbilityLayer.ABILITIES])
        for card in affectedKeywordsBefore:
            card.updateKeywordsCache()
```
