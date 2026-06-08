---
aliases:
  - TriggerTurnBegin
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/trigger
fqn: forge.game.trigger.TriggerTurnBegin
package: forge.game.trigger
module: forge-game
kind: Class
---

# TriggerTurnBegin

**Package:** `forge.game.trigger` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class TriggerTurnBegin {
        +performTest(Map~AbilityKey,Object~ runParams) boolean
        +setTriggeringObjects(SpellAbility sa, Map~AbilityKey,Object~ runParams) void
        +getImportantStackObjects(SpellAbility sa) String
        +TriggerTurnBegin(Map~String,String~ params, Card host, boolean intrinsic)
    }
    TriggerTurnBegin --|> Trigger : extends
    TriggerTurnBegin ..> AbilityKey : uses
    TriggerTurnBegin ..> Card : uses
    TriggerTurnBegin ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.trigger.Trigger|Trigger]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Source
`forge-game/src/main/java/forge/game/trigger/TriggerTurnBegin.java`

```java
package forge.game.trigger;

import java.util.Map;

import forge.game.ability.AbilityKey;
import forge.game.card.Card;
import forge.game.spellability.SpellAbility;
import forge.util.Localizer;

// Turn Begin isn't a "real" trigger, but is useful for Advanced Scripting Techniques
public class TriggerTurnBegin extends Trigger {
    public TriggerTurnBegin(final Map<String, String> params, final Card host, final boolean intrinsic) {
        super(params, host, intrinsic);
    }

    @Override
    public final boolean performTest(final Map<AbilityKey, Object> runParams) {
        if (!matchesValidParam("ValidPlayer", runParams.get(AbilityKey.Player))) {
            return false;
        }
        return true;
    }

    @Override
    public final void setTriggeringObjects(final SpellAbility sa, Map<AbilityKey, Object> runParams) {
        sa.setTriggeringObjectsFrom(runParams, AbilityKey.Player);
    }

    @Override
    public String getImportantStackObjects(SpellAbility sa) {
        StringBuilder sb = new StringBuilder();
        sb.append(Localizer.getInstance().getMessage("lblPlayer")).append(": ").append(sa.getTriggeringObject(AbilityKey.Player));
        return sb.toString();
    }
}
```
