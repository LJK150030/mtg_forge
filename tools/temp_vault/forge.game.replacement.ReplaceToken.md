---
aliases:
  - ReplaceToken
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/replacement
fqn: forge.game.replacement.ReplaceToken
package: forge.game.replacement
module: forge-game
kind: Class
---

# ReplaceToken

**Package:** `forge.game.replacement` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class ReplaceToken {
        +canReplace(Map~AbilityKey,Object~ runParams) boolean
        +setReplacingObjects(Map~AbilityKey,Object~ runParams, SpellAbility sa) void
        +filterAmount(TokenCreateTable table) int
        +ReplaceToken(Map~String,String~ mapParams, Card host, boolean intrinsic)
    }
    ReplaceToken --|> ReplacementEffect : extends
    ReplaceToken ..> AbilityKey : uses
    ReplaceToken ..> Card : uses
    ReplaceToken ..> SpellAbility : uses
    ReplaceToken ..> TokenCreateTable : uses
```

## Relationships
**Extends:**
- [[forge.game.replacement.ReplacementEffect|ReplacementEffect]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.card.TokenCreateTable|TokenCreateTable]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Source
`forge-game/src/main/java/forge/game/replacement/ReplaceToken.java`

```java
package forge.game.replacement;

import java.util.Map;

import forge.game.ability.AbilityKey;
import forge.game.card.Card;
import forge.game.card.TokenCreateTable;
import forge.game.spellability.SpellAbility;

/** 
 * TODO: Write javadoc for this type.
 *
 */
public class ReplaceToken extends ReplacementEffect {

    /**
     * 
     * ReplaceProduceMana.
     * @param mapParams &emsp; HashMap<String, String>
     * @param host &emsp; Card
     */
    public ReplaceToken(final Map<String, String> mapParams, final Card host, final boolean intrinsic) {
        super(mapParams, host, intrinsic);
    }

    /* (non-Javadoc)
     * @see forge.card.replacement.ReplacementEffect#canReplace(java.util.Map)
     */
    @Override
    public boolean canReplace(Map<AbilityKey, Object> runParams) {
        if (hasParam("EffectOnly")) {
            final Boolean effectOnly = (Boolean) runParams.get(AbilityKey.EffectOnly);
            if (!effectOnly) {
                return false;
            }
        }

        if (!matchesValidParam("ValidPlayer", runParams.get(AbilityKey.Affected))) {
            return false;
        }

        if (filterAmount((TokenCreateTable) runParams.get(AbilityKey.Token)) <= 0) {
            return false;
        }

        return true;
    }

    /* (non-Javadoc)
     * @see forge.card.replacement.ReplacementEffect#setReplacingObjects(java.util.Map, forge.card.spellability.SpellAbility)
     */
    @Override
    public void setReplacingObjects(Map<AbilityKey, Object> runParams, SpellAbility sa) {
        sa.setReplacingObject(AbilityKey.TokenNum, filterAmount((TokenCreateTable) runParams.get(AbilityKey.Token)));
        sa.setReplacingObjectsFrom(runParams, AbilityKey.Token, AbilityKey.Cause);
        sa.setReplacingObject(AbilityKey.Player, runParams.get(AbilityKey.Affected));
    }

    public int filterAmount(final TokenCreateTable table) {
        return table.getFilterAmount(getParamOrDefault("ValidPlayer", null), getParamOrDefault("ValidToken", null), this);
    }
}
```
