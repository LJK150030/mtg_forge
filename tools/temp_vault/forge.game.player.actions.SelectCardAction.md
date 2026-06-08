---
aliases:
  - SelectCardAction
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/player/actions
fqn: forge.game.player.actions.SelectCardAction
package: forge.game.player.actions
module: forge-game
kind: Class
---

# SelectCardAction

**Package:** `forge.game.player.actions` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class SelectCardAction {
        +SelectCardAction(GameEntityView cardView)
    }
    SelectCardAction --|> PlayerAction : extends
    SelectCardAction ..> GameEntityView : uses
```

## Relationships
**Extends:**
- [[forge.game.player.actions.PlayerAction|PlayerAction]]
**Uses:**
- [[forge.game.GameEntityView|GameEntityView]]

## Source
`forge-game/src/main/java/forge/game/player/actions/SelectCardAction.java`

```java
package forge.game.player.actions;

import forge.game.GameEntityView;

public class SelectCardAction extends PlayerAction{
    public SelectCardAction(GameEntityView cardView) {
        super(cardView, "Select card");
    }


}
```
