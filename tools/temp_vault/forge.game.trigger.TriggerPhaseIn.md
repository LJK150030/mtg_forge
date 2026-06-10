---
aliases:
  - TriggerPhaseIn
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/trigger
fqn: forge.game.trigger.TriggerPhaseIn
package: forge.game.trigger
module: forge-game
kind: Class
---

# TriggerPhaseIn

**Package:** `forge.game.trigger` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class TriggerPhaseIn {
        +performTest(Map~AbilityKey,Object~ runParams) boolean
        +setTriggeringObjects(SpellAbility sa, Map~AbilityKey,Object~ runParams) void
        +getImportantStackObjects(SpellAbility sa) String
        +TriggerPhaseIn(Map~String,String~ params, Card host, boolean intrinsic)
    }
    TriggerPhaseIn --|> Trigger : extends
    TriggerPhaseIn ..> AbilityKey : uses
    TriggerPhaseIn ..> Card : uses
    TriggerPhaseIn ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.trigger.Trigger|Trigger]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

Phasing-in trigger that fires when a permanent phases back into the game. As a concrete subclass of `Trigger`, `TriggerPhaseIn` specializes the abstract trigger framework for the "phases in" game event, supplying the three hooks the engine expects: `performTest` filters candidate events against the optional `ValidCard` restriction, `setTriggeringObjects` binds the phasing card into the firing `SpellAbility` via the `AbilityKey.Card` key, and `getImportantStackObjects` builds a localized, human-readable description of the event. It collaborates with `Card` (the host and triggering permanent), `SpellAbility` (the ability fired in response), and `AbilityKey` (the typed run-parameter map keys). Notable intent: the methods are `final` to lock the trigger's contract, validation reuses the inherited `matchesValidParam` helper, and user-facing text is routed through `Localizer` for translation.

## Source
`forge-game/src/main/java/forge/game/trigger/TriggerPhaseIn.java`

```java
package forge.game.trigger;

import java.util.Map;

import forge.game.ability.AbilityKey;
import forge.game.card.Card;
import forge.game.spellability.SpellAbility;
import forge.util.Localizer;

public class TriggerPhaseIn extends Trigger {

    public TriggerPhaseIn(final Map<String, String> params, final Card host, final boolean intrinsic) {
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
        sb.append(Localizer.getInstance().getMessage("lblPhasedIn")).append(": ").append(sa.getTriggeringObject(AbilityKey.Card));
        return sb.toString();
    }
}
```

## Python
`forge/game/trigger/TriggerPhaseIn.py`

```python
from typing import Map

from forge.game.ability.AbilityKey import AbilityKey
from forge.game.card.Card import Card
from forge.game.spellability.SpellAbility import SpellAbility
from forge.game.trigger.Trigger import Trigger
from forge.util.Localizer import Localizer


class TriggerPhaseIn(Trigger):

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
        sb.append(Localizer.getInstance().getMessage("lblPhasedIn"))
        sb.append(": ")
        sb.append(str(sa.getTriggeringObject(AbilityKey.Card)))
        return "".join(sb)
```
