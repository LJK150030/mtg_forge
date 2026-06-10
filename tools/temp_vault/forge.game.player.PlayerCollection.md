---
aliases:
  - PlayerCollection
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/player
fqn: forge.game.player.PlayerCollection
package: forge.game.player
module: forge-game
kind: Class
---

# PlayerCollection

**Package:** `forge.game.player` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class PlayerCollection {
        -long serialVersionUID
        +getCardsIn(ZoneType zone) CardCollection
        +getCardsIn(Iterable~ZoneType~ zones) CardCollection
        +getCreaturesInPlay() CardCollection
        +filter(Predicate~Player~ pred) PlayerCollection
        +min(Comparator~Player~ comp) Player
        +max(Comparator~Player~ comp) Player
        +min(Function~Player,Integer~ func) Integer
        +max(Function~Player,Integer~ func) Integer
        +sum(Function~Player,Integer~ func) Integer
        +PlayerCollection()
        +PlayerCollection(Iterable~Player~ players)
        +PlayerCollection(Player player)
    }
    PlayerCollection --|> FCollection : extends
    PlayerCollection ..> CardCollection : uses
    PlayerCollection ..> Player : uses
    PlayerCollection ..> ZoneType : uses
```

## Relationships
**Extends:**
- [[forge.util.collect.FCollection|FCollection]]
**Uses:**
- [[forge.game.card.CardCollection|CardCollection]]
- [[forge.game.player.Player|Player]]
- [[forge.game.zone.ZoneType|ZoneType]]

## Design Description

PlayerCollection is a specialized, serializable container of `Player` objects that extends the generic `FCollection<Player>` framework, inheriting its ordered, set-like storage and exposing convenience constructors for building a collection from nothing, an existing iterable, or a single player. Its responsibility is to add player-domain operations on top of that base: aggregating cards across all contained players (`getCardsIn`, `getCreaturesInPlay`) into a unified `CardCollection`, and providing functional-style query helpers for filtering by `Predicate`, selecting extremes via `Comparator`, and computing min/max/sum over integer-valued `Function`s.

The design intent is to keep player-group logic cohesive and fluent: `filter` returns a new `PlayerCollection` to support chaining, comparator-based selectors guard against emptiness by returning null, and value aggregations delegate to the shared `Aggregates` utility. An author's TODO notes these aggregate methods could be hoisted into `FCollectionView`, signaling awareness that the same patterns recur across collaborating collection types.

## Source
`forge-game/src/main/java/forge/game/player/PlayerCollection.java`

```java
package forge.game.player;

import java.util.Collections;
import java.util.Comparator;
import java.util.function.Function;
import java.util.function.Predicate;

import forge.game.card.CardCollection;
import forge.game.zone.ZoneType;
import forge.util.Aggregates;
import forge.util.IterableUtil;
import forge.util.collect.FCollection;

public class PlayerCollection extends FCollection<Player> {

    private static final long serialVersionUID = -4374566955977201748L;

    public PlayerCollection() {
    }
    
    public PlayerCollection(Iterable<Player> players) {
        this.addAll(players); 
    }

    public PlayerCollection(Player player) {
        this.add(player);
    }

    // card collection functions
    public final CardCollection getCardsIn(ZoneType zone) {
        CardCollection result = new CardCollection();
        for (Player p : this) {
            result.addAll(p.getCardsIn(zone));
        }
        return result;
    }

    public final CardCollection getCardsIn(Iterable<ZoneType> zones) {
        CardCollection result = new CardCollection();
        for (Player p : this) {
            result.addAll(p.getCardsIn(zones));
        }
        return result;
    }
    
    public final CardCollection getCreaturesInPlay() {
        CardCollection result = new CardCollection();
        for (Player p : this) {
            result.addAll(p.getCreaturesInPlay());
        }
        return result;
    }
    
    // filter functions with predicate
    public PlayerCollection filter(Predicate<Player> pred) {
        return new PlayerCollection(IterableUtil.filter(this, pred));
    }
    
    // sort functions with Comparator
    public Player min(Comparator<Player> comp) {
        if (this.isEmpty()) return null;
        return Collections.min(this, comp);
    }
    public Player max(Comparator<Player> comp) {
        if (this.isEmpty()) return null;
        return Collections.max(this, comp);
    }
    
    // value functions with Function
    //TODO: Could probably move these up to FCollectionView, apply them, and trim off a bunch of "Aggregates" clauses.
    public Integer min(Function<Player, Integer> func) {
        return Aggregates.min(this, func);
    }
    public Integer max(Function<Player, Integer> func) {
        return Aggregates.max(this, func);
    }
    public Integer sum(Function<Player, Integer> func) {
        return Aggregates.sum(this, func);
    }
}
```

## Python
`forge/game/player/PlayerCollection.py`

```python
from forge.game.card.CardCollection import CardCollection
from forge.game.player.Player import Player
from forge.game.zone.ZoneType import ZoneType
from forge.util.Aggregates import Aggregates
from forge.util.IterableUtil import IterableUtil
from forge.util.collect.FCollection import FCollection


class PlayerCollection(FCollection):

    serialVersionUID = -4374566955977201748

    def __init__(self, arg=None):
        super().__init__()
        if arg is None:
            pass
        elif isinstance(arg, Player):
            self.add(arg)
        else:
            self.addAll(arg)

    # card collection functions
    def getCardsIn(self, zone):
        result = CardCollection()
        for p in self:
            result.addAll(p.getCardsIn(zone))
        return result

    def getCardsIn(self, zones):
        result = CardCollection()
        for p in self:
            result.addAll(p.getCardsIn(zones))
        return result

    def getCreaturesInPlay(self):
        result = CardCollection()
        for p in self:
            result.addAll(p.getCreaturesInPlay())
        return result

    # filter functions with predicate
    def filter(self, pred):
        return PlayerCollection(IterableUtil.filter(self, pred))

    # sort functions with Comparator
    def min(self, comp):
        if self.isEmpty():
            return None
        return min(self, key=cmp_to_key(comp))

    def max(self, comp):
        if self.isEmpty():
            return None
        return max(self, key=cmp_to_key(comp))

    # value functions with Function
    # TODO: Could probably move these up to FCollectionView, apply them, and trim off a bunch of "Aggregates" clauses.
    def min(self, func):
        return Aggregates.min(self, func)

    def max(self, func):
        return Aggregates.max(self, func)

    def sum(self, func):
        return Aggregates.sum(self, func)
```
