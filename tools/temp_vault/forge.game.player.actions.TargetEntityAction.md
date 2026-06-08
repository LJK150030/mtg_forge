---
aliases:
  - TargetEntityAction
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/player/actions
fqn: forge.game.player.actions.TargetEntityAction
package: forge.game.player.actions
module: forge-game
kind: Class
---

# TargetEntityAction

**Package:** `forge.game.player.actions` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class TargetEntityAction {
        +TargetEntityAction(GameEntityView cardView)
    }
    TargetEntityAction --|> PlayerAction : extends
    TargetEntityAction ..> GameEntityView : uses
```

## Relationships
**Extends:**
- [[forge.game.player.actions.PlayerAction|PlayerAction]]
**Uses:**
- [[forge.game.GameEntityView|GameEntityView]]

## Source
`forge-game/src/main/java/forge/game/player/actions/TargetEntityAction.java`

```java
package forge.game.player.actions;

import forge.game.GameEntityView;

public class TargetEntityAction extends PlayerAction {
    // TODO Add distribution damage/counters
    public TargetEntityAction(GameEntityView cardView) {
        super(cardView, "Target game entity");
    }
}
```
