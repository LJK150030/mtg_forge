---
aliases:
  - ActivationTable
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/card
fqn: forge.game.card.ActivationTable
package: forge.game.card
module: forge-game
kind: Class
---

# ActivationTable

**Package:** `forge.game.card` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class ActivationTable {
        ~Table~SpellAbility,Optional,List~ dataTable
        #delegate() Table~SpellAbility,Optional,List~
        #getOriginal(SpellAbility sa) SpellAbility
        +add(SpellAbility sa) void
        +get(SpellAbility sa) Integer
        +getActivators(SpellAbility sa) List~Player~
    }
    ActivationTable --|> ForwardingTable : extends
    ActivationTable ..> Player : uses
    ActivationTable ..> SpellAbility : uses
    ActivationTable ..> StaticAbility : uses
```

## Relationships
**Uses:**
- [[forge.game.player.Player|Player]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]

## Design Description

ActivationTable is a specialized tally that records which players have activated a given ability, keyed by the ability and the optional static ability that granted it. By extending Guava's `ForwardingTable` and delegating to an internal `HashBasedTable<SpellAbility, Optional<StaticAbility>, List<Player>>`, it inherits the full `Table` API while exposing a small, intent-revealing surface—`add`, `get`, and `getActivators`—tailored to activation counting.

Its central design concern is identity normalization: because trigger and copied spell abilities are duplicated at runtime, `getOriginal` resolves each `SpellAbility` back to its canonical root (via the trigger's overriding ability or the original ability) so that every activation maps to a stable key. Pairing that root with the grantor `StaticAbility` lets the table distinguish activations granted by different static effects, and storing per-key `List<Player>` collaborators preserves who activated so callers can both count and enumerate activators.

## Source
`forge-game/src/main/java/forge/game/card/ActivationTable.java`

```java
package forge.game.card;

import com.google.common.collect.ForwardingTable;
import com.google.common.collect.HashBasedTable;
import com.google.common.collect.Lists;
import com.google.common.collect.Table;
import forge.game.player.Player;
import forge.game.spellability.SpellAbility;
import forge.game.staticability.StaticAbility;

import java.util.List;
import java.util.Objects;
import java.util.Optional;

public class ActivationTable extends ForwardingTable<SpellAbility, Optional<StaticAbility>, List<Player>> {
    Table<SpellAbility, Optional<StaticAbility>, List<Player>> dataTable = HashBasedTable.create();

    @Override
    protected Table<SpellAbility, Optional<StaticAbility>, List<Player>> delegate() {
        return dataTable;
    }

    protected SpellAbility getOriginal(SpellAbility sa) {
        SpellAbility original = null;
        SpellAbility root = sa.getRootAbility();

        // because trigger spell abilities are copied, try to get original one
        if (root.isTrigger()) {
            original = root.getTrigger().getOverridingAbility();
        } else {
            original = Objects.requireNonNullElse(root.getOriginalAbility(), root);
        }
        return original;
    }

    public void add(SpellAbility sa) {
        SpellAbility root = sa.getRootAbility();
        SpellAbility original = getOriginal(sa);

        if (original != null) {
            Optional<StaticAbility> st = Optional.ofNullable(root.getGrantorStatic());

            List<Player> activators = get(original, st);
            if (activators == null) {
                activators = Lists.newArrayList();
            }
            activators.add(sa.getActivatingPlayer());
            delegate().put(original, st, activators);
        }
    }

    public Integer get(SpellAbility sa) {
        return getActivators(sa).size();
    }

    public List<Player> getActivators(SpellAbility sa) {
        SpellAbility root = sa.getRootAbility();
        SpellAbility original = getOriginal(sa);
        Optional<StaticAbility> st = Optional.ofNullable(root.getGrantorStatic());

        if (contains(original, st)) {
            return get(original, st);
        }
        return Lists.newArrayList();
    }
}
```
