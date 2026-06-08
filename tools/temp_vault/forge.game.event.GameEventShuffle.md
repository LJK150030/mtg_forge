---
aliases:
  - GameEventShuffle
tags:
  - java/record
  - module/forge-game
  - pkg/forge/game/event
fqn: forge.game.event.GameEventShuffle
package: forge.game.event
module: forge-game
kind: Record
---

# GameEventShuffle

**Package:** `forge.game.event` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Record

```mermaid
classDiagram
    class GameEventShuffle {
        <<record>>
        +visit(IGameEventVisitor~T~ visitor) T
        +toString() String
        +GameEventShuffle(Player player)
    }
    GameEventShuffle ..|> GameEvent : implements
    GameEventShuffle ..> IGameEventVisitor : uses
    GameEventShuffle ..> Player : uses
    GameEventShuffle ..> PlayerView : uses
```

## Relationships
**Implements:**
- [[forge.game.event.GameEvent|GameEvent]]
**Uses:**
- [[forge.game.event.IGameEventVisitor|IGameEventVisitor]]
- [[forge.game.player.Player|Player]]
- [[forge.game.player.PlayerView|PlayerView]]

## Design Description

GameEventShuffle is an immutable event record signaling that a player has shuffled their library. As a `GameEvent` implementation, it participates in the engine's visitor-based event-dispatch mechanism: its `visit` method double-dispatches to an `IGameEventVisitor`, letting observers (UI, AI, logging) react without the event itself knowing their concrete types. The record's single component is a `PlayerView`—a lightweight, view-layer snapshot of the player—rather than the live `Player`; a convenience constructor accepts a `Player` and converts it via `PlayerView.get`, decoupling event consumers from mutable game state. The overridden `toString` builds a human-readable message (e.g. "Alice shuffles their library") using `Lang` and `TextUtil` for grammatically correct, localizable phrasing.

## Source
`forge-game/src/main/java/forge/game/event/GameEventShuffle.java`

```java
package forge.game.event;

import forge.game.player.Player;
import forge.game.player.PlayerView;
import forge.util.Lang;
import forge.util.TextUtil;

public record GameEventShuffle(PlayerView player) implements GameEvent {

    public GameEventShuffle(Player player) {
        this(PlayerView.get(player));
    }

    @Override
    public <T> T visit(IGameEventVisitor<T> visitor) {
        return visitor.visit(this);
    }

    /* (non-Javadoc)
     * @see java.lang.Object#toString()
     */
    @Override
    public String toString() {
        return TextUtil.concatWithSpace(player.toString(), Lang.joinVerb(player.getName(), "shuffle"), "their library");
    }
}
```
