---
aliases:
  - TriggerBecomesSaddled
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/trigger
fqn: forge.game.trigger.TriggerBecomesSaddled
package: forge.game.trigger
module: forge-game
kind: Class
---

# TriggerBecomesSaddled

**Package:** `forge.game.trigger` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class TriggerBecomesSaddled {
        +performTest(Map~AbilityKey,Object~ runParams) boolean
        +setTriggeringObjects(SpellAbility sa, Map~AbilityKey,Object~ runParams) void
        +getImportantStackObjects(SpellAbility sa) String
        +TriggerBecomesSaddled(Map~String,String~ params, Card host, boolean intrinsic)
    }
    TriggerBecomesSaddled --|> Trigger : extends
    TriggerBecomesSaddled ..> AbilityKey : uses
    TriggerBecomesSaddled ..> Card : uses
    TriggerBecomesSaddled ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.trigger.Trigger|Trigger]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Source
`forge-game/src/main/java/forge/game/trigger/TriggerBecomesSaddled.java`

```java
package forge.game.trigger;

import java.util.Map;

import forge.game.ability.AbilityKey;
import forge.game.card.Card;
import forge.game.spellability.SpellAbility;
import forge.util.Localizer;

public class TriggerBecomesSaddled extends Trigger {

    public TriggerBecomesSaddled(final Map<String, String> params, final Card host, final boolean intrinsic) {
        super(params, host, intrinsic);
    }

    @Override
    public boolean performTest(Map<AbilityKey, Object> runParams) {
        if (!matchesValidParam("ValidSaddled", runParams.get(AbilityKey.Card))) {
            return false;
        }
        if (hasParam("FirstTimeSaddled")) {
            Card v = (Card) runParams.get(AbilityKey.Card);
            if (v.getTimesSaddledThisTurn() != 1) {
                return false;
            }
        }
        return true;
    }

    // For now, since Saddled is so much like Crew, just use AbilityKey.Crew for cards that tap to saddle 

    @Override
    public void setTriggeringObjects(SpellAbility sa, Map<AbilityKey, Object> runParams) {
        sa.setTriggeringObjectsFrom(runParams, AbilityKey.Card, AbilityKey.Crew);
    }

    @Override
    public String getImportantStackObjects(SpellAbility sa) {
        StringBuilder sb = new StringBuilder();
        sb.append(Localizer.getInstance().getMessage("lblSaddled")).append(": ").append(sa.getTriggeringObject(AbilityKey.Card));
        sb.append("  ");
        sb.append(Localizer.getInstance().getMessage("lblSaddledBy")).append(": ").append(sa.getTriggeringObject(AbilityKey.Crew));
        return sb.toString();
    }
}
```
