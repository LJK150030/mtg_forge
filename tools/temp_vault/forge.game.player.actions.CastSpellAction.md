---
aliases:
  - CastSpellAction
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/player/actions
fqn: forge.game.player.actions.CastSpellAction
package: forge.game.player.actions
module: forge-game
kind: Class
---

# CastSpellAction

**Package:** `forge.game.player.actions` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class CastSpellAction {
        +CastSpellAction(GameEntityView cardView)
    }
    CastSpellAction --|> PlayerAction : extends
    CastSpellAction ..> GameEntityView : uses
```

## Relationships
**Extends:**
- [[forge.game.player.actions.PlayerAction|PlayerAction]]
**Uses:**
- [[forge.game.GameEntityView|GameEntityView]]

## Source
`forge-game/src/main/java/forge/game/player/actions/CastSpellAction.java`

```java
package forge.game.player.actions;

import forge.game.GameEntityView;

public class CastSpellAction extends PlayerAction {
    public CastSpellAction(GameEntityView cardView) {
        super(cardView, "Cast spell");
    }
}
```
