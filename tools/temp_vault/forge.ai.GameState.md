---
aliases:
  - GameState
tags:
  - java/class
  - module/forge-ai
  - pkg/forge/ai
fqn: forge.ai.GameState
package: forge.ai
module: forge-ai
kind: Class
---

# GameState

**Package:** `forge.ai` &nbsp; **Module:** `forge-ai` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class GameState {
        -Map~ZoneType,String~ ZONES
        -List~PlayerState~ playerStates
        -boolean puzzleCreatorState
        -Map~Integer,Card~ idToCard
        -Map~Card,Integer~ cardToAttachId
        -Map~Card,Player~ cardToEnchantPlayerId
        -Map~Card,Integer~ markedDamage
        -Map~Card,List~ cardToChosenClrs
        -Map~Card,CardCollection~ cardToChosenCards
        -Map~Card,String~ cardToChosenType
        -Map~Card,String~ cardToChosenType2
        -Map~Card,List~ cardToRememberedId
        -Map~Card,List~ cardToImprintedId
        -Map~Card,List~ cardToMergedCards
        -Map~Card,List~ cardToNamedCard
        -Map~Card,String~ cardToExiledWithId
        -Map~Card,Card~ cardAttackMap
        -Map~Card,String~ cardToScript
        -Map~String,String~ abilityString
        -Set~Card~ cardsReferencedByID
        -Set~Card~ cardsWithoutETBTrigs
        -String tChangePlayer
        -String tChangePhase
        -String tAdvancePhase
        -int turn
        -boolean removeSummoningSickness
        -int TARGET_NONE
        -int TARGET_HUMAN
        -int TARGET_AI
        +getPaperCard(String cardName, String setCode, int artID) IPaperCard
        +toString() String
        -appendCards(Map~ZoneType,String~ cardTexts, String categoryPrefix, StringBuilder sb) void
        +initFromGame(Game game) void
        -getPlayerString(Player p) String
        -parsePlayerString(Game game, String str) Player
        -addCard(ZoneType zoneType, Map~ZoneType,String~ cardTexts, Card c) void
        -countersToString(Map~CounterType,Integer~ counters) String
        -splitLine(String line) String[]
        +parse(InputStream in) void
        +parse(List~String~ lines) void
        +parse(Stream~String~ lines) void
        -getPlayerState(int index) PlayerState
        -getPlayerState(String key) PlayerState
        #parseLine(String line) void
        +applyToGame(Game game) void
        #applyGameOnThread(Game game) void
        -processManaPool(ManaPool manaPool) String
        -updateManaPool(Player p, String manaDef, boolean clearPool, boolean persistent) void
        -handleCombat(Game game, Player attackingPlayer, Player defendingPlayer, boolean toDeclareBlockers) void
        -handleRememberedEntities() void
        -parseTargetInScript(String tgtDef) int
        -handleScriptedTargetingForSA(Game game, SpellAbility sa, int tgtID) void
        -handleScriptExecution(Game game) void
        -executeScript(Game game, Card c, String sPtr) void
        -executeScript(Game game, Card c, String sPtr, boolean putOnStack) void
        -handlePrecastSpells(Game game) void
        -handleAddSAsToStack(Game game) void
        -precastSpellFromCard(String spellDef, Player activator, Game game) void
        -precastSpellFromCard(String spellDef, Player activator, Game game, boolean putOnStack) void
        -handleMarkedDamage() void
        -handleChosenEntities() void
        -handleCardAttachments() void
        -handleMergedCards() void
        -emulateMergeViaMutate(Card top, Card bottom) void
        -applyCountersToGameEntity(GameEntity entity, String counterString) void
        -setupPlayerState(Player p, PlayerState state) void
        -processCardsForZone(String[] data, Player player) CardCollectionView
        +GameState()
    }
    GameState ..> AbilityManaPart : uses
    GameState ..> Card : uses
    GameState ..> CardCloneStates : uses
    GameState ..> CardCollection : uses
    GameState ..> CardCollectionView : uses
    GameState ..> CardCopyService : uses
    GameState ..> CardStateName : uses
    GameState ..> Combat : uses
    GameState ..> CounterType : uses
    GameState ..> DetachedCardEffect : uses
    GameState ..> EmptySa : uses
    GameState ..> FCollectionView : uses
    GameState ..> Game : uses
    GameState ..> GameEntity : uses
    GameState ..> GameEventAttackersDeclared : uses
    GameState ..> GameEventCombatChanged : uses
    GameState ..> IPaperCard : uses
    GameState ..> ManaPool : uses
    GameState ..> PaperCard : uses
    GameState ..> PaperToken : uses
    GameState ..> PhaseType : uses
    GameState ..> Player : uses
    GameState ..> PlayerState : uses
    GameState ..> PlayerZone : uses
    GameState ..> SpellAbility : uses
    GameState ..> TokenInfo : uses
    GameState ..> ZoneType : uses
```

## Relationships
**Uses:**
- [[forge.ai.GameState.PlayerState|PlayerState]]
- [[forge.card.CardStateName|CardStateName]]
- [[forge.game.Game|Game]]
- [[forge.game.GameEntity|GameEntity]]
- [[forge.game.ability.effects.DetachedCardEffect|DetachedCardEffect]]
- [[forge.game.card.Card|Card]]
- [[forge.game.card.CardCloneStates|CardCloneStates]]
- [[forge.game.card.CardCollection|CardCollection]]
- [[forge.game.card.CardCollectionView|CardCollectionView]]
- [[forge.game.card.CardCopyService|CardCopyService]]
- [[forge.game.card.CounterType|CounterType]]
- [[forge.game.card.token.TokenInfo|TokenInfo]]
- [[forge.game.combat.Combat|Combat]]
- [[forge.game.event.GameEventAttackersDeclared|GameEventAttackersDeclared]]
- [[forge.game.event.GameEventCombatChanged|GameEventCombatChanged]]
- [[forge.game.mana.ManaPool|ManaPool]]
- [[forge.game.phase.PhaseType|PhaseType]]
- [[forge.game.player.Player|Player]]
- [[forge.game.spellability.AbilityManaPart|AbilityManaPart]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]
- [[forge.game.spellability.SpellAbility.EmptySa|EmptySa]]
- [[forge.game.zone.PlayerZone|PlayerZone]]
- [[forge.game.zone.ZoneType|ZoneType]]
- [[forge.item.IPaperCard|IPaperCard]]
- [[forge.item.PaperCard|PaperCard]]
- [[forge.item.PaperToken|PaperToken]]
- [[forge.util.collect.FCollectionView|FCollectionView]]


## Design Description

GameState is an abstract base class in the `forge.ai` package that serializes a complete Magic: The Gathering game snapshot to and from a flat key/value text format, used by AI dev mode and Puzzle Mode. Its two responsibilities mirror each other: `initFromGame`/`toString` capture a live `Game`â€”players, zones, and per-card attributes such as counters, damage, attachments, chosen colors, combat assignments, and merged/transformed statesâ€”into per-player `PlayerState` records, while `parse` plus `applyToGame`/`applyGameOnThread` rebuild that state back onto a `Game`.

It collaborates broadly with the engine modelâ€”`Card`, `Player`, `Combat`, `ManaPool`, `SpellAbility`, `ZoneType`, and paper-card/token factoriesâ€”and structures reconstruction through many focused `handle*` helpers that defer cross-references (attachments, remembered/imprinted IDs, scripted targeting) until every card exists, resolving them via an `idToCard` map. The single abstract `getPaperCard` hook delegates card-database lookup to concrete subclasses, decoupling state logic from card-source resolution, while trigger suppression and stack freezing during application reflect deliberate intent to install state without firing spurious game events.

## Source
`forge-ai/src/main/java/forge/ai/GameState.java`

```java
package forge.ai;

import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Multimap;
import forge.StaticData;
import forge.card.CardEdition;
import forge.card.CardStateName;
import forge.card.GamePieceType;
import forge.card.MagicColor;
import forge.card.mana.ManaAtom;
import forge.game.Game;
import forge.game.GameEntity;
import forge.game.ability.AbilityFactory;
import forge.game.ability.ApiType;
import forge.game.ability.effects.DetachedCardEffect;
import forge.game.card.*;
import forge.game.card.token.TokenInfo;
import forge.game.combat.Combat;
import forge.game.combat.CombatUtil;
import forge.game.event.GameEventAttackersDeclared;
import forge.game.event.GameEventCombatChanged;
import forge.game.mana.ManaPool;
import forge.game.phase.PhaseType;
import forge.game.player.Player;
import forge.game.spellability.AbilityManaPart;
import forge.game.spellability.SpellAbility;
import forge.game.zone.PlayerZone;
import forge.game.zone.ZoneType;
import forge.item.IPaperCard;
import forge.item.PaperCard;
import forge.item.PaperToken;
import forge.util.TextUtil;
import forge.util.collect.FCollectionView;
import org.apache.commons.lang3.StringUtils;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.*;
import java.util.Map.Entry;
import java.util.stream.Stream;

public abstract class GameState {
    private static final Map<ZoneType, String> ZONES = new HashMap<>();
    static {
        ZONES.put(ZoneType.Battlefield, "battlefield");
        ZONES.put(ZoneType.Hand, "hand");
        ZONES.put(ZoneType.Graveyard, "graveyard");
        ZONES.put(ZoneType.Library, "library");
        ZONES.put(ZoneType.Exile, "exile");
        ZONES.put(ZoneType.Command, "command");
        ZONES.put(ZoneType.Sideboard, "sideboard");
    }

    static class PlayerState {
        private int life = -1;
        private String counters = "";
        private String manaPool = "";
        private String persistentMana = "";
        private int landsPlayed = 0;
        private int landsPlayedLastTurn = 0;
        private int numRingTemptedYou = 0;
        private int speed = 0;
        private String precast = null;
        private String putOnStack = null;
        private final Map<ZoneType, String> cardTexts = new EnumMap<>(ZoneType.class);
    }
    private final List<PlayerState> playerStates = new ArrayList<>();

    private boolean puzzleCreatorState = false;

    private final Map<Integer, Card> idToCard = new HashMap<>();
    private final Map<Card, Integer> cardToAttachId = new HashMap<>();
    private final Map<Card, Player> cardToEnchantPlayerId = new HashMap<>();
    private final Map<Card, Integer> markedDamage = new HashMap<>();
    private final Map<Card, List<String>> cardToChosenClrs = new HashMap<>();
    private final Map<Card, CardCollection> cardToChosenCards = new HashMap<>();
    private final Map<Card, String> cardToChosenType = new HashMap<>();
    private final Map<Card, String> cardToChosenType2 = new HashMap<>();
    private final Map<Card, List<String>> cardToRememberedId = new HashMap<>();
    private final Map<Card, List<String>> cardToImprintedId = new HashMap<>();
    private final Map<Card, List<String>> cardToMergedCards = new HashMap<>();
    private final Map<Card, List<String>> cardToNamedCard = new HashMap<>();
    private final Map<Card, String> cardToExiledWithId = new HashMap<>();
    private final Map<Card, Card> cardAttackMap = new HashMap<>();

    private final Map<Card, String> cardToScript = new HashMap<>();

    private final Map<String, String> abilityString = new HashMap<>();

    private final Set<Card> cardsReferencedByID = new HashSet<>();
    private final Set<Card> cardsWithoutETBTrigs = new HashSet<>();

    private String tChangePlayer = "NONE";
    private String tChangePhase = "NONE";

    private String tAdvancePhase = "NONE";

    private int turn = 1;

    private boolean removeSummoningSickness = false;

    // Targeting for precast spells in a game state (mostly used by Puzzle Mode game states)
    private final int TARGET_NONE = -1; // untargeted spell (e.g. Joraga Invocation)
    private final int TARGET_HUMAN = -2;
    private final int TARGET_AI = -3;

    public GameState() {
    }

    public abstract IPaperCard getPaperCard(String cardName, String setCode, int artID);

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();

        if (puzzleCreatorState) {
            // append basic puzzle metadata if we're dumping from the puzzle creator screen
            sb.append("[metadata]\n");
            sb.append("Name:New Puzzle\n");
            sb.append("URL:https://www.cardforge.org\n");
            sb.append("Goal:Win\n");
            sb.append("Turns:1\n");
            sb.append("Difficulty:Common\n");
            sb.append("Description:Win this turn.\n");
            sb.append("[state]\n");
        }

        sb.append(TextUtil.concatNoSpace("turn=", String.valueOf(turn), "\n"));
        sb.append(TextUtil.concatNoSpace("activeplayer=", tChangePlayer, "\n"));
        sb.append(TextUtil.concatNoSpace("activephase=", tChangePhase, "\n"));

        int playerIndex = 0;
        for (PlayerState p : playerStates) {
            String prefix = "p" + playerIndex++;
            sb.append(TextUtil.concatNoSpace(prefix + "life=", String.valueOf(p.life), "\n"));
            sb.append(TextUtil.concatNoSpace(prefix + "landsplayed=", String.valueOf(p.landsPlayed), "\n"));
            sb.append(TextUtil.concatNoSpace(prefix + "landsplayedlastturn=", String.valueOf(p.landsPlayedLastTurn), "\n"));
            sb.append(TextUtil.concatNoSpace(prefix + "numringtemptedyou=", String.valueOf(p.numRingTemptedYou), "\n"));
            sb.append(TextUtil.concatNoSpace(prefix + "speed=", String.valueOf(p.speed), "\n"));
            if (!p.counters.isEmpty()) {
                sb.append(TextUtil.concatNoSpace(prefix + "counters=", p.counters, "\n"));
            }
            if (!p.manaPool.isEmpty()) {
                sb.append(TextUtil.concatNoSpace(prefix + "manapool=", p.manaPool, "\n"));
            }
            if (!p.persistentMana.isEmpty()) {
                sb.append(TextUtil.concatNoSpace(prefix + "persistentmana=", p.persistentMana, "\n"));
            }
            appendCards(p.cardTexts, prefix, sb);
        }
        return sb.toString();
    }

    private void appendCards(Map<ZoneType, String> cardTexts, String categoryPrefix, StringBuilder sb) {
        for (Entry<ZoneType, String> kv : cardTexts.entrySet()) {
            sb.append(TextUtil.concatNoSpace(categoryPrefix, ZONES.get(kv.getKey()), "=", kv.getValue(), "\n"));
        }
    }

    public void initFromGame(Game game) {
        playerStates.clear();
        for (Player player : game.getPlayers()) {
            PlayerState p = new PlayerState();
            p.life = player.getLife();
            p.landsPlayed = player.getLandsPlayedThisTurn();
            p.landsPlayedLastTurn = player.getLandsPlayedLastTurn();
            p.counters = countersToString(player.getCounters());
            p.manaPool = processManaPool(player.getManaPool());
            p.numRingTemptedYou = player.getNumRingTemptedYou();
            p.speed = player.getSpeed();
            playerStates.add(p);
        }

        tChangePlayer = "p" + game.getPlayers().indexOf(game.getPhaseHandler().getPlayerTurn());
        tChangePhase = game.getPhaseHandler().getPhase().toString();
        turn = game.getPhaseHandler().getTurn();

        // Mark the cards that need their ID remembered for various reasons
        cardsReferencedByID.clear();
        for (ZoneType zone : ZONES.keySet()) {
            for (Card card : game.getCardsIncludePhasingIn(zone)) {
                if (card.getExiledWith() != null) {
                    // Remember the ID of the card that exiled this card
                    cardsReferencedByID.add(card.getExiledWith());
                }
                if (zone == ZoneType.Battlefield) {
                    if (!card.getAllAttachedCards().isEmpty()) {
                        // Remember the ID of cards that have attachments
                        cardsReferencedByID.add(card);
                    }
                }
                for (Object o : card.getRemembered()) {
                    // Remember the IDs of remembered cards
                    if (o instanceof Card) {
                        cardsReferencedByID.add((Card)o);
                    }
                }
                for (Card i : card.getImprintedCards()) {
                    // Remember the IDs of imprinted cards
                    cardsReferencedByID.add(i);
                }
                for (Card i : card.getChosenCards()) {
                    // Remember the IDs of chosen cards
                    cardsReferencedByID.add(i);
                }
                if (game.getCombat() != null && game.getCombat().isAttacking(card)) {
                    // Remember the IDs of attacked planeswalkers
                    GameEntity def = game.getCombat().getDefenderByAttacker(card);
                    if (def instanceof Card) {
                        cardsReferencedByID.add((Card)def);
                    }
                }
            }
        }

        for (ZoneType zone : ZONES.keySet()) {
            // Init texts to empty, so that restoring will clear the state
            // if the zone had no cards in it (e.g. empty hand).
            for (PlayerState p : playerStates) {
                p.cardTexts.put(zone, "");
            }
            for (Card card : game.getCardsIncludePhasingIn(zone)) {
                if (card.getName().equals("Puzzle Goal") && card.getOracleText().contains("New Puzzle")) {
                    puzzleCreatorState = true;
                }
                if (card instanceof DetachedCardEffect) {
                    continue;
                }
                int playerIndex = game.getPlayers().indexOf(card.getZone().getPlayer());
                addCard(zone, playerStates.get(playerIndex).cardTexts, card);
            }
        }
    }

    private String getPlayerString(Player p) {
        return "P" + p.getGame().getPlayers().indexOf(p);
    }

    private Player parsePlayerString(Game game, String str) {
        if (str.equalsIgnoreCase("HUMAN")) {
            return game.getPlayers().get(0);
        } else if (str.equalsIgnoreCase("AI")) {
            return game.getPlayers().get(1);
        } else if (str.startsWith("P") && Character.isDigit(str.charAt(1))) {
            return game.getPlayers().get(Integer.parseInt(String.valueOf(str.charAt(1))));
        } else {
            return game.getPlayers().get(0);
        }
    }

    private void addCard(ZoneType zoneType, Map<ZoneType, String> cardTexts, Card c) {
        StringBuilder newText = new StringBuilder(cardTexts.get(zoneType));
        if (newText.length() > 0) {
            newText.append(";");
        }
        if (c.isToken()) {
            newText.append("t:").append(new TokenInfo(c));
        } else {
            if (c.getPaperCard() == null) {
                return;
            }

            if (c.hasMergedCard()) {
                String suffix = c.getTopMergedCard().hasPaperFoil() ? "+" : "";
                // we have to go by the current top card name here
                newText.append(c.getTopMergedCard().getPaperCard().getName()).append(suffix).append("|Set:")
                        .append(c.getTopMergedCard().getPaperCard().getEdition()).append("|Art:")
                        .append(c.getTopMergedCard().getPaperCard().getArtIndex());
            } else {
                String suffix = c.hasPaperFoil() ? "+" : "";
                newText.append(c.getPaperCard().getName()).append(suffix).append("|Set:").append(c.getPaperCard().getEdition())
                        .append("|Art:").append(c.getPaperCard().getArtIndex());
            }
        }
        if (c.isCommander()) {
            newText.append("|IsCommander");
        }
        if (c.isRingBearer()) {
            newText.append("|IsRingBearer");
        }

        if (cardsReferencedByID.contains(c)) {
            newText.append("|Id:").append(c.getId());
        }

        if (zoneType == ZoneType.Battlefield) {
            if (c.getOwner() != c.getController()) {
                newText.append("|Owner:").append(getPlayerString(c.getOwner()));
            }
            if (c.isTapped()) {
                newText.append("|Tapped");
            }
            if (c.isSick()) {
                newText.append("|SummonSick");
            }
            if (c.isRenowned()) {
                newText.append("|Renowned");
            }
            if (c.isSolved()) {
                newText.append("|Solved");
            }
            if (c.isSuspected()) {
                newText.append("|Suspected");
            }
            if (c.isMonstrous()) {
                newText.append("|Monstrous");
            }
            if (c.isPhasedOut()) {
                newText.append("|PhasedOut:");
                newText.append(getPlayerString(c.getPhasedOut()));
            }
            if (c.isFaceDown()) {
                newText.append("|FaceDown");
                if (c.isManifested()) {
                    newText.append(":Manifested");
                }
                if (c.isCloaked()) {
                    newText.append(":Cloaked");
                }
            }
            if (c.getCurrentStateName().equals(CardStateName.Flipped)) {
                newText.append("|Flipped");
            } else if (c.getCurrentStateName().equals(CardStateName.Meld)) {
                newText.append("|Meld");
                if (c.getMeldedWith() != null) {
                    String suffix = c.getMeldedWith().hasPaperFoil() ? "+" : "";
                    newText.append(":");
                    newText.append(c.getMeldedWith().getName()).append(suffix);
                }
            } else if (c.getCurrentStateName().equals(CardStateName.Backside)) {
                if (c.isModal()) {
                    newText.append("|Modal");
                } else {
                    newText.append("|Transformed");
                }
            }

            if (c.getPlayerAttachedTo() != null) {
                newText.append("|EnchantingPlayer:");
                newText.append(getPlayerString(c.getPlayerAttachedTo()));
            } else if (c.isAttachedToEntity()) {
                newText.append("|AttachedTo:").append(c.getEntityAttachedTo().getId());
            }

            if (c.getDamage() > 0) {
                newText.append("|Damage:").append(c.getDamage());
            }

            if (c.hasChosenColor()) {
                newText.append("|ChosenColor:").append(TextUtil.join(c.getChosenColors(), ","));
            }
            if (c.hasChosenType()) {
                newText.append("|ChosenType:").append(c.getChosenType());
            }
            if (c.hasChosenType2()) {
                newText.append("|ChosenType2:").append(c.getChosenType2());
            }
            if (!c.getNamedCard().isEmpty()) {
                newText.append("|NamedCard:").append(c.getNamedCard());
            }

            List<String> chosenCardIds = Lists.newArrayList();
            for (Card obj : c.getChosenCards()) {
                chosenCardIds.add(String.valueOf(obj.getId()));
            }
            if (!chosenCardIds.isEmpty()) {
                newText.append("|ChosenCards:").append(TextUtil.join(chosenCardIds, ","));
            }

            List<String> rememberedCardIds = Lists.newArrayList();
            for (Object obj : c.getRemembered()) {
                if (obj instanceof Card) {
                    int id = ((Card)obj).getId();
                    rememberedCardIds.add(String.valueOf(id));
                }
            }
            if (!rememberedCardIds.isEmpty()) {
                newText.append("|RememberedCards:").append(TextUtil.join(rememberedCardIds, ","));
            }

            List<String> imprintedCardIds = Lists.newArrayList();
            for (Card impr : c.getImprintedCards()) {
                int id = impr.getId();
                imprintedCardIds.add(String.valueOf(id));
            }
            if (!imprintedCardIds.isEmpty()) {
                newText.append("|Imprinting:").append(TextUtil.join(imprintedCardIds, ","));
            }

            if (c.hasMergedCard()) {
                List<String> mergedCardNames = new ArrayList<>();
                for (Card merged : c.getMergedCards()) {
                    if (c.getTopMergedCard() == merged) {
                        continue;
                    }
                    mergedCardNames.add(merged.getPaperCard().getName().replace(",", "^"));
                }
                newText.append("|MergedCards:").append(TextUtil.join(mergedCardNames, ","));
            }

            if (c.getClassLevel() > 1) {
                newText.append("|ClassLevel:").append(c.getClassLevel());
            }
        }

        if (zoneType == ZoneType.Exile) {
            if (c.getExiledWith() != null) {
                newText.append("|ExiledWith:").append(c.getExiledWith().getId());
            }
            if (c.isFaceDown()) {
                newText.append("|FaceDown"); // Exiled face down
            }
            if (c.isAdventureCard() && c.getZone().is(ZoneType.Exile)) {
                // TODO: this will basically default all exiled cards with Adventure to being "On Adventure".
                // Need to figure out a better way to detect if it's actually on adventure.
                newText.append("|OnAdventure");
            }
            if (c.isForetold()) {
                newText.append("|Foretold");
                if (c.enteredThisTurn()) {
                    newText.append("|ForetoldThisTurn");
                }
            }
        }

        if (zoneType == ZoneType.Battlefield || zoneType == ZoneType.Exile) {
            // A card can have counters on the battlefield and in exile (e.g. exiled by Mairsil, the Pretender)
            Map<CounterType, Integer> counters = c.getCounters();
            if (!counters.isEmpty()) {
                newText.append("|Counters:");
                newText.append(countersToString(counters));
            }
        }

        if (c.getGame().getCombat() != null) {
            if (c.getGame().getCombat().isAttacking(c)) {
                newText.append("|Attacking");
                GameEntity def = c.getGame().getCombat().getDefenderByAttacker(c);
                if (def instanceof Card) {
                    newText.append(":").append(def.getId());
                }
            }
        }

        if (!c.getUnlockedRooms().isEmpty()) {
            for (CardStateName stateName : c.getUnlockedRooms()) {
                newText.append("|UnlockedRoom:");
                newText.append(stateName.name());
            }
        }

        cardTexts.put(zoneType, newText.toString());
    }

    private String countersToString(Map<CounterType, Integer> counters) {
        boolean first = true;
        StringBuilder counterString = new StringBuilder();

        for (Entry<CounterType, Integer> kv : counters.entrySet()) {
            if (!first) {
                counterString.append(",");
            }

            first = false;
            counterString.append(TextUtil.concatNoSpace(kv.getKey().toString(), "=", String.valueOf(kv.getValue())));
        }
        return counterString.toString();
    }

    private String[] splitLine(String line) {
        if (line.charAt(0) == '#') {
            return null;
        }
        final String[] tempData = line.split("=", 2);
        if (tempData.length >= 2) {
            return tempData;
        }
        if (tempData.length == 1 && line.endsWith("=")) {
            // Empty value.
            return new String[] {tempData[0], ""};
        }
        return null;
    }

    public void parse(InputStream in) throws Exception {
        final BufferedReader br = new BufferedReader(new InputStreamReader(in));
        parse(br.lines());
    }

    public void parse(List<String> lines) {
        parse(lines.stream());
    }

    public void parse(Stream<String> lines) {
        playerStates.clear();
        lines.forEach(this::parseLine);
    }


    private PlayerState getPlayerState(int index) {
        while (index >= playerStates.size()) {
            playerStates.add(new PlayerState());
        }
        return playerStates.get(index);
    }

    private PlayerState getPlayerState(String key) {
        if (key.startsWith("human")) {
            return getPlayerState(0);
        } else if (key.startsWith("ai")) {
            return getPlayerState(1);
        } else if (key.startsWith("p") && Character.isDigit(key.charAt(1))) {
            return getPlayerState(Integer.parseInt(String.valueOf(key.charAt(1))));
        } else {
            System.err.println("Unknown player state key: " + key);
            return new PlayerState();
        }
    }

    protected void parseLine(String line) {
        String[] keyValue = splitLine(line);
        if (keyValue == null) return;

        final String categoryName = keyValue[0].toLowerCase();
        final String categoryValue = keyValue[1];

        if (categoryName.startsWith("active")) {
            if (categoryName.endsWith("player"))
                tChangePlayer = categoryValue.trim().toLowerCase();
            else if (categoryName.endsWith("phase"))
                tChangePhase = categoryValue.trim().toUpperCase();
            else if (categoryName.endsWith("phaseadvance"))
                tAdvancePhase = categoryValue.trim().toUpperCase();
            return;
        }

        if (categoryName.equals("turn")) {
            turn = Integer.parseInt(categoryValue);
        } else if (categoryName.equals("removesummoningsickness")) {
            removeSummoningSickness = categoryValue.equalsIgnoreCase("true");
        } else if (categoryName.endsWith("life")) {
            getPlayerState(categoryName).life = Integer.parseInt(categoryValue);
        } else if (categoryName.endsWith("counters")) {
            getPlayerState(categoryName).counters = categoryValue;
        } else if (categoryName.endsWith("landsplayed")) {
            getPlayerState(categoryName).landsPlayed = Integer.parseInt(categoryValue);
        } else if (categoryName.endsWith("landsplayedlastturn")) {
            getPlayerState(categoryName).landsPlayedLastTurn = Integer.parseInt(categoryValue);
        } else if (categoryName.endsWith("numringtemptedyou")) {
            getPlayerState(categoryName).numRingTemptedYou = Integer.parseInt(categoryValue);
        } else if (categoryName.endsWith("speed")) {
            getPlayerState(categoryName).speed = Integer.parseInt(categoryValue);
        } else if (categoryName.endsWith("play") || categoryName.endsWith("battlefield")) {
            getPlayerState(categoryName).cardTexts.put(ZoneType.Battlefield, categoryValue);
        } else if (categoryName.endsWith("hand")) {
            getPlayerState(categoryName).cardTexts.put(ZoneType.Hand, categoryValue);
        } else if (categoryName.endsWith("graveyard")) {
            getPlayerState(categoryName).cardTexts.put(ZoneType.Graveyard, categoryValue);
        } else if (categoryName.endsWith("library")) {
            getPlayerState(categoryName).cardTexts.put(ZoneType.Library, categoryValue);
        } else if (categoryName.endsWith("exile")) {
            getPlayerState(categoryName).cardTexts.put(ZoneType.Exile, categoryValue);
        } else if (categoryName.endsWith("command")) {
            getPlayerState(categoryName).cardTexts.put(ZoneType.Command, categoryValue);
        } else if (categoryName.endsWith("sideboard")) {
            getPlayerState(categoryName).cardTexts.put(ZoneType.Sideboard, categoryValue);
        } else if (categoryName.startsWith("ability")) {
            abilityString.put(categoryName.substring("ability".length()), categoryValue);
        } else if (categoryName.endsWith("precast")) {
            getPlayerState(categoryName).precast = categoryValue;
        } else if (categoryName.endsWith("putonstack")) {
            getPlayerState(categoryName).putOnStack = categoryValue;
        } else if (categoryName.endsWith("manapool")) {
            getPlayerState(categoryName).manaPool = categoryValue;
        } else if (categoryName.endsWith("persistentmana")) {
            getPlayerState(categoryName).persistentMana = categoryValue;
        } else {
            System.err.println("Unknown key: " + categoryName);
        }
    }

    public void applyToGame(final Game game) {
        game.getAction().invoke(() -> applyGameOnThread(game));
    }

    protected void applyGameOnThread(final Game game) {
        if (game.getPlayers().size() != playerStates.size()) {
            throw new RuntimeException("Non-matching number of players, (" +
                game.getPlayers().size() + " vs. " + playerStates.size() + ")");
        }

        idToCard.clear();
        cardToAttachId.clear();
        cardToEnchantPlayerId.clear();
        cardToRememberedId.clear();
        cardToExiledWithId.clear();
        cardToImprintedId.clear();
        markedDamage.clear();
        cardToChosenClrs.clear();
        cardToChosenCards.clear();
        cardToChosenType.clear();
        cardToChosenType2.clear();
        cardToMergedCards.clear();
        cardToScript.clear();
        cardAttackMap.clear();

        int playerTurn = playerStates.indexOf(getPlayerState(tChangePlayer));
        Player newPlayerTurn = game.getPlayers().get(playerTurn);
        PhaseType newPhase = tChangePhase.equalsIgnoreCase("none") ? null : PhaseType.smartValueOf(tChangePhase);
        PhaseType advPhase = tAdvancePhase.equalsIgnoreCase("none") ? null : PhaseType.smartValueOf(tAdvancePhase);

        // Set stack to resolving so things won't trigger/effects be checked right away
        game.getStack().setResolving(true);

        game.getPhaseHandler().devModeSet(newPhase, newPlayerTurn, turn);

        game.getTriggerHandler().setSuppressAllTriggers(true);

        for (int i = 0; i < playerStates.size(); i++) {
            setupPlayerState(game.getPlayers().get(i), playerStates.get(i));
        }
        handleCardAttachments();
        handleChosenEntities();
        handleRememberedEntities();
        handleMergedCards();
        handleScriptExecution(game);
        handlePrecastSpells(game);
        handleMarkedDamage();

        game.getTriggerHandler().setSuppressAllTriggers(false);

        // SAs added to stack cause triggers to fire, as if the relevant SAs were cast
        handleAddSAsToStack(game);

        // Combat only works for 1v1 matches for now (which are the only matches dev mode supports anyway)
        // Note: triggers may fire during combat declarations ("whenever X attacks, ...", etc.)
        if (newPhase == PhaseType.COMBAT_DECLARE_ATTACKERS || newPhase == PhaseType.COMBAT_DECLARE_BLOCKERS) {
            boolean toDeclareBlockers = newPhase == PhaseType.COMBAT_DECLARE_BLOCKERS;
            if (newPlayerTurn != null) {
                handleCombat(game, newPlayerTurn, newPlayerTurn.getSingleOpponent(), toDeclareBlockers);
            }
        }

        game.getStack().setResolving(false);
        game.getStack().unfreezeStack();

        // Advance to a certain phase, activating all triggered abilities
        if (advPhase != null) {
            game.getPhaseHandler().devAdvanceToPhase(advPhase);
        }

        if (removeSummoningSickness) {
            for (Card card : game.getCardsInGame()) {
                card.setSickness(false);
            }
        }

        game.getAction().checkStateEffects(true); //ensure state based effects and triggers are updated

        // prevent interactions with objects from old state
        game.copyLastState();

        // Store snapshot for restoring
        game.stashGameState();

        // Set negative or zero life after state effects if need be, important for some puzzles that rely on
        // pre-setting negative life (e.g. PS_NEO4).
        for (int i = 0; i < playerStates.size(); i++) {
            int life = playerStates.get(i).life;
            if (life <= 0) {
                game.getPlayers().get(i).setLife(life, null);
            }
        }
    }

    private String processManaPool(ManaPool manaPool) {
        StringBuilder mana = new StringBuilder();
        for (final byte c : ManaAtom.MANATYPES) {
            int amount = manaPool.getAmountOfColor(c);
            for (int i = 0; i < amount; i++) {
                mana.append(MagicColor.toShortString(c)).append(" ");
            }
        }

        return mana.toString().trim();
    }

    private void updateManaPool(Player p, String manaDef, boolean clearPool, boolean persistent) {
        Game game = p.getGame();
        if (clearPool) {
            p.getManaPool().clearPool(false);
        }

        if (!manaDef.isEmpty()) {
            final Card dummy = new Card(-777777, game);
            dummy.setOwner(p);
            final Map<String, String> produced = Maps.newHashMap();
            produced.put("Produced", manaDef);
            if (persistent) {
                produced.put("PersistentMana", "True");
            }
            final AbilityManaPart abMana = new AbilityManaPart(dummy, produced);
            game.getAction().invoke(() -> abMana.produceMana(null));
        }
    }

    private void handleCombat(final Game game, final Player attackingPlayer, final Player defendingPlayer, final boolean toDeclareBlockers) {
        // First we need to ensure that all attackers are declared in the Declare Attackers step,
        // even if proceeding straight to Declare Blockers
        game.getPhaseHandler().devModeSet(PhaseType.COMBAT_DECLARE_ATTACKERS, attackingPlayer, turn);

        if (game.getPhaseHandler().getCombat() == null) {
            game.getPhaseHandler().setCombat(new Combat(attackingPlayer));
            game.updateCombatForView();
        }

        Combat combat = game.getPhaseHandler().getCombat();
        for (Entry<Card, Card> attackMap : cardAttackMap.entrySet()) {
            Card attacker = attackMap.getKey();
            Card attacked = attackMap.getValue();

            combat.addAttacker(attacker, attacked == null ? defendingPlayer : attacked);
        }

        // Run the necessary combat events and triggers to set things up correctly as if the
        // attack was actually declared by the attacking player
        Multimap<GameEntity, Card> attackersMap = ArrayListMultimap.create();
        for (GameEntity ge : combat.getDefenders()) {
            attackersMap.putAll(ge, combat.getAttackersOf(ge));
        }
        game.fireEvent(new GameEventAttackersDeclared(attackingPlayer, attackersMap));

        for (final Card c : combat.getAttackers()) {
            CombatUtil.checkDeclaredAttacker(game, c, combat, false);
        }

        game.updateCombatForView();
        game.fireEvent(new GameEventCombatChanged());

        // Gracefully proceed to Declare Blockers, giving priority to the defending player,
        // but only if the stack is empty (otherwise the game will crash).
        game.getStack().addAllTriggeredAbilitiesToStack();
        if (toDeclareBlockers && game.getStack().isEmpty()) {
            game.getPhaseHandler().devAdvanceToPhase(PhaseType.COMBAT_DECLARE_BLOCKERS);
        }
    }

    private void handleRememberedEntities() {
        // Remembered: X
        for (Entry<Card, List<String>> rememberedEnts : cardToRememberedId.entrySet()) {
            Card c = rememberedEnts.getKey();
            List<String> ids = rememberedEnts.getValue();

            for (String id : ids) {
                Card tgt = idToCard.get(Integer.parseInt(id));
                c.addRemembered(tgt);
            }
        }

        // Imprinting: X
        for (Entry<Card, List<String>> imprintedCards : cardToImprintedId.entrySet()) {
            Card c = imprintedCards.getKey();
            List<String> ids = imprintedCards.getValue();

            for (String id : ids) {
                Card tgt = idToCard.get(Integer.parseInt(id));
                c.addImprintedCard(tgt);
            }
        }

        // Exiled with X
        for (Entry<Card, String> rememberedEnts : cardToExiledWithId.entrySet()) {
            Card c = rememberedEnts.getKey();
            String id = rememberedEnts.getValue();

            Card exiledWith = idToCard.get(Integer.parseInt(id));
            if (exiledWith != null) {
                exiledWith.addExiledCard(c);
                c.setExiledWith(exiledWith);
                c.setExiledBy(exiledWith.getController());
            }
        }
    }

    private int parseTargetInScript(final String tgtDef) {
        int tgtID;
        if (tgtDef.equalsIgnoreCase("human")) {
            tgtID = TARGET_HUMAN;
        } else if (tgtDef.equalsIgnoreCase("ai")) {
            tgtID = TARGET_AI;
        } else {
            tgtID = Integer.parseInt(tgtDef);
        }

        return tgtID;
    }

    private void handleScriptedTargetingForSA(final Game game, final SpellAbility sa, int tgtID) {
        Player human = game.getPlayers().get(0);
        Player ai = game.getPlayers().get(1);

        if (tgtID != TARGET_NONE) {
            switch (tgtID) {
                case TARGET_HUMAN:
                    sa.getTargets().add(human);
                    break;
                case TARGET_AI:
                    sa.getTargets().add(ai);
                    break;
                default:
                    sa.getTargets().add(idToCard.get(tgtID));
                    break;
            }
        }

        if (sa.hasParam("RememberTargets")) {
            sa.getHostCard().addRemembered(sa.getTargets());
        }
    }

    private void handleScriptExecution(final Game game) {
        for (Entry<Card, String> scriptPtr : cardToScript.entrySet()) {
            Card c = scriptPtr.getKey();
            String sPtr = scriptPtr.getValue();

            executeScript(game, c, sPtr);
        }
    }

    private void executeScript(Game game, Card c, String sPtr) {
        executeScript(game, c, sPtr, false);
    }
    private void executeScript(Game game, Card c, String sPtr, boolean putOnStack) {
        int tgtID = TARGET_NONE;
        if (sPtr.contains("->")) {
            String tgtDef = sPtr.substring(sPtr.lastIndexOf("->") + 2);

            tgtID = parseTargetInScript(tgtDef);
            sPtr = sPtr.substring(0, sPtr.lastIndexOf("->"));
        }

        SpellAbility sa = null;
        if (StringUtils.isNumeric(sPtr)) {
            int numSA = Integer.parseInt(sPtr);
            if (c.getSpellAbilities().size() >= numSA) {
                sa = c.getSpellAbilities().get(numSA);
            } else {
                System.err.println("ERROR: Unable to find SA with index " + numSA + " on card " + c + " to execute!");
            }
        } else {
            // Special handling for keyworded abilities
            if (sPtr.startsWith("KW#")) {
                String kwName = sPtr.substring(3);
                FCollectionView<SpellAbility> saList = c.getSpellAbilities();

                if (kwName.equals("Awaken") || kwName.equals("AwakenOnly")) {
                    // AwakenOnly only creates the Awaken effect, while Awaken precasts the whole spell with Awaken
                    for (SpellAbility ab : saList) {
                        if (ab.getDescription().startsWith("Awaken")) {
                            ab.setActivatingPlayer(c.getController());
                            // target for Awaken is set in its first subability
                            handleScriptedTargetingForSA(game, ab.getSubAbility(), tgtID);
                            sa = kwName.equals("AwakenOnly") ? ab.getSubAbility() : ab;
                        }
                    }
                    if (sa == null) {
                        System.err.println("ERROR: Could not locate keyworded ability Awaken in card " + c + " to execute!");
                        return;
                    }
                }
            } else {
                // SVar-based script execution
                String svarValue = "";

                if (sPtr.startsWith("CustomScript:")) {
                    // A custom line defined in the game state file
                    svarValue = sPtr.substring(sPtr.indexOf(":") + 1);
                } else {
                    // A SVar from the card script file
                    if (!c.hasSVar(sPtr)) {
                        System.err.println("ERROR: Unable to find SVar " + sPtr + " on card " + c + " + to execute!");
                        return;
                    }

                    svarValue = c.getSVar(sPtr);

                    if (tgtID != TARGET_NONE && svarValue.contains("| Defined$")) {
                        // We want a specific target, so try to undefine a predefined target if possible
                        svarValue = TextUtil.fastReplace(svarValue, "| Defined$", "| Undefined$");
                        if (tgtID == TARGET_HUMAN || tgtID == TARGET_AI) {
                            svarValue += " | ValidTgts$ Player";
                        } else {
                            svarValue += " | ValidTgts$ Card";
                        }
                    }
                }

                sa = AbilityFactory.getAbility(svarValue, c);
                if (sa == null) {
                    System.err.println("ERROR: Unable to generate ability for SVar " + svarValue);
                }
            }
        }

        if (sa != null) {
            sa.setActivatingPlayer(c.getController());
        }
        handleScriptedTargetingForSA(game, sa, tgtID);

        if (putOnStack) {
            game.getStack().addAndUnfreeze(sa);
        } else {
            sa.resolve();

            // resolve subabilities
            SpellAbility subSa = sa.getSubAbility();
            while (subSa != null) {
                subSa.resolve();
                subSa = subSa.getSubAbility();
            }
        }
    }

    private void handlePrecastSpells(final Game game) {
        for (int i = 0; i < playerStates.size(); i++) {
            if (playerStates.get(i).precast != null) {
                String[] spellList = TextUtil.split(playerStates.get(i).precast, ';');
                for (String spell : spellList) {
                    precastSpellFromCard(spell, game.getPlayers().get(i), game);
                }
            }
        }
    }

    private void handleAddSAsToStack(final Game game) {
        for (int i = 0; i < playerStates.size(); i++) {
            if (playerStates.get(i).putOnStack != null) {
                String[] spellList = TextUtil.split(playerStates.get(i).putOnStack, ';');
                for (String spell : spellList) {
                    precastSpellFromCard(spell, game.getPlayers().get(i), game, true);
                }
            }
        }
    }

    private void precastSpellFromCard(String spellDef, final Player activator, final Game game) {
        precastSpellFromCard(spellDef, activator, game, false);
    }
    private void precastSpellFromCard(String spellDef, final Player activator, final Game game, final boolean putOnStack) {
        int tgtID = TARGET_NONE;
        String scriptID = "";

        if (spellDef.contains(":")) {
            // targeting via -> will be handled in executeScript
            scriptID = spellDef.substring(spellDef.indexOf(":") + 1).trim();
            spellDef = spellDef.substring(0, spellDef.indexOf(":")).trim();
        } else if (spellDef.contains("->")) {
            String tgtDef = spellDef.substring(spellDef.indexOf("->") + 2).trim();
            tgtID = parseTargetInScript(tgtDef);
            spellDef = spellDef.substring(0, spellDef.indexOf("->")).trim();
        }

        spellDef = spellDef.replace("^", ":"); // alternate marker for when : is the name of the card

        Card c = null;

        if (StringUtils.isNumeric(spellDef)) {
            // Precast from a specific host
            c = idToCard.get(Integer.parseInt(spellDef));
            if (c == null) {
                System.err.println("ERROR: Could not find a card with ID " + spellDef + " to precast!");
                return;
            }
        } else {
            // Precast from a card by name
            PaperCard pc = StaticData.instance().getCommonCards().getCard(spellDef);

            if (pc == null) {
                System.err.println("ERROR: Could not find a card with name " + spellDef + " to precast!");
                return;
            }

            c = Card.fromPaperCard(pc, activator);
        }

        SpellAbility sa = null;

        if (!scriptID.isEmpty()) {
            executeScript(game, c, scriptID, putOnStack);
            return;
        }

        if (!c.getName().equals(spellDef) && c.hasAlternateState() && spellDef.equals(c.getAlternateState().getName())) {
            sa = c.getAlternateState().getFirstSpellAbility();
        } else {
            sa = c.getFirstSpellAbility();
        }

        sa.setActivatingPlayer(activator);

        handleScriptedTargetingForSA(game, sa, tgtID);

        if (putOnStack) {
            game.getStack().addAndUnfreeze(sa);
        } else {
            sa.resolve();
        }
    }

    private void handleMarkedDamage() {
        for (Entry<Card, Integer> entry : markedDamage.entrySet()) {
            Card c = entry.getKey();
            Integer dmg = entry.getValue();

            c.setDamage(dmg);
        }
    }

    private void handleChosenEntities() {
        // TODO: the AI still gets to choose something (and the notification box pops up) before the
        // choice is overwritten here. Somehow improve this so that there is at least no notification
        // about the choice that will be force-changed anyway.

        // Chosen colors
        for (Entry<Card, List<String>> entry : cardToChosenClrs.entrySet()) {
            Card c = entry.getKey();
            List<String> colors = entry.getValue();

            c.setChosenColors(colors);
        }

        // Chosen type
        for (Entry<Card, String> entry : cardToChosenType.entrySet()) {
            Card c = entry.getKey();
            c.setChosenType(entry.getValue());
        }

        // Chosen type 2
        for (Entry<Card, String> entry : cardToChosenType2.entrySet()) {
            Card c = entry.getKey();
            c.setChosenType2(entry.getValue());
        }

        // Named card
        for (Entry<Card, List<String>> entry : cardToNamedCard.entrySet()) {
            Card c = entry.getKey();
            for (String s : entry.getValue()) {
                c.addNamedCard(s);
            }
        }

        // Chosen cards
        for (Entry<Card, CardCollection> entry : cardToChosenCards.entrySet()) {
            Card c = entry.getKey();
            c.setChosenCards(entry.getValue());
        }
    }

    private void handleCardAttachments() {
        // Unattach all permanents first
        for (Entry<Card, Integer> entry : cardToAttachId.entrySet()) {
            Card attachedTo = idToCard.get(entry.getValue());
            attachedTo.unAttachAllCards(attachedTo);
        }

        // Attach permanents by ID
        for (Entry<Card, Integer> entry : cardToAttachId.entrySet()) {
            Card attachedTo = idToCard.get(entry.getValue());
            Card attacher = entry.getKey();
            if (attacher.isAttachment()) {
                attacher.attachToEntity(attachedTo, null, true);
            }
        }

        // Enchant players
        for (Entry<Card, Player> entry : cardToEnchantPlayerId.entrySet()) {
            entry.getKey().attachToEntity(entry.getValue(), null);
        }
    }

    private void handleMergedCards() {
        for (Entry<Card, List<String>> entry : cardToMergedCards.entrySet()) {
            Card mergedTo = entry.getKey();
            for (String mergedCardName : entry.getValue()) {
                Card c;
                PaperCard pc = StaticData.instance().getCommonCards().getCard(mergedCardName. replace("^", ","));
                if (pc == null) {
                    System.err.println("ERROR: Tried to create a non-existent card named " + mergedCardName + " (as a merged card) when loading game state!");
                    continue;
                }

                c = Card.fromPaperCard(pc, mergedTo.getOwner());
                emulateMergeViaMutate(mergedTo, c);
            }
        }
    }

    private void emulateMergeViaMutate(Card top, Card bottom) {
        if (top == null || bottom == null) {
            System.err.println("ERROR: Tried to call emulateMergeViaMutate with a null card!");
            return;
        }

        Game game = top.getGame();

        bottom.setMergedToCard(top);
        if (!top.hasMergedCard()) {
            top.addMergedCard(top);
        }
        top.addMergedCard(bottom);

        top.removeMutatedStates();

        final long ts = game.getNextTimestamp();
        top.setMutatedTimestamp(ts);
        if (top.getCurrentStateName() != CardStateName.FaceDown) {
            final CardCloneStates mutatedStates = CardFactory.getMutatedCloneStates(top, null/*FIXME*/);
            top.addCloneState(mutatedStates, ts);
        }
        bottom.setTapped(top.isTapped());
        bottom.setFlipped(top.isFlipped());
        top.setTimesMutated(top.getTimesMutated() + 1);
        top.updateTokenView();

        // TODO: Merged commanders aren't supported yet
    }

    private void applyCountersToGameEntity(GameEntity entity, String counterString) {
        entity.setCounters(Maps.newHashMap());
        String[] allCounterStrings = counterString.split(",");
        for (final String counterPair : allCounterStrings) {
            String[] pair = counterPair.split("=", 2);
            entity.addCounterInternal(CounterType.getType(pair[0]), Integer.parseInt(pair[1]), null, false, null, null);
        }
    }

    private void setupPlayerState(final Player p, final PlayerState state) {
        // Lock check static as we setup player state

        // Clear all zones first, this ensures that any lingering cards and effects (e.g. in command zone) get cleared up
        // before setting up a new state
        for (ZoneType zt : ZONES.keySet()) {
            p.getZone(zt).removeAllCards(true);
        }

        p.getCommanders().clear();
        p.clearTheRing();

        Map<ZoneType, CardCollectionView> playerCards = new EnumMap<>(ZoneType.class);
        for (Entry<ZoneType, String> kv : state.cardTexts.entrySet()) {
            String value = kv.getValue();
            playerCards.put(kv.getKey(), processCardsForZone(value.isEmpty() ? new String[0] : value.split(";"), p));
        }

        if (state.life >= 0) p.setLife(state.life, null);
        p.setLandsPlayedThisTurn(state.landsPlayed);
        p.setLandsPlayedLastTurn(state.landsPlayedLastTurn);
        p.setNumRingTemptedYou(state.numRingTemptedYou);
        p.setSpeed(state.speed);

        p.clearPaidForSA();

        for (Entry<ZoneType, CardCollectionView> kv : playerCards.entrySet()) {
            PlayerZone zone = p.getZone(kv.getKey());
            if (kv.getKey() == ZoneType.Battlefield) {
                List<Card> cards = new ArrayList<>();
                for (final Card c : kv.getValue()) {
                    if (c.isToken()) {
                        cards.add(c);
                    }
                }
                zone.setCards(cards);
                for (final Card c : kv.getValue()) {
                    if (c.isToken()) {
                        continue;
                    }
                    boolean tapped = c.isTapped();
                    boolean sickness = c.hasSickness();
                    Map<CounterType, Integer> counters = c.getCounters();
                    // Note: Not clearCounters() since we want to keep the counters var as-is.
                    c.setCounters(Maps.newHashMap());
                    if (c.isAura()) {
                        // dummy "enchanting" to indicate that the card will be force-attached elsewhere
                        // (will be overridden later, so the actual value shouldn't matter)

                        //FIXME it shouldn't be able to attach itself
                        c.setEntityAttachedTo(new CardCopyService(c).copyCard(true));
                    }

                    if (cardsWithoutETBTrigs.contains(c)) {
                        p.getGame().getAction().moveTo(ZoneType.Battlefield, c, null, null);
                    } else {
                        p.getZone(ZoneType.Hand).add(c);
                        p.getGame().getAction().moveToPlay(c, null, null);
                    }

                    c.setTapped(tapped);
                    c.setSickness(sickness);
                    c.setCounters(counters);
                }
            } else {
                zone.setCards(kv.getValue());
            }
        }
        if (!p.getCommanders().isEmpty())
            p.createCommanderEffect(); //Original one was lost, and the one made by addCommander would have been erased by setCards.

        updateManaPool(p, state.manaPool, true, false);
        updateManaPool(p, state.persistentMana, false, true);

        if (!state.counters.isEmpty()) {
            applyCountersToGameEntity(p, state.counters);
        }
        if (state.numRingTemptedYou > 0) {
            //setup all levels
            for (int i = 1; i <= state.numRingTemptedYou; i++) {
                if (i > 4)
                    break;
                p.setRingLevel(i);
            }
        }
        if (state.speed > 0) p.createSpeedEffect();
    }

    /**
     * <p>
     * processCardsForZone.
     * </p>
     *
     * @param data
     *            an array of {@link java.lang.String} objects.
     * @param player
     *            a {@link forge.game.player.Player} object.
     * @return a {@link CardCollectionView} object.
     */
    private CardCollectionView processCardsForZone(final String[] data, final Player player) {
        final CardCollection cl = new CardCollection();
        for (final String element : data) {
            final String[] cardinfo = element.trim().split("\\|");

            String setCode = null;
            for (final String info : cardinfo) {
                if (info.startsWith("Set:")) {
                    setCode = info.substring(info.indexOf(':') + 1);
                    break;
                }
            }

            int artID = -1;
            for (final String info : cardinfo) {
                if (info.startsWith("Art:")) {
                    try {
                        artID = Integer.parseInt(info.substring(info.indexOf(':') + 1));
                    } catch (Exception e) {
                        break;
                    }
                    break;
                }
            }

            Card c;
            boolean hasSetCurSet = false;
            if (cardinfo[0].startsWith("t:")) {
                // TODO Make sure Game State conversion works with new tokens
                String tokenStr = cardinfo[0].substring(2);
                c = new TokenInfo(tokenStr).makeOneToken(player);
            } else if (cardinfo[0].startsWith("T:")) {
                String tokenStr = cardinfo[0].substring(2);
                PaperToken token = StaticData.instance().getAllTokens().getToken(tokenStr,
                        setCode != null ? setCode : CardEdition.UNKNOWN_CODE);
                if (token == null) {
                    System.err.println("ERROR: Tried to create a non-existent token named " + cardinfo[0] + " when loading game state!");
                    continue;
                }
                c = CardFactory.getCard(token, player, player.getGame());
            } else {
                PaperCard pc = StaticData.instance().getCommonCards().getCard(cardinfo[0], setCode, artID);
                if (pc == null) {
                    System.err.println("ERROR: Tried to create a non-existent card named " + cardinfo[0] + " (set: " + (setCode == null ? "any" : setCode) + ") when loading game state!");
                    continue;
                }

                c = Card.fromPaperCard(pc, player);
                if (setCode != null) {
                    hasSetCurSet = true;
                }
            }
            c.setSickness(false);

            for (final String info : cardinfo) {
                if (info.startsWith("Tapped")) {
                    c.tap(false, null, null);
                } else if (info.startsWith("Renowned")) {
                    c.setRenowned(true);
                } else if (info.startsWith("Solved")) {
                    c.setSolved(true);
                } else if (info.startsWith("Saddled")) {
                    c.setSaddled(true);
                } else if (info.startsWith("Suspected")) {
                    c.setSuspected(true);
                } else if (info.startsWith("Monstrous")) {
                    c.setMonstrous(true);
                } else if (info.startsWith("PhasedOut")) {
                    String tgt = info.substring(info.indexOf(':') + 1);
                    c.setPhasedOut(parsePlayerString(player.getGame(), tgt));
                } else if (info.startsWith("Counters:")) {
                    applyCountersToGameEntity(c, info.substring(info.indexOf(':') + 1));
                } else if (info.startsWith("SummonSick")) {
                    c.setSickness(true);
                } else if (info.startsWith("FaceDown")) {
                    c.turnFaceDown(true);
                    if (info.endsWith("Manifested")) {
                        c.setManifested(new SpellAbility.EmptySa(ApiType.Manifest, c));
                    }
                    if (info.endsWith("Cloaked")) {
                        c.setCloaked(new SpellAbility.EmptySa(ApiType.Cloak, c));
                    }
                } else if (info.startsWith("Transformed") || info.startsWith("Modal")) {
                    c.setState(CardStateName.Backside, true);
                    c.setBackSide(true);
                } else if (info.startsWith("Flipped")) {
                    c.setState(CardStateName.Flipped, true);
                } else if (info.startsWith("Meld")) {
                    if (info.indexOf(':') > 0) {
                        String meldCardName = info.substring(info.indexOf(':') + 1).replace("^", ",");
                        Card meldTarget;
                        PaperCard pc = StaticData.instance().getCommonCards().getCard(meldCardName);
                        if (pc == null) {
                            System.err.println("ERROR: Tried to create a non-existent card named " + meldCardName + " (as a MeldedWith card) when loading game state!");
                            continue;
                        }
                        meldTarget = Card.fromPaperCard(pc, c.getOwner());
                        c.setMeldedWith(meldTarget);
                    }
                    c.setState(CardStateName.Meld, true);
                    c.setBackSide(true);
                }
                else if (info.startsWith("OnAdventure")) {
                    String abAdventure = "DB$ Effect | RememberObjects$ Self | StaticAbilities$ Play | ForgetOnMoved$ Exile | Duration$ Permanent | ConditionDefined$ Self | ConditionPresent$ Card.!copiedSpell";
                    SpellAbility saAdventure = AbilityFactory.getAbility(abAdventure, c);
                    StringBuilder sbPlay = new StringBuilder();
                    sbPlay.append("Mode$ Continuous | MayPlay$ True | EffectZone$ Command | Affected$ Card.IsRemembered+nonAdventure");
                    sbPlay.append(" | AffectedZone$ Exile | Description$ You may cast the card.");
                    saAdventure.setSVar("Play", sbPlay.toString());
                    saAdventure.setActivatingPlayer(c.getOwner());
                    saAdventure.resolve();
                    c.setExiledWith(c); // This seems to be the way it's set up internally. Potentially not needed here?
                    c.setExiledBy(c.getController());
                } else if (info.startsWith("IsCommander")) {
                    player.addCommander(c);
                } else if (info.startsWith("IsRingBearer")) {
                    c.setRingBearer(true);
                    player.setRingBearer(c);
                } else if (info.startsWith("Id:")) {
                    int id = Integer.parseInt(info.substring(3));
                    idToCard.put(id, c);
                } else if (info.startsWith("Attaching:") /*deprecated*/ || info.startsWith("AttachedTo:")) {
                    int id = Integer.parseInt(info.substring(info.indexOf(':') + 1));
                    cardToAttachId.put(c, id);
                } else if (info.startsWith("EnchantingPlayer:")) {
                    String tgt = info.substring(info.indexOf(':') + 1);
                    cardToEnchantPlayerId.put(c, parsePlayerString(player.getGame(), tgt));
                } else if (info.startsWith("Owner:")) {
                    String owner = info.substring(info.indexOf(':') + 1);
                    Player controller = c.getController();
                    c.setOwner(parsePlayerString(player.getGame(), owner));
                    c.setController(controller, c.getGame().getNextTimestamp());
                } else if (info.startsWith("Ability:")) {
                    String abString = info.substring(info.indexOf(':') + 1).toLowerCase();
                    c.addSpellAbility(AbilityFactory.getAbility(abilityString.get(abString), c));
                } else if (info.startsWith("Damage:")) {
                    int dmg = Integer.parseInt(info.substring(info.indexOf(':') + 1));
                    markedDamage.put(c, dmg);
                } else if (info.startsWith("ChosenColor:")) {
                    cardToChosenClrs.put(c, Arrays.asList(info.substring(info.indexOf(':') + 1).split(",")));
                } else if (info.startsWith("ChosenType:")) {
                    cardToChosenType.put(c, info.substring(info.indexOf(':') + 1));
                } else if (info.startsWith("ChosenType2:")) {
                    cardToChosenType2.put(c, info.substring(info.indexOf(':') + 1));
                } else if (info.startsWith("ChosenCards:")) {
                    CardCollection chosen = new CardCollection();
                    String[] idlist = info.substring(info.indexOf(':') + 1).split(",");
                    for (String id : idlist) {
                        chosen.add(idToCard.get(Integer.parseInt(id)));
                    }
                    cardToChosenCards.put(c, chosen);
                } else if (info.startsWith("MergedCards:")) {
                    List<String> cardNames = Arrays.asList(info.substring(info.indexOf(':') + 1).split(","));
                    cardToMergedCards.put(c, cardNames);
                } else if (info.startsWith("NamedCard:")) {
                    List<String> cardNames = Arrays.asList(info.substring(info.indexOf(':') + 1).split(","));
                    cardToNamedCard.put(c, cardNames);
                } else if (info.startsWith("ExecuteScript:")) {
                    cardToScript.put(c, info.substring(info.indexOf(':') + 1));
                } else if (info.startsWith("RememberedCards:")) {
                    cardToRememberedId.put(c, Arrays.asList(info.substring(info.indexOf(':') + 1).split(",")));
                } else if (info.startsWith("Imprinting:")) {
                    cardToImprintedId.put(c, Arrays.asList(info.substring(info.indexOf(':') + 1).split(",")));
                } else if (info.startsWith("ExiledWith:")) {
                    cardToExiledWithId.put(c, info.substring(info.indexOf(':') + 1));
                } else if (info.startsWith("Attacking")) {
                    if (info.contains(":")) {
                        int id = Integer.parseInt(info.substring(info.indexOf(':') + 1));
                        cardAttackMap.put(c, idToCard.get(id));
                    } else {
                        cardAttackMap.put(c, null);
                    }
                } else if (info.equals("NoETBTrigs")) {
                    cardsWithoutETBTrigs.add(c);
                } else if (info.equals("Foretold")) {
                    c.setForetold(true);
                    c.turnFaceDown(true);
                    c.addMayLookFaceDownExile(c.getOwner());
                } else if (info.equals("ForetoldThisTurn")) {
                    c.setTurnInZone(turn);
                } else if (info.equals("IsToken")) {
                    c.setGamePieceType(GamePieceType.TOKEN);
                } else if (info.startsWith("ClassLevel:")) {
                    c.setClassLevel(Integer.parseInt(info.substring(info.indexOf(':') + 1)));
                } else if (info.startsWith("UnlockedRoom:")) {
                    c.unlockRoom(c.getController(), CardStateName.smartValueOf(info.substring(info.indexOf(':') + 1)));
                }
            }

            if (!hasSetCurSet && !c.isToken()) {
                c.setSetCode(c.getMostRecentSet());
            }

            cl.add(c);
        }
        return cl;
    }
}
```

## Python
`forge/ai/GameState.py`

```python
from forge.StaticData import StaticData
from forge.card.CardEdition import CardEdition
from forge.card.CardStateName import CardStateName
from forge.card.GamePieceType import GamePieceType
from forge.card.MagicColor import MagicColor
from forge.card.mana.ManaAtom import ManaAtom
from forge.game.Game import Game
from forge.game.GameEntity import GameEntity
from forge.game.ability.AbilityFactory import AbilityFactory
from forge.game.ability.ApiType import ApiType
from forge.game.ability.effects.DetachedCardEffect import DetachedCardEffect
from forge.game.card.Card import Card
from forge.game.card.CardCloneStates import CardCloneStates
from forge.game.card.CardCollection import CardCollection
from forge.game.card.CardCollectionView import CardCollectionView
from forge.game.card.CardCopyService import CardCopyService
from forge.game.card.CardFactory import CardFactory
from forge.game.card.CounterType import CounterType
from forge.game.card.token.TokenInfo import TokenInfo
from forge.game.combat.Combat import Combat
from forge.game.combat.CombatUtil import CombatUtil
from forge.game.event.GameEventAttackersDeclared import GameEventAttackersDeclared
from forge.game.event.GameEventCombatChanged import GameEventCombatChanged
from forge.game.mana.ManaPool import ManaPool
from forge.game.phase.PhaseType import PhaseType
from forge.game.player.Player import Player
from forge.game.spellability.AbilityManaPart import AbilityManaPart
from forge.game.spellability.SpellAbility import SpellAbility
from forge.game.zone.PlayerZone import PlayerZone
from forge.game.zone.ZoneType import ZoneType
from forge.item.IPaperCard import IPaperCard
from forge.item.PaperCard import PaperCard
from forge.item.PaperToken import PaperToken
from forge.util.TextUtil import TextUtil
from forge.util.collect.FCollectionView import FCollectionView

import sys
from abc import ABC, abstractmethod
from io import BufferedReader, TextIOWrapper


class GameState(ABC):
    ZONES: dict[ZoneType, str] = {}
    ZONES[ZoneType.Battlefield] = "battlefield"
    ZONES[ZoneType.Hand] = "hand"
    ZONES[ZoneType.Graveyard] = "graveyard"
    ZONES[ZoneType.Library] = "library"
    ZONES[ZoneType.Exile] = "exile"
    ZONES[ZoneType.Command] = "command"
    ZONES[ZoneType.Sideboard] = "sideboard"

    class PlayerState:
        def __init__(self):
            self.life = -1
            self.counters = ""
            self.manaPool = ""
            self.persistentMana = ""
            self.landsPlayed = 0
            self.landsPlayedLastTurn = 0
            self.numRingTemptedYou = 0
            self.speed = 0
            self.precast = None
            self.putOnStack = None
            self.cardTexts: dict[ZoneType, str] = {}

    def __init__(self):
        self.playerStates: list[GameState.PlayerState] = []

        self.puzzleCreatorState = False

        self.idToCard: dict[int, Card] = {}
        self.cardToAttachId: dict[Card, int] = {}
        self.cardToEnchantPlayerId: dict[Card, Player] = {}
        self.markedDamage: dict[Card, int] = {}
        self.cardToChosenClrs: dict[Card, list[str]] = {}
        self.cardToChosenCards: dict[Card, CardCollection] = {}
        self.cardToChosenType: dict[Card, str] = {}
        self.cardToChosenType2: dict[Card, str] = {}
        self.cardToRememberedId: dict[Card, list[str]] = {}
        self.cardToImprintedId: dict[Card, list[str]] = {}
        self.cardToMergedCards: dict[Card, list[str]] = {}
        self.cardToNamedCard: dict[Card, list[str]] = {}
        self.cardToExiledWithId: dict[Card, str] = {}
        self.cardAttackMap: dict[Card, Card] = {}

        self.cardToScript: dict[Card, str] = {}

        self.abilityString: dict[str, str] = {}

        self.cardsReferencedByID: set[Card] = set()
        self.cardsWithoutETBTrigs: set[Card] = set()

        self.tChangePlayer = "NONE"
        self.tChangePhase = "NONE"

        self.tAdvancePhase = "NONE"

        self.turn = 1

        self.removeSummoningSickness = False

        # Targeting for precast spells in a game state (mostly used by Puzzle Mode game states)
        self.TARGET_NONE = -1  # untargeted spell (e.g. Joraga Invocation)
        self.TARGET_HUMAN = -2
        self.TARGET_AI = -3

    @abstractmethod
    def getPaperCard(self, cardName: str, setCode: str, artID: int) -> IPaperCard:
        ...

    def toString(self) -> str:
        sb = []

        if self.puzzleCreatorState:
            # append basic puzzle metadata if we're dumping from the puzzle creator screen
            sb.append("[metadata]\n")
            sb.append("Name:New Puzzle\n")
            sb.append("URL:https://www.cardforge.org\n")
            sb.append("Goal:Win\n")
            sb.append("Turns:1\n")
            sb.append("Difficulty:Common\n")
            sb.append("Description:Win this turn.\n")
            sb.append("[state]\n")

        sb.append(TextUtil.concatNoSpace("turn=", str(self.turn), "\n"))
        sb.append(TextUtil.concatNoSpace("activeplayer=", self.tChangePlayer, "\n"))
        sb.append(TextUtil.concatNoSpace("activephase=", self.tChangePhase, "\n"))

        playerIndex = 0
        for p in self.playerStates:
            prefix = "p" + str(playerIndex)
            playerIndex += 1
            sb.append(TextUtil.concatNoSpace(prefix + "life=", str(p.life), "\n"))
            sb.append(TextUtil.concatNoSpace(prefix + "landsplayed=", str(p.landsPlayed), "\n"))
            sb.append(TextUtil.concatNoSpace(prefix + "landsplayedlastturn=", str(p.landsPlayedLastTurn), "\n"))
            sb.append(TextUtil.concatNoSpace(prefix + "numringtemptedyou=", str(p.numRingTemptedYou), "\n"))
            sb.append(TextUtil.concatNoSpace(prefix + "speed=", str(p.speed), "\n"))
            if p.counters:
                sb.append(TextUtil.concatNoSpace(prefix + "counters=", p.counters, "\n"))
            if p.manaPool:
                sb.append(TextUtil.concatNoSpace(prefix + "manapool=", p.manaPool, "\n"))
            if p.persistentMana:
                sb.append(TextUtil.concatNoSpace(prefix + "persistentmana=", p.persistentMana, "\n"))
            self.appendCards(p.cardTexts, prefix, sb)
        return "".join(sb)

    def appendCards(self, cardTexts: dict[ZoneType, str], categoryPrefix: str, sb: list) -> None:
        for key, value in cardTexts.items():
            sb.append(TextUtil.concatNoSpace(categoryPrefix, GameState.ZONES.get(key), "=", value, "\n"))

    def initFromGame(self, game: Game) -> None:
        self.playerStates.clear()
        for player in game.getPlayers():
            p = GameState.PlayerState()
            p.life = player.getLife()
            p.landsPlayed = player.getLandsPlayedThisTurn()
            p.landsPlayedLastTurn = player.getLandsPlayedLastTurn()
            p.counters = self.countersToString(player.getCounters())
            p.manaPool = self.processManaPool(player.getManaPool())
            p.numRingTemptedYou = player.getNumRingTemptedYou()
            p.speed = player.getSpeed()
            self.playerStates.append(p)

        self.tChangePlayer = "p" + str(game.getPlayers().indexOf(game.getPhaseHandler().getPlayerTurn()))
        self.tChangePhase = game.getPhaseHandler().getPhase().toString()
        self.turn = game.getPhaseHandler().getTurn()

        # Mark the cards that need their ID remembered for various reasons
        self.cardsReferencedByID.clear()
        for zone in GameState.ZONES.keys():
            for card in game.getCardsIncludePhasingIn(zone):
                if card.getExiledWith() is not None:
                    # Remember the ID of the card that exiled this card
                    self.cardsReferencedByID.add(card.getExiledWith())
                if zone == ZoneType.Battlefield:
                    if not card.getAllAttachedCards().isEmpty():
                        # Remember the ID of cards that have attachments
                        self.cardsReferencedByID.add(card)
                for o in card.getRemembered():
                    # Remember the IDs of remembered cards
                    if isinstance(o, Card):
                        self.cardsReferencedByID.add(o)
                for i in card.getImprintedCards():
                    # Remember the IDs of imprinted cards
                    self.cardsReferencedByID.add(i)
                for i in card.getChosenCards():
                    # Remember the IDs of chosen cards
                    self.cardsReferencedByID.add(i)
                if game.getCombat() is not None and game.getCombat().isAttacking(card):
                    # Remember the IDs of attacked planeswalkers
                    defn = game.getCombat().getDefenderByAttacker(card)
                    if isinstance(defn, Card):
                        self.cardsReferencedByID.add(defn)

        for zone in GameState.ZONES.keys():
            # Init texts to empty, so that restoring will clear the state
            # if the zone had no cards in it (e.g. empty hand).
            for p in self.playerStates:
                p.cardTexts[zone] = ""
            for card in game.getCardsIncludePhasingIn(zone):
                if card.getName() == "Puzzle Goal" and "New Puzzle" in card.getOracleText():
                    self.puzzleCreatorState = True
                if isinstance(card, DetachedCardEffect):
                    continue
                playerIndex = game.getPlayers().indexOf(card.getZone().getPlayer())
                self.addCard(zone, self.playerStates[playerIndex].cardTexts, card)

    def getPlayerString(self, p: Player) -> str:
        return "P" + str(p.getGame().getPlayers().indexOf(p))

    def parsePlayerString(self, game: Game, str_: str) -> Player:
        if str_.lower() == "human":
            return game.getPlayers().get(0)
        elif str_.lower() == "ai":
            return game.getPlayers().get(1)
        elif str_.startswith("P") and str_[1].isdigit():
            return game.getPlayers().get(int(str_[1]))
        else:
            return game.getPlayers().get(0)

    def addCard(self, zoneType: ZoneType, cardTexts: dict[ZoneType, str], c: Card) -> None:
        newText = [cardTexts.get(zoneType)]
        if len("".join(newText)) > 0:
            newText.append(";")
        if c.isToken():
            newText.append("t:")
            newText.append(str(TokenInfo(c)))
        else:
            if c.getPaperCard() is None:
                return

            if c.hasMergedCard():
                suffix = "+" if c.getTopMergedCard().hasPaperFoil() else ""
                # we have to go by the current top card name here
                newText.append(c.getTopMergedCard().getPaperCard().getName())
                newText.append(suffix)
                newText.append("|Set:")
                newText.append(str(c.getTopMergedCard().getPaperCard().getEdition()))
                newText.append("|Art:")
                newText.append(str(c.getTopMergedCard().getPaperCard().getArtIndex()))
            else:
                suffix = "+" if c.hasPaperFoil() else ""
                newText.append(c.getPaperCard().getName())
                newText.append(suffix)
                newText.append("|Set:")
                newText.append(str(c.getPaperCard().getEdition()))
                newText.append("|Art:")
                newText.append(str(c.getPaperCard().getArtIndex()))
        if c.isCommander():
            newText.append("|IsCommander")
        if c.isRingBearer():
            newText.append("|IsRingBearer")

        if c in self.cardsReferencedByID:
            newText.append("|Id:")
            newText.append(str(c.getId()))

        if zoneType == ZoneType.Battlefield:
            if c.getOwner() != c.getController():
                newText.append("|Owner:")
                newText.append(self.getPlayerString(c.getOwner()))
            if c.isTapped():
                newText.append("|Tapped")
            if c.isSick():
                newText.append("|SummonSick")
            if c.isRenowned():
                newText.append("|Renowned")
            if c.isSolved():
                newText.append("|Solved")
            if c.isSuspected():
                newText.append("|Suspected")
            if c.isMonstrous():
                newText.append("|Monstrous")
            if c.isPhasedOut():
                newText.append("|PhasedOut:")
                newText.append(self.getPlayerString(c.getPhasedOut()))
            if c.isFaceDown():
                newText.append("|FaceDown")
                if c.isManifested():
                    newText.append(":Manifested")
                if c.isCloaked():
                    newText.append(":Cloaked")
            if c.getCurrentStateName() == CardStateName.Flipped:
                newText.append("|Flipped")
            elif c.getCurrentStateName() == CardStateName.Meld:
                newText.append("|Meld")
                if c.getMeldedWith() is not None:
                    suffix = "+" if c.getMeldedWith().hasPaperFoil() else ""
                    newText.append(":")
                    newText.append(c.getMeldedWith().getName())
                    newText.append(suffix)
            elif c.getCurrentStateName() == CardStateName.Backside:
                if c.isModal():
                    newText.append("|Modal")
                else:
                    newText.append("|Transformed")

            if c.getPlayerAttachedTo() is not None:
                newText.append("|EnchantingPlayer:")
                newText.append(self.getPlayerString(c.getPlayerAttachedTo()))
            elif c.isAttachedToEntity():
                newText.append("|AttachedTo:")
                newText.append(str(c.getEntityAttachedTo().getId()))

            if c.getDamage() > 0:
                newText.append("|Damage:")
                newText.append(str(c.getDamage()))

            if c.hasChosenColor():
                newText.append("|ChosenColor:")
                newText.append(TextUtil.join(c.getChosenColors(), ","))
            if c.hasChosenType():
                newText.append("|ChosenType:")
                newText.append(c.getChosenType())
            if c.hasChosenType2():
                newText.append("|ChosenType2:")
                newText.append(c.getChosenType2())
            if not c.getNamedCard().isEmpty():
                newText.append("|NamedCard:")
                newText.append(c.getNamedCard())

            chosenCardIds = []
            for obj in c.getChosenCards():
                chosenCardIds.append(str(obj.getId()))
            if chosenCardIds:
                newText.append("|ChosenCards:")
                newText.append(TextUtil.join(chosenCardIds, ","))

            rememberedCardIds = []
            for obj in c.getRemembered():
                if isinstance(obj, Card):
                    id_ = obj.getId()
                    rememberedCardIds.append(str(id_))
            if rememberedCardIds:
                newText.append("|RememberedCards:")
                newText.append(TextUtil.join(rememberedCardIds, ","))

            imprintedCardIds = []
            for impr in c.getImprintedCards():
                id_ = impr.getId()
                imprintedCardIds.append(str(id_))
            if imprintedCardIds:
                newText.append("|Imprinting:")
                newText.append(TextUtil.join(imprintedCardIds, ","))

            if c.hasMergedCard():
                mergedCardNames = []
                for merged in c.getMergedCards():
                    if c.getTopMergedCard() == merged:
                        continue
                    mergedCardNames.append(merged.getPaperCard().getName().replace(",", "^"))
                newText.append("|MergedCards:")
                newText.append(TextUtil.join(mergedCardNames, ","))

            if c.getClassLevel() > 1:
                newText.append("|ClassLevel:")
                newText.append(str(c.getClassLevel()))

        if zoneType == ZoneType.Exile:
            if c.getExiledWith() is not None:
                newText.append("|ExiledWith:")
                newText.append(str(c.getExiledWith().getId()))
            if c.isFaceDown():
                newText.append("|FaceDown")  # Exiled face down
            if c.isAdventureCard() and c.getZone().is_(ZoneType.Exile):
                # TODO: this will basically default all exiled cards with Adventure to being "On Adventure".
                # Need to figure out a better way to detect if it's actually on adventure.
                newText.append("|OnAdventure")
            if c.isForetold():
                newText.append("|Foretold")
                if c.enteredThisTurn():
                    newText.append("|ForetoldThisTurn")

        if zoneType == ZoneType.Battlefield or zoneType == ZoneType.Exile:
            # A card can have counters on the battlefield and in exile (e.g. exiled by Mairsil, the Pretender)
            counters = c.getCounters()
            if not counters:
                pass
            else:
                newText.append("|Counters:")
                newText.append(self.countersToString(counters))

        if c.getGame().getCombat() is not None:
            if c.getGame().getCombat().isAttacking(c):
                newText.append("|Attacking")
                defn = c.getGame().getCombat().getDefenderByAttacker(c)
                if isinstance(defn, Card):
                    newText.append(":")
                    newText.append(str(defn.getId()))

        if not c.getUnlockedRooms().isEmpty():
            for stateName in c.getUnlockedRooms():
                newText.append("|UnlockedRoom:")
                newText.append(stateName.name())

        cardTexts[zoneType] = "".join(newText)

    def countersToString(self, counters: dict[CounterType, int]) -> str:
        first = True
        counterString = []

        for key, value in counters.items():
            if not first:
                counterString.append(",")

            first = False
            counterString.append(TextUtil.concatNoSpace(key.toString(), "=", str(value)))
        return "".join(counterString)

    def splitLine(self, line: str):
        if line[0] == '#':
            return None
        tempData = line.split("=", 1)
        if len(tempData) >= 2:
            return tempData
        if len(tempData) == 1 and line.endswith("="):
            # Empty value.
            return [tempData[0], ""]
        return None

    def parse(self, in_) -> None:
        if isinstance(in_, list):
            self.parse_list(in_)
            return
        if hasattr(in_, '__iter__') and not hasattr(in_, 'read'):
            self.parse_stream(in_)
            return
        br = BufferedReader(in_) if not isinstance(in_, (BufferedReader, TextIOWrapper)) else in_
        reader = TextIOWrapper(br) if isinstance(br, BufferedReader) else br
        self.parse_stream(line.rstrip("\n") for line in reader)

    def parse_list(self, lines: list[str]) -> None:
        self.parse_stream(iter(lines))

    def parse_stream(self, lines) -> None:
        self.playerStates.clear()
        for line in lines:
            self.parseLine(line)

    def getPlayerStateByIndex(self, index: int) -> 'GameState.PlayerState':
        while index >= len(self.playerStates):
            self.playerStates.append(GameState.PlayerState())
        return self.playerStates[index]

    def getPlayerState(self, key) -> 'GameState.PlayerState':
        if isinstance(key, int):
            return self.getPlayerStateByIndex(key)
        if key.startswith("human"):
            return self.getPlayerStateByIndex(0)
        elif key.startswith("ai"):
            return self.getPlayerStateByIndex(1)
        elif key.startswith("p") and key[1].isdigit():
            return self.getPlayerStateByIndex(int(key[1]))
        else:
            sys.stderr.write("Unknown player state key: " + key + "\n")
            return GameState.PlayerState()

    def parseLine(self, line: str) -> None:
        keyValue = self.splitLine(line)
        if keyValue is None:
            return

        categoryName = keyValue[0].lower()
        categoryValue = keyValue[1]

        if categoryName.startswith("active"):
            if categoryName.endswith("player"):
                self.tChangePlayer = categoryValue.strip().lower()
            elif categoryName.endswith("phase"):
                self.tChangePhase = categoryValue.strip().upper()
            elif categoryName.endswith("phaseadvance"):
                self.tAdvancePhase = categoryValue.strip().upper()
            return

        if categoryName == "turn":
            self.turn = int(categoryValue)
        elif categoryName == "removesummoningsickness":
            self.removeSummoningSickness = categoryValue.lower() == "true"
        elif categoryName.endswith("life"):
            self.getPlayerState(categoryName).life = int(categoryValue)
        elif categoryName.endswith("counters"):
            self.getPlayerState(categoryName).counters = categoryValue
        elif categoryName.endswith("landsplayed"):
            self.getPlayerState(categoryName).landsPlayed = int(categoryValue)
        elif categoryName.endswith("landsplayedlastturn"):
            self.getPlayerState(categoryName).landsPlayedLastTurn = int(categoryValue)
        elif categoryName.endswith("numringtemptedyou"):
            self.getPlayerState(categoryName).numRingTemptedYou = int(categoryValue)
        elif categoryName.endswith("speed"):
            self.getPlayerState(categoryName).speed = int(categoryValue)
        elif categoryName.endswith("play") or categoryName.endswith("battlefield"):
            self.getPlayerState(categoryName).cardTexts[ZoneType.Battlefield] = categoryValue
        elif categoryName.endswith("hand"):
            self.getPlayerState(categoryName).cardTexts[ZoneType.Hand] = categoryValue
        elif categoryName.endswith("graveyard"):
            self.getPlayerState(categoryName).cardTexts[ZoneType.Graveyard] = categoryValue
        elif categoryName.endswith("library"):
            self.getPlayerState(categoryName).cardTexts[ZoneType.Library] = categoryValue
        elif categoryName.endswith("exile"):
            self.getPlayerState(categoryName).cardTexts[ZoneType.Exile] = categoryValue
        elif categoryName.endswith("command"):
            self.getPlayerState(categoryName).cardTexts[ZoneType.Command] = categoryValue
        elif categoryName.endswith("sideboard"):
            self.getPlayerState(categoryName).cardTexts[ZoneType.Sideboard] = categoryValue
        elif categoryName.startswith("ability"):
            self.abilityString[categoryName[len("ability"):]] = categoryValue
        elif categoryName.endswith("precast"):
            self.getPlayerState(categoryName).precast = categoryValue
        elif categoryName.endswith("putonstack"):
            self.getPlayerState(categoryName).putOnStack = categoryValue
        elif categoryName.endswith("manapool"):
            self.getPlayerState(categoryName).manaPool = categoryValue
        elif categoryName.endswith("persistentmana"):
            self.getPlayerState(categoryName).persistentMana = categoryValue
        else:
            sys.stderr.write("Unknown key: " + categoryName + "\n")

    def applyToGame(self, game: Game) -> None:
        game.getAction().invoke(lambda: self.applyGameOnThread(game))

    def applyGameOnThread(self, game: Game) -> None:
        if game.getPlayers().size() != len(self.playerStates):
            raise RuntimeError("Non-matching number of players, (" +
                str(game.getPlayers().size()) + " vs. " + str(len(self.playerStates)) + ")")

        self.idToCard.clear()
        self.cardToAttachId.clear()
        self.cardToEnchantPlayerId.clear()
        self.cardToRememberedId.clear()
        self.cardToExiledWithId.clear()
        self.cardToImprintedId.clear()
        self.markedDamage.clear()
        self.cardToChosenClrs.clear()
        self.cardToChosenCards.clear()
        self.cardToChosenType.clear()
        self.cardToChosenType2.clear()
        self.cardToMergedCards.clear()
        self.cardToScript.clear()
        self.cardAttackMap.clear()

        playerTurn = self.playerStates.index(self.getPlayerState(self.tChangePlayer))
        newPlayerTurn = game.getPlayers().get(playerTurn)
        newPhase = None if self.tChangePhase.lower() == "none" else PhaseType.smartValueOf(self.tChangePhase)
        advPhase = None if self.tAdvancePhase.lower() == "none" else PhaseType.smartValueOf(self.tAdvancePhase)

        # Set stack to resolving so things won't trigger/effects be checked right away
        game.getStack().setResolving(True)

        game.getPhaseHandler().devModeSet(newPhase, newPlayerTurn, self.turn)

        game.getTriggerHandler().setSuppressAllTriggers(True)

        for i in range(len(self.playerStates)):
            self.setupPlayerState(game.getPlayers().get(i), self.playerStates[i])
        self.handleCardAttachments()
        self.handleChosenEntities()
        self.handleRememberedEntities()
        self.handleMergedCards()
        self.handleScriptExecution(game)
        self.handlePrecastSpells(game)
        self.handleMarkedDamage()

        game.getTriggerHandler().setSuppressAllTriggers(False)

        # SAs added to stack cause triggers to fire, as if the relevant SAs were cast
        self.handleAddSAsToStack(game)

        # Combat only works for 1v1 matches for now (which are the only matches dev mode supports anyway)
        # Note: triggers may fire during combat declarations ("whenever X attacks, ...", etc.)
        if newPhase == PhaseType.COMBAT_DECLARE_ATTACKERS or newPhase == PhaseType.COMBAT_DECLARE_BLOCKERS:
            toDeclareBlockers = newPhase == PhaseType.COMBAT_DECLARE_BLOCKERS
            if newPlayerTurn is not None:
                self.handleCombat(game, newPlayerTurn, newPlayerTurn.getSingleOpponent(), toDeclareBlockers)

        game.getStack().setResolving(False)
        game.getStack().unfreezeStack()

        # Advance to a certain phase, activating all triggered abilities
        if advPhase is not None:
            game.getPhaseHandler().devAdvanceToPhase(advPhase)

        if self.removeSummoningSickness:
            for card in game.getCardsInGame():
                card.setSickness(False)

        game.getAction().checkStateEffects(True)  # ensure state based effects and triggers are updated

        # prevent interactions with objects from old state
        game.copyLastState()

        # Store snapshot for restoring
        game.stashGameState()

        # Set negative or zero life after state effects if need be, important for some puzzles that rely on
        # pre-setting negative life (e.g. PS_NEO4).
        for i in range(len(self.playerStates)):
            life = self.playerStates[i].life
            if life <= 0:
                game.getPlayers().get(i).setLife(life, None)

    def processManaPool(self, manaPool: ManaPool) -> str:
        mana = []
        for c in ManaAtom.MANATYPES:
            amount = manaPool.getAmountOfColor(c)
            for i in range(amount):
                mana.append(MagicColor.toShortString(c))
                mana.append(" ")

        return "".join(mana).strip()

    def updateManaPool(self, p: Player, manaDef: str, clearPool: bool, persistent: bool) -> None:
        game = p.getGame()
        if clearPool:
            p.getManaPool().clearPool(False)

        if manaDef:
            dummy = Card(-777777, game)
            dummy.setOwner(p)
            produced = {}
            produced["Produced"] = manaDef
            if persistent:
                produced["PersistentMana"] = "True"
            abMana = AbilityManaPart(dummy, produced)
            game.getAction().invoke(lambda: abMana.produceMana(None))

    def handleCombat(self, game: Game, attackingPlayer: Player, defendingPlayer: Player, toDeclareBlockers: bool) -> None:
        # First we need to ensure that all attackers are declared in the Declare Attackers step,
        # even if proceeding straight to Declare Blockers
        game.getPhaseHandler().devModeSet(PhaseType.COMBAT_DECLARE_ATTACKERS, attackingPlayer, self.turn)

        if game.getPhaseHandler().getCombat() is None:
            game.getPhaseHandler().setCombat(Combat(attackingPlayer))
            game.updateCombatForView()

        combat = game.getPhaseHandler().getCombat()
        for attacker, attacked in self.cardAttackMap.items():
            combat.addAttacker(attacker, defendingPlayer if attacked is None else attacked)

        # Run the necessary combat events and triggers to set things up correctly as if the
        # attack was actually declared by the attacking player
        from com.google.common.collect.ArrayListMultimap import ArrayListMultimap
        attackersMap = ArrayListMultimap.create()
        for ge in combat.getDefenders():
            attackersMap.putAll(ge, combat.getAttackersOf(ge))
        game.fireEvent(GameEventAttackersDeclared(attackingPlayer, attackersMap))

        for c in combat.getAttackers():
            CombatUtil.checkDeclaredAttacker(game, c, combat, False)

        game.updateCombatForView()
        game.fireEvent(GameEventCombatChanged())

        # Gracefully proceed to Declare Blockers, giving priority to the defending player,
        # but only if the stack is empty (otherwise the game will crash).
        game.getStack().addAllTriggeredAbilitiesToStack()
        if toDeclareBlockers and game.getStack().isEmpty():
            game.getPhaseHandler().devAdvanceToPhase(PhaseType.COMBAT_DECLARE_BLOCKERS)

    def handleRememberedEntities(self) -> None:
        # Remembered: X
        for c, ids in self.cardToRememberedId.items():
            for id_ in ids:
                tgt = self.idToCard.get(int(id_))
                c.addRemembered(tgt)

        # Imprinting: X
        for c, ids in self.cardToImprintedId.items():
            for id_ in ids:
                tgt = self.idToCard.get(int(id_))
                c.addImprintedCard(tgt)

        # Exiled with X
        for c, id_ in self.cardToExiledWithId.items():
            exiledWith = self.idToCard.get(int(id_))
            if exiledWith is not None:
                exiledWith.addExiledCard(c)
                c.setExiledWith(exiledWith)
                c.setExiledBy(exiledWith.getController())

    def parseTargetInScript(self, tgtDef: str) -> int:
        if tgtDef.lower() == "human":
            tgtID = self.TARGET_HUMAN
        elif tgtDef.lower() == "ai":
            tgtID = self.TARGET_AI
        else:
            tgtID = int(tgtDef)

        return tgtID

    def handleScriptedTargetingForSA(self, game: Game, sa: SpellAbility, tgtID: int) -> None:
        human = game.getPlayers().get(0)
        ai = game.getPlayers().get(1)

        if tgtID != self.TARGET_NONE:
            if tgtID == self.TARGET_HUMAN:
                sa.getTargets().add(human)
            elif tgtID == self.TARGET_AI:
                sa.getTargets().add(ai)
            else:
                sa.getTargets().add(self.idToCard.get(tgtID))

        if sa.hasParam("RememberTargets"):
            sa.getHostCard().addRemembered(sa.getTargets())

    def handleScriptExecution(self, game: Game) -> None:
        for c, sPtr in self.cardToScript.items():
            self.executeScript(game, c, sPtr)

    def executeScript(self, game: Game, c: Card, sPtr: str, putOnStack: bool = False) -> None:
        tgtID = self.TARGET_NONE
        if "->" in sPtr:
            tgtDef = sPtr[sPtr.rfind("->") + 2:]

            tgtID = self.parseTargetInScript(tgtDef)
            sPtr = sPtr[:sPtr.rfind("->")]

        sa = None
        if sPtr.isdigit():
            numSA = int(sPtr)
            if c.getSpellAbilities().size() >= numSA:
                sa = c.getSpellAbilities().get(numSA)
            else:
                sys.stderr.write("ERROR: Unable to find SA with index " + str(numSA) + " on card " + str(c) + " to execute!\n")
        else:
            # Special handling for keyworded abilities
            if sPtr.startswith("KW#"):
                kwName = sPtr[3:]
                saList = c.getSpellAbilities()

                if kwName == "Awaken" or kwName == "AwakenOnly":
                    # AwakenOnly only creates the Awaken effect, while Awaken precasts the whole spell with Awaken
                    for ab in saList:
                        if ab.getDescription().startswith("Awaken"):
                            ab.setActivatingPlayer(c.getController())
                            # target for Awaken is set in its first subability
                            self.handleScriptedTargetingForSA(game, ab.getSubAbility(), tgtID)
                            sa = ab.getSubAbility() if kwName == "AwakenOnly" else ab
                    if sa is None:
                        sys.stderr.write("ERROR: Could not locate keyworded ability Awaken in card " + str(c) + " to execute!\n")
                        return
            else:
                # SVar-based script execution
                svarValue = ""

                if sPtr.startswith("CustomScript:"):
                    # A custom line defined in the game state file
                    svarValue = sPtr[sPtr.index(":") + 1:]
                else:
                    # A SVar from the card script file
                    if not c.hasSVar(sPtr):
                        sys.stderr.write("ERROR: Unable to find SVar " + sPtr + " on card " + str(c) + " + to execute!\n")
                        return

                    svarValue = c.getSVar(sPtr)

                    if tgtID != self.TARGET_NONE and "| Defined$" in svarValue:
                        # We want a specific target, so try to undefine a predefined target if possible
                        svarValue = TextUtil.fastReplace(svarValue, "| Defined$", "| Undefined$")
                        if tgtID == self.TARGET_HUMAN or tgtID == self.TARGET_AI:
                            svarValue += " | ValidTgts$ Player"
                        else:
                            svarValue += " | ValidTgts$ Card"

                sa = AbilityFactory.getAbility(svarValue, c)
                if sa is None:
                    sys.stderr.write("ERROR: Unable to generate ability for SVar " + svarValue + "\n")

        if sa is not None:
            sa.setActivatingPlayer(c.getController())
        self.handleScriptedTargetingForSA(game, sa, tgtID)

        if putOnStack:
            game.getStack().addAndUnfreeze(sa)
        else:
            sa.resolve()

            # resolve subabilities
            subSa = sa.getSubAbility()
            while subSa is not None:
                subSa.resolve()
                subSa = subSa.getSubAbility()

    def handlePrecastSpells(self, game: Game) -> None:
        for i in range(len(self.playerStates)):
            if self.playerStates[i].precast is not None:
                spellList = TextUtil.split(self.playerStates[i].precast, ';')
                for spell in spellList:
                    self.precastSpellFromCard(spell, game.getPlayers().get(i), game)

    def handleAddSAsToStack(self, game: Game) -> None:
        for i in range(len(self.playerStates)):
            if self.playerStates[i].putOnStack is not None:
                spellList = TextUtil.split(self.playerStates[i].putOnStack, ';')
                for spell in spellList:
                    self.precastSpellFromCard(spell, game.getPlayers().get(i), game, True)

    def precastSpellFromCard(self, spellDef: str, activator: Player, game: Game, putOnStack: bool = False) -> None:
        tgtID = self.TARGET_NONE
        scriptID = ""

        if ":" in spellDef:
            # targeting via -> will be handled in executeScript
            scriptID = spellDef[spellDef.index(":") + 1:].strip()
            spellDef = spellDef[:spellDef.index(":")].strip()
        elif "->" in spellDef:
            tgtDef = spellDef[spellDef.index("->") + 2:].strip()
            tgtID = self.parseTargetInScript(tgtDef)
            spellDef = spellDef[:spellDef.index("->")].strip()

        spellDef = spellDef.replace("^", ":")  # alternate marker for when : is the name of the card

        c = None

        if spellDef.isdigit():
            # Precast from a specific host
            c = self.idToCard.get(int(spellDef))
            if c is None:
                sys.stderr.write("ERROR: Could not find a card with ID " + spellDef + " to precast!\n")
                return
        else:
            # Precast from a card by name
            pc = StaticData.instance().getCommonCards().getCard(spellDef)

            if pc is None:
                sys.stderr.write("ERROR: Could not find a card with name " + spellDef + " to precast!\n")
                return

            c = Card.fromPaperCard(pc, activator)

        sa = None

        if scriptID:
            self.executeScript(game, c, scriptID, putOnStack)
            return

        if c.getName() != spellDef and c.hasAlternateState() and spellDef == c.getAlternateState().getName():
            sa = c.getAlternateState().getFirstSpellAbility()
        else:
            sa = c.getFirstSpellAbility()

        sa.setActivatingPlayer(activator)

        self.handleScriptedTargetingForSA(game, sa, tgtID)

        if putOnStack:
            game.getStack().addAndUnfreeze(sa)
        else:
            sa.resolve()

    def handleMarkedDamage(self) -> None:
        for c, dmg in self.markedDamage.items():
            c.setDamage(dmg)

    def handleChosenEntities(self) -> None:
        # TODO: the AI still gets to choose something (and the notification box pops up) before the
        # choice is overwritten here. Somehow improve this so that there is at least no notification
        # about the choice that will be force-changed anyway.

        # Chosen colors
        for c, colors in self.cardToChosenClrs.items():
            c.setChosenColors(colors)

        # Chosen type
        for c, value in self.cardToChosenType.items():
            c.setChosenType(value)

        # Chosen type 2
        for c, value in self.cardToChosenType2.items():
            c.setChosenType2(value)

        # Named card
        for c, names in self.cardToNamedCard.items():
            for s in names:
                c.addNamedCard(s)

        # Chosen cards
        for c, value in self.cardToChosenCards.items():
            c.setChosenCards(value)

    def handleCardAttachments(self) -> None:
        # Unattach all permanents first
        for c, attachId in self.cardToAttachId.items():
            attachedTo = self.idToCard.get(attachId)
            attachedTo.unAttachAllCards(attachedTo)

        # Attach permanents by ID
        for attacher, attachId in self.cardToAttachId.items():
            attachedTo = self.idToCard.get(attachId)
            if attacher.isAttachment():
                attacher.attachToEntity(attachedTo, None, True)

        # Enchant players
        for key, value in self.cardToEnchantPlayerId.items():
            key.attachToEntity(value, None)

    def handleMergedCards(self) -> None:
        for mergedTo, names in self.cardToMergedCards.items():
            for mergedCardName in names:
                pc = StaticData.instance().getCommonCards().getCard(mergedCardName.replace("^", ","))
                if pc is None:
                    sys.stderr.write("ERROR: Tried to create a non-existent card named " + mergedCardName + " (as a merged card) when loading game state!\n")
                    continue

                c = Card.fromPaperCard(pc, mergedTo.getOwner())
                self.emulateMergeViaMutate(mergedTo, c)

    def emulateMergeViaMutate(self, top: Card, bottom: Card) -> None:
        if top is None or bottom is None:
            sys.stderr.write("ERROR: Tried to call emulateMergeViaMutate with a null card!\n")
            return

        game = top.getGame()

        bottom.setMergedToCard(top)
        if not top.hasMergedCard():
            top.addMergedCard(top)
        top.addMergedCard(bottom)

        top.removeMutatedStates()

        ts = game.getNextTimestamp()
        top.setMutatedTimestamp(ts)
        if top.getCurrentStateName() != CardStateName.FaceDown:
            mutatedStates = CardFactory.getMutatedCloneStates(top, None)  # FIXME
            top.addCloneState(mutatedStates, ts)
        bottom.setTapped(top.isTapped())
        bottom.setFlipped(top.isFlipped())
        top.setTimesMutated(top.getTimesMutated() + 1)
        top.updateTokenView()

        # TODO: Merged commanders aren't supported yet

    def applyCountersToGameEntity(self, entity: GameEntity, counterString: str) -> None:
        entity.setCounters({})
        allCounterStrings = counterString.split(",")
        for counterPair in allCounterStrings:
            pair = counterPair.split("=", 1)
            entity.addCounterInternal(CounterType.getType(pair[0]), int(pair[1]), None, False, None, None)

    def setupPlayerState(self, p: Player, state: 'GameState.PlayerState') -> None:
        # Lock check static as we setup player state

        # Clear all zones first, this ensures that any lingering cards and effects (e.g. in command zone) get cleared up
        # before setting up a new state
        for zt in GameState.ZONES.keys():
            p.getZone(zt).removeAllCards(True)

        p.getCommanders().clear()
        p.clearTheRing()

        playerCards: dict[ZoneType, CardCollectionView] = {}
        for key, value in state.cardTexts.items():
            playerCards[key] = self.processCardsForZone([] if not value else value.split(";"), p)

        if state.life >= 0:
            p.setLife(state.life, None)
        p.setLandsPlayedThisTurn(state.landsPlayed)
        p.setLandsPlayedLastTurn(state.landsPlayedLastTurn)
        p.setNumRingTemptedYou(state.numRingTemptedYou)
        p.setSpeed(state.speed)

        p.clearPaidForSA()

        for key, value in playerCards.items():
            zone = p.getZone(key)
            if key == ZoneType.Battlefield:
                cards = []
                for c in value:
                    if c.isToken():
                        cards.append(c)
                zone.setCards(cards)
                for c in value:
                    if c.isToken():
                        continue
                    tapped = c.isTapped()
                    sickness = c.hasSickness()
                    counters = c.getCounters()
                    # Note: Not clearCounters() since we want to keep the counters var as-is.
                    c.setCounters({})
                    if c.isAura():
                        # dummy "enchanting" to indicate that the card will be force-attached elsewhere
                        # (will be overridden later, so the actual value shouldn't matter)

                        # FIXME it shouldn't be able to attach itself
                        c.setEntityAttachedTo(CardCopyService(c).copyCard(True))

                    if c in self.cardsWithoutETBTrigs:
                        p.getGame().getAction().moveTo(ZoneType.Battlefield, c, None, None)
                    else:
                        p.getZone(ZoneType.Hand).add(c)
                        p.getGame().getAction().moveToPlay(c, None, None)

                    c.setTapped(tapped)
                    c.setSickness(sickness)
                    c.setCounters(counters)
            else:
                zone.setCards(value)
        if not p.getCommanders().isEmpty():
            p.createCommanderEffect()  # Original one was lost, and the one made by addCommander would have been erased by setCards.

        self.updateManaPool(p, state.manaPool, True, False)
        self.updateManaPool(p, state.persistentMana, False, True)

        if state.counters:
            self.applyCountersToGameEntity(p, state.counters)
        if state.numRingTemptedYou > 0:
            # setup all levels
            for i in range(1, state.numRingTemptedYou + 1):
                if i > 4:
                    break
                p.setRingLevel(i)
        if state.speed > 0:
            p.createSpeedEffect()

    def processCardsForZone(self, data: list[str], player: Player) -> CardCollectionView:
        """
        processCardsForZone.

        @param data
                   an array of String objects.
        @param player
                   a Player object.
        @return a CardCollectionView object.
        """
        cl = CardCollection()
        for element in data:
            cardinfo = element.strip().split("|")

            setCode = None
            for info in cardinfo:
                if info.startswith("Set:"):
                    setCode = info[info.index(':') + 1:]
                    break

            artID = -1
            for info in cardinfo:
                if info.startswith("Art:"):
                    try:
                        artID = int(info[info.index(':') + 1:])
                    except Exception:
                        break
                    break

            c = None
            hasSetCurSet = False
            if cardinfo[0].startswith("t:"):
                # TODO Make sure Game State conversion works with new tokens
                tokenStr = cardinfo[0][2:]
                c = TokenInfo(tokenStr).makeOneToken(player)
            elif cardinfo[0].startswith("T:"):
                tokenStr = cardinfo[0][2:]
                token = StaticData.instance().getAllTokens().getToken(tokenStr,
                        setCode if setCode is not None else CardEdition.UNKNOWN_CODE)
                if token is None:
                    sys.stderr.write("ERROR: Tried to create a non-existent token named " + cardinfo[0] + " when loading game state!\n")
                    continue
                c = CardFactory.getCard(token, player, player.getGame())
            else:
                pc = StaticData.instance().getCommonCards().getCard(cardinfo[0], setCode, artID)
                if pc is None:
                    sys.stderr.write("ERROR: Tried to create a non-existent card named " + cardinfo[0] + " (set: " + ("any" if setCode is None else setCode) + ") when loading game state!\n")
                    continue

                c = Card.fromPaperCard(pc, player)
                if setCode is not None:
                    hasSetCurSet = True
            c.setSickness(False)

            for info in cardinfo:
                if info.startswith("Tapped"):
                    c.tap(False, None, None)
                elif info.startswith("Renowned"):
                    c.setRenowned(True)
                elif info.startswith("Solved"):
                    c.setSolved(True)
                elif info.startswith("Saddled"):
                    c.setSaddled(True)
                elif info.startswith("Suspected"):
                    c.setSuspected(True)
                elif info.startswith("Monstrous"):
                    c.setMonstrous(True)
                elif info.startswith("PhasedOut"):
                    tgt = info[info.index(':') + 1:]
                    c.setPhasedOut(self.parsePlayerString(player.getGame(), tgt))
                elif info.startswith("Counters:"):
                    self.applyCountersToGameEntity(c, info[info.index(':') + 1:])
                elif info.startswith("SummonSick"):
                    c.setSickness(True)
                elif info.startswith("FaceDown"):
                    c.turnFaceDown(True)
                    if info.endswith("Manifested"):
                        c.setManifested(SpellAbility.EmptySa(ApiType.Manifest, c))
                    if info.endswith("Cloaked"):
                        c.setCloaked(SpellAbility.EmptySa(ApiType.Cloak, c))
                elif info.startswith("Transformed") or info.startswith("Modal"):
                    c.setState(CardStateName.Backside, True)
                    c.setBackSide(True)
                elif info.startswith("Flipped"):
                    c.setState(CardStateName.Flipped, True)
                elif info.startswith("Meld"):
                    if info.find(':') > 0:
                        meldCardName = info[info.index(':') + 1:].replace("^", ",")
                        pc = StaticData.instance().getCommonCards().getCard(meldCardName)
                        if pc is None:
                            sys.stderr.write("ERROR: Tried to create a non-existent card named " + meldCardName + " (as a MeldedWith card) when loading game state!\n")
                            continue
                        meldTarget = Card.fromPaperCard(pc, c.getOwner())
                        c.setMeldedWith(meldTarget)
                    c.setState(CardStateName.Meld, True)
                    c.setBackSide(True)
                elif info.startswith("OnAdventure"):
                    abAdventure = "DB$ Effect | RememberObjects$ Self | StaticAbilities$ Play | ForgetOnMoved$ Exile | Duration$ Permanent | ConditionDefined$ Self | ConditionPresent$ Card.!copiedSpell"
                    saAdventure = AbilityFactory.getAbility(abAdventure, c)
                    sbPlay = []
                    sbPlay.append("Mode$ Continuous | MayPlay$ True | EffectZone$ Command | Affected$ Card.IsRemembered+nonAdventure")
                    sbPlay.append(" | AffectedZone$ Exile | Description$ You may cast the card.")
                    saAdventure.setSVar("Play", "".join(sbPlay))
                    saAdventure.setActivatingPlayer(c.getOwner())
                    saAdventure.resolve()
                    c.setExiledWith(c)  # This seems to be the way it's set up internally. Potentially not needed here?
                    c.setExiledBy(c.getController())
                elif info.startswith("IsCommander"):
                    player.addCommander(c)
                elif info.startswith("IsRingBearer"):
                    c.setRingBearer(True)
                    player.setRingBearer(c)
                elif info.startswith("Id:"):
                    id_ = int(info[3:])
                    self.idToCard[id_] = c
                elif info.startswith("Attaching:") or info.startswith("AttachedTo:"):  # Attaching is deprecated
                    id_ = int(info[info.index(':') + 1:])
                    self.cardToAttachId[c] = id_
                elif info.startswith("EnchantingPlayer:"):
                    tgt = info[info.index(':') + 1:]
                    self.cardToEnchantPlayerId[c] = self.parsePlayerString(player.getGame(), tgt)
                elif info.startswith("Owner:"):
                    owner = info[info.index(':') + 1:]
                    controller = c.getController()
                    c.setOwner(self.parsePlayerString(player.getGame(), owner))
                    c.setController(controller, c.getGame().getNextTimestamp())
                elif info.startswith("Ability:"):
                    abString = info[info.index(':') + 1:].lower()
                    c.addSpellAbility(AbilityFactory.getAbility(self.abilityString.get(abString), c))
                elif info.startswith("Damage:"):
                    dmg = int(info[info.index(':') + 1:])
                    self.markedDamage[c] = dmg
                elif info.startswith("ChosenColor:"):
                    self.cardToChosenClrs[c] = info[info.index(':') + 1:].split(",")
                elif info.startswith("ChosenType:"):
                    self.cardToChosenType[c] = info[info.index(':') + 1:]
                elif info.startswith("ChosenType2:"):
                    self.cardToChosenType2[c] = info[info.index(':') + 1:]
                elif info.startswith("ChosenCards:"):
                    chosen = CardCollection()
                    idlist = info[info.index(':') + 1:].split(",")
                    for id_ in idlist:
                        chosen.add(self.idToCard.get(int(id_)))
                    self.cardToChosenCards[c] = chosen
                elif info.startswith("MergedCards:"):
                    cardNames = info[info.index(':') + 1:].split(",")
                    self.cardToMergedCards[c] = cardNames
                elif info.startswith("NamedCard:"):
                    cardNames = info[info.index(':') + 1:].split(",")
                    self.cardToNamedCard[c] = cardNames
                elif info.startswith("ExecuteScript:"):
                    self.cardToScript[c] = info[info.index(':') + 1:]
                elif info.startswith("RememberedCards:"):
                    self.cardToRememberedId[c] = info[info.index(':') + 1:].split(",")
                elif info.startswith("Imprinting:"):
                    self.cardToImprintedId[c] = info[info.index(':') + 1:].split(",")
                elif info.startswith("ExiledWith:"):
                    self.cardToExiledWithId[c] = info[info.index(':') + 1:]
                elif info.startswith("Attacking"):
                    if ":" in info:
                        id_ = int(info[info.index(':') + 1:])
                        self.cardAttackMap[c] = self.idToCard.get(id_)
                    else:
                        self.cardAttackMap[c] = None
                elif info == "NoETBTrigs":
                    self.cardsWithoutETBTrigs.add(c)
                elif info == "Foretold":
                    c.setForetold(True)
                    c.turnFaceDown(True)
                    c.addMayLookFaceDownExile(c.getOwner())
                elif info == "ForetoldThisTurn":
                    c.setTurnInZone(self.turn)
                elif info == "IsToken":
                    c.setGamePieceType(GamePieceType.TOKEN)
                elif info.startswith("ClassLevel:"):
                    c.setClassLevel(int(info[info.index(':') + 1:]))
                elif info.startswith("UnlockedRoom:"):
                    c.unlockRoom(c.getController(), CardStateName.smartValueOf(info[info.index(':') + 1:]))

            if not hasSetCurSet and not c.isToken():
                c.setSetCode(c.getMostRecentSet())

            cl.add(c)
        return cl
```
