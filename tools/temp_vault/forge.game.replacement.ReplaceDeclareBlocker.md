---
aliases:
  - ReplaceDeclareBlocker
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/replacement
fqn: forge.game.replacement.ReplaceDeclareBlocker
package: forge.game.replacement
module: forge-game
kind: Class
---

# ReplaceDeclareBlocker

**Package:** `forge.game.replacement` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class ReplaceDeclareBlocker {
        +canReplace(Map~AbilityKey,Object~ runParams) boolean
        +setReplacingObjects(Map~AbilityKey,Object~ runParams, SpellAbility sa) void
        +ReplaceDeclareBlocker(Map~String,String~ mapParams, Card host, boolean intrinsic)
    }
    ReplaceDeclareBlocker --|> ReplacementEffect : extends
    ReplaceDeclareBlocker ..> AbilityKey : uses
    ReplaceDeclareBlocker ..> Card : uses
    ReplaceDeclareBlocker ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.replacement.ReplacementEffect|ReplacementEffect]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Source
`forge-game/src/main/java/forge/game/replacement/ReplaceDeclareBlocker.java`

```java
package forge.game.replacement;

import java.util.Map;

import forge.game.ability.AbilityKey;
import forge.game.card.Card;
import forge.game.spellability.SpellAbility;

public class ReplaceDeclareBlocker extends ReplacementEffect {

    public ReplaceDeclareBlocker(final Map<String, String> mapParams, final Card host, final boolean intrinsic) {
        super(mapParams, host, intrinsic);
    }

    @Override
    public boolean canReplace(Map<AbilityKey, Object> runParams) {
        if (!matchesValidParam("ValidPlayer", runParams.get(AbilityKey.Affected))) {
            return false;
        }
        return true;
    }

    @Override
    public void setReplacingObjects(Map<AbilityKey, Object> runParams, SpellAbility sa) {
        sa.setReplacingObject(AbilityKey.DefendingPlayer, runParams.get(AbilityKey.Affected));
        // Here the Player is the one who would declare blockers (may be changed by some Card's effect)
        sa.setReplacingObject(AbilityKey.Player, runParams.get(AbilityKey.Player));
    }
}
```
