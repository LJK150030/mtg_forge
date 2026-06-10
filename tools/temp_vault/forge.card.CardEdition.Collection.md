---
aliases:
  - Collection
tags:
  - java/class
  - module/forge-core
  - pkg/forge/card
fqn: forge.card.CardEdition.Collection
package: forge.card
module: forge-core
kind: Class
---

# Collection

**Package:** `forge.card` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class Collection {
        -Map~String,CardEdition~ aliasToEdition
        -boolean lock
        +Comparator~PaperCard~ CARD_EDITION_COMPARATOR
        -initAliases(CardEdition E) void
        +add(CardEdition item) void
        +append(CardEdition.Collection C) void
        +get(String code) CardEdition
        +getOrderedEditions() Iterable~CardEdition~
        +getPrereleaseEditions() Iterable~CardEdition~
        +getEditionByCodeOrThrow(String code) CardEdition
        +getCode2ByCode(String code) String
        +getBoosterGenerator() IItemReader~SealedTemplate~
        +getTheLatestOfAllTheOriginalEditionsOfCardsIn(CardPool cards) CardEdition
        +Collection(IItemReader~CardEdition~ reader)
    }
    Collection --|> StorageBase : extends
    Collection ..> CardDb : uses
    Collection ..> CardEdition : uses
    Collection ..> CardPool : uses
    Collection ..> IItemReader : uses
    Collection ..> PaperCard : uses
    Collection ..> SealedTemplate : uses
    Collection ..> StorageReaderBase : uses
```

## Relationships
**Extends:**
- [[forge.util.storage.StorageBase|StorageBase]]
**Uses:**
- [[forge.card.CardDb|CardDb]]
- [[forge.card.CardEdition|CardEdition]]
- [[forge.deck.CardPool|CardPool]]
- [[forge.item.PaperCard|PaperCard]]
- [[forge.item.SealedTemplate|SealedTemplate]]
- [[forge.util.IItemReader|IItemReader]]
- [[forge.util.storage.StorageReaderBase|StorageReaderBase]]

## Design Description

`CardEdition.Collection` is a specialized, in-memory store of all known card sets, extending `StorageBase<CardEdition>` to inherit code-keyed storage and iteration while layering edition-specific lookup and query logic on top. Its core responsibility is resolving an edition from a string code, transparently falling back from primary three-letter codes to a case-insensitive alias map of two-letter codes and aliases (`aliasToEdition`). Beyond lookup, it exposes higher-level queries: chronologically ordered editions, prerelease editions, code translation for image generation, an on-demand `SealedTemplate` booster reader, and a `CardPool` analysis that finds the most recent original printing edition across a pool's cards (collaborating with `CardDb`/`StaticData`).

A notable design intent is selective immutability: the storage is conceptually read-only, but `add`/`append` permit injecting custom user content until a `lock` flag is set, after which writes throw. Alias registration is centralized in `initAliases` so custom editions stay consistently discoverable.

## Source
`forge-core/src/main/java/forge/card/CardEdition.java` Ã¢â‚¬â€ declaration excerpt

```java
    public static class Collection extends StorageBase<CardEdition> {
        private final Map<String, CardEdition> aliasToEdition = new TreeMap<>(String.CASE_INSENSITIVE_ORDER);
        private boolean lock = false; //Lock once custom content has been added.
        public Collection(IItemReader<CardEdition> reader) {
            super("Card editions", reader);

            for (CardEdition ee : this) {
                initAliases(ee);
            }
        }
        private void initAliases(CardEdition E) { //Add the alias to the edition here, to ensure it's always done equally.
            String alias = E.getAlias();
            if (null != alias)
                aliasToEdition.put(alias, E);
            aliasToEdition.put(E.getCode2(), E);
        }
        @Override
        public void add(CardEdition item) { //Even though we want it to be read only, make an exception for custom content.
            if (lock) throw new UnsupportedOperationException("This is a read-only storage");
            else map.put(item.getCode(), item);
        }
        public void append(CardEdition.Collection C) { //Append custom editions
            if (lock) throw new UnsupportedOperationException("This is a read-only storage");
            for (CardEdition E : C) { //Update the alias list as above or else it'll fail to look up.
                this.add(E);
                initAliases(E); //Made a method in case the system changes, so it's consistent.
            }
            CardEdition customBucket = new CardEdition("2990-01-01", "USER", "USER", Type.CUSTOM_SET, "USER", FoilType.NOT_SUPPORTED);
            this.add(customBucket);
            initAliases(customBucket);
            this.lock = true; //Consider it initialized and prevent from writing any more data.
        }

        //Gets a sets by code.  It will search first by three letter codes, then by aliases and two-letter codes.
        @Override
        public CardEdition get(final String code) {
            if (code == null) {
                return null;
            }

            CardEdition baseResult = super.get(code);
            return baseResult == null ? aliasToEdition.get(code) : baseResult;
        }

        public Iterable<CardEdition> getOrderedEditions() {
            List<CardEdition> res = Lists.newArrayList(this);
            Collections.sort(res);
            Collections.reverse(res);
            return res;
        }

        public Iterable<CardEdition> getPrereleaseEditions() {
            return this.stream()
                    .filter(edition -> edition.getPrerelease() != null)
                    .collect(Collectors.toList());
        }

        public CardEdition getEditionByCodeOrThrow(final String code) {
            final CardEdition set = this.get(code);
            if (null == set && code.equals(UNKNOWN_CODE)) //Hardcoded set ??? is not with the others, needs special check.
                return UNKNOWN;
            if (null == set) {
                throw new RuntimeException("Edition with code '" + code + "' not found");
            }
            return set;
        }

        // used by image generating code
        public String getCode2ByCode(final String code) {
            final CardEdition set = this.get(code);
            return set == null ? "" : set.getCode2();
        }

        public final Comparator<PaperCard> CARD_EDITION_COMPARATOR = Comparator.comparing(c -> Collection.this.get(c.getEdition()));

        public IItemReader<SealedTemplate> getBoosterGenerator() {
            return new StorageReaderBase<>(null) {
                @Override
                public Map<String, SealedTemplate> readAll() {
                    Map<String, SealedTemplate> map = new TreeMap<>(String.CASE_INSENSITIVE_ORDER);
                    for (CardEdition ce : Collection.this) {
                        List<String> boosterTypes = Lists.newArrayList(ce.getAvailableBoosterTypes());
                        for (String type : boosterTypes) {
                            String setAffix = type.equals("Draft") ? "" : type;

                            map.put(ce.getCode() + setAffix, ce.getBoosterTemplate(type));
                        }
                    }
                    return map;
                }

                @Override
                public String getItemKey(SealedTemplate item) {
                    return item.getEdition();
                }

                @Override
                public String getFullPath() {
                    return null;
                }
            };
        }

        /* @leriomaggio
          The original name "getEarliestEditionWithAllCards" was completely misleading, as it did
          not reflect at all what the method really does (and what's the original goal).

          What the method does is to return the **latest** (as in the most recent)
          Card Edition among all the different "Original" sets (as in "first print") were cards
          in the Pool can be found.
          Therefore, nothing to do with an Edition "including" all the cards.
         */
        public CardEdition getTheLatestOfAllTheOriginalEditionsOfCardsIn(CardPool cards) {
            Set<String> minEditions = new HashSet<>();
            CardDb db = StaticData.instance().getCommonCards();
            for (Entry<PaperCard, Integer> k : cards) {
                // NOTE: Even if we do force a very stringent Policy on Editions
                // (which only considers core, expansions, and reprint editions), the fetch method
                // is flexible enough to relax the constraint automatically, if no card can be found
                // under those conditions (i.e. ORIGINAL_ART_ALL_EDITIONS will be automatically used instead).
                PaperCard cp = db.getCardFromEditions(k.getKey().getName(),
                                                      CardArtPreference.ORIGINAL_ART_CORE_EXPANSIONS_REPRINT_ONLY);
                if (cp == null)   // it's unlikely, this code will ever run. Only Happens if card does not exist.
                    cp = k.getKey();
                minEditions.add(cp.getEdition());
            }
            for (CardEdition ed : getOrderedEditions()) {
                if (minEditions.contains(ed.getCode()))
                    return ed;
            }
            return UNKNOWN;
        }
    }
```

## Python
`forge/card/CardEdition/Collection.py`

```python
from forge.util.storage.StorageBase import StorageBase
from forge.card.CardDb import CardDb
from forge.card.CardEdition import CardEdition
from forge.deck.CardPool import CardPool
from forge.item.PaperCard import PaperCard
from forge.item.SealedTemplate import SealedTemplate
from forge.util.IItemReader import IItemReader
from forge.util.storage.StorageReaderBase import StorageReaderBase
from forge.StaticData import StaticData


class Collection(StorageBase):
    def __init__(self, reader: IItemReader):
        super().__init__("Card editions", reader)

        self.aliasToEdition: dict[str, CardEdition] = {}  # case-insensitive (String.CASE_INSENSITIVE_ORDER)
        self.lock = False  # Lock once custom content has been added.

        # Comparator<PaperCard> CARD_EDITION_COMPARATOR
        self.CARD_EDITION_COMPARATOR = lambda c: self.get(c.getEdition())

        for ee in self:
            self.initAliases(ee)

    def initAliases(self, E: CardEdition) -> None:  # Add the alias to the edition here, to ensure it's always done equally.
        alias = E.getAlias()
        if alias is not None:
            self._putAlias(alias, E)
        self._putAlias(E.getCode2(), E)

    def _putAlias(self, key: str, E: CardEdition) -> None:
        # Emulate TreeMap(String.CASE_INSENSITIVE_ORDER): keys compared case-insensitively.
        for existing in list(self.aliasToEdition.keys()):
            if existing.lower() == key.lower():
                self.aliasToEdition[existing] = E
                return
        self.aliasToEdition[key] = E

    def _getAlias(self, code: str) -> CardEdition:
        for existing, value in self.aliasToEdition.items():
            if existing.lower() == code.lower():
                return value
        return None

    def add(self, item: CardEdition) -> None:  # Even though we want it to be read only, make an exception for custom content.
        if self.lock:
            raise NotImplementedError("This is a read-only storage")
        else:
            self.map[item.getCode()] = item

    def append(self, C: "Collection") -> None:  # Append custom editions
        if self.lock:
            raise NotImplementedError("This is a read-only storage")
        for E in C:  # Update the alias list as above or else it'll fail to look up.
            self.add(E)
            self.initAliases(E)  # Made a method in case the system changes, so it's consistent.
        customBucket = CardEdition("2990-01-01", "USER", "USER", CardEdition.Type.CUSTOM_SET, "USER", CardEdition.FoilType.NOT_SUPPORTED)
        self.add(customBucket)
        self.initAliases(customBucket)
        self.lock = True  # Consider it initialized and prevent from writing any more data.

    # Gets a sets by code.  It will search first by three letter codes, then by aliases and two-letter codes.
    def get(self, code: str) -> CardEdition:
        if code is None:
            return None

        baseResult = super().get(code)
        return self._getAlias(code) if baseResult is None else baseResult

    def getOrderedEditions(self):
        res = list(self)
        res.sort()
        res.reverse()
        return res

    def getPrereleaseEditions(self):
        return [edition for edition in self if edition.getPrerelease() is not None]

    def getEditionByCodeOrThrow(self, code: str) -> CardEdition:
        set = self.get(code)
        if set is None and code == CardEdition.UNKNOWN_CODE:  # Hardcoded set ??? is not with the others, needs special check.
            return CardEdition.UNKNOWN
        if set is None:
            raise RuntimeError("Edition with code '" + code + "' not found")
        return set

    # used by image generating code
    def getCode2ByCode(self, code: str) -> str:
        set = self.get(code)
        return "" if set is None else set.getCode2()

    def getBoosterGenerator(self) -> IItemReader:
        outer = self

        class _BoosterReader(StorageReaderBase):
            def __init__(self):
                super().__init__(None)

            def readAll(self) -> dict[str, SealedTemplate]:
                map: dict[str, SealedTemplate] = {}  # TreeMap(String.CASE_INSENSITIVE_ORDER)
                for ce in outer:
                    boosterTypes = list(ce.getAvailableBoosterTypes())
                    for type in boosterTypes:
                        setAffix = "" if type == "Draft" else type

                        map[ce.getCode() + setAffix] = ce.getBoosterTemplate(type)
                return map

            def getItemKey(self, item: SealedTemplate) -> str:
                return item.getEdition()

            def getFullPath(self) -> str:
                return None

        return _BoosterReader()

    # @leriomaggio
    #   The original name "getEarliestEditionWithAllCards" was completely misleading, as it did
    #   not reflect at all what the method really does (and what's the original goal).
    #
    #   What the method does is to return the **latest** (as in the most recent)
    #   Card Edition among all the different "Original" sets (as in "first print") were cards
    #   in the Pool can be found.
    #   Therefore, nothing to do with an Edition "including" all the cards.
    def getTheLatestOfAllTheOriginalEditionsOfCardsIn(self, cards: CardPool) -> CardEdition:
        minEditions: set[str] = set()
        db = StaticData.instance().getCommonCards()
        for k in cards:
            # NOTE: Even if we do force a very stringent Policy on Editions
            # (which only considers core, expansions, and reprint editions), the fetch method
            # is flexible enough to relax the constraint automatically, if no card can be found
            # under those conditions (i.e. ORIGINAL_ART_ALL_EDITIONS will be automatically used instead).
            cp = db.getCardFromEditions(k.getKey().getName(),
                                        CardDb.CardArtPreference.ORIGINAL_ART_CORE_EXPANSIONS_REPRINT_ONLY)
            if cp is None:  # it's unlikely, this code will ever run. Only Happens if card does not exist.
                cp = k.getKey()
            minEditions.add(cp.getEdition())
        for ed in self.getOrderedEditions():
            if ed.getCode() in minEditions:
                return ed
        return CardEdition.UNKNOWN
```
