---
aliases:
  - TriggerCollectEvidence
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/trigger
fqn: forge.game.trigger.TriggerCollectEvidence
package: forge.game.trigger
module: forge-game
kind: Class
---

# TriggerCollectEvidence

**Package:** `forge.game.trigger` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class TriggerCollectEvidence {
        +performTest(Map~AbilityKey,Object~ runParams) boolean
        +setTriggeringObjects(SpellAbility sa, Map~AbilityKey,Object~ runParams) void
        +getImportantStackObjects(SpellAbility sa) String
        +TriggerCollectEvidence(Map~String,String~ params, Card host, boolean intrinsic)
    }
    TriggerCollectEvidence --|> Trigger : extends
    TriggerCollectEvidence ..> AbilityKey : uses
    TriggerCollectEvidence ..> Card : uses
    TriggerCollectEvidence ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.trigger.Trigger|Trigger]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

Forge MTG's "Collect Evidence" trigger fires in response to a player performing the collect-evidence action, modeling the namesake mechanic from the trading card game. As a concrete subclass of `Trigger`, it plugs into the engine's event-driven trigger framework by overriding the three template hooks the base class defines: `performTest` gates firing on the optional `ValidPlayer` restriction, `setTriggeringObjects` exposes the acting player to the resulting ability via the `AbilityKey.Player` key, and `getImportantStackObjects` produces a localized, human-readable summary for the stack. It collaborates with `Card` and the `params` map at construction to configure the trigger declaratively, and with `SpellAbility` and the `AbilityKey`-keyed run-parameter map at runtime. The design intent is uniformity: it carries no state of its own, deferring all shared behavior to `Trigger` and keeping the player-centric matching logic minimal and data-driven.

## Source
`forge-game/src/main/java/forge/game/trigger/TriggerCollectEvidence.java`

```java
package forge.game.trigger;

import java.util.Map;

import forge.game.ability.AbilityKey;
import forge.game.card.Card;
import forge.game.spellability.SpellAbility;
import forge.util.Localizer;

public class TriggerCollectEvidence extends Trigger {

    public TriggerCollectEvidence(Map<String, String> params, Card host, boolean intrinsic) {
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
`forge/game/trigger/TriggerCollectEvidence.py`

```python
from forge.game.trigger.Trigger import Trigger
from forge.game.ability.AbilityKey import AbilityKey
from forge.game.card.Card import Card
from forge.game.spellability.SpellAbility import SpellAbility
from forge.util.Localizer import Localizer


class TriggerCollectEvidence(Trigger):

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
