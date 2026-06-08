---
aliases:
  - TriggerDayTimeChanges
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/trigger
fqn: forge.game.trigger.TriggerDayTimeChanges
package: forge.game.trigger
module: forge-game
kind: Class
---

# TriggerDayTimeChanges

**Package:** `forge.game.trigger` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class TriggerDayTimeChanges {
        +performTest(Map~AbilityKey,Object~ runParams) boolean
        +setTriggeringObjects(SpellAbility sa, Map~AbilityKey,Object~ runParams) void
        +getImportantStackObjects(SpellAbility sa) String
        +TriggerDayTimeChanges(Map~String,String~ params, Card host, boolean intrinsic)
    }
    TriggerDayTimeChanges --|> Trigger : extends
    TriggerDayTimeChanges ..> AbilityKey : uses
    TriggerDayTimeChanges ..> Card : uses
    TriggerDayTimeChanges ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.trigger.Trigger|Trigger]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Source
`forge-game/src/main/java/forge/game/trigger/TriggerDayTimeChanges.java`

```java
package forge.game.trigger;

import java.util.Map;

import forge.game.ability.AbilityKey;
import forge.game.card.Card;
import forge.game.spellability.SpellAbility;

public class TriggerDayTimeChanges extends Trigger {

    public TriggerDayTimeChanges(Map<String, String> params, Card host, boolean intrinsic) {
        super(params, host, intrinsic);
    }

    @Override
    public boolean performTest(Map<AbilityKey, Object> runParams) {
        return true;
    }

    @Override
    public void setTriggeringObjects(SpellAbility sa, Map<AbilityKey, Object> runParams) {
    }

    @Override
    public String getImportantStackObjects(SpellAbility sa) {
        return "";
    }

}
```
