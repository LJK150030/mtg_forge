---
aliases:
  - TriggerPhaseOut
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/trigger
fqn: forge.game.trigger.TriggerPhaseOut
package: forge.game.trigger
module: forge-game
kind: Class
---

# TriggerPhaseOut

**Package:** `forge.game.trigger` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class TriggerPhaseOut {
        +performTest(Map~AbilityKey,Object~ runParams) boolean
        +setTriggeringObjects(SpellAbility sa, Map~AbilityKey,Object~ runParams) void
        +getImportantStackObjects(SpellAbility sa) String
        +TriggerPhaseOut(Map~String,String~ params, Card host, boolean intrinsic)
    }
    TriggerPhaseOut --|> Trigger : extends
    TriggerPhaseOut ..> AbilityKey : uses
    TriggerPhaseOut ..> Card : uses
    TriggerPhaseOut ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.trigger.Trigger|Trigger]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Source
`forge-game/src/main/java/forge/game/trigger/TriggerPhaseOut.java`

```java
package forge.game.trigger;

import java.util.Map;

import forge.game.ability.AbilityKey;
import forge.game.card.Card;
import forge.game.spellability.SpellAbility;
import forge.util.Localizer;

public class TriggerPhaseOut extends Trigger {

    public TriggerPhaseOut(final Map<String, String> params, final Card host, final boolean intrinsic) {
        super(params, host, intrinsic);
    }

    /** {@inheritDoc}
     * @param runParams*/
    @Override
    public final boolean performTest(final Map<AbilityKey, Object> runParams) {
        if (!matchesValidParam("ValidCard", runParams.get(AbilityKey.Card))) {
            return false;
        }

        return true;
    }

    /** {@inheritDoc} */
    @Override
    public final void setTriggeringObjects(final SpellAbility sa, Map<AbilityKey, Object> runParams) {
        sa.setTriggeringObjectsFrom(runParams, AbilityKey.Card);
    }

    @Override
    public String getImportantStackObjects(SpellAbility sa) {
        StringBuilder sb = new StringBuilder();
        sb.append(Localizer.getInstance().getMessage("lblPhasedOut")).append(": ").append(sa.getTriggeringObject(AbilityKey.Card));
        return sb.toString();
    }
}
```
