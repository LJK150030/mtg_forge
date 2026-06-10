---
aliases:
  - GameEventCardSacrificed
tags:
  - java/record
  - module/forge-game
  - pkg/forge/game/event
fqn: forge.game.event.GameEventCardSacrificed
package: forge.game.event
module: forge-game
kind: Record
---

# GameEventCardSacrificed

**Package:** `forge.game.event` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Record

```mermaid
classDiagram
    class GameEventCardSacrificed {
        <<record>>
        +visit(IGameEventVisitor~T~ visitor) T
        +toString() String
    }
    GameEventCardSacrificed ..|> GameEvent : implements
    GameEventCardSacrificed ..> CardView : uses
    GameEventCardSacrificed ..> IGameEventVisitor : uses
```

## Relationships
**Implements:**
- [[forge.game.event.GameEvent|GameEvent]]
**Uses:**
- [[forge.game.card.CardView|CardView]]
- [[forge.game.event.IGameEventVisitor|IGameEventVisitor]]

## Design Description

Records the sacrifice of a single card as an immutable game event. As a Java `record` implementing the `GameEvent` interface, it carries one `CardView` payload identifying the sacrificed card and participates in the event system's visitor pattern: its `visit` method dispatches to the appropriate `IGameEventVisitor` handler, letting observers react to sacrifices without the event itself knowing their concrete types. The overridden `toString` produces a human-readable summaryâ€”the card's controller followed by the sacrificed cardâ€”useful for logging and game-log display. The record form signals deliberate immutability and value semantics, fitting a fire-and-forget notification that should never be mutated after dispatch.

## Source
`forge-game/src/main/java/forge/game/event/GameEventCardSacrificed.java`

```java
package forge.game.event;

import forge.game.card.CardView;

public record GameEventCardSacrificed(CardView card) implements GameEvent {

    @Override
    public <T> T visit(IGameEventVisitor<T> visitor) {
        return visitor.visit(this);
    }

    /* (non-Javadoc)
     * @see java.lang.Object#toString()
     */
    @Override
    public String toString() {
        return "" + card.getController() + " sacrificed " + card;
    }
}
```

## Python
`forge/game/event/GameEventCardSacrificed.py`

```python
from forge.game.card.CardView import CardView
from forge.game.event.GameEvent import GameEvent
from forge.game.event.IGameEventVisitor import IGameEventVisitor


class GameEventCardSacrificed(GameEvent):

    def __init__(self, card: CardView):
        self.card = card

    def visit(self, visitor: IGameEventVisitor):
        return visitor.visit(self)

    def __str__(self) -> str:
        return "" + str(self.card.getController()) + " sacrificed " + str(self.card)

    def __repr__(self) -> str:
        return self.__str__()

    def __eq__(self, other) -> bool:
        if not isinstance(other, GameEventCardSacrificed):
            return False
        return self.card == other.card

    def __hash__(self) -> int:
        return hash(self.card)
```
