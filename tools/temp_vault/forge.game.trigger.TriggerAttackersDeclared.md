---
aliases:
  - TriggerAttackersDeclared
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/trigger
fqn: forge.game.trigger.TriggerAttackersDeclared
package: forge.game.trigger
module: forge-game
kind: Class
---

# TriggerAttackersDeclared

**Package:** `forge.game.trigger` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class TriggerAttackersDeclared {
        +performTest(Map~AbilityKey,Object~ runParams) boolean
        +setTriggeringObjects(SpellAbility sa, Map~AbilityKey,Object~ runParams) void
        +getImportantStackObjects(SpellAbility sa) String
        +TriggerAttackersDeclared(Map~String,String~ params, Card host, boolean intrinsic)
    }
    TriggerAttackersDeclared --|> Trigger : extends
    TriggerAttackersDeclared ..> AbilityKey : uses
    TriggerAttackersDeclared ..> Card : uses
    TriggerAttackersDeclared ..> CardCollection : uses
    TriggerAttackersDeclared ..> FCollection : uses
    TriggerAttackersDeclared ..> GameEntity : uses
    TriggerAttackersDeclared ..> SpellAbility : uses
```

## Relationships
**Extends:**
- [[forge.game.trigger.Trigger|Trigger]]
**Uses:**
- [[forge.game.GameEntity|GameEntity]]
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.card.CardCollection|CardCollection]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]
- [[forge.util.collect.FCollection|FCollection]]

## Source
`forge-game/src/main/java/forge/game/trigger/TriggerAttackersDeclared.java`

```java
/*
 * Forge: Play Magic: the Gathering.
 * Copyright (C) 2011  Forge Team
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package forge.game.trigger;

import java.util.*;

import forge.game.GameEntity;
import forge.game.GameObjectPredicates;
import forge.game.ability.AbilityKey;
import forge.game.ability.AbilityUtils;
import forge.game.card.Card;
import forge.game.card.CardCollection;
import forge.game.card.CardLists;
import forge.game.spellability.SpellAbility;
import forge.util.Expressions;
import forge.util.IterableUtil;
import forge.util.Localizer;
import forge.util.collect.FCollection;

/**
 * TODO Write javadoc for this type.
 * 
 */
public class TriggerAttackersDeclared extends Trigger {

    /**
     * Instantiates a new trigger_ attackers declared.
     * 
     * @param params
     *            the params
     * @param host
     *            the host
     * @param intrinsic
     *            the intrinsic
     */
    public TriggerAttackersDeclared(final Map<String, String> params, final Card host, final boolean intrinsic) {
        super(params, host, intrinsic);
    }

    /** {@inheritDoc}
     * @param runParams*/
    @Override
    public final boolean performTest(final Map<AbilityKey, Object> runParams) {
        if (!matchesValidParam("AttackingPlayer", runParams.get(AbilityKey.AttackingPlayer))) {
            return false;
        }
        if (!matchesValidParam("AttackedTarget", runParams.get(AbilityKey.AttackedTarget))) {
            return false;
        }
        if (hasParam("ValidAttackers")) {
            String param = getParamOrDefault("ValidAttackersAmount", "GE1");
            int attackers = CardLists.getValidCardCount((CardCollection) runParams.get(AbilityKey.Attackers), getParam("ValidAttackers"), getHostCard().getController(), getHostCard(), this);
            int amount = AbilityUtils.calculateAmount(getHostCard(), param.substring(2), this);
            if (!Expressions.compare(attackers, param, amount)) {
                return false;
            }
        }

        return true;
    }

    /** {@inheritDoc} */
    @Override
    public final void setTriggeringObjects(final SpellAbility sa, Map<AbilityKey, Object> runParams) {
        Iterable<GameEntity> attackedTarget = (Iterable<GameEntity>) runParams.get(AbilityKey.AttackedTarget);

        CardCollection attackers = (CardCollection) runParams.get(AbilityKey.Attackers);
        if (hasParam("ValidAttackers")) {
            attackers = CardLists.getValidCards(attackers, getParam("ValidAttackers"), getHostCard().getController(), getHostCard(), this);
            FCollection<GameEntity> defenders = new FCollection<>();
            for (Card attacker : attackers) {
                defenders.add(attacker.getGame().getCombat().getDefenderByAttacker(attacker));
            }
            attackedTarget = defenders;
        }
        sa.setTriggeringObject(AbilityKey.Attackers, attackers);

        if (hasParam("AttackedTarget")) {
            attackedTarget = IterableUtil.filter(attackedTarget, GameObjectPredicates.restriction(getParam("AttackedTarget").split(","), getHostCard().getController(), getHostCard(), this));
        }
        sa.setTriggeringObject(AbilityKey.AttackedTarget, attackedTarget);

        sa.setTriggeringObjectsFrom(runParams, AbilityKey.AttackingPlayer);
    }

    @Override
    public String getImportantStackObjects(SpellAbility sa) {
        StringBuilder sb = new StringBuilder();
        sb.append(Localizer.getInstance().getMessage("lblNumberAttackers")).append(": ").append(sa.getTriggeringObject(AbilityKey.Attackers));
        return sb.toString();
    }
}
```
