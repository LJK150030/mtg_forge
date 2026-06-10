---
aliases:
  - ReplaceBeginPhase
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/replacement
fqn: forge.game.replacement.ReplaceBeginPhase
package: forge.game.replacement
module: forge-game
kind: Class
---

# ReplaceBeginPhase

**Package:** `forge.game.replacement` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class ReplaceBeginPhase {
        +canReplace(Map~AbilityKey,Object~ runParams) boolean
        +setReplacingObjects(Map~AbilityKey,Object~ runParams, SpellAbility sa) void
        +ReplaceBeginPhase(Map~String,String~ mapParams, Card host, boolean intrinsic)
    }
    ReplaceBeginPhase --|> ReplacementEffect : extends
    ReplaceBeginPhase ..> AbilityKey : uses
    ReplaceBeginPhase ..> Card : uses
    ReplaceBeginPhase ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.replacement.ReplacementEffect|ReplacementEffect]]
**Uses:**
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]

## Design Description

ReplaceBeginPhase is a concrete replacement effect that intercepts the beginning of a game phase, allowing card abilities to alter or respond to phase transitions. Extending ReplacementEffect, it overrides `canReplace` to gate activation on the affected player matching a `ValidPlayer` constraint and, optionally, the current phase falling within a configured `Phase` range (parsed via PhaseType). When triggered, `setReplacingObjects` binds the affected player as the replacement's Player object on the SpellAbility.

The class collaborates with AbilityKey to read run-time parameters (Affected, Phase), Card as its host, and SpellAbility as the effect's execution context. A notable design choice is the constructor defaulting the replacement layer to `Control` when none is specified, reflecting that phase-begin replacements typically govern turn-control effects rather than value modification.

## Source
`forge-game/src/main/java/forge/game/replacement/ReplaceBeginPhase.java`

```java
package forge.game.replacement;

import java.util.Map;

import forge.game.ability.AbilityKey;
import forge.game.card.Card;
import forge.game.phase.PhaseType;
import forge.game.spellability.SpellAbility;

public class ReplaceBeginPhase extends ReplacementEffect {

    public ReplaceBeginPhase(final Map<String, String> mapParams, final Card host, final boolean intrinsic) {
        super(mapParams, host, intrinsic);
        // set default layer to control
        if (!mapParams.containsKey("Layer")) {
            this.setLayer(ReplacementLayer.Control);
        }
    }

    @Override
    public boolean canReplace(Map<AbilityKey, Object> runParams) {
        if (!matchesValidParam("ValidPlayer", runParams.get(AbilityKey.Affected))) {
            return false;
        }

        if (hasParam("Phase") && !PhaseType.parseRange(getParam("Phase")).contains(runParams.get(AbilityKey.Phase))) {
            return false;
        }

        return true;
    }

    @Override
    public void setReplacingObjects(Map<AbilityKey, Object> runParams, SpellAbility sa) {
        sa.setReplacingObject(AbilityKey.Player, runParams.get(AbilityKey.Affected));
    }
}
```

## Python
`forge/game/replacement/ReplaceBeginPhase.py`

```python
from forge.game.ability.AbilityKey import AbilityKey
from forge.game.card.Card import Card
from forge.game.phase.PhaseType import PhaseType
from forge.game.spellability.SpellAbility import SpellAbility
from forge.game.replacement.ReplacementEffect import ReplacementEffect
from forge.game.replacement.ReplacementLayer import ReplacementLayer


class ReplaceBeginPhase(ReplacementEffect):

    def __init__(self, mapParams: dict[str, str], host: Card, intrinsic: bool):
        super().__init__(mapParams, host, intrinsic)
        # set default layer to control
        if "Layer" not in mapParams:
            self.setLayer(ReplacementLayer.Control)

    def canReplace(self, runParams: dict[AbilityKey, object]) -> bool:
        if not self.matchesValidParam("ValidPlayer", runParams.get(AbilityKey.Affected)):
            return False

        if self.hasParam("Phase") and runParams.get(AbilityKey.Phase) not in PhaseType.parseRange(self.getParam("Phase")):
            return False

        return True

    def setReplacingObjects(self, runParams: dict[AbilityKey, object], sa: SpellAbility) -> None:
        sa.setReplacingObject(AbilityKey.Player, runParams.get(AbilityKey.Affected))
```
