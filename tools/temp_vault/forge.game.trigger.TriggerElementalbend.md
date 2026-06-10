---
aliases:
  - TriggerElementalbend
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/trigger
fqn: forge.game.trigger.TriggerElementalbend
package: forge.game.trigger
module: forge-game
kind: Class
---

# TriggerElementalbend

**Package:** `forge.game.trigger` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class TriggerElementalbend {
        +performTest(Map~AbilityKey,Object~ runParams) boolean
        +setTriggeringObjects(SpellAbility sa, Map~AbilityKey,Object~ runParams) void
        +getImportantStackObjects(SpellAbility sa) String
        +TriggerElementalbend(Map~String,String~ params, Card host, boolean intrinsic)
    }
    TriggerElementalbend --|> Trigger : extends
    TriggerElementalbend ..> AbilityKey : uses
    TriggerElementalbend ..> Card : uses
    TriggerElementalbend ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.trigger.Trigger|Trigger]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

Elementalbend is one of MTG's hidden enchantment triggers. Let me write the SDD.

A concrete trigger that fires in response to a player-related game event, `TriggerElementalbend` extends `Trigger` to implement the three template-method hooks the trigger framework expects. `performTest` gates firing by checking the event's `Player` run-parameter against the trigger's optional `ValidPlayer` restriction, `setTriggeringObjects` copies that player into the resolving `SpellAbility`'s triggering context, and `getImportantStackObjects` produces a localized, human-readable summary naming the triggering player.

The class collaborates with `AbilityKey` to address run-parameter values in a type-safe map, with `Card` as the trigger's host (passed straight to the superclass), and with `SpellAbility` as the effect it parameterizes. Its design intent is minimal and declarative: nearly all behavior is inherited from `Trigger`, and this subclass only specializes the player-matching semantics, keeping per-trigger logic small and data-driven via the `params` map.

## Source
`forge-game/src/main/java/forge/game/trigger/TriggerElementalbend.java`

```java
package forge.game.trigger;

import java.util.Map;

import forge.game.ability.AbilityKey;
import forge.game.card.Card;
import forge.game.spellability.SpellAbility;
import forge.util.Localizer;

public class TriggerElementalbend extends Trigger {

    public TriggerElementalbend(final Map<String, String> params, final Card host, final boolean intrinsic) {
        super(params, host, intrinsic);
    }
    
    @Override
    public boolean performTest(Map<AbilityKey, Object> runParams) {
        if (!matchesValidParam("ValidPlayer", runParams.get(AbilityKey.Player))) {
            return false;
        }
        return true;
    }

    @Override
    public void setTriggeringObjects(SpellAbility sa, Map<AbilityKey, Object> runParams) {
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

## Python
`forge/game/trigger/TriggerElementalbend.py`

```python
from forge.game.trigger.Trigger import Trigger
from forge.game.ability.AbilityKey import AbilityKey
from forge.game.card.Card import Card
from forge.game.spellability.SpellAbility import SpellAbility
from forge.util.Localizer import Localizer


class TriggerElementalbend(Trigger):

    def __init__(self, params: dict[str, str], host: Card, intrinsic: bool):
        super().__init__(params, host, intrinsic)

    def performTest(self, runParams: dict[AbilityKey, object]) -> bool:
        if not self.matchesValidParam("ValidPlayer", runParams.get(AbilityKey.Player)):
            return False
        return True

    def setTriggeringObjects(self, sa: SpellAbility, runParams: dict[AbilityKey, object]) -> None:
        sa.setTriggeringObjectsFrom(runParams, AbilityKey.Player)

    def getImportantStackObjects(self, sa: SpellAbility) -> str:
        sb = []
        sb.append(Localizer.getInstance().getMessage("lblPlayer"))
        sb.append(": ")
        sb.append(str(sa.getTriggeringObject(AbilityKey.Player)))
        return "".join(sb)
```
