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

## Design Description

Phasing out is a triggered ability that fires when a permanent phases out of the game. The class extends `Trigger`, supplying the three hooks the trigger framework requires: `performTest` filters firing against the host's `ValidCard` restriction, matching it against the `AbilityKey.Card` run parameter; `setTriggeringObjects` binds that card onto the resolving `SpellAbility` so downstream effects can reference it; and `getImportantStackObjects` produces a localized, human-readable stack description naming the phased-out card.

The design is deliberately minimalâ€”a thin, declarative specialization of `Trigger` that carries no state beyond what the base constructor stores, delegating all parameter parsing and lifecycle handling to the superclass. It collaborates with `Card` and `SpellAbility` only transiently through the `AbilityKey` map, and routes user-facing text through `Localizer` to keep presentation translatable.

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

## Python
`forge/game/trigger/TriggerPhaseOut.py`

```python
from forge.game.trigger.Trigger import Trigger
from forge.game.ability.AbilityKey import AbilityKey
from forge.game.card.Card import Card
from forge.game.spellability.SpellAbility import SpellAbility
from forge.util.Localizer import Localizer


class TriggerPhaseOut(Trigger):

    def __init__(self, params: dict[str, str], host: Card, intrinsic: bool):
        super().__init__(params, host, intrinsic)

    def performTest(self, runParams: dict[AbilityKey, object]) -> bool:
        if not self.matchesValidParam("ValidCard", runParams.get(AbilityKey.Card)):
            return False

        return True

    def setTriggeringObjects(self, sa: SpellAbility, runParams: dict[AbilityKey, object]) -> None:
        sa.setTriggeringObjectsFrom(runParams, AbilityKey.Card)

    def getImportantStackObjects(self, sa: SpellAbility) -> str:
        sb = []
        sb.append(Localizer.getInstance().getMessage("lblPhasedOut"))
        sb.append(": ")
        sb.append(str(sa.getTriggeringObject(AbilityKey.Card)))
        return "".join(sb)
```
