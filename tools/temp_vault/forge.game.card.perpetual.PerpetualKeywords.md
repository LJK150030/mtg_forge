---
aliases:
  - PerpetualKeywords
tags:
  - java/record
  - module/forge-game
  - pkg/forge/game/card/perpetual
fqn: forge.game.card.perpetual.PerpetualKeywords
package: forge.game.card.perpetual
module: forge-game
kind: Record
---

# PerpetualKeywords

**Package:** `forge.game.card.perpetual` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Record

```mermaid
classDiagram
    class PerpetualKeywords {
        <<record>>
        +getTimestamp() long
        +applyEffect(Card c) void
    }
    PerpetualKeywords ..|> PerpetualInterface : implements
    PerpetualKeywords ..> Card : uses
```

## Relationships
**Implements:**
- [[forge.game.card.perpetual.PerpetualInterface|PerpetualInterface]]
**Uses:**
- [[forge.game.card.Card|Card]]

## Design Description

PerpetualKeywords is an immutable record that captures a "perpetual" modification to a card's keyword set—keywords to grant, keywords to strip, and a flag to remove all existing ones—stamped with a creation timestamp for ordering. As a record it provides value-based identity and concise, final state, fitting the engine's continuous-effects model where layered changes are resolved by timestamp.

It realizes the PerpetualInterface contract, exposing `getTimestamp()` for ordering against other perpetual effects and `applyEffect(Card)` to enact the change. The latter collaborates with Card, delegating to `addChangedCardKeywords` so the card itself owns the bookkeeping of its changed-keyword layers; the null final argument signals no removal-by-type. The design favors small, declarative effect objects that the card replays in timestamp order, keeping perpetual keyword logic decoupled from the broader effect-resolution machinery.

## Source
`forge-game/src/main/java/forge/game/card/perpetual/PerpetualKeywords.java`

```java
package forge.game.card.perpetual;

import java.util.List;

import forge.game.card.Card;

public record PerpetualKeywords(long timestamp, List<String> addKeywords, List<String> removeKeywords, boolean removeAll) implements PerpetualInterface {
    @Override
    public long getTimestamp() {
        return timestamp;
    }

    @Override
    public void applyEffect(Card c) {
        c.addChangedCardKeywords(addKeywords, removeKeywords, removeAll, timestamp, null);
    }
}
```
