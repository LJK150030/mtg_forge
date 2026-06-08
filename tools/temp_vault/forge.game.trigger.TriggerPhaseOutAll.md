---
aliases:
  - TriggerPhaseOutAll
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/trigger
fqn: forge.game.trigger.TriggerPhaseOutAll
package: forge.game.trigger
module: forge-game
kind: Class
---

# TriggerPhaseOutAll

**Package:** `forge.game.trigger` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class TriggerPhaseOutAll {
        +performTest(Map~AbilityKey,Object~ runParams) boolean
        +setTriggeringObjects(SpellAbility sa, Map~AbilityKey,Object~ runParams) void
        +getImportantStackObjects(SpellAbility sa) String
        +TriggerPhaseOutAll(Map~String,String~ params, Card host, boolean intrinsic)
    }
    TriggerPhaseOutAll --|> Trigger : extends
    TriggerPhaseOutAll ..> AbilityKey : uses
    TriggerPhaseOutAll ..> Card : uses
    TriggerPhaseOutAll ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.trigger.Trigger|Trigger]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Source
`forge-game/src/main/java/forge/game/trigger/TriggerPhaseOutAll.java`

```java
package forge.game.trigger;

import forge.game.ability.AbilityKey;
import forge.game.card.Card;
import forge.game.card.CardPredicates;
import forge.game.spellability.SpellAbility;
import forge.util.IterableUtil;
import forge.util.Localizer;

import java.util.Map;

public class TriggerPhaseOutAll extends Trigger {

    public TriggerPhaseOutAll(final Map<String, String> params, final Card host, final boolean intrinsic) {
        super(params, host, intrinsic);
    }

    @Override
    public boolean performTest(Map<AbilityKey, Object> runParams) {
        if (!matchesValidParam("ValidCards", runParams.get(AbilityKey.Cards))) {
            return false;
        }

        return true;
    }

    @Override
    public void setTriggeringObjects(SpellAbility sa, Map<AbilityKey, Object> runParams) {
        Iterable<Card> cards = (Iterable<Card>) runParams.get(AbilityKey.Cards);
        if (hasParam("ValidCards")) {
            cards = IterableUtil.filter(cards, CardPredicates.restriction(getParam("ValidCards").split(","),
                    getHostCard().getController(), getHostCard(), this));
        }

        sa.setTriggeringObject(AbilityKey.Cards, cards);
    }

    @Override
    public String getImportantStackObjects(SpellAbility sa) {
        StringBuilder sb = new StringBuilder();
        sb.append(Localizer.getInstance().getMessage("lblPhasedOut")).append(": ");
        sb.append(sa.getTriggeringObject(AbilityKey.Cards));
        return sb.toString();
    }
}
```
