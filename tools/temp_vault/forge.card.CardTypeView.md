---
aliases:
  - CardTypeView
tags:
  - java/interface
  - module/forge-core
  - pkg/forge/card
fqn: forge.card.CardTypeView
package: forge.card
module: forge-core
kind: Interface
---

# CardTypeView

**Package:** `forge.card` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Interface

```mermaid
classDiagram
    class CardTypeView {
        <<interface>>
        ~isEmpty() boolean
        ~getCoreTypes() Collection~CoreType~
        ~getSupertypes() Collection~Supertype~
        ~getSubtypes() Collection~String~
        ~getExcludedCreatureSubTypes() Iterable~String~
        ~getCreatureTypes() Set~String~
        ~getLandTypes() Set~String~
        ~getBattleTypes() Set~String~
        ~hasStringType(String t) boolean
        ~hasType(CoreType type) boolean
        ~hasSupertype(Supertype supertype) boolean
        ~hasSubtype(String subtype) boolean
        ~hasCreatureType(String creatureType) boolean
        ~hasAllCreatureTypes() boolean
        ~hasABasicLandType() boolean
        ~hasANonBasicLandType() boolean
        ~sharesCreaturetypeWith(CardTypeView ctOther) boolean
        ~sharesLandTypeWith(CardTypeView ctOther) boolean
        ~sharesPermanentTypeWith(CardTypeView ctOther) boolean
        ~sharesCardTypeWith(CardTypeView ctOther) boolean
        ~sharesAllCardTypesWith(CardTypeView ctOther) boolean
        ~isPermanent() boolean
        ~isCreature() boolean
        ~isPlaneswalker() boolean
        ~isBattle() boolean
        ~isLand() boolean
        ~isArtifact() boolean
        ~isInstant() boolean
        ~isSorcery() boolean
        ~isConspiracy() boolean
        ~isVanguard() boolean
        ~isScheme() boolean
        ~isEnchantment() boolean
        ~isBasic() boolean
        ~isLegendary() boolean
        ~isSnow() boolean
        ~isBasicLand() boolean
        ~isPlane() boolean
        ~isPhenomenon() boolean
        ~isKindred() boolean
        ~isDungeon() boolean
        ~isAttachment() boolean
        ~isAura() boolean
        ~isEquipment() boolean
        ~isFortification() boolean
        ~isAttraction() boolean
        ~isContraption() boolean
        ~isSaga() boolean
        ~isHistoric() boolean
        ~isOutlaw() boolean
        ~isParty() boolean
        ~getTypeWithChanges(Iterable~ICardChangedType~ changedCardTypes) CardTypeView
    }
    CardTypeView --|> Serializable : extends
    CardTypeView ..> CoreType : uses
    CardTypeView ..> ICardChangedType : uses
    CardTypeView ..> Supertype : uses
```

## Relationships
**Uses:**
- [[forge.card.CardType.CoreType|CoreType]]
- [[forge.card.CardType.Supertype|Supertype]]
- [[forge.card.ICardChangedType|ICardChangedType]]


## Design Description

CardTypeView is a read-only contract that exposes a Magic card's type information—core types, supertypes, and the subtype categories (creature, land, battle)—without permitting mutation. As its source comment states, it "exposes only the desired functions of CardType without allowing modification," acting as an immutable view facet over the concrete CardType while leaving all modification to that implementation.

Its surface is dominated by predicate methods: membership checks (`hasType`, `hasSubtype`, `hasCreatureType`), convenience `is*` tests for every game-relevant category, and relational `shares*With` comparisons that take another CardTypeView to detect overlapping types. By extending `Serializable`, it supports persistence and network transfer, fitting Forge's client/server model. The `getTypeWithChanges` method folds a sequence of `ICardChangedType` modifications into a *new* view rather than mutating the original, reflecting a functional, immutable design in which continuous-effect type alterations produce derived views—collaborating with the `CoreType` and `Supertype` enums throughout.

## Source
`forge-core/src/main/java/forge/card/CardTypeView.java`

```java
package forge.card;

import forge.card.CardType.CoreType;
import forge.card.CardType.Supertype;

import java.io.Serializable;
import java.util.Collection;
import java.util.Set;

//Interface to expose only the desired functions of CardType without allowing modification
public interface CardTypeView extends Serializable {
    boolean isEmpty();
    Collection<CoreType> getCoreTypes();
    Collection<Supertype> getSupertypes();
    Collection<String> getSubtypes();
    Iterable<String> getExcludedCreatureSubTypes();

    Set<String> getCreatureTypes();
    Set<String> getLandTypes();
    Set<String> getBattleTypes();

    boolean hasStringType(String t);
    boolean hasType(CoreType type);
    boolean hasSupertype(Supertype supertype);
    boolean hasSubtype(String subtype);
    boolean hasCreatureType(String creatureType);
    boolean hasAllCreatureTypes();
    boolean hasABasicLandType();
    boolean hasANonBasicLandType();

    boolean sharesCreaturetypeWith(final CardTypeView ctOther);
    boolean sharesLandTypeWith(final CardTypeView ctOther);
    boolean sharesPermanentTypeWith(final CardTypeView ctOther);
    boolean sharesCardTypeWith(final CardTypeView ctOther);
    boolean sharesAllCardTypesWith(final CardTypeView ctOther);

    boolean isPermanent();
    boolean isCreature();
    boolean isPlaneswalker();
    boolean isBattle();
    boolean isLand();
    boolean isArtifact();
    boolean isInstant();
    boolean isSorcery();
    boolean isConspiracy();
    boolean isVanguard();
    boolean isScheme();
    boolean isEnchantment();
    boolean isBasic();
    boolean isLegendary();
    boolean isSnow();
    boolean isBasicLand();
    boolean isPlane();
    boolean isPhenomenon();
    boolean isKindred();
    boolean isDungeon();

    boolean isAttachment();
    boolean isAura();
    boolean isEquipment();
    boolean isFortification();
    boolean isAttraction();
    boolean isContraption();

    boolean isSaga();
    boolean isHistoric();
    boolean isOutlaw();
    boolean isParty();

    CardTypeView getTypeWithChanges(Iterable<ICardChangedType> changedCardTypes);
}
```
