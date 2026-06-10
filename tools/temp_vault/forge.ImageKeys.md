---
aliases:
  - ImageKeys
tags:
  - java/class
  - module/forge-core
  - pkg/forge
fqn: forge.ImageKeys
package: forge
module: forge-core
kind: Class
---

# ImageKeys

**Package:** `forge` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class ImageKeys {
        +String CARD_PREFIX
        +String TOKEN_PREFIX
        +String ICON_PREFIX
        +String BOOSTER_PREFIX
        +String FATPACK_PREFIX
        +String BOOSTERBOX_PREFIX
        +String PRECON_PREFIX
        +String TOURNAMENTPACK_PREFIX
        +String ADVENTURECARD_PREFIX
        +String HIDDEN_CARD
        +String MORPH_IMAGE
        +String MANIFEST_IMAGE
        +String CLOAKED_IMAGE
        +String FORETELL_IMAGE
        +String BLESSING_IMAGE
        +String INITIATIVE_IMAGE
        +String MONARCH_IMAGE
        +String THE_RING_IMAGE
        +String RADIATION_IMAGE
        +String SPEED_IMAGE
        +String MAX_SPEED_IMAGE
        +String ADVENTURE_IMAGE
        +String BACKFACE_POSTFIX
        +String SPECFACE_W
        +String SPECFACE_U
        +String SPECFACE_B
        +String SPECFACE_R
        +String SPECFACE_G
        -String CACHE_CARD_PICS_DIR
        -String CACHE_TOKEN_PICS_DIR
        -String CACHE_ICON_PICS_DIR
        -String CACHE_BOOSTER_PICS_DIR
        -String CACHE_FATPACK_PICS_DIR
        -String CACHE_BOOSTERBOX_PICS_DIR
        -String CACHE_PRECON_PICS_DIR
        -String CACHE_TOURNAMENTPACK_PICS_DIR
        +String ADVENTURE_CARD_PICS_DIR
        -Map~String,String~ CACHE_CARD_PICS_SUBDIR
        -Map~String,Boolean~ editionImageLookup
        -Map~String,Set~ editionAlias
        -Set~String~ toFind
        -boolean isLibGDXPort
        -String[] FILE_EXTENSIONS
        -Map~String,File~ cachedCards
        +HashSet~String~ missingCards
        ~HashMap~String,HashSet~ cachedContent
        +setIsLibGDXPort(boolean value) void
        +initializeDirs(String cards, Map~String,String~ cardsSub, String tokens, String icons, String boosters, String fatPacks, String boosterBoxes, String precons, String tournamentPacks) void
        +getTokenKey(String tokenName) String
        +getTokenImageName(String tokenKey) String
        +clearMissingCards() void
        +getCachedCardsFile(String key) File
        +getImageFile(String key) File
        +getSetFolder(String edition) String
        +hasSetLookup(String filename) boolean
        +setLookUpFile(String filename, String fullborderFile) File
        -findFile(String dir, String filename) File
        +hasImage(PaperCard pc) boolean
        +hasImage(PaperCard pc, boolean update) boolean
        -hitCache(HashSet~String~ cache, String filename) boolean
        -ImageKeys()
    }
    ImageKeys ..> CardEdition : uses
    ImageKeys ..> PaperCard : uses
```

## Relationships
**Uses:**
- [[forge.card.CardEdition|CardEdition]]
- [[forge.item.PaperCard|PaperCard]]

## Design Description

ImageKeys is a final, non-instantiable utility class in the forge-core module that centralizes the resolution of Magic: The Gathering image assets to on-disk files. It defines the canonical set of key prefixes (cards, tokens, icons, boosters, etc.) and special-state image names, holds the configured cache directories, and translates an image key into a concrete File through getImageFile, applying an extensive cascade of fallback strategiesâ€”filename casing fixes, full/fullborder variants, art-index reduction, set-folder aliasing, and asynchronous set lookups.

As a purely static helper it exposes no inheritance hierarchy, instead collaborating with PaperCard (via hasImage) and CardEdition to determine whether a card's edition has artwork. Notable design intent includes aggressive in-memory caching (cachedCards, cachedContent, editionImageLookup) sized for large collections, tracking of missing and in-flight files to avoid redundant disk hits, and a libGDX-port flag that toggles missing-card recording for mobile compatibility.

## Source
`forge-core/src/main/java/forge/ImageKeys.java`

```java
package forge;

import forge.card.CardEdition;
import forge.item.PaperCard;
import forge.util.FileUtil;
import forge.util.TextUtil;
import forge.util.ThreadUtil;
import org.apache.commons.lang3.StringUtils;

import java.io.File;
import java.util.*;

public final class ImageKeys {
    public static final String CARD_PREFIX           = "c:";
    public static final String TOKEN_PREFIX          = "t:";
    public static final String ICON_PREFIX           = "i:";
    public static final String BOOSTER_PREFIX        = "b:";
    public static final String FATPACK_PREFIX        = "f:";
    public static final String BOOSTERBOX_PREFIX     = "x:";
    public static final String PRECON_PREFIX         = "p:";
    public static final String TOURNAMENTPACK_PREFIX = "o:";
    public static final String ADVENTURECARD_PREFIX = "a:";

    public static final String HIDDEN_CARD           = "hidden";
    public static final String MORPH_IMAGE           = "morph";
    public static final String MANIFEST_IMAGE        = "manifest";
    public static final String CLOAKED_IMAGE         = "cloaked";
    public static final String FORETELL_IMAGE        = "foretell";
    public static final String BLESSING_IMAGE        = "blessing";
    public static final String INITIATIVE_IMAGE      = "initiative";
    public static final String MONARCH_IMAGE         = "monarch";
    public static final String THE_RING_IMAGE        = "the_ring";
    public static final String RADIATION_IMAGE       = "radiation";
    public static final String SPEED_IMAGE           = "speed";
    public static final String MAX_SPEED_IMAGE       = "max_speed";
    public static final String ADVENTURE_IMAGE       = "adventure";

    public static final String BACKFACE_POSTFIX  = "$alt";
    public static final String SPECFACE_W = "$wspec";
    public static final String SPECFACE_U = "$uspec";
    public static final String SPECFACE_B = "$bspec";
    public static final String SPECFACE_R = "$rspec";
    public static final String SPECFACE_G = "$gspec";

    private static String CACHE_CARD_PICS_DIR, CACHE_TOKEN_PICS_DIR, CACHE_ICON_PICS_DIR, CACHE_BOOSTER_PICS_DIR,
        CACHE_FATPACK_PICS_DIR, CACHE_BOOSTERBOX_PICS_DIR, CACHE_PRECON_PICS_DIR, CACHE_TOURNAMENTPACK_PICS_DIR;
    public static String ADVENTURE_CARD_PICS_DIR;
    private static Map<String, String> CACHE_CARD_PICS_SUBDIR;

    private static Map<String, Boolean> editionImageLookup = new HashMap<>();

    private static Map<String, Set<String>> editionAlias = new HashMap<>();
    private static Set<String> toFind = new HashSet<>();

    private static boolean isLibGDXPort = false;

    /**
     * Private constructor to prevent instantiation.
     */
    private ImageKeys() {
    }

    public static void setIsLibGDXPort(boolean value) {
        isLibGDXPort = value;
    }
    public static void initializeDirs(String cards, Map<String, String> cardsSub, String tokens, String icons, String boosters,
            String fatPacks, String boosterBoxes, String precons, String tournamentPacks) {
        CACHE_CARD_PICS_DIR = cards;
        CACHE_CARD_PICS_SUBDIR = cardsSub;
        CACHE_TOKEN_PICS_DIR = tokens;
        CACHE_ICON_PICS_DIR = icons;
        CACHE_BOOSTER_PICS_DIR = boosters;
        CACHE_FATPACK_PICS_DIR = fatPacks;
        CACHE_BOOSTERBOX_PICS_DIR = boosterBoxes;
        CACHE_PRECON_PICS_DIR = precons;
        CACHE_TOURNAMENTPACK_PICS_DIR = tournamentPacks;
    }

    // image file extensions for various formats in order of likelihood
    // the last, empty, string is for keys that come in with an extension already in place
    private static final String[] FILE_EXTENSIONS = { ".jpg", ".png", "" };

    public static String getTokenKey(String tokenName) {
        return ImageKeys.TOKEN_PREFIX + tokenName;
    }

    public static String getTokenImageName(String tokenKey) {
        if (!tokenKey.startsWith(ImageKeys.TOKEN_PREFIX)) {
            return null;
        }
        return tokenKey.substring(ImageKeys.TOKEN_PREFIX.length());
    }

    private static final Map<String, File> cachedCards = new HashMap<>(50000);
    public static HashSet<String> missingCards = new HashSet<>();
    public static void clearMissingCards() {
        missingCards.clear();
    }
    public static File getCachedCardsFile(String key) {
        return cachedCards.get(key);
    }
    public static File getImageFile(String key) {
        if (StringUtils.isEmpty(key))
            return null;

        final String dir;
        final String filename;
        String[] tempdata = null;
        if (key.startsWith(ImageKeys.TOKEN_PREFIX)) {
            tempdata = key.substring(ImageKeys.TOKEN_PREFIX.length()).split("\\|");
            String tokenname = tempdata[0];
            if (tempdata.length > 1) {
                tokenname += "_" + tempdata[1];
            }
            if (tempdata.length > 2) {
                tokenname += "_" + tempdata[2];
            }
            filename = tokenname;

            dir = CACHE_TOKEN_PICS_DIR;
        } else if (key.startsWith(ImageKeys.ICON_PREFIX)) {
            filename = key.substring(ImageKeys.ICON_PREFIX.length());
            dir = CACHE_ICON_PICS_DIR;
        } else if (key.startsWith(ImageKeys.BOOSTER_PREFIX)) {
            filename = key.substring(ImageKeys.BOOSTER_PREFIX.length());
            dir = CACHE_BOOSTER_PICS_DIR;
        } else if (key.startsWith(ImageKeys.FATPACK_PREFIX)) {
            filename = key.substring(ImageKeys.FATPACK_PREFIX.length());
            dir = CACHE_FATPACK_PICS_DIR;
        } else if (key.startsWith(ImageKeys.BOOSTERBOX_PREFIX)) {
            filename = key.substring(ImageKeys.BOOSTERBOX_PREFIX.length());
            dir = CACHE_BOOSTERBOX_PICS_DIR;
        } else if (key.startsWith(ImageKeys.PRECON_PREFIX)) {
            filename = key.substring(ImageKeys.PRECON_PREFIX.length());
            dir = CACHE_PRECON_PICS_DIR;
        } else if (key.startsWith(ImageKeys.TOURNAMENTPACK_PREFIX)) {
            filename = key.substring(ImageKeys.TOURNAMENTPACK_PREFIX.length());
            dir = CACHE_TOURNAMENTPACK_PICS_DIR;
        } else if (key.startsWith(ImageKeys.ADVENTURECARD_PREFIX)) {
            filename = key.substring(ImageKeys.ADVENTURECARD_PREFIX.length());
            dir = ADVENTURE_CARD_PICS_DIR;
        }else {
            filename = key;
            dir = CACHE_CARD_PICS_DIR;
        }
        if (toFind.contains(filename))
            return null;
        if (missingCards.contains(filename))
            return null;

        File cachedFile = cachedCards.get(filename);
        if (cachedFile != null) {
            return cachedFile;
        } else {
            File file = findFile(dir, filename);
            if (file != null) {
                cachedCards.put(filename, file);
                return file;
            }
            if (dir.equals(CACHE_TOKEN_PICS_DIR)) {
                String setlessFilename = tempdata[0];
                String setCode = tempdata.length > 1 ? tempdata[1] : "";
                String collectorNumber = tempdata.length > 2 ? tempdata[2] : "";
                if (!setCode.isEmpty()) {
                    if (!collectorNumber.isEmpty()) {
                        file = findFile(dir, setCode + "/" + collectorNumber + "_" + setlessFilename);
                        if (file != null) {
                            cachedCards.put(filename, file);
                            return file;
                        }
                    }
                    file = findFile(dir, setCode + "/" + setlessFilename);
                    if (file != null) {
                        cachedCards.put(filename, file);
                        return file;
                    }
                }
                file = findFile(dir, setlessFilename);
                if (file != null) {
                    cachedCards.put(filename, file);
                    return file;
                }
            }

            // AE -> Ae and Ae -> AE for older cards with different file names
            // on case-sensitive file systems
            if (filename.contains("Ae")) {
                file = findFile(dir, TextUtil.fastReplace(filename, "Ae", "AE"));
                if (file != null) {
                    cachedCards.put(filename, file);
                    return file;
                }
            } else if (filename.contains("AE")) {
                file = findFile(dir, TextUtil.fastReplace(filename, "AE", "Ae"));
                if (file != null) {
                    cachedCards.put(filename, file);
                    return file;
                }
            }
            //try fullborder...
            if (filename.contains(".full")) {
                String fullborderFile = TextUtil.fastReplace(filename, ".full", ".fullborder");
                file = findFile(dir, fullborderFile);
                if (file != null) {
                    cachedCards.put(filename, file);
                    return file;
                }
                // if there's a 1st art variant try without it for .fullborder images
                file = findFile(dir, TextUtil.fastReplace(fullborderFile, "1.fullborder", ".fullborder"));
                if (file != null) {
                    cachedCards.put(filename, file);
                    return file;
                }
                // if there's an art variant try without it for .full images
                file = findFile(dir, filename.replaceAll("[0-9].full",".full"));
                if (file != null) {
                    cachedCards.put(filename, file);
                    return file;
                }
                //setlookup
                if (hasSetLookup(filename)) {
                    toFind.add(filename);
                    try {
                        ThreadUtil.getServicePool().submit(() -> {
                            File f = setLookUpFile(filename, fullborderFile);
                            if (f != null)
                                cachedCards.put(filename, f);
                            else //is null
                                missingCards.add(filename);
                            toFind.remove(filename);
                        });
                    } catch (Exception e) {
                        toFind.remove(filename);
                    }
                }
                String setCode = filename.contains("/") ? filename.substring(0, filename.indexOf("/")) : "";
                if (!setCode.isEmpty() && editionAlias.containsKey(setCode)) {
                    for (String alias : editionAlias.get(setCode)) {
                        file = findFile(dir, TextUtil.fastReplace(filename, setCode + "/", alias + "/"));
                        if (file != null) {
                            cachedCards.put(filename, file);
                            return file;
                        }
                        file = findFile(dir, TextUtil.fastReplace(fullborderFile, setCode + "/", alias + "/"));
                        if (file != null) {
                            cachedCards.put(filename, file);
                            return file;
                        }
                    }
                }
            }
            //if an image, like phenomenon or planes is missing .full in their filenames but you have an existing images that have .full/.fullborder
            if (!filename.contains(".full")) {
                file = findFile(dir, TextUtil.addSuffix(filename,".full"));
                if (file != null) {
                    cachedCards.put(filename, file);
                    return file;
                }
                file = findFile(dir, TextUtil.addSuffix(filename,".fullborder"));
                if (file != null) {
                    cachedCards.put(filename, file);
                    return file;
                }
            }
            if (filename.contains("/")) {
                String setlessFilename = filename.substring(filename.indexOf('/') + 1);
                file = findFile(dir, setlessFilename);
                if (file != null) {
                    cachedCards.put(filename, file);
                    return file;
                }

                if (setlessFilename.contains(".full")) {
                    //try fullborder
                    String fullborderFile = TextUtil.fastReplace(setlessFilename, ".full", ".fullborder");
                    file = findFile(dir, fullborderFile);
                    if (file != null) {
                        cachedCards.put(filename, file);
                        return file;
                    }
                    // try lowering the art index to the minimum for regular cards
                    file = findFile(dir, setlessFilename.replaceAll("[0-9]*[.]full", "1.full"));
                    if (file != null) {
                        cachedCards.put(filename, file);
                        return file;
                    }
                }
                //lookup other cards like planechase/phenomenon
                if (!filename.contains(".full")) {
                    String newFilename = TextUtil.addSuffix(filename,".full");
                    file = findFile(dir, newFilename);
                    if (file != null) {
                        cachedCards.put(filename, file);
                        return file;
                    }
                    String newFilename2 = TextUtil.addSuffix(filename,".fullborder");
                    file = findFile(dir, newFilename2);
                    if (file != null) {
                        cachedCards.put(filename, file);
                        return file;
                    }
                    String setCode = filename.substring(0, filename.indexOf("/"));
                    if (!setCode.isEmpty() && editionAlias.containsKey(setCode)) {
                        for (String alias : editionAlias.get(setCode)) {
                            file = findFile(dir, TextUtil.fastReplace(newFilename, setCode + "/", alias + "/"));
                            if (file != null) {
                                cachedCards.put(filename, file);
                                return file;
                            }
                            file = findFile(dir, TextUtil.fastReplace(newFilename2, setCode + "/", alias + "/"));
                            if (file != null) {
                                cachedCards.put(filename, file);
                                return file;
                            }
                        }
                    }
                }
            }
        }

        // System.out.println("File not found, no image created: " + key);
        // add missing cards - disable for desktop version for compatibility reasons with autodownloader
        if (isLibGDXPort && !hasSetLookup(filename)) //missing cards with setlookup is handled differently
            missingCards.add(filename);
        return null;
    }

    public static String getSetFolder(String edition) {
        return  !CACHE_CARD_PICS_SUBDIR.containsKey(edition)
                ? StaticData.instance().getEditions().getCode2ByCode(edition) // by default 2-letter codes from MWS are used
                : CACHE_CARD_PICS_SUBDIR.get(edition); // may use custom paths though
    }
    public static boolean hasSetLookup(String filename) {
        if (filename == null)
            return false;
        if (!StaticData.instance().getSetLookup().isEmpty()) {
            return StaticData.instance().getSetLookup().keySet().stream().anyMatch(filename::startsWith);
        }

        return false;
    }
    public static File setLookUpFile(String filename, String fullborderFile) {
        if (!StaticData.instance().getSetLookup().isEmpty()) {
            for (String setKey : StaticData.instance().getSetLookup().keySet()) {
                if (filename.startsWith(setKey)) {
                    for (String setLookup : StaticData.instance().getSetLookup().get(setKey)) {
                        String lookupDirectory = CACHE_CARD_PICS_DIR + setLookup;
                        File f = new File(lookupDirectory);
                        if (f.exists() && f.isDirectory()) {
                            for (String ext : FILE_EXTENSIONS) {
                                if (ext.isEmpty())
                                    continue;
                                File placeholder;
                                String fb1 = fullborderFile.replace(setKey+"/","")+ext;
                                placeholder = new File(lookupDirectory+"/"+fb1);
                                if (placeholder.exists()) {
                                    return placeholder;
                                }
                                String fb2 = fullborderFile.replace(setKey+"/","").replaceAll("[0-9]*.fullborder", "1.fullborder")+ext;
                                placeholder = new File(lookupDirectory+"/"+fb2);
                                if (placeholder.exists()) {
                                    return placeholder;
                                }
                                String f1 = filename.replace(setKey+"/","")+ext;
                                placeholder = new File(lookupDirectory+"/"+f1);
                                if (placeholder.exists()) {
                                    return placeholder;
                                }
                                String f2 = filename.replace(setKey+"/","").replaceAll("[0-9]*.full", "1.full")+ext;
                                placeholder = new File(lookupDirectory+"/"+f2);
                                if (placeholder.exists()) {
                                    return placeholder;
                                }
                            }
                        }
                    }
                }
            }
        }
        return null;
    }
    private static File findFile(String dir, String filename) {
        if (dir.equals(CACHE_CARD_PICS_DIR)) {
            for (String ext : FILE_EXTENSIONS) {
                if (ext.isEmpty())
                    continue;

                File f = new File(dir, filename + ext);
                if (f.exists()) {
                    return f;
                }
            }
        } else {
            //old method for tokens and others
            for (String ext : FILE_EXTENSIONS) {
                File file = new File(dir, filename + ext);
                if (file.exists()) {
                    if (file.isDirectory()) {
                        file.delete();
                        continue;
                    }
                    return file;
                }
            }
        }
        return null;
    }

    //shortcut for determining if a card image exists for a given card
    //should only be called from PaperCard.hasImage()
    static HashMap<String, HashSet<String>> cachedContent=new HashMap<>(50000);
    public static boolean hasImage(PaperCard pc) {
        return hasImage(pc, false);
    }
    public static boolean hasImage(PaperCard pc, boolean update) {
        Boolean editionHasImage = editionImageLookup.get(pc.getEdition());
        if (editionHasImage == null) {
            String setFolder = getSetFolder(pc.getEdition());
            CardEdition ed = StaticData.instance().getEditions().get(setFolder);
            if (ed != null && !editionAlias.containsKey(setFolder)) {
                String alias = ed.getAlias();
                Set<String> aliasSet = new HashSet<>();
                if (alias != null) {
                    if (!alias.equalsIgnoreCase(setFolder))
                        aliasSet.add(alias);
                }
                String code = ed.getCode();
                if (code != null) {
                    if (!code.equalsIgnoreCase(setFolder))
                        aliasSet.add(code);
                }
                if (!aliasSet.isEmpty())
                    editionAlias.put(setFolder, aliasSet);
            }
            editionHasImage = FileUtil.isDirectoryWithFiles(CACHE_CARD_PICS_DIR + setFolder);
            editionImageLookup.put(pc.getEdition(), editionHasImage);
            if (editionHasImage) {
                File f = new File(CACHE_CARD_PICS_DIR + setFolder);  // no need to check this, otherwise editionHasImage would be false!
                HashSet<String> setFolderContent = new HashSet<>();
                for (String filename : Arrays.asList(f.list())) {
                    // TODO: should this use FILE_EXTENSIONS ?
                    if (!filename.endsWith(".jpg") && !filename.endsWith(".png"))
                        continue;  // not image - not interested
                    setFolderContent.add(filename.split("\\.")[0]);  // get rid of any full or fullborder
                    //preload cachedCards at startUp
                    String key = setFolder + "/" + filename.replace(".fullborder", ".full").replace(".jpg", "").replace(".png", "");
                    File value = new File(CACHE_CARD_PICS_DIR + setFolder + "/" + filename);
                    cachedCards.put(key, value);
                }
                cachedContent.put(setFolder, setFolderContent);
            }
        }
        String[] keyParts = StringUtils.split(pc.getCardImageKey(), "//");
        if (keyParts.length != 2)
            return false;
        if (update && editionHasImage) {
            try {
                cachedContent.get(getSetFolder(pc.getEdition())).add(pc.getName());
            } catch (Exception e) {
                System.err.println(e);
            }
        }
        HashSet<String> content = cachedContent.getOrDefault(keyParts[0], null);
        //avoid checking for file if edition doesn't have any images
        return editionHasImage && hitCache(content, keyParts[1]);
    }

    private static boolean hitCache(HashSet<String> cache, String filename) {
        if (cache == null || cache.isEmpty())
            return false;
        final String keyPrefix = filename.split("\\.")[0];
        return cache.contains(keyPrefix);
    }
}
```

## Python
`forge/ImageKeys.py`

```python
from forge.card.CardEdition import CardEdition
from forge.item.PaperCard import PaperCard
from forge.util.FileUtil import FileUtil
from forge.util.TextUtil import TextUtil
from forge.util.ThreadUtil import ThreadUtil
from forge.StaticData import StaticData

import os
import re
import sys


class ImageKeys:
    CARD_PREFIX           = "c:"
    TOKEN_PREFIX          = "t:"
    ICON_PREFIX           = "i:"
    BOOSTER_PREFIX        = "b:"
    FATPACK_PREFIX        = "f:"
    BOOSTERBOX_PREFIX     = "x:"
    PRECON_PREFIX         = "p:"
    TOURNAMENTPACK_PREFIX = "o:"
    ADVENTURECARD_PREFIX  = "a:"

    HIDDEN_CARD           = "hidden"
    MORPH_IMAGE           = "morph"
    MANIFEST_IMAGE        = "manifest"
    CLOAKED_IMAGE         = "cloaked"
    FORETELL_IMAGE        = "foretell"
    BLESSING_IMAGE        = "blessing"
    INITIATIVE_IMAGE      = "initiative"
    MONARCH_IMAGE         = "monarch"
    THE_RING_IMAGE        = "the_ring"
    RADIATION_IMAGE       = "radiation"
    SPEED_IMAGE           = "speed"
    MAX_SPEED_IMAGE       = "max_speed"
    ADVENTURE_IMAGE       = "adventure"

    BACKFACE_POSTFIX = "$alt"
    SPECFACE_W = "$wspec"
    SPECFACE_U = "$uspec"
    SPECFACE_B = "$bspec"
    SPECFACE_R = "$rspec"
    SPECFACE_G = "$gspec"

    CACHE_CARD_PICS_DIR = None
    CACHE_TOKEN_PICS_DIR = None
    CACHE_ICON_PICS_DIR = None
    CACHE_BOOSTER_PICS_DIR = None
    CACHE_FATPACK_PICS_DIR = None
    CACHE_BOOSTERBOX_PICS_DIR = None
    CACHE_PRECON_PICS_DIR = None
    CACHE_TOURNAMENTPACK_PICS_DIR = None
    ADVENTURE_CARD_PICS_DIR = None
    CACHE_CARD_PICS_SUBDIR = None

    editionImageLookup = {}

    editionAlias = {}
    toFind = set()

    isLibGDXPort = False

    def __init__(self):
        """
        Private constructor to prevent instantiation.
        """
        pass

    @staticmethod
    def setIsLibGDXPort(value):
        ImageKeys.isLibGDXPort = value

    @staticmethod
    def initializeDirs(cards, cardsSub, tokens, icons, boosters,
            fatPacks, boosterBoxes, precons, tournamentPacks):
        ImageKeys.CACHE_CARD_PICS_DIR = cards
        ImageKeys.CACHE_CARD_PICS_SUBDIR = cardsSub
        ImageKeys.CACHE_TOKEN_PICS_DIR = tokens
        ImageKeys.CACHE_ICON_PICS_DIR = icons
        ImageKeys.CACHE_BOOSTER_PICS_DIR = boosters
        ImageKeys.CACHE_FATPACK_PICS_DIR = fatPacks
        ImageKeys.CACHE_BOOSTERBOX_PICS_DIR = boosterBoxes
        ImageKeys.CACHE_PRECON_PICS_DIR = precons
        ImageKeys.CACHE_TOURNAMENTPACK_PICS_DIR = tournamentPacks

    # image file extensions for various formats in order of likelihood
    # the last, empty, string is for keys that come in with an extension already in place
    FILE_EXTENSIONS = [".jpg", ".png", ""]

    @staticmethod
    def getTokenKey(tokenName):
        return ImageKeys.TOKEN_PREFIX + tokenName

    @staticmethod
    def getTokenImageName(tokenKey):
        if not tokenKey.startswith(ImageKeys.TOKEN_PREFIX):
            return None
        return tokenKey[len(ImageKeys.TOKEN_PREFIX):]

    cachedCards = {}
    missingCards = set()

    @staticmethod
    def clearMissingCards():
        ImageKeys.missingCards.clear()

    @staticmethod
    def getCachedCardsFile(key):
        return ImageKeys.cachedCards.get(key)

    @staticmethod
    def getImageFile(key):
        if key is None or key == "":
            return None

        tempdata = None
        if key.startswith(ImageKeys.TOKEN_PREFIX):
            tempdata = key[len(ImageKeys.TOKEN_PREFIX):].split("|")
            tokenname = tempdata[0]
            if len(tempdata) > 1:
                tokenname += "_" + tempdata[1]
            if len(tempdata) > 2:
                tokenname += "_" + tempdata[2]
            filename = tokenname

            dir = ImageKeys.CACHE_TOKEN_PICS_DIR
        elif key.startswith(ImageKeys.ICON_PREFIX):
            filename = key[len(ImageKeys.ICON_PREFIX):]
            dir = ImageKeys.CACHE_ICON_PICS_DIR
        elif key.startswith(ImageKeys.BOOSTER_PREFIX):
            filename = key[len(ImageKeys.BOOSTER_PREFIX):]
            dir = ImageKeys.CACHE_BOOSTER_PICS_DIR
        elif key.startswith(ImageKeys.FATPACK_PREFIX):
            filename = key[len(ImageKeys.FATPACK_PREFIX):]
            dir = ImageKeys.CACHE_FATPACK_PICS_DIR
        elif key.startswith(ImageKeys.BOOSTERBOX_PREFIX):
            filename = key[len(ImageKeys.BOOSTERBOX_PREFIX):]
            dir = ImageKeys.CACHE_BOOSTERBOX_PICS_DIR
        elif key.startswith(ImageKeys.PRECON_PREFIX):
            filename = key[len(ImageKeys.PRECON_PREFIX):]
            dir = ImageKeys.CACHE_PRECON_PICS_DIR
        elif key.startswith(ImageKeys.TOURNAMENTPACK_PREFIX):
            filename = key[len(ImageKeys.TOURNAMENTPACK_PREFIX):]
            dir = ImageKeys.CACHE_TOURNAMENTPACK_PICS_DIR
        elif key.startswith(ImageKeys.ADVENTURECARD_PREFIX):
            filename = key[len(ImageKeys.ADVENTURECARD_PREFIX):]
            dir = ImageKeys.ADVENTURE_CARD_PICS_DIR
        else:
            filename = key
            dir = ImageKeys.CACHE_CARD_PICS_DIR

        if filename in ImageKeys.toFind:
            return None
        if filename in ImageKeys.missingCards:
            return None

        cachedFile = ImageKeys.cachedCards.get(filename)
        if cachedFile is not None:
            return cachedFile
        else:
            file = ImageKeys.findFile(dir, filename)
            if file is not None:
                ImageKeys.cachedCards[filename] = file
                return file
            if dir == ImageKeys.CACHE_TOKEN_PICS_DIR:
                setlessFilename = tempdata[0]
                setCode = tempdata[1] if len(tempdata) > 1 else ""
                collectorNumber = tempdata[2] if len(tempdata) > 2 else ""
                if setCode != "":
                    if collectorNumber != "":
                        file = ImageKeys.findFile(dir, setCode + "/" + collectorNumber + "_" + setlessFilename)
                        if file is not None:
                            ImageKeys.cachedCards[filename] = file
                            return file
                    file = ImageKeys.findFile(dir, setCode + "/" + setlessFilename)
                    if file is not None:
                        ImageKeys.cachedCards[filename] = file
                        return file
                file = ImageKeys.findFile(dir, setlessFilename)
                if file is not None:
                    ImageKeys.cachedCards[filename] = file
                    return file

            # AE -> Ae and Ae -> AE for older cards with different file names
            # on case-sensitive file systems
            if "Ae" in filename:
                file = ImageKeys.findFile(dir, TextUtil.fastReplace(filename, "Ae", "AE"))
                if file is not None:
                    ImageKeys.cachedCards[filename] = file
                    return file
            elif "AE" in filename:
                file = ImageKeys.findFile(dir, TextUtil.fastReplace(filename, "AE", "Ae"))
                if file is not None:
                    ImageKeys.cachedCards[filename] = file
                    return file
            # try fullborder...
            if ".full" in filename:
                fullborderFile = TextUtil.fastReplace(filename, ".full", ".fullborder")
                file = ImageKeys.findFile(dir, fullborderFile)
                if file is not None:
                    ImageKeys.cachedCards[filename] = file
                    return file
                # if there's a 1st art variant try without it for .fullborder images
                file = ImageKeys.findFile(dir, TextUtil.fastReplace(fullborderFile, "1.fullborder", ".fullborder"))
                if file is not None:
                    ImageKeys.cachedCards[filename] = file
                    return file
                # if there's an art variant try without it for .full images
                file = ImageKeys.findFile(dir, re.sub(r"[0-9].full", ".full", filename))
                if file is not None:
                    ImageKeys.cachedCards[filename] = file
                    return file
                # setlookup
                if ImageKeys.hasSetLookup(filename):
                    ImageKeys.toFind.add(filename)
                    try:
                        def _lookup():
                            f = ImageKeys.setLookUpFile(filename, fullborderFile)
                            if f is not None:
                                ImageKeys.cachedCards[filename] = f
                            else:  # is null
                                ImageKeys.missingCards.add(filename)
                            ImageKeys.toFind.discard(filename)
                        ThreadUtil.getServicePool().submit(_lookup)
                    except Exception as e:
                        ImageKeys.toFind.discard(filename)
                setCode = filename[0:filename.index("/")] if "/" in filename else ""
                if setCode != "" and setCode in ImageKeys.editionAlias:
                    for alias in ImageKeys.editionAlias[setCode]:
                        file = ImageKeys.findFile(dir, TextUtil.fastReplace(filename, setCode + "/", alias + "/"))
                        if file is not None:
                            ImageKeys.cachedCards[filename] = file
                            return file
                        file = ImageKeys.findFile(dir, TextUtil.fastReplace(fullborderFile, setCode + "/", alias + "/"))
                        if file is not None:
                            ImageKeys.cachedCards[filename] = file
                            return file
            # if an image, like phenomenon or planes is missing .full in their filenames but you have an existing images that have .full/.fullborder
            if ".full" not in filename:
                file = ImageKeys.findFile(dir, TextUtil.addSuffix(filename, ".full"))
                if file is not None:
                    ImageKeys.cachedCards[filename] = file
                    return file
                file = ImageKeys.findFile(dir, TextUtil.addSuffix(filename, ".fullborder"))
                if file is not None:
                    ImageKeys.cachedCards[filename] = file
                    return file
            if "/" in filename:
                setlessFilename = filename[filename.index("/") + 1:]
                file = ImageKeys.findFile(dir, setlessFilename)
                if file is not None:
                    ImageKeys.cachedCards[filename] = file
                    return file

                if ".full" in setlessFilename:
                    # try fullborder
                    fullborderFile = TextUtil.fastReplace(setlessFilename, ".full", ".fullborder")
                    file = ImageKeys.findFile(dir, fullborderFile)
                    if file is not None:
                        ImageKeys.cachedCards[filename] = file
                        return file
                    # try lowering the art index to the minimum for regular cards
                    file = ImageKeys.findFile(dir, re.sub(r"[0-9]*[.]full", "1.full", setlessFilename))
                    if file is not None:
                        ImageKeys.cachedCards[filename] = file
                        return file
                # lookup other cards like planechase/phenomenon
                if ".full" not in filename:
                    newFilename = TextUtil.addSuffix(filename, ".full")
                    file = ImageKeys.findFile(dir, newFilename)
                    if file is not None:
                        ImageKeys.cachedCards[filename] = file
                        return file
                    newFilename2 = TextUtil.addSuffix(filename, ".fullborder")
                    file = ImageKeys.findFile(dir, newFilename2)
                    if file is not None:
                        ImageKeys.cachedCards[filename] = file
                        return file
                    setCode = filename[0:filename.index("/")]
                    if setCode != "" and setCode in ImageKeys.editionAlias:
                        for alias in ImageKeys.editionAlias[setCode]:
                            file = ImageKeys.findFile(dir, TextUtil.fastReplace(newFilename, setCode + "/", alias + "/"))
                            if file is not None:
                                ImageKeys.cachedCards[filename] = file
                                return file
                            file = ImageKeys.findFile(dir, TextUtil.fastReplace(newFilename2, setCode + "/", alias + "/"))
                            if file is not None:
                                ImageKeys.cachedCards[filename] = file
                                return file

        # System.out.println("File not found, no image created: " + key);
        # add missing cards - disable for desktop version for compatibility reasons with autodownloader
        if ImageKeys.isLibGDXPort and not ImageKeys.hasSetLookup(filename):  # missing cards with setlookup is handled differently
            ImageKeys.missingCards.add(filename)
        return None

    @staticmethod
    def getSetFolder(edition):
        return (StaticData.instance().getEditions().getCode2ByCode(edition)  # by default 2-letter codes from MWS are used
                if edition not in ImageKeys.CACHE_CARD_PICS_SUBDIR
                else ImageKeys.CACHE_CARD_PICS_SUBDIR[edition])  # may use custom paths though

    @staticmethod
    def hasSetLookup(filename):
        if filename is None:
            return False
        if len(StaticData.instance().getSetLookup()) != 0:
            return any(filename.startswith(k) for k in StaticData.instance().getSetLookup().keys())

        return False

    @staticmethod
    def setLookUpFile(filename, fullborderFile):
        if len(StaticData.instance().getSetLookup()) != 0:
            for setKey in StaticData.instance().getSetLookup().keys():
                if filename.startswith(setKey):
                    for setLookup in StaticData.instance().getSetLookup().get(setKey):
                        lookupDirectory = ImageKeys.CACHE_CARD_PICS_DIR + setLookup
                        f = lookupDirectory
                        if os.path.exists(f) and os.path.isdir(f):
                            for ext in ImageKeys.FILE_EXTENSIONS:
                                if ext == "":
                                    continue
                                fb1 = fullborderFile.replace(setKey + "/", "") + ext
                                placeholder = lookupDirectory + "/" + fb1
                                if os.path.exists(placeholder):
                                    return placeholder
                                fb2 = re.sub(r"[0-9]*.fullborder", "1.fullborder", fullborderFile.replace(setKey + "/", "")) + ext
                                placeholder = lookupDirectory + "/" + fb2
                                if os.path.exists(placeholder):
                                    return placeholder
                                f1 = filename.replace(setKey + "/", "") + ext
                                placeholder = lookupDirectory + "/" + f1
                                if os.path.exists(placeholder):
                                    return placeholder
                                f2 = re.sub(r"[0-9]*.full", "1.full", filename.replace(setKey + "/", "")) + ext
                                placeholder = lookupDirectory + "/" + f2
                                if os.path.exists(placeholder):
                                    return placeholder
        return None

    @staticmethod
    def findFile(dir, filename):
        if dir == ImageKeys.CACHE_CARD_PICS_DIR:
            for ext in ImageKeys.FILE_EXTENSIONS:
                if ext == "":
                    continue

                f = os.path.join(dir, filename + ext)
                if os.path.exists(f):
                    return f
        else:
            # old method for tokens and others
            for ext in ImageKeys.FILE_EXTENSIONS:
                file = os.path.join(dir, filename + ext)
                if os.path.exists(file):
                    if os.path.isdir(file):
                        os.rmdir(file)
                        continue
                    return file
        return None

    # shortcut for determining if a card image exists for a given card
    # should only be called from PaperCard.hasImage()
    cachedContent = {}

    @staticmethod
    def hasImage(pc, update=False):
        editionHasImage = ImageKeys.editionImageLookup.get(pc.getEdition())
        if editionHasImage is None:
            setFolder = ImageKeys.getSetFolder(pc.getEdition())
            ed = StaticData.instance().getEditions().get(setFolder)
            if ed is not None and setFolder not in ImageKeys.editionAlias:
                alias = ed.getAlias()
                aliasSet = set()
                if alias is not None:
                    if alias.lower() != setFolder.lower():
                        aliasSet.add(alias)
                code = ed.getCode()
                if code is not None:
                    if code.lower() != setFolder.lower():
                        aliasSet.add(code)
                if len(aliasSet) != 0:
                    ImageKeys.editionAlias[setFolder] = aliasSet
            editionHasImage = FileUtil.isDirectoryWithFiles(ImageKeys.CACHE_CARD_PICS_DIR + setFolder)
            ImageKeys.editionImageLookup[pc.getEdition()] = editionHasImage
            if editionHasImage:
                f = ImageKeys.CACHE_CARD_PICS_DIR + setFolder  # no need to check this, otherwise editionHasImage would be false!
                setFolderContent = set()
                for filename in os.listdir(f):
                    # TODO: should this use FILE_EXTENSIONS ?
                    if not filename.endswith(".jpg") and not filename.endswith(".png"):
                        continue  # not image - not interested
                    setFolderContent.add(filename.split(".")[0])  # get rid of any full or fullborder
                    # preload cachedCards at startUp
                    key = setFolder + "/" + filename.replace(".fullborder", ".full").replace(".jpg", "").replace(".png", "")
                    value = ImageKeys.CACHE_CARD_PICS_DIR + setFolder + "/" + filename
                    ImageKeys.cachedCards[key] = value
                ImageKeys.cachedContent[setFolder] = setFolderContent

        keyParts = [p for p in re.split(r"/+", pc.getCardImageKey()) if p]
        if len(keyParts) != 2:
            return False
        if update and editionHasImage:
            try:
                ImageKeys.cachedContent.get(ImageKeys.getSetFolder(pc.getEdition())).add(pc.getName())
            except Exception as e:
                print(e, file=sys.stderr)
        content = ImageKeys.cachedContent.get(keyParts[0], None)
        # avoid checking for file if edition doesn't have any images
        return editionHasImage and ImageKeys.hitCache(content, keyParts[1])

    @staticmethod
    def hitCache(cache, filename):
        if cache is None or len(cache) == 0:
            return False
        keyPrefix = filename.split(".")[0]
        return keyPrefix in cache
```
