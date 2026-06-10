---
aliases:
  - CardRules
tags:
  - java/class
  - module/forge-core
  - pkg/forge/card
fqn: forge.card.CardRules
package: forge.card
module: forge-core
kind: Class
---

# CardRules

**Package:** `forge.card` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class CardRules {
        -String normalizedName
        -CardSplitType splitType
        -ICardFace mainPart
        -ICardFace otherPart
        -Map~CardStateName,ICardFace~ specializedParts
        -List~ICardFace~ allFaces
        -CardAiHints aiHints
        -ColorSet colorIdentity
        -ColorSet deckbuildingColors
        -String meldWith
        -String partnerWith
        -String partnerType
        -int setColorID
        -boolean custom
        -boolean unsupported
        -Map~Integer,String~ placeholderFaces
        -String path
        -int deltaHand
        -int deltaLife
        -List~String~ tokens
        -Set~String~ supportedFunctionalVariants
        ~reinitializeFromRules(CardRules newRules) void
        -calculateColorIdentity(CardRules rules) ColorSet
        -calculateColorIdentity(ICardFace face) byte
        +isVariant() boolean
        +getSplitType() CardSplitType
        +getMainPart() ICardFace
        +getOtherPart() ICardFace
        +getSpecializeParts() Map~CardStateName,ICardFace~
        +getAllFaces() List~ICardFace~
        +isTransformable() boolean
        +getWSpecialize() ICardFace
        +getUSpecialize() ICardFace
        +getBSpecialize() ICardFace
        +getRSpecialize() ICardFace
        +getGSpecialize() ICardFace
        +getName() String
        +getPreInitName() String
        +getNormalizedName() String
        +getPath() String
        +setPath(String path) void
        +getAiHints() CardAiHints
        +isCustom() boolean
        +setCustom() void
        +isUnsupported() boolean
        +getType() CardType
        +getManaCost() ManaCost
        +getColor() ColorSet
        -canCastFace(ICardFace face, byte colorCode) boolean
        +canCastWithAvailable(byte colorCode) boolean
        +getIntPower() int
        +getIntToughness() int
        +getPower() String
        +getToughness() String
        +getInitialLoyalty() String
        +getDefense() String
        +getAttractionLights() Set~Integer~
        +getOracleText() String
        +isEnterableDungeon() boolean
        +canBeCommander() boolean
        +canBePartnerCommanders(CardRules b) boolean
        +canBePartnerCommander() boolean
        +canBeBackground() boolean
        +isDoctor() boolean
        +canBeOathbreaker() boolean
        +canBeSignatureSpell() boolean
        +canBeBrawlCommander() boolean
        +canBeTinyLeadersCommander() boolean
        +canBeCreature() boolean
        +getMeldWith() String
        +getPartnerWith() String
        +getAddsWildCardColor() boolean
        +getSetColorID() int
        +getTokens() List~String~
        +getHand() int
        +getLife() int
        +setVanguardProperties(String pt) void
        +hasFunctionalVariants() boolean
        +getSupportedFunctionalVariants() Set~String~
        +getDisplayNameForVariant(String variantName) String
        ~findOrCreateVariantForFlavorName(String flavorName, String suggestedVariantName) String
        ~hasPlaceholderFaces() boolean
        ~supplyPlaceholderFaces(Map~String,ICardFace~ facesByName) void
        +getColorIdentity() ColorSet
        +fromScript(Iterable~String~ script) CardRules
        +getUnsupportedCardNamed(String name) CardRules
        +hasKeyword(String k) boolean
        +hasStartOfKeyword(String k) boolean
        +hasStartOfKeyword(String k, ICardFace cf) boolean
        +getKeywordMagnitude(String k) Integer
        +getDeckbuildingColors() ColorSet
        +CardRules(ICardFace[] faces, CardSplitType altMode, CardAiHints cah)
    }
    CardRules ..|> ICardCharacteristics : implements
    CardRules ..> CardAiHints : uses
    CardRules ..> CardFace : uses
    CardRules ..> CardSplitType : uses
    CardRules ..> CardStateName : uses
    CardRules ..> CardType : uses
    CardRules ..> ColorSet : uses
    CardRules ..> DeckHints : uses
    CardRules ..> ICardFace : uses
    CardRules ..> ManaCost : uses
    CardRules ..> Reader : uses
```

## Relationships
**Implements:**
- [[forge.card.ICardCharacteristics|ICardCharacteristics]]
**Uses:**
- [[forge.card.CardAiHints|CardAiHints]]
- [[forge.card.CardFace|CardFace]]
- [[forge.card.CardRules.Reader|Reader]]
- [[forge.card.CardSplitType|CardSplitType]]
- [[forge.card.CardStateName|CardStateName]]
- [[forge.card.CardType|CardType]]
- [[forge.card.ColorSet|ColorSet]]
- [[forge.card.DeckHints|DeckHints]]
- [[forge.card.ICardFace|ICardFace]]
- [[forge.card.mana.ManaCost|ManaCost]]

## Design Description

`CardRules` is the immutable, fully-resolved model of a Magic card's metadata and gameplay rules. It aggregates one or more `ICardFace` partsâ€”main, other, and the W/U/B/R/G specialize facesâ€”under a `CardSplitType` whose aggregation method governs how their names, types, mana costs, colors, and oracle text combine into a single view. By implementing `ICardCharacteristics`, it exposes that unified card-level interface while delegating per-face data to its `ICardFace` collaborators, and it derives higher-order properties such as color identity, deckbuilding colors, and the many commander/format-eligibility predicates (Brawl, Oathbreaker, partner, Background, Doctor).

Construction is funneled through the nested reusable `Reader`, which parses line-based scripts into `CardFace`, `CardAiHints`, `DeckHints`, and `ManaCost` instances, separating parsing from the rules model. Design intent shows in its deferred initializationâ€”`CopyFaceFrom` placeholder faces and lazily recomputed color identity let cards cross-reference before all scripts loadâ€”and in hand-tuned loops that avoid `toCharArray`/`toUnmodifiableList` for allocation cost and Android compatibility.

## Source
`forge-core/src/main/java/forge/card/CardRules.java`

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
package forge.card;

import com.google.common.collect.Iterables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import forge.card.mana.ManaCost;
import forge.util.TextUtil;
import org.apache.commons.lang3.StringUtils;

import java.util.*;
import java.util.stream.Collectors;

import static forge.card.MagicColor.Constant.BASIC_LANDS;
import static org.apache.commons.lang3.StringUtils.containsIgnoreCase;

/**
 * A collection of methods containing full
 * meta and gameplay properties of a card.
 *
 * @author Forge
 * @version $Id: CardRules.java 9708 2011-08-09 19:34:12Z jendave $
 */
public final class CardRules implements ICardCharacteristics {
    private String normalizedName;
    private CardSplitType splitType;
    private ICardFace mainPart;
    private ICardFace otherPart;
    private Map<CardStateName, ICardFace> specializedParts = Maps.newHashMap();
    private List<ICardFace> allFaces;

    private CardAiHints aiHints;
    private ColorSet colorIdentity;
    private ColorSet deckbuildingColors;
    private String meldWith;
    private String partnerWith;
    private String partnerType;
    private int setColorID;
    private boolean custom;
    private boolean unsupported;
    private Map<Integer, String> placeholderFaces;
    private String path;

    public CardRules(ICardFace[] faces, CardSplitType altMode, CardAiHints cah) {
        splitType = altMode;
        mainPart = faces[0];
        otherPart = faces[1];

        if (CardSplitType.Specialize.equals(splitType)) {
            specializedParts.put(CardStateName.SpecializeW, faces[2]);
            specializedParts.put(CardStateName.SpecializeU, faces[3]);
            specializedParts.put(CardStateName.SpecializeB, faces[4]);
            specializedParts.put(CardStateName.SpecializeR, faces[5]);
            specializedParts.put(CardStateName.SpecializeG, faces[6]);
        }

        // Android doesn't support toUnmodifiableList
        allFaces = Arrays.stream(faces).filter(Objects::nonNull).collect(Collectors.toList());

        aiHints = cah;
        meldWith = "";
        partnerWith = "";
        partnerType = "";
        setColorID = 0;

        colorIdentity = calculateColorIdentity(this);
    }

    void reinitializeFromRules(CardRules newRules) {
        if (!newRules.getName().equals(this.getName()))
            throw new UnsupportedOperationException("You cannot rename the card using the same CardRules object");

        splitType = newRules.splitType;
        mainPart = newRules.mainPart;
        otherPart = newRules.otherPart;
        specializedParts = Maps.newHashMap(newRules.specializedParts);
        allFaces = newRules.allFaces;
        aiHints = newRules.aiHints;
        colorIdentity = newRules.colorIdentity;
        meldWith = newRules.meldWith;
        partnerWith = newRules.partnerWith;
        setColorID = newRules.setColorID;
        tokens = newRules.tokens;
    }

    private static ColorSet calculateColorIdentity(CardRules rules) {
        byte colMask = calculateColorIdentity(rules.mainPart);

        if (rules.otherPart != null) {
            colMask |= calculateColorIdentity(rules.otherPart);
        }
        return ColorSet.fromMask(colMask);
    }

    private static byte calculateColorIdentity(final ICardFace face) {
        if (face == null)
            return 0; //Still initializing; filled in during supplyPlaceholderFaces
        byte res = face.getColor().getColor();
        boolean isReminder = false;
        boolean isSymbol = false;
        String oracleText = face.getOracleText();
        // CR 903.4 colors defined by its characteristic-defining abilities
        for (String staticAbility : face.getStaticAbilities()) {
            if (staticAbility.contains("CharacteristicDefining$ True") && staticAbility.contains("SetColor$ All")) {
                return MagicColor.ALL_COLORS;
            }
        }
        // no need to check oracle if it is already all colors
        if (res == MagicColor.ALL_COLORS) {
            return res;
        }
        int len = oracleText.length();
        for (int i = 0; i < len; i++) {
            char c = oracleText.charAt(i); // This is to avoid needless allocations performed by toCharArray()
            switch (c) {
                case('('): isReminder = i > 0; break; // if oracle has only reminder, consider it valid rules (basic and true lands need this)
                case(')'): isReminder = false; break;
                case('{'): isSymbol = true; break;
                case('}'): isSymbol = false; break;
                default:
                    if (isSymbol && !isReminder) {
                        switch(c) {
                            case('W'): res |= MagicColor.WHITE; break;
                            case('U'): res |= MagicColor.BLUE; break;
                            case('B'): res |= MagicColor.BLACK; break;
                            case('R'): res |= MagicColor.RED; break;
                            case('G'): res |= MagicColor.GREEN; break;
                        }
                    }
                    break;
            }
        }
        return res;
    }

    public boolean isVariant() {
        if (placeholderFaces != null && (mainPart == null || splitType.getAggregationMethod() == CardSplitType.FaceSelectionMethod.COMBINE))
            return false; //Type line isn't fully generated, and we need it to determine if this is a variant type
        CardType t = getType();
        return t.isVanguard() || t.isScheme() || t.isPlane() || t.isPhenomenon()
                || t.isConspiracy() || t.isDungeon() || t.isAttraction() || t.isContraption();
    }

    public CardSplitType getSplitType() {
        return splitType;
    }

    public ICardFace getMainPart() {
        return mainPart;
    }

    public ICardFace getOtherPart() {
        return otherPart;
    }

    public Map<CardStateName, ICardFace> getSpecializeParts() {
        return specializedParts;
    }

    public List<ICardFace> getAllFaces() {
        return allFaces;
    }

    public boolean isTransformable() {
        return CardSplitType.Transform == getSplitType() || CardSplitType.Modal == getSplitType();
    }

    public ICardFace getWSpecialize() {
        return specializedParts.get(CardStateName.SpecializeW);
    }
    public ICardFace getUSpecialize() {
        return specializedParts.get(CardStateName.SpecializeU);
    }
    public ICardFace getBSpecialize() {
        return specializedParts.get(CardStateName.SpecializeB);
    }
    public ICardFace getRSpecialize() {
        return specializedParts.get(CardStateName.SpecializeR);
    }
    public ICardFace getGSpecialize() {
        return specializedParts.get(CardStateName.SpecializeG);
    }

    public String getName() {
        switch (splitType.getAggregationMethod()) {
            case COMBINE:
                return mainPart.getName() + " // " + otherPart.getName();
            default:
                return mainPart.getName();
        }
    }

    /**
     * Similar to `getName`, but goes through some extra steps to figure out the card's name in the event that
     * one or more of the card faces isn't fully initialized yet. This should never be necessary outside of
     * CardDB initialization.
     */
    public String getPreInitName() { //Would make this package private but StaticData needs it.
        if (this.placeholderFaces == null)
            return getName();
        String mainName =  mainPart == null ? placeholderFaces.get(0) : mainPart.getName();
        if (splitType.getAggregationMethod() == CardSplitType.FaceSelectionMethod.COMBINE) {
            String otherName =  otherPart == null ? placeholderFaces.get(1) : otherPart.getName();
            return mainName + " // " + otherName;
        }
        return mainName;
    }

    public String getNormalizedName() { return normalizedName; }

    public String getPath() { return path; }
    public void setPath(String path) { this.path = path; }

    public CardAiHints getAiHints() {
        return aiHints;
    }

    public boolean isCustom() { return custom; }
    public void setCustom() { custom = true; }

    public boolean isUnsupported() { return unsupported; }

    @Override
    public CardType getType() {
        if (mainPart == null) {
            return new CardType(false); // Still initializing; filled in during supplyPlaceholderFaces
        }
        switch (splitType.getAggregationMethod()) {
            case COMBINE: // no cards currently have different types
                if (otherPart == null) {
                    return mainPart.getType();
                }
                return CardType.combine(mainPart.getType(), otherPart.getType());
            default:
                return mainPart.getType();
        }
    }

    @Override
    public ManaCost getManaCost() {
        switch (splitType.getAggregationMethod()) {
            case COMBINE:
                return ManaCost.combine(mainPart.getManaCost(), otherPart.getManaCost());
            default:
                return mainPart.getManaCost();
        }
    }

    @Override
    public ColorSet getColor() {
        switch (splitType.getAggregationMethod()) {
            case COMBINE:
                return ColorSet.combine(mainPart.getColor(), otherPart.getColor());
            default:
                return mainPart.getColor();
        }
    }

    private static boolean canCastFace(final ICardFace face, final byte colorCode) {
        if (face.getManaCost().isNoCost()) {
            //if card face has no cost, assume castable only by mana of its defined color
            return face.getColor().hasNoColorsExcept(colorCode);
        }
        return face.getManaCost().canBePaidWithAvailable(colorCode);
    }

    public boolean canCastWithAvailable(byte colorCode) {
        switch (splitType.getAggregationMethod()) {
            case COMBINE:
                return canCastFace(mainPart, colorCode) || canCastFace(otherPart, colorCode);
            default:
                return canCastFace(mainPart, colorCode);
        }
    }

    @Override public int getIntPower() { return mainPart.getIntPower(); }
    @Override public int getIntToughness() { return mainPart.getIntToughness(); }
    @Override public String getPower() { return mainPart.getPower(); }
    @Override public String getToughness() { return mainPart.getToughness(); }
    @Override public String getInitialLoyalty() { return mainPart.getInitialLoyalty(); }

    @Override
    public String getDefense() {
        return mainPart.getDefense();
    }

    @Override public Set<Integer> getAttractionLights() { return mainPart.getAttractionLights(); }

    @Override
    public String getOracleText() {
        switch (splitType.getAggregationMethod()) {
            case COMBINE:
                return mainPart.getOracleText() + "\r\n\r\n" + otherPart.getOracleText();
            default:
                return mainPart.getOracleText();
        }
    }

    public boolean isEnterableDungeon() {
        if (mainPart.getOracleText().contains("You can't enter this dungeon unless")) {
            return false;
        }
        return getType().isDungeon();
    }

    public boolean canBeCommander() {
        if (mainPart.getOracleText().contains("can be your commander") || canBeBackground()) {
            return true;
        }
        CardType type = mainPart.getType();
        if (!type.isLegendary()) {
            return false;
        }
        if (canBeCreature() || type.isVehicle() || (
                type.isSpacecraft() && getPower() != null)) {
            // Spacecraft need printed PT
            return true;
        }
        return false;
    }

    public boolean canBePartnerCommanders(CardRules b) {
        if (!(canBePartnerCommander() && b.canBePartnerCommander())) {
            return false;
        }
        if (hasKeyword("Partner") && b.hasKeyword("Partner")) {
            return true; // normal partner commander
        }
        if (getName().equals(b.getPartnerWith()) && b.getName().equals(getPartnerWith())) {
            return true; // paired partner commander
        }

        if (!this.partnerType.isEmpty() && this.partnerType.equals(b.partnerType)) {
            return true;
        }

        if (hasKeyword("Choose a Background") && b.canBeBackground()
                || b.hasKeyword("Choose a Background") && canBeBackground()) {
            return true; // commander with background
        }
        if (isDoctor() && b.hasKeyword("Doctor's companion")
                || hasKeyword("Doctor's companion") && b.isDoctor()) {
            return true; // Doctor Who partner commander
        }
        return false;
    }

    public boolean canBePartnerCommander() {
        if (canBeBackground()) {
            return true;
        }
        if (!canBeCommander()) {
            return false;
        }
        return hasKeyword("Partner") || !this.partnerWith.isEmpty() || !this.partnerType.isEmpty() ||
                hasKeyword("Choose a Background") || hasKeyword("Doctor's companion") || isDoctor();
    }

    public boolean canBeBackground() {
        return mainPart.getType().hasSubtype("Background");
    }

    public boolean isDoctor() {
        Set<String> subtypes = new HashSet<>();
        for (String type : mainPart.getType().getSubtypes()) {
            subtypes.add(type);
        }

        return subtypes.size() == 2 &&
                subtypes.contains("Time Lord") &&
                subtypes.contains("Doctor");
    }

    public boolean canBeOathbreaker() {
        CardType type = mainPart.getType();
        if (mainPart.getOracleText().contains("can be your commander")) {
            return true;
        }
        return type.isPlaneswalker();
    }

    public boolean canBeSignatureSpell() {
        CardType type = mainPart.getType();
        return type.isInstant() || type.isSorcery();
    }

    public boolean canBeBrawlCommander() {
        CardType type = mainPart.getType();
        if (!type.isLegendary()) {
            return false;
        }
        if (canBeCreature() || type.isPlaneswalker()) {
            return true;
        }
        return false;
    }

    public boolean canBeTinyLeadersCommander() {
        CardType type = mainPart.getType();
        if (!type.isLegendary()) {
            return false;
        }
        if (canBeCreature() || type.isPlaneswalker()) {
            return true;
        }
        return false;
    }

    public boolean canBeCreature() {
        CardType type = mainPart.getType();
        if (type.isCreature()) {
            return true;
        }
        for (String staticAbility : mainPart.getStaticAbilities()) { // Check for Grist
            if (staticAbility.contains("CharacteristicDefining$ True") && staticAbility.contains("AddType$ Creature")) {
                return true;
            }
        }
        return false;
    }

    public String getMeldWith() {
        return meldWith;
    }

    public String getPartnerWith() {
        return partnerWith;
    }

    public boolean getAddsWildCardColor() {
        return mainPart.getOracleText().contains(" is your commander, choose a color before the game begins.");
    }

    public int getSetColorID() {
        //Could someday generalize this to support other kinds of markings.
        return setColorID;
    }

    // vanguard card fields, they don't use sides.
    private int deltaHand;
    private int deltaLife;

    private List<String> tokens = Collections.emptyList();

    public List<String> getTokens() {
        return tokens;
    }

    public int getHand() { return deltaHand; }
    public int getLife() { return deltaLife; }
    public void setVanguardProperties(String pt) {
        final int slashPos = pt == null ? -1 : pt.indexOf('/');
        if (slashPos == -1) {
            throw new RuntimeException("Vanguard '" + this.getName() + "' has bad hand/life stats");
        }
        this.deltaHand = Integer.parseInt(TextUtil.fastReplace(pt.substring(0, slashPos), "+", ""));
        this.deltaLife = Integer.parseInt(TextUtil.fastReplace(pt.substring(slashPos+1), "+", ""));
    }

    private Set<String> supportedFunctionalVariants;
    public boolean hasFunctionalVariants() {
        return this.supportedFunctionalVariants != null;
    }
    public Set<String> getSupportedFunctionalVariants() {
        return this.supportedFunctionalVariants;
    }

    public String getDisplayNameForVariant(String variantName) {
        if(supportedFunctionalVariants == null || !supportedFunctionalVariants.contains(variantName))
            return getName();

        ICardFace mainFace = Objects.requireNonNullElse(mainPart.getFunctionalVariant(variantName), mainPart);
        String mainPartName = mainFace.getDisplayName();

        if(splitType.getAggregationMethod() == CardSplitType.FaceSelectionMethod.COMBINE) {
            ICardFace otherFace = Objects.requireNonNullElse(otherPart.getFunctionalVariant(variantName), otherPart);
            String otherPartName = otherFace.getDisplayName();
            return mainPartName + " // " + otherPartName;
        }
        else
            return mainPartName;
    }

    String findOrCreateVariantForFlavorName(String flavorName, String suggestedVariantName) {
        Objects.requireNonNull(flavorName);
        String[] nameParts = flavorName.trim().split("\\s*//\\s*");
        flavorName = String.join(" // ", nameParts); //Normalize this just in case.
        if(otherPart != null && nameParts.length < 2)
            throw new IllegalArgumentException("Tried to assign a single flavor name to a multi-faced card. Use ' // ' as a separator in the flavorName parameter.");
        if(supportedFunctionalVariants == null)
            supportedFunctionalVariants = new HashSet<>();
        for(String variantName : this.supportedFunctionalVariants) {
            if(getDisplayNameForVariant(variantName).equals(flavorName))
                return variantName;
        }
        String variantName = suggestedVariantName != null ? suggestedVariantName : "FlavorName" + flavorName.hashCode();
        if(supportedFunctionalVariants.contains(variantName))
            variantName = variantName + flavorName.hashCode();

        CardFace variantMain = ((CardFace) mainPart).getOrCreateFunctionalVariant(variantName);
        variantMain.setFlavorName(nameParts[0]);
        ((CardFace) mainPart).assignMissingFieldsToVariant(variantMain);

        if(otherPart != null) {
            CardFace variantOther = ((CardFace) otherPart).getOrCreateFunctionalVariant(variantName);
            variantOther.setFlavorName(nameParts[1]);
            ((CardFace) otherPart).assignMissingFieldsToVariant(variantOther);
        }

        supportedFunctionalVariants.add(variantName);

        return variantName;
    }

    /**
     * A card has placeholder faces if its script uses `CopyFaceFrom` to reference another card.
     * These will be filled in via `supplyPlaceholderFaces` after all scripts have been processed.
     */
    boolean hasPlaceholderFaces() {
        return this.placeholderFaces != null;
    }

    void supplyPlaceholderFaces(Map<String, ICardFace> facesByName) {
        if(this.placeholderFaces == null)
            return;
        List<ICardFace> newFaceList = new ArrayList<>(this.allFaces);
        for(Map.Entry<Integer, String> neededFace : this.placeholderFaces.entrySet()) {
            int index = neededFace.getKey();
            ICardFace face = facesByName.get(neededFace.getValue());
            if(face == null)
                throw new NoSuchElementException("Missing placeholder face for '" + this.normalizedName + "'; Cannot find '" + neededFace.getValue() + "'!");
            newFaceList.add(index, face);
            if(index == 0)
                this.mainPart = face;
            else if(index == 1)
                this.otherPart = face;
        }
        this.allFaces = Collections.unmodifiableList(newFaceList);

        //Recalculate color identity now that we have all the faces.
        this.colorIdentity = calculateColorIdentity(this);

        this.placeholderFaces = null;
    }

    public ColorSet getColorIdentity() {
        return colorIdentity;
    }

    /** Instantiates class, reads a card. For batch operations better create you own reader instance. */
    public static CardRules fromScript(Iterable<String> script) {
        Reader crr = new Reader();
        for (String line : script) {
            crr.parseLine(line);
        }
        return crr.getCard();
    }

    // Reads cardname.txt
    public static class Reader {
        // fields to build
        private CardFace[] faces = new CardFace[] { null, null, null, null, null, null, null };
        private int curFace = 0;
        private CardSplitType altMode = CardSplitType.None;
        private String meldWith = "";
        private String partnerWith = "";
        private String partnerType = "";
        private int setColorID = 0;
        private String handLife = null;
        private String normalizedName = "";
        private Set<String> supportedFunctionalVariants = null;
        private Map<Integer, String> placeholderFaces = null;

        private List<String> tokens = Lists.newArrayList();

        // fields to build CardAiHints
        private boolean removedFromAIDecks = false;
        private boolean removedFromRandomDecks = false;
        private boolean removedFromNonCommanderDecks = false;
        private DeckHints hints = null;
        private DeckHints needs = null;
        private DeckHints has = null;

        /**
         * Reset all fields to parse next card (to avoid allocating new CardRulesReader N times)
         */
        public final void reset() {
            this.setColorID = 0;
            this.curFace = 0;
            this.faces[0] = null;
            this.faces[1] = null;
            this.faces[2] = null;
            this.faces[3] = null;
            this.faces[4] = null;
            this.faces[5] = null;
            this.faces[6] = null;

            this.handLife = null;
            this.altMode = CardSplitType.None;

            this.removedFromAIDecks = false;
            this.removedFromRandomDecks = false;
            this.removedFromNonCommanderDecks = false;
            this.needs = null;
            this.hints = null;
            this.has = null;
            this.meldWith = "";
            this.partnerWith = "";
            this.partnerType = "";
            this.normalizedName = "";
            this.supportedFunctionalVariants = null;
            this.placeholderFaces = null;
            this.tokens = Lists.newArrayList();
        }

        /**
         * Gets the card.
         *
         * @return the card
         */
        public final CardRules getCard() {
            CardAiHints cah = new CardAiHints(removedFromAIDecks, removedFromRandomDecks, removedFromNonCommanderDecks, hints, needs, has);
            if (null != faces[0]) faces[0].assignMissingFields();
            else assert(placeholderFaces != null);
            if (null != faces[1]) faces[1].assignMissingFields();
            if (null != faces[2]) faces[2].assignMissingFields();
            if (null != faces[3]) faces[3].assignMissingFields();
            if (null != faces[4]) faces[4].assignMissingFields();
            if (null != faces[5]) faces[5].assignMissingFields();
            if (null != faces[6]) faces[6].assignMissingFields();
            final CardRules result = new CardRules(faces, altMode, cah);

            result.normalizedName = this.normalizedName;
            result.meldWith = this.meldWith;
            result.partnerWith = this.partnerWith;
            result.partnerType = this.partnerType;
            result.setColorID = this.setColorID;
            if (!tokens.isEmpty()) {
                result.tokens = tokens;
            }
            if (StringUtils.isNotBlank(handLife))
                result.setVanguardProperties(handLife);
            result.supportedFunctionalVariants = this.supportedFunctionalVariants;
            result.placeholderFaces = this.placeholderFaces;
            return result;
        }

        public final CardRules readCard(final Iterable<String> script, String filename) {
            this.reset();
            for (String line : script) {
                if (line.isEmpty() || line.charAt(0) == '#') {
                    continue;
                }
                this.parseLine(line, this.faces[curFace]);
            }
            this.normalizedName = filename;
            return this.getCard();
        }

        public final CardRules readCard(final Iterable<String> script) {
            return readCard(script, null);
        }

        /**
         * Parses a single line of a card script.
         *
         * @param line Line of text to parse.
         */
        public final void parseLine(final String line) {
            this.parseLine(line, this.faces[curFace]);
        }

        private void parseLine(final String line, CardFace face) {
            int colonPos = line.indexOf(':');
            String key = colonPos > 0 ? line.substring(0, colonPos) : line;
            String value = colonPos > 0 ? line.substring(1+colonPos).trim() : null;

            if (value != null) {
                int tokIdx = value.indexOf("TokenScript$");
                if (tokIdx > 0) {
                    String tokenParam = value.substring(tokIdx + 12).trim();
                    int endIdx = tokenParam.indexOf("|");
                    if (endIdx > 0) {
                        tokenParam = tokenParam.substring(0, endIdx).trim();
                    }
                    this.tokens.addAll(Arrays.asList(tokenParam.split(",")));
                }
            }

            switch (key.charAt(0)) {
                case 'A':
                    if ("A".equals(key)) {
                        face.addAbility(value);
                    } else if ("AI".equals(key)) {
                        colonPos = value.indexOf(':');
                        String variable = colonPos > 0 ? value.substring(0, colonPos) : value;
                        value = colonPos > 0 ? value.substring(1+colonPos) : null;

                        if ("RemoveDeck".equals(variable)) {
                            this.removedFromAIDecks |= "All".equalsIgnoreCase(value);
                            this.removedFromRandomDecks |= "Random".equalsIgnoreCase(value);
                            this.removedFromNonCommanderDecks |= "NonCommander".equalsIgnoreCase(value);
                        }
                    } else if ("AlternateMode".equals(key)) {
                        this.altMode = CardSplitType.smartValueOf(value);
                    } else if ("ALTERNATE".equals(key)) {
                        this.curFace = 1;
                    }
                    break;

                case 'C':
                    if ("Colors".equals(key)) {
                        ColorSet newCol = ColorSet.fromNames(value.split(","));
                        face.setColor(newCol);
                    } else if ("CopyFaceFrom".equals(key)) {
                        if (placeholderFaces == null)
                            placeholderFaces = new HashMap<>(2);
                        assert(this.faces[this.curFace] == null);
                        placeholderFaces.put(this.curFace, value);
                    }
                    break;

                case 'D':
                    if ("DeckHints".equals(key)) {
                        hints = new DeckHints(value);
                    } else if ("DeckNeeds".equals(key)) {
                        needs = new DeckHints(value);
                    } else if ("DeckHas".equals(key)) {
                        has = new DeckHints(value);
                    } else if ("Defense".equals(key)) {
                        face.setDefense(value);
                    } else if ("Draft".equals(key)) {
                        face.addDraftAction(value);
                    }
                    break;

                case 'F':
                    if("FlavorName".equals(key)) {
                        face.setFlavorName(value);
                    }

                case 'H':
                    if ("HandLifeModifier".equals(key)) {
                        handLife = value;
                    }
                    break;

                case 'K':
                    if ("K".equals(key)) {
                        face.addKeyword(value);
                        if (value.startsWith("Partner with:")) {
                            this.partnerWith = value.split(":")[1];
                        }
                        if (value.startsWith("Partner:")) {
                            this.partnerType = value.split(":")[1];
                        }
                    }
                    break;

                case 'L':
                    if ("Loyalty".equals(key)) {
                        face.setInitialLoyalty(value);
                    }
                    if ("Lights".equals(key)) {
                        face.setAttractionLights(value);
                    }
                    break;

                case 'M':
                    if ("ManaCost".equals(key)) {
                        face.setManaCost("no cost".equals(value) ? ManaCost.NO_COST : new ManaCost(value));
                    } else if ("MeldPair".equals(key)) {
                        this.meldWith = value;
                    }
                    break;

                case 'N':
                    if ("Name".equals(key)) {
                        assert(this.placeholderFaces == null || !this.placeholderFaces.containsKey(this.curFace));
                        this.faces[this.curFace] = new CardFace(value);
                    }
                    break;

                case 'O':
                    if ("Oracle".equals(key)) {
                        face.setOracleText(value);
                    }
                    break;

                case 'P':
                    if ("PT".equals(key)) {
                        face.setPtText(value);
                    }
                    break;

                case 'R':
                    if ("R".equals(key)) {
                        face.addReplacementEffect(value);
                    }
                    break;

                case 'S':
                    if ("S".equals(key)) {
                        face.addStaticAbility(value);
                    } else if (key.startsWith("SPECIALIZE")) {
                        if (value.equals("WHITE")) {
                            this.curFace = 2;
                        } else if (value.equals("BLUE")) {
                            this.curFace = 3;
                        } else if (value.equals("BLACK")) {
                            this.curFace = 4;
                        } else if (value.equals("RED")) {
                            this.curFace = 5;
                        } else if (value.equals("GREEN")) {
                            this.curFace = 6;
                        }
                    } else if ("SVar".equals(key)) {
                        if (null == value) throw new IllegalArgumentException("SVar has no variable name");

                        colonPos = value.indexOf(':');
                        String variable = colonPos > 0 ? value.substring(0, colonPos) : value;
                        value = colonPos > 0 ? value.substring(1+colonPos) : null;

                        face.addSVar(variable, value);
                    } else if (key.startsWith("SETCOLORID")) {
                        this.setColorID = Integer.parseInt(value);
                    }
                    break;

                case 'T':
                    if ("T".equals(key)) {
                        face.addTrigger(value);
                    } else if ("Types".equals(key)) {
                        face.setType(CardType.parse(value, false));
                    } else if ("Text".equals(key) && StringUtils.isNotBlank(value)) {
                        face.setNonAbilityText(value);
                    }
                    break;

                case 'V':
                    if("Variant".equals(key)) {
                        if (value == null) value = "";
                        colonPos = value.indexOf(':');
                        if(colonPos <= 0) throw new IllegalArgumentException("Missing variant name");
                        String variantName = value.substring(0, colonPos);
                        CardFace varFace = face.getOrCreateFunctionalVariant(variantName);
                        String variantLine = value.substring(1 + colonPos);
                        this.parseLine(variantLine, varFace);
                        if(this.supportedFunctionalVariants == null)
                            this.supportedFunctionalVariants = new HashSet<>();
                        this.supportedFunctionalVariants.add(variantName);
                    }
                    break;
            }
        }
    }

    public static CardRules getUnsupportedCardNamed(String name) {
        CardAiHints cah = new CardAiHints(true, true, true, null, null, null);
        CardFace[] faces = { new CardFace(name), null, null, null, null, null, null};
        faces[0].setColor(ColorSet.fromMask(0));
        faces[0].setType(CardType.parse("", false));
        faces[0].setOracleText("This card is not supported by Forge. Whenever you start a game with this card, it will be bugged.");
        faces[0].setNonAbilityText("This card is not supported by Forge.\nWhenever you start a game with this card, it will be bugged.");
        faces[0].assignMissingFields();
        final CardRules result = new CardRules(faces, CardSplitType.None, cah);

        result.unsupported = true;

        return result;
    }

    public boolean hasKeyword(final String k) {
        return Iterables.contains(mainPart.getKeywords(), k);
    }

    public boolean hasStartOfKeyword(final String k) {
        return hasStartOfKeyword(k, mainPart);
    }
    public boolean hasStartOfKeyword(final String k, ICardFace cf) {
        for (final String inst : cf.getKeywords()) {
            if (inst.startsWith(k)) {
                return true;
            }
        }
        return false;
    }

    public Integer getKeywordMagnitude(final String k) {
        for (final String inst : mainPart.getKeywords()) {
            final String[] parts = inst.split(":");
            if (parts[0].equals(k) && StringUtils.isNumeric(parts[1])) {
                return Integer.valueOf(parts[1]);
            }
        }
        return null;
    }

    public ColorSet getDeckbuildingColors() {
        if (deckbuildingColors == null) {
            byte colors = 0;
            if (mainPart.getType().isLand()) {
                colors = getColorIdentity().getColor();
                for (int i = 0; i < 5; i++) {
                    if (containsIgnoreCase(mainPart.getOracleText(), BASIC_LANDS.get(i))) {
                        colors |= 1 << i;
                    }
                }
            } else {
                colors = getColor().getColor();
                if (getOtherPart() != null) {
                    colors |= getOtherPart().getManaCost().getColorProfile();
                }
            }
            deckbuildingColors = ColorSet.fromMask(colors);
        }
        return deckbuildingColors;
    }
}
```

## Python
`forge/card/CardRules.py`

```python
from forge.card.ICardCharacteristics import ICardCharacteristics
from forge.card.CardAiHints import CardAiHints
from forge.card.CardFace import CardFace
from forge.card.CardSplitType import CardSplitType
from forge.card.CardStateName import CardStateName
from forge.card.CardType import CardType
from forge.card.ColorSet import ColorSet
from forge.card.DeckHints import DeckHints
from forge.card.ICardFace import ICardFace
from forge.card.MagicColor import MagicColor
from forge.card.mana.ManaCost import ManaCost
from forge.util.TextUtil import TextUtil

import re

# Sentinel used to distinguish "face argument not provided" from an explicit None.
_FACE_NOT_PROVIDED = object()


class CardRules(ICardCharacteristics):
    """
    A collection of methods containing full
    meta and gameplay properties of a card.
    """

    def __init__(self, faces, altMode, cah):
        self.normalizedName = None
        self.specializedParts = {}
        self.deckbuildingColors = None
        self.meldWith = ""
        self.partnerWith = ""
        self.partnerType = ""
        self.setColorID = 0
        self.custom = False
        self.unsupported = False
        self.placeholderFaces = None
        self.path = None
        # vanguard card fields, they don't use sides.
        self.deltaHand = 0
        self.deltaLife = 0
        self.tokens = []
        self.supportedFunctionalVariants = None

        self.splitType = altMode
        self.mainPart = faces[0]
        self.otherPart = faces[1]

        if CardSplitType.Specialize == self.splitType:
            self.specializedParts[CardStateName.SpecializeW] = faces[2]
            self.specializedParts[CardStateName.SpecializeU] = faces[3]
            self.specializedParts[CardStateName.SpecializeB] = faces[4]
            self.specializedParts[CardStateName.SpecializeR] = faces[5]
            self.specializedParts[CardStateName.SpecializeG] = faces[6]

        # Android doesn't support toUnmodifiableList
        self.allFaces = [f for f in faces if f is not None]

        self.aiHints = cah
        self.meldWith = ""
        self.partnerWith = ""
        self.partnerType = ""
        self.setColorID = 0

        self.colorIdentity = CardRules.calculateColorIdentity(self)

    def reinitializeFromRules(self, newRules):
        if newRules.getName() != self.getName():
            raise RuntimeError("You cannot rename the card using the same CardRules object")

        self.splitType = newRules.splitType
        self.mainPart = newRules.mainPart
        self.otherPart = newRules.otherPart
        self.specializedParts = dict(newRules.specializedParts)
        self.allFaces = newRules.allFaces
        self.aiHints = newRules.aiHints
        self.colorIdentity = newRules.colorIdentity
        self.meldWith = newRules.meldWith
        self.partnerWith = newRules.partnerWith
        self.setColorID = newRules.setColorID
        self.tokens = newRules.tokens

    @staticmethod
    def calculateColorIdentity(arg):
        if isinstance(arg, CardRules):
            rules = arg
            colMask = CardRules.calculateColorIdentity(rules.mainPart)
            if rules.otherPart is not None:
                colMask |= CardRules.calculateColorIdentity(rules.otherPart)
            return ColorSet.fromMask(colMask)

        face = arg
        if face is None:
            return 0  # Still initializing; filled in during supplyPlaceholderFaces
        res = face.getColor().getColor()
        isReminder = False
        isSymbol = False
        oracleText = face.getOracleText()
        # CR 903.4 colors defined by its characteristic-defining abilities
        for staticAbility in face.getStaticAbilities():
            if "CharacteristicDefining$ True" in staticAbility and "SetColor$ All" in staticAbility:
                return MagicColor.ALL_COLORS
        # no need to check oracle if it is already all colors
        if res == MagicColor.ALL_COLORS:
            return res
        length = len(oracleText)
        for i in range(length):
            c = oracleText[i]  # This is to avoid needless allocations performed by toCharArray()
            if c == '(':
                isReminder = i > 0  # if oracle has only reminder, consider it valid rules (basic and true lands need this)
            elif c == ')':
                isReminder = False
            elif c == '{':
                isSymbol = True
            elif c == '}':
                isSymbol = False
            else:
                if isSymbol and not isReminder:
                    if c == 'W':
                        res |= MagicColor.WHITE
                    elif c == 'U':
                        res |= MagicColor.BLUE
                    elif c == 'B':
                        res |= MagicColor.BLACK
                    elif c == 'R':
                        res |= MagicColor.RED
                    elif c == 'G':
                        res |= MagicColor.GREEN
        return res

    def isVariant(self):
        if self.placeholderFaces is not None and (self.mainPart is None or self.splitType.getAggregationMethod() == CardSplitType.FaceSelectionMethod.COMBINE):
            return False  # Type line isn't fully generated, and we need it to determine if this is a variant type
        t = self.getType()
        return (t.isVanguard() or t.isScheme() or t.isPlane() or t.isPhenomenon()
                or t.isConspiracy() or t.isDungeon() or t.isAttraction() or t.isContraption())

    def getSplitType(self):
        return self.splitType

    def getMainPart(self):
        return self.mainPart

    def getOtherPart(self):
        return self.otherPart

    def getSpecializeParts(self):
        return self.specializedParts

    def getAllFaces(self):
        return self.allFaces

    def isTransformable(self):
        return CardSplitType.Transform == self.getSplitType() or CardSplitType.Modal == self.getSplitType()

    def getWSpecialize(self):
        return self.specializedParts.get(CardStateName.SpecializeW)

    def getUSpecialize(self):
        return self.specializedParts.get(CardStateName.SpecializeU)

    def getBSpecialize(self):
        return self.specializedParts.get(CardStateName.SpecializeB)

    def getRSpecialize(self):
        return self.specializedParts.get(CardStateName.SpecializeR)

    def getGSpecialize(self):
        return self.specializedParts.get(CardStateName.SpecializeG)

    def getName(self):
        if self.splitType.getAggregationMethod() == CardSplitType.FaceSelectionMethod.COMBINE:
            return self.mainPart.getName() + " // " + self.otherPart.getName()
        return self.mainPart.getName()

    def getPreInitName(self):
        """
        Similar to `getName`, but goes through some extra steps to figure out the card's name in the event that
        one or more of the card faces isn't fully initialized yet. This should never be necessary outside of
        CardDB initialization.
        """
        if self.placeholderFaces is None:
            return self.getName()
        mainName = self.placeholderFaces.get(0) if self.mainPart is None else self.mainPart.getName()
        if self.splitType.getAggregationMethod() == CardSplitType.FaceSelectionMethod.COMBINE:
            otherName = self.placeholderFaces.get(1) if self.otherPart is None else self.otherPart.getName()
            return mainName + " // " + otherName
        return mainName

    def getNormalizedName(self):
        return self.normalizedName

    def getPath(self):
        return self.path

    def setPath(self, path):
        self.path = path

    def getAiHints(self):
        return self.aiHints

    def isCustom(self):
        return self.custom

    def setCustom(self):
        self.custom = True

    def isUnsupported(self):
        return self.unsupported

    def getType(self):
        if self.mainPart is None:
            return CardType(False)  # Still initializing; filled in during supplyPlaceholderFaces
        if self.splitType.getAggregationMethod() == CardSplitType.FaceSelectionMethod.COMBINE:
            # no cards currently have different types
            if self.otherPart is None:
                return self.mainPart.getType()
            return CardType.combine(self.mainPart.getType(), self.otherPart.getType())
        return self.mainPart.getType()

    def getManaCost(self):
        if self.splitType.getAggregationMethod() == CardSplitType.FaceSelectionMethod.COMBINE:
            return ManaCost.combine(self.mainPart.getManaCost(), self.otherPart.getManaCost())
        return self.mainPart.getManaCost()

    def getColor(self):
        if self.splitType.getAggregationMethod() == CardSplitType.FaceSelectionMethod.COMBINE:
            return ColorSet.combine(self.mainPart.getColor(), self.otherPart.getColor())
        return self.mainPart.getColor()

    @staticmethod
    def canCastFace(face, colorCode):
        if face.getManaCost().isNoCost():
            # if card face has no cost, assume castable only by mana of its defined color
            return face.getColor().hasNoColorsExcept(colorCode)
        return face.getManaCost().canBePaidWithAvailable(colorCode)

    def canCastWithAvailable(self, colorCode):
        if self.splitType.getAggregationMethod() == CardSplitType.FaceSelectionMethod.COMBINE:
            return CardRules.canCastFace(self.mainPart, colorCode) or CardRules.canCastFace(self.otherPart, colorCode)
        return CardRules.canCastFace(self.mainPart, colorCode)

    def getIntPower(self):
        return self.mainPart.getIntPower()

    def getIntToughness(self):
        return self.mainPart.getIntToughness()

    def getPower(self):
        return self.mainPart.getPower()

    def getToughness(self):
        return self.mainPart.getToughness()

    def getInitialLoyalty(self):
        return self.mainPart.getInitialLoyalty()

    def getDefense(self):
        return self.mainPart.getDefense()

    def getAttractionLights(self):
        return self.mainPart.getAttractionLights()

    def getOracleText(self):
        if self.splitType.getAggregationMethod() == CardSplitType.FaceSelectionMethod.COMBINE:
            return self.mainPart.getOracleText() + "\r\n\r\n" + self.otherPart.getOracleText()
        return self.mainPart.getOracleText()

    def isEnterableDungeon(self):
        if "You can't enter this dungeon unless" in self.mainPart.getOracleText():
            return False
        return self.getType().isDungeon()

    def canBeCommander(self):
        if "can be your commander" in self.mainPart.getOracleText() or self.canBeBackground():
            return True
        type = self.mainPart.getType()
        if not type.isLegendary():
            return False
        if self.canBeCreature() or type.isVehicle() or (type.isSpacecraft() and self.getPower() is not None):
            # Spacecraft need printed PT
            return True
        return False

    def canBePartnerCommanders(self, b):
        if not (self.canBePartnerCommander() and b.canBePartnerCommander()):
            return False
        if self.hasKeyword("Partner") and b.hasKeyword("Partner"):
            return True  # normal partner commander
        if self.getName() == b.getPartnerWith() and b.getName() == self.getPartnerWith():
            return True  # paired partner commander

        if self.partnerType != "" and self.partnerType == b.partnerType:
            return True

        if (self.hasKeyword("Choose a Background") and b.canBeBackground()
                or b.hasKeyword("Choose a Background") and self.canBeBackground()):
            return True  # commander with background
        if (self.isDoctor() and b.hasKeyword("Doctor's companion")
                or self.hasKeyword("Doctor's companion") and b.isDoctor()):
            return True  # Doctor Who partner commander
        return False

    def canBePartnerCommander(self):
        if self.canBeBackground():
            return True
        if not self.canBeCommander():
            return False
        return (self.hasKeyword("Partner") or self.partnerWith != "" or self.partnerType != ""
                or self.hasKeyword("Choose a Background") or self.hasKeyword("Doctor's companion") or self.isDoctor())

    def canBeBackground(self):
        return self.mainPart.getType().hasSubtype("Background")

    def isDoctor(self):
        subtypes = set()
        for type in self.mainPart.getType().getSubtypes():
            subtypes.add(type)

        return (len(subtypes) == 2
                and "Time Lord" in subtypes
                and "Doctor" in subtypes)

    def canBeOathbreaker(self):
        type = self.mainPart.getType()
        if "can be your commander" in self.mainPart.getOracleText():
            return True
        return type.isPlaneswalker()

    def canBeSignatureSpell(self):
        type = self.mainPart.getType()
        return type.isInstant() or type.isSorcery()

    def canBeBrawlCommander(self):
        type = self.mainPart.getType()
        if not type.isLegendary():
            return False
        if self.canBeCreature() or type.isPlaneswalker():
            return True
        return False

    def canBeTinyLeadersCommander(self):
        type = self.mainPart.getType()
        if not type.isLegendary():
            return False
        if self.canBeCreature() or type.isPlaneswalker():
            return True
        return False

    def canBeCreature(self):
        type = self.mainPart.getType()
        if type.isCreature():
            return True
        for staticAbility in self.mainPart.getStaticAbilities():  # Check for Grist
            if "CharacteristicDefining$ True" in staticAbility and "AddType$ Creature" in staticAbility:
                return True
        return False

    def getMeldWith(self):
        return self.meldWith

    def getPartnerWith(self):
        return self.partnerWith

    def getAddsWildCardColor(self):
        return " is your commander, choose a color before the game begins." in self.mainPart.getOracleText()

    def getSetColorID(self):
        # Could someday generalize this to support other kinds of markings.
        return self.setColorID

    def getTokens(self):
        return self.tokens

    def getHand(self):
        return self.deltaHand

    def getLife(self):
        return self.deltaLife

    def setVanguardProperties(self, pt):
        slashPos = -1 if pt is None else pt.find('/')
        if slashPos == -1:
            raise RuntimeError("Vanguard '" + self.getName() + "' has bad hand/life stats")
        self.deltaHand = int(TextUtil.fastReplace(pt[0:slashPos], "+", ""))
        self.deltaLife = int(TextUtil.fastReplace(pt[slashPos + 1:], "+", ""))

    def hasFunctionalVariants(self):
        return self.supportedFunctionalVariants is not None

    def getSupportedFunctionalVariants(self):
        return self.supportedFunctionalVariants

    def getDisplayNameForVariant(self, variantName):
        if self.supportedFunctionalVariants is None or variantName not in self.supportedFunctionalVariants:
            return self.getName()

        mainFace = self.mainPart.getFunctionalVariant(variantName)
        if mainFace is None:
            mainFace = self.mainPart
        mainPartName = mainFace.getDisplayName()

        if self.splitType.getAggregationMethod() == CardSplitType.FaceSelectionMethod.COMBINE:
            otherFace = self.otherPart.getFunctionalVariant(variantName)
            if otherFace is None:
                otherFace = self.otherPart
            otherPartName = otherFace.getDisplayName()
            return mainPartName + " // " + otherPartName
        else:
            return mainPartName

    def findOrCreateVariantForFlavorName(self, flavorName, suggestedVariantName):
        if flavorName is None:
            raise TypeError()
        nameParts = re.split(r'\s*//\s*', flavorName.strip())
        flavorName = " // ".join(nameParts)  # Normalize this just in case.
        if self.otherPart is not None and len(nameParts) < 2:
            raise ValueError("Tried to assign a single flavor name to a multi-faced card. Use ' // ' as a separator in the flavorName parameter.")
        if self.supportedFunctionalVariants is None:
            self.supportedFunctionalVariants = set()
        for variantName in self.supportedFunctionalVariants:
            if self.getDisplayNameForVariant(variantName) == flavorName:
                return variantName
        variantName = suggestedVariantName if suggestedVariantName is not None else "FlavorName" + str(hash(flavorName))
        if variantName in self.supportedFunctionalVariants:
            variantName = variantName + str(hash(flavorName))

        variantMain = self.mainPart.getOrCreateFunctionalVariant(variantName)
        variantMain.setFlavorName(nameParts[0])
        self.mainPart.assignMissingFieldsToVariant(variantMain)

        if self.otherPart is not None:
            variantOther = self.otherPart.getOrCreateFunctionalVariant(variantName)
            variantOther.setFlavorName(nameParts[1])
            self.otherPart.assignMissingFieldsToVariant(variantOther)

        self.supportedFunctionalVariants.add(variantName)

        return variantName

    def hasPlaceholderFaces(self):
        """
        A card has placeholder faces if its script uses `CopyFaceFrom` to reference another card.
        These will be filled in via `supplyPlaceholderFaces` after all scripts have been processed.
        """
        return self.placeholderFaces is not None

    def supplyPlaceholderFaces(self, facesByName):
        if self.placeholderFaces is None:
            return
        newFaceList = list(self.allFaces)
        for index, neededName in self.placeholderFaces.items():
            face = facesByName.get(neededName)
            if face is None:
                raise LookupError("Missing placeholder face for '" + self.normalizedName + "'; Cannot find '" + neededName + "'!")
            newFaceList.insert(index, face)
            if index == 0:
                self.mainPart = face
            elif index == 1:
                self.otherPart = face
        self.allFaces = newFaceList

        # Recalculate color identity now that we have all the faces.
        self.colorIdentity = CardRules.calculateColorIdentity(self)

        self.placeholderFaces = None

    def getColorIdentity(self):
        return self.colorIdentity

    @staticmethod
    def fromScript(script):
        """Instantiates class, reads a card. For batch operations better create you own reader instance."""
        crr = CardRules.Reader()
        for line in script:
            crr.parseLine(line)
        return crr.getCard()

    # Reads cardname.txt
    class Reader:
        def __init__(self):
            self.faces = [None, None, None, None, None, None, None]
            self.reset()

        def reset(self):
            """Reset all fields to parse next card (to avoid allocating new CardRulesReader N times)"""
            self.setColorID = 0
            self.curFace = 0
            self.faces[0] = None
            self.faces[1] = None
            self.faces[2] = None
            self.faces[3] = None
            self.faces[4] = None
            self.faces[5] = None
            self.faces[6] = None

            self.handLife = None
            self.altMode = getattr(CardSplitType, "None")

            self.removedFromAIDecks = False
            self.removedFromRandomDecks = False
            self.removedFromNonCommanderDecks = False
            self.needs = None
            self.hints = None
            self.has = None
            self.meldWith = ""
            self.partnerWith = ""
            self.partnerType = ""
            self.normalizedName = ""
            self.supportedFunctionalVariants = None
            self.placeholderFaces = None
            self.tokens = []

        def getCard(self):
            """Gets the card."""
            cah = CardAiHints(self.removedFromAIDecks, self.removedFromRandomDecks, self.removedFromNonCommanderDecks, self.hints, self.needs, self.has)
            if self.faces[0] is not None:
                self.faces[0].assignMissingFields()
            else:
                assert self.placeholderFaces is not None
            if self.faces[1] is not None:
                self.faces[1].assignMissingFields()
            if self.faces[2] is not None:
                self.faces[2].assignMissingFields()
            if self.faces[3] is not None:
                self.faces[3].assignMissingFields()
            if self.faces[4] is not None:
                self.faces[4].assignMissingFields()
            if self.faces[5] is not None:
                self.faces[5].assignMissingFields()
            if self.faces[6] is not None:
                self.faces[6].assignMissingFields()
            result = CardRules(self.faces, self.altMode, cah)

            result.normalizedName = self.normalizedName
            result.meldWith = self.meldWith
            result.partnerWith = self.partnerWith
            result.partnerType = self.partnerType
            result.setColorID = self.setColorID
            if len(self.tokens) != 0:
                result.tokens = self.tokens
            if self.handLife is not None and self.handLife.strip() != "":
                result.setVanguardProperties(self.handLife)
            result.supportedFunctionalVariants = self.supportedFunctionalVariants
            result.placeholderFaces = self.placeholderFaces
            return result

        def readCard(self, script, filename=None):
            self.reset()
            for line in script:
                if len(line) == 0 or line[0] == '#':
                    continue
                self.parseLine(line, self.faces[self.curFace])
            self.normalizedName = filename
            return self.getCard()

        def parseLine(self, line, face=_FACE_NOT_PROVIDED):
            """Parses a single line of a card script."""
            if face is _FACE_NOT_PROVIDED:
                face = self.faces[self.curFace]

            colonPos = line.find(':')
            key = line[0:colonPos] if colonPos > 0 else line
            value = line[1 + colonPos:].strip() if colonPos > 0 else None

            if value is not None:
                tokIdx = value.find("TokenScript$")
                if tokIdx > 0:
                    tokenParam = value[tokIdx + 12:].strip()
                    endIdx = tokenParam.find("|")
                    if endIdx > 0:
                        tokenParam = tokenParam[0:endIdx].strip()
                    self.tokens.extend(tokenParam.split(","))

            c0 = key[0]
            if c0 == 'A':
                if key == "A":
                    face.addAbility(value)
                elif key == "AI":
                    colonPos = value.find(':')
                    variable = value[0:colonPos] if colonPos > 0 else value
                    value = value[1 + colonPos:] if colonPos > 0 else None

                    if variable == "RemoveDeck":
                        self.removedFromAIDecks = self.removedFromAIDecks or (value is not None and value.lower() == "all".lower())
                        self.removedFromRandomDecks = self.removedFromRandomDecks or (value is not None and value.lower() == "random".lower())
                        self.removedFromNonCommanderDecks = self.removedFromNonCommanderDecks or (value is not None and value.lower() == "noncommander".lower())
                elif key == "AlternateMode":
                    self.altMode = CardSplitType.smartValueOf(value)
                elif key == "ALTERNATE":
                    self.curFace = 1

            elif c0 == 'C':
                if key == "Colors":
                    newCol = ColorSet.fromNames(value.split(","))
                    face.setColor(newCol)
                elif key == "CopyFaceFrom":
                    if self.placeholderFaces is None:
                        self.placeholderFaces = {}
                    assert self.faces[self.curFace] is None
                    self.placeholderFaces[self.curFace] = value

            elif c0 == 'D':
                if key == "DeckHints":
                    self.hints = DeckHints(value)
                elif key == "DeckNeeds":
                    self.needs = DeckHints(value)
                elif key == "DeckHas":
                    self.has = DeckHints(value)
                elif key == "Defense":
                    face.setDefense(value)
                elif key == "Draft":
                    face.addDraftAction(value)

            elif c0 == 'F' or c0 == 'H':
                # case 'F' falls through to case 'H' in the original Java
                if c0 == 'F':
                    if key == "FlavorName":
                        face.setFlavorName(value)
                if key == "HandLifeModifier":
                    self.handLife = value

            elif c0 == 'K':
                if key == "K":
                    face.addKeyword(value)
                    if value.startswith("Partner with:"):
                        self.partnerWith = value.split(":")[1]
                    if value.startswith("Partner:"):
                        self.partnerType = value.split(":")[1]

            elif c0 == 'L':
                if key == "Loyalty":
                    face.setInitialLoyalty(value)
                if key == "Lights":
                    face.setAttractionLights(value)

            elif c0 == 'M':
                if key == "ManaCost":
                    face.setManaCost(ManaCost.NO_COST if value == "no cost" else ManaCost(value))
                elif key == "MeldPair":
                    self.meldWith = value

            elif c0 == 'N':
                if key == "Name":
                    assert self.placeholderFaces is None or self.curFace not in self.placeholderFaces
                    self.faces[self.curFace] = CardFace(value)

            elif c0 == 'O':
                if key == "Oracle":
                    face.setOracleText(value)

            elif c0 == 'P':
                if key == "PT":
                    face.setPtText(value)

            elif c0 == 'R':
                if key == "R":
                    face.addReplacementEffect(value)

            elif c0 == 'S':
                if key == "S":
                    face.addStaticAbility(value)
                elif key.startswith("SPECIALIZE"):
                    if value == "WHITE":
                        self.curFace = 2
                    elif value == "BLUE":
                        self.curFace = 3
                    elif value == "BLACK":
                        self.curFace = 4
                    elif value == "RED":
                        self.curFace = 5
                    elif value == "GREEN":
                        self.curFace = 6
                elif key == "SVar":
                    if value is None:
                        raise ValueError("SVar has no variable name")

                    colonPos = value.find(':')
                    variable = value[0:colonPos] if colonPos > 0 else value
                    value = value[1 + colonPos:] if colonPos > 0 else None

                    face.addSVar(variable, value)
                elif key.startswith("SETCOLORID"):
                    self.setColorID = int(value)

            elif c0 == 'T':
                if key == "T":
                    face.addTrigger(value)
                elif key == "Types":
                    face.setType(CardType.parse(value, False))
                elif key == "Text" and value is not None and value.strip() != "":
                    face.setNonAbilityText(value)

            elif c0 == 'V':
                if key == "Variant":
                    if value is None:
                        value = ""
                    colonPos = value.find(':')
                    if colonPos <= 0:
                        raise ValueError("Missing variant name")
                    variantName = value[0:colonPos]
                    varFace = face.getOrCreateFunctionalVariant(variantName)
                    variantLine = value[1 + colonPos:]
                    self.parseLine(variantLine, varFace)
                    if self.supportedFunctionalVariants is None:
                        self.supportedFunctionalVariants = set()
                    self.supportedFunctionalVariants.add(variantName)

    @staticmethod
    def getUnsupportedCardNamed(name):
        cah = CardAiHints(True, True, True, None, None, None)
        faces = [CardFace(name), None, None, None, None, None, None]
        faces[0].setColor(ColorSet.fromMask(0))
        faces[0].setType(CardType.parse("", False))
        faces[0].setOracleText("This card is not supported by Forge. Whenever you start a game with this card, it will be bugged.")
        faces[0].setNonAbilityText("This card is not supported by Forge.\nWhenever you start a game with this card, it will be bugged.")
        faces[0].assignMissingFields()
        result = CardRules(faces, getattr(CardSplitType, "None"), cah)

        result.unsupported = True

        return result

    def hasKeyword(self, k):
        return k in self.mainPart.getKeywords()

    def hasStartOfKeyword(self, k, cf=_FACE_NOT_PROVIDED):
        if cf is _FACE_NOT_PROVIDED:
            cf = self.mainPart
        for inst in cf.getKeywords():
            if inst.startswith(k):
                return True
        return False

    def getKeywordMagnitude(self, k):
        for inst in self.mainPart.getKeywords():
            parts = inst.split(":")
            if parts[0] == k and parts[1].isdigit():
                return int(parts[1])
        return None

    def getDeckbuildingColors(self):
        if self.deckbuildingColors is None:
            colors = 0
            if self.mainPart.getType().isLand():
                colors = self.getColorIdentity().getColor()
                for i in range(5):
                    if MagicColor.Constant.BASIC_LANDS[i].lower() in self.mainPart.getOracleText().lower():
                        colors |= 1 << i
            else:
                colors = self.getColor().getColor()
                if self.getOtherPart() is not None:
                    colors |= self.getOtherPart().getManaCost().getColorProfile()
            self.deckbuildingColors = ColorSet.fromMask(colors)
        return self.deckbuildingColors
```
