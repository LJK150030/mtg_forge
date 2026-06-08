---
aliases:
  - TriggerCounterTypeAddedAll
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/trigger
fqn: forge.game.trigger.TriggerCounterTypeAddedAll
package: forge.game.trigger
module: forge-game
kind: Class
---

# TriggerCounterTypeAddedAll

**Package:** `forge.game.trigger` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class TriggerCounterTypeAddedAll {
        +performTest(Map~AbilityKey,Object~ runParams) boolean
        +setTriggeringObjects(SpellAbility sa, Map~AbilityKey,Object~ runParams) void
        +getImportantStackObjects(SpellAbility sa) String
        +TriggerCounterTypeAddedAll(Map~String,String~ params, Card host, boolean intrinsic)
    }
    TriggerCounterTypeAddedAll --|> Trigger : extends
    TriggerCounterTypeAddedAll ..> AbilityKey : uses
    TriggerCounterTypeAddedAll ..> Card : uses
    TriggerCounterTypeAddedAll ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.trigger.Trigger|Trigger]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Source
`forge-game/src/main/java/forge/game/trigger/TriggerCounterTypeAddedAll.java`

```java
package forge.game.trigger;

import java.util.Map;

import forge.game.ability.AbilityKey;
import forge.game.card.Card;
import forge.game.spellability.SpellAbility;
import forge.util.Localizer;

public class TriggerCounterTypeAddedAll extends Trigger {

    public TriggerCounterTypeAddedAll(Map<String, String> params, Card host, boolean intrinsic) {
        super(params, host, intrinsic);
    }

    @Override
    public boolean performTest(Map<AbilityKey, Object> runParams) {
        if (!matchesValidParam("ValidObject", runParams.get(AbilityKey.Object))) {
            return false;
        }

        if (hasParam("FirstTime")) {
            if (!(boolean) runParams.get(AbilityKey.FirstTime)) {
                return false;
            }
        }

        return true;
    }

    @Override
    public void setTriggeringObjects(SpellAbility sa, Map<AbilityKey, Object> runParams) {
        sa.setTriggeringObjectsFrom(runParams, AbilityKey.Object);
    }

    @Override
    public String getImportantStackObjects(SpellAbility sa) {
        StringBuilder sb = new StringBuilder();
        sb.append(Localizer.getInstance().getMessage("lblAddedOnce")).append(": ");
        sb.append(sa.getTriggeringObject(AbilityKey.Object));
        return sb.toString();
    }

}
```
