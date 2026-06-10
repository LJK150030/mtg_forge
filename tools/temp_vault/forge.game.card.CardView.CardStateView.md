---
aliases:
  - CardStateView
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/card
fqn: forge.game.card.CardView.CardStateView
package: forge.game.card
module: forge-game
kind: Class
---

# CardStateView

**Package:** `forge.game.card` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class CardStateView {
        -long serialVersionUID
        -CardStateName state
        -int foilIndexOverride
        +getDisplayId() String
        +hashCode() int
        +toString() String
        +getCard() CardView
        +getState() CardStateName
        +getName() String
        ~updateName(CardState c) void
        -setName(String name) void
        +getOracleName() String
        -setOracleName(String name) void
        +getColors() ColorSet
        +getOriginalColors() ColorSet
        ~updateColors(Card c) void
        ~updateColors(CardState c) void
        ~setOriginalColors(Card c) void
        ~updateHasChangeColors(boolean hasChangeColor) void
        +hasChangeColors() boolean
        +getImageKey() String
        +getImageKey(Iterable~PlayerView~ viewers) String
        +getTrackableImageKey() String
        ~updateImageKey(Card c) void
        ~updateImageKey(CardState c) void
        +getType() CardTypeView
        ~updateType(CardState c) void
        +getManaCost() ManaCost
        +getOriginalManaCost() ManaCost
        ~updateManaCost(CardState c) void
        ~updateManaCost(Card c) void
        +getOracleText() String
        ~setOracleText(String oracleText) void
        +getFunctionalVariantName() String
        ~setFunctionalVariantName(String functionalVariant) void
        +getRulesText() String
        ~updateRulesText(CardRules rules) void
        +getPower() int
        ~updatePower(Card c) void
        ~updatePower(CardState c) void
        +getToughness() int
        ~updateToughness(Card c) void
        ~updateToughness(CardState c) void
        +getLoyalty() String
        ~updateLoyalty(Card c) void
        ~updateLoyalty(String loyalty) void
        ~updateLoyalty(CardState c) void
        +getDefense() String
        ~updateDefense(Card c) void
        ~updateDefense(String defense) void
        ~updateDefense(CardState c) void
        +getAttractionLights() Set~Integer~
        ~updateAttractionLights(CardState c) void
        +hasPrintedPT() boolean
        ~updateHasPrintedPT(boolean v) void
        +getSetCode() String
        ~updateSetCode(CardState c) void
        +getRarity() CardRarity
        ~updateRarity(CardState c) void
        +getFoilIndex() int
        ~updateFoilIndex(Card c) void
        ~updateFoilIndex(CardState c) void
        +setFoilIndexOverride(int index0) void
        +getKeywords() KeywordCollectionView
        +hasKeyword(Keyword keyword) boolean
        +hasAnnihilator() boolean
        +hasWard() boolean
        +hasDeathtouch() boolean
        +hasDevoid() boolean
        +hasTrample() boolean
        +hasHaste() boolean
        +hasInfect() boolean
        +hasStorm() boolean
        +hasAftermath() boolean
        +hasDivideDamage() boolean
        +origProduceAnyMana() boolean
        +origProduceMana() ColorSet
        +getAbilityText() String
        ~updateAbilityText(Card c, CardState state) void
        ~updateKeywords(Card c, CardState state) void
        ~updateManaColorBG(CardState state) void
        +isBasicLand() boolean
        +isCreature() boolean
        +isLand() boolean
        +isPlane() boolean
        +isPhenomenon() boolean
        +isPlaneswalker() boolean
        +isBattle() boolean
        +isVehicle() boolean
        +isArtifact() boolean
        +isEnchantment() boolean
        +isSpaceCraft() boolean
        +isAttraction() boolean
        +isContraption() boolean
        +isInstant() boolean
        +isSorcery() boolean
        +getTranslationKey() String
        +getUntranslatedType() String
        +getTranslatedName() String
        +CardStateView(int id0, CardStateName state0, Tracker tracker)
    }
    CardStateView --|> TrackableObject : extends
    CardStateView ..|> ITranslatable : implements
    CardStateView ..> AbilityManaPart : uses
    CardStateView ..> Card : uses
    CardStateView ..> CardRarity : uses
    CardStateView ..> CardRules : uses
    CardStateView ..> CardState : uses
    CardStateView ..> CardStateName : uses
    CardStateView ..> CardTypeView : uses
    CardStateView ..> CardView : uses
    CardStateView ..> ColorSet : uses
    CardStateView ..> Keyword : uses
    CardStateView ..> KeywordCollectionView : uses
    CardStateView ..> ManaCost : uses
    CardStateView ..> PlayerView : uses
    CardStateView ..> SpellAbility : uses
    CardStateView ..> Tracker : uses
```

## Relationships
**Extends:**
- [[forge.trackable.TrackableObject|TrackableObject]]
**Implements:**
- [[forge.util.ITranslatable|ITranslatable]]
**Uses:**
- [[forge.card.CardRarity|CardRarity]]
- [[forge.card.CardRules|CardRules]]
- [[forge.card.CardStateName|CardStateName]]
- [[forge.card.CardTypeView|CardTypeView]]
- [[forge.card.ColorSet|ColorSet]]
- [[forge.card.mana.ManaCost|ManaCost]]
- [[forge.game.card.Card|Card]]
- [[forge.game.card.CardState|CardState]]
- [[forge.game.card.CardView|CardView]]
- [[forge.game.keyword.Keyword|Keyword]]
- [[forge.game.keyword.KeywordCollectionView|KeywordCollectionView]]
- [[forge.game.player.PlayerView|PlayerView]]
- [[forge.game.spellability.AbilityManaPart|AbilityManaPart]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]
- [[forge.trackable.Tracker|Tracker]]

## Design Description

CardStateView is a lightweight, serializable view object representing a single named state (e.g., front, back, or face-down) of a card for presentation to the UI and remote clients. As a nested non-static class of CardView, it accesses its enclosing card instance directly while extending TrackableObject to store all displayable attributesâ€”name, colors, mana cost, type, power/toughness, loyalty, keywords, rarity, image key, and rules textâ€”as tracked properties whose changes propagate automatically to observers. It implements ITranslatable to supply localization keys for the card's name and type.

The design cleanly separates the mutable game model from its observable projection: package-private `update*` methods pull values from the live `Card` or `CardState` and write them via `set(TrackableProperty.*)`, while public getters expose them. Visibility logic (face-down handling, viewer-based image masking, clone source substitution) and convenience type-predicate methods keep display concerns encapsulated within the view rather than the engine.

## Source
`forge-game/src/main/java/forge/game/card/CardView.java` Ã¢â‚¬â€ declaration excerpt

```java
    public class CardStateView extends TrackableObject implements ITranslatable {
        private static final long serialVersionUID = 6673944200513430607L;

        private final CardStateName state;

        public CardStateView(final int id0, final CardStateName state0, final Tracker tracker) {
            super(id0, tracker);
            state = state0;
        }

        public String getDisplayId() {
            if (getState().equals(CardStateName.FaceDown)) {
                return "H" + getHiddenId();
            }
            final int id = getId();
            if (id > 0) {
                return String.valueOf(getId());
            }
            return StringUtils.EMPTY;
        }

        @Override
        public int hashCode() {
            return Objects.hash(getId(), state);
        }

        @Override
        public String toString() {
            return (getName() + " (" + getDisplayId() + ")").trim();
        }

        public CardView getCard() {
            return CardView.this;
        }

        public CardStateName getState() {
            return state;
        }

        public String getName() {
            return get(TrackableProperty.Name);
        }
        void updateName(CardState c) {
            Card card = c.getCard();
            setName(card.getDisplayName(c));
            setOracleName(card.getName(c));

            if (CardView.this.getCurrentState() == this) {
                CardView.this.updateName(card);
            }
        }
        private void setName(String name) {
            set(TrackableProperty.Name, name);
        }

        /**
         * @return The name of the card, unaltered by flavor names.
         */
        public String getOracleName() {
            return get(TrackableProperty.OracleName);
        }
        private void setOracleName(String name) {
            set(TrackableProperty.OracleName, name);
        }

        public ColorSet getColors() {
            return get(TrackableProperty.Colors);
        }
        public ColorSet getOriginalColors() {
            return get(TrackableProperty.OriginalColors);
        }
        void updateColors(Card c) {
            set(TrackableProperty.Colors, c.getColor());
        }
        void updateColors(CardState c) {
            set(TrackableProperty.Colors, c.getColor());
        }
        void setOriginalColors(Card c) {
            set(TrackableProperty.OriginalColors, c.getColor());
        }
        void updateHasChangeColors(boolean hasChangeColor) {
            set(TrackableProperty.HasChangedColors, hasChangeColor);
        }
        public boolean hasChangeColors() { return get(TrackableProperty.HasChangedColors); }

        public String getImageKey() {
            return getImageKey(null);
        }
        public String getImageKey(Iterable<PlayerView> viewers) {
            if (getState() == CardStateName.FaceDown) {
                return getCard().getFacedownImageKey();
            }
            if (canBeShownToAny(viewers)) {
                if (isCloned() && StaticData.instance().useSourceImageForClone()) {
                    return getBackup().getCurrentState().getImageKey(viewers);
                }
                return get(TrackableProperty.ImageKey);
            }
            return ImageKeys.getTokenKey(ImageKeys.HIDDEN_CARD);
        }
        /*
        * Use this for revealing purposes only
        * */
        public String getTrackableImageKey() {
            return get(TrackableProperty.ImageKey);
        }
        void updateImageKey(Card c) {
            set(TrackableProperty.ImageKey, c.getImageKey());
        }
        void updateImageKey(CardState c) {
            set(TrackableProperty.ImageKey, c.getImageKey());
        }

        public CardTypeView getType() {
            if (getState() != CardStateName.Original && isFaceDown() && !isInZone(EnumSet.of(ZoneType.Battlefield, ZoneType.Stack))) {
                return CardType.EMPTY;
            }
            return get(TrackableProperty.Type);
        }
        void updateType(CardState c) {
            set(TrackableProperty.Type, c.getTypeWithChanges());
        }

        public ManaCost getManaCost() {
            return get(TrackableProperty.ManaCost);
        }
        public ManaCost getOriginalManaCost() {
            return get(TrackableProperty.OriginalManaCost);
        }
        void updateManaCost(CardState c) {
            set(TrackableProperty.ManaCost, c.getPerpetualAdjustedManaCost());
            set(TrackableProperty.OriginalManaCost, c.getManaCost());
        }
        void updateManaCost(Card c) {
            set(TrackableProperty.ManaCost, c.getCurrentState().getPerpetualAdjustedManaCost());
            set(TrackableProperty.OriginalManaCost, c.getManaCost());
        }

        public String getOracleText() {
            return get(TrackableProperty.OracleText);
        }
        void setOracleText(String oracleText) {
            set(TrackableProperty.OracleText, oracleText.replace("\\n", "\r\n\r\n").trim());
        }

        public String getFunctionalVariantName() {
            return get(TrackableProperty.FunctionalVariant);
        }
        void setFunctionalVariantName(String functionalVariant) {
            set(TrackableProperty.FunctionalVariant, functionalVariant);
        }

        public String getRulesText() {
            return get(TrackableProperty.RulesText);
        }
        void updateRulesText(CardRules rules) {
            String rulesText = null;

            if (rules != null && rules.getType().isVanguard()) {
                boolean decHand = rules.getHand() < 0;
                boolean decLife = rules.getLife() < 0;
                String handSize = Localizer.getInstance().getMessageorUseDefault("lblHandSize", "Hand Size")
                        + (!decHand ? ": +" : ": ") + rules.getHand();
                String startingLife = Localizer.getInstance().getMessageorUseDefault("lblStartingLife", "Starting Life")
                        + (!decLife ? ": +" : ": ") + rules.getLife();
                rulesText = handSize + "\r\n" + startingLife;
            }
            set(TrackableProperty.RulesText, rulesText);
        }

        public int getPower() {
            return get(TrackableProperty.Power);
        }
        void updatePower(Card c) {
            int num;
            if (hasPrintedPT() && !isCreature()) {
                // use printed value so user can still see it
                num = c.getCurrentPower();
            } else {
                num = c.getNetPower();
            }
            if (c.getCurrentState().getView() != this && c.getAlternateState() != null) {
                num = num - c.getBasePower() + c.getAlternateState().getBasePower();
            }
            set(TrackableProperty.Power, num);
        }
        void updatePower(CardState c) {
            Card card = c.getCard();
            if (card != null) {
                updatePower(card); //TODO: find a better way to do this
                return;
            }
            set(TrackableProperty.Power, c.getBasePower());
        }

        public int getToughness() {
            return get(TrackableProperty.Toughness);
        }
        void updateToughness(Card c) {
            int num;
            if (hasPrintedPT() && !isCreature()) {
                // use printed value so user can still see it
                num = c.getCurrentToughness();
            } else {
                num = c.getNetToughness();
            }
            if (c.getCurrentState().getView() != this && c.getAlternateState() != null) {
                num = num - c.getBaseToughness() + c.getAlternateState().getBaseToughness();
            }
            set(TrackableProperty.Toughness, num);
        }
        void updateToughness(CardState c) {
            Card card = c.getCard();
            if (card != null) {
                updateToughness(card); //TODO: find a better way to do this
                return;
            }
            set(TrackableProperty.Toughness, c.getBaseToughness());
        }

        public String getLoyalty() {
            return get(TrackableProperty.Loyalty);
        }
        void updateLoyalty(Card c) {
            if (c.isInZone(ZoneType.Battlefield)) {
                updateLoyalty(String.valueOf(c.getCurrentLoyalty()));
            } else {
                updateLoyalty(c.getCurrentState().getBaseLoyalty());
            }
        }
        void updateLoyalty(String loyalty) {
            set(TrackableProperty.Loyalty, loyalty);
        }
        void updateLoyalty(CardState c) {
            if (CardView.this.getCurrentState() == this) {
                Card card = c.getCard();
                if (card != null) {
                    if (card.isInZone(ZoneType.Battlefield)) {
                        updateLoyalty(card);
                    } else {
                        updateLoyalty(c.getBaseLoyalty());
                    }

                    return;
                }
            }
            set(TrackableProperty.Loyalty, "0"); //alternates don't need loyalty
        }

        public String getDefense() {
            return get(TrackableProperty.Defense);
        }
        void updateDefense(Card c) {
            if (c.isInZone(ZoneType.Battlefield)) {
                updateDefense(String.valueOf(c.getCurrentDefense()));
            } else {
                updateDefense(c.getCurrentState().getBaseDefense());
            }
        }
        void updateDefense(String defense) {
            set(TrackableProperty.Defense, defense);
        }
        void updateDefense(CardState c) {
            if (CardView.this.getCurrentState() == this) {
                Card card = c.getCard();
                if (card != null) {
                    if (card.isInZone(ZoneType.Battlefield)) {
                        updateDefense(card);
                    } else {
                        updateDefense(c.getBaseDefense());
                    }

                    return;
                }
            }
            updateDefense("0");
        }

        public Set<Integer> getAttractionLights() {
            return get(TrackableProperty.AttractionLights);
        }
        void updateAttractionLights(CardState c) {
            set(TrackableProperty.AttractionLights, c.getAttractionLights());
        }

        public boolean hasPrintedPT() {
            return get(TrackableProperty.HasPrintedPT);
        }
        void updateHasPrintedPT(boolean v) {
            set(TrackableProperty.HasPrintedPT, v);
        }

        public String getSetCode() {
            return get(TrackableProperty.SetCode);
        }
        void updateSetCode(CardState c) {
            set(TrackableProperty.SetCode, c.getSetCode());
        }

        public CardRarity getRarity() {
            return get(TrackableProperty.Rarity);
        }
        void updateRarity(CardState c) {
            set(TrackableProperty.Rarity, c.getRarity());
        }

        private int foilIndexOverride = -1;
        public int getFoilIndex() {
            if (foilIndexOverride >= 0) {
                return foilIndexOverride;
            }
            return get(TrackableProperty.FoilIndex);
        }
        void updateFoilIndex(Card c) {
            updateFoilIndex(c.getCurrentState());
        }
        void updateFoilIndex(CardState c) {
            set(TrackableProperty.FoilIndex, c.getFoil());
        }
        public void setFoilIndexOverride(int index0) {
            if (index0 < 0) {
                index0 = CardEdition.getRandomFoil(getSetCode());
            }
            foilIndexOverride = index0;
        }

        public KeywordCollectionView getKeywords()  { return get(TrackableProperty.Keywords); }
        public boolean hasKeyword(Keyword keyword) { return getKeywords().contains(keyword); }

        public boolean hasAnnihilator() { return get(TrackableProperty.HasAnnihilator); }
        public boolean hasWard() { return get(TrackableProperty.HasWard); }

        public boolean hasDeathtouch() { return hasKeyword(Keyword.DEATHTOUCH); }
        public boolean hasDevoid() { return hasKeyword(Keyword.DEVOID); }
        public boolean hasTrample() { return hasKeyword(Keyword.TRAMPLE); }
        public boolean hasHaste() { return hasKeyword(Keyword.HASTE); }
        public boolean hasInfect() { return hasKeyword(Keyword.INFECT); }
        public boolean hasStorm() { return hasKeyword(Keyword.STORM); }
        public boolean hasAftermath() { return hasKeyword(Keyword.AFTERMATH); }

        public boolean hasDivideDamage() { return get(TrackableProperty.HasDivideDamage); }

        public boolean origProduceAnyMana() {
            return get(TrackableProperty.OrigProduceAnyMana);
        }
        public ColorSet origProduceMana() {
            return get(TrackableProperty.OrigProduceMana);
        }

        public String getAbilityText() {
            return get(TrackableProperty.AbilityText);
        }
        void updateAbilityText(Card c, CardState state) {
            set(TrackableProperty.AbilityText, c.getAbilityText(state));
        }
        void updateKeywords(Card c, CardState state) {
            c.updateKeywordsCache(state);
            set(TrackableProperty.Keywords, state.getCachedKeywords().getView());
            // deeper check for Idris
            set(TrackableProperty.HasAnnihilator, c.hasKeyword(Keyword.ANNIHILATOR, state) || state.getTriggers().anyMatch(t -> t.isKeyword(Keyword.ANNIHILATOR)));
            set(TrackableProperty.HasWard, c.hasKeyword(Keyword.WARD, state) || state.getTriggers().anyMatch(t -> t.isKeyword(Keyword.WARD)));
            updateAbilityText(c, state);
            //update Trackable Mana Color for BG Colors
            updateManaColorBG(state);

            set(TrackableProperty.HasDivideDamage, c.hasKeyword("You may assign CARDNAME's combat damage divided as " +
                    "you choose among defending player and/or any number of creatures they control."));
        }
        void updateManaColorBG(CardState state) {
            boolean anyMana = false;
            boolean cMana = false;
            byte colors = 0;
            for (SpellAbility sa : state.getManaAbilities()) {
                if (sa == null)
                    continue;
                for (AbilityManaPart mp : sa.getAllManaParts()) {
                    if (mp.isAnyMana()) {
                        anyMana = true;
                        continue;
                    }

                    String[] colorsProduced = mp.mana(sa).split(" ");

                    //todo improve this
                    for (final String s : colorsProduced) {
                        switch (s.toUpperCase()) {
                            case "R":
                                colors |= MagicColor.RED;
                                break;
                            case "G":
                                colors |= MagicColor.GREEN;
                                break;
                            case "B":
                                colors |= MagicColor.BLACK;
                                break;
                            case "U":
                                colors |= MagicColor.BLUE;
                                break;
                            case "W":
                                colors |= MagicColor.WHITE;
                                break;
                            case "C":
                                cMana = true;
                                break;
                        }
                    }
                }
            }
            set(TrackableProperty.OrigProduceMana, colors > 0 ? ColorSet.fromMask(colors) : cMana ? ColorSet.C : null);
            set(TrackableProperty.OrigProduceAnyMana, anyMana);
        }

        public boolean isBasicLand() {
            return getType().isBasicLand();
        }
        public boolean isCreature() {
            return getType().isCreature();
        }
        public boolean isLand() {
            return getType().isLand();
        }
        public boolean isPlane() {
            return getType().isPlane();
        }
        public boolean isPhenomenon() {
            return getType().isPhenomenon();
        }
        public boolean isPlaneswalker() {
            return getType().isPlaneswalker();
        }

        public boolean isBattle() {
            return getType().isBattle();
        }
        public boolean isVehicle() {
            return getType().hasSubtype("Vehicle");
        }
        public boolean isArtifact() {
            return getType().isArtifact();
        }
        public boolean isEnchantment() {
            return getType().isEnchantment();
        }
        public boolean isSpaceCraft() {
            return getType().hasSubtype("Spacecraft");
        }
        public boolean isAttraction() {
            return getType().isAttraction();
        }
        public boolean isContraption() {
            return getType().isContraption();
        }
        public boolean isInstant() {
            return getType().isInstant();
        }
        public boolean isSorcery() {
            return getType().isSorcery();
        }

        @Override
        public String getTranslationKey() {
            String key = getName();
            String variant = getFunctionalVariantName();
            if(StringUtils.isNotEmpty(variant))
                key = key + " $" + variant;
            return key;
        }

        @Override
        public String getUntranslatedType() {
            return getType().toString();
        }

        @Override
        public String getTranslatedName() {
            return CardTranslation.getTranslatedName(this);
        }
    }
```

## Python
`forge/game/card/CardView/CardStateView.py`

```python
from typing import Iterable

from forge.trackable.TrackableObject import TrackableObject
from forge.util.ITranslatable import ITranslatable
from forge.card.CardRarity import CardRarity
from forge.card.CardRules import CardRules
from forge.card.CardStateName import CardStateName
from forge.card.CardTypeView import CardTypeView
from forge.card.ColorSet import ColorSet
from forge.card.mana.ManaCost import ManaCost
from forge.game.card.Card import Card
from forge.game.card.CardState import CardState
from forge.game.card.CardView import CardView
from forge.game.keyword.Keyword import Keyword
from forge.game.keyword.KeywordCollectionView import KeywordCollectionView
from forge.game.player.PlayerView import PlayerView
from forge.game.spellability.AbilityManaPart import AbilityManaPart
from forge.game.spellability.SpellAbility import SpellAbility
from forge.trackable.Tracker import Tracker

from forge.trackable.TrackableProperty import TrackableProperty
from forge.StaticData import StaticData
from forge.ImageKeys import ImageKeys
from forge.game.card.CardType import CardType
from forge.game.zone.ZoneType import ZoneType
from forge.card.CardEdition import CardEdition
from forge.card.MagicColor import MagicColor
from forge.util.Localizer import Localizer
from forge.util.CardTranslation import CardTranslation


class CardStateView(TrackableObject, ITranslatable):
    serialVersionUID = 6673944200513430607

    def __init__(self, id0: int, state0: CardStateName, tracker: Tracker):
        super().__init__(id0, tracker)
        self.state = state0
        self.foilIndexOverride = -1

    def getDisplayId(self) -> str:
        if self.getState() == CardStateName.FaceDown:
            return "H" + str(self.getCard().getHiddenId())
        id = self.getId()
        if id > 0:
            return str(self.getId())
        return ""

    def hashCode(self) -> int:
        return hash((self.getId(), self.state))

    def toString(self) -> str:
        return (self.getName() + " (" + self.getDisplayId() + ")").strip()

    def getCard(self) -> CardView:
        return CardView.this

    def getState(self) -> CardStateName:
        return self.state

    def getName(self) -> str:
        return self.get(TrackableProperty.Name)

    def updateName(self, c: CardState) -> None:
        card = c.getCard()
        self.setName(card.getDisplayName(c))
        self.setOracleName(card.getName(c))

        if self.getCard().getCurrentState() == self:
            self.getCard().updateName(card)

    def setName(self, name: str) -> None:
        self.set(TrackableProperty.Name, name)

    def getOracleName(self) -> str:
        """The name of the card, unaltered by flavor names."""
        return self.get(TrackableProperty.OracleName)

    def setOracleName(self, name: str) -> None:
        self.set(TrackableProperty.OracleName, name)

    def getColors(self) -> ColorSet:
        return self.get(TrackableProperty.Colors)

    def getOriginalColors(self) -> ColorSet:
        return self.get(TrackableProperty.OriginalColors)

    def updateColors(self, c) -> None:
        self.set(TrackableProperty.Colors, c.getColor())

    def setOriginalColors(self, c: Card) -> None:
        self.set(TrackableProperty.OriginalColors, c.getColor())

    def updateHasChangeColors(self, hasChangeColor: bool) -> None:
        self.set(TrackableProperty.HasChangedColors, hasChangeColor)

    def hasChangeColors(self) -> bool:
        return self.get(TrackableProperty.HasChangedColors)

    def getImageKey(self, viewers: Iterable[PlayerView] = None) -> str:
        if self.getState() == CardStateName.FaceDown:
            return self.getCard().getFacedownImageKey()
        if self.getCard().canBeShownToAny(viewers):
            if self.getCard().isCloned() and StaticData.instance().useSourceImageForClone():
                return self.getCard().getBackup().getCurrentState().getImageKey(viewers)
            return self.get(TrackableProperty.ImageKey)
        return ImageKeys.getTokenKey(ImageKeys.HIDDEN_CARD)

    def getTrackableImageKey(self) -> str:
        # Use this for revealing purposes only
        return self.get(TrackableProperty.ImageKey)

    def updateImageKey(self, c) -> None:
        self.set(TrackableProperty.ImageKey, c.getImageKey())

    def getType(self) -> CardTypeView:
        if self.getState() != CardStateName.Original and self.getCard().isFaceDown() and not self.getCard().isInZone({ZoneType.Battlefield, ZoneType.Stack}):
            return CardType.EMPTY
        return self.get(TrackableProperty.Type)

    def updateType(self, c: CardState) -> None:
        self.set(TrackableProperty.Type, c.getTypeWithChanges())

    def getManaCost(self) -> ManaCost:
        return self.get(TrackableProperty.ManaCost)

    def getOriginalManaCost(self) -> ManaCost:
        return self.get(TrackableProperty.OriginalManaCost)

    def updateManaCost(self, c) -> None:
        if isinstance(c, Card):
            self.set(TrackableProperty.ManaCost, c.getCurrentState().getPerpetualAdjustedManaCost())
            self.set(TrackableProperty.OriginalManaCost, c.getManaCost())
        else:
            self.set(TrackableProperty.ManaCost, c.getPerpetualAdjustedManaCost())
            self.set(TrackableProperty.OriginalManaCost, c.getManaCost())

    def getOracleText(self) -> str:
        return self.get(TrackableProperty.OracleText)

    def setOracleText(self, oracleText: str) -> None:
        self.set(TrackableProperty.OracleText, oracleText.replace("\\n", "\r\n\r\n").strip())

    def getFunctionalVariantName(self) -> str:
        return self.get(TrackableProperty.FunctionalVariant)

    def setFunctionalVariantName(self, functionalVariant: str) -> None:
        self.set(TrackableProperty.FunctionalVariant, functionalVariant)

    def getRulesText(self) -> str:
        return self.get(TrackableProperty.RulesText)

    def updateRulesText(self, rules: CardRules) -> None:
        rulesText = None

        if rules is not None and rules.getType().isVanguard():
            decHand = rules.getHand() < 0
            decLife = rules.getLife() < 0
            handSize = Localizer.getInstance().getMessageorUseDefault("lblHandSize", "Hand Size") \
                + ((": +" if not decHand else ": ")) + str(rules.getHand())
            startingLife = Localizer.getInstance().getMessageorUseDefault("lblStartingLife", "Starting Life") \
                + ((": +" if not decLife else ": ")) + str(rules.getLife())
            rulesText = handSize + "\r\n" + startingLife
        self.set(TrackableProperty.RulesText, rulesText)

    def getPower(self) -> int:
        return self.get(TrackableProperty.Power)

    def updatePower(self, c) -> None:
        if isinstance(c, CardState):
            card = c.getCard()
            if card is not None:
                self.updatePower(card)  # TODO: find a better way to do this
                return
            self.set(TrackableProperty.Power, c.getBasePower())
            return
        if self.hasPrintedPT() and not self.isCreature():
            # use printed value so user can still see it
            num = c.getCurrentPower()
        else:
            num = c.getNetPower()
        if c.getCurrentState().getView() != self and c.getAlternateState() is not None:
            num = num - c.getBasePower() + c.getAlternateState().getBasePower()
        self.set(TrackableProperty.Power, num)

    def getToughness(self) -> int:
        return self.get(TrackableProperty.Toughness)

    def updateToughness(self, c) -> None:
        if isinstance(c, CardState):
            card = c.getCard()
            if card is not None:
                self.updateToughness(card)  # TODO: find a better way to do this
                return
            self.set(TrackableProperty.Toughness, c.getBaseToughness())
            return
        if self.hasPrintedPT() and not self.isCreature():
            # use printed value so user can still see it
            num = c.getCurrentToughness()
        else:
            num = c.getNetToughness()
        if c.getCurrentState().getView() != self and c.getAlternateState() is not None:
            num = num - c.getBaseToughness() + c.getAlternateState().getBaseToughness()
        self.set(TrackableProperty.Toughness, num)

    def getLoyalty(self) -> str:
        return self.get(TrackableProperty.Loyalty)

    def updateLoyalty(self, c) -> None:
        if isinstance(c, str):
            self.set(TrackableProperty.Loyalty, c)
            return
        if isinstance(c, CardState):
            if self.getCard().getCurrentState() == self:
                card = c.getCard()
                if card is not None:
                    if card.isInZone(ZoneType.Battlefield):
                        self.updateLoyalty(card)
                    else:
                        self.updateLoyalty(c.getBaseLoyalty())
                    return
            self.set(TrackableProperty.Loyalty, "0")  # alternates don't need loyalty
            return
        # Card
        if c.isInZone(ZoneType.Battlefield):
            self.updateLoyalty(str(c.getCurrentLoyalty()))
        else:
            self.updateLoyalty(c.getCurrentState().getBaseLoyalty())

    def getDefense(self) -> str:
        return self.get(TrackableProperty.Defense)

    def updateDefense(self, c) -> None:
        if isinstance(c, str):
            self.set(TrackableProperty.Defense, c)
            return
        if isinstance(c, CardState):
            if self.getCard().getCurrentState() == self:
                card = c.getCard()
                if card is not None:
                    if card.isInZone(ZoneType.Battlefield):
                        self.updateDefense(card)
                    else:
                        self.updateDefense(c.getBaseDefense())
                    return
            self.updateDefense("0")
            return
        # Card
        if c.isInZone(ZoneType.Battlefield):
            self.updateDefense(str(c.getCurrentDefense()))
        else:
            self.updateDefense(c.getCurrentState().getBaseDefense())

    def getAttractionLights(self) -> set[int]:
        return self.get(TrackableProperty.AttractionLights)

    def updateAttractionLights(self, c: CardState) -> None:
        self.set(TrackableProperty.AttractionLights, c.getAttractionLights())

    def hasPrintedPT(self) -> bool:
        return self.get(TrackableProperty.HasPrintedPT)

    def updateHasPrintedPT(self, v: bool) -> None:
        self.set(TrackableProperty.HasPrintedPT, v)

    def getSetCode(self) -> str:
        return self.get(TrackableProperty.SetCode)

    def updateSetCode(self, c: CardState) -> None:
        self.set(TrackableProperty.SetCode, c.getSetCode())

    def getRarity(self) -> CardRarity:
        return self.get(TrackableProperty.Rarity)

    def updateRarity(self, c: CardState) -> None:
        self.set(TrackableProperty.Rarity, c.getRarity())

    def getFoilIndex(self) -> int:
        if self.foilIndexOverride >= 0:
            return self.foilIndexOverride
        return self.get(TrackableProperty.FoilIndex)

    def updateFoilIndex(self, c) -> None:
        if isinstance(c, Card):
            self.updateFoilIndex(c.getCurrentState())
        else:
            self.set(TrackableProperty.FoilIndex, c.getFoil())

    def setFoilIndexOverride(self, index0: int) -> None:
        if index0 < 0:
            index0 = CardEdition.getRandomFoil(self.getSetCode())
        self.foilIndexOverride = index0

    def getKeywords(self) -> KeywordCollectionView:
        return self.get(TrackableProperty.Keywords)

    def hasKeyword(self, keyword: Keyword) -> bool:
        return self.getKeywords().contains(keyword)

    def hasAnnihilator(self) -> bool:
        return self.get(TrackableProperty.HasAnnihilator)

    def hasWard(self) -> bool:
        return self.get(TrackableProperty.HasWard)

    def hasDeathtouch(self) -> bool:
        return self.hasKeyword(Keyword.DEATHTOUCH)

    def hasDevoid(self) -> bool:
        return self.hasKeyword(Keyword.DEVOID)

    def hasTrample(self) -> bool:
        return self.hasKeyword(Keyword.TRAMPLE)

    def hasHaste(self) -> bool:
        return self.hasKeyword(Keyword.HASTE)

    def hasInfect(self) -> bool:
        return self.hasKeyword(Keyword.INFECT)

    def hasStorm(self) -> bool:
        return self.hasKeyword(Keyword.STORM)

    def hasAftermath(self) -> bool:
        return self.hasKeyword(Keyword.AFTERMATH)

    def hasDivideDamage(self) -> bool:
        return self.get(TrackableProperty.HasDivideDamage)

    def origProduceAnyMana(self) -> bool:
        return self.get(TrackableProperty.OrigProduceAnyMana)

    def origProduceMana(self) -> ColorSet:
        return self.get(TrackableProperty.OrigProduceMana)

    def getAbilityText(self) -> str:
        return self.get(TrackableProperty.AbilityText)

    def updateAbilityText(self, c: Card, state: CardState) -> None:
        self.set(TrackableProperty.AbilityText, c.getAbilityText(state))

    def updateKeywords(self, c: Card, state: CardState) -> None:
        c.updateKeywordsCache(state)
        self.set(TrackableProperty.Keywords, state.getCachedKeywords().getView())
        # deeper check for Idris
        self.set(TrackableProperty.HasAnnihilator, c.hasKeyword(Keyword.ANNIHILATOR, state) or any(t.isKeyword(Keyword.ANNIHILATOR) for t in state.getTriggers()))
        self.set(TrackableProperty.HasWard, c.hasKeyword(Keyword.WARD, state) or any(t.isKeyword(Keyword.WARD) for t in state.getTriggers()))
        self.updateAbilityText(c, state)
        # update Trackable Mana Color for BG Colors
        self.updateManaColorBG(state)

        self.set(TrackableProperty.HasDivideDamage, c.hasKeyword("You may assign CARDNAME's combat damage divided as "
                 "you choose among defending player and/or any number of creatures they control."))

    def updateManaColorBG(self, state: CardState) -> None:
        anyMana = False
        cMana = False
        colors = 0
        for sa in state.getManaAbilities():
            if sa is None:
                continue
            for mp in sa.getAllManaParts():
                if mp.isAnyMana():
                    anyMana = True
                    continue

                colorsProduced = mp.mana(sa).split(" ")

                # todo improve this
                for s in colorsProduced:
                    u = s.upper()
                    if u == "R":
                        colors |= MagicColor.RED
                    elif u == "G":
                        colors |= MagicColor.GREEN
                    elif u == "B":
                        colors |= MagicColor.BLACK
                    elif u == "U":
                        colors |= MagicColor.BLUE
                    elif u == "W":
                        colors |= MagicColor.WHITE
                    elif u == "C":
                        cMana = True
        self.set(TrackableProperty.OrigProduceMana, ColorSet.fromMask(colors) if colors > 0 else (ColorSet.C if cMana else None))
        self.set(TrackableProperty.OrigProduceAnyMana, anyMana)

    def isBasicLand(self) -> bool:
        return self.getType().isBasicLand()

    def isCreature(self) -> bool:
        return self.getType().isCreature()

    def isLand(self) -> bool:
        return self.getType().isLand()

    def isPlane(self) -> bool:
        return self.getType().isPlane()

    def isPhenomenon(self) -> bool:
        return self.getType().isPhenomenon()

    def isPlaneswalker(self) -> bool:
        return self.getType().isPlaneswalker()

    def isBattle(self) -> bool:
        return self.getType().isBattle()

    def isVehicle(self) -> bool:
        return self.getType().hasSubtype("Vehicle")

    def isArtifact(self) -> bool:
        return self.getType().isArtifact()

    def isEnchantment(self) -> bool:
        return self.getType().isEnchantment()

    def isSpaceCraft(self) -> bool:
        return self.getType().hasSubtype("Spacecraft")

    def isAttraction(self) -> bool:
        return self.getType().isAttraction()

    def isContraption(self) -> bool:
        return self.getType().isContraption()

    def isInstant(self) -> bool:
        return self.getType().isInstant()

    def isSorcery(self) -> bool:
        return self.getType().isSorcery()

    def getTranslationKey(self) -> str:
        key = self.getName()
        variant = self.getFunctionalVariantName()
        if variant is not None and len(variant) > 0:
            key = key + " $" + variant
        return key

    def getUntranslatedType(self) -> str:
        return self.getType().toString()

    def getTranslatedName(self) -> str:
        return CardTranslation.getTranslatedName(self)
```
