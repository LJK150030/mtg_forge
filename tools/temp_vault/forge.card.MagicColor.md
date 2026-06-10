---
aliases:
  - MagicColor
tags:
  - java/class
  - module/forge-core
  - pkg/forge/card
fqn: forge.card.MagicColor
package: forge.card
module: forge-core
kind: Class
---

# MagicColor

**Package:** `forge.card` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class MagicColor {
        +byte WHITE
        +byte BLUE
        +byte BLACK
        +byte RED
        +byte GREEN
        +byte COLORLESS
        +byte ALL_COLORS
        +int NUMBER_OR_COLORS
        +byte[] WUBRG
        +byte[] WUBRGC
        +byte[] COLORPAIR
        +fromName(String s) byte
        +fromName(char c) byte
        +toShortString(String color) String
        +toShortString(byte color) String
        +toLongString(byte color) String
        +toSymbol(byte color) String
        +toSymbol(String color) String
        -MagicColor()
    }
    MagicColor ..> Color : uses
    MagicColor ..> ITranslatable : uses
```

## Relationships
**Uses:**
- [[forge.card.MagicColor.Color|Color]]
- [[forge.util.ITranslatable|ITranslatable]]


## Design Description

MagicColor is a final, non-instantiable utility class in `forge.card` that centralizes Magic: The Gathering's color model for the engine. It encodes the five colors plus colorless as single-bit `byte` flags, so multi-color identities (color pairs, all-colors) compose naturally through bitwise OR, and it publishes reusable constant arrays (WUBRG, WUBRGC, COLORPAIR) and canonical string literals via its nested `Constant` class. Its static converters translate freely among names, characters, short codes, symbols, and bytes, making it the engine's single point of truth for color identity.

It delegates richer per-color metadata to the nested `Color` enum, which maps each bitmask to display names, symbols, and basic land types and implements `ITranslatable` (through `Localizer`) for localized labels. This split keeps the lightweight bitmask API stable and fast while the enum carries heavier, translatable dataâ€”a deliberate choice favoring compact `byte` flags in performance-sensitive color logic.

## Source
`forge-core/src/main/java/forge/card/MagicColor.java`

```java
package forge.card;

import java.util.Locale;

import com.google.common.collect.ImmutableList;

import forge.util.ITranslatable;
import forge.util.Localizer;

/**
 * Holds byte values for each color magic has.
 */
public final class MagicColor {

    // Colorless value synchronized with value in ManaAtom
    public static final byte WHITE     = 1 << 0;
    public static final byte BLUE      = 1 << 1;
    public static final byte BLACK     = 1 << 2;
    public static final byte RED       = 1 << 3;
    public static final byte GREEN     = 1 << 4;
    // Colorless values for MagicColor needs to be the absence of any color
    // Any comparison between colorless cards and colorless mana need to be adjusted appropriately.
    public static final byte COLORLESS = 0;

    public static final byte ALL_COLORS = WHITE | BLUE | BLACK | RED | GREEN;

    public static final int NUMBER_OR_COLORS = 5;

    public static final byte[] WUBRG  = new byte[] { WHITE, BLUE, BLACK, RED, GREEN };
    public static final byte[] WUBRGC = new byte[] { WHITE, BLUE, BLACK, RED, GREEN, COLORLESS };
    public static final byte[] COLORPAIR  = new byte[] { WHITE | BLUE, BLUE | BLACK, BLACK | RED, RED | GREEN, GREEN | WHITE,
            WHITE | BLACK, BLUE | RED, BLACK | GREEN, RED | WHITE, GREEN | BLUE };

    /**
     * Private constructor to prevent instantiation.
     */
    private MagicColor() {
    }

    public static byte fromName(String s) {
        if (s == null) {
            return 0;
        }
        if (s.equals("all")) {
            return MagicColor.ALL_COLORS;
        }
        if (s.length() == 2) { //if name is two characters, check for combination of two colors
            return (byte)(fromName(s.charAt(0)) | fromName(s.charAt(1)));
        }
        s = s.toLowerCase();
        if (s.length() == 1) {
            switch (s) {
                case "w": return MagicColor.WHITE;
                case "u": return MagicColor.BLUE;
                case "b": return MagicColor.BLACK;
                case "r": return MagicColor.RED;
                case "g": return MagicColor.GREEN;
                case "c": return MagicColor.COLORLESS;
            }
        } else {
            switch (s) {
                case Constant.WHITE: return MagicColor.WHITE;
                case Constant.BLUE: return MagicColor.BLUE;
                case Constant.BLACK: return MagicColor.BLACK;
                case Constant.RED: return MagicColor.RED;
                case Constant.GREEN: return MagicColor.GREEN;
                case Constant.COLORLESS: return MagicColor.COLORLESS;
            }
        }
        return 0; // colorless
    }

    public static byte fromName(final char c) {
        return switch (Character.toLowerCase(c)) {
            case 'w' -> MagicColor.WHITE;
            case 'u' -> MagicColor.BLUE;
            case 'b' -> MagicColor.BLACK;
            case 'r' -> MagicColor.RED;
            case 'g' -> MagicColor.GREEN;
            default  -> 0; // unknown means 'colorless'
        };
    }

    // This probably should be in ManaAtom since it cares about Mana, not Color.
    public static String toShortString(final String color) {
        if (color.equalsIgnoreCase(Constant.SNOW)) {
            return "S";
        } // compatibility
        return toShortString(fromName(color));
    }

    public static String toShortString(final byte color) {
        return Color.fromByte(color).getShortName();
    }

    public static String toLongString(final byte color) {
        return Color.fromByte(color).getName();
    }

    public static String toSymbol(final byte color) {
        return Color.fromByte(color).getSymbol();
    }

    public static String toSymbol(final String color) {
        return toSymbol(fromName(color));
    }

    /**
     * The Interface Color.
     */
    public static final class Constant {
        /** The White. */
        public static final String WHITE = "white";

        /** The Blue. */
        public static final String BLUE = "blue";

        /** The Black. */
        public static final String BLACK = "black";

        /** The Red. */
        public static final String RED = "red";

        /** The Green. */
        public static final String GREEN = "green";

        /** The Colorless. */
        public static final String COLORLESS = "colorless";

        /** The only colors. */
        public static final ImmutableList<String> ONLY_COLORS = ImmutableList.of(WHITE, BLUE, BLACK, RED, GREEN);
        public static final ImmutableList<String> COLORS_AND_COLORLESS = ImmutableList.of(WHITE, BLUE, BLACK, RED, GREEN, COLORLESS);

        /** The Snow. */
        public static final String SNOW = "snow";

        /** The Basic lands. */
        public static final ImmutableList<String> BASIC_LANDS = ImmutableList.of("Plains", "Island", "Swamp", "Mountain", "Forest");
        public static final ImmutableList<String> SNOW_LANDS = ImmutableList.of("Snow-Covered Plains", "Snow-Covered Island", "Snow-Covered Swamp", "Snow-Covered Mountain", "Snow-Covered Forest");

        public static final String ANY_COLOR_CONVERSION = "AnyType->AnyColor";
        public static final String ANY_TYPE_CONVERSION = "AnyType->AnyType";
        /**
         * Private constructor to prevent instantiation.
         */
        private Constant() {
        }
    }

    public enum Color implements ITranslatable {
        WHITE(Constant.WHITE, MagicColor.WHITE, "W", "Plains", "lblWhite"),
        BLUE(Constant.BLUE, MagicColor.BLUE, "U", "Island", "lblBlue"),
        BLACK(Constant.BLACK, MagicColor.BLACK, "B", "Swamp", "lblBlack"),
        RED(Constant.RED, MagicColor.RED, "R", "Mountain", "lblRed"),
        GREEN(Constant.GREEN, MagicColor.GREEN, "G", "Forest", "lblGreen"),
        COLORLESS(Constant.COLORLESS, MagicColor.COLORLESS, "C", null, "lblColorless");

        private final String name, shortName, symbol;
        private final String basicLandType;
        private final String label;
        private final byte colormask;

        Color(String name0, byte colormask0, String shortName, String basicLandType, String label) {
            name = name0;
            colormask = colormask0;
            this.shortName = shortName;
            symbol = "{" + shortName + "}";
            this.basicLandType = basicLandType;
            this.label = label;
        }

        public static Color fromByte(final byte color) {
            return switch (color) {
                case MagicColor.WHITE -> WHITE;
                case MagicColor.BLUE -> BLUE;
                case MagicColor.BLACK -> BLACK;
                case MagicColor.RED -> RED;
                case MagicColor.GREEN -> GREEN;
                default -> COLORLESS;
            };
        }
        public static Color fromName(final String color) {
            if (color == null) {
                return null;
            }
            return switch (color.toLowerCase(Locale.ROOT)) {
                case MagicColor.Constant.WHITE -> WHITE;
                case MagicColor.Constant.BLUE -> BLUE;
                case MagicColor.Constant.BLACK -> BLACK;
                case MagicColor.Constant.RED -> RED;
                case MagicColor.Constant.GREEN -> GREEN;
                case MagicColor.Constant.COLORLESS -> COLORLESS;
                default -> null;
            };
        }

        @Override
        public String getName() {
            return name;
        }
        public String getShortName() {
            return shortName;
        }
        public String getBasicLandType() {
            return basicLandType;
        }

        @Override
        public String getTranslatedName() {
            return Localizer.getInstance().getMessage(label);
        }

        public byte getColorMask() {
            return colormask;
        }
        public String getSymbol() {
            return symbol;
        }
    }

}
```

## Python
`forge/card/MagicColor.py`

```python
from forge.util.ITranslatable import ITranslatable
from forge.util.Localizer import Localizer


class Constant:
    """The Interface Color."""

    # The White.
    WHITE = "white"

    # The Blue.
    BLUE = "blue"

    # The Black.
    BLACK = "black"

    # The Red.
    RED = "red"

    # The Green.
    GREEN = "green"

    # The Colorless.
    COLORLESS = "colorless"

    # The only colors.
    ONLY_COLORS = (WHITE, BLUE, BLACK, RED, GREEN)
    COLORS_AND_COLORLESS = (WHITE, BLUE, BLACK, RED, GREEN, COLORLESS)

    # The Snow.
    SNOW = "snow"

    # The Basic lands.
    BASIC_LANDS = ("Plains", "Island", "Swamp", "Mountain", "Forest")
    SNOW_LANDS = ("Snow-Covered Plains", "Snow-Covered Island", "Snow-Covered Swamp",
                  "Snow-Covered Mountain", "Snow-Covered Forest")

    ANY_COLOR_CONVERSION = "AnyType->AnyColor"
    ANY_TYPE_CONVERSION = "AnyType->AnyType"

    def __init__(self):
        """Private constructor to prevent instantiation."""
        raise RuntimeError("Constant is non-instantiable")


class MagicColor:
    """Holds byte values for each color magic has."""

    # Colorless value synchronized with value in ManaAtom
    WHITE = 1 << 0
    BLUE = 1 << 1
    BLACK = 1 << 2
    RED = 1 << 3
    GREEN = 1 << 4
    # Colorless values for MagicColor needs to be the absence of any color
    # Any comparison between colorless cards and colorless mana need to be adjusted appropriately.
    COLORLESS = 0

    ALL_COLORS = WHITE | BLUE | BLACK | RED | GREEN

    NUMBER_OR_COLORS = 5

    WUBRG = [WHITE, BLUE, BLACK, RED, GREEN]
    WUBRGC = [WHITE, BLUE, BLACK, RED, GREEN, COLORLESS]
    COLORPAIR = [WHITE | BLUE, BLUE | BLACK, BLACK | RED, RED | GREEN, GREEN | WHITE,
                 WHITE | BLACK, BLUE | RED, BLACK | GREEN, RED | WHITE, GREEN | BLUE]

    def __init__(self):
        """Private constructor to prevent instantiation."""
        raise RuntimeError("MagicColor is non-instantiable")

    @staticmethod
    def fromName(s):
        if isinstance(s, str) and len(s) == 1:
            # char overload: case-insensitive single character
            c = s.lower()
            if c == 'w':
                return MagicColor.WHITE
            elif c == 'u':
                return MagicColor.BLUE
            elif c == 'b':
                return MagicColor.BLACK
            elif c == 'r':
                return MagicColor.RED
            elif c == 'g':
                return MagicColor.GREEN
            elif c == 'c':
                return MagicColor.COLORLESS
            return 0  # unknown means 'colorless'
        if s is None:
            return 0
        if s == "all":
            return MagicColor.ALL_COLORS
        if len(s) == 2:  # if name is two characters, check for combination of two colors
            return MagicColor.fromName(s[0]) | MagicColor.fromName(s[1])
        s = s.lower()
        if len(s) == 1:
            if s == "w":
                return MagicColor.WHITE
            elif s == "u":
                return MagicColor.BLUE
            elif s == "b":
                return MagicColor.BLACK
            elif s == "r":
                return MagicColor.RED
            elif s == "g":
                return MagicColor.GREEN
            elif s == "c":
                return MagicColor.COLORLESS
        else:
            if s == Constant.WHITE:
                return MagicColor.WHITE
            elif s == Constant.BLUE:
                return MagicColor.BLUE
            elif s == Constant.BLACK:
                return MagicColor.BLACK
            elif s == Constant.RED:
                return MagicColor.RED
            elif s == Constant.GREEN:
                return MagicColor.GREEN
            elif s == Constant.COLORLESS:
                return MagicColor.COLORLESS
        return 0  # colorless

    # This probably should be in ManaAtom since it cares about Mana, not Color.
    @staticmethod
    def toShortString(color):
        if isinstance(color, str):
            if color.lower() == Constant.SNOW:
                return "S"
            # compatibility
            return MagicColor.toShortString(MagicColor.fromName(color))
        return Color.fromByte(color).getShortName()

    @staticmethod
    def toLongString(color):
        return Color.fromByte(color).getName()

    @staticmethod
    def toSymbol(color):
        if isinstance(color, str):
            return MagicColor.toSymbol(MagicColor.fromName(color))
        return Color.fromByte(color).getSymbol()


class Color(ITranslatable):

    def __init__(self, name0, colormask0, shortName, basicLandType, label):
        self.name = name0
        self.colormask = colormask0
        self.shortName = shortName
        self.symbol = "{" + shortName + "}"
        self.basicLandType = basicLandType
        self.label = label

    @staticmethod
    def fromByte(color):
        if color == MagicColor.WHITE:
            return Color.WHITE
        elif color == MagicColor.BLUE:
            return Color.BLUE
        elif color == MagicColor.BLACK:
            return Color.BLACK
        elif color == MagicColor.RED:
            return Color.RED
        elif color == MagicColor.GREEN:
            return Color.GREEN
        else:
            return Color.COLORLESS

    @staticmethod
    def fromName(color):
        if color is None:
            return None
        c = color.lower()
        if c == Constant.WHITE:
            return Color.WHITE
        elif c == Constant.BLUE:
            return Color.BLUE
        elif c == Constant.BLACK:
            return Color.BLACK
        elif c == Constant.RED:
            return Color.RED
        elif c == Constant.GREEN:
            return Color.GREEN
        elif c == Constant.COLORLESS:
            return Color.COLORLESS
        else:
            return None

    def getName(self):
        return self.name

    def getShortName(self):
        return self.shortName

    def getBasicLandType(self):
        return self.basicLandType

    def getTranslatedName(self):
        return Localizer.getInstance().getMessage(self.label)

    def getColorMask(self):
        return self.colormask

    def getSymbol(self):
        return self.symbol


Color.WHITE = Color(Constant.WHITE, MagicColor.WHITE, "W", "Plains", "lblWhite")
Color.BLUE = Color(Constant.BLUE, MagicColor.BLUE, "U", "Island", "lblBlue")
Color.BLACK = Color(Constant.BLACK, MagicColor.BLACK, "B", "Swamp", "lblBlack")
Color.RED = Color(Constant.RED, MagicColor.RED, "R", "Mountain", "lblRed")
Color.GREEN = Color(Constant.GREEN, MagicColor.GREEN, "G", "Forest", "lblGreen")
Color.COLORLESS = Color(Constant.COLORLESS, MagicColor.COLORLESS, "C", None, "lblColorless")

MagicColor.Constant = Constant
MagicColor.Color = Color
```
