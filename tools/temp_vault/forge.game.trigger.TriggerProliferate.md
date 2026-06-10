---
aliases:
  - TriggerProliferate
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/trigger
fqn: forge.game.trigger.TriggerProliferate
package: forge.game.trigger
module: forge-game
kind: Class
---

# TriggerProliferate

**Package:** `forge.game.trigger` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class TriggerProliferate {
        +performTest(Map~AbilityKey,Object~ runParams) boolean
        +setTriggeringObjects(SpellAbility sa, Map~AbilityKey,Object~ runParams) void
        +getImportantStackObjects(SpellAbility sa) String
        +TriggerProliferate(Map~String,String~ params, Card host, boolean intrinsic)
    }
    TriggerProliferate --|> Trigger : extends
    TriggerProliferate ..> AbilityKey : uses
    TriggerProliferate ..> Card : uses
    TriggerProliferate ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.trigger.Trigger|Trigger]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

TriggerProliferate is a concrete trigger that fires when a proliferate event occurs, identifying the player who performs the proliferation. Extending the abstract `Trigger` base class, it overrides the standard trigger lifecycle hooks: `performTest` gates activation by filtering on the optional `ValidPlayer` parameter, `setTriggeringObjects` exposes the proliferating player to the resulting ability, and `getImportantStackObjects` produces a localized, human-readable summary for the stack display.

Its responsibilities are deliberately narrowâ€”it carries no proliferation logic itself, instead collaborating with `AbilityKey` to key into the runtime parameter map, `Card` as its host, and `SpellAbility` to relay triggering data downstream. By keying everything on `AbilityKey.Player` and delegating construction and matching to its supertype, the class fits the engine's data-driven, parameter-map trigger pattern, keeping each trigger type a thin, focused specialization.

## Source
`forge-game/src/main/java/forge/game/trigger/TriggerProliferate.java`

```java
package forge.game.trigger;

import java.util.Map;

import forge.game.ability.AbilityKey;
import forge.game.card.Card;
import forge.game.spellability.SpellAbility;
import forge.util.Localizer;

public class TriggerProliferate extends Trigger {

    public TriggerProliferate(Map<String, String> params, Card host, boolean intrinsic) {
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
`forge/game/trigger/TriggerProliferate.py`

```python
from forge.game.trigger.Trigger import Trigger
from forge.game.ability.AbilityKey import AbilityKey
from forge.game.card.Card import Card
from forge.game.spellability.SpellAbility import SpellAbility
from forge.util.Localizer import Localizer


class TriggerProliferate(Trigger):

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
