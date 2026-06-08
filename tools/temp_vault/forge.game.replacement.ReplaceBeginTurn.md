---
aliases:
  - ReplaceBeginTurn
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/replacement
fqn: forge.game.replacement.ReplaceBeginTurn
package: forge.game.replacement
module: forge-game
kind: Class
---

# ReplaceBeginTurn

**Package:** `forge.game.replacement` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class ReplaceBeginTurn {
        +canReplace(Map~AbilityKey,Object~ runParams) boolean
        +setReplacingObjects(Map~AbilityKey,Object~ runParams, SpellAbility sa) void
        +ReplaceBeginTurn(Map~String,String~ mapParams, Card host, boolean intrinsic)
    }
    ReplaceBeginTurn --|> ReplacementEffect : extends
    ReplaceBeginTurn ..> AbilityKey : uses
    ReplaceBeginTurn ..> Card : uses
    ReplaceBeginTurn ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.replacement.ReplacementEffect|ReplacementEffect]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Source
`forge-game/src/main/java/forge/game/replacement/ReplaceBeginTurn.java`

```java
package forge.game.replacement;

import java.util.Map;

import forge.game.ability.AbilityKey;
import forge.game.card.Card;
import forge.game.spellability.SpellAbility;

public class ReplaceBeginTurn extends ReplacementEffect {

    public ReplaceBeginTurn(final Map<String, String> mapParams, final Card host, final boolean intrinsic) {
        super(mapParams, host, intrinsic);
    }

    @Override
    public boolean canReplace(Map<AbilityKey, Object> runParams) {
        if (!matchesValidParam("ValidPlayer", runParams.get(AbilityKey.Affected))) {
            return false;
        }
        if (hasParam("ExtraTurn")) {
            if (!(boolean) runParams.get(AbilityKey.ExtraTurn)) {
                return false;
            }
        }
        return true;
    }

    @Override
    public void setReplacingObjects(Map<AbilityKey, Object> runParams, SpellAbility sa) {
        sa.setReplacingObject(AbilityKey.Player, runParams.get(AbilityKey.Affected));
    }
}
```
