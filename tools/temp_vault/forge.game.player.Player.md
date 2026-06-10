---
aliases:
  - Player
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/player
fqn: forge.game.player.Player
package: forge.game.player
module: forge-game
kind: Class
---

# Player

**Package:** `forge.game.player` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class Player {
        +List~ZoneType~ ALL_ZONES
        -int life
        -int startingLife
        -int lifeStartedThisTurnWith
        -int lifeLostThisTurn
        -int lifeLostLastTurn
        -int lifeGainedThisTurn
        -int lifeGainedTimesThisTurn
        -int lifeGainedByTeamThisTurn
        -int maxHandSize
        -int startingHandSize
        -boolean unlimitedHandSize
        -Card lastDrawnCard
        -int numDrawnThisTurn
        -int numDrawnLastTurn
        -int numDrawnThisDrawStep
        -int numCardsInHandStartedThisTurnWith
        -int numExploredThisTurn
        -int numTokenCreatedThisTurn
        -int numForetoldThisTurn
        -int landsPlayedThisTurn
        -int landsPlayedLastTurn
        -int numPowerSurgeLands
        -int spellsCastThisTurn
        -int spellsCastThisGame
        -int spellsCastLastTurn
        -List~Card~ spellsCastSinceBeginningOfLastTurn
        -int investigatedThisTurn
        -int surveilThisTurn
        -int committedCrimeThisTurn
        -int numFlipsThisTurn
        -int numRollsThisTurn
        -List~Integer~ diceRollsThisTurn
        -int expentThisTurn
        -int numLibrarySearchedOwn
        -int venturedThisTurn
        -int attractionsVisitedThisTurn
        -int descended
        -int numRingTemptedYou
        -int devotionMod
        -Card ringBearer
        -Card theRing
        -int speed
        -List~Card~ discardedThisTurn
        -List~Card~ sacrificedThisTurn
        -int simultaneousDamage
        -int lastTurnNr
        -String namedCard
        -Map~String,FCollection~ notes
        -Map~String,Integer~ notedNum
        -Map~String,String~ draftNotes
        -CardCollection inboundTokens
        -KeywordCollection keywords
        -Table~Long,String,KeywordInterface~ storedKeywords
        -Table~Long,Long,IKeywordsChange~ changedKeywords
        -Map~GameEntity,List~ attackedThisTurn
        -List~Player~ attackedPlayersLastTurn
        -List~Player~ attackedPlayersThisCombat
        -boolean beenDealtCombatDamageSinceLastTurn
        -boolean tappedLandForManaThisTurn
        -Map~ZoneType,PlayerZone~ zones
        -List~PlayerZone~ extraZones
        -Map~Long,Integer~ adjustLandPlays
        -Set~Long~ adjustLandPlaysInfinite
        -Map~Card,Card~ maingameCardsMap
        -CardCollection currentPlanes
        -CardCollection planeswalkedToThisTurn
        -Card activeScheme
        -NavigableMap~Long,Pair~ controlledBy
        -NavigableMap~Long,Player~ controlledWhileSearching
        -int numManaShards
        -int teamNumber
        -PlayerController controller
        -Game game
        -boolean triedToDrawFromEmptyLibrary
        -CardCollection lostOwnership
        -CardCollection gainedOwnership
        -ManaPool manaPool
        -Deque~SpellAbility~ paidForStack
        -List~Card~ completedDungeons
        -CardCollection commanders
        -Map~Card,Integer~ commanderCast
        -Map~Card,Integer~ commanderDamage
        -DetachedCardEffect commanderEffect
        -Card monarchEffect
        -Card initiativeEffect
        -Card blessingEffect
        -Card contraptionSprocketEffect
        -Card radiationEffect
        -Card keywordEffect
        -Card speedEffect
        -Map~Long,Integer~ additionalVotes
        -Map~Long,Integer~ additionalOptionalVotes
        -SortedSet~Long~ controlVotes
        -Map~Long,Integer~ additionalVillainousChoices
        -EnumSet~TriggerType~ elementalBendThisTurn
        -NavigableMap~Long,Player~ declaresAttackers
        -NavigableMap~Long,Player~ declaresBlockers
        -int crankCounter
        -PlayerStatistics stats
        -AchievementTracker achievementTracker
        -PlayerView view
        +getAchievementTracker() AchievementTracker
        -chooseName(String originalName) String
        +getGame() Game
        +getStats() PlayerStatistics
        +getTeam() int
        +setTeam(int iTeam) void
        +isArchenemy() boolean
        +getActiveScheme() Card
        +setSchemeInMotion(SpellAbility cause) void
        +setSchemeInMotion(SpellAbility cause, Card scheme) void
        +getRegisteredPlayers() PlayerCollection
        +getOpponents() PlayerCollection
        +getRegisteredOpponents() PlayerCollection
        +updateOpponentsForView() void
        +updateFlashbackForView() void
        +getSingleOpponent() Player
        +getOpponentsSmallestLifeTotal() int
        +getOpponentsGreatestLifeTotal() int
        +getOpponentsTotalPoisonCounters() int
        +getAllies() PlayerCollection
        +getTeamMates(boolean inclThis) PlayerCollection
        +getYourTeam() PlayerCollection
        +getAllOtherPlayers() PlayerCollection
        +getWeakestOpponent() Player
        +getStrongestOpponent() Player
        +isOpponentOf(Player other) boolean
        +isOpponentOf(String other) boolean
        +setLife(int newLife, SpellAbility sa) boolean
        +getStartingLife() int
        +setStartingLife(int startLife) void
        +getLife() int
        +gainLife(int lifeGain, Card source, SpellAbility sa) boolean
        +canGainLife() boolean
        +loseLife(int toLose, boolean damage, boolean manaBurn) int
        +canLoseLife() boolean
        +canPayLife(int lifePayment, boolean effect, SpellAbility cause) boolean
        +payLife(int lifePayment, SpellAbility cause, boolean effect) boolean
        +canPayEnergy(int energyPayment) boolean
        +loseEnergy(int lostEnergy) boolean
        +payEnergy(int energyPayment, Card source) boolean
        +canPayShards(int shardPayment) boolean
        +loseShards(int lostShards) int
        +payShards(int shardPayment, Card source) boolean
        +addDamageAfterPrevention(int amount, Card source, SpellAbility cause, boolean isCombat, GameEntityCounterTable counterTable) int
        +staticReplaceDamage(int damage, Card source, boolean isCombat) int
        +processDamage() int
        +getOpponentsAssignedDamage() int
        +getMaxOpponentAssignedDamage() int
        +getMaxAssignedCombatDamage() int
        +canReceiveCounters(CounterType type) boolean
        +canRemoveCounters(CounterType type) boolean
        +addCounterInternal(CounterType counterType, int n, Player source, boolean fireEvents, GameEntityCounterTable table, Map~AbilityKey,Object~ params) void
        +subtractCounter(CounterType counterName, int num, Player remover) int
        +clearCounters() void
        +setCounters(CounterType counterType, Integer num, Player source, boolean fireEvents) void
        +setCounters(Map~CounterType,Integer~ allCounters) void
        +addRadCounters(int num, Player source, GameEntityCounterTable table) void
        +removeRadCounters(int num) void
        +getPoisonCounters() int
        +setPoisonCounters(int num, Player source) void
        +addPoisonCounters(int num, Player source, GameEntityCounterTable table) void
        +removePoisonCounters(int num, Player source) void
        +addChangedKeywords(List~String~ addKeywords, List~String~ removeKeywords, Long timestamp, long staticId) void
        +getKeywordForStaticAbility(String kw, long staticId) KeywordInterface
        +removeChangedKeywords(Long timestamp, long staticId) IKeywordsChange
        +hasKeyword(String keyword) boolean
        +hasKeyword(Keyword keyword) boolean
        -updateKeywords() void
        +getKeywords() KeywordCollection
        +canBeTargetedBy(SpellAbility sa) boolean
        +surveil(int num, SpellAbility cause, Map~AbilityKey,Object~ params) void
        +getSurveilThisTurn() int
        +resetSurveilThisTurn() void
        +canMulligan() boolean
        +canDraw() boolean
        +canDrawAmount(int amount) boolean
        +drawCard() CardCollectionView
        +drawCards(int n) CardCollectionView
        +drawCards(int n, PlayerZone zone) CardCollectionView
        +drawCards(int n, SpellAbility cause, Map~AbilityKey,Object~ params) CardCollectionView
        +drawCards(int n, SpellAbility cause, Map~AbilityKey,Object~ params, PlayerZone zone) CardCollectionView
        -doDraw(Map~Player,CardCollection~ revealed, SpellAbility sa, Map~AbilityKey,Object~ params, PlayerZone hand) CardCollectionView
        +resetNumDrawnThisDrawStep() void
        +resetNumDrawnThisTurn() void
        +getNumDrawnThisTurn() int
        +getNumDrawnLastTurn() int
        +numDrawnThisDrawStep() int
        +getZone(ZoneType zone) PlayerZone
        +updateZoneForView(PlayerZone zone) void
        +updateAllZonesForView() void
        +getExtraZones() List~PlayerZone~
        +resetExtraZones(ZoneType type) void
        +getCardsIn(ZoneType zoneType) CardCollectionView
        +getCardsIn(ZoneType zoneType, boolean filterOutPhasedOut) CardCollectionView
        +getCardsIn(ZoneType zone, int n) CardCollectionView
        +getCardsIn(Iterable~ZoneType~ zones) CardCollectionView
        +getCardsIn(Iterable~ZoneType~ zones, boolean filterOutPhasedOut) CardCollectionView
        +getCardsIn(ZoneType[] zones) CardCollectionView
        +getCardsIn(ZoneType zone, String cardName) CardCollectionView
        +getCardsActivatableInExternalZones(boolean includeCommandZone) CardCollectionView
        +getAllCards() CardCollectionView
        +resetNumRollsThisTurn() void
        +getNumRollsThisTurn() int
        +roll() void
        +resetNumFlipsThisTurn() void
        +getNumFlipsThisTurn() int
        +flip() void
        +discard(Card c, SpellAbility sa, boolean effect, Map~AbilityKey,Object~ params) Card
        +addTokensCreatedThisTurn(Card token) void
        +getNumTokenCreatedThisTurn() int
        +resetNumTokenCreatedThisTurn() void
        +getNumForetoldThisTurn() int
        +addForetoldThisTurn() void
        +resetNumForetoldThisTurn() void
        +getDiscardedThisTurn() List~Card~
        +resetDiscardedThisTurn() void
        +getNumExploredThisTurn() int
        +addExploredThisTurn() void
        +resetNumExploredThisTurn() void
        +getNumCardsInHandStartedThisTurnWith() int
        +setNumCardsInHandStartedThisTurnWith(int num) void
        +getLifeStartedThisTurnWith() int
        +setLifeStartedThisTurnWith(int l) void
        +addNoteForName(String notedFor, String noted) void
        +getNotesForName(String notedFor) FCollection~String~
        +clearNotesForName(String notedFor) void
        +noteNumberForName(String notedFor, int noted) void
        +getNotedNumberForName(String notedFor) int
        +mill(int n, ZoneType destination, SpellAbility sa, Map~AbilityKey,Object~ params) CardCollectionView
        +getTopXCardsFromLibrary(int amount) CardCollection
        +shuffle(SpellAbility sa) void
        +playLand(Card land, SpellAbility cause) Card
        +canPlayLand(Card land, boolean ignoreZoneAndTiming, SpellAbility landSa) boolean
        +getMaxLandPlays() int
        +addMaxLandPlays(long timestamp, int value) void
        +removeMaxLandPlays(long timestamp) boolean
        +addMaxLandPlaysInfinite(long timestamp) void
        +removeMaxLandPlaysInfinite(long timestamp) boolean
        +getMaxLandPlaysInfinite() boolean
        +addMaingameCardMapping(Card subgameCard, Card maingameCard) void
        +getMappingMaingameCard(Card subgameCard) Card
        +getManaPool() ManaPool
        +updateManaForView() void
        +getNumPowerSurgeLands() int
        +setNumPowerSurgeLands(int n) int
        +getLastDrawnCard() Card
        -setLastDrawnCard(Card c) Card
        +getRingBearer() Card
        +getTheRing() Card
        +clearTheRing() void
        +setRingBearer(Card bearer) void
        +clearRingBearer() void
        +getNamedCard() String
        +setNamedCard(String s) void
        +getTurn() int
        +incrementTurn() void
        +getLastTurnNr() int
        +hasTappedLandForManaThisTurn() boolean
        +setTappedLandForManaThisTurn(boolean tappedLandForManaThisTurn) void
        +hasBeenDealtCombatDamageSinceLastTurn() boolean
        +setBeenDealtCombatDamageSinceLastTurn(boolean b) void
        +getCreaturesAttackedThisTurn() List~Card~
        +getCreaturesAttackedThisTurn(GameEntity e) List~Card~
        +addCreaturesAttackedThisTurn(Card c, GameEntity e) void
        +getAttackedPlayersMyTurn() Iterable~Player~
        +getAttackedPlayersMyLastTurn() List~Player~
        +clearAttackedMyTurn() void
        +setAttackedPlayersMyLastTurn(Iterable~Player~ players) void
        +getAttackedPlayersMyCombat() List~Player~
        +clearAttackedPlayersMyCombat() void
        +getVenturedThisTurn() int
        +incrementVenturedThisTurn() void
        +resetVenturedThisTurn() void
        +getCompletedDungeons() List~Card~
        +addCompletedDungeon(Card dungeon) void
        +resetCompletedDungeons() void
        +getSpeed() int
        +increaseSpeed() void
        +decreaseSpeed() void
        +noSpeed() boolean
        +maxSpeed() boolean
        +setSpeed(int i) void
        +createSpeedEffect() void
        #updateSpeedEffect() void
        +altWinBySpellEffect(String sourceName) void
        +loseConditionMet(GameLossReason state, String spellName) boolean
        +concede() void
        +intentionalDraw() void
        +conceded() boolean
        +cantLose() boolean
        +cantLoseForZeroOrLessLife() boolean
        +cantLoseCheck(GameLossReason state) boolean
        +cantWin() boolean
        +checkLoseCondition() boolean
        +hasLost() boolean
        +hasWon() boolean
        +isInGame() boolean
        +hasMetalcraft() boolean
        +hasDesert() boolean
        +hasThreshold() boolean
        +hasHellbent() boolean
        +hasRevolt() boolean
        +getDescended() int
        +descend() void
        +setDescended(int n) void
        +hasDelirium() boolean
        +hasLandfall() boolean
        +hasFerocious() boolean
        +hasSurge() boolean
        +hasBloodthirst() boolean
        +getBloodthirstAmount() int
        +getOpponentLostLifeThisTurn() int
        +hasProwl(SpellAbility sa) boolean
        +hasFreerunning() boolean
        +setLibrarySearched(int l) void
        +getLibrarySearched() int
        +incLibrarySearched() void
        +isValid(String restriction, Player sourceController, Card source, CardTraitBase spellAbility) boolean
        +hasProperty(String property, Player sourceController, Card source, CardTraitBase spellAbility) boolean
        +getMaxHandSize() int
        +setMaxHandSize(int size) void
        +isUnlimitedHandSize() boolean
        +setUnlimitedHandSize(boolean unlimited) void
        +getStartingHandSize() int
        +setStartingHandSize(int shs) void
        +getLandsPlayedThisTurn() int
        +getLandsPlayedLastTurn() int
        +addLandPlayedThisTurn() void
        +resetLandsPlayedThisTurn() void
        +setLandsPlayedThisTurn(int num) void
        +setLandsPlayedLastTurn(int num) void
        +setNumDrawnLastTurn(int num) void
        +getInvestigateNumThisTurn() int
        +addInvestigatedThisTurn() void
        +resetInvestigatedThisTurn() void
        +addSacrificedThisTurn(Card cpy, SpellAbility source) void
        +getSacrificedThisTurn() List~Card~
        +resetSacrificedThisTurn() void
        +getSpellsCastSinceBegOfYourLastTurn() List~Card~
        +resetSpellCastSinceBegOfYourLastTurn() void
        +addSpellCastSinceBegOfYourLastTurn(List~Card~ spells) void
        +getSpellsCastThisTurn() int
        +getSpellsCastLastTurn() int
        +addSpellCastThisTurn() void
        +resetSpellsCastThisTurn() void
        +setSpellsCastLastTurn(int num) void
        +getSpellsCastThisGame() int
        +resetSpellCastThisGame() void
        +getLifeGainedByTeamThisTurn() int
        +addLifeGainedByTeamThisTurn(int val) void
        +getLifeGainedThisTurn() int
        +setLifeGainedThisTurn(int n) void
        +getLifeGainedTimesThisTurn() int
        +getLifeLostThisTurn() int
        +setLifeLostThisTurn(int n) void
        +getLifeLostLastTurn() int
        +setLifeLostLastTurn(int n) void
        +getNumManaShards() int
        +setNumManaShards(int n) void
        +compareTo(Player o) int
        +setDraftNotes(Map~String,String~ notes) void
        +getDraftNotes() Map~String,String~
        +getLobbyPlayer() LobbyPlayer
        +getOriginalLobbyPlayer() LobbyPlayer
        +getRegisteredPlayer() RegisteredPlayer
        +getOutcome() PlayerOutcome
        -setOutcome(PlayerOutcome outcome) void
        +onGameOver() void
        +getCreaturesInPlay() CardCollection
        +getPlaneswalkersInPlay() CardCollection
        +getBattlesInPlay() CardCollection
        +getTokensInPlay() CardCollection
        +getLandsInPlay() CardCollection
        +isCardInPlay(String cardName) boolean
        +isCardInCommand(String cardName) boolean
        +getColoredCardsInPlay(String color) CardCollectionView
        +getColoredCardsInPlay(byte color) CardCollectionView
        +getAmountOfKeyword(String k) int
        +isTurnOrderReversed() boolean
        +isPhasesReversed() boolean
        +onCleanupPhase() void
        +canCastSorcery() boolean
        +getController() PlayerController
        +getControllingPlayer() Player
        +isControlled() boolean
        +addController(long timestamp, Player pl) void
        +addController(long timestamp, Player pl, PlayerController pc, boolean event) void
        +removeController(long timestamp) void
        +removeController(long timestamp, boolean event) void
        +clearController() void
        +getControlledWhileSearching() Map.Entry~Long,Player~
        +addControlledWhileSearching(long timestamp, Player pl) void
        +removeControlledWhileSearching(long timestamp) void
        +setFirstController(PlayerController ctrlr) void
        +dangerouslySetController(PlayerController ctrlr) void
        +updateAvatar() void
        +updateSleeve() void
        +runWithController(Runnable proc, PlayerController tempController) void
        +isSkippingCombat() boolean
        +getPlaneswalkedToThisTurn() List~Card~
        +planeswalk(SpellAbility sa) void
        +planeswalkTo(SpellAbility sa, CardCollectionView destinations) void
        +leaveCurrentPlane() void
        +removeCurrentPlane(Card c) void
        +initPlane() void
        +getInboundTokens() CardCollectionView
        +addInboundToken(Card c) void
        +removeInboundToken(Card c) void
        +onMulliganned() void
        +getCommanders() List~Card~
        +copyCommandersToSnapshot(Player toPlayer, Function~Card,Card~ mapper) void
        +addCommander(Card commander) void
        +removeCommander(Card commander) void
        +setCommanderReplacementSuppressed(boolean suppress) void
        +getCommanderDamage() Iterable~Entry~
        +getCommanderDamage(Card commander) int
        +addCommanderDamage(Card commander, int damage) void
        +getCommanderColorID() ColorSet
        +getNotCommanderColorID() ColorSet
        +getCommanderCast(Card commander) int
        +incCommanderCast(Card commander) void
        +resetCommanderStats() void
        +updateMergedCommanderInfo(Card target, Card commander) void
        +getTotalCommanderCast() int
        +isExtraTurn() boolean
        +setExtraTurn(boolean b) void
        +setHasLost(boolean b) void
        +getExtraTurnCount() int
        +setExtraTurnCount(int val) void
        +setHasPriority(boolean val) void
        +isAI() boolean
        +initVariantsZones(RegisteredPlayer registeredPlayer) void
        +initCommanderColor(Card cmd) void
        +allCardsUniqueManaSymbols() boolean
        +assignCompanion(Game game, PlayerController player) void
        +deckMatchesDeckRestriction(Card source, String restriction) boolean
        +createCompanionEffect(Card companion) DetachedCardEffect
        +createCommanderEffect() void
        +createPlanechaseEffects(Game game) void
        +createTheRing(String set) void
        +setRingLevel(int level) void
        +getNumRingTemptedYou() int
        +incrementRingTemptedYou() void
        +setNumRingTemptedYou(int value) void
        +resetRingTemptedYou() void
        +changeOwnership(Card card) void
        +destroyPhysicalCard(Card card) void
        +getLostOwnership() CardCollectionView
        +getGainedOwnership() CardCollectionView
        +getView() PlayerView
        +getPaidForSA() SpellAbility
        +pushPaidForSA(SpellAbility sa) void
        +popPaidForSA() void
        +clearPaidForSA() void
        +isStartingPlayer() boolean
        +isMonarch() boolean
        +getMonarchSet() String
        +createMonarchEffect(String set) void
        +removeMonarchEffect() void
        +canBecomeMonarch() boolean
        +getInitiativeSet() String
        +createInitiativeEffect(String set) void
        +hasInitiative() boolean
        +removeInitiativeEffect() void
        +getRadiationEffect() Card
        +createRadiationEffect(String setCode) void
        +removeRadiationEffect() void
        +hasRadiationEffect() boolean
        +getKeywordCard() Card
        +updateKeywordCardAbilityText() void
        +trimKeywords(String keywordTexts) String
        +checkKeywordCard() void
        +hasBlessing() boolean
        +setBlessing(boolean bless, String setCode) void
        +sameTeam(Player other) boolean
        +isCursed() boolean
        +canDiscardBy(SpellAbility sa, boolean effect) boolean
        +canSearchLibraryWith(SpellAbility sa, Player targetPlayer) boolean
        +addAdditionalVote(long timestamp, int value) void
        +removeAdditionalVote(long timestamp) void
        +getAdditionalVotesAmount() int
        +addAdditionalOptionalVote(long timestamp, int value) void
        +removeAdditionalOptionalVote(long timestamp) void
        +getAdditionalOptionalVotesAmount() int
        +addControlVote(long timestamp) boolean
        +removeControlVote(long timestamp) boolean
        ~updateControlVote() void
        +getControlVote() Set~Long~
        +setControlVote(Set~Long~ value) void
        +getHighestControlVote() Long
        +addAdditionalVillainousChoices(long timestamp, int value) void
        +removeAdditionalVillainousChoices(long timestamp) void
        +getAdditionalVillainousChoices() int
        +addCycled(SpellAbility sp) void
        +hasUrzaLands() boolean
        +revealFaceDownCards() void
        +learnLesson(SpellAbility sa, Map~AbilityKey,Object~ params) void
        +commitCrime() void
        +getCommittedCrimeThisTurn() int
        +setCommitedCrimeThisTurn(int v) void
        +getDiceRollsThisTurn() List~Integer~
        +addDieRollThisTurn(List~Integer~ rolls) void
        +getExpentThisTurn() int
        +setExpentThisTurn(int v) void
        +addExpentThisTurn(int v, SpellAbility sp) void
        +visitAttractions(int light) void
        +rollToVisitAttractions() void
        +getAttractionsVisitedThisTurn() int
        +getCrankCounter() int
        +setCrankCounter(int counters) void
        +advanceCrankCounter() void
        +createContraptionSprockets() void
        +addDeclaresAttackers(long ts, Player p) void
        +removeDeclaresAttackers(long ts) void
        +getDeclaresAttackers() Player
        +addDeclaresBlockers(long ts, Player p) void
        +removeDeclaresBlockers(long ts) void
        +getDeclaresBlockers() Player
        +getUnlockedDoors() List~String~
        +getDevotionMod() int
        +afterStaticAbilityLayer(StaticAbilityLayer layer) void
        +triggerElementalBend(TriggerType type) void
        +hasAllElementBend() boolean
        +Player(String name0, Game game0, int id0)
    }
    Player --|> GameEntity : extends
    Player ..|> Comparable : implements
    Player ..> AbilityKey : uses
    Player ..> AbilitySub : uses
    Player ..> AchievementTracker : uses
    Player ..> Card : uses
    Player ..> CardCollection : uses
    Player ..> CardCollectionView : uses
    Player ..> CardState : uses
    Player ..> CardStateName : uses
    Player ..> CardTraitBase : uses
    Player ..> CardType : uses
    Player ..> ColorSet : uses
    Player ..> Companion : uses
    Player ..> CoreType : uses
    Player ..> CounterType : uses
    Player ..> DetachedCardEffect : uses
    Player ..> EmptySa : uses
    Player ..> FCollection : uses
    Player ..> Game : uses
    Player ..> GameEntityCounterTable : uses
    Player ..> GameEventAddLog : uses
    Player ..> GameEventCardSacrificed : uses
    Player ..> GameEventLandPlayed : uses
    Player ..> GameEventManaBurn : uses
    Player ..> GameEventMulligan : uses
    Player ..> GameEventPlayerControl : uses
    Player ..> GameEventPlayerCounters : uses
    Player ..> GameEventPlayerDamaged : uses
    Player ..> GameEventPlayerLivesChanged : uses
    Player ..> GameEventPlayerPoisoned : uses
    Player ..> GameEventPlayerRadiation : uses
    Player ..> GameEventPlayerShardsChanged : uses
    Player ..> GameEventPlayerStatsChanged : uses
    Player ..> GameEventShuffle : uses
    Player ..> GameEventSpeedChanged : uses
    Player ..> GameEventSurveil : uses
    Player ..> GameEventZone : uses
    Player ..> GameLossReason : uses
    Player ..> IGameEntitiesFactory : uses
    Player ..> IKeywordsChange : uses
    Player ..> IPaperCard : uses
    Player ..> Keyword : uses
    Player ..> KeywordCollection : uses
    Player ..> KeywordInterface : uses
    Player ..> KeywordsChange : uses
    Player ..> LobbyPlayer : uses
    Player ..> Localizer : uses
    Player ..> ManaCost : uses
    Player ..> ManaCostShard : uses
    Player ..> ManaPool : uses
    Player ..> PaperCard : uses
    Player ..> PhaseHandler : uses
    Player ..> PlayerCollection : uses
    Player ..> PlayerController : uses
    Player ..> PlayerOutcome : uses
    Player ..> PlayerStatistics : uses
    Player ..> PlayerView : uses
    Player ..> PlayerZone : uses
    Player ..> PlayerZoneBattlefield : uses
    Player ..> RegisteredPlayer : uses
    Player ..> ReplacementEffect : uses
    Player ..> SpellAbility : uses
    Player ..> StaticAbility : uses
    Player ..> StaticAbilityLayer : uses
    Player ..> Trigger : uses
    Player ..> TriggerHandler : uses
    Player ..> TriggerType : uses
    Player ..> Zone : uses
    Player ..> ZoneType : uses
```

## Relationships
**Extends:**
- [[forge.game.GameEntity|GameEntity]]
**Uses:**
- [[forge.LobbyPlayer|LobbyPlayer]]
- [[forge.card.CardStateName|CardStateName]]
- [[forge.card.CardType|CardType]]
- [[forge.card.CardType.CoreType|CoreType]]
- [[forge.card.ColorSet|ColorSet]]
- [[forge.card.mana.ManaCost|ManaCost]]
- [[forge.card.mana.ManaCostShard|ManaCostShard]]
- [[forge.game.CardTraitBase|CardTraitBase]]
- [[forge.game.Game|Game]]
- [[forge.game.GameEntityCounterTable|GameEntityCounterTable]]
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.ability.effects.DetachedCardEffect|DetachedCardEffect]]
- [[forge.game.card.Card|Card]]
- [[forge.game.card.CardCollection|CardCollection]]
- [[forge.game.card.CardCollectionView|CardCollectionView]]
- [[forge.game.card.CardState|CardState]]
- [[forge.game.card.CounterType|CounterType]]
- [[forge.game.event.GameEventAddLog|GameEventAddLog]]
- [[forge.game.event.GameEventCardSacrificed|GameEventCardSacrificed]]
- [[forge.game.event.GameEventLandPlayed|GameEventLandPlayed]]
- [[forge.game.event.GameEventManaBurn|GameEventManaBurn]]
- [[forge.game.event.GameEventMulligan|GameEventMulligan]]
- [[forge.game.event.GameEventPlayerControl|GameEventPlayerControl]]
- [[forge.game.event.GameEventPlayerCounters|GameEventPlayerCounters]]
- [[forge.game.event.GameEventPlayerDamaged|GameEventPlayerDamaged]]
- [[forge.game.event.GameEventPlayerLivesChanged|GameEventPlayerLivesChanged]]
- [[forge.game.event.GameEventPlayerPoisoned|GameEventPlayerPoisoned]]
- [[forge.game.event.GameEventPlayerRadiation|GameEventPlayerRadiation]]
- [[forge.game.event.GameEventPlayerShardsChanged|GameEventPlayerShardsChanged]]
- [[forge.game.event.GameEventPlayerStatsChanged|GameEventPlayerStatsChanged]]
- [[forge.game.event.GameEventShuffle|GameEventShuffle]]
- [[forge.game.event.GameEventSpeedChanged|GameEventSpeedChanged]]
- [[forge.game.event.GameEventSurveil|GameEventSurveil]]
- [[forge.game.event.GameEventZone|GameEventZone]]
- [[forge.game.keyword.Companion|Companion]]
- [[forge.game.keyword.IKeywordsChange|IKeywordsChange]]
- [[forge.game.keyword.Keyword|Keyword]]
- [[forge.game.keyword.KeywordCollection|KeywordCollection]]
- [[forge.game.keyword.KeywordInterface|KeywordInterface]]
- [[forge.game.keyword.KeywordsChange|KeywordsChange]]
- [[forge.game.mana.ManaPool|ManaPool]]
- [[forge.game.phase.PhaseHandler|PhaseHandler]]
- [[forge.game.player.AchievementTracker|AchievementTracker]]
- [[forge.game.player.GameLossReason|GameLossReason]]
- [[forge.game.player.IGameEntitiesFactory|IGameEntitiesFactory]]
- [[forge.game.player.PlayerCollection|PlayerCollection]]
- [[forge.game.player.PlayerController|PlayerController]]
- [[forge.game.player.PlayerOutcome|PlayerOutcome]]
- [[forge.game.player.PlayerStatistics|PlayerStatistics]]
- [[forge.game.player.PlayerView|PlayerView]]
- [[forge.game.player.RegisteredPlayer|RegisteredPlayer]]
- [[forge.game.replacement.ReplacementEffect|ReplacementEffect]]
- [[forge.game.spellability.AbilitySub|AbilitySub]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]
- [[forge.game.spellability.SpellAbility.EmptySa|EmptySa]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]
- [[forge.game.staticability.StaticAbilityLayer|StaticAbilityLayer]]
- [[forge.game.trigger.Trigger|Trigger]]
- [[forge.game.trigger.TriggerHandler|TriggerHandler]]
- [[forge.game.trigger.TriggerType|TriggerType]]
- [[forge.game.zone.PlayerZone|PlayerZone]]
- [[forge.game.zone.PlayerZoneBattlefield|PlayerZoneBattlefield]]
- [[forge.game.zone.Zone|Zone]]
- [[forge.game.zone.ZoneType|ZoneType]]
- [[forge.item.IPaperCard|IPaperCard]]
- [[forge.item.PaperCard|PaperCard]]
- [[forge.util.Localizer|Localizer]]
- [[forge.util.collect.FCollection|FCollection]]

## Design Description

The Player class models a single participant in a Magic: the Gathering match, serving as the central aggregate for all per-player game state: life, counters, keywords, mana, the full set of zones (library, hand, battlefield, graveyard, command, and variant decks), and a large body of per-turn statistics tracking draws, lands, spells cast, sacrifices, and format-specific mechanics like commander damage, the monarchy, the Ring, radiation, and speed. Extending GameEntity, it inherits damage and counter handling while implementing Comparable for ordering by name, and it delegates decision-making to a pluggable PlayerController, enabling AI or human play and mind-slave control via timestamped overrides.

Its design intent is rules-faithful mutation: life changes, draws, mills, and counter additions route through the Game's ReplacementHandler and TriggerHandler and fire GameEvents to keep the PlayerView synchronized, cleanly separating game logic from presentation. It collaborates closely with Card/CardCollection, the zone system, and numerous StaticAbility helpers, and constructs in-game effect cards (commander, monarch, Ring) to embody special-format rules as ordinary triggered abilities.

## Source
`forge-game/src/main/java/forge/game/player/Player.java`

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
package forge.game.player;

import com.google.common.collect.*;
import forge.ImageKeys;
import forge.LobbyPlayer;
import forge.StaticData;
import forge.card.*;
import forge.card.mana.ManaCost;
import forge.card.mana.ManaCostShard;
import forge.game.*;
import forge.game.ability.AbilityFactory;
import forge.game.ability.AbilityKey;
import forge.game.ability.AbilityUtils;
import forge.game.ability.ApiType;
import forge.game.ability.effects.DetachedCardEffect;
import forge.game.ability.effects.RollDiceEffect;
import forge.game.card.*;
import forge.game.event.*;
import forge.game.keyword.*;
import forge.game.mana.ManaPool;
import forge.game.phase.PhaseHandler;
import forge.game.phase.PhaseType;
import forge.game.replacement.ReplacementEffect;
import forge.game.replacement.ReplacementHandler;
import forge.game.replacement.ReplacementResult;
import forge.game.replacement.ReplacementType;
import forge.game.spellability.AbilitySub;

import forge.game.spellability.AlternativeCost;
import forge.game.spellability.SpellAbility;
import forge.game.staticability.*;
import forge.game.trigger.Trigger;
import forge.game.trigger.TriggerHandler;
import forge.game.trigger.TriggerType;
import forge.game.zone.PlayerZone;
import forge.game.zone.PlayerZoneBattlefield;
import forge.game.zone.Zone;
import forge.game.zone.ZoneType;
import forge.item.IPaperCard;
import forge.item.PaperCard;
import forge.util.*;
import forge.util.collect.FCollection;
import org.apache.commons.lang3.tuple.Pair;

import java.util.*;
import java.util.Map.Entry;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * <p>
 * Abstract Player class.
 * </p>
 *
 * @author Forge
 * @version $Id$
 */
public class Player extends GameEntity implements Comparable<Player> {
    public static final List<ZoneType> ALL_ZONES = Collections.unmodifiableList(Arrays.asList(ZoneType.Battlefield,
            ZoneType.Library, ZoneType.Graveyard, ZoneType.Hand, ZoneType.Exile, ZoneType.Command, ZoneType.Ante,
            ZoneType.Sideboard, ZoneType.PlanarDeck, ZoneType.SchemeDeck, ZoneType.AttractionDeck, ZoneType.ContraptionDeck,
            ZoneType.Junkyard, ZoneType.Merged, ZoneType.Subgame, ZoneType.None));

    private int life = 20;
    private int startingLife = 20;
    private int lifeStartedThisTurnWith = startingLife;
    private int lifeLostThisTurn;
    private int lifeLostLastTurn;
    private int lifeGainedThisTurn;
    private int lifeGainedTimesThisTurn;
    private int lifeGainedByTeamThisTurn;
    private int maxHandSize = 7;
    private int startingHandSize = 7;
    private boolean unlimitedHandSize = false;
    private Card lastDrawnCard;
    private int numDrawnThisTurn;
    private int numDrawnLastTurn;
    private int numDrawnThisDrawStep;
    private int numCardsInHandStartedThisTurnWith;
    private int numExploredThisTurn;
    private int numTokenCreatedThisTurn;
    private int numForetoldThisTurn;
    private int landsPlayedThisTurn;
    private int landsPlayedLastTurn;
    private int numPowerSurgeLands;
    private int spellsCastThisTurn;
    private int spellsCastThisGame;
    private int spellsCastLastTurn;
    private List<Card> spellsCastSinceBeginningOfLastTurn = Lists.newArrayList();
    private int investigatedThisTurn;
    private int surveilThisTurn;
    private int committedCrimeThisTurn;
    private int numFlipsThisTurn;
    private int numRollsThisTurn;
    private List<Integer> diceRollsThisTurn = Lists.newArrayList();
    private int expentThisTurn;
    private int numLibrarySearchedOwn; //The number of times this player has searched his library
    private int venturedThisTurn;
    private int attractionsVisitedThisTurn;
    private int descended;
    private int numRingTemptedYou;
    private int devotionMod;
    private Card ringBearer, theRing;
    private int speed;

    private List<Card> discardedThisTurn = new ArrayList<>();
    private List<Card> sacrificedThisTurn = new ArrayList<>();

    private int simultaneousDamage = 0;

    private int lastTurnNr = 0;

    private String namedCard = "";

    private final Map<String, FCollection<String>> notes = Maps.newHashMap();
    private final Map<String, Integer> notedNum = Maps.newHashMap();
    private final Map<String, String> draftNotes = Maps.newHashMap();

    /** A list of tokens not in play, but on their way.
     * This list is kept in order to not break ETB-replacement
     * on tokens. */
    private CardCollection inboundTokens = new CardCollection();

    private KeywordCollection keywords = new KeywordCollection();
    // stores the keywords created by static abilities
    private final Table<Long, String, KeywordInterface> storedKeywords = TreeBasedTable.create();
    private Table<Long, Long, IKeywordsChange> changedKeywords = TreeBasedTable.create();

    private Map<GameEntity, List<Card>> attackedThisTurn = new HashMap<>();
    private List<Player> attackedPlayersLastTurn = new ArrayList<>();
    private List<Player> attackedPlayersThisCombat = new ArrayList<>();

    private boolean beenDealtCombatDamageSinceLastTurn = false;

    private boolean tappedLandForManaThisTurn = false;

    private final Map<ZoneType, PlayerZone> zones = Maps.newEnumMap(ZoneType.class);
    private List<PlayerZone> extraZones = null;

    private final Map<Long, Integer> adjustLandPlays = Maps.newHashMap();
    private final Set<Long> adjustLandPlaysInfinite = Sets.newHashSet();
    private Map<Card, Card> maingameCardsMap = Maps.newHashMap();

    private CardCollection currentPlanes = new CardCollection();
    private CardCollection planeswalkedToThisTurn = new CardCollection();

    private Card activeScheme = null;

    private NavigableMap<Long, Pair<Player, PlayerController>> controlledBy = Maps.newTreeMap();
    private NavigableMap<Long, Player> controlledWhileSearching = Maps.newTreeMap();

    private int numManaShards;

    private int teamNumber = -1;

    private PlayerController controller;
    private final Game game;

    private boolean triedToDrawFromEmptyLibrary = false;
    private CardCollection lostOwnership = new CardCollection();
    private CardCollection gainedOwnership = new CardCollection();

    private ManaPool manaPool = new ManaPool(this);
    // The SA currently being paid for
    private Deque<SpellAbility> paidForStack = new ArrayDeque<>();

    private List<Card> completedDungeons = new ArrayList<>();

    private final CardCollection commanders = new CardCollection();
    private final Map<Card, Integer> commanderCast = Maps.newHashMap();
    private final Map<Card, Integer> commanderDamage = Maps.newHashMap();
    private DetachedCardEffect commanderEffect = null;

    private Card monarchEffect;
    private Card initiativeEffect;
    private Card blessingEffect;
    private Card contraptionSprocketEffect;
    private Card radiationEffect;
    private Card keywordEffect;
    private Card speedEffect;

    private Map<Long, Integer> additionalVotes = Maps.newHashMap();
    private Map<Long, Integer> additionalOptionalVotes = Maps.newHashMap();
    private SortedSet<Long> controlVotes = Sets.newTreeSet();
    private Map<Long, Integer> additionalVillainousChoices = Maps.newHashMap();

    private EnumSet<TriggerType> elementalBendThisTurn = EnumSet.noneOf(TriggerType.class);

    private NavigableMap<Long, Player> declaresAttackers = Maps.newTreeMap();
    private NavigableMap<Long, Player> declaresBlockers = Maps.newTreeMap();

    private int crankCounter = 3;

    private PlayerStatistics stats = new PlayerStatistics();

    private final AchievementTracker achievementTracker = new AchievementTracker();
    private final PlayerView view;

    public Player(String name0, Game game0, final int id0) {
        super(id0);

        game = game0;
        for (final ZoneType z : Player.ALL_ZONES) {
            final PlayerZone toPut = z == ZoneType.Battlefield ? new PlayerZoneBattlefield(z, this) : new PlayerZone(z, this);
            zones.put(z, toPut);
        }

        view = new PlayerView(id0, game.getTracker());
        view.updateMaxHandSize(this);
        view.updateKeywords(this);
        view.updateMaxLandPlay(this);
        view.setDraftNotes(this.getDraftNotes());
        setName(chooseName(name0));
        if (id0 >= 0) {
            game.addPlayer(id, this);
        }
    }

    public final AchievementTracker getAchievementTracker() {
        return achievementTracker;
    }

    private String chooseName(String originalName) {
        String nameCandidate = originalName;
        for (int i = 2; i <= 8; i++) { // several tries, not matter how many
            boolean haveDuplicates = false;
            for (Player p : game.getPlayers()) {
                if (p.getName().equals(nameCandidate)) {
                    haveDuplicates = true;
                    break;
                }
            }
            if (!haveDuplicates) {
                return nameCandidate;
            }
            nameCandidate = Lang.getInstance().getOrdinal(i) + " " + originalName;
        }
        return nameCandidate;
    }

    @Override
    public Game getGame() {
        return game;
    }

    public final PlayerStatistics getStats() {
        return stats;
    }

    public final int getTeam() {
        return teamNumber;
    }
    public final void setTeam(int iTeam) {
        teamNumber = iTeam;
    }

    public boolean isArchenemy() {
        return getZone(ZoneType.SchemeDeck).size() > 0; //Only the archenemy has schemes.
    }

    public Card getActiveScheme() {
        return activeScheme;
    }

    public void setSchemeInMotion(SpellAbility cause) {
        setSchemeInMotion(cause, getZone(ZoneType.SchemeDeck).get(0));
    }
    public void setSchemeInMotion(SpellAbility cause, Card scheme) {
        if (game.getReplacementHandler().run(ReplacementType.SetInMotion, AbilityKey.mapFromAffected(this)) != ReplacementResult.NotReplaced) {
            return;
        }

        Map<AbilityKey, Object> moveParams = AbilityKey.newMap();
        moveParams.put(AbilityKey.LastStateBattlefield, game.getLastStateBattlefield());
        moveParams.put(AbilityKey.LastStateGraveyard, game.getLastStateGraveyard());

        game.getAction().moveToCommand(scheme, cause);

        final Map<AbilityKey, Object> runParams = AbilityKey.newMap();
        runParams.put(AbilityKey.Scheme, scheme);
        game.getTriggerHandler().runTrigger(TriggerType.SetInMotion, runParams, false);
    }

    /**
     * returns all players.
     */
    public final PlayerCollection getRegisteredPlayers() {
        return game.getRegisteredPlayers();
    }

    /**
     * returns all opponents.
     * Should keep player relations somewhere in the match structure
     */
    public final PlayerCollection getOpponents() {
        return game.getPlayersInTurnOrder(this).filter(PlayerPredicates.isOpponentOf(this));
    }

    public final PlayerCollection getRegisteredOpponents() {
        return game.getRegisteredPlayers().filter(PlayerPredicates.isOpponentOf(this));
    }

    public void updateOpponentsForView() {
        view.updateOpponents(this);
    }

    public void updateFlashbackForView() {
        view.updateFlashback(this);
        game.fireEvent(new GameEventZone(ZoneType.Flashback, this, EventValueChangeType.Added, null));
    }

    //get single opponent for player if only one, otherwise returns null
    //meant to be used after game ends for the sake of achievements
    public Player getSingleOpponent() {
        if (game.getRegisteredPlayers().size() == 2) {
            for (Player p : game.getRegisteredPlayers()) {
                if (p.isOpponentOf(this)) {
                    return p;
                }
            }
        }
        return null;
    }

    /**
     * Find the smallest life total amongst this player's opponents.
     */
    public final int getOpponentsSmallestLifeTotal() {
        return Aggregates.min(getOpponents(), Player::getLife);
    }

    /**
     * Find the greatest life total amongst this player's opponents.
     */
    public final int getOpponentsGreatestLifeTotal() {
        return Aggregates.max(getOpponents(), Player::getLife);
    }

    /**
     * Get the total number of poison counters amongst this player's opponents.
     */
    public final int getOpponentsTotalPoisonCounters() {
        return Aggregates.sum(getOpponents(), Player::getPoisonCounters);
    }

    /**
     * returns allied players.
     * Should keep player relations somewhere in the match structure
     */
    public final PlayerCollection getAllies() {
        return getAllOtherPlayers().filter(PlayerPredicates.isOpponentOf(this).negate());
    }

    public final PlayerCollection getTeamMates(final boolean inclThis) {
        PlayerCollection col = new PlayerCollection();
        if (inclThis) {
            col.add(this);
        }
        col.addAll(getAllOtherPlayers().filter(PlayerPredicates.sameTeam(this)));
        return col;
    }

    /**
     * returns allied players.
     * Should keep player relations somewhere in the match structure
     */
    public final PlayerCollection getYourTeam() {
        return getTeamMates(true);
    }

    /**
     * returns all other players.
     * Should keep player relations somewhere in the match structure
     */
    public final PlayerCollection getAllOtherPlayers() {
        PlayerCollection result = new PlayerCollection(game.getPlayers());
        result.remove(this);
        return result;
    }

    /**
     * returns the weakest opponent (based on life totals).
     * Should keep player relations somewhere in the match structure
     */
    public final Player getWeakestOpponent() {
        return getOpponents().min(PlayerPredicates.compareByLife());
    }
    public final Player getStrongestOpponent() {
        return getOpponents().max(PlayerPredicates.compareByLife());
    }

    public boolean isOpponentOf(Player other) {
        return other != this && other != null && (other.teamNumber < 0 || other.teamNumber != teamNumber);
    }
    public boolean isOpponentOf(String other) {
        Player otherPlayer = null;
        for (Player p : game.getPlayers()) {
            if (p.getName().equals(other)) {
                otherPlayer = p;
                break;
            }
        }
        return isOpponentOf(otherPlayer);
    }

    public final boolean setLife(final int newLife, final SpellAbility sa) {
        boolean change = false;
        // rule 119.5
        if (life > newLife) {
            change = loseLife(life - newLife, false, false) > 0;
        }
        else if (newLife > life) {
            change = gainLife(newLife - life, sa == null ? null : sa.getHostCard(), sa);
        }
        else { // life == newLife
            change = false;
        }
        return change;
    }

    public final int getStartingLife() {
        return startingLife;
    }
    public final void setStartingLife(final int startLife) {
        //Should only be called from newGame().
        startingLife = startLife;
        life = startLife;
        view.updateLife(this);
    }

    public final int getLife() {
        return life;
    }

    public final boolean gainLife(int lifeGain, final Card source, final SpellAbility sa) {
        if (!canGainLife() || lifeGain <= 0) {
            return false;
        }

        final Map<AbilityKey, Object> repParams = AbilityKey.mapFromAffected(this);
        repParams.put(AbilityKey.LifeGained, lifeGain);
        repParams.put(AbilityKey.SourceSA, sa);

        switch (getGame().getReplacementHandler().run(ReplacementType.GainLife, repParams)) {
        case NotReplaced:
            break;
        case Updated:
            // check if this is still the affected player
            if (this.equals(repParams.get(AbilityKey.Affected))) {
                lifeGain = (int) repParams.get(AbilityKey.LifeGained);
            } else {
                return false;
            }
            break;
        default:
            return false;
        }

        if (lifeGain <= 0) {
            return false;
        }

        int oldLife = life;
        life += lifeGain;
        view.updateLife(this);
        boolean firstGain = lifeGainedTimesThisTurn == 0;
        lifeGainedThisTurn += lifeGain;
        lifeGainedTimesThisTurn++;

        // team mates need to be notified about life gained
        for (final Player p : getTeamMates(true)) {
            p.addLifeGainedByTeamThisTurn(lifeGain);
        }

        final Map<AbilityKey, Object> runParams = AbilityKey.mapFromPlayer(this);
        runParams.put(AbilityKey.LifeAmount, lifeGain);
        runParams.put(AbilityKey.Source, source);
        runParams.put(AbilityKey.SourceSA, sa);
        runParams.put(AbilityKey.FirstTime, firstGain);
        game.getTriggerHandler().runTrigger(TriggerType.LifeGained, runParams, false);

        game.fireEvent(new GameEventPlayerLivesChanged(this, oldLife, life));
        return true;
    }

    public final boolean canGainLife() {
        return isInGame() && !StaticAbilityCantGainLosePayLife.anyCantGainLife(this);
    }

    public final int loseLife(int toLose, final boolean damage, final boolean manaBurn) {
        // Rule 118.4
        // this is for players being able to pay 0 life nothing to do
        // no trigger for lost no life
        if (toLose <= 0 || !canLoseLife()) {
            return 0;
        }
        int oldLife = life;

        final Map<AbilityKey, Object> repParams = AbilityKey.mapFromAffected(this);
        repParams.put(AbilityKey.Amount, toLose);
        repParams.put(AbilityKey.IsDamage, damage);

        switch (getGame().getReplacementHandler().run(ReplacementType.LifeReduced, repParams)) {
        case NotReplaced:
            break;
        case Updated:
            // check if this is still the affected player
            if (this.equals(repParams.get(AbilityKey.Affected))) {
                toLose = (int) repParams.get(AbilityKey.Amount);
                // there is nothing that changes lifegain into lifeloss this way
                if (toLose <= 0) {
                    return 0;
                }
            } else {
                return 0;
            }
            break;
        default:
            return 0;
        }

        life -= toLose;
        view.updateLife(this);
        if (manaBurn) {
            game.fireEvent(new GameEventManaBurn(PlayerView.get(this), true, toLose));
        } else {
            game.fireEvent(new GameEventPlayerLivesChanged(this, oldLife, life));
        }

        boolean firstLost = lifeLostThisTurn == 0;
        lifeLostThisTurn += toLose;

        final Map<AbilityKey, Object> runParams = AbilityKey.mapFromPlayer(this);
        runParams.put(AbilityKey.LifeAmount, toLose);
        runParams.put(AbilityKey.FirstTime, firstLost);
        game.getTriggerHandler().runTrigger(TriggerType.LifeLost, runParams, false);

        return toLose;
    }

    public final boolean canLoseLife() {
        return isInGame() && !StaticAbilityCantGainLosePayLife.anyCantLoseLife(this);
    }

    public final boolean canPayLife(final int lifePayment, final boolean effect, SpellAbility cause) {
        if (lifePayment > 0 && life < lifePayment) {
            return false;
        }
        return lifePayment <= 0 || !StaticAbilityCantGainLosePayLife.anyCantPayLife(this, effect, cause);
    }

    public final boolean payLife(final int lifePayment, final SpellAbility cause, final boolean effect) {
        // fast check for pay zero life
        if (lifePayment <= 0) {
            cause.setPaidLife(0);
            return true;
        }

        if (!canPayLife(lifePayment, effect, cause)) {
            return false;
        }

        // Replacement only matters when life payment is greater than 0
        Map<AbilityKey, Object> replaceParams = AbilityKey.mapFromAffected(this);
        replaceParams.put(AbilityKey.Amount, lifePayment);
        replaceParams.put(AbilityKey.Cause, cause);
        replaceParams.put(AbilityKey.EffectOnly, effect);
        // copy replacement params?
        if (cause.isReplacementAbility() && effect) {
            replaceParams.putAll(cause.getReplacingObjects());
        }
        switch (getGame().getReplacementHandler().run(ReplacementType.PayLife, replaceParams)) {
        case Replaced:
            return true;
        case Prevented:
        case Skipped:
            return false;
        default:
            break;
        }

        final int lost = loseLife(lifePayment, false, false);
        cause.setPaidLife(lifePayment);

        final Map<AbilityKey, Object> runParams = AbilityKey.mapFromPlayer(this);
        runParams.put(AbilityKey.LifeAmount, lifePayment);
        game.getTriggerHandler().runTrigger(TriggerType.PayLife, runParams, false);

        if (lost > 0) { // Run triggers if player actually lost life
            boolean runAll = false;
            Map<Player, Integer> lossMap = cause.getLoseLifeMap();
            if (lossMap == null) {
                lossMap = Maps.newHashMap();
                runAll = true;
            }
            lossMap.put(this, lost);
            if (runAll) {
                final Map<AbilityKey, Object> runParams2 = AbilityKey.mapFromPIMap(lossMap);
                game.getTriggerHandler().runTrigger(TriggerType.LifeLostAll, runParams2, false);
            }
        }

        return true;
    }

    public final boolean canPayEnergy(final int energyPayment) {
        int cnt = getCounters(CounterEnumType.ENERGY);
        return cnt >= energyPayment;
    }

    public final boolean loseEnergy(int lostEnergy) {
        int cnt = getCounters(CounterEnumType.ENERGY);
        if (lostEnergy > cnt) {
            return false;
        }
        subtractCounter(CounterEnumType.ENERGY, lostEnergy, this);
        return true;
    }

    public final boolean payEnergy(final int energyPayment, final Card source) {
        if (energyPayment <= 0)
            return true;

        return canPayEnergy(energyPayment) && loseEnergy(energyPayment);
    }

    public final boolean canPayShards(final int shardPayment) {
        int cnt = getNumManaShards();
        return cnt >= shardPayment;
    }

    public final int loseShards(int lostShards) {
        int cnt = getNumManaShards();
        if (lostShards > cnt) {
            return -1;
        }
        cnt -= lostShards;
        this.setNumManaShards(cnt);
        return cnt;
    }

    public final boolean payShards(final int shardPayment, final Card source) {
        if (shardPayment <= 0)
            return true;

        return canPayShards(shardPayment) && loseShards(shardPayment) > -1;
    }

    // This function handles damage after replacement and prevention effects are applied
    @Override
    public final int addDamageAfterPrevention(final int amount, final Card source, final SpellAbility cause, final boolean isCombat, GameEntityCounterTable counterTable) {
        if (amount <= 0 || hasLost()) {
            return 0;
        }

        boolean infect = source.isInfectDamage(this);

        int poisonCounters = 0;
        if (infect) {
            poisonCounters += amount;
        }
        else {
            // rule 118.2. Damage dealt to a player normally causes that player to lose that much life.
            simultaneousDamage += amount;
        }

        if (isCombat) {
            poisonCounters += source.getKeywordMagnitude(Keyword.TOXIC);
        }

        if (poisonCounters > 0) {
            addPoisonCounters(poisonCounters, source.getController(), counterTable);
        }

        //Oathbreaker, Tiny Leaders, and Brawl ignore commander damage rule
        if (source.isCommander() && isCombat
                && !this.getGame().getRules().hasAppliedVariant(GameType.Oathbreaker)
                && !this.getGame().getRules().hasAppliedVariant(GameType.TinyLeaders)
                && !this.getGame().getRules().hasAppliedVariant(GameType.Brawl)) {
            // In case that commander is merged permanent, get the real commander card
            final Card realCommander = source.getRealCommander();
            addCommanderDamage(realCommander, amount);
            view.updateCommanderDamage(this);
            if (realCommander != source) {
                view.updateMergedCommanderDamage(source, realCommander);
            }
        }

        final Map<AbilityKey, Object> runParams = AbilityKey.newMap();
        runParams.put(AbilityKey.DamageSource, source);
        runParams.put(AbilityKey.DamageTarget, this);
        runParams.put(AbilityKey.Cause, cause);
        runParams.put(AbilityKey.DamageAmount, amount);
        runParams.put(AbilityKey.IsCombatDamage, isCombat);
        // Defending player at the time the damage was dealt
        runParams.put(AbilityKey.DefendingPlayer, game.getCombat() != null ? game.getCombat().getDefendingPlayerRelatedTo(source) : null);
        game.getTriggerHandler().runTrigger(TriggerType.DamageDone, runParams, isCombat);

        game.fireEvent(new GameEventPlayerDamaged(PlayerView.get(this), CardView.get(source), amount, isCombat, infect));

        return amount;
    }

    // This is usable by the AI to forecast an effect (so it must
    // not change the game state)
    // 2012/01/02: No longer used in calculating the finalized damage, but
    // retained for damageprediction. -Hellfish
    // TODO make this more generic in looking at the ReplacementEffects
    @Override
    public final int staticReplaceDamage(final int damage, final Card source, final boolean isCombat) {
        int restDamage = damage;

        // TODO handle life loss replacement

        for (Card c : game.getCardsIn(ZoneType.Battlefield)) {
            if (c.getName().equals("Sulfuric Vapors")) {
                if (source.isSpell() && source.isRed()) {
                    restDamage += 1;
                }
            } else if (c.getName().equals("Pyromancer's Swath")) {
                if (c.getController().equals(source.getController()) && (source.isInstant() || source.isSorcery())) {
                    restDamage += 2;
                }
            } else if (c.getName().equals("Pyromancer's Gauntlet")) {
                if (c.getController().equals(source.getController()) && source.isRed()
                        && (source.isInstant() || source.isSorcery() || source.isPlaneswalker())) {
                    restDamage += 2;
                }
            } else if (c.getName().equals("Furnace of Rath") || c.getName().equals("Dictate of the Twin Gods")) {
                restDamage *= 2;
            } else if (c.getName().equals("Gratuitous Violence")) {
                if (c.getController().equals(source.getController()) && source.isCreature()) {
                    restDamage *= 2;
                }
            } else if (c.getName().equals("Fire Servant")) {
                if (c.getController().equals(source.getController()) && source.isRed()
                        && (source.isInstant() || source.isSorcery())) {
                    restDamage *= 2;
                }
            } else if (c.getName().equals("Curse of Bloodletting")) {
                if (c.getEntityAttachedTo().equals(this)) {
                    restDamage *= 2;
                }
            } else if (c.getName().equals("Gisela, Blade of Goldnight")) {
                if (!c.getController().equals(this)) {
                    restDamage *= 2;
                }
            } else if (c.getName().equals("Inquisitor's Flail")) {
                if (isCombat && c.getEquipping() != null && c.getEquipping().equals(source)) {
                    restDamage *= 2;
                }
            } else if (c.getName().equals("Ghosts of the Innocent")) {
                restDamage = restDamage / 2;
            } else if (c.getName().equals("Benevolent Unicorn")) {
                if (source.isSpell()) {
                    restDamage -= 1;
                }
            } else if (c.getName().equals("Divine Presence")) {
                if (restDamage > 3) {
                    restDamage = 3;
                }
            } else if (c.getName().equals("Forethought Amulet")) {
                if (c.getController().equals(this) && (source.isInstant() || source.isSorcery())
                        && restDamage > 2) {
                    restDamage = 2;
                }
            } else if (c.getName().equals("Elderscale Wurm")) {
                if (c.getController().equals(this) && getLife() >= 7 && getLife() - restDamage < 7) {
                    restDamage = getLife() - 7;
                    if (restDamage < 0) {
                        restDamage = 0;
                    }
                }
            } else if (c.getName().equals("Obosh, the Preypiercer")) {
                if (c.getController().equals(source.getController()) && source.getCMC() % 2 != 0) {
                    restDamage *= 2;
                }
            }
        }

        // TODO: improve such that this can be predicted from the replacement effect itself
        // (+ move this function out into ComputerUtilCombat?)
        for (Card c : game.getCardsIn(ZoneType.Command)) {
            if (c.getName().equals("Insult Effect")) {
                if (c.getController().equals(source.getController())) {
                    restDamage *= 2;
                }
            } else if (c.getName().equals("Mishra")) {
                if (c.isCreature() && c.getController().equals(source.getController())) {
                    restDamage *= 2;
                }
            }
        }

        return restDamage;
    }

    public final int processDamage() {
        int lost = loseLife(simultaneousDamage, true, false);
        simultaneousDamage = 0;
        return lost;
    }

    /**
     * Get the total damage assigned to this player's opponents this turn.
     */
    public final int getOpponentsAssignedDamage() {
        return Aggregates.sum(getOpponents(), GameEntity::getAssignedDamage);
    }

    /**
     * Get the greatest amount of damage assigned to a single opponent this turn.
     */
    public final int getMaxOpponentAssignedDamage() {
        return Aggregates.max(getRegisteredOpponents(), GameEntity::getAssignedDamage);
    }

    /**
     * Get the greatest amount of combat damage assigned to a single player this turn.
     */
    public final int getMaxAssignedCombatDamage() {
        return Aggregates.max(getRegisteredPlayers(), GameEntity::getAssignedCombatDamage);
    }

    public final boolean canReceiveCounters(final CounterType type) {
        if (!isInGame()) {
            return false;
        }
        if (StaticAbilityCantPutCounter.anyCantPutCounter(this, type)) {
            return false;
        }
        return true;
    }

    public final boolean canRemoveCounters(final CounterType type) {
        if (!isInGame()) {
            return false;
        }
        // no RE affecting players currently, skip check for performance
        return true;
    }

    @Override
    public void addCounterInternal(final CounterType counterType, final int n, final Player source, final boolean fireEvents, GameEntityCounterTable table, Map<AbilityKey, Object> params) {
        int addAmount = n;
        if (addAmount <= 0 || !canReceiveCounters(counterType)) {
            // As per rule 107.1b
            return;
        }

        final int oldValue = getCounters(counterType);
        final int newValue = addAmount + oldValue;
        this.setCounters(counterType, newValue, source, fireEvents);

        if (counterType.is(CounterEnumType.RAD) && newValue > 0) {
            String setCode = null;
            if (params.containsKey(AbilityKey.Cause)) {
                SpellAbility cause = (SpellAbility) params.get(AbilityKey.Cause);
                setCode = cause.getHostCard().getSetCode();
            }
            createRadiationEffect(setCode);
        }

        final Map<AbilityKey, Object> runParams = AbilityKey.mapFromPlayer(this);
        runParams.put(AbilityKey.Source, source);
        runParams.put(AbilityKey.CounterType, counterType);
        if (params != null) {
            runParams.putAll(params);
        }
        for (int i = 0; i < addAmount; i++) {
            runParams.put(AbilityKey.CounterAmount, oldValue + i + 1);
            getGame().getTriggerHandler().runTrigger(TriggerType.CounterAdded, AbilityKey.newMap(runParams), false);
        }
        runParams.put(AbilityKey.CounterAmount, addAmount);
        getGame().getTriggerHandler().runTrigger(TriggerType.CounterAddedOnce, AbilityKey.newMap(runParams), false);
        if (table != null) {
            table.put(source, this, counterType, addAmount);
        }
    }

    @Override
    public int subtractCounter(CounterType counterName, int num, final Player remover) {
        int oldValue = getCounters(counterName);
        int newValue = Math.max(oldValue - num, 0);

        final int delta = oldValue - newValue;
        if (delta == 0) { return 0; }

        setCounters(counterName, newValue, null, true);

        getGame().addCounterRemovedThisTurn(counterName, this, delta);

        /* TODO Run triggers when something cares
        int curCounters = oldValue;
        for (int i = 0; i < delta && curCounters != 0; i++) {
            final Map<String, Object> runParams = new TreeMap<>();
            runParams.put("Card", this);
            runParams.put("CounterType", counterName);
            runParams.put("NewCounterAmount", --curCounters);
            getGame().getTriggerHandler().runTrigger(TriggerType.CounterRemoved, runParams, false);
        }
        */
        return delta;
    }

    public final void clearCounters() {
        if (counters.isEmpty()) { return; }
        counters.clear();
        view.updateCounters(this);
        getGame().fireEvent(new GameEventPlayerCounters(this, null, 0, 0));
    }

    public void setCounters(final CounterType counterType, final Integer num, Player source, boolean fireEvents) {
        int old = getCounters(counterType);
        setCounters(counterType, num);
        view.updateCounters(this);
        if (fireEvents) {
            getGame().fireEvent(new GameEventPlayerCounters(this, counterType, old, num));
            if (counterType.is(CounterEnumType.POISON)) {
                getGame().fireEvent(new GameEventPlayerPoisoned(this, source, old, num - old));
            } else if (counterType.is(CounterEnumType.RAD)) {
                getGame().fireEvent(new GameEventPlayerRadiation(this, source, num - old));
            }
        }

        if (counterType.is(CounterEnumType.RAD) && num <= 0) {
            removeRadiationEffect();
        }
    }

    @Override
    public void setCounters(Map<CounterType, Integer> allCounters) {
        counters = allCounters;
        view.updateCounters(this);
        getGame().fireEvent(new GameEventPlayerCounters(this, null, 0, 0));

        // create Radiation Effect for GameState
        if (counters.getOrDefault(CounterEnumType.RAD, 0) > 0) {
            this.createRadiationEffect(null);
        } else {
            this.removeRadiationEffect();
        }
    }

    public final void addRadCounters(final int num, final Player source, GameEntityCounterTable table) {
        addCounter(CounterEnumType.RAD, num, source, table);
    }
    public final void removeRadCounters(final int num) {
        subtractCounter(CounterEnumType.RAD, num, this);
    }

    // TODO Merge These calls into the primary counter calls
    public final int getPoisonCounters() {
        return getCounters(CounterEnumType.POISON);
    }
    public final void setPoisonCounters(final int num, Player source) {
        setCounters(CounterEnumType.POISON, num, source, true);
    }
    public final void addPoisonCounters(final int num, final Player source, GameEntityCounterTable table) {
        addCounter(CounterEnumType.POISON, num, source, table);
    }
    public final void removePoisonCounters(final int num, final Player source) {
        subtractCounter(CounterEnumType.POISON, num, source);
    }
    // ================ POISON Merged =================================
    public final void addChangedKeywords(final List<String> addKeywords, final List<String> removeKeywords, final Long timestamp, final long staticId) {
        List<KeywordInterface> kws = Lists.newArrayList();
        if (addKeywords != null) {
            for (String kw : addKeywords) {
                kws.add(getKeywordForStaticAbility(kw, staticId));
            }
        }
        KeywordsChange cks = new KeywordsChange(kws, removeKeywords, false);
        if (cks.hasTraits()) {
            getKeywordCard().addChangedCardTraits(cks, timestamp, staticId, true);
        }
        changedKeywords.put(timestamp, staticId, cks);
        updateKeywords();
        game.fireEvent(new GameEventPlayerStatsChanged(this, true));
    }

    public final KeywordInterface getKeywordForStaticAbility(String kw, final long staticId) {
        KeywordInterface result;
        if (staticId < 1 || !storedKeywords.contains(staticId, kw)) {
            result = Keyword.getInstance(kw);
            result.createTraits(this, false);
        } else {
            result = storedKeywords.get(staticId, kw);
        }
        return result;
    }

    public final IKeywordsChange removeChangedKeywords(final Long timestamp, final long staticId) {
        IKeywordsChange change = changedKeywords.remove(timestamp, staticId);
        if (change != null) {
            if (keywordEffect != null) {
                getKeywordCard().removeChangedCardTraits(timestamp, staticId);
            }
            updateKeywords();
            game.fireEvent(new GameEventPlayerStatsChanged(this, true));
        }
        return change;
    }

    @Override
    public final boolean hasKeyword(final String keyword) {
        return keywords.contains(keyword);
    }
    @Override
    public final boolean hasKeyword(final Keyword keyword) {
        return keywords.contains(keyword);
    }

    private void updateKeywords() {
        keywords.clear();

        // see if keyword changes are in effect
        keywords.applyChanges(changedKeywords.values());
        view.updateKeywords(this);
        updateKeywordCardAbilityText();
    }

    public final KeywordCollection getKeywords() {
        return keywords;
    }

    @Override
    public final boolean canBeTargetedBy(final SpellAbility sa) {
        if (hasLost()) {
            return false;
        }

        // CantTarget static abilities
        if (StaticAbilityCantTarget.cantTarget(this, sa) != null) {
            return false;
        }

        return true;
    }

    public void surveil(int num, SpellAbility cause, Map<AbilityKey, Object> params) {
        num += StaticAbilitySurveilNum.surveilNumMod(this);

        final CardCollection topN = getTopXCardsFromLibrary(num);

        if (!topN.isEmpty()) {
            final Pair<CardCollection, CardCollection> lists = getController().arrangeForSurveil(topN);
            final CardCollection toTop = lists.getLeft();
            final CardCollection toGrave = lists.getRight();

            int numToGrave = 0;
            int numToTop = 0;

            if (toGrave != null) {
                for (Card c : toGrave) {
                    Card moved = getGame().getAction().moveToGraveyard(c, cause, params);
                    moved.setSurveilled(true);
                    numToGrave++;
                }
                if (cause.hasParam("RememberMoved")) {
                    cause.getHostCard().addRemembered(toGrave);
                }
            }

            if (toTop != null) {
                Collections.reverse(toTop); // the last card in list will become topmost in library, have to revert thus.
                for (Card c : toTop) {
                    getGame().getAction().moveToLibrary(c, cause, params);
                    numToTop++;
                }
                if (cause.hasParam("RememberKept")) {
                    cause.getHostCard().addRemembered(toTop);
                }
            }

            getGame().fireEvent(new GameEventSurveil(PlayerView.get(this), numToTop, numToGrave));
        }

        final Map<AbilityKey, Object> runParams = AbilityKey.mapFromPlayer(this);
        runParams.put(AbilityKey.FirstTime, surveilThisTurn == 0);
        if (params != null) {
            runParams.putAll(params);
        }
        getGame().getTriggerHandler().runTrigger(TriggerType.Surveil, runParams, false);

        surveilThisTurn++;
    }

    public int getSurveilThisTurn() {
        return surveilThisTurn;
    }

    public void resetSurveilThisTurn() {
        surveilThisTurn = 0;
    }

    public boolean canMulligan() {
        return !getZone(ZoneType.Hand).isEmpty();
    }

    public final boolean canDraw() {
        return canDrawAmount(1);
    }

    public final boolean canDrawAmount(int amount) {
        return StaticAbilityCantDraw.canDrawThisAmount(this, amount);
    }

    public final CardCollectionView drawCard() {
        return drawCards(1);
    }

    public final CardCollectionView drawCards(final int n) {
        return drawCards(n, null, AbilityKey.newMap(), this.getZone(ZoneType.Hand));
    }

    public final CardCollectionView drawCards(final int n, PlayerZone zone) {
        return drawCards(n, null, AbilityKey.newMap(), zone);
    }

    public final CardCollectionView drawCards(final int n, SpellAbility cause, Map<AbilityKey, Object> params) {
        return drawCards(n, cause, params, this.getZone(ZoneType.Hand));
    }

    public final CardCollectionView drawCards(final int n, SpellAbility cause, Map<AbilityKey, Object> params, PlayerZone zone) {
        final CardCollection drawn = new CardCollection();
        if (n <= 0) {
            return drawn;
        }

        // always allow drawing cards before the game actually starts (e.g. Maralen of the Mornsong Avatar)
        final boolean gameStarted = game.getAge().ordinal() > GameStage.Mulligan.ordinal();

        if (gameStarted) {
            final Map<AbilityKey, Object> repRunParams = AbilityKey.mapFromAffected(this);
            repRunParams.put(AbilityKey.Number, n);
            if (params != null) {
                repRunParams.putAll(params);
            }
            if (game.getReplacementHandler().run(ReplacementType.DrawCards, repRunParams) != ReplacementResult.NotReplaced) {
                return drawn;
            }
        }

        final Map<Player, CardCollection> toReveal = Maps.newHashMap();

        for (int i = 0; i < n; i++) {
            if (gameStarted && !canDraw()) {
                return drawn;
            }
            drawn.addAll(doDraw(toReveal, cause, params, zone));
        }

        // reveal multiple drawn cards when playing with the top of the library revealed
        for (Map.Entry<Player, CardCollection> e : toReveal.entrySet()) {
            if (e.getValue().size() > 1) {
                game.getAction().revealTo(e.getValue(), e.getKey(), "Revealing cards drawn from ");
            }
        }
        return drawn;
    }

    /**
     * @return a CardCollectionView of cards actually drawn
     */
    private CardCollectionView doDraw(Map<Player, CardCollection> revealed, SpellAbility sa, Map<AbilityKey, Object> params, PlayerZone hand) {
        final CardCollection drawn = new CardCollection();
        final PlayerZone library = getZone(ZoneType.Library);

        SpellAbility cause = sa;
        if (cause != null && cause.isReplacementAbility()) {
            cause = (SpellAbility) cause.getReplacingObject(AbilityKey.Cause);
        }

        final boolean gameStarted = game.getAge().ordinal() > GameStage.Mulligan.ordinal();

        if (gameStarted) {
            Map<AbilityKey, Object> repParams = AbilityKey.mapFromAffected(this);
            repParams.put(AbilityKey.Cause, cause);
            if (params != null) {
                repParams.putAll(params);
            }
            if (game.getReplacementHandler().run(ReplacementType.Draw, repParams) != ReplacementResult.NotReplaced) {
                return drawn;
            }
        }

        if (!library.isEmpty()) {
            Card c;

            if (hasKeyword("You draw cards from the bottom of your library instead of the top of your library.")) {
                c = library.get(library.size() - 1);
            } else {
                c = library.get(0);
            }

            List<Player> pList = Lists.newArrayList();
            for (Player p : getAllOtherPlayers()) {
                if (c.mayPlayerLook(p)) {
                    pList.add(p);
                }
            }

            c = game.getAction().moveTo(hand, c, cause, params);
            drawn.add(c);

            // CR 121.6c additional actions can't be performed when draw gets replaced
            // but "drawn this way" effects should still count them
            if (cause != null && cause.hasParam("RememberDrawn") && cause.getParam("RememberDrawn").equals("AllReplaced")) {
                cause.getHostCard().addRemembered(drawn);
            }

            for (Player p : pList) {
                if (!revealed.containsKey(p)) {
                    revealed.put(p, new CardCollection());
                }
                revealed.get(p).add(c);
            }

            if (gameStarted) {
                setLastDrawnCard(c);
                c.setDrawnThisTurn(true);
                numDrawnThisTurn++;
                if (game.getPhaseHandler().is(PhaseType.DRAW)) {
                    numDrawnThisDrawStep++;
                }
                view.updateNumDrawnThisTurn(this);

                final Map<AbilityKey, Object> runParams = AbilityKey.mapFromPlayer(this);
                if (params != null) {
                    runParams.putAll(params);
                }

                // CR 121.8 card was drawn as part of another sa (e.g. paying with Chromantic Sphere), hide it temporarily
                if (game.getTopLibForPlayer(this) != null && getPaidForSA() != null && cause != null && getPaidForSA() != cause.getRootAbility()) {
                    c.turnFaceDown();
                    game.addFacedownWhileCasting(c, numDrawnThisTurn);
                    runParams.put(AbilityKey.CanReveal, false);
                }

                // Run triggers
                runParams.put(AbilityKey.Card, c);
                runParams.put(AbilityKey.Number, numDrawnThisTurn);
                game.getTriggerHandler().runTrigger(TriggerType.Drawn, runParams, false);
            }
        }
        else { // Lose by milling is always on. Give AI many cards it cannot play if you want it not to undertake actions
            triedToDrawFromEmptyLibrary = true;
        }
        return drawn;
    }

    public final void resetNumDrawnThisDrawStep() {
        numDrawnThisDrawStep = 0;
    }

    public final void resetNumDrawnThisTurn() {
        numDrawnThisTurn = 0;
        view.updateNumDrawnThisTurn(this);
    }

    public final int getNumDrawnThisTurn() {
        return numDrawnThisTurn;
    }
    public final int getNumDrawnLastTurn() {
        return numDrawnLastTurn;
    }
    public final int numDrawnThisDrawStep() {
        return numDrawnThisDrawStep;
    }

    /**
     * Returns PlayerZone corresponding to the given zone of game.
     */
    public final PlayerZone getZone(final ZoneType zone) {
        return zones.get(zone);
    }
    public void updateZoneForView(PlayerZone zone) {
        view.updateZone(zone);
    }

    public void updateAllZonesForView() {
        for (PlayerZone zone : zones.values()) {
            updateZoneForView(zone);
        }
    }

    public final List<PlayerZone> getExtraZones() {
        return extraZones;
    }

    public void resetExtraZones(ZoneType type) {
        extraZones.removeIf(z -> z.getZoneType().equals(type));
        if (extraZones.isEmpty()) {
            extraZones = null;
        }
    }

    public final CardCollectionView getCardsIn(final ZoneType zoneType) {
        return getCardsIn(zoneType, true);
    }

    /**
     * gets a list of all cards in the requested zone. This function makes a CardCollectionView from Card[].
     */
    public final CardCollectionView getCardsIn(final ZoneType zoneType, boolean filterOutPhasedOut) {
        if (zoneType == ZoneType.Stack) {
            CardCollection cards = new CardCollection();
            for (Card c : game.getStackZone().getCards()) {
                if (c.getOwner().equals(this)) {
                    cards.add(c);
                }
            }
            return cards;
        }
        else if (zoneType == ZoneType.Flashback) {
            return getCardsActivatableInExternalZones(true);
        }

        PlayerZone zone = getZone(zoneType);
        return zone == null ? CardCollection.EMPTY : zone.getCards(filterOutPhasedOut);
    }

    /**
     * gets a list of first N cards in the requested zone. This function makes a CardCollectionView from Card[].
     */
    public final CardCollectionView getCardsIn(final ZoneType zone, final int n) {
        return new CardCollection(getCardsIn(zone).stream().limit(n));
    }

    /**
     * gets a list of all cards in a given player's requested zones.
     */
    public final CardCollectionView getCardsIn(final Iterable<ZoneType> zones) {
        return getCardsIn(zones, true);
    }
    public final CardCollectionView getCardsIn(final Iterable<ZoneType> zones, boolean filterOutPhasedOut) {
        final CardCollection result = new CardCollection();
        for (final ZoneType z : zones) {
            result.addAll(getCardsIn(z, filterOutPhasedOut));
        }
        return result;
    }
    public final CardCollectionView getCardsIn(final ZoneType[] zones) {
        final CardCollection result = new CardCollection();
        for (final ZoneType z : zones) {
            result.addAll(getCardsIn(z));
        }
        return result;
    }

    /**
     * gets a list of all cards with requested cardName in a given player's
     * requested zone. This function makes a CardCollectionView from Card[].
     */
    public final CardCollectionView getCardsIn(final ZoneType zone, final String cardName) {
        return CardLists.filter(getCardsIn(zone), CardPredicates.nameEquals(cardName));
    }

    public CardCollectionView getCardsActivatableInExternalZones(boolean includeCommandZone) {
        final CardCollection cl = new CardCollection();

        cl.addAll(getZone(ZoneType.Graveyard).getCardsPlayerCanActivate(this));
        cl.addAll(getZone(ZoneType.Exile).getCardsPlayerCanActivate(this));
        cl.addAll(getZone(ZoneType.Library).getCardsPlayerCanActivate(this));
        if (includeCommandZone) {
            cl.addAll(getZone(ZoneType.Command).getCardsPlayerCanActivate(this));
            cl.addAll(getZone(ZoneType.Sideboard).getCardsPlayerCanActivate(this));
        }

        //External activatables from all opponents
        for (final Player other : getAllOtherPlayers()) {
            cl.addAll(other.getZone(ZoneType.Exile).getCardsPlayerCanActivate(this));
            cl.addAll(other.getZone(ZoneType.Graveyard).getCardsPlayerCanActivate(this));
            cl.addAll(other.getZone(ZoneType.Library).getCardsPlayerCanActivate(this));
            cl.addAll(other.getZone(ZoneType.Hand).getCardsPlayerCanActivate(this));
        }
        cl.addAll(getGame().getCardsPlayerCanActivateInStack());
        return cl;
    }

    public final CardCollectionView getAllCards() {
        return CardCollection.combine(getCardsIn(Player.ALL_ZONES), getCardsIn(ZoneType.Stack), inboundTokens);
    }

    public final void resetNumRollsThisTurn() {
        numRollsThisTurn = 0;
    }
    public final int getNumRollsThisTurn() {
        return numRollsThisTurn;
    }
    public void roll() {
        numRollsThisTurn++;
    }

    public final void resetNumFlipsThisTurn() {
        numFlipsThisTurn = 0;
    }
    public final int getNumFlipsThisTurn() {
        return numFlipsThisTurn;
    }
    public void flip() {
        numFlipsThisTurn++;
    }

    public final Card discard(final Card c, final SpellAbility sa, final boolean effect, Map<AbilityKey, Object> params) {
        if (!c.canBeDiscardedBy(sa, effect)) {
            return null;
        }

        discardedThisTurn.add(CardCopyService.getLKICopy(c));

        params.put(AbilityKey.Discard, true);
        params.put(AbilityKey.EffectOnly, effect);
        final Card newCard = game.getAction().moveToGraveyard(c, sa, params);

        StringBuilder sb = new StringBuilder();
        sb.append(this).append(" discards ").append(c);
        //sb.append(" to the library");
        //sb.append(" with Madness");
        sb.append(".");
        // Play the Discard sound
        game.fireEvent(new GameEventAddLog(GameLogEntryType.DISCARD, sb.toString(), c));

        newCard.setDiscarded(true);

        if (sa != null && sa.hasParam("RememberDiscarded")) {
            sa.getHostCard().addRemembered(newCard);
        }
        final Map<AbilityKey, Object> runParams = AbilityKey.mapFromPlayer(this);
        runParams.put(AbilityKey.Card, c);
        runParams.put(AbilityKey.Cause, sa);
        runParams.putAll(params);
        game.getTriggerHandler().runTrigger(TriggerType.Discarded, runParams, false);

        return newCard;
    }

    public final void addTokensCreatedThisTurn(Card token) {
        numTokenCreatedThisTurn++;
        final Map<AbilityKey, Object> runParams = AbilityKey.mapFromPlayer(this);
        runParams.put(AbilityKey.Num, numTokenCreatedThisTurn);
        runParams.put(AbilityKey.Card, token);
        game.getTriggerHandler().runTrigger(TriggerType.TokenCreated, runParams, false);
    }

    public final int getNumTokenCreatedThisTurn() {
        return numTokenCreatedThisTurn;
    }

    public final void resetNumTokenCreatedThisTurn() {
        numTokenCreatedThisTurn = 0;
    }

    public final int getNumForetoldThisTurn() {
        return numForetoldThisTurn;
    }

    public final void addForetoldThisTurn() {
        numForetoldThisTurn++;
        final Map<AbilityKey, Object> runParams = AbilityKey.mapFromPlayer(this);
        runParams.put(AbilityKey.Num, numForetoldThisTurn);
        game.getTriggerHandler().runTrigger(TriggerType.Foretell, runParams, false);
    }

    public final void resetNumForetoldThisTurn() {
        numForetoldThisTurn = 0;
    }

    public final List<Card> getDiscardedThisTurn() {
        return discardedThisTurn;
    }
    public final void resetDiscardedThisTurn() {
        discardedThisTurn.clear();
    }

    public final int getNumExploredThisTurn() {
        return numExploredThisTurn;
    }
    public final void addExploredThisTurn() {
        numExploredThisTurn++;
    }
    public final void resetNumExploredThisTurn() {
        numExploredThisTurn = 0;
    }

    public int getNumCardsInHandStartedThisTurnWith() {
        return numCardsInHandStartedThisTurnWith;
    }
    public void setNumCardsInHandStartedThisTurnWith(int num) {
        numCardsInHandStartedThisTurnWith = num;
    }

    public int getLifeStartedThisTurnWith() {
        return lifeStartedThisTurnWith;
    }
    public void setLifeStartedThisTurnWith(int l) {
        lifeStartedThisTurnWith = l;
    }

    public void addNoteForName(String notedFor, String noted) {
        if (!notes.containsKey(notedFor)) {
            notes.put(notedFor, new FCollection<>());
        }
        notes.get(notedFor).add(noted);
    }
    public FCollection<String> getNotesForName(String notedFor) {
        if (!notes.containsKey(notedFor)) {
            notes.put(notedFor, new FCollection<>());
        }
        return notes.get(notedFor);
    }
    public void clearNotesForName(String notedFor) {
        if (notes.containsKey(notedFor)) {
            notes.get(notedFor).clear();
        }
    }

    public void noteNumberForName(String notedFor, int noted) {
        notedNum.put(notedFor, noted);
    }
    public int getNotedNumberForName(String notedFor) {
        if (!notedNum.containsKey(notedFor)) {
            return 0;
        }
        return notedNum.get(notedFor);
    }

    public final CardCollectionView mill(int n, final ZoneType destination, SpellAbility sa, Map<AbilityKey, Object> params) {
        // Replacement effects
        final Map<AbilityKey, Object> repRunParams = AbilityKey.mapFromAffected(this);
        repRunParams.put(AbilityKey.Number, n);
        if (params != null) {
            repRunParams.putAll(params);
        }

        if (destination == ZoneType.Graveyard) {
            switch (getGame().getReplacementHandler().run(ReplacementType.Mill, repRunParams)) {
                case NotReplaced:
                    break;
                case Updated:
                    // check if this is still the affected player
                    if (this.equals(repRunParams.get(AbilityKey.Affected))) {
                        n = (int) repRunParams.get(AbilityKey.Number);
                    } else {
                        return CardCollection.EMPTY;
                    }
                    break;
                default:
                    return CardCollection.EMPTY;
            }
        }

        Iterable<Card> milledView = getCardsIn(ZoneType.Library);
        // CR 614.13c
        if (sa.getRootAbility().getReplacingObject(AbilityKey.SimultaneousETB) != null) {
            milledView = IterableUtil.filter(milledView, c -> !((CardCollection) sa.getRootAbility().getReplacingObject(AbilityKey.SimultaneousETB)).contains(c));
        }
        CardCollectionView milled = new CardCollection(Iterables.limit(milledView, n));

        if (destination == ZoneType.Graveyard) {
            milled = GameActionUtil.orderCardsByTheirOwners(game, milled, ZoneType.Graveyard, sa);
        }

        for (Card m : milled) {
            Card moved = game.getAction().moveTo(destination, m, sa, params);
            moved.setMilled(true);

            final Map<AbilityKey, Object> runParams = AbilityKey.mapFromPlayer(this);
            runParams.put(AbilityKey.Card, m);
            game.getTriggerHandler().runTrigger(TriggerType.Milled, runParams, false);
        }

        if (!milled.isEmpty()) {
            final Map<AbilityKey, Object> runParams = AbilityKey.mapFromPlayer(this);
            runParams.put(AbilityKey.Cards, milled);
            game.getTriggerHandler().runTrigger(TriggerType.MilledOnce, runParams, false);
        }

        return milled;
    }

    public final CardCollection getTopXCardsFromLibrary(int amount) {
        final CardCollection topCards = new CardCollection();
        final PlayerZone lib = this.getZone(ZoneType.Library);
        int maxCards = lib.size();
        // If library is smaller than N, only get that many cards
        maxCards = Math.min(maxCards, amount);

        // show top n cards:
        for (int j = 0; j < maxCards; j++) {
            topCards.add(lib.get(j));
        }

        return topCards;
    }

    public final void shuffle(final SpellAbility sa) {
        final CardCollection list = new CardCollection(getCardsIn(ZoneType.Library));

        // Note: Shuffling once is sufficient.
        Collections.shuffle(list, MyRandom.getRandom());

        getZone(ZoneType.Library).setCards(getController().cheatShuffle(list));

        // Always Run triggers (701.20e)
        final Map<AbilityKey, Object> runParams = AbilityKey.mapFromPlayer(this);
        runParams.put(AbilityKey.Source, sa);
        game.getTriggerHandler().runTrigger(TriggerType.Shuffled, runParams, false);

        // Play the shuffle sound
        game.fireEvent(new GameEventShuffle(this));
    }

    public final Card playLand(final Card land, SpellAbility cause) {
        land.setController(this, 0);
        if (land.isFaceDown()) {
            land.turnFaceUp(null);
            if (cause.isLandAbility()) {
                land.changeToState(cause.getCardStateName());
            }
        }

        Map<AbilityKey, Object> runParams = AbilityKey.mapFromCard(land);
        runParams.put(AbilityKey.Origin, land.getZone().getZoneType().name());

        game.copyLastState();
        final Card c = game.getAction().moveTo(getZone(ZoneType.Battlefield), land, cause);
        game.updateLastStateForCard(c);

        // Run triggers
        runParams.put(AbilityKey.SpellAbility, cause);
        game.getTriggerHandler().runTrigger(TriggerType.LandPlayed, runParams, false);

        game.getStack().unfreezeStack();
        addLandPlayedThisTurn();

        // play a sound
        game.fireEvent(new GameEventLandPlayed(PlayerView.get(this), CardView.get(c)));

        return c;
    }

    public final boolean canPlayLand(final Card land, final boolean ignoreZoneAndTiming, SpellAbility landSa) {
        if (!ignoreZoneAndTiming) {
            // CR 305.3
            if (!game.getPhaseHandler().isPlayerTurn(this)) {
                return false;
            }
            if (!canCastSorcery() && (landSa == null || !landSa.withFlash(land, this))) {
                return false;
            }

            final boolean mayPlay = landSa == null ? !land.mayPlay(this).isEmpty() : landSa.getMayPlay() != null;
            if (land.getOwner() != this && !mayPlay) {
                return false;
            }

            final Zone zone = game.getZoneOf(land);
            if (zone != null && (zone.is(ZoneType.Battlefield) || (!zone.is(ZoneType.Hand) && !mayPlay
                    && (landSa == null || !landSa.isAlternativeCost(AlternativeCost.Mayhem))))) {
                return false;
            }
        }

        // CantBeCast static abilities
        if (StaticAbilityCantBeCast.cantPlayLandAbility(landSa, land, this)) {
            return false;
        }

        // **** Check for land play limit per turn ****
        // Dev Mode
        if (getMaxLandPlaysInfinite()) {
            return true;
        }

        // check for adjusted max lands play per turn
        return getLandsPlayedThisTurn() < getMaxLandPlays();
    }

    public final int getMaxLandPlays() {
        int adjMax = 1;
        for (Integer i : adjustLandPlays.values()) {
            adjMax += i;
        }
        return adjMax;
    }

    public final void addMaxLandPlays(long timestamp, int value) {
        adjustLandPlays.put(timestamp, value);
        getView().updateMaxLandPlay(this);
        getGame().fireEvent(new GameEventPlayerStatsChanged(this, false));
    }
    public final boolean removeMaxLandPlays(long timestamp) {
        boolean changed = adjustLandPlays.remove(timestamp) != null;
        if (changed) {
            getView().updateMaxLandPlay(this);
            getGame().fireEvent(new GameEventPlayerStatsChanged(this, false));
        }
        return changed;
    }

    public final void addMaxLandPlaysInfinite(long timestamp) {
        adjustLandPlaysInfinite.add(timestamp);
        getView().updateUnlimitedLandPlay(this);
        getGame().fireEvent(new GameEventPlayerStatsChanged(this, false));
    }
    public final boolean removeMaxLandPlaysInfinite(long timestamp) {
        boolean changed = adjustLandPlaysInfinite.remove(timestamp);
        if (changed) {
            getView().updateUnlimitedLandPlay(this);
            getGame().fireEvent(new GameEventPlayerStatsChanged(this, false));
        }
        return changed;
    }

    public final boolean getMaxLandPlaysInfinite() {
        if (getController().canPlayUnlimitedLands()) {
            return true;
        }
        return !adjustLandPlaysInfinite.isEmpty();
    }

    public final void addMaingameCardMapping(Card subgameCard, Card maingameCard) {
        maingameCardsMap.put(subgameCard, maingameCard);
    }
    public final Card getMappingMaingameCard(Card subgameCard) {
        return maingameCardsMap.get(subgameCard);
    }

    public final ManaPool getManaPool() {
        return manaPool;
    }
    public void updateManaForView() {
        view.updateMana(this);
    }

    public final int getNumPowerSurgeLands() {
        return numPowerSurgeLands;
    }
    public final int setNumPowerSurgeLands(final int n) {
        numPowerSurgeLands = n;
        return numPowerSurgeLands;
    }

    public final Card getLastDrawnCard() {
        return lastDrawnCard;
    }
    private Card setLastDrawnCard(final Card c) {
        lastDrawnCard = c;
        return lastDrawnCard;
    }

    public final Card getRingBearer() {
        return ringBearer;
    }
    public final Card getTheRing() {
        return theRing;
    }
    public final void clearTheRing() {
        theRing = null;
    }
    public final void setRingBearer(Card bearer) {
        if (bearer == null)
            return;
        clearRingBearer();
        ringBearer = bearer;
        ringBearer.setRingBearer(true);
    }
    public void clearRingBearer() {
        if (ringBearer == null)
            return;
        ringBearer.setRingBearer(false);
        ringBearer = null;
    }

    public final String getNamedCard() {
        return namedCard;
    }
    public final void setNamedCard(final String s) {
        namedCard = s;
    }

    public final int getTurn() {
        return stats.getTurnsPlayed();
    }

    public final void incrementTurn() {
        stats.nextTurn();
    }

    public final int getLastTurnNr() {
        return this.lastTurnNr;
    }

    public boolean hasTappedLandForManaThisTurn() {
        return tappedLandForManaThisTurn;
    }
    public void setTappedLandForManaThisTurn(boolean tappedLandForManaThisTurn) {
        this.tappedLandForManaThisTurn = tappedLandForManaThisTurn;
    }

    public final boolean hasBeenDealtCombatDamageSinceLastTurn() {
        return beenDealtCombatDamageSinceLastTurn;
    }
    public final void setBeenDealtCombatDamageSinceLastTurn(final boolean b) {
        beenDealtCombatDamageSinceLastTurn = b;
    }

    public final List<Card> getCreaturesAttackedThisTurn() {
        List<Card> result = Lists.newArrayList(Iterables.concat(attackedThisTurn.values()));
        return result;
    }
    public final List<Card> getCreaturesAttackedThisTurn(final GameEntity e) {
        return attackedThisTurn.getOrDefault(e, Lists.newArrayList());
    }
    public final void addCreaturesAttackedThisTurn(final Card c, final GameEntity e) {
        final List<Card> creatures = attackedThisTurn.getOrDefault(e, Lists.newArrayList());
        creatures.add(c);
        attackedThisTurn.putIfAbsent(e, creatures);
        if (e instanceof Player && !attackedPlayersThisCombat.contains(e)) {
            attackedPlayersThisCombat.add((Player) e);
        }
    }

    public final Iterable<Player> getAttackedPlayersMyTurn() {
        return IterableUtil.filter(attackedThisTurn.keySet(), Player.class);
    }
    public final List<Player> getAttackedPlayersMyLastTurn() {
        return attackedPlayersLastTurn;
    }
    public final void clearAttackedMyTurn() {
        attackedThisTurn.clear();
    }
    public final void setAttackedPlayersMyLastTurn(Iterable<Player> players) {
        attackedPlayersLastTurn.clear();
        players.forEach(attackedPlayersLastTurn::add);
    }

    public final List<Player> getAttackedPlayersMyCombat() {
        return attackedPlayersThisCombat;
    }
    public final void clearAttackedPlayersMyCombat() {
        attackedPlayersThisCombat.clear();
    }

    public final int getVenturedThisTurn() {
        return venturedThisTurn;
    }
    public final void incrementVenturedThisTurn() {
        venturedThisTurn++;
    }
    public final void resetVenturedThisTurn() {
        venturedThisTurn = 0;
    }

    public final List<Card> getCompletedDungeons() {
        return completedDungeons;
    }
    public void addCompletedDungeon(Card dungeon) {
        completedDungeons.add(dungeon);
    }
    public void resetCompletedDungeons() {
        completedDungeons.clear();
    }

    public final int getSpeed() {
        return speed;
    }
    public final void increaseSpeed() {
        if (!maxSpeed()) { // can't increase past 4
            int old = speed;
            speed++;
            getGame().fireEvent(new GameEventSpeedChanged(this, old, speed)); //play sound effect
            updateSpeedEffect();
        }
    }
    public final void decreaseSpeed() {
        if (speed > 1) { // can't decrease speed below 1
            int old = speed;
            speed--;
            game.fireEvent(new GameEventSpeedChanged(this, old, speed));
            updateSpeedEffect();
        }
    }
    public final boolean noSpeed() {
        return speed == 0;
    }
    public final boolean maxSpeed() {
        return speed == 4;
    }
    public final void setSpeed(int i) { //just used for copy/save
        speed = i;
        if(this.speedEffect != null)
            updateSpeedEffect();
    }
    public final void createSpeedEffect() {
        if(this.speedEffect != null || this.noSpeed())
            return;

        speedEffect = new Card(game.nextCardId(), null, game);
        speedEffect.setOwner(this);
        speedEffect.setGamePieceType(GamePieceType.EFFECT);

        speedEffect.addAlternateState(CardStateName.Backside, false);
        CardState speedFront = speedEffect.getState(CardStateName.Original);
        CardState speedBack = speedEffect.getState(CardStateName.Backside);


        speedFront.setImageKey(StaticData.instance().getOtherImageKey(ImageKeys.SPEED_IMAGE, CardEdition.UNKNOWN_CODE));
        speedFront.setName("Start Your Engines!");

        speedBack.setImageKey(StaticData.instance().getOtherImageKey(ImageKeys.MAX_SPEED_IMAGE, CardEdition.UNKNOWN_CODE));
        speedBack.setName("Max Speed!");

        String label = Localizer.getInstance().getMessage("lblSpeed", this.speed);
        speedEffect.setOverlayText(label);

        // 702.179d There is an inherent triggered ability associated with a player having 1 or more speed. This ability has no source and is controlled by that player.
        // That ability is Ã¢â‚¬Å“Whenever one or more opponents lose life during your turn, if your speed is less than 4, your speed increases by 1. This ability triggers only once each turn.Ã¢â‚¬Â
        String trigger = "Mode$ LifeLostAll | ValidPlayer$ Opponent | TriggerZones$ Command | ActivationLimit$ 1 | " +
                "PlayerTurn$ True | CheckSVar$ Count$YourSpeed | SVarCompare$ LT4 | "
                + "TriggerDescription$ Whenever one or more opponents lose life during your turn, if your speed is less than 4, your speed increases by 1. This ability triggers only once each turn.";
        String speedUp = "DB$ ChangeSpeed";
        Trigger lifeLostTrigger = TriggerHandler.parseTrigger(trigger, speedEffect, true);
        lifeLostTrigger.setOverridingAbility(AbilityFactory.getAbility(speedUp, speedEffect));
        speedFront.addTrigger(lifeLostTrigger);

        speedEffect.updateStateForView();

        if(this.maxSpeed())
            speedEffect.setState(CardStateName.Backside, true);

        final PlayerZone com = getZone(ZoneType.Command);
        com.add(speedEffect);
        this.updateZoneForView(com);
    }
    protected void updateSpeedEffect() {
        if(this.speedEffect == null) {
            if(this.noSpeed())
                return;
            createSpeedEffect();
        }
        Localizer localizer = Localizer.getInstance();
        String label = this.maxSpeed() ? localizer.getMessage("lblMaxSpeed") : localizer.getMessage("lblSpeed", this.speed);
        speedEffect.setOverlayText(label);
        if(maxSpeed() && speedEffect.getCurrentStateName() == CardStateName.Original)
            speedEffect.setState(CardStateName.Backside, true);
        else if(!maxSpeed() && speedEffect.getCurrentStateName() == CardStateName.Backside)
            speedEffect.setState(CardStateName.Original, true);
    }

    public final void altWinBySpellEffect(final String sourceName) {
        if (cantWin()) {
            return;
        }
        setOutcome(PlayerOutcome.altWin(sourceName));
    }

    public final boolean loseConditionMet(final GameLossReason state, final String spellName) {
        if (state != GameLossReason.OpponentWon) {
            Map<AbilityKey, Object> repParams = AbilityKey.mapFromAffected(this);
            repParams.put(AbilityKey.LoseReason, state);
            if (game.getReplacementHandler().run(ReplacementType.GameLoss, repParams) != ReplacementResult.NotReplaced) {
                return false;
            }
        }
        setOutcome(PlayerOutcome.loss(state, spellName));
        return true;
    }

    public final void concede() { // No cantLose checks - just lose
        setOutcome(PlayerOutcome.concede());
    }

    public final void intentionalDraw() {
        setOutcome(PlayerOutcome.draw());
    }

    public final boolean conceded() {
        return getOutcome() != null && getOutcome().lossState == GameLossReason.Conceded;
    }

    public final boolean cantLose() {
        if (conceded()) {
            return false;
        }
        return cantLoseCheck(null);
    }

    public final boolean cantLoseForZeroOrLessLife() {
        if (conceded()) {
            return false;
        }
        return cantLoseCheck(GameLossReason.LifeReachedZero);
    }

    public final boolean cantLoseCheck(final GameLossReason state) {
        Map<AbilityKey, Object> repParams = AbilityKey.mapFromAffected(this);
        repParams.put(AbilityKey.LoseReason, state);
        return game.getReplacementHandler().cantHappenCheck(ReplacementType.GameLoss, repParams);
    }

    public final boolean cantWin() {
        return game.getReplacementHandler().cantHappenCheck(ReplacementType.GameWin, AbilityKey.mapFromAffected(this));
    }

    public final boolean checkLoseCondition() {
        // Just in case player already lost
        if (hasLost()) {
            return true;
        }

        // check this first because of Lich's Mirror (704.7)
        // Rule 704.5b - If a player attempted to draw a card from a library with no cards in it
        //               since the last time state-based actions were checked, he or she loses the game.
        if (triedToDrawFromEmptyLibrary) {
            triedToDrawFromEmptyLibrary = false; // one-shot check
            // Mine, Mine, Mine! prevents decking
            if (loseConditionMet(GameLossReason.Milled, null)) {
                return true;
            }
        }

        // Rule 704.5a -  If a player has 0 or less life, he or she loses the game.
        final boolean hasNoLife = getLife() <= 0;
        if (hasNoLife && loseConditionMet(GameLossReason.LifeReachedZero, null)) {
            return true;
        }

        // Rule 704.5c - If a player has ten or more poison counters, he or she loses the game.
        // 704.6b In a Two-Headed Giant game, if a team has fifteen or more poison counters, that team loses the game. See rule 810, Ã¢â‚¬Å“Two-Headed Giant Variant.Ã¢â‚¬Â
        if (getCounters(CounterEnumType.POISON) >= 10 && loseConditionMet(GameLossReason.Poisoned, null)) {
            return true;
        }

        if (game.getRules().hasAppliedVariant(GameType.Commander)) {
            for (Entry<Card, Integer> entry : getCommanderDamage()) {
                if (entry.getValue() >= 21 && loseConditionMet(GameLossReason.CommanderDamage, null)) {
                    return true;
                }
            }
        }
        return false;
    }

    public final boolean hasLost() {
        return getOutcome() != null && getOutcome().lossState != null;
    }

    public final boolean hasWon() {
        if (cantWin()) {
            return false;
        }
        // in multiplayer game one player's win is replaced by all other's lose (rule 103.4h)
        // so if someone cannot lose, the game appears to continue
        return getOutcome() != null && getOutcome().lossState == null;
    }

    public final boolean isInGame() {
        return getOutcome() == null;
    }

    public final boolean hasMetalcraft() {
        return CardLists.count(getCardsIn(ZoneType.Battlefield), CardPredicates.ARTIFACTS) >= 3;
    }

    public final boolean hasDesert() {
        return getCardsIn(Arrays.asList(ZoneType.Battlefield, ZoneType.Graveyard)).anyMatch(CardPredicates.isType("Desert"));
    }

    public final boolean hasThreshold() {
        return getZone(ZoneType.Graveyard).size() >= 7;
    }

    public final boolean hasHellbent() {
        return getZone(ZoneType.Hand).isEmpty();
    }

    public final boolean hasRevolt() {
        return getGame().getLeftBattlefieldThisTurn().stream().anyMatch(CardPredicates.isController(this));
    }

    public final int getDescended() {
        return descended;
    }
    public final void descend() {
        descended++;
    }
    public final void setDescended(final int n) {
        descended = n;
    }

    public final boolean hasDelirium() {
        return AbilityUtils.countCardTypesFromList(getCardsIn(ZoneType.Graveyard), false) >= 4;
    }

    public final boolean hasLandfall() {
        return getZone(ZoneType.Battlefield).getCardsAddedThisTurn(null).stream()
                .anyMatch(CardPredicates.LANDS);
    }

    public boolean hasFerocious() {
        return !CardLists.filterPower(getCreaturesInPlay(), 4).isEmpty();
    }

    public final boolean hasSurge() {
        return !CardLists.filterControlledBy(game.getStack().getSpellsCastThisTurn(), getYourTeam()).isEmpty();
    }

    public final boolean hasBloodthirst() {
        for (Player p : getRegisteredOpponents()) {
            if (p.getAssignedDamage() > 0) {
                return true;
            }
        }
        return false;
    }

    public final int getBloodthirstAmount() {
        return Aggregates.sum(getRegisteredOpponents(), GameEntity::getAssignedDamage);
    }

    public final int getOpponentLostLifeThisTurn() {
        int lost = 0;
        for (Player opp : getRegisteredOpponents()) {
            lost += opp.getLifeLostThisTurn();
        }
        return lost;
    }

    public final boolean hasProwl(final SpellAbility sa) {
        return !game.getDamageDoneThisTurn(true, true, "Card.YouCtrl+sharesCreatureTypeWith", "Player", sa.getHostCard(), this, sa).isEmpty();
    }

    public final boolean hasFreerunning() {
        return !game.getDamageDoneThisTurn(true, true, "Card.Assassin+YouCtrl,Card.IsCommander+YouCtrl", "Player", null, this, null).isEmpty();
    }

    public final void setLibrarySearched(final int l) {
        numLibrarySearchedOwn = l;
    }
    public final int getLibrarySearched() {
        return numLibrarySearchedOwn;
    }
    public final void incLibrarySearched() {
        numLibrarySearchedOwn++;
    }

    @Override
    public final boolean isValid(final String restriction, final Player sourceController, final Card source, CardTraitBase spellAbility) {
        final String[] incR = restriction.split("\\.", 2);

        if (incR[0].equals("Opponent")) {
            if (equals(sourceController) || !isOpponentOf(sourceController)) {
                return false;
            }
        } else if (incR[0].equals("You")) {
            if (!equals(sourceController)) {
                return false;
            }
        } else if (incR[0].equals("Any")) {
            //todo further check for Effect API and other replacement Effect
            /*if (spellAbility == null)
                return false;
            ApiType apiType = ((SpellAbility) spellAbility).getApi();
            if (!(ApiType.DealDamage.equals(apiType) || ApiType.PreventDamage.equals(apiType)))
                return false;*/
        } else if (!incR[0].equals("Player")) {
            return false;
        }

        if (incR.length > 1) {
            final String excR = incR[1];
            final String[] exR = excR.split("\\+"); // Exclusive Restrictions are ...
            for (String s : exR) {
                if (!hasProperty(s, sourceController, source, spellAbility)) {
                    return false;
                }
            }
        }
        return true;
    }

    @Override
    public final boolean hasProperty(final String property, final Player sourceController, final Card source, CardTraitBase spellAbility) {
        if (property.startsWith("!")) {
            return !PlayerProperty.playerHasProperty(this, property.substring(1), sourceController, source, spellAbility);
        }
        return PlayerProperty.playerHasProperty(this, property, sourceController, source, spellAbility);
    }

    public final int getMaxHandSize() {
        return maxHandSize;
    }
    public final void setMaxHandSize(int size) {
        if (maxHandSize == size) { return; }
        maxHandSize = size;
        view.updateMaxHandSize(this);
    }

    public boolean isUnlimitedHandSize() {
        return unlimitedHandSize;
    }
    public void setUnlimitedHandSize(boolean unlimited) {
        if (unlimitedHandSize == unlimited) { return; }
        unlimitedHandSize = unlimited;
        view.updateUnlimitedHandSize(this);
    }

    public int getStartingHandSize() {
        return startingHandSize;
    }
    public void setStartingHandSize(int shs) {
        startingHandSize = shs;
    }

    public final int getLandsPlayedThisTurn() {
        return landsPlayedThisTurn;
    }
    public final int getLandsPlayedLastTurn() {
        return landsPlayedLastTurn;
    }
    public final void addLandPlayedThisTurn() {
        landsPlayedThisTurn++;
        achievementTracker.landsPlayed++;
        view.updateNumLandThisTurn(this);
    }
    public final void resetLandsPlayedThisTurn() {
        landsPlayedThisTurn = 0;
        view.updateNumLandThisTurn(this);
    }
    public final void setLandsPlayedThisTurn(int num) {
        // This method should only be used directly when setting up the game state.
        landsPlayedThisTurn = num;

        view.updateNumLandThisTurn(this);
    }
    public final void setLandsPlayedLastTurn(int num) {
        landsPlayedLastTurn = num;
    }
    public final void setNumDrawnLastTurn(int num) {
        numDrawnLastTurn= num;
    }

    public final int getInvestigateNumThisTurn() {
        return investigatedThisTurn;
    }
    public final void addInvestigatedThisTurn() {
        investigatedThisTurn++;
        final Map<AbilityKey, Object> runParams = AbilityKey.mapFromPlayer(this);
        runParams.put(AbilityKey.FirstTime, investigatedThisTurn == 1);
        game.getTriggerHandler().runTrigger(TriggerType.Investigated, runParams, false);
    }
    public final void resetInvestigatedThisTurn() {
        investigatedThisTurn = 0;
    }

    public final void addSacrificedThisTurn(final Card cpy, final SpellAbility source) {
        // Play the Sacrifice sound
        game.fireEvent(new GameEventCardSacrificed(CardView.get(cpy)));

        sacrificedThisTurn.add(cpy);

        final Map<AbilityKey, Object> runParams = AbilityKey.mapFromPlayer(this);
        // use a copy that preserves last known information about the card (e.g. for Savra, Queen of the Golgari + Painter's Servant)
        runParams.put(AbilityKey.Card, cpy);
        runParams.put(AbilityKey.Cause, source);
        runParams.put(AbilityKey.CostStack, game.costPaymentStack);
        runParams.put(AbilityKey.IndividualCostPaymentInstance, game.costPaymentStack.peek());
        game.getTriggerHandler().runTrigger(TriggerType.Sacrificed, runParams, false);
    }

    public final List<Card> getSacrificedThisTurn() {
        return sacrificedThisTurn;
    }
    public final void resetSacrificedThisTurn() {
        sacrificedThisTurn.clear();
    }

    public final List<Card> getSpellsCastSinceBegOfYourLastTurn() {
        List<Card> all = new ArrayList<>(game.getStack().getSpellsCastThisTurn());
        all.addAll(spellsCastSinceBeginningOfLastTurn);
        return all;
    }
    public final void resetSpellCastSinceBegOfYourLastTurn() {
        spellsCastSinceBeginningOfLastTurn = Lists.newArrayList();
    }
    public final void addSpellCastSinceBegOfYourLastTurn(List<Card> spells) {
        spellsCastSinceBeginningOfLastTurn.addAll(spells);
    }

    public final int getSpellsCastThisTurn() {
        return spellsCastThisTurn;
    }
    public final int getSpellsCastLastTurn() {
        return spellsCastLastTurn;
    }
    public final void addSpellCastThisTurn() {
        spellsCastThisTurn++;
        spellsCastThisGame++;
        achievementTracker.spellsCast++;
        if (spellsCastThisTurn > achievementTracker.maxStormCount) {
            achievementTracker.maxStormCount = spellsCastThisTurn;
        }
    }
    public final void resetSpellsCastThisTurn() {
        spellsCastThisTurn = 0;
    }
    public final void setSpellsCastLastTurn(int num) {
        spellsCastLastTurn = num;
    }
    public final int getSpellsCastThisGame() {
        return spellsCastThisGame;
    }
    public final void resetSpellCastThisGame() {
        spellsCastThisGame = 0;
    }

    public final int getLifeGainedByTeamThisTurn() {
        return lifeGainedByTeamThisTurn;
    }
    public final void addLifeGainedByTeamThisTurn(int val) {
        lifeGainedByTeamThisTurn += val;
    }

    public final int getLifeGainedThisTurn() {
        return lifeGainedThisTurn;
    }
    public final void setLifeGainedThisTurn(final int n) {
        lifeGainedThisTurn = n;
    }

    public final int getLifeGainedTimesThisTurn() {
        return lifeGainedTimesThisTurn;
    }

    public final int getLifeLostThisTurn() {
        return lifeLostThisTurn;
    }
    public final void setLifeLostThisTurn(final int n) {
        lifeLostThisTurn = n;
    }

    public final int getLifeLostLastTurn() {
        return lifeLostLastTurn;
    }
    public final void setLifeLostLastTurn(final int n) {
        lifeLostLastTurn = n;
    }

    public final int getNumManaShards() {
        return numManaShards;
    }
    public final void setNumManaShards(final int n) {
        int old = numManaShards;
        numManaShards = n;
        view.updateNumManaShards(this);
        game.fireEvent(new GameEventPlayerShardsChanged(this, old, numManaShards));
    }

    @Override
    public int compareTo(Player o) {
        if (o == null) {
            return 1;
        }
        return getName().compareTo(o.getName());
    }

    public void setDraftNotes(Map<String, String> notes) {
        this.draftNotes.clear();
        this.draftNotes.putAll(notes);
    }

    public Map<String, String> getDraftNotes() {
        return draftNotes;
    }

    public final LobbyPlayer getLobbyPlayer() {
        return getController().getLobbyPlayer();
    }

    public final LobbyPlayer getOriginalLobbyPlayer() {
        return controller.getLobbyPlayer();
    }

    public final RegisteredPlayer getRegisteredPlayer() {
        return game.getMatch().getPlayers().get(game.getRegisteredPlayers().indexOf(this));
    }

    public final PlayerOutcome getOutcome() {
        return stats.getOutcome();
    }
    private void setOutcome(PlayerOutcome outcome) {
        stats.setOutcome(outcome);
    }

    public void onGameOver() {
        if (null == stats.getOutcome()) {
            setOutcome(PlayerOutcome.win());
        }
    }

    /**
     * use to get a list of creatures in play for a given player.
     */
    public CardCollection getCreaturesInPlay() {
        return CardLists.filter(getCardsIn(ZoneType.Battlefield), CardPredicates.CREATURES);
    }

    public CardCollection getPlaneswalkersInPlay() {
        return CardLists.filter(getCardsIn(ZoneType.Battlefield), CardPredicates.PLANESWALKERS);
    }

    public CardCollection getBattlesInPlay() {
        return CardLists.filter(getCardsIn(ZoneType.Battlefield), CardPredicates.BATTLES);
    }

    /**
     * use to get a list of tokens in play for a given player.
     */
    public CardCollection getTokensInPlay() {
        return CardLists.filter(getCardsIn(ZoneType.Battlefield), CardPredicates.TOKEN);
    }

    /**
     * use to get a list of all lands a given player has on the battlefield.
     */
    public CardCollection getLandsInPlay() {
        return CardLists.filter(getCardsIn(ZoneType.Battlefield), CardPredicates.LANDS);
    }

    public boolean isCardInPlay(final String cardName) {
        return getZone(ZoneType.Battlefield).contains(CardPredicates.nameEquals(cardName));
    }

    public boolean isCardInCommand(final String cardName) {
        return getZone(ZoneType.Command).contains(CardPredicates.nameEquals(cardName));
    }

    public CardCollectionView getColoredCardsInPlay(final String color) {
        return getColoredCardsInPlay(MagicColor.fromName(color));
    }
    public CardCollectionView getColoredCardsInPlay(final byte color) {
        return CardLists.getColor(getCardsIn(ZoneType.Battlefield), color);
    }

    public final int getAmountOfKeyword(final String k) {
        return keywords.getAmount(k);
    }

    public boolean isTurnOrderReversed() {
        return StaticAbilityTurnPhaseReversed.isTurnReversed(this);
    }
    public boolean isPhasesReversed() {
        return StaticAbilityTurnPhaseReversed.isPhaseReversed(this);
    }

    public void onCleanupPhase() {
        for (Card c : getCardsIn(ZoneType.Hand)) {
            c.setDrawnThisTurn(false);
        }
        for (final PlayerZone pz : zones.values()) {
            pz.resetCardsAddedThisTurn();
        }
        setNumDrawnLastTurn(getNumDrawnThisTurn());
        resetNumDrawnThisTurn();
        resetNumRollsThisTurn();
        resetNumFlipsThisTurn();
        resetNumExploredThisTurn();
        resetNumForetoldThisTurn();
        resetNumTokenCreatedThisTurn();
        setNumCardsInHandStartedThisTurnWith(getCardsIn(ZoneType.Hand).size());
        setTappedLandForManaThisTurn(false);
        setLandsPlayedLastTurn(getLandsPlayedThisTurn());
        resetLandsPlayedThisTurn();
        resetInvestigatedThisTurn();
        resetSurveilThisTurn();
        resetDiscardedThisTurn();
        resetSacrificedThisTurn();
        resetVenturedThisTurn();
        setDescended(0);
        setSpellsCastLastTurn(getSpellsCastThisTurn());
        resetSpellsCastThisTurn();
        setLifeLostLastTurn(getLifeLostThisTurn());
        setLifeLostThisTurn(0);
        setLifeGainedThisTurn(0);
        lifeGainedTimesThisTurn = 0;
        lifeGainedByTeamThisTurn = 0;
        setLifeStartedThisTurnWith(getLife());
        setLibrarySearched(0);

        setCommitedCrimeThisTurn(0);
        diceRollsThisTurn = Lists.newArrayList();
        setExpentThisTurn(0);
        attractionsVisitedThisTurn = 0;

        damageReceivedThisTurn.clear();
        planeswalkedToThisTurn.clear();

        elementalBendThisTurn.clear();

        // set last turn nr
        if (game.getPhaseHandler().isPlayerTurn(this)) {
            setBeenDealtCombatDamageSinceLastTurn(false);
            setAttackedPlayersMyLastTurn(getAttackedPlayersMyTurn());
            clearAttackedMyTurn();
            this.lastTurnNr = game.getPhaseHandler().getTurn();
        }
    }

    public boolean canCastSorcery() {
        PhaseHandler now = game.getPhaseHandler();
        return now.isPlayerTurn(this) && now.getPhase().isMain() && game.getStack().isEmpty();
    }

    public final PlayerController getController() {
        if (!controlledBy.isEmpty()) {
            return controlledBy.lastEntry().getValue().getValue();
        }
        return controller;
    }

    public final Player getControllingPlayer() {
        if (!controlledBy.isEmpty()) {
            return controlledBy.lastEntry().getValue().getKey();
        }
        return null;
    }

    public final boolean isControlled() {
        Player ctrlPlayer = this.getControllingPlayer();
        return ctrlPlayer != null && ctrlPlayer != this;
    }

    public void addController(long timestamp, Player pl) {
        final IGameEntitiesFactory master = (IGameEntitiesFactory)pl.getLobbyPlayer();
        addController(timestamp, pl, master.createMindSlaveController(pl, this), true);
    }

    public void addController(long timestamp, Player pl, PlayerController pc, boolean event) {
        controlledBy.put(timestamp, Pair.of(pl, pc));
        getView().updateMindSlaveMaster(this);

        if (event) {
            game.fireEvent(new GameEventPlayerControl(getView(), getLobbyPlayer().getName(), !getController().isAI()));
        }
    }

    public void removeController(long timestamp) {
        removeController(timestamp, true);
    }
    public void removeController(long timestamp, boolean event) {
        controlledBy.remove(timestamp);
        getView().updateMindSlaveMaster(this);

        if (event) {
            game.fireEvent(new GameEventPlayerControl(getView(), getLobbyPlayer().getName(), !getController().isAI()));
        }
    }

    public void clearController() {
        controlledBy.clear();
        game.fireEvent(new GameEventPlayerControl(getView(), null, !getController().isAI()));
    }

    public Map.Entry<Long, Player> getControlledWhileSearching() {
        if (controlledWhileSearching.isEmpty()) {
            return null;
        }
        return controlledWhileSearching.lastEntry();
    }

    public void addControlledWhileSearching(long timestamp, Player pl) {
        controlledWhileSearching.put(timestamp, pl);
    }

    public void removeControlledWhileSearching(long timestamp) {
        controlledWhileSearching.remove(timestamp);
    }

    public final void setFirstController(PlayerController ctrlr) {
        if (controller != null) {
            throw new IllegalStateException("Controller creator already assigned");
        }
        dangerouslySetController(ctrlr);
    }

    public final void dangerouslySetController(PlayerController ctrlr) {
        controller = ctrlr;
        updateAvatar();
        updateSleeve();
        view.updateIsAI(this);
        view.updateLobbyPlayerName(this);
    }

    public void updateAvatar() {
        view.updateAvatarIndex(this);
        view.updateAvatarCardImageKey(this);
        view.setAvatarLifeDifference(0);
        view.setHasLost(false);
    }

    public void updateSleeve() {
        view.updateSleeveIndex(this);
    }

    /**
     * Run a procedure using a different controller
     */
    public void runWithController(Runnable proc, PlayerController tempController) {
        long ts = game.getNextTimestamp();
        addController(ts, this, tempController, false);
        try {
            proc.run();
        } finally {
            removeController(ts, false);
        }
    }

    public boolean isSkippingCombat() {
        return !isInGame();
    }

    public final List<Card> getPlaneswalkedToThisTurn() {
        return planeswalkedToThisTurn;
    }

    /**
     * Takes the top plane of the planar deck and put it face up in the command zone.
     * Then runs triggers.
     */
    public void planeswalk(SpellAbility sa) {
        planeswalkTo(sa, new CardCollection(getZone(ZoneType.PlanarDeck).get(0)));
    }

    /**
     * Puts the planes in the argument and puts them face up in the command zone.
     * Then runs triggers.
     */
    public void planeswalkTo(SpellAbility sa, final CardCollectionView destinations) {
        System.out.println(getName() + " planeswalks to " + destinations.toString());
        game.getView().updatePlanarPlayer(getView());

        for (Card c : destinations) {
            currentPlanes.add(game.getAction().moveTo(getZone(ZoneType.Command), c, sa, AbilityKey.newMap()));
            planeswalkedToThisTurn.add(c);
        }

        game.setActivePlanes(currentPlanes);

        final Map<AbilityKey, Object> runParams = AbilityKey.newMap();
        runParams.put(AbilityKey.Cards, destinations);
        game.getTriggerHandler().runTrigger(TriggerType.PlaneswalkedTo, runParams, false);
        view.updateCurrentPlaneName(currentPlanes.toString().replaceAll(" \\(.*","").replace("[",""));
    }

    /**
     * Puts my currently active planes, if any, at the bottom of my planar deck.
     */
    public void leaveCurrentPlane() {
        final Map<AbilityKey, Object> runParams = AbilityKey.newMap();
        runParams.put(AbilityKey.Cards, new CardCollection(currentPlanes));
        game.getTriggerHandler().runTrigger(TriggerType.PlaneswalkedFrom, runParams, false);

        for (final Card plane : currentPlanes) {
            plane.clearControllers();
            game.getAction().moveTo(ZoneType.PlanarDeck, plane, -1, null, AbilityKey.newMap());
        }
        currentPlanes.clear();
    }

    /**
     * Removes a particular plane from the active plane list.
     */
    public void removeCurrentPlane(Card c) {
        currentPlanes.remove(c);
    }

    /**
     * Sets up the first plane of a round.
     */
    public void initPlane() {
        if (game.isGameOver())
            return;
        Card firstPlane;
        view.updateCurrentPlaneName("");
        game.getView().updatePlanarPlayer(getView());
        PlayerZone planarDeck = getZone(ZoneType.PlanarDeck);

        while (!planarDeck.isEmpty()) {
            firstPlane = planarDeck.get(0);
            planarDeck.remove(firstPlane);
            if (firstPlane.getType().isPhenomenon()) {
                planarDeck.add(firstPlane);
            } else {
                currentPlanes.add(firstPlane);
                getZone(ZoneType.Command).add(firstPlane);
                break;
            }
        }
        game.setActivePlanes(currentPlanes);
        view.updateCurrentPlaneName(currentPlanes.toString().replaceAll(" \\(.*","").replace("[",""));
    }

    public CardCollectionView getInboundTokens() {
        return inboundTokens;
    }
    public void addInboundToken(Card c) {
        inboundTokens.add(c);
    }
    public void removeInboundToken(Card c) {
        inboundTokens.remove(c);
    }

    public void onMulliganned() {
        game.fireEvent(new GameEventMulligan(PlayerView.get(this))); // quest listener may interfere here
        final int newHand = getCardsIn(ZoneType.Hand).size();
        stats.notifyHasMulliganed();
        stats.notifyOpeningHandSize(newHand);
        achievementTracker.mulliganTo = newHand;
    }

    public List<Card> getCommanders() {
        return commanders;
    }

    public void copyCommandersToSnapshot(Player toPlayer, Function<Card, Card> mapper) {
        //Seems like the rest of the logic for copying players should be in this class too.
        //For now, doing this here can retain the links between commander effects and commanders.

        toPlayer.resetCommanderStats();
        toPlayer.commanders.clear();
        for (final Card c : this.getCommanders()) {
            Card newCommander = mapper.apply(c);
            if(newCommander == null)
                throw new RuntimeException("Unable to find commander in game snapshot: " + c);
            toPlayer.commanders.add(newCommander);
            newCommander.setCommander(true);
        }
        for (Map.Entry<Card, Integer> entry : this.commanderCast.entrySet()) {
            //Have to iterate over this separately in case commanders change mid-game.
            Card commander = mapper.apply(entry.getKey());
            toPlayer.commanderCast.put(commander, entry.getValue());
        }
        for (Map.Entry<Card, Integer> entry : this.getCommanderDamage()) {
            Card commander = mapper.apply(entry.getKey());
            if(commander == null) //Ceased to exist?
                continue;
            int damage = entry.getValue();
            toPlayer.addCommanderDamage(commander, damage);
        }
        if (this.commanderEffect != null) {
            Card commanderEffect = mapper.apply(this.commanderEffect);
            toPlayer.commanderEffect = (DetachedCardEffect) commanderEffect;
        }
    }

    public void addCommander(Card commander) {
        assert(this.equals(commander.getOwner())); //Making someone else's card your commander isn't currently supported.
        if(this.commanders.contains(commander))
            return;
        this.commanders.add(commander);
        if(this.commanderEffect == null)
            this.createCommanderEffect();
        commander.setCommander(true);
        view.updateCommander(this);
    }

    public void removeCommander(Card commander) {
        if(!this.commanders.remove(commander))
            return;
        commander.setCommander(false);
        view.updateCommander(this);
    }

    /**
     * Toggles whether the commander replacement effect is active.
     * (i.e. the option to send your commander to the command zone when
     * it would otherwise be sent to your library)
     * <p>
     * Used when moving a merged permanent with a commander component.
     * Causes the commander replacement to only be applied after the merged
     * permanent is split up, rather than causing every component card to be moved.
     */
    public void setCommanderReplacementSuppressed(boolean suppress) {
        if(this.commanderEffect == null)
            return;
        for (final ReplacementEffect re : this.commanderEffect.getReplacementEffects()) {
            re.setSuppressed(suppress);
        }
    }

    public Iterable<Entry<Card, Integer>> getCommanderDamage() {
        return commanderDamage.entrySet();
    }
    public int getCommanderDamage(Card commander) {
        Integer damage = commanderDamage.get(commander);
        return damage == null ? 0 : damage;
    }
    public void addCommanderDamage(Card commander, int damage) {
        commanderDamage.merge(commander, damage, Integer::sum);
    }

    public ColorSet getCommanderColorID() {
        if (commanders.isEmpty()) {
            return null;
        }
        byte ci = 0;
        for (final Card c : commanders) {
            ci |= c.getRules().getColorIdentity().getColor();
        }
        ColorSet identity = ColorSet.fromMask(ci);
        return identity;
    }
    public ColorSet getNotCommanderColorID() {
        if (commanders.isEmpty()) {
            return null;
        }
        ColorSet identity = getCommanderColorID();
        return identity.inverse();
    }

    public int getCommanderCast(Card commander) {
        return commanderCast.getOrDefault(commander, 0);
    }
    public void incCommanderCast(Card commander) {
        commanderCast.merge(commander, 1, Integer::sum);
        getView().updateCommanderCast(this, commander);
        getGame().fireEvent(new GameEventPlayerStatsChanged(this, false));
    }

    public void resetCommanderStats() {
        commanderCast.clear();
        commanderDamage.clear();
    }

    public void updateMergedCommanderInfo(Card target, Card commander) {
        getView().updateMergedCommanderCast(this, target, commander);
        getView().updateMergedCommanderDamage(target, commander);
    }

    public int getTotalCommanderCast() {
        int result = 0;
        for (Integer i : commanderCast.values()) {
            result += i;
        }
        return result;
    }

    public boolean isExtraTurn() {
        return view.getIsExtraTurn();
    }
    public void setExtraTurn(boolean b) {
        view.setIsExtraTurn(b);
    }

    public void setHasLost(boolean b) {
        view.setHasLost(b);
    }

    public int getExtraTurnCount() {
        return view.getExtraTurnCount();
    }
    public void setExtraTurnCount(final int val) {
        view.setExtraTurnCount(val);
    }

    public void setHasPriority(final boolean val) {
        view.setHasPriority(val);
    }

    public boolean isAI() {
        return view.isAI();
    }

    public void initVariantsZones(RegisteredPlayer registeredPlayer) {
        PlayerZone bf = getZone(ZoneType.Battlefield);
        Iterable<? extends IPaperCard> cards = registeredPlayer.getCardsOnBattlefield();
        if (cards != null) {
            for (final IPaperCard cp : cards) {
                Card c = Card.fromPaperCard(cp, this);
                bf.add(c);
                c.setCollectible(false); //Some nuance may be appropriate here someday.
                c.setSickness(true);
                c.setStartsGameInPlay(true);
                if (registeredPlayer.hasEnableETBCountersEffect()) {
                    for (KeywordInterface inst : c.getKeywords()) {
                        String keyword = inst.getOriginal();
                        try {
                            if (keyword.startsWith("etbCounter")) {
                                final String[] p = keyword.split(":");
                                c.addCounterInternal(CounterType.getType(p[1]), Integer.parseInt(p[2]), null, false, null, null);
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }
            }
        }

        PlayerZone com = getZone(ZoneType.Command);

        // Vanguard
        if (registeredPlayer.getVanguardAvatars() != null) {
            for (PaperCard avatar:registeredPlayer.getVanguardAvatars()) {
                Card c = Card.fromPaperCard(avatar, this);
                c.setCollectible(true);
                com.add(c);
            }
        }

        // Schemes
        CardCollection sd = new CardCollection();
        for (IPaperCard cp : registeredPlayer.getSchemes()) {
            sd.add(Card.fromPaperCard(cp, this));
        }
        if (!sd.isEmpty()) {
            for (Card c : sd) {
                c.setCollectible(true);
                getZone(ZoneType.SchemeDeck).add(c);
            }
            getZone(ZoneType.SchemeDeck).shuffle();
        }

        // Planes
        CardCollection l = new CardCollection();
        for (IPaperCard cp : registeredPlayer.getPlanes()) {
            l.add(Card.fromPaperCard(cp, this));
        }
        if (!l.isEmpty()) {
            for (Card c : l) {
                c.setCollectible(true);
                getZone(ZoneType.PlanarDeck).add(c);
            }
            getZone(ZoneType.PlanarDeck).shuffle();
        }

        // Commander
        if (!registeredPlayer.getCommanders().isEmpty()) {
            for (PaperCard pc : registeredPlayer.getCommanders()) {
                Card cmd = Card.fromPaperCard(pc, this);
                initCommanderColor(cmd);
                cmd.setCollectible(true);
                com.add(cmd);
                this.addCommander(cmd);
            }
        }
        else if (registeredPlayer.getPlaneswalker() != null) { // Planeswalker
            Card cmd = Card.fromPaperCard(registeredPlayer.getPlaneswalker(), this);
            cmd.setCollectible(true);
            cmd.setCommander(true);
            com.add(cmd);
            this.addCommander(cmd);
        }

        // Conspiracies
        for (IPaperCard cp : registeredPlayer.getConspiracies()) {
            Card conspire = Card.fromPaperCard(cp, this);
            boolean addToCommand = true;
            for (KeywordInterface ki : conspire.getKeywords(Keyword.HIDDEN_AGENDA)) {
                if (!CardFactoryUtil.handleHiddenAgenda(this, conspire, ki)) {
                    addToCommand = false;
                }
            }
            for (KeywordInterface ki : conspire.getKeywords(Keyword.DOUBLE_AGENDA)) {
                if (!CardFactoryUtil.handleHiddenAgenda(this, conspire, ki)) {
                    addToCommand = false;
                }
            }

            if (Objects.equals(conspire.getName(), "Backup Plan")) {
                PlayerZone hand = new PlayerZone(ZoneType.ExtraHand, this);
                if (this.extraZones == null) {
                    this.extraZones = new ArrayList<>();
                }
                this.extraZones.add(hand);
            }

            if (addToCommand) {
                com.add(conspire);
            }
        }

        // Attractions
        PlayerZone attractionDeck = getZone(ZoneType.AttractionDeck);
        for (IPaperCard cp : registeredPlayer.getAttractions()) {
            Card c = Card.fromPaperCard(cp, this);
            c.setCollectible(true);
            attractionDeck.add(c);
        }
        if (!attractionDeck.isEmpty())
            attractionDeck.shuffle();

        // Contraptions
        PlayerZone contraptionDeck = getZone(ZoneType.ContraptionDeck);
        for (IPaperCard cp : registeredPlayer.getContraptions()) {
            Card c = Card.fromPaperCard(cp, this);
            c.setCollectible(true);
            contraptionDeck.add(c);
        }
        if (!contraptionDeck.isEmpty())
            contraptionDeck.shuffle();

        // Adventure Mode items
        Iterable<? extends IPaperCard> adventureItemCards  = registeredPlayer.getExtraCardsInCommandZone();
        if (adventureItemCards  != null) {
            for (final IPaperCard cp : adventureItemCards) {
                Card c = Card.fromPaperCard(cp, this);
                com.add(c);
                c.setStartsGameInPlay(true);
            }
        }

        for (final Card c : getCardsIn(ZoneType.Library)) {
            for (KeywordInterface inst : c.getKeywords()) {
                String kw = inst.getOriginal();
                if (kw.startsWith("MayEffectFromOpeningDeck")) {
                    String[] split = kw.split(":");
                    final String effName = split[1];

                    final SpellAbility effect = AbilityFactory.getAbility(c.getSVar(effName), c);
                    effect.setActivatingPlayer(this);

                    getController().playSpellAbilityNoStack(effect, true);
                }
            }
        }
    }

    public void initCommanderColor(Card cmd) {
        if (cmd.getRules().getAddsWildCardColor()) {
            Player p = cmd.getController();
            String prompt = Localizer.getInstance().getMessage("lblChooseAColorFor", cmd.getName());
            SpellAbility cmdColorsa = new SpellAbility.EmptySa(ApiType.ChooseColor, cmd, p);
            byte chosenColor = p.getController().chooseColor(prompt, cmdColorsa, ColorSet.WUBRG);
            cmd.setChosenColors(List.of(MagicColor.toLongString(chosenColor)));
            p.getGame().getAction().notifyOfValue(cmdColorsa, cmd,
                    Localizer.getInstance().getMessage("lblPlayerPickedChosen", p.getName(), MagicColor.toLongString(chosenColor)), p);
        }
    }

    public boolean allCardsUniqueManaSymbols() {
        for (final Card c : getCardsIn(ZoneType.Library)) {
            Set<CardStateName> cardStateNames = c.isSplitCard() ?  EnumSet.of(CardStateName.LeftSplit, CardStateName.RightSplit) : EnumSet.of(CardStateName.Original);
            Set<ManaCostShard> coloredManaSymbols = new HashSet<>();
            Set<Integer> genericManaSymbols = new HashSet<>();

            for (final CardStateName cardStateName : cardStateNames) {
                final ManaCost manaCost = c.getState(cardStateName).getManaCost();
                for (final ManaCostShard manaSymbol : manaCost) {
                    if (!coloredManaSymbols.add(manaSymbol)) {
                        return false;
                    }
                }
                int generic = manaCost.getGenericCost();
                if (generic > 0 || manaCost.getCMC() == 0) {
                    if (!genericManaSymbols.add(generic)) {
                        return false;
                    }
                }
            }
        }
        return true;
    }

    public void assignCompanion(Game game, PlayerController player) {
        List<Card> legalCompanions = Lists.newArrayList();

        boolean uniqueNames = true;
        Set<String> cardNames = new HashSet<>();
        Set<CardType.CoreType> cardTypes = EnumSet.allOf(CardType.CoreType.class);
        final CardCollection nonLandInDeck = CardLists.getNotType(getCardsIn(ZoneType.Library), "Land");
        for (final Card c : nonLandInDeck) {
            if (uniqueNames) {
                if (cardNames.contains(c.getName())) {
                    uniqueNames = false;
                } else {
                    cardNames.add(c.getName());
                }
            }

            cardTypes.retainAll(c.getPaperCard().getRules().getType().getCoreTypes());
        }

        int deckSize = getCardsIn(ZoneType.Library).size();
        int minSize = game.getMatch().getRules().getGameType().getDeckFormat().getMainRange().getMinimum();

        game.getAction().checkStaticAbilities(false);

        for (final Card c : getCardsIn(ZoneType.Sideboard)) {
            for (KeywordInterface inst : c.getKeywords(Keyword.COMPANION)) {
                if (!(inst instanceof Companion kwInstance)) {
                    continue;
                }

                if (kwInstance.hasSpecialRestriction()) {
                    String specialRules = kwInstance.getSpecialRules();
                    if (specialRules.equals("UniqueNames")) {
                        if (uniqueNames) {
                            legalCompanions.add(c);
                        }
                    } else if (specialRules.equals("UniqueManaSymbols")) {
                        if (this.allCardsUniqueManaSymbols()) {
                            legalCompanions.add(c);
                        }
                    } else if (specialRules.equals("DeckSizePlus20")) {
                        // +20 deck size to min deck size
                        if (deckSize >= minSize + 20) {
                            legalCompanions.add(c);
                        }
                    } else if (specialRules.equals("SharesCardType")) {
                        // Shares card type
                        if (!cardTypes.isEmpty()) {
                            legalCompanions.add(c);
                        }
                    }
                } else {
                    String restriction = kwInstance.getDeckRestriction();
                    if (deckMatchesDeckRestriction(c, restriction)) {
                        legalCompanions.add(c);
                    }
                }
            }
        }

        if (legalCompanions.isEmpty()) {
            return;
        }

        CardCollectionView view = CardCollection.getView(legalCompanions);

        SpellAbility fakeSa = new SpellAbility.EmptySa(ApiType.CompanionChoose, legalCompanions.get(0), this);
        Card companion = player.chooseSingleEntityForEffect(view, fakeSa, Localizer.getInstance().getMessage("lblChooseACompanion"), true, null);

        PlayerZone commandZone = getZone(ZoneType.Command);
        companion = game.getAction().moveTo(ZoneType.Command, companion, null, AbilityKey.newMap());
        commandZone.add(Player.createCompanionEffect(companion));
        updateZoneForView(commandZone);
    }

    public boolean deckMatchesDeckRestriction(Card source, String restriction) {
        for (final Card c : getCardsIn(ZoneType.Library)) {
            if (!c.isValid(restriction.split(","), this, source, null)) {
                return false;
            }
        }
        return true;
     }

    public static DetachedCardEffect createCompanionEffect(Card companion) {
        final String name = Lang.getInstance().getPossesive(companion.getDisplayName()) + " Companion Effect";
        DetachedCardEffect eff = new DetachedCardEffect(companion, name);

        String addToHandAbility = "Mode$ Continuous | EffectZone$ Command | Affected$ Card.YouOwn+EffectSource | AffectedZone$ Command | AddAbility$ MoveToHand";
        String moveToHand = "ST$ ChangeZone | Cost$ 3 | Defined$ Self | Origin$ Command | Destination$ Hand | SorcerySpeed$ True | ActivationZone$ Command | SpellDescription$ Companion - Put CARDNAME in to your hand";

        StaticAbility stAb = StaticAbility.create(addToHandAbility, eff, eff.getCurrentState(), true);
        stAb.setSVar("MoveToHand", moveToHand);
        eff.addStaticAbility(stAb);

        return eff;
    }

    public void createCommanderEffect() {
        PlayerZone com = getZone(ZoneType.Command);
        if(this.commanderEffect != null)
            com.remove(this.commanderEffect);

        DetachedCardEffect eff = new DetachedCardEffect(this, "Commander Effect");

        String validCommander = "Card.IsCommander+YouOwn";
        if (game.getRules().hasAppliedVariant(GameType.Oathbreaker)) {
            //signature spells can only reside on the stack or in the command zone
            String effStr = "DB$ ChangeZone | Origin$ Stack | Destination$ Command | Defined$ ReplacedCard";

            String moved = "Event$ Moved | ValidCard$ Spell.IsCommander+YouOwn | Secondary$ True | Destination$ Graveyard,Exile,Hand,Library | " +
                    "Description$ If a signature spell would be put into another zone from the stack, put it into the command zone instead.";
            ReplacementEffect re = ReplacementHandler.parseReplacement(moved, eff, true);
            re.setOverridingAbility(AbilityFactory.getAbility(effStr, eff));
            eff.addReplacementEffect(re);

            //TODO: Actual recognition for signature spells as their own thing, separate from commanders.
            validCommander = "Permanent.IsCommander+YouOwn";

            //signature spells can only be cast if your oathbreaker is in on the battlefield under your control
            String castRestriction = "Mode$ CantBeCast | ValidCard$ Spell.IsCommander+YouOwn | EffectZone$ Command | IsPresent$ Permanent.IsCommander+YouOwn+YouCtrl | PresentZone$ Battlefield | PresentCompare$ EQ0 | " +
                    "Description$ Signature spell can only be cast if your oathbreaker is on the battlefield under your control.";
            eff.addStaticAbility(castRestriction);
        }

        String effStr = "DB$ ChangeZone | Origin$ Battlefield,Graveyard,Exile,Library,Hand | Destination$ Command | Defined$ ReplacedCard";

        String moved = "Event$ Moved | ValidCard$ " + validCommander + " | Secondary$ True | Optional$ True | OptionalDecider$ You | CommanderMoveReplacement$ True ";
        if (game.getRules().hasAppliedVariant(GameType.TinyLeaders)) {
            moved += " | Destination$ Graveyard,Exile | Description$ If a commander would be put into its owner's graveyard or exile from anywhere, that player may put it into the command zone instead.";
        }
        else if (game.getRules().hasAppliedVariant(GameType.Oathbreaker)) {
            moved += " | Destination$ Graveyard,Exile,Hand,Library | Description$ If a commander would be exiled or put into hand, graveyard, or library from anywhere, that player may put it into the command zone instead.";
        } else {
            // rule 903.9b
            moved += " | Destination$ Hand,Library | Description$ If a commander would be put into its owner's hand or library from anywhere, its owner may put it into the command zone instead.";
        }
        ReplacementEffect re = ReplacementHandler.parseReplacement(moved, eff, true);
        re.setOverridingAbility(AbilityFactory.getAbility(effStr, eff));
        eff.addReplacementEffect(re);

        String mayBePlayedAbility = "Mode$ Continuous | EffectZone$ Command | MayPlay$ True | Affected$ Card.IsCommander+YouOwn | AffectedZone$ Command";
        if (game.getRules().hasAppliedVariant(GameType.Planeswalker)) { //support paying for Planeswalker with any color mana
            mayBePlayedAbility += " | MayPlayIgnoreColor$ True";
        }
        eff.addStaticAbility(mayBePlayedAbility);
        this.commanderEffect = eff;
        com.add(eff);
    }

    public void createPlanechaseEffects(Game game) {
        final PlayerZone com = getZone(ZoneType.Command);
        final String name = "Planar Dice";
        final Card eff = new Card(game.nextCardId(), game);
        eff.setGameTimestamp(game.getNextTimestamp());
        eff.setName(name);
        eff.setOwner(this);
        eff.setGamePieceType(GamePieceType.EFFECT);
        String image = ImageKeys.getTokenKey("planechase");
        eff.setImageKey(image);

        String trigger = "Mode$ PlanarDice | Result$ Planeswalk | TriggerZones$ Command | ValidPlayer$ You | Secondary$ True | " +
                "TriggerDescription$ Whenever you roll the Planeswalker symbol on the planar die, planeswalk.";
        String rolledWalk = "DB$ Planeswalk | Cause$ PlanarDie";
        Trigger planesWalkTrigger = TriggerHandler.parseTrigger(trigger, eff, true);
        planesWalkTrigger.setOverridingAbility(AbilityFactory.getAbility(rolledWalk, eff));
        eff.addTrigger(planesWalkTrigger);

        String specialA = "ST$ RollPlanarDice | Cost$ X | SorcerySpeed$ True | Activator$ Player | SpecialAction$ True" +
                " | ActivationZone$ Command | SpellDescription$ Roll the planar dice. X is equal to the number of " +
                "times you have previously taken this action this turn. | CostDesc$ {X}: ";
        SpellAbility planarRoll = AbilityFactory.getAbility(specialA, eff);
        planarRoll.setSVar("X", "Count$PlanarDiceSpecialActionThisTurn");
        eff.addSpellAbility(planarRoll);

        eff.updateStateForView();
        com.add(eff);
        this.updateZoneForView(com);
    }

    public void createTheRing(String set) {
        if (theRing == null) {
            final PlayerZone com = getZone(ZoneType.Command);
            theRing = new Card(game.nextCardId(), null, game);
            theRing.setOwner(this);
            theRing.setGamePieceType(GamePieceType.EFFECT);
            theRing.setImageKey(StaticData.instance().getOtherImageKey(ImageKeys.THE_RING_IMAGE, set));
            if (set != null) {
                theRing.setSetCode(set);
            }
            theRing.setName("The Ring");
            theRing.updateStateForView();
            com.add(theRing);
            this.updateZoneForView(com);
        }
    }
    public void setRingLevel(int level) {
        if (getTheRing() == null)
            createTheRing(null);
        if (level == 1) {
            String legendary = "Mode$ Continuous | EffectZone$ Command | Affected$ Card.YouCtrl+IsRingbearer | AddType$ Legendary | Description$ Your Ring-bearer is legendary.";
            String cantBeBlocked = "Mode$ CantBlockBy | EffectZone$ Command | ValidAttacker$ Card.YouCtrl+IsRingbearer | ValidBlockerRelative$ Creature.powerGTX | Description$ Your Ring-bearer can't be blocked by creatures with greater power.";
            getTheRing().addStaticAbility(legendary);
            StaticAbility st = getTheRing().addStaticAbility(cantBeBlocked);
            st.setSVar("X", "Count$CardPower");
        } else if (level == 2) {
            final String attackTrig = "Mode$ Attacks | ValidCard$ Card.YouCtrl+IsRingbearer | TriggerDescription$ Whenever your ring-bearer attacks, draw a card, then discard a card. | TriggerZones$ Command";
            final String drawEffect = "DB$ Draw | Defined$ You | NumCards$ 1";
            final String discardEffect = "DB$ Discard | Defined$ You | NumCards$ 1 | Mode$ TgtChoose";

            final Trigger attackTrigger = TriggerHandler.parseTrigger(attackTrig, getTheRing(), true);

            SpellAbility drawExecute = AbilityFactory.getAbility(drawEffect, getTheRing());
            AbilitySub discardExecute = (AbilitySub) AbilityFactory.getAbility(discardEffect, getTheRing());

            drawExecute.setSubAbility(discardExecute);
            attackTrigger.setOverridingAbility(drawExecute);
            getTheRing().addTrigger(attackTrigger);
        } else if (level == 3) {
            final String becomesBlockedTrig = "Mode$ AttackerBlockedByCreature | ValidCard$ Card.YouCtrl+IsRingbearer| ValidBlocker$ Creature | TriggerZones$ Command | TriggerDescription$ Whenever your Ring-bearer becomes blocked a creature, that creature's controller sacrifices it at the end of combat.";
            final String endOfCombatTrig = "DB$ DelayedTrigger | Mode$ Phase | Phase$ EndCombat | RememberObjects$ TriggeredBlockerLKICopy | TriggerDescription$ At end of combat, the controller of the creature that blocked CARDNAME sacrifices that creature.";
            final String sacBlockerEffect = "DB$ SacrificeAll | Defined$ DelayTriggerRememberedLKI";

            final Trigger becomesBlockedTrigger = TriggerHandler.parseTrigger(becomesBlockedTrig, getTheRing(), true);

            SpellAbility endCombatExecute = AbilityFactory.getAbility(endOfCombatTrig, getTheRing());
            AbilitySub sacExecute = (AbilitySub) AbilityFactory.getAbility(sacBlockerEffect, getTheRing());

            endCombatExecute.setAdditionalAbility("Execute", sacExecute);
            becomesBlockedTrigger.setOverridingAbility(endCombatExecute);
            getTheRing().addTrigger(becomesBlockedTrigger);
        } else if (level == 4) {
            final String damageTrig = "Mode$ DamageDone | ValidSource$ Card.YouCtrl+IsRingbearer | ValidTarget$ Player | CombatDamage$ True | TriggerZones$ Command | TriggerDescription$ Whenever your Ring-bearer deals combat damage to a player, each opponent loses 3 life.";
            final String loseEffect = "DB$ LoseLife | Defined$ Opponent | LifeAmount$ 3";

            final Trigger damageTrigger = TriggerHandler.parseTrigger(damageTrig, getTheRing(), true);
            SpellAbility loseExecute = AbilityFactory.getAbility(loseEffect, getTheRing());

            damageTrigger.setOverridingAbility(loseExecute);
            getTheRing().addTrigger(damageTrigger);
        }
        getTheRing().updateStateForView();
    }

    public final int getNumRingTemptedYou() {
        return numRingTemptedYou;
    }
    public final void incrementRingTemptedYou() {
        numRingTemptedYou++;
    }
    public final void setNumRingTemptedYou(int value) {
        numRingTemptedYou = value;
    }
    public final void resetRingTemptedYou() {
        numRingTemptedYou = 0;
    }

    public void changeOwnership(Card card) {
        // If lost then gained, just clear out of lost.
        // If gained then lost, just clear out of gained.
        Player oldOwner = card.getOwner();

        if (equals(oldOwner)) {
            return;
        }
        card.setOwner(this);

        if(!card.isCollectible()) {
            return;
        }

        if (!card.getGame().getRules().useAnte()) {
            // Only track permanent ownership changes when ante is used
            return;
        }

        if (lostOwnership.contains(card)) {
            lostOwnership.remove(card);
        } else {
            gainedOwnership.add(card);
        }

        if (oldOwner.gainedOwnership.contains(card)) {
            oldOwner.gainedOwnership.remove(card);
        } else {
            oldOwner.lostOwnership.add(card);
        }
    }

    public void destroyPhysicalCard(Card card) {
        if(!card.isCollectible()) {
            return;
        }

        card.getOwner().lostOwnership.add(card);
    }

    public CardCollectionView getLostOwnership() {
        return lostOwnership;
    }
    public CardCollectionView getGainedOwnership() {
        return gainedOwnership;
    }

    @Override
    public PlayerView getView() {
        return view;
    }

    public SpellAbility getPaidForSA() {
        return paidForStack.peek();
    }
    public void pushPaidForSA(SpellAbility sa) {
        paidForStack.push(sa);
    }
    public void popPaidForSA() {
        // it could be empty if spell couldn't be cast
        paidForStack.poll();
    }
    public void clearPaidForSA() {
        paidForStack.clear();
    }

    public boolean isStartingPlayer() {
        return equals(game.getStartingPlayer());
    }

    public boolean isMonarch() {
        return equals(game.getMonarch());
    }

    public String getMonarchSet() {
        return monarchEffect == null ? monarchEffect.getSetCode() : null;
    }

    public void createMonarchEffect(final String set) {
        final PlayerZone com = getZone(ZoneType.Command);
        if (monarchEffect == null) {
            monarchEffect = new Card(game.nextCardId(), null, game);
            monarchEffect.setOwner(this);
            monarchEffect.setGamePieceType(GamePieceType.EFFECT);
            monarchEffect.setImageKey(StaticData.instance().getOtherImageKey(ImageKeys.MONARCH_IMAGE, set));
            monarchEffect.setSetCode(set);
            monarchEffect.setName("The Monarch");

            {
                final String drawTrig = "Mode$ Phase | Phase$ End of Turn | TriggerZones$ Command | " +
                "ValidPlayer$ You |  TriggerDescription$ At the beginning of your end step, draw a card.";
                final String drawEff = "DB$ Draw | Defined$ You";

                final Trigger drawTrigger = TriggerHandler.parseTrigger(drawTrig, monarchEffect, true);

                drawTrigger.setOverridingAbility(AbilityFactory.getAbility(drawEff, monarchEffect));
                monarchEffect.addTrigger(drawTrigger);
            }

            {
                final String damageTrig = "Mode$ DamageDone | ValidSource$ Creature | ValidTarget$ You | CombatDamage$ True | TriggerZones$ Command |" +
                " TriggerDescription$ Whenever a creature deals combat damage to you, its controller becomes the monarch.";
                final String damageEff = "DB$ BecomeMonarch | Defined$ TriggeredSourceController";

                final Trigger damageTrigger = TriggerHandler.parseTrigger(damageTrig, monarchEffect, true);

                damageTrigger.setOverridingAbility(AbilityFactory.getAbility(damageEff, monarchEffect));
                monarchEffect.addTrigger(damageTrigger);
            }
            monarchEffect.updateStateForView();
        }
        com.add(monarchEffect);

        this.updateZoneForView(com);
    }
    public void removeMonarchEffect() {
        final PlayerZone com = getZone(ZoneType.Command);
        if (monarchEffect != null) {
            com.remove(monarchEffect);
            this.updateZoneForView(com);
        }
    }
    public boolean canBecomeMonarch() {
        return !StaticAbilityCantBecomeMonarch.anyCantBecomeMonarch(this);
    }

    public String getInitiativeSet() {
        return initiativeEffect != null ? initiativeEffect.getSetCode() : null;
    }

    public void createInitiativeEffect(final String set) {
        final PlayerZone com = getZone(ZoneType.Command);
        if (initiativeEffect == null) {
            initiativeEffect = new Card(game.nextCardId(), null, game);
            initiativeEffect.setOwner(this);
            initiativeEffect.setGamePieceType(GamePieceType.EFFECT);
            initiativeEffect.setImageKey(StaticData.instance().getOtherImageKey(ImageKeys.INITIATIVE_IMAGE, set));
            initiativeEffect.setSetCode(set);
            initiativeEffect.setName("The Initiative");

            //Set up damage trigger
            final String damageTrig = "Mode$ DamageDoneOnceByController | ValidSource$ Player | ValidTarget$ You | " +
                    "CombatDamage$ True | TriggerZones$ Command | TriggerDescription$ Whenever one or more " +
                    "creatures a player controls deal combat damage to you, that player takes the initiative.";
            final String damageEff = "DB$ TakeInitiative | Defined$ TriggeredSource";

            final Trigger damageTrigger = TriggerHandler.parseTrigger(damageTrig, initiativeEffect, true);

            damageTrigger.setOverridingAbility(AbilityFactory.getAbility(damageEff, initiativeEffect));
            initiativeEffect.addTrigger(damageTrigger);

            //Set up triggers to venture into Undercity
            final String ventureTakeTrig  = "Mode$ TakesInitiative | ValidPlayer$ You | TriggerZones$ Command | " +
                    "TriggerDescription$ Whenever you take the initiative and at the beginning of your upkeep, " +
                    "venture into Undercity. (If you're in a dungeon, advance to the next room. If not, enter " +
                    "Undercity. You can take the initiative even if you already have it.)";

            final String ventureUpkpTrig = "Mode$ Phase | Phase$ Upkeep | TriggerZones$ Command | ValidPlayer$ You " +
                    "| TriggerDescription$ Whenever you take the initiative and at the beginning of your upkeep, " +
                    "venture into Undercity. (If you're in a dungeon, advance to the next room. If not, enter " +
                    "Undercity. You can take the initiative even if you already have it.) | Secondary$ True";

            final String ventureEff = "DB$ Venture | Dungeon$ Undercity";

            final Trigger ventureUTrigger = TriggerHandler.parseTrigger(ventureUpkpTrig, initiativeEffect, true);
            ventureUTrigger.setOverridingAbility(AbilityFactory.getAbility(ventureEff, initiativeEffect));
            initiativeEffect.addTrigger(ventureUTrigger);

            final Trigger ventureTTrigger = TriggerHandler.parseTrigger(ventureTakeTrig, initiativeEffect, true);
            ventureTTrigger.setOverridingAbility(AbilityFactory.getAbility(ventureEff, initiativeEffect));
            initiativeEffect.addTrigger(ventureTTrigger);

            initiativeEffect.updateStateForView();
        }

        final TriggerHandler triggerHandler = game.getTriggerHandler();
        com.add(initiativeEffect);
        triggerHandler.clearActiveTriggers(initiativeEffect, null);
        triggerHandler.registerActiveTrigger(initiativeEffect, false);

        this.updateZoneForView(com);
    }

    public boolean hasInitiative() {
        return equals(game.getHasInitiative());
    }

    public void removeInitiativeEffect() {
        final PlayerZone com = getZone(ZoneType.Command);
        if (initiativeEffect != null) {
            com.remove(initiativeEffect);
            this.updateZoneForView(com);
        }
    }

    public final Card getRadiationEffect() {
        return radiationEffect;
    }
    public void createRadiationEffect(String setCode) {
        final PlayerZone com = getZone(ZoneType.Command);
        if (radiationEffect == null) {
            radiationEffect = new Card(game.nextCardId(), null, game);
            radiationEffect.setOwner(this);
            radiationEffect.setGamePieceType(GamePieceType.EFFECT);
            radiationEffect.setImageKey(StaticData.instance().getOtherImageKey(ImageKeys.RADIATION_IMAGE, setCode));
            radiationEffect.setName("Radiation");
            if (setCode != null) {
                radiationEffect.setSetCode(setCode);
            }

            String trigStr = "Mode$ Phase | Phase$ Main1 | ValidPlayer$ You | TriggerZones$ Command | TriggerDescription$ " +
                "At the beginning of your precombat main phase, if you have any rad counters, mill that many cards. For each nonland card milled this way, you lose 1 life and a rad counter.";

            Trigger tr = TriggerHandler.parseTrigger(trigStr, radiationEffect, true);
            SpellAbility sa = AbilityFactory.getAbility("DB$ InternalRadiation", radiationEffect);
            tr.setOverridingAbility(sa);

            radiationEffect.addTrigger(tr);
            radiationEffect.updateStateForView();
        }
        com.add(radiationEffect);
        this.updateZoneForView(com);
    }

    public void removeRadiationEffect() {
        final PlayerZone com = getZone(ZoneType.Command);
        if (radiationEffect != null) {
            com.remove(radiationEffect);
            radiationEffect = null;
            this.updateZoneForView(com);
        }
    }

    public boolean hasRadiationEffect() {
        return radiationEffect != null;
    }

    public Card getKeywordCard() {
        if (keywordEffect != null) {
            return keywordEffect;
        }

        final PlayerZone com = getZone(ZoneType.Command);

        keywordEffect = new Card(game.nextCardId(), null, game);
        keywordEffect.setGamePieceType(GamePieceType.EFFECT);
        keywordEffect.setOwner(this);
        keywordEffect.setName("Keyword Effects");
        keywordEffect.setImageKey(ImageKeys.HIDDEN_CARD);

        keywordEffect.updateStateForView();

        com.add(keywordEffect);

        this.updateZoneForView(com);
        return keywordEffect;
    }
    public void updateKeywordCardAbilityText() {
        if (getKeywordCard() == null)
            return;
        final PlayerZone com = getZone(ZoneType.Command);
        keywordEffect.setText("");
        boolean headerAdded = false;
        StringBuilder kw = new StringBuilder();
        for (KeywordInterface k : keywords) {
            if (!headerAdded) {
                headerAdded = true;
                kw.append(this.getName()).append(" has: \n");
            }
            kw.append(k).append("\n");
        }
        if (!kw.toString().isEmpty()) {
            keywordEffect.setText(trimKeywords(kw.toString()));
        }
        keywordEffect.updateAbilityTextForView();
        this.updateZoneForView(com);
    }
    public String trimKeywords(String keywordTexts) {
        if (keywordTexts.contains("Protection:")) {
            List <String> lines = Arrays.asList(keywordTexts.split("\n"));
            for (String line : lines) {
                if (line.startsWith("Protection:")) {
                    List<String> parts = Arrays.asList(line.split(":"));
                    if (parts.size() > 2) {
                        keywordTexts = TextUtil.fastReplace(keywordTexts, line, parts.get(2));
                    }
                }
            }
        }
        keywordTexts = TextUtil.fastReplace(keywordTexts,":Card.named", " from ");
        keywordTexts = TextUtil.fastReplace(keywordTexts, ":Card.Black:", " from ");
        keywordTexts = TextUtil.fastReplace(keywordTexts, ":Card.Blue:", " from ");
        keywordTexts = TextUtil.fastReplace(keywordTexts, ":Card.Red:", " from ");
        keywordTexts = TextUtil.fastReplace(keywordTexts, ":Card.Green:", " from ");
        keywordTexts = TextUtil.fastReplace(keywordTexts, ":Card.White:", " from ");
        keywordTexts = TextUtil.fastReplace(keywordTexts, ":Card.MonoColor:", " from ");
        keywordTexts = TextUtil.fastReplace(keywordTexts, ":Card.MultiColor:", " from ");
        keywordTexts = TextUtil.fastReplace(keywordTexts, ":Card.Colorless:", " from ");
        return keywordTexts;
    }
    public void checkKeywordCard() {
        if (keywordEffect == null)
            return;
        final PlayerZone com = getZone(ZoneType.Command);
        if (keywordEffect.getAbilityText().isEmpty()) {
            com.remove(keywordEffect);
            this.updateZoneForView(com);
            keywordEffect = null;
        }
    }

    public boolean hasBlessing() {
        return blessingEffect != null;
    }
    public void setBlessing(boolean bless, String setCode) {
        // no need to to change
        if ((blessingEffect != null) == bless) {
            return;
        }

        final PlayerZone com = getZone(ZoneType.Command);

        if (bless) {
            blessingEffect = new Card(game.nextCardId(), null, game);
            blessingEffect.setOwner(this);
            blessingEffect.setImageKey(StaticData.instance().getOtherImageKey(ImageKeys.BLESSING_IMAGE, setCode));
            blessingEffect.setName("City's Blessing");
            blessingEffect.setGamePieceType(GamePieceType.EFFECT);
            if (setCode != null) {
                blessingEffect.setSetCode(setCode);
            }

            blessingEffect.updateStateForView();

            com.add(blessingEffect);

            // 702.131d. After a player gets the city's blessing, continuous effects are reapplied
            game.getAction().checkStaticAbilities();
        } else {
            com.remove(blessingEffect);
            blessingEffect = null;
        }

        this.updateZoneForView(com);
    }

    public final boolean sameTeam(final Player other) {
        if (this.equals(other)) {
            return true;
        }
        if (this.teamNumber < 0 || other.getTeam() < 0) {
            return false;
        }
        return this.teamNumber == other.getTeam();
    }

    public final boolean isCursed() {
        return CardLists.count(getAttachedCards(), Card::isCurse) > 0;
    }

    public boolean canDiscardBy(SpellAbility sa, final boolean effect) {
        if (sa == null) {
            return true;
        }

        return !StaticAbilityCantDiscard.cantDiscard(this, sa, effect);
    }

    public boolean canSearchLibraryWith(SpellAbility sa, Player targetPlayer) {
        if (sa == null) {
            return true;
        }

        if (hasKeyword("CantSearchLibrary")) {
            return false;
        }
        return targetPlayer == null || !targetPlayer.equals(sa.getActivatingPlayer())
                || !hasKeyword("Spells and abilities you control can't cause you to search your library.");
    }

    public void addAdditionalVote(long timestamp, int value) {
        additionalVotes.put(timestamp, value);
        getView().updateAdditionalVote(this);
        getGame().fireEvent(new GameEventPlayerStatsChanged(this, false));
    }
    public void removeAdditionalVote(long timestamp) {
        if (additionalVotes.remove(timestamp) != null) {
            getView().updateAdditionalVote(this);
            getGame().fireEvent(new GameEventPlayerStatsChanged(this, false));
        }
    }

    public int getAdditionalVotesAmount() {
        int value = 0;
        for (Integer i : additionalVotes.values()) {
            value += i;
        }
        return value;
    }

    public void addAdditionalOptionalVote(long timestamp, int value) {
        additionalOptionalVotes.put(timestamp, value);
        getView().updateOptionalAdditionalVote(this);
        getGame().fireEvent(new GameEventPlayerStatsChanged(this, false));
    }
    public void removeAdditionalOptionalVote(long timestamp) {
        if (additionalOptionalVotes.remove(timestamp) != null) {
            getView().updateOptionalAdditionalVote(this);
            getGame().fireEvent(new GameEventPlayerStatsChanged(this, false));
        }
    }

    public int getAdditionalOptionalVotesAmount() {
        int value = 0;
        for (Integer i : additionalOptionalVotes.values()) {
            value += i;
        }
        return value;
    }

    public boolean addControlVote(long timestamp) {
        if (controlVotes.add(timestamp)) {
            updateControlVote();
            return true;
        }
        return false;
    }
    public boolean removeControlVote(long timestamp) {
        if (controlVotes.remove(timestamp)) {
            updateControlVote();
            return true;
        }
        return false;
    }

    void updateControlVote() {
        // need to update all players because it can't know
        Player control = getGame().getControlVote();
        for (Player pl : getGame().getPlayers()) {
            pl.getView().updateControlVote(pl.equals(control));
            getGame().fireEvent(new GameEventPlayerStatsChanged(pl, false));
        }
    }

    public Set<Long> getControlVote() {
        return controlVotes;
    }
    public void setControlVote(Set<Long> value) {
        controlVotes.clear();
        controlVotes.addAll(value);
        updateControlVote();
    }

    public Long getHighestControlVote() {
        if (controlVotes.isEmpty()) {
            return null;
        }
        return controlVotes.last();
    }

    public void addAdditionalVillainousChoices(long timestamp, int value) {
        additionalVillainousChoices.put(timestamp, value);
        getView().updateAdditionalVillainousChoices(this);
        getGame().fireEvent(new GameEventPlayerStatsChanged(this, false));
    }
    public void removeAdditionalVillainousChoices(long timestamp) {
        if (additionalVillainousChoices.remove(timestamp) != null) {
            getView().updateAdditionalVillainousChoices(this);
            getGame().fireEvent(new GameEventPlayerStatsChanged(this, false));
        }
    }

    public int getAdditionalVillainousChoices() {
        int value = 0;
        for (Integer i : additionalVillainousChoices.values()) {
            value += i;
        }
        return value;
    }

    public void addCycled(SpellAbility sp) {
        Map<AbilityKey, Object> cycleParams = AbilityKey.mapFromCard(CardCopyService.getLKICopy(game.getCardState(sp.getHostCard())));
        cycleParams.put(AbilityKey.Cause, sp);
        cycleParams.put(AbilityKey.Player, this);
        cycleParams.put(AbilityKey.FirstTime, CardUtil.getThisTurnActivated("Activated.Cycling+YouCtrl", sp.getHostCard(), sp, this).size() == 1);
        game.getTriggerHandler().runTrigger(TriggerType.Cycled, cycleParams, false);
    }

    public boolean hasUrzaLands() {
        final CardCollectionView landsControlled = getCardsIn(ZoneType.Battlefield);
        return landsControlled.anyMatch(CardPredicates.isType("Urza's").and(CardPredicates.isType("Mine")))
                && landsControlled.anyMatch(CardPredicates.isType("Urza's").and(CardPredicates.isType("Power-Plant")))
                && landsControlled.anyMatch(CardPredicates.isType("Urza's").and(CardPredicates.isType("Tower")));
    }

    public void revealFaceDownCards() {
        final List<List<ZoneType>> revealZones = Arrays.asList(Arrays.asList(ZoneType.Battlefield, ZoneType.Merged), Arrays.asList(ZoneType.Exile));
        final PlayerCollection otherPlayers = new PlayerCollection(game.getRegisteredPlayers());
        otherPlayers.remove(this);

        for (List<ZoneType> z : revealZones) {
            CardCollection revealCards = new CardCollection();
            for (Card c : game.getCardsInOwnedBy(z, this)) {
                if (!c.isRealFaceDown()) continue;

                Card lki = CardCopyService.getLKICopy(c);
                lki.forceTurnFaceUp();
                lki.setZone(c.getZone());
                revealCards.add(lki);
            }
            game.getAction().revealTo(revealCards, otherPlayers, Localizer.getInstance().getMessage("lblRevealFaceDownCards"), true);
        }
    }

    public void learnLesson(SpellAbility sa, Map<AbilityKey, Object> params) {
        if (hasLost()) {
            return;
        }

        Map<AbilityKey, Object> repParams = AbilityKey.mapFromAffected(this);
        repParams.put(AbilityKey.Cause, sa);
        repParams.putAll(params);
        if (game.getReplacementHandler().run(ReplacementType.Learn, repParams) != ReplacementResult.NotReplaced) {
            return;
        }

        CardCollection list = new CardCollection();
        if (!isControlled()) {
            list.addAll(CardLists.getType(getZone(ZoneType.Sideboard), "Lesson"));
        }
        list.addAll(getZone(ZoneType.Hand));
        if (list.isEmpty()) {
            return;
        }

        Card c = getController().chooseSingleCardForZoneChange(ZoneType.Hand, List.of(ZoneType.Sideboard, ZoneType.Hand),
                sa, list, null, Localizer.getInstance().getMessage("lblLearnALesson"), true, this);
        if (c == null) {
            return;
        }
        if (c.isInZone(ZoneType.Sideboard)) { // Sideboard Lesson to Hand
            game.getAction().reveal(new CardCollection(c), c.getOwner(), true);
            game.getAction().moveTo(ZoneType.Hand, c, sa, params);
        } else if (c.isInZone(ZoneType.Hand)) { // Discard and Draw
            List<Card> discardedBefore = Lists.newArrayList(getDiscardedThisTurn());
            Card moved = discard(c, sa, true, params);
            if (moved != null) {
                // Change this if something would make multiple player learn at the same time

                // Discard Trigger outside Effect
                final Map<AbilityKey, Object> runParams = AbilityKey.mapFromPlayer(this);
                runParams.put(AbilityKey.Cards, new CardCollection(moved));
                runParams.put(AbilityKey.Cause, sa);
                runParams.put(AbilityKey.DiscardedBefore, discardedBefore);
                if (params != null) {
                    runParams.putAll(params);
                }
                getGame().getTriggerHandler().runTrigger(TriggerType.DiscardedAll, runParams, false);

                drawCards(1, sa, params);
            }
        }
    }

    public void commitCrime() {
        //boolean firstTime = this.commitedCrimeThisTurn == 0;
        committedCrimeThisTurn++;

        final Map<AbilityKey, Object> runParams = AbilityKey.mapFromPlayer(this);
        game.getTriggerHandler().runTrigger(TriggerType.CommitCrime, runParams, false);
    }

    public int getCommittedCrimeThisTurn() {
        return committedCrimeThisTurn;
    }
    public void setCommitedCrimeThisTurn(int v) {
        committedCrimeThisTurn = v;
    }

    public List<Integer> getDiceRollsThisTurn() {
        return diceRollsThisTurn;
    }
    public void addDieRollThisTurn(List<Integer> rolls) {
        diceRollsThisTurn.addAll(rolls);
    }

    public int getExpentThisTurn() {
        return expentThisTurn;
    }
    public void setExpentThisTurn(int v) {
        expentThisTurn = v;
    }

    public void addExpentThisTurn(int v, SpellAbility sp) {
        if (v <= 0) {
            return;
        }
        int startingMana = expentThisTurn;
        int totalMana = expentThisTurn += v;
        for (int i = startingMana + 1; i <= totalMana; i++) {
            Map<AbilityKey, Object> expendParams = AbilityKey.mapFromPlayer(this);
            expendParams.put(AbilityKey.SpellAbility, sp);
            expendParams.put(AbilityKey.Amount, i);
            game.getTriggerHandler().runTrigger(TriggerType.ManaExpend, expendParams, true);
        }
    }

    public void visitAttractions(int light) {
        CardCollection attractions = CardLists.filter(getCardsIn(ZoneType.Battlefield), CardPredicates.isAttractionWithLight(light));
        for (Card c : attractions) {
            if(!c.wasVisitedThisTurn())
                this.attractionsVisitedThisTurn++;
            c.visitAttraction(this);
        }
    }
    public void rollToVisitAttractions() {
        this.visitAttractions(RollDiceEffect.rollDiceForPlayerToVisitAttractions(this));
    }
    public int getAttractionsVisitedThisTurn() {
        return this.attractionsVisitedThisTurn;
    }

    public int getCrankCounter() {
        return this.crankCounter;
    }
    public void setCrankCounter(int counters) {
        this.crankCounter = counters;
        if (this.contraptionSprocketEffect != null) {
            String label = Localizer.getInstance().getMessage("lblCrank", this.crankCounter);
            contraptionSprocketEffect.setOverlayText(label);
        }
        else if (this.getCardsIn(ZoneType.Battlefield).anyMatch(Card::isContraption)) {
            this.createContraptionSprockets();
        }
    }
    public void advanceCrankCounter() {
        this.setCrankCounter((this.crankCounter) % 3 + 1);
        CardCollection contraptions = CardLists.filter(getCardsIn(ZoneType.Battlefield), CardPredicates.isContraptionOnSprocket(crankCounter));
        List<Card> chosenContraptions = getController().chooseContraptionsToCrank(contraptions);
        for(Card c : chosenContraptions) {
            final Map<AbilityKey, Object> runParams = AbilityKey.mapFromCard(c);
            runParams.put(AbilityKey.Player, this);
            game.getTriggerHandler().runTrigger(TriggerType.CrankContraption, runParams, false);
        }
    }
    public void createContraptionSprockets() {
        if (this.contraptionSprocketEffect != null)
            return;

        contraptionSprocketEffect = new Card(game.nextCardId(), null, game);
        contraptionSprocketEffect.setOwner(this);
        contraptionSprocketEffect.setImageKey("t:sprockets");
        contraptionSprocketEffect.setName("Contraption Sprockets");
        contraptionSprocketEffect.setGamePieceType(GamePieceType.EFFECT);

        String label = Localizer.getInstance().getMessage("lblCrank", this.crankCounter);
        contraptionSprocketEffect.setOverlayText(label);
        contraptionSprocketEffect.setText("At the beginning of your upkeep, if you control a Contraption, move the CRANK! counter to the next sprocket and crank any number of that sprocket's Contraptions.");

        contraptionSprocketEffect.updateStateForView();

        final PlayerZone com = getZone(ZoneType.Command);
        com.add(contraptionSprocketEffect);
        this.updateZoneForView(com);
    }

    public void addDeclaresAttackers(long ts, Player p) {
        this.declaresAttackers.put(ts, p);
    }
    public void removeDeclaresAttackers(long ts) {
        this.declaresAttackers.remove(ts);
    }
    public Player getDeclaresAttackers() {
        Map.Entry<Long, Player> e = declaresAttackers.lastEntry();
        return e == null ? null : e.getValue();
    }

    public void addDeclaresBlockers(long ts, Player p) {
        this.declaresBlockers.put(ts, p);
    }
    public void removeDeclaresBlockers(long ts) {
        this.declaresBlockers.remove(ts);
    }
    public Player getDeclaresBlockers() {
        Map.Entry<Long, Player> e = declaresBlockers.lastEntry();
        return e == null ? null : e.getValue();
    }

    public List<String> getUnlockedDoors() {
        return getCardsIn(ZoneType.Battlefield).stream()
                .filter(Card::isRoom)
                .map(Card::getUnlockedRoomNames)
                .flatMap(Collection::stream)
                .collect(Collectors.toList());
    }

    public int getDevotionMod() {
        return devotionMod;
    }

    public void afterStaticAbilityLayer(StaticAbilityLayer layer) {
        if (layer != StaticAbilityLayer.TEXT) {
            return;
        }

        devotionMod = StaticAbilityDevotion.getDevotionMod(this);
    }

    public void triggerElementalBend(TriggerType type) {
        elementalBendThisTurn.add(type);

        Map<AbilityKey, Object> runParams = AbilityKey.mapFromPlayer(this);

        getGame().getTriggerHandler().runTrigger(TriggerType.ElementalBend, runParams, false);
        getGame().getTriggerHandler().runTrigger(type, runParams, false);
    }

    public boolean hasAllElementBend() {
        return elementalBendThisTurn.size() >= 4;
    }
}
```

## Python
`forge/game/player/Player.py`

```python
# Planes
        l = CardCollection()
        for cp in registeredPlayer.getPlanes():
            l.add(Card.fromPaperCard(cp, self))
        if not l.isEmpty():
            for c in l:
                c.setCollectible(True)
                self.getZone(ZoneType.PlanarDeck).add(c)
            self.getZone(ZoneType.PlanarDeck).shuffle()

        # Commander
        if not registeredPlayer.getCommanders().isEmpty():
            for pc in registeredPlayer.getCommanders():
                cmd = Card.fromPaperCard(pc, self)
                self.initCommanderColor(cmd)
                cmd.setCollectible(True)
                com.add(cmd)
                self.addCommander(cmd)
        elif registeredPlayer.getPlaneswalker() is not None:  # Planeswalker
            cmd = Card.fromPaperCard(registeredPlayer.getPlaneswalker(), self)
            cmd.setCollectible(True)
            cmd.setCommander(True)
            com.add(cmd)
            self.addCommander(cmd)

        # Conspiracies
        for cp in registeredPlayer.getConspiracies():
            conspire = Card.fromPaperCard(cp, self)
            addToCommand = True
            for ki in conspire.getKeywords(Keyword.HIDDEN_AGENDA):
                if not CardFactoryUtil.handleHiddenAgenda(self, conspire, ki):
                    addToCommand = False
            for ki in conspire.getKeywords(Keyword.DOUBLE_AGENDA):
                if not CardFactoryUtil.handleHiddenAgenda(self, conspire, ki):
                    addToCommand = False

            if conspire.getName() == "Backup Plan":
                hand = PlayerZone(ZoneType.ExtraHand, self)
                if self.extraZones is None:
                    self.extraZones = []
                self.extraZones.append(hand)

            if addToCommand:
                com.add(conspire)

        # Attractions
        attractionDeck = self.getZone(ZoneType.AttractionDeck)
        for cp in registeredPlayer.getAttractions():
            c = Card.fromPaperCard(cp, self)
            c.setCollectible(True)
            attractionDeck.add(c)
        if not attractionDeck.isEmpty():
            attractionDeck.shuffle()

        # Contraptions
        contraptionDeck = self.getZone(ZoneType.ContraptionDeck)
        for cp in registeredPlayer.getContraptions():
            c = Card.fromPaperCard(cp, self)
            c.setCollectible(True)
            contraptionDeck.add(c)
        if not contraptionDeck.isEmpty():
            contraptionDeck.shuffle()

        # Adventure Mode items
        adventureItemCards = registeredPlayer.getExtraCardsInCommandZone()
        if adventureItemCards is not None:
            for cp in adventureItemCards:
                c = Card.fromPaperCard(cp, self)
                com.add(c)
                c.setStartsGameInPlay(True)

        for c in self.getCardsIn(ZoneType.Library):
            for inst in c.getKeywords():
                kw = inst.getOriginal()
                if kw.startswith("MayEffectFromOpeningDeck"):
                    split = kw.split(":")
                    effName = split[1]

                    effect = AbilityFactory.getAbility(c.getSVar(effName), c)
                    effect.setActivatingPlayer(self)

                    self.getController().playSpellAbilityNoStack(effect, True)

    def initCommanderColor(self, cmd):
        if cmd.getRules().getAddsWildCardColor():
            p = cmd.getController()
            prompt = Localizer.getInstance().getMessage("lblChooseAColorFor", cmd.getName())
            cmdColorsa = EmptySa(ApiType.ChooseColor, cmd, p)
            chosenColor = p.getController().chooseColor(prompt, cmdColorsa, ColorSet.WUBRG)
            cmd.setChosenColors([MagicColor.toLongString(chosenColor)])
            p.getGame().getAction().notifyOfValue(cmdColorsa, cmd,
                    Localizer.getInstance().getMessage("lblPlayerPickedChosen", p.getName(), MagicColor.toLongString(chosenColor)), p)

    def allCardsUniqueManaSymbols(self):
        for c in self.getCardsIn(ZoneType.Library):
            cardStateNames = {CardStateName.LeftSplit, CardStateName.RightSplit} if c.isSplitCard() else {CardStateName.Original}
            coloredManaSymbols = set()
            genericManaSymbols = set()

            for cardStateName in cardStateNames:
                manaCost = c.getState(cardStateName).getManaCost()
                for manaSymbol in manaCost:
                    if manaSymbol in coloredManaSymbols:
                        return False
                    coloredManaSymbols.add(manaSymbol)
                generic = manaCost.getGenericCost()
                if generic > 0 or manaCost.getCMC() == 0:
                    if generic in genericManaSymbols:
                        return False
                    genericManaSymbols.add(generic)
        return True

    def assignCompanion(self, game, player):
        legalCompanions = []

        uniqueNames = True
        cardNames = set()
        cardTypes = set(CardType.CoreType)
        nonLandInDeck = CardLists.getNotType(self.getCardsIn(ZoneType.Library), "Land")
        for c in nonLandInDeck:
            if uniqueNames:
                if c.getName() in cardNames:
                    uniqueNames = False
                else:
                    cardNames.add(c.getName())

            cardTypes.intersection_update(c.getPaperCard().getRules().getType().getCoreTypes())

        deckSize = self.getCardsIn(ZoneType.Library).size()
        minSize = game.getMatch().getRules().getGameType().getDeckFormat().getMainRange().getMinimum()

        game.getAction().checkStaticAbilities(False)

        for c in self.getCardsIn(ZoneType.Sideboard):
            for inst in c.getKeywords(Keyword.COMPANION):
                if not isinstance(inst, Companion):
                    continue
                kwInstance = inst

                if kwInstance.hasSpecialRestriction():
                    specialRules = kwInstance.getSpecialRules()
                    if specialRules == "UniqueNames":
                        if uniqueNames:
                            legalCompanions.append(c)
                    elif specialRules == "UniqueManaSymbols":
                        if self.allCardsUniqueManaSymbols():
                            legalCompanions.append(c)
                    elif specialRules == "DeckSizePlus20":
                        # +20 deck size to min deck size
                        if deckSize >= minSize + 20:
                            legalCompanions.append(c)
                    elif specialRules == "SharesCardType":
                        # Shares card type
                        if len(cardTypes) != 0:
                            legalCompanions.append(c)
                else:
                    restriction = kwInstance.getDeckRestriction()
                    if self.deckMatchesDeckRestriction(c, restriction):
                        legalCompanions.append(c)

        if len(legalCompanions) == 0:
            return

        view = CardCollection.getView(legalCompanions)

        fakeSa = EmptySa(ApiType.CompanionChoose, legalCompanions[0], self)
        companion = player.chooseSingleEntityForEffect(view, fakeSa, Localizer.getInstance().getMessage("lblChooseACompanion"), True, None)

        commandZone = self.getZone(ZoneType.Command)
        companion = game.getAction().moveTo(ZoneType.Command, companion, None, AbilityKey.newMap())
        commandZone.add(Player.createCompanionEffect(companion))
        self.updateZoneForView(commandZone)

    def deckMatchesDeckRestriction(self, source, restriction):
        for c in self.getCardsIn(ZoneType.Library):
            if not c.isValid(restriction.split(","), self, source, None):
                return False
        return True

    @staticmethod
    def createCompanionEffect(companion):
        name = Lang.getInstance().getPossesive(companion.getDisplayName()) + " Companion Effect"
        eff = DetachedCardEffect(companion, name)

        addToHandAbility = "Mode$ Continuous | EffectZone$ Command | Affected$ Card.YouOwn+EffectSource | AffectedZone$ Command | AddAbility$ MoveToHand"
        moveToHand = "ST$ ChangeZone | Cost$ 3 | Defined$ Self | Origin$ Command | Destination$ Hand | SorcerySpeed$ True | ActivationZone$ Command | SpellDescription$ Companion - Put CARDNAME in to your hand"

        stAb = StaticAbility.create(addToHandAbility, eff, eff.getCurrentState(), True)
        stAb.setSVar("MoveToHand", moveToHand)
        eff.addStaticAbility(stAb)

        return eff

    def createCommanderEffect(self):
        com = self.getZone(ZoneType.Command)
        if self.commanderEffect is not None:
            com.remove(self.commanderEffect)

        eff = DetachedCardEffect(self, "Commander Effect")

        validCommander = "Card.IsCommander+YouOwn"
        if self.game.getRules().hasAppliedVariant(GameType.Oathbreaker):
            # signature spells can only reside on the stack or in the command zone
            effStr = "DB$ ChangeZone | Origin$ Stack | Destination$ Command | Defined$ ReplacedCard"

            moved = ("Event$ Moved | ValidCard$ Spell.IsCommander+YouOwn | Secondary$ True | Destination$ Graveyard,Exile,Hand,Library | "
                     "Description$ If a signature spell would be put into another zone from the stack, put it into the command zone instead.")
            re_ = ReplacementHandler.parseReplacement(moved, eff, True)
            re_.setOverridingAbility(AbilityFactory.getAbility(effStr, eff))
            eff.addReplacementEffect(re_)

            # TODO: Actual recognition for signature spells as their own thing, separate from commanders.
            validCommander = "Permanent.IsCommander+YouOwn"

            # signature spells can only be cast if your oathbreaker is in on the battlefield under your control
            castRestriction = ("Mode$ CantBeCast | ValidCard$ Spell.IsCommander+YouOwn | EffectZone$ Command | IsPresent$ Permanent.IsCommander+YouOwn+YouCtrl | PresentZone$ Battlefield | PresentCompare$ EQ0 | "
                               "Description$ Signature spell can only be cast if your oathbreaker is on the battlefield under your control.")
            eff.addStaticAbility(castRestriction)

        effStr = "DB$ ChangeZone | Origin$ Battlefield,Graveyard,Exile,Library,Hand | Destination$ Command | Defined$ ReplacedCard"

        moved = "Event$ Moved | ValidCard$ " + validCommander + " | Secondary$ True | Optional$ True | OptionalDecider$ You | CommanderMoveReplacement$ True "
        if self.game.getRules().hasAppliedVariant(GameType.TinyLeaders):
            moved += " | Destination$ Graveyard,Exile | Description$ If a commander would be put into its owner's graveyard or exile from anywhere, that player may put it into the command zone instead."
        elif self.game.getRules().hasAppliedVariant(GameType.Oathbreaker):
            moved += " | Destination$ Graveyard,Exile,Hand,Library | Description$ If a commander would be exiled or put into hand, graveyard, or library from anywhere, that player may put it into the command zone instead."
        else:
            # rule 903.9b
            moved += " | Destination$ Hand,Library | Description$ If a commander would be put into its owner's hand or library from anywhere, its owner may put it into the command zone instead."
        re_ = ReplacementHandler.parseReplacement(moved, eff, True)
        re_.setOverridingAbility(AbilityFactory.getAbility(effStr, eff))
        eff.addReplacementEffect(re_)

        mayBePlayedAbility = "Mode$ Continuous | EffectZone$ Command | MayPlay$ True | Affected$ Card.IsCommander+YouOwn | AffectedZone$ Command"
        if self.game.getRules().hasAppliedVariant(GameType.Planeswalker):  # support paying for Planeswalker with any color mana
            mayBePlayedAbility += " | MayPlayIgnoreColor$ True"
        eff.addStaticAbility(mayBePlayedAbility)
        self.commanderEffect = eff
        com.add(eff)

    def createPlanechaseEffects(self, game):
        com = self.getZone(ZoneType.Command)
        name = "Planar Dice"
        eff = Card(game.nextCardId(), game)
        eff.setGameTimestamp(game.getNextTimestamp())
        eff.setName(name)
        eff.setOwner(self)
        eff.setGamePieceType(GamePieceType.EFFECT)
        image = ImageKeys.getTokenKey("planechase")
        eff.setImageKey(image)

        trigger = ("Mode$ PlanarDice | Result$ Planeswalk | TriggerZones$ Command | ValidPlayer$ You | Secondary$ True | "
                   "TriggerDescription$ Whenever you roll the Planeswalker symbol on the planar die, planeswalk.")
        rolledWalk = "DB$ Planeswalk | Cause$ PlanarDie"
        planesWalkTrigger = TriggerHandler.parseTrigger(trigger, eff, True)
        planesWalkTrigger.setOverridingAbility(AbilityFactory.getAbility(rolledWalk, eff))
        eff.addTrigger(planesWalkTrigger)

        specialA = ("ST$ RollPlanarDice | Cost$ X | SorcerySpeed$ True | Activator$ Player | SpecialAction$ True"
                    " | ActivationZone$ Command | SpellDescription$ Roll the planar dice. X is equal to the number of "
                    "times you have previously taken this action this turn. | CostDesc$ {X}: ")
        planarRoll = AbilityFactory.getAbility(specialA, eff)
        planarRoll.setSVar("X", "Count$PlanarDiceSpecialActionThisTurn")
        eff.addSpellAbility(planarRoll)

        eff.updateStateForView()
        com.add(eff)
        self.updateZoneForView(com)

    def createTheRing(self, set):
        if self.theRing is None:
            com = self.getZone(ZoneType.Command)
            self.theRing = Card(self.game.nextCardId(), None, self.game)
            self.theRing.setOwner(self)
            self.theRing.setGamePieceType(GamePieceType.EFFECT)
            self.theRing.setImageKey(StaticData.instance().getOtherImageKey(ImageKeys.THE_RING_IMAGE, set))
            if set is not None:
                self.theRing.setSetCode(set)
            self.theRing.setName("The Ring")
            self.theRing.updateStateForView()
            com.add(self.theRing)
            self.updateZoneForView(com)

    def setRingLevel(self, level):
        if self.getTheRing() is None:
            self.createTheRing(None)
        if level == 1:
            legendary = "Mode$ Continuous | EffectZone$ Command | Affected$ Card.YouCtrl+IsRingbearer | AddType$ Legendary | Description$ Your Ring-bearer is legendary."
            cantBeBlocked = "Mode$ CantBlockBy | EffectZone$ Command | ValidAttacker$ Card.YouCtrl+IsRingbearer | ValidBlockerRelative$ Creature.powerGTX | Description$ Your Ring-bearer can't be blocked by creatures with greater power."
            self.getTheRing().addStaticAbility(legendary)
            st = self.getTheRing().addStaticAbility(cantBeBlocked)
            st.setSVar("X", "Count$CardPower")
        elif level == 2:
            attackTrig = "Mode$ Attacks | ValidCard$ Card.YouCtrl+IsRingbearer | TriggerDescription$ Whenever your ring-bearer attacks, draw a card, then discard a card. | TriggerZones$ Command"
            drawEffect = "DB$ Draw | Defined$ You | NumCards$ 1"
            discardEffect = "DB$ Discard | Defined$ You | NumCards$ 1 | Mode$ TgtChoose"

            attackTrigger = TriggerHandler.parseTrigger(attackTrig, self.getTheRing(), True)

            drawExecute = AbilityFactory.getAbility(drawEffect, self.getTheRing())
            discardExecute = AbilityFactory.getAbility(discardEffect, self.getTheRing())

            drawExecute.setSubAbility(discardExecute)
            attackTrigger.setOverridingAbility(drawExecute)
            self.getTheRing().addTrigger(attackTrigger)
        elif level == 3:
            becomesBlockedTrig = "Mode$ AttackerBlockedByCreature | ValidCard$ Card.YouCtrl+IsRingbearer| ValidBlocker$ Creature | TriggerZones$ Command | TriggerDescription$ Whenever your Ring-bearer becomes blocked a creature, that creature's controller sacrifices it at the end of combat."
            endOfCombatTrig = "DB$ DelayedTrigger | Mode$ Phase | Phase$ EndCombat | RememberObjects$ TriggeredBlockerLKICopy | TriggerDescription$ At end of combat, the controller of the creature that blocked CARDNAME sacrifices that creature."
            sacBlockerEffect = "DB$ SacrificeAll | Defined$ DelayTriggerRememberedLKI"

            becomesBlockedTrigger = TriggerHandler.parseTrigger(becomesBlockedTrig, self.getTheRing(), True)

            endCombatExecute = AbilityFactory.getAbility(endOfCombatTrig, self.getTheRing())
            sacExecute = AbilityFactory.getAbility(sacBlockerEffect, self.getTheRing())

            endCombatExecute.setAdditionalAbility("Execute", sacExecute)
            becomesBlockedTrigger.setOverridingAbility(endCombatExecute)
            self.getTheRing().addTrigger(becomesBlockedTrigger)
        elif level == 4:
            damageTrig = "Mode$ DamageDone | ValidSource$ Card.YouCtrl+IsRingbearer | ValidTarget$ Player | CombatDamage$ True | TriggerZones$ Command | TriggerDescription$ Whenever your Ring-bearer deals combat damage to a player, each opponent loses 3 life."
            loseEffect = "DB$ LoseLife | Defined$ Opponent | LifeAmount$ 3"

            damageTrigger = TriggerHandler.parseTrigger(damageTrig, self.getTheRing(), True)
            loseExecute = AbilityFactory.getAbility(loseEffect, self.getTheRing())

            damageTrigger.setOverridingAbility(loseExecute)
            self.getTheRing().addTrigger(damageTrigger)
        self.getTheRing().updateStateForView()

    def getNumRingTemptedYou(self):
        return self.numRingTemptedYou

    def incrementRingTemptedYou(self):
        self.numRingTemptedYou += 1

    def setNumRingTemptedYou(self, value):
        self.numRingTemptedYou = value

    def resetRingTemptedYou(self):
        self.numRingTemptedYou = 0

    def changeOwnership(self, card):
        # If lost then gained, just clear out of lost.
        # If gained then lost, just clear out of gained.
        oldOwner = card.getOwner()

        if self.equals(oldOwner):
            return
        card.setOwner(self)

        if not card.isCollectible():
            return

        if not card.getGame().getRules().useAnte():
            # Only track permanent ownership changes when ante is used
            return

        if self.lostOwnership.contains(card):
            self.lostOwnership.remove(card)
        else:
            self.gainedOwnership.add(card)

        if oldOwner.gainedOwnership.contains(card):
            oldOwner.gainedOwnership.remove(card)
        else:
            oldOwner.lostOwnership.add(card)

    def destroyPhysicalCard(self, card):
        if not card.isCollectible():
            return

        card.getOwner().lostOwnership.add(card)

    def getLostOwnership(self):
        return self.lostOwnership

    def getGainedOwnership(self):
        return self.gainedOwnership

    def getView(self):
        return self.view

    def getPaidForSA(self):
        return self.paidForStack[0] if self.paidForStack else None

    def pushPaidForSA(self, sa):
        self.paidForStack.appendleft(sa)

    def popPaidForSA(self):
        # it could be empty if spell couldn't be cast
        if self.paidForStack:
            self.paidForStack.popleft()

    def clearPaidForSA(self):
        self.paidForStack.clear()

    def isStartingPlayer(self):
        return self.equals(self.game.getStartingPlayer())

    def isMonarch(self):
        return self.equals(self.game.getMonarch())

    def getMonarchSet(self):
        return self.monarchEffect.getSetCode() if self.monarchEffect is None else None

    def createMonarchEffect(self, set):
        com = self.getZone(ZoneType.Command)
        if self.monarchEffect is None:
            self.monarchEffect = Card(self.game.nextCardId(), None, self.game)
            self.monarchEffect.setOwner(self)
            self.monarchEffect.setGamePieceType(GamePieceType.EFFECT)
            self.monarchEffect.setImageKey(StaticData.instance().getOtherImageKey(ImageKeys.MONARCH_IMAGE, set))
            self.monarchEffect.setSetCode(set)
            self.monarchEffect.setName("The Monarch")

            drawTrig = ("Mode$ Phase | Phase$ End of Turn | TriggerZones$ Command | "
                        "ValidPlayer$ You |  TriggerDescription$ At the beginning of your end step, draw a card.")
            drawEff = "DB$ Draw | Defined$ You"

            drawTrigger = TriggerHandler.parseTrigger(drawTrig, self.monarchEffect, True)

            drawTrigger.setOverridingAbility(AbilityFactory.getAbility(drawEff, self.monarchEffect))
            self.monarchEffect.addTrigger(drawTrigger)

            damageTrig = ("Mode$ DamageDone | ValidSource$ Creature | ValidTarget$ You | CombatDamage$ True | TriggerZones$ Command |"
                          " TriggerDescription$ Whenever a creature deals combat damage to you, its controller becomes the monarch.")
            damageEff = "DB$ BecomeMonarch | Defined$ TriggeredSourceController"

            damageTrigger = TriggerHandler.parseTrigger(damageTrig, self.monarchEffect, True)

            damageTrigger.setOverridingAbility(AbilityFactory.getAbility(damageEff, self.monarchEffect))
            self.monarchEffect.addTrigger(damageTrigger)
            self.monarchEffect.updateStateForView()
        com.add(self.monarchEffect)

        self.updateZoneForView(com)

    def removeMonarchEffect(self):
        com = self.getZone(ZoneType.Command)
        if self.monarchEffect is not None:
            com.remove(self.monarchEffect)
            self.updateZoneForView(com)

    def canBecomeMonarch(self):
        return not StaticAbilityCantBecomeMonarch.anyCantBecomeMonarch(self)

    def getInitiativeSet(self):
        return self.initiativeEffect.getSetCode() if self.initiativeEffect is not None else None

    def createInitiativeEffect(self, set):
        com = self.getZone(ZoneType.Command)
        if self.initiativeEffect is None:
            self.initiativeEffect = Card(self.game.nextCardId(), None, self.game)
            self.initiativeEffect.setOwner(self)
            self.initiativeEffect.setGamePieceType(GamePieceType.EFFECT)
            self.initiativeEffect.setImageKey(StaticData.instance().getOtherImageKey(ImageKeys.INITIATIVE_IMAGE, set))
            self.initiativeEffect.setSetCode(set)
            self.initiativeEffect.setName("The Initiative")

            # Set up damage trigger
            damageTrig = ("Mode$ DamageDoneOnceByController | ValidSource$ Player | ValidTarget$ You | "
                          "CombatDamage$ True | TriggerZones$ Command | TriggerDescription$ Whenever one or more "
                          "creatures a player controls deal combat damage to you, that player takes the initiative.")
            damageEff = "DB$ TakeInitiative | Defined$ TriggeredSource"

            damageTrigger = TriggerHandler.parseTrigger(damageTrig, self.initiativeEffect, True)

            damageTrigger.setOverridingAbility(AbilityFactory.getAbility(damageEff, self.initiativeEffect))
            self.initiativeEffect.addTrigger(damageTrigger)

            # Set up triggers to venture into Undercity
            ventureTakeTrig = ("Mode$ TakesInitiative | ValidPlayer$ You | TriggerZones$ Command | "
                               "TriggerDescription$ Whenever you take the initiative and at the beginning of your upkeep, "
                               "venture into Undercity. (If you're in a dungeon, advance to the next room. If not, enter "
                               "Undercity. You can take the initiative even if you already have it.)")

            ventureUpkpTrig = ("Mode$ Phase | Phase$ Upkeep | TriggerZones$ Command | ValidPlayer$ You "
                               "| TriggerDescription$ Whenever you take the initiative and at the beginning of your upkeep, "
                               "venture into Undercity. (If you're in a dungeon, advance to the next room. If not, enter "
                               "Undercity. You can take the initiative even if you already have it.) | Secondary$ True")

            ventureEff = "DB$ Venture | Dungeon$ Undercity"

            ventureUTrigger = TriggerHandler.parseTrigger(ventureUpkpTrig, self.initiativeEffect, True)
            ventureUTrigger.setOverridingAbility(AbilityFactory.getAbility(ventureEff, self.initiativeEffect))
            self.initiativeEffect.addTrigger(ventureUTrigger)

            ventureTTrigger = TriggerHandler.parseTrigger(ventureTakeTrig, self.initiativeEffect, True)
            ventureTTrigger.setOverridingAbility(AbilityFactory.getAbility(ventureEff, self.initiativeEffect))
            self.initiativeEffect.addTrigger(ventureTTrigger)

            self.initiativeEffect.updateStateForView()

        triggerHandler = self.game.getTriggerHandler()
        com.add(self.initiativeEffect)
        triggerHandler.clearActiveTriggers(self.initiativeEffect, None)
        triggerHandler.registerActiveTrigger(self.initiativeEffect, False)

        self.updateZoneForView(com)

    def hasInitiative(self):
        return self.equals(self.game.getHasInitiative())

    def removeInitiativeEffect(self):
        com = self.getZone(ZoneType.Command)
        if self.initiativeEffect is not None:
            com.remove(self.initiativeEffect)
            self.updateZoneForView(com)

    def getRadiationEffect(self):
        return self.radiationEffect

    def createRadiationEffect(self, setCode):
        com = self.getZone(ZoneType.Command)
        if self.radiationEffect is None:
            self.radiationEffect = Card(self.game.nextCardId(), None, self.game)
            self.radiationEffect.setOwner(self)
            self.radiationEffect.setGamePieceType(GamePieceType.EFFECT)
            self.radiationEffect.setImageKey(StaticData.instance().getOtherImageKey(ImageKeys.RADIATION_IMAGE, setCode))
            self.radiationEffect.setName("Radiation")
            if setCode is not None:
                self.radiationEffect.setSetCode(setCode)

            trigStr = ("Mode$ Phase | Phase$ Main1 | ValidPlayer$ You | TriggerZones$ Command | TriggerDescription$ "
                       "At the beginning of your precombat main phase, if you have any rad counters, mill that many cards. For each nonland card milled this way, you lose 1 life and a rad counter.")

            tr = TriggerHandler.parseTrigger(trigStr, self.radiationEffect, True)
            sa = AbilityFactory.getAbility("DB$ InternalRadiation", self.radiationEffect)
            tr.setOverridingAbility(sa)

            self.radiationEffect.addTrigger(tr)
            self.radiationEffect.updateStateForView()
        com.add(self.radiationEffect)
        self.updateZoneForView(com)

    def removeRadiationEffect(self):
        com = self.getZone(ZoneType.Command)
        if self.radiationEffect is not None:
            com.remove(self.radiationEffect)
            self.radiationEffect = None
            self.updateZoneForView(com)

    def hasRadiationEffect(self):
        return self.radiationEffect is not None

    def getKeywordCard(self):
        if self.keywordEffect is not None:
            return self.keywordEffect

        com = self.getZone(ZoneType.Command)

        self.keywordEffect = Card(self.game.nextCardId(), None, self.game)
        self.keywordEffect.setGamePieceType(GamePieceType.EFFECT)
        self.keywordEffect.setOwner(self)
        self.keywordEffect.setName("Keyword Effects")
        self.keywordEffect.setImageKey(ImageKeys.HIDDEN_CARD)

        self.keywordEffect.updateStateForView()

        com.add(self.keywordEffect)

        self.updateZoneForView(com)
        return self.keywordEffect

    def updateKeywordCardAbilityText(self):
        if self.getKeywordCard() is None:
            return
        com = self.getZone(ZoneType.Command)
        self.keywordEffect.setText("")
        headerAdded = False
        kw = ""
        for k in self.keywords:
            if not headerAdded:
                headerAdded = True
                kw += self.getName() + " has: \n"
            kw += str(k) + "\n"
        if kw != "":
            self.keywordEffect.setText(self.trimKeywords(kw))
        self.keywordEffect.updateAbilityTextForView()
        self.updateZoneForView(com)

    def trimKeywords(self, keywordTexts):
        if "Protection:" in keywordTexts:
            lines = keywordTexts.split("\n")
            for line in lines:
                if line.startswith("Protection:"):
                    parts = line.split(":")
                    if len(parts) > 2:
                        keywordTexts = TextUtil.fastReplace(keywordTexts, line, parts[2])
        keywordTexts = TextUtil.fastReplace(keywordTexts, ":Card.named", " from ")
        keywordTexts = TextUtil.fastReplace(keywordTexts, ":Card.Black:", " from ")
        keywordTexts = TextUtil.fastReplace(keywordTexts, ":Card.Blue:", " from ")
        keywordTexts = TextUtil.fastReplace(keywordTexts, ":Card.Red:", " from ")
        keywordTexts = TextUtil.fastReplace(keywordTexts, ":Card.Green:", " from ")
        keywordTexts = TextUtil.fastReplace(keywordTexts, ":Card.White:", " from ")
        keywordTexts = TextUtil.fastReplace(keywordTexts, ":Card.MonoColor:", " from ")
        keywordTexts = TextUtil.fastReplace(keywordTexts, ":Card.MultiColor:", " from ")
        keywordTexts = TextUtil.fastReplace(keywordTexts, ":Card.Colorless:", " from ")
        return keywordTexts

    def checkKeywordCard(self):
        if self.keywordEffect is None:
            return
        com = self.getZone(ZoneType.Command)
        if self.keywordEffect.getAbilityText().isEmpty():
            com.remove(self.keywordEffect)
            self.updateZoneForView(com)
            self.keywordEffect = None

    def hasBlessing(self):
        return self.blessingEffect is not None

    def setBlessing(self, bless, setCode):
        # no need to to change
        if (self.blessingEffect is not None) == bless:
            return

        com = self.getZone(ZoneType.Command)

        if bless:
            self.blessingEffect = Card(self.game.nextCardId(), None, self.game)
            self.blessingEffect.setOwner(self)
            self.blessingEffect.setImageKey(StaticData.instance().getOtherImageKey(ImageKeys.BLESSING_IMAGE, setCode))
            self.blessingEffect.setName("City's Blessing")
            self.blessingEffect.setGamePieceType(GamePieceType.EFFECT)
            if setCode is not None:
                self.blessingEffect.setSetCode(setCode)

            self.blessingEffect.updateStateForView()

            com.add(self.blessingEffect)

            # 702.131d. After a player gets the city's blessing, continuous effects are reapplied
            self.game.getAction().checkStaticAbilities()
        else:
            com.remove(self.blessingEffect)
            self.blessingEffect = None

        self.updateZoneForView(com)

    def sameTeam(self, other):
        if self.equals(other):
            return True
        if self.teamNumber < 0 or other.getTeam() < 0:
            return False
        return self.teamNumber == other.getTeam()

    def isCursed(self):
        return CardLists.count(self.getAttachedCards(), Card.isCurse) > 0

    def canDiscardBy(self, sa, effect):
        if sa is None:
            return True

        return not StaticAbilityCantDiscard.cantDiscard(self, sa, effect)

    def canSearchLibraryWith(self, sa, targetPlayer):
        if sa is None:
            return True

        if self.hasKeyword("CantSearchLibrary"):
            return False
        return (targetPlayer is None or not targetPlayer.equals(sa.getActivatingPlayer())
                or not self.hasKeyword("Spells and abilities you control can't cause you to search your library."))

    def addAdditionalVote(self, timestamp, value):
        self.additionalVotes[timestamp] = value
        self.getView().updateAdditionalVote(self)
        self.getGame().fireEvent(GameEventPlayerStatsChanged(self, False))

    def removeAdditionalVote(self, timestamp):
        if self.additionalVotes.pop(timestamp, None) is not None:
            self.getView().updateAdditionalVote(self)
            self.getGame().fireEvent(GameEventPlayerStatsChanged(self, False))

    def getAdditionalVotesAmount(self):
        value = 0
        for i in self.additionalVotes.values():
            value += i
        return value

    def addAdditionalOptionalVote(self, timestamp, value):
        self.additionalOptionalVotes[timestamp] = value
        self.getView().updateOptionalAdditionalVote(self)
        self.getGame().fireEvent(GameEventPlayerStatsChanged(self, False))

    def removeAdditionalOptionalVote(self, timestamp):
        if self.additionalOptionalVotes.pop(timestamp, None) is not None:
            self.getView().updateOptionalAdditionalVote(self)
            self.getGame().fireEvent(GameEventPlayerStatsChanged(self, False))

    def getAdditionalOptionalVotesAmount(self):
        value = 0
        for i in self.additionalOptionalVotes.values():
            value += i
        return value

    def addControlVote(self, timestamp):
        if timestamp not in self.controlVotes:
            self.controlVotes.add(timestamp)
            self.updateControlVote()
            return True
        return False

    def removeControlVote(self, timestamp):
        if timestamp in self.controlVotes:
            self.controlVotes.remove(timestamp)
            self.updateControlVote()
            return True
        return False

    def updateControlVote(self):
        # need to update all players because it can't know
        control = self.getGame().getControlVote()
        for pl in self.getGame().getPlayers():
            pl.getView().updateControlVote(pl.equals(control))
            self.getGame().fireEvent(GameEventPlayerStatsChanged(pl, False))

    def getControlVote(self):
        return self.controlVotes

    def setControlVote(self, value):
        self.controlVotes.clear()
        self.controlVotes.update(value)
        self.updateControlVote()

    def getHighestControlVote(self):
        if len(self.controlVotes) == 0:
            return None
        return max(self.controlVotes)

    def addAdditionalVillainousChoices(self, timestamp, value):
        self.additionalVillainousChoices[timestamp] = value
        self.getView().updateAdditionalVillainousChoices(self)
        self.getGame().fireEvent(GameEventPlayerStatsChanged(self, False))

    def removeAdditionalVillainousChoices(self, timestamp):
        if self.additionalVillainousChoices.pop(timestamp, None) is not None:
            self.getView().updateAdditionalVillainousChoices(self)
            self.getGame().fireEvent(GameEventPlayerStatsChanged(self, False))

    def getAdditionalVillainousChoices(self):
        value = 0
        for i in self.additionalVillainousChoices.values():
            value += i
        return value

    def addCycled(self, sp):
        cycleParams = AbilityKey.mapFromCard(CardCopyService.getLKICopy(self.game.getCardState(sp.getHostCard())))
        cycleParams[AbilityKey.Cause] = sp
        cycleParams[AbilityKey.Player] = self
        cycleParams[AbilityKey.FirstTime] = CardUtil.getThisTurnActivated("Activated.Cycling+YouCtrl", sp.getHostCard(), sp, self).size() == 1
        self.game.getTriggerHandler().runTrigger(TriggerType.Cycled, cycleParams, False)

    def hasUrzaLands(self):
        landsControlled = self.getCardsIn(ZoneType.Battlefield)
        return (landsControlled.anyMatch(CardPredicates.isType("Urza's").and_(CardPredicates.isType("Mine")))
                and landsControlled.anyMatch(CardPredicates.isType("Urza's").and_(CardPredicates.isType("Power-Plant")))
                and landsControlled.anyMatch(CardPredicates.isType("Urza's").and_(CardPredicates.isType("Tower"))))

    def revealFaceDownCards(self):
        revealZones = [[ZoneType.Battlefield, ZoneType.Merged], [ZoneType.Exile]]
        otherPlayers = PlayerCollection(self.game.getRegisteredPlayers())
        otherPlayers.remove(self)

        for z in revealZones:
            revealCards = CardCollection()
            for c in self.game.getCardsInOwnedBy(z, self):
                if not c.isRealFaceDown():
                    continue

                lki = CardCopyService.getLKICopy(c)
                lki.forceTurnFaceUp()
                lki.setZone(c.getZone())
                revealCards.add(lki)
            self.game.getAction().revealTo(revealCards, otherPlayers, Localizer.getInstance().getMessage("lblRevealFaceDownCards"), True)

    def learnLesson(self, sa, params):
        if self.hasLost():
            return

        repParams = AbilityKey.mapFromAffected(self)
        repParams[AbilityKey.Cause] = sa
        repParams.update(params)
        if self.game.getReplacementHandler().run(ReplacementType.Learn, repParams) != ReplacementResult.NotReplaced:
            return

        list_ = CardCollection()
        if not self.isControlled():
            list_.addAll(CardLists.getType(self.getZone(ZoneType.Sideboard), "Lesson"))
        list_.addAll(self.getZone(ZoneType.Hand))
        if list_.isEmpty():
            return

        c = self.getController().chooseSingleCardForZoneChange(ZoneType.Hand, [ZoneType.Sideboard, ZoneType.Hand],
                sa, list_, None, Localizer.getInstance().getMessage("lblLearnALesson"), True, self)
        if c is None:
            return
        if c.isInZone(ZoneType.Sideboard):  # Sideboard Lesson to Hand
            self.game.getAction().reveal(CardCollection(c), c.getOwner(), True)
            self.game.getAction().moveTo(ZoneType.Hand, c, sa, params)
        elif c.isInZone(ZoneType.Hand):  # Discard and Draw
            discardedBefore = list(self.getDiscardedThisTurn())
            moved = self.discard(c, sa, True, params)
            if moved is not None:
                # Change this if something would make multiple player learn at the same time

                # Discard Trigger outside Effect
                runParams = AbilityKey.mapFromPlayer(self)
                runParams[AbilityKey.Cards] = CardCollection(moved)
                runParams[AbilityKey.Cause] = sa
                runParams[AbilityKey.DiscardedBefore] = discardedBefore
                if params is not None:
                    runParams.update(params)
                self.getGame().getTriggerHandler().runTrigger(TriggerType.DiscardedAll, runParams, False)

                self.drawCards(1, sa, params)

    def commitCrime(self):
        # boolean firstTime = this.commitedCrimeThisTurn == 0;
        self.committedCrimeThisTurn += 1

        runParams = AbilityKey.mapFromPlayer(self)
        self.game.getTriggerHandler().runTrigger(TriggerType.CommitCrime, runParams, False)

    def getCommittedCrimeThisTurn(self):
        return self.committedCrimeThisTurn

    def setCommitedCrimeThisTurn(self, v):
        self.committedCrimeThisTurn = v

    def getDiceRollsThisTurn(self):
        return self.diceRollsThisTurn

    def addDieRollThisTurn(self, rolls):
        self.diceRollsThisTurn.extend(rolls)

    def getExpentThisTurn(self):
        return self.expentThisTurn

    def setExpentThisTurn(self, v):
        self.expentThisTurn = v

    def addExpentThisTurn(self, v, sp):
        if v <= 0:
            return
        startingMana = self.expentThisTurn
        self.expentThisTurn += v
        totalMana = self.expentThisTurn
        for i in range(startingMana + 1, totalMana + 1):
            expendParams = AbilityKey.mapFromPlayer(self)
            expendParams[AbilityKey.SpellAbility] = sp
            expendParams[AbilityKey.Amount] = i
            self.game.getTriggerHandler().runTrigger(TriggerType.ManaExpend, expendParams, True)

    def visitAttractions(self, light):
        attractions = CardLists.filter(self.getCardsIn(ZoneType.Battlefield), CardPredicates.isAttractionWithLight(light))
        for c in attractions:
            if not c.wasVisitedThisTurn():
                self.attractionsVisitedThisTurn += 1
            c.visitAttraction(self)

    def rollToVisitAttractions(self):
        self.visitAttractions(RollDiceEffect.rollDiceForPlayerToVisitAttractions(self))

    def getAttractionsVisitedThisTurn(self):
        return self.attractionsVisitedThisTurn

    def getCrankCounter(self):
        return self.crankCounter

    def setCrankCounter(self, counters):
        self.crankCounter = counters
        if self.contraptionSprocketEffect is not None:
            label = Localizer.getInstance().getMessage("lblCrank", self.crankCounter)
            self.contraptionSprocketEffect.setOverlayText(label)
        elif self.getCardsIn(ZoneType.Battlefield).anyMatch(Card.isContraption):
            self.createContraptionSprockets()

    def advanceCrankCounter(self):
        self.setCrankCounter(self.crankCounter % 3 + 1)
        contraptions = CardLists.filter(self.getCardsIn(ZoneType.Battlefield), CardPredicates.isContraptionOnSprocket(self.crankCounter))
        chosenContraptions = self.getController().chooseContraptionsToCrank(contraptions)
        for c in chosenContraptions:
            runParams = AbilityKey.mapFromCard(c)
            runParams[AbilityKey.Player] = self
            self.game.getTriggerHandler().runTrigger(TriggerType.CrankContraption, runParams, False)

    def createContraptionSprockets(self):
        if self.contraptionSprocketEffect is not None:
            return

        self.contraptionSprocketEffect = Card(self.game.nextCardId(), None, self.game)
        self.contraptionSprocketEffect.setOwner(self)
        self.contraptionSprocketEffect.setImageKey("t:sprockets")
        self.contraptionSprocketEffect.setName("Contraption Sprockets")
        self.contraptionSprocketEffect.setGamePieceType(GamePieceType.EFFECT)

        label = Localizer.getInstance().getMessage("lblCrank", self.crankCounter)
        self.contraptionSprocketEffect.setOverlayText(label)
        self.contraptionSprocketEffect.setText("At the beginning of your upkeep, if you control a Contraption, move the CRANK! counter to the next sprocket and crank any number of that sprocket's Contraptions.")

        self.contraptionSprocketEffect.updateStateForView()

        com = self.getZone(ZoneType.Command)
        com.add(self.contraptionSprocketEffect)
        self.updateZoneForView(com)

    def addDeclaresAttackers(self, ts, p):
        self.declaresAttackers[ts] = p

    def removeDeclaresAttackers(self, ts):
        self.declaresAttackers.pop(ts, None)

    def getDeclaresAttackers(self):
        if not self.declaresAttackers:
            return None
        return self.declaresAttackers[max(self.declaresAttackers)]

    def addDeclaresBlockers(self, ts, p):
        self.declaresBlockers[ts] = p

    def removeDeclaresBlockers(self, ts):
        self.declaresBlockers.pop(ts, None)

    def getDeclaresBlockers(self):
        if not self.declaresBlockers:
            return None
        return self.declaresBlockers[max(self.declaresBlockers)]

    def getUnlockedDoors(self):
        result = []
        for c in self.getCardsIn(ZoneType.Battlefield):
            if c.isRoom():
                result.extend(c.getUnlockedRoomNames())
        return result

    def getDevotionMod(self):
        return self.devotionMod

    def afterStaticAbilityLayer(self, layer):
        if layer != StaticAbilityLayer.TEXT:
            return

        self.devotionMod = StaticAbilityDevotion.getDevotionMod(self)

    def triggerElementalBend(self, type):
        self.elementalBendThisTurn.add(type)

        runParams = AbilityKey.mapFromPlayer(self)

        self.getGame().getTriggerHandler().runTrigger(TriggerType.ElementalBend, runParams, False)
        self.getGame().getTriggerHandler().runTrigger(type, runParams, False)

    def hasAllElementBend(self):
        return len(self.elementalBendThisTurn) >= 4
```
