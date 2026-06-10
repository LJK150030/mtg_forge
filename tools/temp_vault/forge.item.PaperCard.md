---
aliases:
  - PaperCard
tags:
  - java/class
  - module/forge-core
  - pkg/forge/item
fqn: forge.item.PaperCard
package: forge.item
module: forge-core
kind: Class
---

# PaperCard

**Package:** `forge.item` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class PaperCard {
        -long serialVersionUID
        -CardRules rules
        -String name
        -String edition
        -String collectorNumber
        -String artist
        -int artIndex
        -boolean foil
        -PaperCardFlags flags
        -String functionalVariant
        -CardRarity rarity
        -PaperCard foiledVersion
        -PaperCard noSellVersion
        -PaperCard flaglessVersion
        -Boolean hasImage
        -String displayName
        -String sortableName
        -boolean hasFlavorName
        +PaperCard FAKE_CARD
        -Set~String~ searchableNames
        -String searchableNameLang
        -String sortableCNKey
        -String cardImageKey
        -String cardAltImageKey
        +getName() String
        +getEdition() String
        +getCollectorNumber() String
        +getFunctionalVariant() String
        +getMarkedColors() ColorSet
        +getArtIndex() int
        +isFoil() boolean
        +isToken() boolean
        +getRules() CardRules
        +getRarity() CardRarity
        +getArtist() String
        +getFoiled() PaperCard
        +getUnFoiled() PaperCard
        +getNoSellVersion() PaperCard
        +getMeldBaseCard() PaperCard
        +copyWithoutFlags() PaperCard
        +copyWithFlags(Map~String,String~ flags) PaperCard
        +copyWithMarkedColors(ColorSet colors) PaperCard
        +getItemType() String
        +getMarkedFlags() PaperCardFlags
        +hasNoSellValue() boolean
        +hasImage() boolean
        +hasImage(boolean update) boolean
        +equals(Object obj) boolean
        +hashCode() int
        +toString() String
        +getCardName() String
        +getDisplayName() String
        +hasFlavorName() boolean
        +getAllSearchableNames() Set~String~
        -computeSearchableNames(String language) Set~String~
        -makeCollectorNumberSortingKey(String collectorNumber0) String
        +getCollectorNumberSortingKey() String
        +compareTo(IPaperCard o) int
        -readObject(ObjectInputStream ois) void
        -readObjectAlternate(String name, String edition) IPaperCard
        -readResolve() Object
        +getImageKey(boolean altState) String
        +getCardImageKey() String
        +getCardAltImageKey() String
        +hasBackFace() boolean
        +getMainFace() ICardFace
        +getOtherFace() ICardFace
        +getAllFaces() List~ICardFace~
        -getVariantForFace(ICardFace face) ICardFace
        +isVeryBasicLand() boolean
        +getSortableName() String
        +isUnRebalanced() boolean
        +isRebalanced() boolean
        +PaperCard(CardRules rules0, String edition0, CardRarity rarity0)
        +PaperCard(PaperCard copyFrom, PaperCardFlags flags)
        +PaperCard(CardRules rules0, String edition0, CardRarity rarity0, int artIndex0, boolean foil0, String collectorNumber0, String artist0, String functionalVariant)
        #PaperCard(CardRules rules, String edition, CardRarity rarity, int artIndex, boolean foil, String collectorNumber, String artist, String functionalVariant, PaperCardFlags flags)
    }
    PaperCard ..|> Comparable : implements
    PaperCard ..|> InventoryItemFromSet : implements
    PaperCard ..|> IPaperCard : implements
    PaperCard ..> CardRarity : uses
    PaperCard ..> CardRules : uses
    PaperCard ..> CardSplitType : uses
    PaperCard ..> CardTranslation : uses
    PaperCard ..> ColorSet : uses
    PaperCard ..> ICardFace : uses
    PaperCard ..> Localizer : uses
    PaperCard ..> PaperCardFlags : uses
    PaperCard ..> PrintSheet : uses
```

## Relationships
**Implements:**
- [[forge.item.IPaperCard|IPaperCard]]
- [[forge.item.InventoryItemFromSet|InventoryItemFromSet]]
**Uses:**
- [[forge.card.CardRarity|CardRarity]]
- [[forge.card.CardRules|CardRules]]
- [[forge.card.CardSplitType|CardSplitType]]
- [[forge.card.ColorSet|ColorSet]]
- [[forge.card.ICardFace|ICardFace]]
- [[forge.card.PrintSheet|PrintSheet]]
- [[forge.item.PaperCard.PaperCardFlags|PaperCardFlags]]
- [[forge.util.CardTranslation|CardTranslation]]
- [[forge.util.Localizer|Localizer]]

## Design Description

PaperCard is a lightweight, immutable representation of a real-world Magic card identity used outside active gamesâ€”in inventories, decks, and tradesâ€”deliberately delegating the full gameplay ruleset to its referenced CardRules. As a concrete implementation of IPaperCard and InventoryItemFromSet, it keys a card by name, edition, collector number, art index, foil status, and an immutable PaperCardFlags bundle, defining equals/hashCode and compareTo over these so instances serve as stable map keys and sort deterministically.

Its design intent centers on cheap, shareable variants: foil, no-sell, marked-color, and flagless copies are produced through copy constructors and cached transient fields rather than mutation. It collaborates with CardRarity, CardSplitType, ColorSet, and ICardFace to expose face and image data, and with CardTranslation/Localizer for localized display and searchable names. Custom serialization (readObject/readResolve) re-resolves the canonical card from StaticData and back-fills defaults for legacy saves.

## Source
`forge-core/src/main/java/forge/item/PaperCard.java`

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
package forge.item;

import forge.ImageKeys;
import forge.StaticData;
import forge.card.*;
import forge.util.*;
import org.apache.commons.lang3.StringUtils;

import java.io.*;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * A lightweight version of a card that matches real-world cards, to use outside of games (eg. inventory, decks, trade).
 * <br><br>
 * The full set of rules is in the CardRules class.
 *
 * @author Forge
 */
public class PaperCard implements Comparable<IPaperCard>, InventoryItemFromSet, IPaperCard {
    @Serial
    private static final long serialVersionUID = 2942081982620691205L;

    // Reference to rules
    private transient CardRules rules;

    // These fields are kinda PK for PrintedCard
    private final String name;
    private String edition;
    /* [NEW] Attribute to store reference to CollectorNumber of each PaperCard.
       By default the attribute is marked as "unset" so that it could be retrieved and set.
       (see getCollectorNumber())
    */
    private String collectorNumber;
    private String artist;
    private final int artIndex;
    private final boolean foil;
    private final PaperCardFlags flags;
    private final String functionalVariant;

    // Calculated fields are below:
    private transient CardRarity rarity; // rarity is given in ctor when set is assigned
    // Reference to a new instance of Self, but foiled!
    private transient PaperCard foiledVersion, noSellVersion, flaglessVersion;
    private transient Boolean hasImage;
    private transient String displayName;
    private transient String sortableName;
    private transient boolean hasFlavorName;

    @Override
    public String getName() {
        return name;
    }

    @Override
    public String getEdition() {
        return edition;
    }

    @Override
    public String getCollectorNumber() {
        if (collectorNumber == null)
            collectorNumber = IPaperCard.NO_COLLECTOR_NUMBER;
        return collectorNumber;
    }

    @Override
    public String getFunctionalVariant() {
        return functionalVariant;
    }

    @Override
    public ColorSet getMarkedColors() {
        return this.flags.markedColors;
    }

    @Override
    public int getArtIndex() {
        return artIndex;
    }

    @Override
    public boolean isFoil() {
        return foil;
    }

    @Override
    public boolean isToken() {
        return false;
    }

    @Override
    public CardRules getRules() {
        return rules;
    }

    @Override
    public CardRarity getRarity() {
        return rarity;
    }

    @Override
    public String getArtist() {
        if (this.artist == null)
            artist = IPaperCard.NO_ARTIST_NAME;
        return artist;
    }

    /* FIXME: At the moment, every card can get Foiled, with no restriction on the
        corresponding Edition - so we could Foil even Alpha cards.
    */
    public PaperCard getFoiled() {
        if (this.foil)
            return this;

        if (this.foiledVersion == null) {
            this.foiledVersion = new PaperCard(this.rules, this.edition, this.rarity,
                    this.artIndex, true, String.valueOf(collectorNumber), this.artist, this.functionalVariant);
        }
        return this.foiledVersion;
    }
    public PaperCard getUnFoiled() {
        if (!this.foil)
            return this;

        PaperCard unFoiledVersion = new PaperCard(this.rules, this.edition, this.rarity,
                this.artIndex, false, String.valueOf(collectorNumber), this.artist, this.functionalVariant);
        return unFoiledVersion;
    }
    public PaperCard getNoSellVersion() {
        if (this.flags.noSellValue)
            return this;

        if (this.noSellVersion == null)
            this.noSellVersion = new PaperCard(this, this.flags.withNoSellValueFlag(true));
        return this.noSellVersion;
    }

    public PaperCard getMeldBaseCard() {
        if (getRules().getSplitType() != CardSplitType.Meld) {
            return null;
        }

        // This is the base part of the meld duo
        if (getRules().getOtherPart() == null) {
            return this;
        }

        String meldWith = getRules().getMeldWith();
        if (meldWith == null) {
            return null;
        }
        
        List<PrintSheet> sheets = StaticData.instance().getCardEdition(this.edition).getPrintSheetsBySection();
        for (PrintSheet sheet : sheets) {
            if (sheet.contains(this)) {
                return sheet.find(PaperCardPredicates.name(meldWith));
            }
        }

        return null;
    }

    public PaperCard copyWithoutFlags() {
        if(this.flaglessVersion == null) {
            if(this.flags == PaperCardFlags.IDENTITY_FLAGS)
                this.flaglessVersion = this;
            else
                this.flaglessVersion = new PaperCard(this, null);
        }
        return flaglessVersion;
    }
    public PaperCard copyWithFlags(Map<String, String> flags) {
        if(flags == null || flags.isEmpty())
            return this.copyWithoutFlags();
        return new PaperCard(this, new PaperCardFlags(flags));
    }
    public PaperCard copyWithMarkedColors(ColorSet colors) {
        if(Objects.equals(colors, this.flags.markedColors))
            return this;
        return new PaperCard(this, this.flags.withMarkedColors(colors));
    }
    @Override
    public String getItemType() {
        final Localizer localizer = Localizer.getInstance();
        return localizer.getMessage("lblCard");
    }

    public PaperCardFlags getMarkedFlags() {
        return this.flags;
    }

    public boolean hasNoSellValue() {
        return this.flags.noSellValue;
    }
    public boolean hasImage() {
        return hasImage(false);
    }
    public boolean hasImage(boolean update) {
        if (hasImage == null || update) { //cache value since it's not free to calculate
            hasImage = ImageKeys.hasImage(this, update);
        }
        return hasImage;
    }

    public PaperCard(final CardRules rules0, final String edition0, final CardRarity rarity0) {
        this(rules0, edition0, rarity0, IPaperCard.DEFAULT_ART_INDEX, false,
                IPaperCard.NO_COLLECTOR_NUMBER, IPaperCard.NO_ARTIST_NAME, IPaperCard.NO_FUNCTIONAL_VARIANT);
    }

    public PaperCard(final PaperCard copyFrom, final PaperCardFlags flags) {
        this(copyFrom.rules, copyFrom.edition, copyFrom.rarity, copyFrom.artIndex, copyFrom.foil, copyFrom.collectorNumber,
                copyFrom.artist, copyFrom.functionalVariant, flags);
        this.flaglessVersion = copyFrom.flaglessVersion;
    }

    public PaperCard(final CardRules rules0, final String edition0, final CardRarity rarity0,
                     final int artIndex0, final boolean foil0, final String collectorNumber0,
                     final String artist0, final String functionalVariant) {
        this(rules0, edition0, rarity0, artIndex0, foil0, collectorNumber0, artist0, functionalVariant, null);
    }

    protected PaperCard(final CardRules rules, final String edition, final CardRarity rarity,
                     final int artIndex, final boolean foil, final String collectorNumber,
                     final String artist, final String functionalVariant, final PaperCardFlags flags) {
        if (rules == null || edition == null || rarity == null) {
            throw new IllegalArgumentException("Cannot create card without rules, edition or rarity");
        }
        this.rules = rules;
        name = rules.getName();
        this.edition = edition;
        this.artIndex = Math.max(artIndex, IPaperCard.DEFAULT_ART_INDEX);
        this.foil = foil;
        this.rarity = rarity;
        this.artist = artist;
        this.collectorNumber = (collectorNumber != null && !collectorNumber.isEmpty()) ? collectorNumber : IPaperCard.NO_COLLECTOR_NUMBER;
        this.functionalVariant = functionalVariant != null ? functionalVariant : IPaperCard.NO_FUNCTIONAL_VARIANT;
        this.displayName = rules.getDisplayNameForVariant(functionalVariant);
        this.hasFlavorName = !name.equals(displayName);
        // If the user changes the language this will make cards sort by the old language until they restart the game.
        // This is a good tradeoff
        this.sortableName = TextUtil.toSortableName(CardTranslation.getTranslatedName(displayName));

        if(flags == null || flags.equals(PaperCardFlags.IDENTITY_FLAGS))
            this.flags = PaperCardFlags.IDENTITY_FLAGS;
        else
            this.flags = flags;
    }

    public static PaperCard FAKE_CARD = new PaperCard(CardRules.getUnsupportedCardNamed("Fake Card"), "Fake Edition", CardRarity.Common);

    // Want this class to be a key for HashTable
    @Override
    public boolean equals(final Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }

        final PaperCard other = (PaperCard) obj;
        if (!name.equals(other.name)) {
            return false;
        }
        if (!edition.equals(other.edition)) {
            return false;
        }
        if (!getCollectorNumber().equals(other.getCollectorNumber()))
            return false;
        if (!Objects.equals(flags, other.flags))
            return false;
        return (other.foil == foil) && (other.artIndex == artIndex);
    }

    /*
     * (non-Javadoc)
     *
     * @see java.lang.Object#hashCode()
     */
    @Override
    public int hashCode() {
        return Objects.hash(name, edition, collectorNumber, artIndex, foil, flags);
    }

    // FIXME: Check
    @Override
    public String toString() {
        return CardTranslation.getTranslatedName(name);
        // cannot still decide, if this "name|set" format is needed anymore
        // return String.format("%s|%s", name, cardSet);
    }
    public String getCardName() {
        return name;
    }

    @Override
    public String getDisplayName() {
        return this.displayName;
    }

    @Override
    public boolean hasFlavorName() {
        return this.hasFlavorName;
    }

    private transient Set<String> searchableNames = null;
    private transient String searchableNameLang = null;

    public Set<String> getAllSearchableNames() {
        if(this.searchableNames != null && CardTranslation.getLanguageSelected().equals(searchableNameLang))
            return searchableNames;
        if(searchableNameLang != null) //Changed the language. May as well update this.
            sortableName = TextUtil.toSortableName(CardTranslation.getTranslatedName(displayName));
        searchableNameLang = CardTranslation.getLanguageSelected();
        searchableNames = computeSearchableNames(searchableNameLang);
        return searchableNames;
    }

    private Set<String> computeSearchableNames(String language) {
        ICardFace otherFace = this.getOtherFace();
        if(otherFace == null && NO_FUNCTIONAL_VARIANT.equals(this.functionalVariant))
        {
            //99% of cases will land here. This could possibly be optimized further by computing and storing this on
            //the CardRules instead, but flavor names will still need to work per-print, or at least per-variant.
            if("en-US".equals(language))
                return Set.of(this.name);
            else {
                String translatedName = CardTranslation.getTranslatedName(this.name);
                return Stream.of(this.name, translatedName, StringUtils.stripAccents(translatedName))
                        .filter(Objects::nonNull)
                        .collect(Collectors.toSet());
            }
        }
        Set<String> names = new HashSet<>();
        ICardFace mainFace = this.getMainFace();
        names.add(mainFace.getName());
        String mainFlavor = mainFace.getFlavorName();
        if(mainFlavor != null)
            names.add(mainFlavor);
        if(otherFace != null) {
            names.add(otherFace.getName());
            String otherFlavor = otherFace.getFlavorName();
            if(otherFlavor != null)
                names.add(otherFlavor);

            names.add(mainFace.getName() + " // " + otherFace.getName());
            if(mainFlavor != null && otherFlavor != null)
                names.add(mainFlavor + " // " + otherFlavor);
        }
        if(!"en-US".equals(language)) {
            Set<String> translated = names.stream().map(CardTranslation::getTranslatedName).filter(Objects::nonNull).collect(Collectors.toSet());
            names.addAll(translated);
        }
        Set<String> noAccents = names.stream().map(StringUtils::stripAccents).collect(Collectors.toSet());
        names.addAll(noAccents);
        return names;
    }

    /*
     * This (utility) method transform a collectorNumber String into a key string for sorting.
     * This method proxies the same strategy implemented in CardEdition.CardInSet class from which the
     * collectorNumber of PaperCard instances are originally retrieved.
     * This is also to centralise the criterion, whilst avoiding code duplication.
     *
     * Note: The method has been made private as this is for internal API use **only**, to allow
     * for generalised comparison with IPaperCard instances (see compareTo)
     *
     * The public API of PaperCard includes a method (i.e. getCollectorNumberSortingKey) which applies
     * this method on instance's own collector number.
     *
     * @return a zero-padded 5-digits String + any non-numerical content in the input String, properly attached.
     */
    private static String makeCollectorNumberSortingKey(final String collectorNumber0){
        String collectorNumber = collectorNumber0;
        if (collectorNumber.equals(NO_COLLECTOR_NUMBER))
            collectorNumber = null;
        return CardEdition.getSortableCollectorNumber(collectorNumber);
    }

    private String sortableCNKey = null;
    public String getCollectorNumberSortingKey(){
        if (sortableCNKey == null) {
            // Hardly the case, but just invoke getter rather than direct
            // attribute to be sure that collectorNumber has been retrieved already!
            sortableCNKey = makeCollectorNumberSortingKey(getCollectorNumber());
        }
        return sortableCNKey;
    }

    @Override
    public int compareTo(final IPaperCard o) {
        final int nameCmp = name.compareToIgnoreCase(o.getName());
        if (0 != nameCmp) {
            return nameCmp;
        }
        //FIXME: compare sets properly
        int setDiff = edition.compareTo(o.getEdition());
        if (0 != setDiff)
            return setDiff;
        String thisCollNrKey = getCollectorNumberSortingKey();
        String othrCollNrKey = makeCollectorNumberSortingKey(o.getCollectorNumber());
        final int collNrCmp = thisCollNrKey.compareTo(othrCollNrKey);
        if (0 != collNrCmp) {
            return collNrCmp;
        }
        return Integer.compare(artIndex, o.getArtIndex());
    }

    @Serial
    private void readObject(ObjectInputStream ois) throws ClassNotFoundException, IOException {
        // default deserialization
        ois.defaultReadObject();

        IPaperCard pc = StaticData.instance().getCommonCards().getCard(name, edition, artIndex);
        if (pc == null) {
            pc = StaticData.instance().getVariantCards().getCard(name, edition, artIndex);
            if (pc == null) {
                System.out.println("PaperCard: " + name + " not found with set and index " + edition + ", " + artIndex);
                pc = readObjectAlternate(name, edition);
                if (pc == null) {
                    pc = StaticData.instance().getCommonCards().createUnsupportedCard(name);
                    //throw new IOException(TextUtil.concatWithSpace("Card", name, "not found with set and index", edition, Integer.toString(artIndex)));
                }
                System.out.println("Alternate object found: " + pc.getName() + ", " + pc.getEdition() + ", " + pc.getArtIndex());
            }
        }
        rules = pc.getRules();
        rarity = pc.getRarity();
        displayName = pc.getDisplayName();
        hasFlavorName = pc.hasFlavorName();
        sortableName = TextUtil.toSortableName(CardTranslation.getTranslatedName(displayName));
    }

    private IPaperCard readObjectAlternate(String name, String edition) throws ClassNotFoundException, IOException {
        IPaperCard pc = StaticData.instance().getCommonCards().getCard(name, edition);
        if (pc == null) {
            pc = StaticData.instance().getVariantCards().getCard(name, edition);
        }

        if (pc == null) {
            pc = StaticData.instance().getCommonCards().getCard(name);
            if (pc == null) {
                pc = StaticData.instance().getVariantCards().getCard(name);
            }
        }

        return pc;
    }

    @Serial
    private Object readResolve() throws ObjectStreamException {
        //If we deserialize an old PaperCard with no flags, reinitialize as a fresh copy to set default flags.
        if(this.flags == null)
            return new PaperCard(this, null);
        return this;
    }

    @Override
    public String getImageKey(boolean altState) {
        String normalizedName = StringUtils.stripAccents(name);
        String imageKey = ImageKeys.CARD_PREFIX + normalizedName + CardDb.NameSetSeparator
                + edition + CardDb.NameSetSeparator + artIndex;
        if (altState) {
            imageKey += ImageKeys.BACKFACE_POSTFIX;
        }
        return imageKey;
    }

    private String cardImageKey = null;
    @Override
    public String getCardImageKey() {
        if (this.cardImageKey == null)
            this.cardImageKey = ImageUtil.getImageKey(this, "", true);
        return cardImageKey;
    }

    private String cardAltImageKey = null;
    @Override
    public String getCardAltImageKey() {
        if (this.cardAltImageKey == null){
            if (this.hasBackFace())
                this.cardAltImageKey = ImageUtil.getImageKey(this, "back", true);
            else  // altImageKey will be the same as cardImageKey
                this.cardAltImageKey = ImageUtil.getImageKey(this, "", true);
        }
        return cardAltImageKey;
    }

    @Override
    public boolean hasBackFace(){
        CardSplitType cst = this.rules.getSplitType();
        return cst == CardSplitType.Transform || cst == CardSplitType.Flip || cst == CardSplitType.Meld
                || cst == CardSplitType.Modal;
    }

    @Override
    public ICardFace getMainFace() {
        ICardFace face = this.rules.getMainPart();
        return this.getVariantForFace(face);
    }

    @Override
    public ICardFace getOtherFace() {
        ICardFace face = this.rules.getOtherPart();
        if(face == null)
            return null;
        return this.getVariantForFace(face);
    }

    @Override
    public List<ICardFace> getAllFaces() {
        return this.rules.getAllFaces().stream().map(this::getVariantForFace).collect(Collectors.toList());
    }

    private ICardFace getVariantForFace(ICardFace face) {
        if(!face.hasFunctionalVariants() || this.functionalVariant.equals(NO_FUNCTIONAL_VARIANT))
            return face;
        ICardFace variant = face.getFunctionalVariant(this.functionalVariant);
        if(variant == null) {
            System.err.printf("Tried to apply unknown or unsupported variant - Card: \"%s\"; Variant: %s\n", face.getName(), this.functionalVariant);
            return face;
        }
        return variant;
    }

    // Return true if card is one of the five basic lands that can be added for free
    public boolean isVeryBasicLand() {
        return (this.getName().equals("Swamp"))
                || (this.getName().equals("Plains"))
                || (this.getName().equals("Island"))
                || (this.getName().equals("Forest"))
                || (this.getName().equals("Mountain"));
    }

    public String getSortableName() {
        return sortableName;
    }
    public boolean isUnRebalanced() {
        return StaticData.instance().isRebalanced("A-" + name);
    }
    public boolean isRebalanced() {
        return StaticData.instance().isRebalanced(name);
    }

    /**
     * Contains properties of a card which distinguish it from an otherwise identical copy of the card with the same
     * name, edition, and collector number. Examples include permanent markings on the card, and flags for Adventure
     * mode.
     */
    public static class PaperCardFlags implements Serializable {
        @Serial
        private static final long serialVersionUID = -3924720485840169336L;

        /**
         * Chosen colors, for cards like Cryptic Spires.
         */
        public final ColorSet markedColors;
        /**
         * Removes the sell value of the card in Adventure mode.
         */
        public final boolean noSellValue;

        //TODO: Could probably move foil here.

        static final PaperCardFlags IDENTITY_FLAGS = new PaperCardFlags(Map.of());

        protected PaperCardFlags(Map<String, String> flags) {
            if(flags.containsKey("markedColors"))
                markedColors = ColorSet.fromNames(flags.get("markedColors").split(""));
            else
                markedColors = null;
            noSellValue = flags.containsKey("noSellValue");
        }

        //Copy constructor. There are some better ways to do this, and they should be explored once we have more than 4
        //or 5 fields here. Just need to ensure it's impossible to accidentally change a field while the PaperCardFlags
        //object is in use.
        private PaperCardFlags(PaperCardFlags copyFrom, ColorSet markedColors, Boolean noSellValue) {
            if(markedColors == null)
                markedColors = copyFrom.markedColors;
            else if(markedColors.isColorless())
                markedColors = null;
            this.markedColors = markedColors;
            this.noSellValue = noSellValue != null ? noSellValue : copyFrom.noSellValue;
        }

        public PaperCardFlags withMarkedColors(ColorSet markedColors) {
            if(markedColors == null)
                markedColors = ColorSet.C;
            return new PaperCardFlags(this, markedColors, null);
        }

        public PaperCardFlags withNoSellValueFlag(boolean noSellValue) {
            return new PaperCardFlags(this, null, noSellValue);
        }

        private Map<String, String> asMap;
        public Map<String, String> toMap() {
            if(asMap != null)
                return asMap;
            Map<String, String> out = new HashMap<>();
            if(markedColors != null && !markedColors.isColorless())
                out.put("markedColors", markedColors.toString());
            if(noSellValue)
                out.put("noSellValue", "true");
            asMap = out;
            return out;
        }

        @Override
        public String toString() {
            return this.toMap().entrySet().stream()
                    .map((e) -> e.getKey() + "=" + e.getValue())
                    .collect(Collectors.joining("\t"));
        }

        @Override
        public boolean equals(Object o) {
            if (!(o instanceof PaperCardFlags that)) return false;
            return noSellValue == that.noSellValue && Objects.equals(markedColors, that.markedColors);
        }

        @Override
        public int hashCode() {
            return Objects.hash(markedColors, noSellValue);
        }
    }
}
```

## Python
`forge/item/PaperCard.py`

```python
from forge.ImageKeys import ImageKeys
from forge.StaticData import StaticData
from forge.card.CardRarity import CardRarity
from forge.card.CardRules import CardRules
from forge.card.CardSplitType import CardSplitType
from forge.card.ColorSet import ColorSet
from forge.card.ICardFace import ICardFace
from forge.card.PrintSheet import PrintSheet
from forge.card.CardEdition import CardEdition
from forge.card.CardDb import CardDb
from forge.item.IPaperCard import IPaperCard
from forge.item.InventoryItemFromSet import InventoryItemFromSet
from forge.item.PaperCardPredicates import PaperCardPredicates
from forge.util.CardTranslation import CardTranslation
from forge.util.Localizer import Localizer
from forge.util.TextUtil import TextUtil
from forge.util.ImageUtil import ImageUtil

import sys
import unicodedata


def _stripAccents(s):
    # Equivalent of org.apache.commons.lang3.StringUtils.stripAccents
    if s is None:
        return None
    normalized = unicodedata.normalize("NFD", s)
    return "".join(c for c in normalized if unicodedata.category(c) != "Mn")


def _compareTo(a, b):
    if a == b:
        return 0
    return -1 if a < b else 1


def _compareToIgnoreCase(a, b):
    al, bl = a.lower(), b.lower()
    if al == bl:
        return 0
    return -1 if al < bl else 1


def _intCompare(a, b):
    return (a > b) - (a < b)


class PaperCard(InventoryItemFromSet, IPaperCard):
    serialVersionUID = 2942081982620691205

    class PaperCardFlags:
        """
        Contains properties of a card which distinguish it from an otherwise identical copy of the card with the same
        name, edition, and collector number. Examples include permanent markings on the card, and flags for Adventure
        mode.
        """
        serialVersionUID = -3924720485840169336

        def __init__(self, *args):
            if len(args) == 1:
                flags = args[0]
                if "markedColors" in flags:
                    self.markedColors = ColorSet.fromNames(list(flags.get("markedColors")))
                else:
                    self.markedColors = None
                self.noSellValue = "noSellValue" in flags
            else:
                # Copy constructor. There are some better ways to do this, and they should be explored once we have more
                # than 4 or 5 fields here. Just need to ensure it's impossible to accidentally change a field while the
                # PaperCardFlags object is in use.
                copyFrom, markedColors, noSellValue = args
                if markedColors is None:
                    markedColors = copyFrom.markedColors
                elif markedColors.isColorless():
                    markedColors = None
                self.markedColors = markedColors
                self.noSellValue = noSellValue if noSellValue is not None else copyFrom.noSellValue
            self.asMap = None

        def withMarkedColors(self, markedColors):
            if markedColors is None:
                markedColors = ColorSet.C
            return PaperCard.PaperCardFlags(self, markedColors, None)

        def withNoSellValueFlag(self, noSellValue):
            return PaperCard.PaperCardFlags(self, None, noSellValue)

        def toMap(self):
            if self.asMap is not None:
                return self.asMap
            out = {}
            if self.markedColors is not None and not self.markedColors.isColorless():
                out["markedColors"] = str(self.markedColors)
            if self.noSellValue:
                out["noSellValue"] = "true"
            self.asMap = out
            return out

        def __str__(self):
            return "\t".join(k + "=" + v for k, v in self.toMap().items())

        def toString(self):
            return self.__str__()

        def equals(self, o):
            if not isinstance(o, PaperCard.PaperCardFlags):
                return False
            return self.noSellValue == o.noSellValue and self.markedColors == o.markedColors

        def __eq__(self, o):
            return self.equals(o)

        def hashCode(self):
            return hash((self.markedColors, self.noSellValue))

        def __hash__(self):
            return self.hashCode()

    def __init__(self, *args):
        if len(args) == 3:
            rules0, edition0, rarity0 = args
            self._init(rules0, edition0, rarity0, IPaperCard.DEFAULT_ART_INDEX, False,
                       IPaperCard.NO_COLLECTOR_NUMBER, IPaperCard.NO_ARTIST_NAME, IPaperCard.NO_FUNCTIONAL_VARIANT, None)
        elif len(args) == 2:
            copyFrom, flags = args
            self._init(copyFrom.rules, copyFrom.edition, copyFrom.rarity, copyFrom.artIndex, copyFrom.foil,
                       copyFrom.collectorNumber, copyFrom.artist, copyFrom.functionalVariant, flags)
            self.flaglessVersion = copyFrom.flaglessVersion
        elif len(args) == 8:
            rules0, edition0, rarity0, artIndex0, foil0, collectorNumber0, artist0, functionalVariant = args
            self._init(rules0, edition0, rarity0, artIndex0, foil0, collectorNumber0, artist0, functionalVariant, None)
        elif len(args) == 9:
            self._init(*args)
        else:
            raise TypeError("Invalid arguments for PaperCard constructor")

    def _init(self, rules, edition, rarity, artIndex, foil, collectorNumber, artist, functionalVariant, flags):
        if rules is None or edition is None or rarity is None:
            raise ValueError("Cannot create card without rules, edition or rarity")
        self.rules = rules
        self.name = rules.getName()
        self.edition = edition
        self.artIndex = max(artIndex, IPaperCard.DEFAULT_ART_INDEX)
        self.foil = foil
        self.rarity = rarity
        self.artist = artist
        self.collectorNumber = collectorNumber if (collectorNumber is not None and collectorNumber != "") else IPaperCard.NO_COLLECTOR_NUMBER
        self.functionalVariant = functionalVariant if functionalVariant is not None else IPaperCard.NO_FUNCTIONAL_VARIANT
        self.displayName = rules.getDisplayNameForVariant(functionalVariant)
        self.hasFlavorName = not (self.name == self.displayName)
        # If the user changes the language this will make cards sort by the old language until they restart the game.
        # This is a good tradeoff
        self.sortableName = TextUtil.toSortableName(CardTranslation.getTranslatedName(self.displayName))

        if flags is None or flags == PaperCard.PaperCardFlags.IDENTITY_FLAGS:
            self.flags = PaperCard.PaperCardFlags.IDENTITY_FLAGS
        else:
            self.flags = flags

        # transient / calculated fields
        self.foiledVersion = None
        self.noSellVersion = None
        self.flaglessVersion = None
        self.hasImage = None
        self.searchableNames = None
        self.searchableNameLang = None
        self.sortableCNKey = None
        self.cardImageKey = None
        self.cardAltImageKey = None

    def getName(self):
        return self.name

    def getEdition(self):
        return self.edition

    def getCollectorNumber(self):
        if self.collectorNumber is None:
            self.collectorNumber = IPaperCard.NO_COLLECTOR_NUMBER
        return self.collectorNumber

    def getFunctionalVariant(self):
        return self.functionalVariant

    def getMarkedColors(self):
        return self.flags.markedColors

    def getArtIndex(self):
        return self.artIndex

    def isFoil(self):
        return self.foil

    def isToken(self):
        return False

    def getRules(self):
        return self.rules

    def getRarity(self):
        return self.rarity

    def getArtist(self):
        if self.artist is None:
            self.artist = IPaperCard.NO_ARTIST_NAME
        return self.artist

    # FIXME: At the moment, every card can get Foiled, with no restriction on the
    # corresponding Edition - so we could Foil even Alpha cards.
    def getFoiled(self):
        if self.foil:
            return self

        if self.foiledVersion is None:
            self.foiledVersion = PaperCard(self.rules, self.edition, self.rarity,
                                           self.artIndex, True, str(self.collectorNumber), self.artist, self.functionalVariant)
        return self.foiledVersion

    def getUnFoiled(self):
        if not self.foil:
            return self

        unFoiledVersion = PaperCard(self.rules, self.edition, self.rarity,
                                    self.artIndex, False, str(self.collectorNumber), self.artist, self.functionalVariant)
        return unFoiledVersion

    def getNoSellVersion(self):
        if self.flags.noSellValue:
            return self

        if self.noSellVersion is None:
            self.noSellVersion = PaperCard(self, self.flags.withNoSellValueFlag(True))
        return self.noSellVersion

    def getMeldBaseCard(self):
        if self.getRules().getSplitType() != CardSplitType.Meld:
            return None

        # This is the base part of the meld duo
        if self.getRules().getOtherPart() is None:
            return self

        meldWith = self.getRules().getMeldWith()
        if meldWith is None:
            return None

        sheets = StaticData.instance().getCardEdition(self.edition).getPrintSheetsBySection()
        for sheet in sheets:
            if sheet.contains(self):
                return sheet.find(PaperCardPredicates.name(meldWith))

        return None

    def copyWithoutFlags(self):
        if self.flaglessVersion is None:
            if self.flags == PaperCard.PaperCardFlags.IDENTITY_FLAGS:
                self.flaglessVersion = self
            else:
                self.flaglessVersion = PaperCard(self, None)
        return self.flaglessVersion

    def copyWithFlags(self, flags):
        if flags is None or len(flags) == 0:
            return self.copyWithoutFlags()
        return PaperCard(self, PaperCard.PaperCardFlags(flags))

    def copyWithMarkedColors(self, colors):
        if colors == self.flags.markedColors:
            return self
        return PaperCard(self, self.flags.withMarkedColors(colors))

    def getItemType(self):
        localizer = Localizer.getInstance()
        return localizer.getMessage("lblCard")

    def getMarkedFlags(self):
        return self.flags

    def hasNoSellValue(self):
        return self.flags.noSellValue

    def hasImage(self, update=False):
        if self.hasImage is None or update:  # cache value since it's not free to calculate
            self.hasImage = ImageKeys.hasImage(self, update)
        return self.hasImage

    FAKE_CARD = None

    # Want this class to be a key for HashTable
    def equals(self, obj):
        if self is obj:
            return True
        if obj is None:
            return False
        if type(self) != type(obj):
            return False

        other = obj
        if self.name != other.name:
            return False
        if self.edition != other.edition:
            return False
        if self.getCollectorNumber() != other.getCollectorNumber():
            return False
        if self.flags != other.flags:
            return False
        return (other.foil == self.foil) and (other.artIndex == self.artIndex)

    def __eq__(self, obj):
        return self.equals(obj)

    def hashCode(self):
        return hash((self.name, self.edition, self.collectorNumber, self.artIndex, self.foil, self.flags))

    def __hash__(self):
        return self.hashCode()

    # FIXME: Check
    def toString(self):
        return CardTranslation.getTranslatedName(self.name)
        # cannot still decide, if this "name|set" format is needed anymore
        # return String.format("%s|%s", name, cardSet);

    def __str__(self):
        return self.toString()

    def getCardName(self):
        return self.name

    def getDisplayName(self):
        return self.displayName

    def hasFlavorName(self):
        return self.hasFlavorName

    def getAllSearchableNames(self):
        if self.searchableNames is not None and CardTranslation.getLanguageSelected() == self.searchableNameLang:
            return self.searchableNames
        if self.searchableNameLang is not None:  # Changed the language. May as well update this.
            self.sortableName = TextUtil.toSortableName(CardTranslation.getTranslatedName(self.displayName))
        self.searchableNameLang = CardTranslation.getLanguageSelected()
        self.searchableNames = self.computeSearchableNames(self.searchableNameLang)
        return self.searchableNames

    def computeSearchableNames(self, language):
        otherFace = self.getOtherFace()
        if otherFace is None and IPaperCard.NO_FUNCTIONAL_VARIANT == self.functionalVariant:
            # 99% of cases will land here. This could possibly be optimized further by computing and storing this on
            # the CardRules instead, but flavor names will still need to work per-print, or at least per-variant.
            if language == "en-US":
                return {self.name}
            else:
                translatedName = CardTranslation.getTranslatedName(self.name)
                return {n for n in (self.name, translatedName, _stripAccents(translatedName)) if n is not None}
        names = set()
        mainFace = self.getMainFace()
        names.add(mainFace.getName())
        mainFlavor = mainFace.getFlavorName()
        if mainFlavor is not None:
            names.add(mainFlavor)
        if otherFace is not None:
            names.add(otherFace.getName())
            otherFlavor = otherFace.getFlavorName()
            if otherFlavor is not None:
                names.add(otherFlavor)

            names.add(mainFace.getName() + " // " + otherFace.getName())
            if mainFlavor is not None and otherFlavor is not None:
                names.add(mainFlavor + " // " + otherFlavor)
        if language != "en-US":
            translated = {t for t in (CardTranslation.getTranslatedName(n) for n in names) if t is not None}
            names.update(translated)
        noAccents = {_stripAccents(n) for n in names}
        names.update(noAccents)
        return names

    # This (utility) method transform a collectorNumber String into a key string for sorting.
    # This method proxies the same strategy implemented in CardEdition.CardInSet class from which the
    # collectorNumber of PaperCard instances are originally retrieved.
    # This is also to centralise the criterion, whilst avoiding code duplication.
    #
    # Note: The method has been made private as this is for internal API use **only**, to allow
    # for generalised comparison with IPaperCard instances (see compareTo)
    #
    # The public API of PaperCard includes a method (i.e. getCollectorNumberSortingKey) which applies
    # this method on instance's own collector number.
    #
    # @return a zero-padded 5-digits String + any non-numerical content in the input String, properly attached.
    @staticmethod
    def makeCollectorNumberSortingKey(collectorNumber0):
        collectorNumber = collectorNumber0
        if collectorNumber == IPaperCard.NO_COLLECTOR_NUMBER:
            collectorNumber = None
        return CardEdition.getSortableCollectorNumber(collectorNumber)

    def getCollectorNumberSortingKey(self):
        if self.sortableCNKey is None:
            # Hardly the case, but just invoke getter rather than direct
            # attribute to be sure that collectorNumber has been retrieved already!
            self.sortableCNKey = PaperCard.makeCollectorNumberSortingKey(self.getCollectorNumber())
        return self.sortableCNKey

    def compareTo(self, o):
        nameCmp = _compareToIgnoreCase(self.name, o.getName())
        if 0 != nameCmp:
            return nameCmp
        # FIXME: compare sets properly
        setDiff = _compareTo(self.edition, o.getEdition())
        if 0 != setDiff:
            return setDiff
        thisCollNrKey = self.getCollectorNumberSortingKey()
        othrCollNrKey = PaperCard.makeCollectorNumberSortingKey(o.getCollectorNumber())
        collNrCmp = _compareTo(thisCollNrKey, othrCollNrKey)
        if 0 != collNrCmp:
            return collNrCmp
        return _intCompare(self.artIndex, o.getArtIndex())

    def __lt__(self, o):
        return self.compareTo(o) < 0

    def readObject(self, ois):
        # default deserialization
        ois.defaultReadObject()

        pc = StaticData.instance().getCommonCards().getCard(self.name, self.edition, self.artIndex)
        if pc is None:
            pc = StaticData.instance().getVariantCards().getCard(self.name, self.edition, self.artIndex)
            if pc is None:
                print("PaperCard: " + self.name + " not found with set and index " + self.edition + ", " + str(self.artIndex))
                pc = self.readObjectAlternate(self.name, self.edition)
                if pc is None:
                    pc = StaticData.instance().getCommonCards().createUnsupportedCard(self.name)
                    # raise IOException(TextUtil.concatWithSpace("Card", name, "not found with set and index", edition, Integer.toString(artIndex)))
                print("Alternate object found: " + pc.getName() + ", " + pc.getEdition() + ", " + str(pc.getArtIndex()))
        self.rules = pc.getRules()
        self.rarity = pc.getRarity()
        self.displayName = pc.getDisplayName()
        self.hasFlavorName = pc.hasFlavorName()
        self.sortableName = TextUtil.toSortableName(CardTranslation.getTranslatedName(self.displayName))

    def readObjectAlternate(self, name, edition):
        pc = StaticData.instance().getCommonCards().getCard(name, edition)
        if pc is None:
            pc = StaticData.instance().getVariantCards().getCard(name, edition)

        if pc is None:
            pc = StaticData.instance().getCommonCards().getCard(name)
            if pc is None:
                pc = StaticData.instance().getVariantCards().getCard(name)

        return pc

    def readResolve(self):
        # If we deserialize an old PaperCard with no flags, reinitialize as a fresh copy to set default flags.
        if self.flags is None:
            return PaperCard(self, None)
        return self

    def getImageKey(self, altState):
        normalizedName = _stripAccents(self.name)
        imageKey = ImageKeys.CARD_PREFIX + normalizedName + CardDb.NameSetSeparator \
            + self.edition + CardDb.NameSetSeparator + str(self.artIndex)
        if altState:
            imageKey += ImageKeys.BACKFACE_POSTFIX
        return imageKey

    def getCardImageKey(self):
        if self.cardImageKey is None:
            self.cardImageKey = ImageUtil.getImageKey(self, "", True)
        return self.cardImageKey

    def getCardAltImageKey(self):
        if self.cardAltImageKey is None:
            if self.hasBackFace():
                self.cardAltImageKey = ImageUtil.getImageKey(self, "back", True)
            else:  # altImageKey will be the same as cardImageKey
                self.cardAltImageKey = ImageUtil.getImageKey(self, "", True)
        return self.cardAltImageKey

    def hasBackFace(self):
        cst = self.rules.getSplitType()
        return cst == CardSplitType.Transform or cst == CardSplitType.Flip or cst == CardSplitType.Meld \
            or cst == CardSplitType.Modal

    def getMainFace(self):
        face = self.rules.getMainPart()
        return self.getVariantForFace(face)

    def getOtherFace(self):
        face = self.rules.getOtherPart()
        if face is None:
            return None
        return self.getVariantForFace(face)

    def getAllFaces(self):
        return [self.getVariantForFace(face) for face in self.rules.getAllFaces()]

    def getVariantForFace(self, face):
        if not face.hasFunctionalVariants() or self.functionalVariant == IPaperCard.NO_FUNCTIONAL_VARIANT:
            return face
        variant = face.getFunctionalVariant(self.functionalVariant)
        if variant is None:
            print("Tried to apply unknown or unsupported variant - Card: \"%s\"; Variant: %s" % (face.getName(), self.functionalVariant), file=sys.stderr)
            return face
        return variant

    # Return true if card is one of the five basic lands that can be added for free
    def isVeryBasicLand(self):
        return (self.getName() == "Swamp") \
            or (self.getName() == "Plains") \
            or (self.getName() == "Island") \
            or (self.getName() == "Forest") \
            or (self.getName() == "Mountain")

    def getSortableName(self):
        return self.sortableName

    def isUnRebalanced(self):
        return StaticData.instance().isRebalanced("A-" + self.name)

    def isRebalanced(self):
        return StaticData.instance().isRebalanced(self.name)


PaperCard.PaperCardFlags.IDENTITY_FLAGS = PaperCard.PaperCardFlags({})

PaperCard.FAKE_CARD = PaperCard(CardRules.getUnsupportedCardNamed("Fake Card"), "Fake Edition", CardRarity.Common)
```
