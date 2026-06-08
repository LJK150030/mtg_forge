---
aliases:
  - ReplaceRollDice
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/replacement
fqn: forge.game.replacement.ReplaceRollDice
package: forge.game.replacement
module: forge-game
kind: Class
---

# ReplaceRollDice

**Package:** `forge.game.replacement` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class ReplaceRollDice {
        +canReplace(Map~AbilityKey,Object~ runParams) boolean
        +setReplacingObjects(Map~AbilityKey,Object~ runParams, SpellAbility sa) void
        +ReplaceRollDice(Map~String,String~ params, Card host, boolean intrinsic)
    }
    ReplaceRollDice --|> ReplacementEffect : extends
    ReplaceRollDice ..> AbilityKey : uses
    ReplaceRollDice ..> Card : uses
    ReplaceRollDice ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.replacement.ReplacementEffect|ReplacementEffect]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Source
`forge-game/src/main/java/forge/game/replacement/ReplaceRollDice.java`

```java
package forge.game.replacement;

import forge.game.ability.AbilityKey;
import forge.game.card.Card;
import forge.game.spellability.SpellAbility;

import java.util.Map;

public class ReplaceRollDice extends ReplacementEffect {

    /**
     * Instantiates a new replace roll planar dice.
     *
     * @param params the params
     * @param host   the host
     */
    public ReplaceRollDice(final Map<String, String> params, final Card host, final boolean intrinsic) {
        super(params, host, intrinsic);
    }

    /* (non-Javadoc)
     * @see forge.card.replacement.ReplacementEffect#canReplace(java.util.HashMap)
     */
    @Override
    public boolean canReplace(Map<AbilityKey, Object> runParams) {
        if (!matchesValidParam("ValidPlayer", runParams.get(AbilityKey.Affected))) {
            return false;
        }
        if (hasParam("ValidSides")) {
            if (((Integer) runParams.get(AbilityKey.Sides)) != Integer.parseInt(getParam("ValidSides"))) {
                return false;
            }
        }
        return true;
    }

    /* (non-Javadoc)
     * @see forge.card.replacement.ReplacementEffect#setReplacingObjects(java.util.Map, forge.card.spellability.SpellAbility)
     */
    @Override
    public void setReplacingObjects(Map<AbilityKey, Object> runParams, SpellAbility sa) {
        sa.setReplacingObject(AbilityKey.Number, runParams.get(AbilityKey.Number));
        sa.setReplacingObject(AbilityKey.Ignore, runParams.get(AbilityKey.Ignore));
        sa.setReplacingObject(AbilityKey.IgnoreChosen, runParams.get(AbilityKey.IgnoreChosen));
        sa.setReplacingObject(AbilityKey.DicePTExchanges, runParams.get(AbilityKey.DicePTExchanges));
    }
}
```
