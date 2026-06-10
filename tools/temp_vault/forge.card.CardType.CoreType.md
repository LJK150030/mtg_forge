---
aliases:
  - CoreType
tags:
  - java/enum
  - module/forge-core
  - pkg/forge/card
fqn: forge.card.CardType.CoreType
package: forge.card
module: forge-core
kind: Enum
---

# CoreType

**Package:** `forge.card` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Enum

```mermaid
classDiagram
    class CoreType {
        <<enumeration>>
        Kindred
        Artifact
        Battle
        Conspiracy
        Enchantment
        Creature
        Dungeon
        Instant
        Land
        Phenomenon
        Plane
        Planeswalker
        Scheme
        Sorcery
        Vanguard
        +boolean isPermanent
        +String pluralName
        +String label
        -Map~String,CoreType~ stringToCoreType
        -Set~String~ allCoreTypeNames
        +Set~CoreType~ spellTypes
        +getEnum(String name) CoreType
        +isValidEnum(String name) boolean
        +toGamePieceType() GamePieceType
        +getName() String
        +getTranslatedName() String
        ~CoreType(boolean permanent, String plural, String label)
    }
    CoreType ..|> ITranslatable : implements
    CoreType ..> GamePieceType : uses
```

## Relationships
**Implements:**
- [[forge.util.ITranslatable|ITranslatable]]
**Uses:**
- [[forge.card.GamePieceType|GamePieceType]]

## Design Description

`CoreType` is an enumeration that models the fundamental card types in Magic: The Gathering's rules engine, naming each canonical type (Creature, Instant, Land, etc.) and pairing it with intrinsic metadata: whether it denotes a permanent, its pluralized form, and a localization label key. By implementing `ITranslatable`, each constant exposes both its raw and translated display name, integrating the type system with Forge's localization layer.

The enum is designed as a lightweight, immutable value catalog: constructor-supplied final fields, a static name-to-constant lookup map, and a precomputed `spellTypes` set support fast validation and classification without instantiation. Its `toGamePieceType()` method bridges to `GamePieceType`, mapping each core type to the game-piece category it typically producesâ€”while the documentation candidly notes this coarse mapping ignores subtype-derived pieces. The result is a central, authoritative reference that other card-handling code consults rather than reimplementing type semantics.

## Source
`forge-core/src/main/java/forge/card/CardType.java` Ã¢â‚¬â€ declaration excerpt

```java
    public enum CoreType implements ITranslatable {
        Kindred(false, "kindreds", "lblKindred"), // always printed first
        Artifact(true, "artifacts", "lblArtifact"),
        Battle(true, "battles", "lblBattle"),
        Conspiracy(false, "conspiracies", "lblConspiracy"),
        Enchantment(true, "enchantments", "lblEnchantment"),
        Creature(true, "creatures", "lblCreature"),
        Dungeon(false, "dungeons", "lblDungeon"),
        Instant(false, "instants", "lblInstant"),
        Land(true, "lands", "lblLand"),
        Phenomenon(false, "phenomenons", "lblPhenomenon"),
        Plane(false, "planes", "lblPlane"),
        Planeswalker(true, "planeswalkers", "lblPlaneswalker"),
        Scheme(false, "schemes", "lblScheme"),
        Sorcery(false, "sorceries", "lblSorcery"),
        Vanguard(false, "vanguards", "lblVanguard");

        public final boolean isPermanent;
        public final String pluralName;
        public final String label;
        private static Map<String, CoreType> stringToCoreType = EnumUtils.getEnumMap(CoreType.class);
        private static final Set<String> allCoreTypeNames = stringToCoreType.keySet();
        public static final Set<CoreType> spellTypes = ImmutableSet.of(Instant, Sorcery);

        public static CoreType getEnum(String name) {
            return stringToCoreType.get(name);
        }

        public static boolean isValidEnum(String name) {
            return stringToCoreType.containsKey(name);
        }

        CoreType(final boolean permanent, final String plural, final String label) {
            isPermanent = permanent;
            pluralName = plural;
            this.label = label;
        }

        /**
         * Converts this core type to whichever GamePieceType is typical of it.
         * Be aware that this will not catch GamePieceTypes derived from subtypes,
         * such as Attractions.
         * @return a GamePieceType appropriate for this core type.
         */
        public GamePieceType toGamePieceType() {
            return switch (this) {
            case Plane, Phenomenon -> GamePieceType.PLANAR;
            case Scheme -> GamePieceType.SCHEME;
            case Dungeon -> GamePieceType.DUNGEON;
            case Vanguard -> GamePieceType.AVATAR;
            default -> GamePieceType.CARD;
            };
        }

        @Override
        public String getName() {
            return this.name();
        }

        @Override
        public String getTranslatedName() {
            return Localizer.getInstance().getMessage(label);
        }
    }
```

## Python
`forge/card/CardType/CoreType.py`

```python
from enum import Enum

from forge.util.ITranslatable import ITranslatable
from forge.util.Localizer import Localizer
from forge.card.GamePieceType import GamePieceType


class CoreType(ITranslatable, Enum):
    Kindred = (False, "kindreds", "lblKindred")  # always printed first
    Artifact = (True, "artifacts", "lblArtifact")
    Battle = (True, "battles", "lblBattle")
    Conspiracy = (False, "conspiracies", "lblConspiracy")
    Enchantment = (True, "enchantments", "lblEnchantment")
    Creature = (True, "creatures", "lblCreature")
    Dungeon = (False, "dungeons", "lblDungeon")
    Instant = (False, "instants", "lblInstant")
    Land = (True, "lands", "lblLand")
    Phenomenon = (False, "phenomenons", "lblPhenomenon")
    Plane = (False, "planes", "lblPlane")
    Planeswalker = (True, "planeswalkers", "lblPlaneswalker")
    Scheme = (False, "schemes", "lblScheme")
    Sorcery = (False, "sorceries", "lblSorcery")
    Vanguard = (False, "vanguards", "lblVanguard")

    def __init__(self, permanent: bool, plural: str, label: str):
        self.isPermanent = permanent
        self.pluralName = plural
        self.label = label

    @staticmethod
    def getEnum(name: str) -> "CoreType":
        return stringToCoreType.get(name)

    @staticmethod
    def isValidEnum(name: str) -> bool:
        return name in stringToCoreType

    def toGamePieceType(self) -> GamePieceType:
        if self in (CoreType.Plane, CoreType.Phenomenon):
            return GamePieceType.PLANAR
        elif self is CoreType.Scheme:
            return GamePieceType.SCHEME
        elif self is CoreType.Dungeon:
            return GamePieceType.DUNGEON
        elif self is CoreType.Vanguard:
            return GamePieceType.AVATAR
        else:
            return GamePieceType.CARD

    def getName(self) -> str:
        return self.name

    def getTranslatedName(self) -> str:
        return Localizer.getInstance().getMessage(self.label)


stringToCoreType: dict[str, CoreType] = {ct.name: ct for ct in CoreType}
allCoreTypeNames: set[str] = set(stringToCoreType.keys())
spellTypes: set[CoreType] = frozenset({CoreType.Instant, CoreType.Sorcery})
```
