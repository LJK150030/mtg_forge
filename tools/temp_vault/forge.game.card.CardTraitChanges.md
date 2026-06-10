---
aliases:
  - CardTraitChanges
tags:
  - java/record
  - module/forge-game
  - pkg/forge/game/card
fqn: forge.game.card.CardTraitChanges
package: forge.game.card
module: forge-game
kind: Record
---

# CardTraitChanges

**Package:** `forge.game.card` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Record

```mermaid
classDiagram
    class CardTraitChanges {
        <<record>>
        +getAbilities() Collection~SpellAbility~
        +getTriggers() Collection~Trigger~
        +getReplacements() Collection~ReplacementEffect~
        +getStaticAbilities() Collection~StaticAbility~
        +containsCostChange() boolean
        +copy(Card host, boolean lki) CardTraitChanges
        +changeText() void
        +applySpellAbility(List~SpellAbility~ list) List~SpellAbility~
        +applyTrigger(List~Trigger~ list) List~Trigger~
        +applyReplacementEffect(List~ReplacementEffect~ list) List~ReplacementEffect~
        +applyStaticAbility(List~StaticAbility~ list) List~StaticAbility~
    }
    CardTraitChanges ..|> ICardTraitChanges : implements
    CardTraitChanges ..> Card : uses
    CardTraitChanges ..> CardTraitBase : uses
    CardTraitChanges ..> ReplacementEffect : uses
    CardTraitChanges ..> SpellAbility : uses
    CardTraitChanges ..> StaticAbility : uses
    CardTraitChanges ..> Trigger : uses
```

## Relationships
**Implements:**
- [[forge.game.card.ICardTraitChanges|ICardTraitChanges]]
**Uses:**
- [[forge.game.CardTraitBase|CardTraitBase]]
- [[forge.game.card.Card|Card]]
- [[forge.game.replacement.ReplacementEffect|ReplacementEffect]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]
- [[forge.game.trigger.Trigger|Trigger]]

## Design Description

`CardTraitChanges` is an immutable record that bundles a set of trait modificationsâ€”spell abilities, triggers, replacement effects, and static abilitiesâ€”to be layered onto a card, along with an optional `remove` predicate identifying existing traits to strip. As an implementation of `ICardTraitChanges`, it serves as the unit of trait mutation in Forge's card-effect system, encapsulating both additive and subtractive changes. Each typed accessor null-coalesces to an empty list, so absent categories are handled safely without null checks at call sites. The four `apply*` methods mutate a caller-supplied list by first removing matching traits, then appending its own, giving a uniform application protocol across all four trait kinds. `copy` deep-copies every contained trait against a new host (supporting last-known-information snapshots), `changeText` cascades text substitution into each trait, and `containsCostChange` inspects its static abilities for mana-cost modification.

## Source
`forge-game/src/main/java/forge/game/card/CardTraitChanges.java`

```java
package forge.game.card;

import forge.game.CardTraitBase;
import forge.game.replacement.ReplacementEffect;
import forge.game.spellability.SpellAbility;
import forge.game.staticability.StaticAbility;
import forge.game.staticability.StaticAbilityMode;
import forge.game.trigger.Trigger;

import java.util.Collection;
import java.util.List;
import java.util.Objects;
import java.util.function.Predicate;
import java.util.stream.Collectors;

public record CardTraitChanges(
        Collection<SpellAbility> abilities,
        Collection<Trigger> triggers,
        Collection<ReplacementEffect> replacements,
        Collection<StaticAbility> staticAbilities,
        Predicate<CardTraitBase> remove
        ) implements ICardTraitChanges {

    /**
     * @return the abilities
     */
    public Collection<SpellAbility> getAbilities() {
        return Objects.requireNonNullElse(abilities, List.of());
    }

    /**
     * @return the triggers
     */
    public Collection<Trigger> getTriggers() {
        return Objects.requireNonNullElse(triggers, List.of());
    }
    /**
     * @return the replacements
     */
    public Collection<ReplacementEffect> getReplacements() {
        return Objects.requireNonNullElse(replacements, List.of());
    }

    /**
     * @return the staticAbilities
     */
    public Collection<StaticAbility> getStaticAbilities() {
        return Objects.requireNonNullElse(staticAbilities, List.of());
    }

    /**
     * Return if any of the static abilities changes the card's mana cost
     */
    public boolean containsCostChange() {
        for (StaticAbility stAb : getStaticAbilities()) {
            if (stAb.checkMode(StaticAbilityMode.ReduceCost) || stAb.checkMode(StaticAbilityMode.RaiseCost)) {
                return true;
            }
        }
        return false;
    }

    public CardTraitChanges copy(Card host, boolean lki) {
        return new CardTraitChanges(
                this.getAbilities().stream().map(sa -> sa.copy(host, lki)).collect(Collectors.toList()),
                this.getTriggers().stream().map(tr -> tr.copy(host, lki)).collect(Collectors.toList()),
                this.getReplacements().stream().map(re -> re.copy(host, lki)).collect(Collectors.toList()),
                this.getStaticAbilities().stream().map(st -> st.copy(host, lki)).collect(Collectors.toList()),
                remove
            );
    }

    public void changeText() {
        for (SpellAbility sa : this.getAbilities()) {
            sa.changeText();
        }

        for (Trigger tr : this.getTriggers()) {
            tr.changeText();
        }

        for (ReplacementEffect re : this.getReplacements()) {
            re.changeText();
        }

        for (StaticAbility sa : this.getStaticAbilities()) {
            sa.changeText();
        }
    }

    public List<SpellAbility> applySpellAbility(List<SpellAbility> list) {
        if (remove != null) {
            list.removeIf(remove);
        }
        list.addAll(getAbilities());
        return list;
    }
    public List<Trigger> applyTrigger(List<Trigger> list) {
        if (remove != null) {
            list.removeIf(remove);
        }
        list.addAll(getTriggers());
        return list;
    }
    public List<ReplacementEffect> applyReplacementEffect(List<ReplacementEffect> list) {
        if (remove != null) {
            list.removeIf(remove);
        }
        list.addAll(getReplacements());
        return list;
    }
    public List<StaticAbility> applyStaticAbility(List<StaticAbility> list) {
        if (remove != null) {
            list.removeIf(remove);
        }
        list.addAll(getStaticAbilities());
        return list;
    }
}
```

## Python
`forge/game/card/CardTraitChanges.py`

```python
from forge.game.card.ICardTraitChanges import ICardTraitChanges
from forge.game.CardTraitBase import CardTraitBase
from forge.game.card.Card import Card
from forge.game.replacement.ReplacementEffect import ReplacementEffect
from forge.game.spellability.SpellAbility import SpellAbility
from forge.game.staticability.StaticAbility import StaticAbility
from forge.game.staticability.StaticAbilityMode import StaticAbilityMode
from forge.game.trigger.Trigger import Trigger

from typing import Callable, Collection, List, Optional


class CardTraitChanges(ICardTraitChanges):
    def __init__(
            self,
            abilities: Collection[SpellAbility],
            triggers: Collection[Trigger],
            replacements: Collection[ReplacementEffect],
            staticAbilities: Collection[StaticAbility],
            remove: Optional[Callable[[CardTraitBase], bool]]
            ):
        self.abilities = abilities
        self.triggers = triggers
        self.replacements = replacements
        self.staticAbilities = staticAbilities
        self.remove = remove

    def getAbilities(self) -> Collection[SpellAbility]:
        """
        @return the abilities
        """
        return self.abilities if self.abilities is not None else []

    def getTriggers(self) -> Collection[Trigger]:
        """
        @return the triggers
        """
        return self.triggers if self.triggers is not None else []

    def getReplacements(self) -> Collection[ReplacementEffect]:
        """
        @return the replacements
        """
        return self.replacements if self.replacements is not None else []

    def getStaticAbilities(self) -> Collection[StaticAbility]:
        """
        @return the staticAbilities
        """
        return self.staticAbilities if self.staticAbilities is not None else []

    def containsCostChange(self) -> bool:
        """
        Return if any of the static abilities changes the card's mana cost
        """
        for stAb in self.getStaticAbilities():
            if stAb.checkMode(StaticAbilityMode.ReduceCost) or stAb.checkMode(StaticAbilityMode.RaiseCost):
                return True
        return False

    def copy(self, host: Card, lki: bool) -> "CardTraitChanges":
        return CardTraitChanges(
                [sa.copy(host, lki) for sa in self.getAbilities()],
                [tr.copy(host, lki) for tr in self.getTriggers()],
                [re.copy(host, lki) for re in self.getReplacements()],
                [st.copy(host, lki) for st in self.getStaticAbilities()],
                self.remove
            )

    def changeText(self) -> None:
        for sa in self.getAbilities():
            sa.changeText()

        for tr in self.getTriggers():
            tr.changeText()

        for re in self.getReplacements():
            re.changeText()

        for sa in self.getStaticAbilities():
            sa.changeText()

    def applySpellAbility(self, list: List[SpellAbility]) -> List[SpellAbility]:
        if self.remove is not None:
            list[:] = [item for item in list if not self.remove(item)]
        list.extend(self.getAbilities())
        return list

    def applyTrigger(self, list: List[Trigger]) -> List[Trigger]:
        if self.remove is not None:
            list[:] = [item for item in list if not self.remove(item)]
        list.extend(self.getTriggers())
        return list

    def applyReplacementEffect(self, list: List[ReplacementEffect]) -> List[ReplacementEffect]:
        if self.remove is not None:
            list[:] = [item for item in list if not self.remove(item)]
        list.extend(self.getReplacements())
        return list

    def applyStaticAbility(self, list: List[StaticAbility]) -> List[StaticAbility]:
        if self.remove is not None:
            list[:] = [item for item in list if not self.remove(item)]
        list.extend(self.getStaticAbilities())
        return list
```
