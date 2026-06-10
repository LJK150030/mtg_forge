---
aliases:
  - CardRequest
tags:
  - java/class
  - module/forge-core
  - pkg/forge/card
fqn: forge.card.CardDb.CardRequest
package: forge.card
module: forge-core
kind: Class
---

# CardRequest

**Package:** `forge.card` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class CardRequest {
        +String cardName
        +String edition
        +int artIndex
        +boolean isFoil
        +String collectorNumber
        +Map~String,String~ flags
        +isFoilCardName(String cardName) boolean
        +compose(String cardName, boolean isFoil) String
        +compose(String cardName, String setCode) String
        +compose(String cardName, String setCode, int artIndex) String
        +compose(String cardName, String setCode, String collectorNumber) String
        +compose(String cardName, String setCode, int artIndex, Map~String,String~ flags) String
        +compose(String cardName, String setCode, String collectorNumber, Map~String,String~ flags) String
        +compose(PaperCard card) String
        +compose(String cardName, String setCode, int artIndex, String collectorNumber) String
        -preprocessCollectorNumber(String collectorNumber) String
        -getFlagSegment(Map~String,String~ flags) String
        -isCollectorNumber(String s) boolean
        -isFlagSegment(String s) boolean
        -isArtIndex(String s) boolean
        -isSetCode(String s) boolean
        -fromPreferredArtEntry(String preferredArt, boolean isFoil) CardRequest
        +fromString(String reqInfo) CardRequest
        -parseRequestFlags(String flagText) Map~String,String~
        -CardRequest(String name, String edition, int artIndex, boolean isFoil, String collectorNumber, Map~String,String~ flags)
    }
    CardRequest ..> PaperCard : uses
```

## Relationships
**Uses:**
- [[forge.item.PaperCard|PaperCard]]

## Design Description

CardRequest is a static nested helper within `CardDb` that models a parsed card lookup specification â€” name, edition, art index, foil status, collector number, and arbitrary string flags â€” and defines the canonical serialization format that ties these attributes together. Its core responsibility is bidirectional translation between structured card identity and a single delimited request string: the overloaded `compose` methods build that string from individual fields or from a `PaperCard`, while `fromString` parses one back, heuristically classifying each segment (set code, art index, bracketed collector number, flag block) and applying fallbacks such as preferred-art lookup and a default art index.

The design favors a flexible, position-tolerant grammar over rigid ordering, using private predicate helpers (`isSetCode`, `isArtIndex`, `isCollectorNumber`) to disambiguate optional segments. A private constructor forces construction through these factory methods, keeping parsing logic centralized. It collaborates with `PaperCard`/`IPaperCard` for field defaults and conventions, and retains backward compatibility by accepting a legacy marked-colors flag form.

## Source
`forge-core/src/main/java/forge/card/CardDb.java` Ã¢â‚¬â€ declaration excerpt

```java
    public static class CardRequest {
        public String cardName;
        public String edition;
        public int artIndex;
        public boolean isFoil;
        public String collectorNumber;
        public Map<String, String> flags;

        private CardRequest(String name, String edition, int artIndex, boolean isFoil, String collectorNumber, Map<String, String> flags) {
            cardName = name;
            this.edition = edition;
            this.artIndex = artIndex;
            this.isFoil = isFoil;
            this.collectorNumber = collectorNumber;
            this.flags = flags;
        }

        public static boolean isFoilCardName(final String cardName){
            return cardName.trim().endsWith(foilSuffix);
        }

        public static String compose(String cardName, boolean isFoil){
            if (isFoil){
                return isFoilCardName(cardName) ? cardName : cardName+foilSuffix;
            }
            return isFoilCardName(cardName) ? cardName.substring(0, cardName.length() - foilSuffix.length()) : cardName;
        }

        public static String compose(String cardName, String setCode) {
            if(setCode == null || StringUtils.isBlank(setCode) || setCode.equals(CardEdition.UNKNOWN_CODE))
                setCode = "";
            cardName = cardName != null ? cardName : "";
            if (cardName.indexOf(NameSetSeparator) != -1)
                // If cardName is another RequestString, just get card name and forget about the rest.
                cardName = CardRequest.fromString(cardName).cardName;
            return cardName + NameSetSeparator + setCode;
        }

        public static String compose(String cardName, String setCode, int artIndex) {
            String requestInfo = compose(cardName, setCode);
            artIndex = Math.max(artIndex, IPaperCard.DEFAULT_ART_INDEX);
            return requestInfo + NameSetSeparator + artIndex;
        }

        public static String compose(String cardName, String setCode, String collectorNumber) {
            String requestInfo = compose(cardName, setCode);
            // CollectorNumber will be wrapped in square brackets
            collectorNumber = preprocessCollectorNumber(collectorNumber);
            return requestInfo + NameSetSeparator + collectorNumber;
        }

        public static String compose(String cardName, String setCode, int artIndex, Map<String, String> flags) {
            String requestInfo = compose(cardName, setCode);
            artIndex = Math.max(artIndex, IPaperCard.DEFAULT_ART_INDEX);
            if(flags == null)
                return requestInfo + NameSetSeparator + artIndex;
            return requestInfo + NameSetSeparator + artIndex + getFlagSegment(flags);
        }

        public static String compose(String cardName, String setCode, String collectorNumber, Map<String, String> flags) {
            String requestInfo = compose(cardName, setCode);
            collectorNumber = preprocessCollectorNumber(collectorNumber);
            if(flags == null || flags.isEmpty())
                return requestInfo + NameSetSeparator + collectorNumber;
            return requestInfo + NameSetSeparator + collectorNumber + getFlagSegment(flags);
        }

        public static String compose(PaperCard card) {
            String name = compose(card.getName(), card.isFoil());
            return compose(name, card.getEdition(), card.getCollectorNumber(), card.getMarkedFlags().toMap());
        }

        public static String compose(String cardName, String setCode, int artIndex, String collectorNumber) {
            String requestInfo = compose(cardName, setCode, artIndex);
            // CollectorNumber will be wrapped in square brackets
            collectorNumber = preprocessCollectorNumber(collectorNumber);
            return requestInfo + NameSetSeparator + collectorNumber;
        }

        private static String preprocessCollectorNumber(String collectorNumber) {
            if (collectorNumber == null)
                return "";
            collectorNumber = collectorNumber.trim();
            if (!collectorNumber.startsWith("["))
                collectorNumber = "[" + collectorNumber;
            if (!collectorNumber.endsWith("]"))
                collectorNumber += "]";
            return collectorNumber;
        }

        private static String getFlagSegment(Map<String, String> flags) {
            if(flags == null)
                return "";
            String flagText = flags.entrySet().stream()
                    .map(e -> e.getKey() + "=" + e.getValue())
                    .collect(Collectors.joining(FlagSeparator));
            return NameSetSeparator + FlagPrefix + "{" + flagText + "}";
        }

        private static boolean isCollectorNumber(String s) {
            return s.startsWith("[") && s.endsWith("]");
        }

        private static boolean isFlagSegment(String s) {
            return s.startsWith(FlagPrefix);
        }

        private static boolean isArtIndex(String s) {
            return StringUtils.isNumeric(s) && s.length() <= 2; // only artIndex between 1-99
        }

        private static boolean isSetCode(String s) {
            return !StringUtils.isNumeric(s);
        }

        private static CardRequest fromPreferredArtEntry(String preferredArt, boolean isFoil){
            // Preferred Art Entry are supposed to be cardName|setCode|artIndex only
            String[] info = TextUtil.split(preferredArt, NameSetSeparator);
            if (info.length != 3)
                return null;
            try {
                String cardName = info[0];
                String setCode = info[1];
                int artIndex = Integer.parseInt(info[2]);
                return new CardRequest(cardName, setCode, artIndex, isFoil, IPaperCard.NO_COLLECTOR_NUMBER, null);
            } catch (NumberFormatException ex){ return null; }
        }

        public static CardRequest fromString(String reqInfo) {
            if (reqInfo == null)
                return null;

            String[] info = TextUtil.split(reqInfo, NameSetSeparator);
            int index = 1;
            String cardName = info[0];
            boolean isFoil = false;
            int artIndex = IPaperCard.NO_ART_INDEX;
            String setCode = null;
            String collectorNumber = IPaperCard.NO_COLLECTOR_NUMBER;
            Map<String, String> flags = null;
            if (isFoilCardName(cardName)) {
                cardName = cardName.substring(0, cardName.length() - foilSuffix.length());
                isFoil = true;
            }

            if(info.length > index && isSetCode(info[index])) {
                setCode = info[index];
                index++;
            }
            if(info.length > index && isArtIndex(info[index].replace(ImageKeys.BACKFACE_POSTFIX, ""))) {
                artIndex = Integer.parseInt(info[index].replace(ImageKeys.BACKFACE_POSTFIX, ""));
                index++;
            }
            if(info.length > index && isCollectorNumber(info[index])) {
                collectorNumber = info[index].substring(1, info[index].length() - 1);
                index++;
            }
            if (info.length > index && isFlagSegment(info[index])) {
                String flagText = info[index].substring(FlagPrefix.length());
                flags = parseRequestFlags(flagText);
            }

            if (CardEdition.UNKNOWN_CODE.equals(setCode)) {  // ???
                setCode = null;
            }
            if (setCode == null) {
                String preferredArt = artPrefs.get(cardName);
                if (preferredArt != null) { //account for preferred art if needed
                    CardRequest request = fromPreferredArtEntry(preferredArt, isFoil);
                    if (request != null)  // otherwise, simply discard it and go on.
                        return request;
                    System.err.printf("[LOG]: Faulty Entry in Preferred Art for Card %s - Please check!%n", cardName);
                }
            }
            // finally, check whether any between artIndex and CollectorNumber has been set
            if (collectorNumber.equals(IPaperCard.NO_COLLECTOR_NUMBER) && artIndex == IPaperCard.NO_ART_INDEX)
                artIndex = IPaperCard.DEFAULT_ART_INDEX;
            return new CardRequest(cardName, setCode, artIndex, isFoil, collectorNumber, flags);
        }

        private static Map<String, String> parseRequestFlags(String flagText) {
            flagText = flagText.trim();
            if(flagText.isEmpty())
                return null;
            if(!flagText.startsWith("{")) {
                //Legacy form for marked colors. They'll be of the form "W#B#R"
                Map<String, String> flags = new HashMap<>();
                String normalizedColorString = ColorSet.fromNames(flagText.split(FlagPrefix)).toString();
                flags.put("markedColors", String.join("", normalizedColorString));
                return flags;
            }
            flagText = flagText.substring(1, flagText.length() - 1); //Trim the braces.
            //List of flags, a series of "key=value" text broken up by tabs.
            return Arrays.stream(flagText.split(FlagSeparator))
                    .map(f -> f.split("=", 2))
                    .filter(f -> f.length > 0)
                    .collect(Collectors.toMap(
                            entry -> entry[0],
                            entry -> entry.length > 1 ? entry[1] : "true" //If there's no '=' in the entry, treat it as a boolean flag.
                    ));
        }
    }
```

## Python
`forge/card/CardDb/CardRequest.py`

```python
from forge.item.PaperCard import PaperCard
from forge.item.IPaperCard import IPaperCard
from forge.card.CardEdition import CardEdition
from forge.card.ColorSet import ColorSet
from forge.ImageKeys import ImageKeys
from forge.util.TextUtil import TextUtil
from forge.card.CardDb import CardDb

import sys


def _isBlank(s):
    return s is None or len(s.strip()) == 0


def _isNumeric(s):
    return s is not None and len(s) > 0 and s.isdigit()


class CardRequest:
    cardName: str
    edition: str
    artIndex: int
    isFoil: bool
    collectorNumber: str
    flags: dict[str, str]

    def __init__(self, name, edition, artIndex, isFoil, collectorNumber, flags):
        self.cardName = name
        self.edition = edition
        self.artIndex = artIndex
        self.isFoil = isFoil
        self.collectorNumber = collectorNumber
        self.flags = flags

    @staticmethod
    def isFoilCardName(cardName):
        return cardName.strip().endswith(CardDb.foilSuffix)

    @staticmethod
    def compose(*args):
        # compose(PaperCard card)
        if len(args) == 1:
            card = args[0]
            name = CardRequest.compose(card.getName(), card.isFoil())
            return CardRequest.compose(name, card.getEdition(), card.getCollectorNumber(), card.getMarkedFlags().toMap())

        if len(args) == 2:
            cardName, second = args
            # compose(String cardName, boolean isFoil)
            if isinstance(second, bool):
                isFoil = second
                if isFoil:
                    return cardName if CardRequest.isFoilCardName(cardName) else cardName + CardDb.foilSuffix
                return cardName[0:len(cardName) - len(CardDb.foilSuffix)] if CardRequest.isFoilCardName(cardName) else cardName
            # compose(String cardName, String setCode)
            setCode = second
            if setCode is None or _isBlank(setCode) or setCode == CardEdition.UNKNOWN_CODE:
                setCode = ""
            cardName = cardName if cardName is not None else ""
            if cardName.find(CardDb.NameSetSeparator) != -1:
                # If cardName is another RequestString, just get card name and forget about the rest.
                cardName = CardRequest.fromString(cardName).cardName
            return cardName + CardDb.NameSetSeparator + setCode

        if len(args) == 3:
            cardName, setCode, third = args
            # compose(String cardName, String setCode, int artIndex)
            if isinstance(third, int) and not isinstance(third, bool):
                artIndex = third
                requestInfo = CardRequest.compose(cardName, setCode)
                artIndex = max(artIndex, IPaperCard.DEFAULT_ART_INDEX)
                return requestInfo + CardDb.NameSetSeparator + str(artIndex)
            # compose(String cardName, String setCode, String collectorNumber)
            collectorNumber = third
            requestInfo = CardRequest.compose(cardName, setCode)
            # CollectorNumber will be wrapped in square brackets
            collectorNumber = CardRequest.preprocessCollectorNumber(collectorNumber)
            return requestInfo + CardDb.NameSetSeparator + collectorNumber

        if len(args) == 4:
            cardName, setCode, third, fourth = args
            if isinstance(third, int) and not isinstance(third, bool):
                artIndex = third
                # compose(String cardName, String setCode, int artIndex, Map<String,String> flags)
                if isinstance(fourth, dict) or fourth is None:
                    flags = fourth
                    requestInfo = CardRequest.compose(cardName, setCode)
                    artIndex = max(artIndex, IPaperCard.DEFAULT_ART_INDEX)
                    if flags is None:
                        return requestInfo + CardDb.NameSetSeparator + str(artIndex)
                    return requestInfo + CardDb.NameSetSeparator + str(artIndex) + CardRequest.getFlagSegment(flags)
                # compose(String cardName, String setCode, int artIndex, String collectorNumber)
                collectorNumber = fourth
                requestInfo = CardRequest.compose(cardName, setCode, artIndex)
                # CollectorNumber will be wrapped in square brackets
                collectorNumber = CardRequest.preprocessCollectorNumber(collectorNumber)
                return requestInfo + CardDb.NameSetSeparator + collectorNumber
            # compose(String cardName, String setCode, String collectorNumber, Map<String,String> flags)
            collectorNumber = third
            flags = fourth
            requestInfo = CardRequest.compose(cardName, setCode)
            collectorNumber = CardRequest.preprocessCollectorNumber(collectorNumber)
            if flags is None or len(flags) == 0:
                return requestInfo + CardDb.NameSetSeparator + collectorNumber
            return requestInfo + CardDb.NameSetSeparator + collectorNumber + CardRequest.getFlagSegment(flags)

        raise TypeError("Invalid compose arguments")

    @staticmethod
    def preprocessCollectorNumber(collectorNumber):
        if collectorNumber is None:
            return ""
        collectorNumber = collectorNumber.strip()
        if not collectorNumber.startswith("["):
            collectorNumber = "[" + collectorNumber
        if not collectorNumber.endswith("]"):
            collectorNumber += "]"
        return collectorNumber

    @staticmethod
    def getFlagSegment(flags):
        if flags is None:
            return ""
        flagText = CardDb.FlagSeparator.join(k + "=" + v for k, v in flags.items())
        return CardDb.NameSetSeparator + CardDb.FlagPrefix + "{" + flagText + "}"

    @staticmethod
    def isCollectorNumber(s):
        return s.startswith("[") and s.endswith("]")

    @staticmethod
    def isFlagSegment(s):
        return s.startswith(CardDb.FlagPrefix)

    @staticmethod
    def isArtIndex(s):
        return _isNumeric(s) and len(s) <= 2  # only artIndex between 1-99

    @staticmethod
    def isSetCode(s):
        return not _isNumeric(s)

    @staticmethod
    def fromPreferredArtEntry(preferredArt, isFoil):
        # Preferred Art Entry are supposed to be cardName|setCode|artIndex only
        info = TextUtil.split(preferredArt, CardDb.NameSetSeparator)
        if len(info) != 3:
            return None
        try:
            cardName = info[0]
            setCode = info[1]
            artIndex = int(info[2])
            return CardRequest(cardName, setCode, artIndex, isFoil, IPaperCard.NO_COLLECTOR_NUMBER, None)
        except ValueError:
            return None

    @staticmethod
    def fromString(reqInfo):
        if reqInfo is None:
            return None

        info = TextUtil.split(reqInfo, CardDb.NameSetSeparator)
        index = 1
        cardName = info[0]
        isFoil = False
        artIndex = IPaperCard.NO_ART_INDEX
        setCode = None
        collectorNumber = IPaperCard.NO_COLLECTOR_NUMBER
        flags = None
        if CardRequest.isFoilCardName(cardName):
            cardName = cardName[0:len(cardName) - len(CardDb.foilSuffix)]
            isFoil = True

        if len(info) > index and CardRequest.isSetCode(info[index]):
            setCode = info[index]
            index += 1
        if len(info) > index and CardRequest.isArtIndex(info[index].replace(ImageKeys.BACKFACE_POSTFIX, "")):
            artIndex = int(info[index].replace(ImageKeys.BACKFACE_POSTFIX, ""))
            index += 1
        if len(info) > index and CardRequest.isCollectorNumber(info[index]):
            collectorNumber = info[index][1:len(info[index]) - 1]
            index += 1
        if len(info) > index and CardRequest.isFlagSegment(info[index]):
            flagText = info[index][len(CardDb.FlagPrefix):]
            flags = CardRequest.parseRequestFlags(flagText)

        if CardEdition.UNKNOWN_CODE == setCode:  # ???
            setCode = None
        if setCode is None:
            preferredArt = CardDb.artPrefs.get(cardName)
            if preferredArt is not None:  # account for preferred art if needed
                request = CardRequest.fromPreferredArtEntry(preferredArt, isFoil)
                if request is not None:  # otherwise, simply discard it and go on.
                    return request
                sys.stderr.write("[LOG]: Faulty Entry in Preferred Art for Card %s - Please check!\n" % cardName)
        # finally, check whether any between artIndex and CollectorNumber has been set
        if collectorNumber == IPaperCard.NO_COLLECTOR_NUMBER and artIndex == IPaperCard.NO_ART_INDEX:
            artIndex = IPaperCard.DEFAULT_ART_INDEX
        return CardRequest(cardName, setCode, artIndex, isFoil, collectorNumber, flags)

    @staticmethod
    def parseRequestFlags(flagText):
        flagText = flagText.strip()
        if flagText == "":
            return None
        if not flagText.startswith("{"):
            # Legacy form for marked colors. They'll be of the form "W#B#R"
            flags = {}
            normalizedColorString = ColorSet.fromNames(flagText.split(CardDb.FlagPrefix)).toString()
            flags["markedColors"] = "".join(normalizedColorString)
            return flags
        flagText = flagText[1:len(flagText) - 1]  # Trim the braces.
        # List of flags, a series of "key=value" text broken up by tabs.
        result = {}
        for f in flagText.split(CardDb.FlagSeparator):
            entry = f.split("=", 1)
            if len(entry) > 0:
                # If there's no '=' in the entry, treat it as a boolean flag.
                result[entry[0]] = entry[1] if len(entry) > 1 else "true"
        return result
```
