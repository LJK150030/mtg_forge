---
aliases:
  - ReplaceGameWin
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/replacement
fqn: forge.game.replacement.ReplaceGameWin
package: forge.game.replacement
module: forge-game
kind: Class
---

# ReplaceGameWin

**Package:** `forge.game.replacement` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class ReplaceGameWin {
        +canReplace(Map~AbilityKey,Object~ runParams) boolean
        +ReplaceGameWin(Map~String,String~ map, Card host, boolean intrinsic)
    }
    ReplaceGameWin --|> ReplacementEffect : extends
    ReplaceGameWin ..> AbilityKey : uses
    ReplaceGameWin ..> Card : uses
```

## Relationships
**Extends:**
- [[forge.game.replacement.ReplacementEffect|ReplacementEffect]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]

## Source
`forge-game/src/main/java/forge/game/replacement/ReplaceGameWin.java`

```java
package forge.game.replacement;

import java.util.Map;

import forge.game.ability.AbilityKey;
import forge.game.card.Card;

public class ReplaceGameWin extends ReplacementEffect {

    public ReplaceGameWin(Map<String, String> map, Card host, boolean intrinsic) {
        super(map, host, intrinsic);
    }

    /* (non-Javadoc)
     * @see forge.card.replacement.ReplacementEffect#canReplace(java.util.HashMap)
     */
    @Override
    public boolean canReplace(Map<AbilityKey, Object> runParams) {
        if (!matchesValidParam("ValidPlayer", runParams.get(AbilityKey.Affected))) {
            return false;
        }

        return true;
    }

}
```
