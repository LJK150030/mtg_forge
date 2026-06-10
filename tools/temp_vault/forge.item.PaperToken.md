---
aliases:
  - PaperToken
tags:
  - java/class
  - module/forge-core
  - pkg/forge/item
fqn: forge.item.PaperToken
package: forge.item
module: forge-core
kind: Class
---

# PaperToken

**Package:** `forge.item` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class PaperToken {
        -long serialVersionUID
        -String name
        -String collectorNumber
        -String artist
        -CardEdition edition
        -ArrayList~String~ imageFileName
        -CardRules cardRules
        -int artIndex
        +makeTokenFileName(String in) String
        +makeTokenFileName(String colors, String power, String toughness, String types) String
        +makeTokenFileName(String name, String colors, String power, String toughness, String types) String
        +getName() String
        +getDisplayName() String
        +toString() String
        +getEdition() String
        +getCollectorNumber() String
        +getFunctionalVariant() String
        +getMarkedColors() ColorSet
        +getArtIndex() int
        +isFoil() boolean
        +getRules() CardRules
        +getRarity() CardRarity
        +getArtist() String
        +getImageFilename(int idx) String
        +getItemType() String
        +hasBackFace() boolean
        +getMainFace() ICardFace
        +getOtherFace() ICardFace
        +getAllFaces() List~ICardFace~
        +isToken() boolean
        +getCardImageKey() String
        +getCardAltImageKey() String
        +getImageKey(boolean altState) String
        +getImageKey(int artIndex) String
        +isRebalanced() boolean
        +PaperToken(CardRules c, CardEdition edition0, String imageFileName, String collectorNumber, String artist)
    }
    PaperToken ..|> InventoryItemFromSet : implements
    PaperToken ..|> IPaperCard : implements
    PaperToken ..> CardEdition : uses
    PaperToken ..> CardRarity : uses
    PaperToken ..> CardRules : uses
    PaperToken ..> CardSplitType : uses
    PaperToken ..> ColorSet : uses
    PaperToken ..> ICardFace : uses
```

## Relationships
**Implements:**
- [[forge.item.IPaperCard|IPaperCard]]
- [[forge.item.InventoryItemFromSet|InventoryItemFromSet]]
**Uses:**
- [[forge.card.CardEdition|CardEdition]]
- [[forge.card.CardRarity|CardRarity]]
- [[forge.card.CardRules|CardRules]]
- [[forge.card.CardSplitType|CardSplitType]]
- [[forge.card.ColorSet|ColorSet]]
- [[forge.card.ICardFace|ICardFace]]

## Design Description

PaperToken represents a physical Magic token card within Forge's inventory model, implementing both `IPaperCard` and `InventoryItemFromSet` so tokens are treated uniformly alongside ordinary paper cards. It wraps the token's gameplay definition (`CardRules`) and printing metadata (`CardEdition`, collector number, artist), exposing identity, face, color, and image-key accessors while hardcoding token-appropriate defaultsâ€”`CardRarity.Token`, never foil, no functional variant or marked colors.

Its central responsibility is resolving token art into stable image keys: static `makeTokenFileName` helpers normalize descriptive strings ("colors power toughness name") into lowercase filenames, while the constructor builds edition- and collector-number-qualified image keys, tracking multiple art indices per token. Image-key lookup randomizes among available art and, for transform/modal tokens (`hasBackFace`), derives a back-face key from the other `ICardFace`. The `transient` rules and edition fields signal that runtime data is reconstructed rather than serialized.

## Source
`forge-core/src/main/java/forge/item/PaperToken.java`

```java
package forge.item;

import forge.ImageKeys;
import forge.card.*;
import forge.util.MyRandom;
import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class PaperToken implements InventoryItemFromSet, IPaperCard {
    private static final long serialVersionUID = 1L;
    private String name;
    private String collectorNumber;
    private String artist;
    private transient CardEdition edition;
    private ArrayList<String> imageFileName = new ArrayList<>();
    private transient CardRules cardRules;
    private int artIndex = 1;

    // takes a string of the form "<colors> <power> <toughness> <name>" such as: "B 0 0 Germ"
    public static String makeTokenFileName(String in) {
        StringBuffer out = new StringBuffer();
        char c;
        for (int i = 0; i < in.length(); i++) {
            c = in.charAt(i);
            if ((c == ' ') || (c == '-') || (c == '_')) {
                out.append('_');
            } else if (Character.isLetterOrDigit(c)) {
                out.append(c);
            }
        }
        return out.toString().toLowerCase(Locale.ENGLISH);
    }

    public static String makeTokenFileName(String colors, String power, String toughness, String types) {
        return makeTokenFileName(null, colors, power, toughness, types);
    }

    public static String makeTokenFileName(String name, String colors, String power, String toughness, String types) {
        ArrayList<String> build = new ArrayList<>();
        if (name != null) {
            build.add(name);
        }

        build.add(colors);

        if (power != null && toughness != null) {
            build.add(power);
            build.add(toughness);
        }
        build.add(types);

        String fileName = StringUtils.join(build, "_");
        return makeTokenFileName(fileName);
    }

    public PaperToken(final CardRules c, CardEdition edition0, String imageFileName, String collectorNumber, String artist) {
        this.cardRules = c;
        this.name = c.getName();
        this.edition = edition0;
        this.collectorNumber = collectorNumber;
        this.artist = artist;

        if (collectorNumber != null && !collectorNumber.isEmpty() && edition != null && edition.getTokens().containsKey(imageFileName)) {
            int idx = 0;
            // count the one with the same collectorNumber
            for (CardEdition.EditionEntry t : edition.getTokens().get(imageFileName)) {
                ++idx;
                if (!t.collectorNumber().equals(collectorNumber)) {
                    continue;
                }
                // TODO make better image file names when collector number is known
                // for the right index, we need to count the ones with wrong collector number too
                this.imageFileName.add(String.format("%s|%s|%s|%d", imageFileName, edition.getCode(), collectorNumber, idx));
            }
            this.artIndex = this.imageFileName.size();
        } else if (null == edition || CardEdition.UNKNOWN == edition) {
            this.imageFileName.add(imageFileName);
        } else {
            // Fallback if CollectorNumber is not used
            this.imageFileName.add(String.format("%s|%s", imageFileName, edition.getCode()));
        }
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public String getDisplayName() {
        return name;
    }

    @Override
    public String toString() {
        return name;
    }

    @Override
    public String getEdition() {
        return edition != null ? edition.getCode() : CardEdition.UNKNOWN_CODE;
    }

    @Override
    public String getCollectorNumber() {
        if (collectorNumber.isEmpty())
            return IPaperCard.NO_COLLECTOR_NUMBER;
        return collectorNumber;
    }

    @Override
    public String getFunctionalVariant() {
        //Tokens aren't differentiated by name, so they don't really need support for this.
        return IPaperCard.NO_FUNCTIONAL_VARIANT;
    }

    @Override
    public ColorSet getMarkedColors() {
        return null;
    }

    @Override
    public int getArtIndex() {
        return artIndex;
    }

    @Override
    public boolean isFoil() {
        return false;
    }

    @Override
    public CardRules getRules() {
        return cardRules;
    }

    @Override
    public CardRarity getRarity() {
        return CardRarity.Token;
    }

    @Override
    public String getArtist() {
        return artist;
    }

    public String getImageFilename(int idx) {
        return imageFileName.get(idx - 1);
    }

    @Override
    public String getItemType() {
        return "Token";
    }

    @Override
    public boolean hasBackFace() {
        if (this.cardRules == null)
            return false;
        CardSplitType cst = this.cardRules.getSplitType();
        //expand this on future for other tokens that has other backsides besides transform..
        return cst == CardSplitType.Transform || cst == CardSplitType.Modal;
    }

    @Override
    public ICardFace getMainFace() {
        return this.getRules().getMainPart();
    }

    @Override
    public ICardFace getOtherFace() {
        return this.getRules().getOtherPart();
    }

    @Override
    public List<ICardFace> getAllFaces() {
        return this.cardRules.getAllFaces();
    }

    @Override
    public boolean isToken() {
        return true;
    }

    // IPaperCard
    @Override
    public String getCardImageKey() {
        return this.getImageKey(false);
    }

    @Override
    public String getCardAltImageKey() {
        return getImageKey(true);
    }

    // InventoryItem
    @Override
    public String getImageKey(boolean altState) {
        String suffix = "";
        if (hasBackFace() && altState) {
            if (collectorNumber != null && !collectorNumber.isEmpty() && edition != null) {
                String name = cardRules.getOtherPart().getName().toLowerCase().replace(" token", "").replace(" ", "_");
                return ImageKeys.getTokenKey(String.format("%s|%s|%s%s", name, edition.getCode(), collectorNumber, ImageKeys.BACKFACE_POSTFIX));
            } else {
                suffix = ImageKeys.BACKFACE_POSTFIX;
            }
        }
        int idx = MyRandom.getRandom().nextInt(artIndex);
        return getImageKey(idx) + suffix;
    }

    public String getImageKey(int artIndex) {
        return ImageKeys.getTokenKey(imageFileName.get(artIndex).replace(" ", "_"));
    }

    public boolean isRebalanced() {
        return false;
    }
}
```

## Python
`forge/item/PaperToken.py`

```python
from forge.ImageKeys import ImageKeys
from forge.card.CardEdition import CardEdition
from forge.card.CardRarity import CardRarity
from forge.card.CardRules import CardRules
from forge.card.CardSplitType import CardSplitType
from forge.card.ColorSet import ColorSet
from forge.card.ICardFace import ICardFace
from forge.item.IPaperCard import IPaperCard
from forge.item.InventoryItemFromSet import InventoryItemFromSet
from forge.util.MyRandom import MyRandom


class PaperToken(InventoryItemFromSet, IPaperCard):
    serialVersionUID = 1

    # takes a string of the form "<colors> <power> <toughness> <name>" such as: "B 0 0 Germ"
    @staticmethod
    def makeTokenFileName(*args):
        if len(args) == 1:
            in_ = args[0]
            out = []
            for i in range(len(in_)):
                c = in_[i]
                if c == ' ' or c == '-' or c == '_':
                    out.append('_')
                elif c.isalnum():
                    out.append(c)
            return ''.join(out).lower()
        elif len(args) == 4:
            colors, power, toughness, types = args
            return PaperToken.makeTokenFileName(None, colors, power, toughness, types)
        else:
            name, colors, power, toughness, types = args
            build = []
            if name is not None:
                build.append(name)

            build.append(colors)

            if power is not None and toughness is not None:
                build.append(power)
                build.append(toughness)
            build.append(types)

            fileName = "_".join(build)
            return PaperToken.makeTokenFileName(fileName)

    def __init__(self, c: CardRules, edition0: CardEdition, imageFileName: str, collectorNumber: str, artist: str):
        self.name = None
        self.collectorNumber = None
        self.artist = None
        self.edition = None
        self.imageFileName = []
        self.cardRules = None
        self.artIndex = 1

        self.cardRules = c
        self.name = c.getName()
        self.edition = edition0
        self.collectorNumber = collectorNumber
        self.artist = artist

        if collectorNumber is not None and collectorNumber != "" and self.edition is not None and imageFileName in self.edition.getTokens():
            idx = 0
            # count the one with the same collectorNumber
            for t in self.edition.getTokens()[imageFileName]:
                idx += 1
                if t.collectorNumber() != collectorNumber:
                    continue
                # TODO make better image file names when collector number is known
                # for the right index, we need to count the ones with wrong collector number too
                self.imageFileName.append("%s|%s|%s|%d" % (imageFileName, self.edition.getCode(), collectorNumber, idx))
            self.artIndex = len(self.imageFileName)
        elif self.edition is None or CardEdition.UNKNOWN == self.edition:
            self.imageFileName.append(imageFileName)
        else:
            # Fallback if CollectorNumber is not used
            self.imageFileName.append("%s|%s" % (imageFileName, self.edition.getCode()))

    def getName(self) -> str:
        return self.name

    def getDisplayName(self) -> str:
        return self.name

    def __str__(self) -> str:
        return self.name

    def getEdition(self) -> str:
        return self.edition.getCode() if self.edition is not None else CardEdition.UNKNOWN_CODE

    def getCollectorNumber(self) -> str:
        if self.collectorNumber == "":
            return IPaperCard.NO_COLLECTOR_NUMBER
        return self.collectorNumber

    def getFunctionalVariant(self) -> str:
        # Tokens aren't differentiated by name, so they don't really need support for this.
        return IPaperCard.NO_FUNCTIONAL_VARIANT

    def getMarkedColors(self) -> ColorSet:
        return None

    def getArtIndex(self) -> int:
        return self.artIndex

    def isFoil(self) -> bool:
        return False

    def getRules(self) -> CardRules:
        return self.cardRules

    def getRarity(self) -> CardRarity:
        return CardRarity.Token

    def getArtist(self) -> str:
        return self.artist

    def getImageFilename(self, idx: int) -> str:
        return self.imageFileName[idx - 1]

    def getItemType(self) -> str:
        return "Token"

    def hasBackFace(self) -> bool:
        if self.cardRules is None:
            return False
        cst = self.cardRules.getSplitType()
        # expand this on future for other tokens that has other backsides besides transform..
        return cst == CardSplitType.Transform or cst == CardSplitType.Modal

    def getMainFace(self) -> ICardFace:
        return self.getRules().getMainPart()

    def getOtherFace(self) -> ICardFace:
        return self.getRules().getOtherPart()

    def getAllFaces(self) -> list[ICardFace]:
        return self.cardRules.getAllFaces()

    def isToken(self) -> bool:
        return True

    # IPaperCard
    def getCardImageKey(self) -> str:
        return self.getImageKey(False)

    def getCardAltImageKey(self) -> str:
        return self.getImageKey(True)

    # InventoryItem
    def getImageKey(self, altState) -> str:
        if isinstance(altState, bool):
            suffix = ""
            if self.hasBackFace() and altState:
                if self.collectorNumber is not None and self.collectorNumber != "" and self.edition is not None:
                    name = self.cardRules.getOtherPart().getName().lower().replace(" token", "").replace(" ", "_")
                    return ImageKeys.getTokenKey("%s|%s|%s%s" % (name, self.edition.getCode(), self.collectorNumber, ImageKeys.BACKFACE_POSTFIX))
                else:
                    suffix = ImageKeys.BACKFACE_POSTFIX
            idx = MyRandom.getRandom().nextInt(self.artIndex)
            return self.getImageKey(idx) + suffix
        else:
            artIndex = altState
            return ImageKeys.getTokenKey(self.imageFileName[artIndex].replace(" ", "_"))

    def isRebalanced(self) -> bool:
        return False
```
