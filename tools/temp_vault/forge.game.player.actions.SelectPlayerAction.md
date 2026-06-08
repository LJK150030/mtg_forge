---
aliases:
  - SelectPlayerAction
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/player/actions
fqn: forge.game.player.actions.SelectPlayerAction
package: forge.game.player.actions
module: forge-game
kind: Class
---

# SelectPlayerAction

**Package:** `forge.game.player.actions` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class SelectPlayerAction {
        +SelectPlayerAction(GameEntityView playerView)
    }
    SelectPlayerAction --|> PlayerAction : extends
    SelectPlayerAction ..> GameEntityView : uses
```

## Relationships
**Extends:**
- [[forge.game.player.actions.PlayerAction|PlayerAction]]
**Uses:**
- [[forge.game.GameEntityView|GameEntityView]]

## Source
`forge-game/src/main/java/forge/game/player/actions/SelectPlayerAction.java`

```java
package forge.game.player.actions;

import forge.game.GameEntityView;

public class SelectPlayerAction extends PlayerAction {
    public SelectPlayerAction(GameEntityView playerView) {
        super(playerView, "Select player");
    }

}
```
