---
aliases:
  - ReplacePlaneswalk
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/replacement
fqn: forge.game.replacement.ReplacePlaneswalk
package: forge.game.replacement
module: forge-game
kind: Class
---

# ReplacePlaneswalk

**Package:** `forge.game.replacement` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class ReplacePlaneswalk {
        +canReplace(Map~AbilityKey,Object~ runParams) boolean
        +setReplacingObjects(Map~AbilityKey,Object~ runParams, SpellAbility sa) void
        +ReplacePlaneswalk(Map~String,String~ mapParams, Card host, boolean intrinsic)
    }
    ReplacePlaneswalk --|> ReplacementEffect : extends
    ReplacePlaneswalk ..> AbilityKey : uses
    ReplacePlaneswalk ..> Card : uses
    ReplacePlaneswalk ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.replacement.ReplacementEffect|ReplacementEffect]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Source
`forge-game/src/main/java/forge/game/replacement/ReplacePlaneswalk.java`

```java
package forge.game.replacement;

import forge.game.ability.AbilityKey;
import forge.game.card.Card;
import forge.game.spellability.SpellAbility;

import java.util.Map;

public class ReplacePlaneswalk extends ReplacementEffect {

    public ReplacePlaneswalk(final Map<String, String> mapParams, final Card host, final boolean intrinsic) {
        super(mapParams, host, intrinsic);
    }

    @Override
    public boolean canReplace(Map<AbilityKey, Object> runParams) {
        if (!matchesValidParam("ValidPlayer", runParams.get(AbilityKey.Affected))) {
            return false;
        }
        if (!matchesValidParam("ValidCause", runParams.get(AbilityKey.Cause))) {
            return false;
        }
        return true;
    }

    @Override
    public void setReplacingObjects(Map<AbilityKey, Object> runParams, SpellAbility sa) {
        sa.setReplacingObject(AbilityKey.Cause, runParams.get(AbilityKey.Cause));
    }

}
```
