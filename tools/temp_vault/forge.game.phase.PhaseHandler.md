---
aliases:
  - PhaseHandler
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/phase
fqn: forge.game.phase.PhaseHandler
package: forge.game.phase
module: forge-game
kind: Class
---

# PhaseHandler

**Package:** `forge.game.phase` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class PhaseHandler {
        -long serialVersionUID
        -StopWatch sw
        -PhaseType phase
        -int turn
        -Stack~ExtraTurn~ extraTurns
        -Map~PhaseType,Stack~ extraPhases
        -int nUpkeepsThisTurn
        -int nUpkeepsThisGame
        -int nCombatsThisTurn
        -int nMainsThisTurn
        -int nEndOfTurnsThisTurn
        -int planarDiceSpecialActionThisTurn
        -Player playerTurn
        -Player playerPreviousTurn
        -Player pPlayerPriority
        -Player pFirstPriority
        -Combat combat
        -boolean skipDamageSteps
        -boolean bRepeatCleanup
        -boolean givePriorityToPlayer
        -Game game
        -boolean DEBUG_PHASES
        +getPhase() PhaseType
        -setPhase(PhaseType phase0) void
        +getTurn() int
        +isPlayerTurn(Player player) boolean
        +getPlayerTurn() Player
        +setPlayerTurn(Player playerTurn0) void
        +getPreviousPlayerTurn() Player
        +getPriorityPlayer() Player
        +setPriority(Player p) void
        +resetPriority() void
        +inCombat() boolean
        +getCombat() Combat
        -advanceToNextPhase() void
        -isSkippingPhase(PhaseType phase) boolean
        -onPhaseBegin() void
        -onPhaseEnd() void
        -declareAttackersTurnBasedAction() void
        -declareBlockersTurnBasedAction() void
        +restart() void
        -handleNextTurn() Player
        -getNextActivePlayer() Player
        +is(PhaseType phase0, Player player0) boolean
        +is(PhaseType phase0) boolean
        +getNextTurn() Player
        +addExtraTurn(Player player) ExtraTurn
        +addExtraPhase(PhaseType afterPhase, List~PhaseType~ extraPhaseList, PhaseType nextPhase) ExtraPhase
        +hasExtraPhaseAfter(PhaseType afterPhase, PhaseType extraPhase) boolean
        +isFirstCombat() boolean
        +getNumCombat() int
        +getNumUpkeep() int
        +isFirstUpkeep() boolean
        +isFirstUpkeepThisGame() boolean
        +getNumMain() int
        +beforeFirstPostCombatMainEnd() boolean
        +skippedDeclareBlockers() boolean
        +getNumEndOfTurn() int
        +setupFirstTurn(Player goesFirst, Runnable startGameHook) void
        +startFirstTurn(Player goesFirst) void
        +startFirstTurn(Player goesFirst, Runnable startGameHook) void
        +mainGameLoop() void
        +mainLoopStep() void
        -checkStateBasedEffects() boolean
        +devAdvanceToPhase(PhaseType targetPhase) boolean
        +devAdvanceToPhase(PhaseType targetPhase, Runnable resolver) boolean
        +devModeSet(PhaseType phase0, Player player0, boolean endCombat, int cturn) void
        +devModeSet(PhaseType phase0, Player player0) void
        +devModeSet(PhaseType phase0, Player player0, int cturn) void
        +devModeSet(PhaseType phase0, Player player0, boolean endCombat) void
        +endCombatPhaseByEffect() void
        +endTurnByEffect() void
        +getPlanarDiceSpecialActionThisTurn() int
        +incPlanarDiceSpecialActionThisTurn() void
        +debugPrintState(boolean hasPriority) String
        +onStackResolved() void
        +endCombat() void
        +setCombat(Combat combat) void
        +getExtraTurnForPlayer(Player p) int
        -handleMultiplayerEffects() void
        +PhaseHandler(Game game0)
    }
    PhaseHandler ..|> Serializable : implements
    PhaseHandler ..|> IHasForgeLog : implements
    PhaseHandler ..> AbilityKey : uses
    PhaseHandler ..> Card : uses
    PhaseHandler ..> CardCollection : uses
    PhaseHandler ..> CardZoneTable : uses
    PhaseHandler ..> Combat : uses
    PhaseHandler ..> CostEnlist : uses
    PhaseHandler ..> CostExert : uses
    PhaseHandler ..> ExtraPhase : uses
    PhaseHandler ..> ExtraTurn : uses
    PhaseHandler ..> Game : uses
    PhaseHandler ..> GameEntity : uses
    PhaseHandler ..> GameEntityCounterTable : uses
    PhaseHandler ..> GameEventAttackersDeclared : uses
    PhaseHandler ..> GameEventBlockersDeclared : uses
    PhaseHandler ..> GameEventCardStatsChanged : uses
    PhaseHandler ..> GameEventCombatChanged : uses
    PhaseHandler ..> GameEventCombatEnded : uses
    PhaseHandler ..> GameEventGameRestarted : uses
    PhaseHandler ..> GameEventPlayerPriority : uses
    PhaseHandler ..> GameEventPlayerStatsChanged : uses
    PhaseHandler ..> GameEventTurnBegan : uses
    PhaseHandler ..> GameEventTurnEnded : uses
    PhaseHandler ..> GameEventTurnPhase : uses
    PhaseHandler ..> PhaseType : uses
    PhaseHandler ..> Player : uses
    PhaseHandler ..> ReplacementResult : uses
    PhaseHandler ..> SpellAbility : uses
    PhaseHandler ..> Trigger : uses
    PhaseHandler ..> Zone : uses
```

## Relationships
**Implements:**
- [[forge.util.IHasForgeLog|IHasForgeLog]]
**Uses:**
- [[forge.game.Game|Game]]
- [[forge.game.GameEntity|GameEntity]]
- [[forge.game.GameEntityCounterTable|GameEntityCounterTable]]
- [[forge.game.ability.AbilityKey|AbilityKey]]
- [[forge.game.card.Card|Card]]
- [[forge.game.card.CardCollection|CardCollection]]
- [[forge.game.card.CardZoneTable|CardZoneTable]]
- [[forge.game.combat.Combat|Combat]]
- [[forge.game.cost.CostEnlist|CostEnlist]]
- [[forge.game.cost.CostExert|CostExert]]
- [[forge.game.event.GameEventAttackersDeclared|GameEventAttackersDeclared]]
- [[forge.game.event.GameEventBlockersDeclared|GameEventBlockersDeclared]]
- [[forge.game.event.GameEventCardStatsChanged|GameEventCardStatsChanged]]
- [[forge.game.event.GameEventCombatChanged|GameEventCombatChanged]]
- [[forge.game.event.GameEventCombatEnded|GameEventCombatEnded]]
- [[forge.game.event.GameEventGameRestarted|GameEventGameRestarted]]
- [[forge.game.event.GameEventPlayerPriority|GameEventPlayerPriority]]
- [[forge.game.event.GameEventPlayerStatsChanged|GameEventPlayerStatsChanged]]
- [[forge.game.event.GameEventTurnBegan|GameEventTurnBegan]]
- [[forge.game.event.GameEventTurnEnded|GameEventTurnEnded]]
- [[forge.game.event.GameEventTurnPhase|GameEventTurnPhase]]
- [[forge.game.phase.ExtraPhase|ExtraPhase]]
- [[forge.game.phase.ExtraTurn|ExtraTurn]]
- [[forge.game.phase.PhaseType|PhaseType]]
- [[forge.game.player.Player|Player]]
- [[forge.game.replacement.ReplacementResult|ReplacementResult]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]
- [[forge.game.trigger.Trigger|Trigger]]
- [[forge.game.zone.Zone|Zone]]

## Design Description

PhaseHandler is the central turn-and-phase engine of Forge's game model, owning the canonical state of the active turn, current `PhaseType`, priority assignment, and the active `Combat`. As a serializable `IHasForgeLog`, it is held by `Game` and drives the main game loop (`mainGameLoop`/`mainLoopStep`), advancing through phases, running turn-based actions (untap, draw, combat declaration and damage, cleanup), and offering priority while firing `GameEvent*` notifications and dispatching triggers and replacement effects through the game's handlers.

Its design emphasizes faithful MTG rules enforcement: it delegates per-phase work to specialized executors and to `Player`/`Combat` collaborators, and models rules-mandated irregularities through explicit data structuresâ€”a LIFO `Stack` of `ExtraTurn`s and a per-phase map of `ExtraPhase`sâ€”so added turns and inserted phases nest correctly. Counters, skip flags, and dev/test setters (`devModeSet`, `devAdvanceToPhase`) keep the loop deterministic while supporting multiplayer leave-game effects and forced phase/turn termination by effect.

## Source
`forge-game/src/main/java/forge/game/phase/PhaseHandler.java`

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
package forge.game.phase;

import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Multimap;
import com.google.common.collect.MultimapBuilder;

import forge.game.*;
import forge.game.ability.AbilityKey;
import forge.game.ability.effects.AddTurnEffect;
import forge.game.ability.effects.SkipPhaseEffect;
import forge.game.card.*;
import forge.game.combat.Combat;
import forge.game.combat.CombatUtil;
import forge.game.cost.CostEnlist;
import forge.game.cost.CostExert;
import forge.game.event.*;
import forge.game.player.Player;
import forge.game.player.PlayerView;
import forge.game.replacement.ReplacementResult;
import forge.game.replacement.ReplacementType;

import forge.game.spellability.SpellAbility;
import forge.game.staticability.StaticAbilityNoCleanupDamage;
import forge.game.trigger.Trigger;
import forge.game.trigger.TriggerType;
import forge.game.zone.Zone;
import forge.game.zone.ZoneType;
import forge.util.IHasForgeLog;
import forge.util.TextUtil;

import org.apache.commons.lang3.time.StopWatch;

import java.util.*;


/**
 * <p>
 * Phase class.
 * </p>
 *
 * @author Forge
 * @version $Id: PhaseHandler.java 13001 2012-01-08 12:25:25Z Sloth $
 */
public class PhaseHandler implements java.io.Serializable, IHasForgeLog {
    private static final long serialVersionUID = 5207222278370963197L;

    // used for debugging phase timing
    private final StopWatch sw = new StopWatch();

    // Start turn at 0, since we start even before first untap
    private PhaseType phase = null;
    private int turn = 0;

    private final transient Stack<ExtraTurn> extraTurns = new Stack<>();
    private final transient Map<PhaseType, Stack<ExtraPhase>> extraPhases = Maps.newEnumMap(PhaseType.class);

    private int nUpkeepsThisTurn = 0;
    private int nUpkeepsThisGame = 0;
    private int nCombatsThisTurn = 0;
    private int nMainsThisTurn = 0;
    private int nEndOfTurnsThisTurn = 0;
    private int planarDiceSpecialActionThisTurn = 0;

    private transient Player playerTurn = null;
    private transient Player playerPreviousTurn = null;

    // priority player

    private transient Player pPlayerPriority = null;
    private transient Player pFirstPriority = null;
    private transient Combat combat = null;
    private boolean skipDamageSteps = false;
    private boolean bRepeatCleanup = false;

    /** The need to next phase. */
    private boolean givePriorityToPlayer = false;

    private final transient Game game;


    public PhaseHandler(final Game game0) {
        game = game0;
    }

    public final PhaseType getPhase() {
        return phase;
    }
    private void setPhase(final PhaseType phase0) {
        if (phase == phase0) { return; }
        phase = phase0;
        game.updatePhaseForView();
    }

    public final int getTurn() {
        return turn;
    }

    public final boolean isPlayerTurn(final Player player) {
        return player.equals(playerTurn);
    }

    public final Player getPlayerTurn() {
        return playerTurn;
    }
    public final void setPlayerTurn(final Player playerTurn0) {
        if (playerTurn == playerTurn0) { return; }
        playerTurn = playerTurn0;
        game.updatePlayerTurnForView();
        resetPriority();
    }

    public final Player getPreviousPlayerTurn() {
        return playerPreviousTurn;
    }

    public final Player getPriorityPlayer() {
        return pPlayerPriority;
    }
    public final void setPriority(final Player p) {
        pFirstPriority = p;
        pPlayerPriority = p;
    }
    public final void resetPriority() {
        setPriority(playerTurn);
    }

    public final boolean inCombat() { return combat != null; }
    public final Combat getCombat() { return combat; }

    private void advanceToNextPhase() {
        PhaseType oldPhase = phase;
        boolean isTopsy = playerTurn.isPhasesReversed();
        boolean turnEnded = false;

        game.getStack().clearUndoStack(); //can't undo action from previous phase

        if (bRepeatCleanup) { // for when Cleanup needs to repeat itself
            bRepeatCleanup = false;
        } else {
            // If the phase that's ending has a stack of additional phases
            // Take the LIFO one and move to that instead of the normal one
            ExtraPhase extraPhase = null;
            if (extraPhases.containsKey(phase)) {
                extraPhase = extraPhases.get(phase).pop();
                PhaseType nextPhase = extraPhase.getPhase();
                // If no more additional phases are available, remove it from the map
                // and let the next add, reput the key
                if (extraPhases.get(phase).isEmpty()) {
                    extraPhases.remove(phase);
                }
                setPhase(nextPhase);
            } else {
                turnEnded = PhaseType.isLast(phase, isTopsy);
                setPhase(PhaseType.getNext(phase, isTopsy));
            }

            if (turnEnded) {
                turn++;
                extraPhases.clear();
                game.updateTurnForView();
                game.fireEvent(new GameEventTurnBegan(PlayerView.get(playerTurn), turn));

                // Tokens starting game in play should suffer from Sum. Sickness
                for (final Card c : playerTurn.getCardsIn(ZoneType.Battlefield, false)) {
                    if (playerTurn.getTurn() > 0 || !c.isStartsGameInPlay()) {
                        c.setSickness(false);
                    }
                }
                playerTurn.incrementTurn();

                final int lands = CardLists.count(playerTurn.getLandsInPlay(), CardPredicates.UNTAPPED);
                playerTurn.setNumPowerSurgeLands(lands);
            }

            final Map<AbilityKey, Object> repRunParams = AbilityKey.mapFromAffected(playerTurn);
            repRunParams.put(AbilityKey.Phase, phase);
            ReplacementResult repres = game.getReplacementHandler().run(ReplacementType.BeginPhase, repRunParams);
            if (repres != ReplacementResult.NotReplaced) {
                // Currently there is no effect to skip entire beginning phase
                // If in the future that kind of effect is added, need to handle it too.
                // Handle skipping of entire combat phase
                if (phase == PhaseType.COMBAT_BEGIN) {
                    setPhase(PhaseType.COMBAT_END);
                }
                advanceToNextPhase();
                return;
            }

            if (extraPhase != null) {
                for (Trigger deltrig : extraPhase.getDelayedTriggers()) {
                    game.getTriggerHandler().registerThisTurnDelayedTrigger(deltrig);
                }
            }
        }

        String phaseType = oldPhase == phase ? "Repeat" : phase == PhaseType.getNext(oldPhase, isTopsy) ? "" : "Additional";
        game.fireEvent(new GameEventTurnPhase(playerTurn, phase, phaseType));
    }

    private boolean isSkippingPhase(final PhaseType phase) {
        switch (phase) {
            case DRAW:
                return turn == 1 && game.getPlayers().size() == 2;

            case COMBAT_BEGIN:
            case COMBAT_DECLARE_ATTACKERS:
                return playerTurn.isSkippingCombat();

            case COMBAT_DECLARE_BLOCKERS:
                skipDamageSteps = !inCombat() || combat.getAttackers().isEmpty();
                //$FALL-THROUGH$
            case COMBAT_FIRST_STRIKE_DAMAGE:
            case COMBAT_DAMAGE:
                return skipDamageSteps;

            default:
                return false;
        }
    }

    private void onPhaseBegin() {
        boolean skipped = false;

        game.getTriggerHandler().resetActiveTriggers();
        if (isSkippingPhase(phase)) {
            skipped = true;
            givePriorityToPlayer = false;
        } else  {
            // Perform turn-based actions
            switch (phase) {
                case UNTAP:
                    givePriorityToPlayer = false;
                    game.getUntap().executeUntil(playerTurn);
                    game.getUntap().executeAt();
                    break;

                case UPKEEP:
                    nUpkeepsThisTurn++;
                    nUpkeepsThisGame++;
                    game.getUpkeep().executeUntil(playerTurn);
                    game.getUpkeep().executeAt();

                    if (playerTurn.getCardsIn(ZoneType.Battlefield).anyMatch(Card::isContraption)) {
                        playerTurn.advanceCrankCounter();
                    }

                    break;

                case DRAW:
                    for (Player p : game.getPlayers()) {
                        p.resetNumDrawnThisDrawStep();
                    }
                    playerTurn.drawCard();
                    break;

                case MAIN1:
                    nMainsThisTurn++;

                    if (playerTurn.isArchenemy()) {
                        playerTurn.setSchemeInMotion(null);
                    }

                    GameEntityCounterTable table = new GameEntityCounterTable();
                    // all Sagas get a Lore counter at the beginning of pre combat
                    for (Card c : playerTurn.getCardsIn(ZoneType.Battlefield)) {
                        if (c.isSaga() && c.hasChapter()) {
                            c.addCounter(CounterEnumType.LORE, 1, playerTurn, table);
                        }
                    }
                    table.replaceCounterEffect(game, null);

                    // roll for attractions if we have any
                    if (playerTurn.getCardsIn(ZoneType.Battlefield).anyMatch(Card::isAttraction)) {
                        playerTurn.rollToVisitAttractions();
                    }

                    break;

                case COMBAT_BEGIN:
                    nCombatsThisTurn++;
                    combat = new Combat(playerTurn);
                    game.getBeginOfCombat().executeUntil(playerTurn);
                    //PhaseUtil.verifyCombat();
                    break;

                case COMBAT_DECLARE_ATTACKERS:
                    combat.initConstraints();
                    game.getStack().freezeStack(null);
                    declareAttackersTurnBasedAction();
                    game.getStack().unfreezeStack();

                    givePriorityToPlayer = inCombat();
                    break;

                case COMBAT_DECLARE_BLOCKERS:
                    combat.removeAbsentCombatants();
                    game.getStack().freezeStack(null);
                    declareBlockersTurnBasedAction();
                    game.getStack().unfreezeStack();
                    break;

                case COMBAT_FIRST_STRIKE_DAMAGE:
                    if (combat.removeAbsentCombatants()) {
                        game.updateCombatForView();
                    }

                    // no first strikers, skip this step
                    if (!combat.assignCombatDamage(true)) {
                        givePriorityToPlayer = false;
                    } else {
                        combat.dealAssignedDamage();
                    }
                    break;

                case COMBAT_DAMAGE:
                    if (combat.removeAbsentCombatants()) {
                        game.updateCombatForView();
                    }

                    if (!combat.assignCombatDamage(false)) {
                        givePriorityToPlayer = false;
                    } else {
                        combat.dealAssignedDamage();
                    }
                    break;

                case COMBAT_END:
                    // End Combat always happens
                    for (final Card c : game.getCardsIn(ZoneType.Battlefield)) {
                        c.onEndOfCombat(playerTurn);
                    }
                    game.getEndOfCombat().executeAt();

                    //SDisplayUtil.showTab(EDocID.REPORT_STACK.getDoc());
                    break;

                case MAIN2:
                    nMainsThisTurn++;
                    //SDisplayUtil.showTab(EDocID.REPORT_STACK.getDoc());
                    break;

                case END_OF_TURN:
                    nEndOfTurnsThisTurn++;
                    game.getEndOfTurn().executeUntil(playerTurn);
                    playerTurn.getController().resetAtEndOfTurn();

                    game.getEndOfTurn().executeAt();
                    break;

                case CLEANUP:
                    // Rule 514.1
                    final int handSize = playerTurn.getZone(ZoneType.Hand).size();
                    final int max = playerTurn.getMaxHandSize();
                    int numDiscard = playerTurn.isUnlimitedHandSize() || handSize <= max || handSize == 0 ? 0 : handSize - max;

                    if (numDiscard > 0) {
                        final CardZoneTable zoneMovements = new CardZoneTable(game.getLastStateBattlefield(), game.getLastStateGraveyard());
                        Map<AbilityKey, Object> moveParams = AbilityKey.newMap();
                        AbilityKey.addCardZoneTableParams(moveParams, zoneMovements);

                        final CardCollection discarded = new CardCollection();
                        List<Card> discardedBefore = Lists.newArrayList(playerTurn.getDiscardedThisTurn());
                        for (Card c : playerTurn.getController().chooseCardsToDiscardToMaximumHandSize(numDiscard)) {
                            Card moved = playerTurn.discard(c, null, false, moveParams);
                            if (moved != null) {
                                discarded.add(moved);
                            }
                        }
                        zoneMovements.triggerChangesZoneAll(game, null);

                        if (!discarded.isEmpty()) {
                            final Map<AbilityKey, Object> runParams = AbilityKey.mapFromPlayer(playerTurn);
                            runParams.put(AbilityKey.Cards, discarded);
                            runParams.put(AbilityKey.Cause, null);
                            runParams.put(AbilityKey.DiscardedBefore, discardedBefore);
                            game.getTriggerHandler().runTrigger(TriggerType.DiscardedAll, runParams, false);
                        }
                    }

                    // Rule 514.2
                    // Reset Damage received map
                    for (final Card c : game.getCardsIncludePhasingIn(ZoneType.Battlefield)) {
                        if (!StaticAbilityNoCleanupDamage.damageNotRemoved(c)) {
                            c.setDamage(0);
                        }
                        c.setHasBeenDealtDeathtouchDamage(false);
                    }

                    game.getEndOfTurn().executeUntil();
                    game.getEndOfTurn().executeUntilEndOfPhase(playerTurn);
                    game.getEndOfTurn().registerUntilEndCommand(playerTurn);
                    game.getEndOfCombat().registerUntilEndCommand(playerTurn);

                    for (Player player : game.getPlayers()) {
                        player.getController().autoPassCancel(); // autopass won't wrap to next turn
                    }

                    nUpkeepsThisTurn = 0;
                    nCombatsThisTurn = 0;
                    nMainsThisTurn = 0;
                    nEndOfTurnsThisTurn = 0;
                    game.getStack().resetMaxDistinctSources();

                    // Rule 514.3
                    givePriorityToPlayer = false;

                    // Rule 514.3a - state-based actions
                    if (game.getAction().checkStateEffects(true)) {
                        bRepeatCleanup = true;
                        givePriorityToPlayer = true;
                    }
                    break;

                default:
                    break;
            }
        }

        if (!skipped) {
            // Run triggers if phase isn't being skipped
            final Map<AbilityKey, Object> runParams = AbilityKey.mapFromPlayer(playerTurn);
            //runParams.put(AbilityKey.Phase, phase.nameForScripts);
            game.getTriggerHandler().runTrigger(TriggerType.Phase, runParams, false);
        }

        // This line fixes Combat Damage triggers not going off when they should
        game.getStack().unfreezeStack();

        // Rule 514.3a
        if (phase == PhaseType.CLEANUP && (!game.getStack().isEmpty() || game.getStack().hasSimultaneousStackEntries())) {
            bRepeatCleanup = true;
            givePriorityToPlayer = true;
        }
    }

    private void onPhaseEnd() {
        // If the Stack isn't empty why is nextPhase being called?
        if (!game.getStack().isEmpty()) {
            throw new IllegalStateException("Phase.nextPhase() is called, but Stack isn't empty.");
        }

        final Map<Player, Integer> lossMap = Maps.newHashMap();
        for (Player p : game.getPlayers()) {
            int burn = p.getManaPool().clearPool(true).size();

            if (p.getManaPool().hasBurn()) {
                final int lost = p.loseLife(burn, false, true);
                if (lost > 0) {
                    lossMap.put(p, lost);
                }
            }
        }
        if (!lossMap.isEmpty()) { // Run triggers if any player actually lost life
            final Map<AbilityKey, Object> runLifeLostParams = AbilityKey.mapFromPIMap(lossMap);
            game.getTriggerHandler().runTrigger(TriggerType.LifeLostAll, runLifeLostParams, false);
        }

        switch (phase) {
            case UPKEEP:
                for (Card c : game.getCardsIncludePhasingIn(ZoneType.Battlefield)) {
                    c.getDamageHistory().setNotAttackedSinceLastUpkeepOf(playerTurn);
                    c.getDamageHistory().setNotBlockedSinceLastUpkeepOf(playerTurn);
                    c.getDamageHistory().setNotBeenBlockedSinceLastUpkeepOf(playerTurn);
                    if (playerTurn.equals(c.getController()) && c.getTurnInZone() < game.getPhaseHandler().getTurn()) {
                        c.setCameUnderControlSinceLastUpkeep(false);
                    }
                }
                game.getUpkeep().executeUntilEndOfPhase(playerTurn);
                game.getUpkeep().registerUntilEndCommand(playerTurn);
                break;

            case UNTAP:
                game.getUntap().executeUntilEndOfPhase(playerTurn);
                break;

            case COMBAT_END:
                GameEventCombatEnded eventEndCombat = null;
                if (inCombat()) {
                    List<Card> attackers = combat.getAttackers();
                    List<Card> blockers = combat.getAllBlockers();
                    eventEndCombat = GameEventCombatEnded.fromCards(attackers, blockers);
                }
                endCombat();

                if (eventEndCombat != null) {
                    game.fireEvent(eventEndCombat);
                }
                break;

            case CLEANUP:
                if (!bRepeatCleanup) {
                    // only call onCleanupPhase when Cleanup is not repeated
                    game.onCleanupPhase();
                    // set previous player
                    playerPreviousTurn = this.getPlayerTurn();
                    setPlayerTurn(handleNextTurn());

                    // start effects for next turn (do this first for ControlPlayer)
                    game.getCleanup().executeUntil();
                    // done this after check state effects, so it only has effect next check
                    game.getCleanup().executeUntil(playerTurn);

                    handleMultiplayerEffects();

                    // "Trigger" for begin turn to get around a phase skipping
                    final Map<AbilityKey, Object> runParams = AbilityKey.mapFromPlayer(playerTurn);
                    game.getTriggerHandler().runTrigger(TriggerType.TurnBegin, runParams, false);
                }
                planarDiceSpecialActionThisTurn = 0;
                // Play the End Turn sound
                game.fireEvent(new GameEventTurnEnded());
                break;
            default: // no action
        }
    }

    private void declareAttackersTurnBasedAction() {
        final Player whoDeclares = Objects.requireNonNullElse(playerTurn.getDeclaresAttackers(), playerTurn);

        if (CombatUtil.canAttack(playerTurn)) {
            boolean success = false;
            do {
                if (game.isGameOver()) { // they just like to close window at any moment
                    return;
                }

                whoDeclares.getController().declareAttackers(playerTurn, combat);
                combat.removeAbsentCombatants();

                success = CombatUtil.validateAttackers(combat);
                if (!success) {
                    whoDeclares.getController().notifyOfValue(null, null, "Attack declaration invalid");
                    continue;
                }

                final CardCollection untapFromCancel = new CardCollection();
                // do a full loop first so attackers can't be used to pay for Propaganda
                for (final Card attacker : combat.getAttackers()) {
                    if (!attacker.attackVigilance()) {
                        // set tapped to true without firing triggers because it may affect propaganda costs
                        attacker.setTapped(true);
                        untapFromCancel.add(attacker);
                    }
                }

                // CR 508.1g
                List<Card> possibleExerters = CombatUtil.getOptionalAttackCostCreatures(combat.getAttackers(), CostExert.class);
                if (!possibleExerters.isEmpty()) {
                    possibleExerters = whoDeclares.getController().exertAttackers(possibleExerters);
                }

                List<Card> possibleEnlisters = CombatUtil.getOptionalAttackCostCreatures(combat.getAttackers(), CostEnlist.class);
                if (!possibleEnlisters.isEmpty()) {
                    // TODO might want to skip if can't be paid
                    possibleEnlisters = whoDeclares.getController().enlistAttackers(possibleEnlisters);
                    possibleExerters.addAll(possibleEnlisters);
                }

                for (final Card attacker : combat.getAttackers()) {
                    // TODO currently doesn't refund previous attackers (can really only happen if you cancel paying for a creature with an attack requirement that could be satisfied without a tax)
                    final boolean canAttack = CombatUtil.checkPropagandaEffects(game, attacker, combat, possibleExerters);

                    if (!canAttack) {
                        combat.removeFromCombat(attacker);
                        if (untapFromCancel.contains(attacker)) {
                            attacker.setTapped(false);
                        }
                        success = CombatUtil.validateAttackers(combat);
                        if (!success) {
                            for (Card c : untapFromCancel) {
                                c.setTapped(false);
                            }
                            // might have been sacrificed while paying
                            combat.removeAbsentCombatants();
                            combat.initConstraints();
                            break;
                        }
                    }
                }
            } while (!success);

            CardCollection tapped = new CardCollection();
            for (final Card attacker : combat.getAttackers()) {
                if (!attacker.attackVigilance()) {
                    attacker.setTapped(false);
                    if (attacker.tap(true, true, null, null)) tapped.add(attacker);
                }
            }
            if (!tapped.isEmpty()) {
                final Map<AbilityKey, Object> runParams = AbilityKey.newMap();
                runParams.put(AbilityKey.Cards, tapped);
                whoDeclares.getGame().getTriggerHandler().runTrigger(TriggerType.TapAll, runParams, false);
            }
        }

        if (game.isGameOver()) { // they just like to close window at any moment
            return;
        }

        // Reset all active Triggers
        game.getTriggerHandler().resetActiveTriggers();

        // Prepare and fire event 'attackers declared'
        Multimap<GameEntity, Card> attackersMap = ArrayListMultimap.create();
        for (GameEntity ge : combat.getDefenders()) {
            attackersMap.putAll(ge, combat.getAttackersOf(ge));
        }
        game.fireEvent(new GameEventAttackersDeclared(playerTurn, attackersMap));

        // fire AttackersDeclared trigger
        if (!combat.getAttackers().isEmpty()) {
            List<GameEntity> attackedTarget = new ArrayList<>();
            for (GameEntity ge : combat.getDefenders()) {
                if (!combat.getAttackersOf(ge).isEmpty()) {
                    final Map<AbilityKey, Object> runParams = AbilityKey.newMap();
                    runParams.put(AbilityKey.Attackers, combat.getAttackersOf(ge));
                    runParams.put(AbilityKey.AttackingPlayer, combat.getAttackingPlayer());
                    runParams.put(AbilityKey.AttackedTarget, Collections.singletonList(ge));
                    attackedTarget.add(ge);
                    game.getTriggerHandler().runTrigger(TriggerType.AttackersDeclaredOneTarget, runParams, false);
                }
            }
            final Map<AbilityKey, Object> runParams = AbilityKey.newMap();
            runParams.put(AbilityKey.Attackers, combat.getAttackers());
            runParams.put(AbilityKey.AttackingPlayer, combat.getAttackingPlayer());
            runParams.put(AbilityKey.AttackedTarget, attackedTarget);
            game.getTriggerHandler().runTrigger(TriggerType.AttackersDeclared, runParams, false);
        }

        for (final Card c : combat.getAttackers()) {
            CombatUtil.checkDeclaredAttacker(game, c, combat, true);
        }

        game.getTriggerHandler().resetActiveTriggers();
        game.updateCombatForView();
        game.fireEvent(new GameEventCombatChanged());
    }

    private void declareBlockersTurnBasedAction() {
        Player p = playerTurn;

        do {
            p = game.getNextPlayerAfter(p);
            // Apply Odric's effect here
            Player whoDeclaresBlockers = Objects.requireNonNullElse(p.getDeclaresBlockers(), p);
            if (combat.isPlayerAttacked(p)) {
                if (CombatUtil.canBlock(p, combat)) {
                    // Replacement effects (for Camouflage)
                    final Map<AbilityKey, Object> repRunParams = AbilityKey.mapFromAffected(p);
                    repRunParams.put(AbilityKey.Player, whoDeclaresBlockers);
                    ReplacementResult repres = game.getReplacementHandler().run(ReplacementType.DeclareBlocker, repRunParams);
                    if (repres == ReplacementResult.NotReplaced) {
                        // If not replaced, run normal declare blockers
                        whoDeclaresBlockers.getController().declareBlockers(p, combat);
                    }
                }
            }
            else { continue; }

            if (game.isGameOver()) { // they just like to close window at any moment
                return;
            }

            // Handles removing cards like Mogg Flunkies from combat if group block didn't occur
            for (Card blocker : CardLists.filterControlledBy(combat.getAllBlockers(), p)) {
                final List<Card> attackers = combat.getAttackersBlockedBy(blocker);
                for (Card attacker : attackers) {
                    boolean hasPaid = CombatUtil.payRequiredBlockCosts(game, blocker, attacker);

                    if (!hasPaid) {
                        combat.removeBlockAssignment(attacker, blocker);
                    }
                }
            }

            // We may need to do multiple iterations removing blockers, since removing one may invalidate
            // others. The loop below is structured so that if no blockers were removed, no extra passes
            // are needed.
            boolean reachedSteadyState;
            do {
                reachedSteadyState = true;
                List<Card> remainingBlockers = CardLists.filterControlledBy(combat.getAllBlockers(), p);
                for (Card c : remainingBlockers) {
                    boolean removeBlocker = false;
                    boolean cantBlockAlone = c.hasKeyword("CARDNAME can't attack or block alone.") || c.hasKeyword("CARDNAME can't block alone.");
                    if (remainingBlockers.size() < 2 && cantBlockAlone) {
                        removeBlocker = true;
                    } else if (remainingBlockers.size() < 3 && c.hasKeyword("CARDNAME can't block unless at least two other creatures block.")) {
                        removeBlocker = true;
                    } else if (c.hasKeyword("CARDNAME can't block unless a creature with greater power also blocks.")) {
                        removeBlocker = true;
                        int power = c.getNetPower();
                        // Note: This is O(n^2), but there shouldn't generally be many creatures with the above keyword.
                        for (Card c2 : remainingBlockers) {
                            if (c2.getNetPower() > power) {
                                removeBlocker = false;
                                break;
                            }
                        }
                    }
                    if (removeBlocker) {
                        combat.undoBlockingAssignment(c);
                        reachedSteadyState = false;
                    }
                }
            } while (!reachedSteadyState);

            // Player is done declaring blockers - redraw UI at this point

            // map: defender => (many) attacker => (many) blocker
            Map<GameEntity, Multimap<Card, Card>> blockers = Maps.newHashMap();
            for (GameEntity ge : combat.getDefendersControlledBy(p)) {
                Multimap<Card, Card> protectThisDefender = MultimapBuilder.hashKeys().arrayListValues().build();
                for (Card att : combat.getAttackersOf(ge)) {
                    protectThisDefender.putAll(att, combat.getBlockers(att).isEmpty() ? List.of(att) : combat.getBlockers(att));
                }
                blockers.put(ge, protectThisDefender);
            }
            game.fireEvent(new GameEventBlockersDeclared(p, blockers));
        } while (p != playerTurn);

        combat.orderBlockersForDamageAssignment(); // 509.2
        combat.orderAttackersForDamageAssignment(); // 509.3

        combat.removeAbsentCombatants();

        combat.fireTriggersForUnblockedAttackers(game);

        final List<Card> declaredBlockers = combat.getAllBlockers();
        if (!declaredBlockers.isEmpty()) {
            final List<Card> blockedAttackers = Lists.newArrayList();
            for (final Card blocker : declaredBlockers) {
                for (final Card blockedAttacker : combat.getAttackersBlockedBy(blocker)) {
                    if (!blockedAttackers.contains(blockedAttacker)) {
                        blockedAttackers.add(blockedAttacker);
                    }
                }
            }
            final Map<AbilityKey, Object> bdRunParams = AbilityKey.newMap();
            bdRunParams.put(AbilityKey.Blockers, declaredBlockers);
            bdRunParams.put(AbilityKey.Attackers, blockedAttackers);
            game.getTriggerHandler().runTrigger(TriggerType.BlockersDeclared, bdRunParams, false);
        }

        for (final Card c1 : combat.getAllBlockers()) {
            if (c1.getDamageHistory().getCreatureBlockedThisCombat()) {
                continue;
            }

            final Map<AbilityKey, Object> runParams = AbilityKey.newMap();
            runParams.put(AbilityKey.Blocker, c1);
            runParams.put(AbilityKey.Attackers, combat.getAttackersBlockedBy(c1));
            game.getTriggerHandler().runTrigger(TriggerType.Blocks, runParams, false);

            c1.getDamageHistory().setCreatureBlockedThisCombat(true);
            c1.getDamageHistory().clearNotBlockedSinceLastUpkeepOf();
        }

        List<Card> blocked = Lists.newArrayList();
        Map<Integer, Card> lkiCache = Maps.newHashMap();

        for (final Card a : combat.getAttackers()) {
            if (combat.isBlocked(a)) {
                a.getDamageHistory().clearNotBeenBlockedSinceLastUpkeepOf();
            }

            final List<Card> blockers = combat.getBlockers(a);
            if (blockers.isEmpty()) {
                continue;
            }

            blocked.add(a);

            // Run triggers
            {
                final Map<AbilityKey, Object> runParams = AbilityKey.newMap();
                runParams.put(AbilityKey.Attacker, a);
                runParams.put(AbilityKey.Blockers, blockers);
                runParams.put(AbilityKey.Defender, combat.getDefenderByAttacker(a));
                runParams.put(AbilityKey.DefendingPlayer, combat.getDefenderPlayerByAttacker(a));
                game.getTriggerHandler().runTrigger(TriggerType.AttackerBlocked, runParams, false);
            }

            // Run this trigger once for each blocker
            for (final Card b : blockers) {
                b.addBlockedThisTurn(CardCopyService.getLKICopy(a, lkiCache));
                a.addBlockedByThisTurn(CardCopyService.getLKICopy(b, lkiCache));

            	final Map<AbilityKey, Object> runParams = AbilityKey.newMap();
                runParams.put(AbilityKey.Attacker, a);
                runParams.put(AbilityKey.Blocker, b);
            	game.getTriggerHandler().runTrigger(TriggerType.AttackerBlockedByCreature, runParams, false);
            }

            a.getDamageHistory().setCreatureGotBlockedThisCombat(true);
        }

        if (!blocked.isEmpty()) {
            final Map<AbilityKey, Object> runParams = AbilityKey.newMap();
            runParams.put(AbilityKey.Attackers, blocked);
            game.getTriggerHandler().runTrigger(TriggerType.AttackerBlockedOnce, runParams, false);
        }

        game.updateCombatForView();
        game.fireEvent(new GameEventCombatChanged());
    }

    public void restart() {
        extraPhases.clear();
        extraTurns.clear();
        turn = 0;
    }

    private Player handleNextTurn() {
        game.getStack().onNextTurn();

        game.getTriggerHandler().clearThisTurnDelayedTrigger();

        Player next = getNextActivePlayer();
        while (!next.isInGame()) {
            next = getNextActivePlayer();
        }

        game.getTriggerHandler().handlePlayerDefinedDelTriggers(next);

        for (final Card c : game.getCardsIncludePhasingIn(ZoneType.Battlefield)) {
            c.setStartedTheTurnUntapped(c.isUntapped());
        }

        game.setMonarchBeginTurn(game.getMonarch());

        if (game.getRules().hasAppliedVariant(GameType.Planechase)) {
            for (Card p :game.getActivePlanes()) {
                if (p != null) {
                    p.setController(next, 0);
                    game.getAction().controllerChangeZoneCorrection(p);
                }
            }
        }
        return next;
    }

    private Player getNextActivePlayer() {
        ExtraTurn extraTurn = !extraTurns.isEmpty() ? extraTurns.pop() : null;
        Player nextPlayer = extraTurn != null ? extraTurn.getPlayer() : game.getNextPlayerAfter(playerTurn);
        // The bottom of the extra turn stack is the normal turn
        boolean isExtraTurn = !extraTurns.isEmpty();

        // update ExtraTurn Count
        nextPlayer.setExtraTurnCount(getExtraTurnForPlayer(nextPlayer));

        // Replacement effects
        final Map<AbilityKey, Object> repRunParams = AbilityKey.mapFromAffected(nextPlayer);
        repRunParams.put(AbilityKey.ExtraTurn, isExtraTurn);
        ReplacementResult repres = game.getReplacementHandler().run(ReplacementType.BeginTurn, repRunParams);
        if (repres != ReplacementResult.NotReplaced) {
            if (extraTurn == null) {
                setPlayerTurn(nextPlayer);
            }
            return getNextActivePlayer();
        }

        nextPlayer.setExtraTurn(isExtraTurn);
        if (extraTurn != null) {
            for (Trigger deltrig : extraTurn.getDelayedTriggers()) {
                game.getTriggerHandler().registerThisTurnDelayedTrigger(deltrig);
            }
            if (extraTurn.isSkipUntap()) {
                SkipPhaseEffect.createSkipPhaseEffect(extraTurn.getSkipUntapSA(), nextPlayer, null, null, "Untap");
            }
            if (extraTurn.isCantSetSchemesInMotion()) {
                AddTurnEffect.createCantSetSchemesInMotionEffect(extraTurn.getCantSetSchemesInMotionSA());
            }
        }
        return nextPlayer;
    }

    public final synchronized boolean is(final PhaseType phase0, final Player player0) {
        return phase == phase0 && playerTurn.equals(player0);
    }
    public final synchronized boolean is(final PhaseType phase0) {
        return phase == phase0;
    }

    public final Player getNextTurn() {
        if (extraTurns.isEmpty()) {
            return game.getNextPlayerAfter(playerTurn);
        }
        return extraTurns.peek().getPlayer();
    }

    public final ExtraTurn addExtraTurn(final Player player) {
        Player previous = null;
        // use a stack to handle extra turns, make sure the bottom of the stack
        // restores original turn order
        if (extraTurns.isEmpty()) {
            extraTurns.push(new ExtraTurn(game.getNextPlayerAfter(playerTurn)));
        } else {
            previous = extraTurns.peek().getPlayer();
        }

        ExtraTurn result = extraTurns.push(new ExtraTurn(player));
        // update Extra Turn for all players
        for (final Player p : game.getPlayers()) {
            p.setExtraTurnCount(getExtraTurnForPlayer(p));
        }

        // get all players where the view should be updated
        List<Player> toUpdate = Lists.newArrayList(player);
        if (previous != null) {
            toUpdate.add(previous);
        }

        // fireEvent to update the Details
        game.fireEvent(new GameEventPlayerStatsChanged(toUpdate, false));

        return result;
    }

    /**
     * Add an extra phase between afterPhase and nextPhase
     * @param afterPhase The phase to add extra phase after
     * @param extraPhaseList The list of extra phase(s) to be added
     * @param nextPhase The original next phase following afterPhase, after extra phase the flow will return to this phase
     * @return returns the added ExtraPhase object
     */
    public final ExtraPhase addExtraPhase(final PhaseType afterPhase, final List<PhaseType> extraPhaseList, PhaseType nextPhase) {
        // 500.8. Some effects can add phases to a turn. They do this by adding the phases directly after the specified phase.
        // If multiple extra phases are created after the same phase, the most recently created phase will occur first.
        for (int i = 0; i < extraPhaseList.size(); i++) {
            PhaseType extra = extraPhaseList.get(i);
            if (!extraPhases.containsKey(extra)) {
                extraPhases.put(extra, new Stack<>());
            }
            if (i < extraPhaseList.size() - 1 ) {
                extraPhases.get(extra).push(new ExtraPhase(extraPhaseList.get(i + 1)));
            } else {
                if (extraPhases.containsKey(afterPhase) && !extraPhases.get(afterPhase).isEmpty()) {
                    // Extra phase(s) was inserted already, link to the first step of inserted extra phase(s)
                    extraPhases.get(extra).push(extraPhases.get(afterPhase).pop());
                } else {
                    extraPhases.get(extra).push(new ExtraPhase(nextPhase));
                }
            }
        }
        if (!extraPhases.containsKey(afterPhase)) {
            extraPhases.put(afterPhase, new Stack<>());
        }
        return extraPhases.get(afterPhase).push(new ExtraPhase(extraPhaseList.get(0)));
    }

    public final boolean hasExtraPhaseAfter(final PhaseType afterPhase, final PhaseType extraPhase) {
        final Stack<ExtraPhase> phases = extraPhases.get(afterPhase);
        return phases != null && !phases.isEmpty() && phases.peek().getPhase() == extraPhase;
    }

    public final boolean isFirstCombat() {
        return nCombatsThisTurn == 1;
    }
    public final int getNumCombat() {
        return nCombatsThisTurn;
    }

    public final int getNumUpkeep() {
        return nUpkeepsThisTurn;
    }

    public final boolean isFirstUpkeep() {
        return is(PhaseType.UPKEEP) && nUpkeepsThisTurn == 0;
    }

    public final boolean isFirstUpkeepThisGame() {
        return is(PhaseType.UPKEEP) && nUpkeepsThisGame == 0;
    }

    public final int getNumMain() {
        return nMainsThisTurn;
    }

    public final boolean beforeFirstPostCombatMainEnd() {
        return nMainsThisTurn <= (is(PhaseType.MAIN2) ? 2 : 1);
    }

    public final boolean skippedDeclareBlockers() {
        return skipDamageSteps;
    }

    public final int getNumEndOfTurn() {
        return nEndOfTurnsThisTurn;
    }

    private final static boolean DEBUG_PHASES = false;

    public void setupFirstTurn(Player goesFirst, Runnable startGameHook) {
        if (phase != null) {
            throw new IllegalStateException("Turns already started, call this only once per game");
        }

        setPlayerTurn(goesFirst);
        advanceToNextPhase();
        onPhaseBegin();

        // don't even offer priority, because it's untap of 1st turn now
        givePriorityToPlayer = false;

        if (startGameHook != null) {
            startGameHook.run();
            givePriorityToPlayer = true;
        }
    }

    public void startFirstTurn(Player goesFirst) {
        startFirstTurn(goesFirst, null);
    }
    public void startFirstTurn(Player goesFirst, Runnable startGameHook) {
        setupFirstTurn(goesFirst, startGameHook);
        mainGameLoop();
    }

    public void mainGameLoop() {
        // MAIN GAME LOOP
        while (!game.isGameOver() && !(game.getAge() == GameStage.RestartedByKarn)) {
            mainLoopStep();
        }
    }

    public void mainLoopStep() {
        if (givePriorityToPlayer) {
            if (DEBUG_PHASES) {
                sw.start();
            }

            game.fireEvent(new GameEventPlayerPriority(PlayerView.get(playerTurn), phase, PlayerView.get(getPriorityPlayer())));
            List<SpellAbility> chosenSa = null;

            int loopCount = 0;
            do {
                if (checkStateBasedEffects()) {
                    // state-based effects check could lead to game over
                    return;
                }
                game.stashGameState();

                chosenSa = pPlayerPriority.getController().chooseSpellAbilityToPlay();

                // this needs to come after chosenSa so it sees you conceding on own turn
                if (playerTurn.hasLost() && pPlayerPriority.equals(playerTurn) && pFirstPriority.equals(playerTurn)) {
                    // If the active player has lost, and they have priority, set the next player to have priority
                    System.out.println("Active player is no longer in the game...");
                    pPlayerPriority = game.getNextPlayerAfter(getPriorityPlayer());
                    pFirstPriority = pPlayerPriority;
                }

                if (chosenSa == null) {
                    break; // that means 'I pass'
                }
                if (DEBUG_PHASES) {
                    System.out.print("... " + pPlayerPriority + " plays " + chosenSa);
                }

                boolean rollback = false;
                for (SpellAbility sa : chosenSa) {
                    Card saHost = sa.getHostCard();
                    final Zone originZone = saHost.getZone();
                    final CardZoneTable triggerList = new CardZoneTable(game.getLastStateBattlefield(), game.getLastStateGraveyard());

                    if (pPlayerPriority.getController().playChosenSpellAbility(sa)) {
                        // 117.3c If a player has priority when they cast a spell, activate an ability, [play a land]
                        // that player receives priority afterward.
                        pFirstPriority = pPlayerPriority; // all opponents have to pass before stack is allowed to resolve
                    } else if (game.EXPERIMENTAL_RESTORE_SNAPSHOT) {
                        rollback = true;
                    }

                    saHost = game.getCardState(saHost);
                    final Zone currentZone = saHost.getZone();

                    // Need to check if Zone did change
                    if (currentZone != null && originZone != null && !currentZone.equals(originZone) && (sa.isSpell() || sa.isLandAbility())) {
                        // currently there can be only one Spell put on the Stack at once, or Land Abilities be played
                        triggerList.put(originZone.getZoneType(), currentZone.getZoneType(), saHost);
                        triggerList.triggerChangesZoneAll(game, sa);
                    }
                }
                // Don't copy last state if we're in the middle of rolling back a spell...
                if (!rollback) {
                    game.copyLastState();
                }
                loopCount++;
            } while (loopCount < 999 || !pPlayerPriority.getController().isAI());

            if (loopCount >= 999 && pPlayerPriority.getController().isAI()) {
                aiLog.warn("AI looped too much with: " + chosenSa);
            }

            if (DEBUG_PHASES) {
                sw.stop();
                System.out.print("... passed in " + sw.getTime()/1000f + " s\n");
                System.out.println("\t\tStack: " + game.getStack());
                sw.reset();
            }
        }
        else if (DEBUG_PHASES) {
            System.out.print(" >> (no priority given to " + getPriorityPlayer() + ")\n");
        }

        // actingPlayer is the player who may act
        // the firstAction is the player who gained Priority First in this segment
        // of Priority
        Player nextPlayer = game.getNextPlayerAfter(getPriorityPlayer());

        if (game.isGameOver() || nextPlayer == null) { return; } // conceded?

        if (DEBUG_PHASES) {
            System.out.println(TextUtil.concatWithSpace(playerTurn.toString(),TextUtil.addSuffix(phase.toString(),":"), pPlayerPriority.toString(),"is active, previous was", nextPlayer.toString()));
        }
        if (pFirstPriority == nextPlayer) {
            if (game.getStack().isEmpty()) {
                if (playerTurn.hasLost()) {
                    setPriority(game.getNextPlayerAfter(playerTurn));
                } else {
                    setPriority(playerTurn);
                }

                // end phase
                givePriorityToPlayer = true;
                onPhaseEnd();
                advanceToNextPhase();
                onPhaseBegin();
            }
            else if (!game.getStack().hasSimultaneousStackEntries()) {
                game.getStack().resolveStack();
            }
        } else {
            // pass the priority to other player
            pPlayerPriority = nextPlayer;
        }

        // If ever the karn's ultimate resolved
        if (game.getAge() == GameStage.RestartedByKarn) {
            setPhase(null);
            game.updatePhaseForView();
            game.fireEvent(new GameEventGameRestarted(PlayerView.get(playerTurn)));
            return;
        }

        // update Priority for all players
        for (final Player p : game.getPlayers()) {
            p.setHasPriority(getPriorityPlayer() == p);
        }
    }

    private boolean checkStateBasedEffects() {
        final Set<Card> allAffectedCards = new HashSet<>();
        do {
            // Rule 704.3  Whenever a player would get priority, the game checks ... for state-based actions,
            game.getAction().checkStateEffects(false, allAffectedCards);
            if (game.isGameOver()) {
                return true; // state-based effects check could lead to game over
            }
        } while (game.getStack().addAllTriggeredAbilitiesToStack()); //loop so long as something was added to stack

        if (!allAffectedCards.isEmpty()) {
            game.fireEvent(new GameEventCardStatsChanged(allAffectedCards));
            allAffectedCards.clear();
            // Update flashback views after static abilities have been recalculated,
            // so play-from-zone abilities (e.g. Bolas's Citadel) are reflected
            game.getPlayers().forEach(Player::updateFlashbackForView);
        }
        return false;
    }

    public final boolean devAdvanceToPhase(PhaseType targetPhase) {
        return devAdvanceToPhase(targetPhase, null);
    }
    public final boolean devAdvanceToPhase(PhaseType targetPhase, Runnable resolver) {
        boolean isTopsy = playerTurn.isPhasesReversed();
        while (phase.isBefore(targetPhase, isTopsy)) {
            if (checkStateBasedEffects()) {
                return false;
            }
            if (resolver != null) {
                resolver.run();
            }
            onPhaseEnd();
            advanceToNextPhase();
            onPhaseBegin();
        }
        checkStateBasedEffects();
        return true;
    }

    // this is a hack for the setup game state mode, do not use outside of devSetupGameState code
    // as it avoids calling any of the phase effects that may be necessary in a less enforced context
    public final void devModeSet(final PhaseType phase0, final Player player0, boolean endCombat, int cturn) {
        if (phase0 != null) {
            setPhase(phase0);
        }
        if (player0 != null) {
            setPlayerTurn(player0);
        }
        turn = cturn;

        game.fireEvent(new GameEventTurnPhase(playerTurn, phase, "dev"));
        if (endCombat) {
            endCombat(); // not-null can be created only when declare attackers phase begins
        }
    }
    public final void devModeSet(final PhaseType phase0, final Player player0) {
        devModeSet(phase0, player0, true, 1);
    }

    public final void devModeSet(final PhaseType phase0, final Player player0, int cturn) {
        devModeSet(phase0, player0, true, cturn);
    }

    public final void devModeSet(final PhaseType phase0, final Player player0, boolean endCombat) {
        devModeSet(phase0, player0, endCombat, 0);
    }

    public final void endCombatPhaseByEffect() {
        endCombat();
        game.getAction().checkStateEffects(true);
        setPhase(PhaseType.COMBAT_END);
        advanceToNextPhase();
    }

    public final void endTurnByEffect() {
        extraPhases.clear();
        setPhase(PhaseType.CLEANUP);
        game.fireEvent(new GameEventTurnPhase(playerTurn, phase, ""));
        onPhaseBegin();
    }

    public int getPlanarDiceSpecialActionThisTurn() {
        return planarDiceSpecialActionThisTurn;
    }
    public void incPlanarDiceSpecialActionThisTurn() {
        planarDiceSpecialActionThisTurn++;
    }

    public String debugPrintState(boolean hasPriority) {
        return String.format("%s's %s [%sP] %s", playerTurn, phase.nameForUi, hasPriority ? "+" : "-", getPriorityPlayer());
    }

    // just to avoid exposing variable to outer classes
    public void onStackResolved() {
        givePriorityToPlayer = true;
    }

    public void endCombat() {
        game.getEndOfCombat().executeUntil();
        game.getEndOfCombat().executeUntilEndOfPhase(playerTurn);
        if (inCombat()) {
            combat.endCombat();
            combat = null;
        }
        game.updateCombatForView();
    }

    public void setCombat(Combat combat) {
        this.combat = combat;
    }

    /**
     * returns the continuous extra turn count
     * @param p
     * @return int
     */
    public int getExtraTurnForPlayer(final Player p) {
        if (this.extraTurns.isEmpty() || this.extraTurns.size() < 2) {
            return 0;
        }

        int count = 0;
        // skip the first element
        for (final ExtraTurn et : extraTurns.subList(1, extraTurns.size())) {
            if (!et.getPlayer().equals(p)) {
                break;
            }
            count += 1;
        }
        return count;
    }

    private void handleMultiplayerEffects() {
        // CR 800.4m When a player leaves the game, any continuous effects with durations that last until that
        // playerÃ¢â‚¬â„¢s next turn or until a specific point in that turn will last until that turn would have begun
        int oldPlayerIdx = game.getRegisteredPlayers().indexOf(playerPreviousTurn);
        final int playerIdx = game.getRegisteredPlayers().indexOf(playerTurn);
        final int direction = game.getTurnOrder().getShift();
        while (oldPlayerIdx != playerIdx) {
            oldPlayerIdx += direction;
            if (oldPlayerIdx < 0) {
                oldPlayerIdx = game.getRegisteredPlayers().size() - 1;
            } else if (oldPlayerIdx > game.getRegisteredPlayers().size() - 1) {
                oldPlayerIdx = 0;
            }
            Player p = game.getRegisteredPlayers().get(oldPlayerIdx);
            if (p.hasLost()) {
                // CR 702.26n
                Untap.doPhasing(p);

                game.getUntap().executeUntil(p);
                game.getUpkeep().executeUntil(p);
                game.getUpkeep().executeUntilEndOfPhase(p);
                game.getEndOfCombat().executeUntilEndOfPhase(p);
                game.getEndOfTurn().executeUntil(p);
                game.getEndOfTurn().executeUntilEndOfPhase(p);
                game.getCleanup().executeUntil(p);
            }
        }
    }
}
```

## Python
`forge/game/phase/PhaseHandler.py`

```python
package forge.game.phase
# /*
#  * Forge: Play Magic: the Gathering.
#  * Copyright (C) 2011  Forge Team
#  *
#  * This program is free software: you can redistribute it and/or modify
#  * it under the terms of the GNU General Public License as published by
#  * the Free Software Foundation, either version 3 of the License, or
#  * (at your option) any later version.
#  *
#  * This program is distributed in the hope that it will be useful,
#  * but WITHOUT ANY WARRANTY; without even the implied warranty of
#  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  * GNU General Public License for more details.
#  *
#  * You should have received a copy of the GNU General Public License
#  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
#  */

from org.apache.commons.lang3.time.StopWatch import StopWatch

from forge.game.Game import Game
from forge.game.GameEntity import GameEntity
from forge.game.GameEntityCounterTable import GameEntityCounterTable
from forge.game.GameType import GameType
from forge.game.GameStage import GameStage
from forge.game.ability.AbilityKey import AbilityKey
from forge.game.ability.effects.AddTurnEffect import AddTurnEffect
from forge.game.ability.effects.SkipPhaseEffect import SkipPhaseEffect
from forge.game.card.Card import Card
from forge.game.card.CardCollection import CardCollection
from forge.game.card.CardCopyService import CardCopyService
from forge.game.card.CardLists import CardLists
from forge.game.card.CardPredicates import CardPredicates
from forge.game.card.CardZoneTable import CardZoneTable
from forge.game.card.CounterEnumType import CounterEnumType
from forge.game.combat.Combat import Combat
from forge.game.combat.CombatUtil import CombatUtil
from forge.game.cost.CostEnlist import CostEnlist
from forge.game.cost.CostExert import CostExert
from forge.game.event.GameEventAttackersDeclared import GameEventAttackersDeclared
from forge.game.event.GameEventBlockersDeclared import GameEventBlockersDeclared
from forge.game.event.GameEventCardStatsChanged import GameEventCardStatsChanged
from forge.game.event.GameEventCombatChanged import GameEventCombatChanged
from forge.game.event.GameEventCombatEnded import GameEventCombatEnded
from forge.game.event.GameEventGameRestarted import GameEventGameRestarted
from forge.game.event.GameEventPlayerPriority import GameEventPlayerPriority
from forge.game.event.GameEventPlayerStatsChanged import GameEventPlayerStatsChanged
from forge.game.event.GameEventTurnBegan import GameEventTurnBegan
from forge.game.event.GameEventTurnEnded import GameEventTurnEnded
from forge.game.event.GameEventTurnPhase import GameEventTurnPhase
from forge.game.phase.ExtraPhase import ExtraPhase
from forge.game.phase.ExtraTurn import ExtraTurn
from forge.game.phase.PhaseType import PhaseType
from forge.game.phase.Untap import Untap
from forge.game.player.Player import Player
from forge.game.player.PlayerView import PlayerView
from forge.game.replacement.ReplacementResult import ReplacementResult
from forge.game.replacement.ReplacementType import ReplacementType
from forge.game.spellability.SpellAbility import SpellAbility
from forge.game.staticability.StaticAbilityNoCleanupDamage import StaticAbilityNoCleanupDamage
from forge.game.trigger.Trigger import Trigger
from forge.game.trigger.TriggerType import TriggerType
from forge.game.zone.Zone import Zone
from forge.game.zone.ZoneType import ZoneType
from forge.util.IHasForgeLog import IHasForgeLog
from forge.util.TextUtil import TextUtil


class PhaseHandler(IHasForgeLog):
    serialVersionUID = 5207222278370963197

    # used for debugging phase timing
    DEBUG_PHASES = False

    def __init__(self, game0: Game):
        self.sw = StopWatch()

        # Start turn at 0, since we start even before first untap
        self.phase = None
        self.turn = 0

        self.extraTurns: list[ExtraTurn] = []
        self.extraPhases: dict[PhaseType, list[ExtraPhase]] = {}

        self.nUpkeepsThisTurn = 0
        self.nUpkeepsThisGame = 0
        self.nCombatsThisTurn = 0
        self.nMainsThisTurn = 0
        self.nEndOfTurnsThisTurn = 0
        self.planarDiceSpecialActionThisTurn = 0

        self.playerTurn = None
        self.playerPreviousTurn = None

        # priority player
        self.pPlayerPriority = None
        self.pFirstPriority = None
        self.combat = None
        self.skipDamageSteps = False
        self.bRepeatCleanup = False

        # The need to next phase.
        self.givePriorityToPlayer = False

        self.game = game0

    def getPhase(self) -> PhaseType:
        return self.phase

    def setPhase(self, phase0: PhaseType) -> None:
        if self.phase == phase0:
            return
        self.phase = phase0
        self.game.updatePhaseForView()

    def getTurn(self) -> int:
        return self.turn

    def isPlayerTurn(self, player: Player) -> bool:
        return player.equals(self.playerTurn)

    def getPlayerTurn(self) -> Player:
        return self.playerTurn

    def setPlayerTurn(self, playerTurn0: Player) -> None:
        if self.playerTurn == playerTurn0:
            return
        self.playerTurn = playerTurn0
        self.game.updatePlayerTurnForView()
        self.resetPriority()

    def getPreviousPlayerTurn(self) -> Player:
        return self.playerPreviousTurn

    def getPriorityPlayer(self) -> Player:
        return self.pPlayerPriority

    def setPriority(self, p: Player) -> None:
        self.pFirstPriority = p
        self.pPlayerPriority = p

    def resetPriority(self) -> None:
        self.setPriority(self.playerTurn)

    def inCombat(self) -> bool:
        return self.combat is not None

    def getCombat(self) -> Combat:
        return self.combat

    def advanceToNextPhase(self) -> None:
        oldPhase = self.phase
        isTopsy = self.playerTurn.isPhasesReversed()
        turnEnded = False

        self.game.getStack().clearUndoStack()  # can't undo action from previous phase

        if self.bRepeatCleanup:  # for when Cleanup needs to repeat itself
            self.bRepeatCleanup = False
        else:
            # If the phase that's ending has a stack of additional phases
            # Take the LIFO one and move to that instead of the normal one
            extraPhase = None
            if self.phase in self.extraPhases:
                extraPhase = self.extraPhases[self.phase].pop()
                nextPhase = extraPhase.getPhase()
                # If no more additional phases are available, remove it from the map
                # and let the next add, reput the key
                if len(self.extraPhases[self.phase]) == 0:
                    del self.extraPhases[self.phase]
                self.setPhase(nextPhase)
            else:
                turnEnded = PhaseType.isLast(self.phase, isTopsy)
                self.setPhase(PhaseType.getNext(self.phase, isTopsy))

            if turnEnded:
                self.turn += 1
                self.extraPhases.clear()
                self.game.updateTurnForView()
                self.game.fireEvent(GameEventTurnBegan(PlayerView.get(self.playerTurn), self.turn))

                # Tokens starting game in play should suffer from Sum. Sickness
                for c in self.playerTurn.getCardsIn(ZoneType.Battlefield, False):
                    if self.playerTurn.getTurn() > 0 or not c.isStartsGameInPlay():
                        c.setSickness(False)
                self.playerTurn.incrementTurn()

                lands = CardLists.count(self.playerTurn.getLandsInPlay(), CardPredicates.UNTAPPED)
                self.playerTurn.setNumPowerSurgeLands(lands)

            repRunParams = AbilityKey.mapFromAffected(self.playerTurn)
            repRunParams[AbilityKey.Phase] = self.phase
            repres = self.game.getReplacementHandler().run(ReplacementType.BeginPhase, repRunParams)
            if repres != ReplacementResult.NotReplaced:
                # Currently there is no effect to skip entire beginning phase
                # If in the future that kind of effect is added, need to handle it too.
                # Handle skipping of entire combat phase
                if self.phase == PhaseType.COMBAT_BEGIN:
                    self.setPhase(PhaseType.COMBAT_END)
                self.advanceToNextPhase()
                return

            if extraPhase is not None:
                for deltrig in extraPhase.getDelayedTriggers():
                    self.game.getTriggerHandler().registerThisTurnDelayedTrigger(deltrig)

        phaseType = "Repeat" if oldPhase == self.phase else ("" if self.phase == PhaseType.getNext(oldPhase, isTopsy) else "Additional")
        self.game.fireEvent(GameEventTurnPhase(self.playerTurn, self.phase, phaseType))

    def isSkippingPhase(self, phase: PhaseType) -> bool:
        if phase == PhaseType.DRAW:
            return self.turn == 1 and self.game.getPlayers().size() == 2

        elif phase == PhaseType.COMBAT_BEGIN or phase == PhaseType.COMBAT_DECLARE_ATTACKERS:
            return self.playerTurn.isSkippingCombat()

        elif phase == PhaseType.COMBAT_DECLARE_BLOCKERS:
            self.skipDamageSteps = not self.inCombat() or self.combat.getAttackers().isEmpty()
            # $FALL-THROUGH$
            return self.skipDamageSteps

        elif phase == PhaseType.COMBAT_FIRST_STRIKE_DAMAGE or phase == PhaseType.COMBAT_DAMAGE:
            return self.skipDamageSteps

        else:
            return False

    def onPhaseBegin(self) -> None:
        skipped = False

        self.game.getTriggerHandler().resetActiveTriggers()
        if self.isSkippingPhase(self.phase):
            skipped = True
            self.givePriorityToPlayer = False
        else:
            # Perform turn-based actions
            if self.phase == PhaseType.UNTAP:
                self.givePriorityToPlayer = False
                self.game.getUntap().executeUntil(self.playerTurn)
                self.game.getUntap().executeAt()

            elif self.phase == PhaseType.UPKEEP:
                self.nUpkeepsThisTurn += 1
                self.nUpkeepsThisGame += 1
                self.game.getUpkeep().executeUntil(self.playerTurn)
                self.game.getUpkeep().executeAt()

                if self.playerTurn.getCardsIn(ZoneType.Battlefield).anyMatch(Card.isContraption):
                    self.playerTurn.advanceCrankCounter()

            elif self.phase == PhaseType.DRAW:
                for p in self.game.getPlayers():
                    p.resetNumDrawnThisDrawStep()
                self.playerTurn.drawCard()

            elif self.phase == PhaseType.MAIN1:
                self.nMainsThisTurn += 1

                if self.playerTurn.isArchenemy():
                    self.playerTurn.setSchemeInMotion(None)

                table = GameEntityCounterTable()
                # all Sagas get a Lore counter at the beginning of pre combat
                for c in self.playerTurn.getCardsIn(ZoneType.Battlefield):
                    if c.isSaga() and c.hasChapter():
                        c.addCounter(CounterEnumType.LORE, 1, self.playerTurn, table)
                table.replaceCounterEffect(self.game, None)

                # roll for attractions if we have any
                if self.playerTurn.getCardsIn(ZoneType.Battlefield).anyMatch(Card.isAttraction):
                    self.playerTurn.rollToVisitAttractions()

            elif self.phase == PhaseType.COMBAT_BEGIN:
                self.nCombatsThisTurn += 1
                self.combat = Combat(self.playerTurn)
                self.game.getBeginOfCombat().executeUntil(self.playerTurn)
                # PhaseUtil.verifyCombat();

            elif self.phase == PhaseType.COMBAT_DECLARE_ATTACKERS:
                self.combat.initConstraints()
                self.game.getStack().freezeStack(None)
                self.declareAttackersTurnBasedAction()
                self.game.getStack().unfreezeStack()

                self.givePriorityToPlayer = self.inCombat()

            elif self.phase == PhaseType.COMBAT_DECLARE_BLOCKERS:
                self.combat.removeAbsentCombatants()
                self.game.getStack().freezeStack(None)
                self.declareBlockersTurnBasedAction()
                self.game.getStack().unfreezeStack()

            elif self.phase == PhaseType.COMBAT_FIRST_STRIKE_DAMAGE:
                if self.combat.removeAbsentCombatants():
                    self.game.updateCombatForView()

                # no first strikers, skip this step
                if not self.combat.assignCombatDamage(True):
                    self.givePriorityToPlayer = False
                else:
                    self.combat.dealAssignedDamage()

            elif self.phase == PhaseType.COMBAT_DAMAGE:
                if self.combat.removeAbsentCombatants():
                    self.game.updateCombatForView()

                if not self.combat.assignCombatDamage(False):
                    self.givePriorityToPlayer = False
                else:
                    self.combat.dealAssignedDamage()

            elif self.phase == PhaseType.COMBAT_END:
                # End Combat always happens
                for c in self.game.getCardsIn(ZoneType.Battlefield):
                    c.onEndOfCombat(self.playerTurn)
                self.game.getEndOfCombat().executeAt()

                # SDisplayUtil.showTab(EDocID.REPORT_STACK.getDoc());

            elif self.phase == PhaseType.MAIN2:
                self.nMainsThisTurn += 1
                # SDisplayUtil.showTab(EDocID.REPORT_STACK.getDoc());

            elif self.phase == PhaseType.END_OF_TURN:
                self.nEndOfTurnsThisTurn += 1
                self.game.getEndOfTurn().executeUntil(self.playerTurn)
                self.playerTurn.getController().resetAtEndOfTurn()

                self.game.getEndOfTurn().executeAt()

            elif self.phase == PhaseType.CLEANUP:
                # Rule 514.1
                handSize = self.playerTurn.getZone(ZoneType.Hand).size()
                max = self.playerTurn.getMaxHandSize()
                numDiscard = 0 if (self.playerTurn.isUnlimitedHandSize() or handSize <= max or handSize == 0) else handSize - max

                if numDiscard > 0:
                    zoneMovements = CardZoneTable(self.game.getLastStateBattlefield(), self.game.getLastStateGraveyard())
                    moveParams = AbilityKey.newMap()
                    AbilityKey.addCardZoneTableParams(moveParams, zoneMovements)

                    discarded = CardCollection()
                    discardedBefore = list(self.playerTurn.getDiscardedThisTurn())
                    for c in self.playerTurn.getController().chooseCardsToDiscardToMaximumHandSize(numDiscard):
                        moved = self.playerTurn.discard(c, None, False, moveParams)
                        if moved is not None:
                            discarded.add(moved)
                    zoneMovements.triggerChangesZoneAll(self.game, None)

                    if not discarded.isEmpty():
                        runParams = AbilityKey.mapFromPlayer(self.playerTurn)
                        runParams[AbilityKey.Cards] = discarded
                        runParams[AbilityKey.Cause] = None
                        runParams[AbilityKey.DiscardedBefore] = discardedBefore
                        self.game.getTriggerHandler().runTrigger(TriggerType.DiscardedAll, runParams, False)

                # Rule 514.2
                # Reset Damage received map
                for c in self.game.getCardsIncludePhasingIn(ZoneType.Battlefield):
                    if not StaticAbilityNoCleanupDamage.damageNotRemoved(c):
                        c.setDamage(0)
                    c.setHasBeenDealtDeathtouchDamage(False)

                self.game.getEndOfTurn().executeUntil()
                self.game.getEndOfTurn().executeUntilEndOfPhase(self.playerTurn)
                self.game.getEndOfTurn().registerUntilEndCommand(self.playerTurn)
                self.game.getEndOfCombat().registerUntilEndCommand(self.playerTurn)

                for player in self.game.getPlayers():
                    player.getController().autoPassCancel()  # autopass won't wrap to next turn

                self.nUpkeepsThisTurn = 0
                self.nCombatsThisTurn = 0
                self.nMainsThisTurn = 0
                self.nEndOfTurnsThisTurn = 0
                self.game.getStack().resetMaxDistinctSources()

                # Rule 514.3
                self.givePriorityToPlayer = False

                # Rule 514.3a - state-based actions
                if self.game.getAction().checkStateEffects(True):
                    self.bRepeatCleanup = True
                    self.givePriorityToPlayer = True

            else:
                pass

        if not skipped:
            # Run triggers if phase isn't being skipped
            runParams = AbilityKey.mapFromPlayer(self.playerTurn)
            # runParams.put(AbilityKey.Phase, phase.nameForScripts);
            self.game.getTriggerHandler().runTrigger(TriggerType.Phase, runParams, False)

        # This line fixes Combat Damage triggers not going off when they should
        self.game.getStack().unfreezeStack()

        # Rule 514.3a
        if self.phase == PhaseType.CLEANUP and (not self.game.getStack().isEmpty() or self.game.getStack().hasSimultaneousStackEntries()):
            self.bRepeatCleanup = True
            self.givePriorityToPlayer = True

    def onPhaseEnd(self) -> None:
        # If the Stack isn't empty why is nextPhase being called?
        if not self.game.getStack().isEmpty():
            raise RuntimeError("Phase.nextPhase() is called, but Stack isn't empty.")

        lossMap: dict[Player, int] = {}
        for p in self.game.getPlayers():
            burn = p.getManaPool().clearPool(True).size()

            if p.getManaPool().hasBurn():
                lost = p.loseLife(burn, False, True)
                if lost > 0:
                    lossMap[p] = lost
        if len(lossMap) != 0:  # Run triggers if any player actually lost life
            runLifeLostParams = AbilityKey.mapFromPIMap(lossMap)
            self.game.getTriggerHandler().runTrigger(TriggerType.LifeLostAll, runLifeLostParams, False)

        if self.phase == PhaseType.UPKEEP:
            for c in self.game.getCardsIncludePhasingIn(ZoneType.Battlefield):
                c.getDamageHistory().setNotAttackedSinceLastUpkeepOf(self.playerTurn)
                c.getDamageHistory().setNotBlockedSinceLastUpkeepOf(self.playerTurn)
                c.getDamageHistory().setNotBeenBlockedSinceLastUpkeepOf(self.playerTurn)
                if self.playerTurn.equals(c.getController()) and c.getTurnInZone() < self.game.getPhaseHandler().getTurn():
                    c.setCameUnderControlSinceLastUpkeep(False)
            self.game.getUpkeep().executeUntilEndOfPhase(self.playerTurn)
            self.game.getUpkeep().registerUntilEndCommand(self.playerTurn)

        elif self.phase == PhaseType.UNTAP:
            self.game.getUntap().executeUntilEndOfPhase(self.playerTurn)

        elif self.phase == PhaseType.COMBAT_END:
            eventEndCombat = None
            if self.inCombat():
                attackers = self.combat.getAttackers()
                blockers = self.combat.getAllBlockers()
                eventEndCombat = GameEventCombatEnded.fromCards(attackers, blockers)
            self.endCombat()

            if eventEndCombat is not None:
                self.game.fireEvent(eventEndCombat)

        elif self.phase == PhaseType.CLEANUP:
            if not self.bRepeatCleanup:
                # only call onCleanupPhase when Cleanup is not repeated
                self.game.onCleanupPhase()
                # set previous player
                self.playerPreviousTurn = self.getPlayerTurn()
                self.setPlayerTurn(self.handleNextTurn())

                # start effects for next turn (do this first for ControlPlayer)
                self.game.getCleanup().executeUntil()
                # done this after check state effects, so it only has effect next check
                self.game.getCleanup().executeUntil(self.playerTurn)

                self.handleMultiplayerEffects()

                # "Trigger" for begin turn to get around a phase skipping
                runParams = AbilityKey.mapFromPlayer(self.playerTurn)
                self.game.getTriggerHandler().runTrigger(TriggerType.TurnBegin, runParams, False)
            self.planarDiceSpecialActionThisTurn = 0
            # Play the End Turn sound
            self.game.fireEvent(GameEventTurnEnded())

        else:
            pass  # no action

    def declareAttackersTurnBasedAction(self) -> None:
        whoDeclares = self.playerTurn.getDeclaresAttackers() if self.playerTurn.getDeclaresAttackers() is not None else self.playerTurn

        if CombatUtil.canAttack(self.playerTurn):
            success = False
            while True:
                if self.game.isGameOver():  # they just like to close window at any moment
                    return

                whoDeclares.getController().declareAttackers(self.playerTurn, self.combat)
                self.combat.removeAbsentCombatants()

                success = CombatUtil.validateAttackers(self.combat)
                if not success:
                    whoDeclares.getController().notifyOfValue(None, None, "Attack declaration invalid")
                    continue

                untapFromCancel = CardCollection()
                # do a full loop first so attackers can't be used to pay for Propaganda
                for attacker in self.combat.getAttackers():
                    if not attacker.attackVigilance():
                        # set tapped to true without firing triggers because it may affect propaganda costs
                        attacker.setTapped(True)
                        untapFromCancel.add(attacker)

                # CR 508.1g
                possibleExerters = CombatUtil.getOptionalAttackCostCreatures(self.combat.getAttackers(), CostExert)
                if len(possibleExerters) != 0:
                    possibleExerters = whoDeclares.getController().exertAttackers(possibleExerters)

                possibleEnlisters = CombatUtil.getOptionalAttackCostCreatures(self.combat.getAttackers(), CostEnlist)
                if len(possibleEnlisters) != 0:
                    # TODO might want to skip if can't be paid
                    possibleEnlisters = whoDeclares.getController().enlistAttackers(possibleEnlisters)
                    possibleExerters.extend(possibleEnlisters)

                for attacker in self.combat.getAttackers():
                    # TODO currently doesn't refund previous attackers (can really only happen if you cancel paying for a creature with an attack requirement that could be satisfied without a tax)
                    canAttack = CombatUtil.checkPropagandaEffects(self.game, attacker, self.combat, possibleExerters)

                    if not canAttack:
                        self.combat.removeFromCombat(attacker)
                        if untapFromCancel.contains(attacker):
                            attacker.setTapped(False)
                        success = CombatUtil.validateAttackers(self.combat)
                        if not success:
                            for c in untapFromCancel:
                                c.setTapped(False)
                            # might have been sacrificed while paying
                            self.combat.removeAbsentCombatants()
                            self.combat.initConstraints()
                            break

                if success:
                    break

            tapped = CardCollection()
            for attacker in self.combat.getAttackers():
                if not attacker.attackVigilance():
                    attacker.setTapped(False)
                    if attacker.tap(True, True, None, None):
                        tapped.add(attacker)
            if not tapped.isEmpty():
                runParams = AbilityKey.newMap()
                runParams[AbilityKey.Cards] = tapped
                whoDeclares.getGame().getTriggerHandler().runTrigger(TriggerType.TapAll, runParams, False)

        if self.game.isGameOver():  # they just like to close window at any moment
            return

        # Reset all active Triggers
        self.game.getTriggerHandler().resetActiveTriggers()

        # Prepare and fire event 'attackers declared'
        attackersMap: dict[GameEntity, list[Card]] = {}
        for ge in self.combat.getDefenders():
            attackersMap.setdefault(ge, []).extend(self.combat.getAttackersOf(ge))
        self.game.fireEvent(GameEventAttackersDeclared(self.playerTurn, attackersMap))

        # fire AttackersDeclared trigger
        if not self.combat.getAttackers().isEmpty():
            attackedTarget: list[GameEntity] = []
            for ge in self.combat.getDefenders():
                if not self.combat.getAttackersOf(ge).isEmpty():
                    runParams = AbilityKey.newMap()
                    runParams[AbilityKey.Attackers] = self.combat.getAttackersOf(ge)
                    runParams[AbilityKey.AttackingPlayer] = self.combat.getAttackingPlayer()
                    runParams[AbilityKey.AttackedTarget] = [ge]
                    attackedTarget.append(ge)
                    self.game.getTriggerHandler().runTrigger(TriggerType.AttackersDeclaredOneTarget, runParams, False)
            runParams = AbilityKey.newMap()
            runParams[AbilityKey.Attackers] = self.combat.getAttackers()
            runParams[AbilityKey.AttackingPlayer] = self.combat.getAttackingPlayer()
            runParams[AbilityKey.AttackedTarget] = attackedTarget
            self.game.getTriggerHandler().runTrigger(TriggerType.AttackersDeclared, runParams, False)

        for c in self.combat.getAttackers():
            CombatUtil.checkDeclaredAttacker(self.game, c, self.combat, True)

        self.game.getTriggerHandler().resetActiveTriggers()
        self.game.updateCombatForView()
        self.game.fireEvent(GameEventCombatChanged())

    def declareBlockersTurnBasedAction(self) -> None:
        p = self.playerTurn

        while True:
            p = self.game.getNextPlayerAfter(p)
            # Apply Odric's effect here
            whoDeclaresBlockers = p.getDeclaresBlockers() if p.getDeclaresBlockers() is not None else p
            attacked = self.combat.isPlayerAttacked(p)
            if attacked:
                if CombatUtil.canBlock(p, self.combat):
                    # Replacement effects (for Camouflage)
                    repRunParams = AbilityKey.mapFromAffected(p)
                    repRunParams[AbilityKey.Player] = whoDeclaresBlockers
                    repres = self.game.getReplacementHandler().run(ReplacementType.DeclareBlocker, repRunParams)
                    if repres == ReplacementResult.NotReplaced:
                        # If not replaced, run normal declare blockers
                        whoDeclaresBlockers.getController().declareBlockers(p, self.combat)
            else:
                if p != self.playerTurn:
                    continue
                else:
                    break

            if self.game.isGameOver():  # they just like to close window at any moment
                return

            # Handles removing cards like Mogg Flunkies from combat if group block didn't occur
            for blocker in CardLists.filterControlledBy(self.combat.getAllBlockers(), p):
                attackers = self.combat.getAttackersBlockedBy(blocker)
                for attacker in attackers:
                    hasPaid = CombatUtil.payRequiredBlockCosts(self.game, blocker, attacker)

                    if not hasPaid:
                        self.combat.removeBlockAssignment(attacker, blocker)

            # We may need to do multiple iterations removing blockers, since removing one may invalidate
            # others. The loop below is structured so that if no blockers were removed, no extra passes
            # are needed.
            while True:
                reachedSteadyState = True
                remainingBlockers = CardLists.filterControlledBy(self.combat.getAllBlockers(), p)
                for c in remainingBlockers:
                    removeBlocker = False
                    cantBlockAlone = c.hasKeyword("CARDNAME can't attack or block alone.") or c.hasKeyword("CARDNAME can't block alone.")
                    if remainingBlockers.size() < 2 and cantBlockAlone:
                        removeBlocker = True
                    elif remainingBlockers.size() < 3 and c.hasKeyword("CARDNAME can't block unless at least two other creatures block."):
                        removeBlocker = True
                    elif c.hasKeyword("CARDNAME can't block unless a creature with greater power also blocks."):
                        removeBlocker = True
                        power = c.getNetPower()
                        # Note: This is O(n^2), but there shouldn't generally be many creatures with the above keyword.
                        for c2 in remainingBlockers:
                            if c2.getNetPower() > power:
                                removeBlocker = False
                                break
                    if removeBlocker:
                        self.combat.undoBlockingAssignment(c)
                        reachedSteadyState = False
                if reachedSteadyState:
                    break

            # Player is done declaring blockers - redraw UI at this point

            # map: defender => (many) attacker => (many) blocker
            blockers: dict[GameEntity, dict[Card, list[Card]]] = {}
            for ge in self.combat.getDefendersControlledBy(p):
                protectThisDefender: dict[Card, list[Card]] = {}
                for att in self.combat.getAttackersOf(ge):
                    protectThisDefender.setdefault(att, []).extend([att] if self.combat.getBlockers(att).isEmpty() else self.combat.getBlockers(att))
                blockers[ge] = protectThisDefender
            self.game.fireEvent(GameEventBlockersDeclared(p, blockers))

            if p == self.playerTurn:
                break

        self.combat.orderBlockersForDamageAssignment()  # 509.2
        self.combat.orderAttackersForDamageAssignment()  # 509.3

        self.combat.removeAbsentCombatants()

        self.combat.fireTriggersForUnblockedAttackers(self.game)

        declaredBlockers = self.combat.getAllBlockers()
        if not declaredBlockers.isEmpty():
            blockedAttackers = []
            for blocker in declaredBlockers:
                for blockedAttacker in self.combat.getAttackersBlockedBy(blocker):
                    if blockedAttacker not in blockedAttackers:
                        blockedAttackers.append(blockedAttacker)
            bdRunParams = AbilityKey.newMap()
            bdRunParams[AbilityKey.Blockers] = declaredBlockers
            bdRunParams[AbilityKey.Attackers] = blockedAttackers
            self.game.getTriggerHandler().runTrigger(TriggerType.BlockersDeclared, bdRunParams, False)

        for c1 in self.combat.getAllBlockers():
            if c1.getDamageHistory().getCreatureBlockedThisCombat():
                continue

            runParams = AbilityKey.newMap()
            runParams[AbilityKey.Blocker] = c1
            runParams[AbilityKey.Attackers] = self.combat.getAttackersBlockedBy(c1)
            self.game.getTriggerHandler().runTrigger(TriggerType.Blocks, runParams, False)

            c1.getDamageHistory().setCreatureBlockedThisCombat(True)
            c1.getDamageHistory().clearNotBlockedSinceLastUpkeepOf()

        blocked = []
        lkiCache: dict[int, Card] = {}

        for a in self.combat.getAttackers():
            if self.combat.isBlocked(a):
                a.getDamageHistory().clearNotBeenBlockedSinceLastUpkeepOf()

            blockers = self.combat.getBlockers(a)
            if blockers.isEmpty():
                continue

            blocked.append(a)

            # Run triggers
            runParams = AbilityKey.newMap()
            runParams[AbilityKey.Attacker] = a
            runParams[AbilityKey.Blockers] = blockers
            runParams[AbilityKey.Defender] = self.combat.getDefenderByAttacker(a)
            runParams[AbilityKey.DefendingPlayer] = self.combat.getDefenderPlayerByAttacker(a)
            self.game.getTriggerHandler().runTrigger(TriggerType.AttackerBlocked, runParams, False)

            # Run this trigger once for each blocker
            for b in blockers:
                b.addBlockedThisTurn(CardCopyService.getLKICopy(a, lkiCache))
                a.addBlockedByThisTurn(CardCopyService.getLKICopy(b, lkiCache))

                runParams = AbilityKey.newMap()
                runParams[AbilityKey.Attacker] = a
                runParams[AbilityKey.Blocker] = b
                self.game.getTriggerHandler().runTrigger(TriggerType.AttackerBlockedByCreature, runParams, False)

            a.getDamageHistory().setCreatureGotBlockedThisCombat(True)

        if len(blocked) != 0:
            runParams = AbilityKey.newMap()
            runParams[AbilityKey.Attackers] = blocked
            self.game.getTriggerHandler().runTrigger(TriggerType.AttackerBlockedOnce, runParams, False)

        self.game.updateCombatForView()
        self.game.fireEvent(GameEventCombatChanged())

    def restart(self) -> None:
        self.extraPhases.clear()
        self.extraTurns.clear()
        self.turn = 0

    def handleNextTurn(self) -> Player:
        self.game.getStack().onNextTurn()

        self.game.getTriggerHandler().clearThisTurnDelayedTrigger()

        next = self.getNextActivePlayer()
        while not next.isInGame():
            next = self.getNextActivePlayer()

        self.game.getTriggerHandler().handlePlayerDefinedDelTriggers(next)

        for c in self.game.getCardsIncludePhasingIn(ZoneType.Battlefield):
            c.setStartedTheTurnUntapped(c.isUntapped())

        self.game.setMonarchBeginTurn(self.game.getMonarch())

        if self.game.getRules().hasAppliedVariant(GameType.Planechase):
            for pl in self.game.getActivePlanes():
                if pl is not None:
                    pl.setController(next, 0)
                    self.game.getAction().controllerChangeZoneCorrection(pl)
        return next

    def getNextActivePlayer(self) -> Player:
        extraTurn = self.extraTurns.pop() if len(self.extraTurns) != 0 else None
        nextPlayer = extraTurn.getPlayer() if extraTurn is not None else self.game.getNextPlayerAfter(self.playerTurn)
        # The bottom of the extra turn stack is the normal turn
        isExtraTurn = len(self.extraTurns) != 0

        # update ExtraTurn Count
        nextPlayer.setExtraTurnCount(self.getExtraTurnForPlayer(nextPlayer))

        # Replacement effects
        repRunParams = AbilityKey.mapFromAffected(nextPlayer)
        repRunParams[AbilityKey.ExtraTurn] = isExtraTurn
        repres = self.game.getReplacementHandler().run(ReplacementType.BeginTurn, repRunParams)
        if repres != ReplacementResult.NotReplaced:
            if extraTurn is None:
                self.setPlayerTurn(nextPlayer)
            return self.getNextActivePlayer()

        nextPlayer.setExtraTurn(isExtraTurn)
        if extraTurn is not None:
            for deltrig in extraTurn.getDelayedTriggers():
                self.game.getTriggerHandler().registerThisTurnDelayedTrigger(deltrig)
            if extraTurn.isSkipUntap():
                SkipPhaseEffect.createSkipPhaseEffect(extraTurn.getSkipUntapSA(), nextPlayer, None, None, "Untap")
            if extraTurn.isCantSetSchemesInMotion():
                AddTurnEffect.createCantSetSchemesInMotionEffect(extraTurn.getCantSetSchemesInMotionSA())
        return nextPlayer

    def is_(self, phase0: PhaseType, player0: Player = None) -> bool:
        if player0 is None:
            return self.phase == phase0
        return self.phase == phase0 and self.playerTurn.equals(player0)

    def getNextTurn(self) -> Player:
        if len(self.extraTurns) == 0:
            return self.game.getNextPlayerAfter(self.playerTurn)
        return self.extraTurns[-1].getPlayer()

    def addExtraTurn(self, player: Player) -> ExtraTurn:
        previous = None
        # use a stack to handle extra turns, make sure the bottom of the stack
        # restores original turn order
        if len(self.extraTurns) == 0:
            self.extraTurns.append(ExtraTurn(self.game.getNextPlayerAfter(self.playerTurn)))
        else:
            previous = self.extraTurns[-1].getPlayer()

        result = ExtraTurn(player)
        self.extraTurns.append(result)
        # update Extra Turn for all players
        for p in self.game.getPlayers():
            p.setExtraTurnCount(self.getExtraTurnForPlayer(p))

        # get all players where the view should be updated
        toUpdate = [player]
        if previous is not None:
            toUpdate.append(previous)

        # fireEvent to update the Details
        self.game.fireEvent(GameEventPlayerStatsChanged(toUpdate, False))

        return result

    def addExtraPhase(self, afterPhase: PhaseType, extraPhaseList: list[PhaseType], nextPhase: PhaseType) -> ExtraPhase:
        # 500.8. Some effects can add phases to a turn. They do this by adding the phases directly after the specified phase.
        # If multiple extra phases are created after the same phase, the most recently created phase will occur first.
        for i in range(len(extraPhaseList)):
            extra = extraPhaseList[i]
            if extra not in self.extraPhases:
                self.extraPhases[extra] = []
            if i < len(extraPhaseList) - 1:
                self.extraPhases[extra].append(ExtraPhase(extraPhaseList[i + 1]))
            else:
                if afterPhase in self.extraPhases and len(self.extraPhases[afterPhase]) != 0:
                    # Extra phase(s) was inserted already, link to the first step of inserted extra phase(s)
                    self.extraPhases[extra].append(self.extraPhases[afterPhase].pop())
                else:
                    self.extraPhases[extra].append(ExtraPhase(nextPhase))
        if afterPhase not in self.extraPhases:
            self.extraPhases[afterPhase] = []
        result = ExtraPhase(extraPhaseList[0])
        self.extraPhases[afterPhase].append(result)
        return result

    def hasExtraPhaseAfter(self, afterPhase: PhaseType, extraPhase: PhaseType) -> bool:
        phases = self.extraPhases.get(afterPhase)
        return phases is not None and len(phases) != 0 and phases[-1].getPhase() == extraPhase

    def isFirstCombat(self) -> bool:
        return self.nCombatsThisTurn == 1

    def getNumCombat(self) -> int:
        return self.nCombatsThisTurn

    def getNumUpkeep(self) -> int:
        return self.nUpkeepsThisTurn

    def isFirstUpkeep(self) -> bool:
        return self.is_(PhaseType.UPKEEP) and self.nUpkeepsThisTurn == 0

    def isFirstUpkeepThisGame(self) -> bool:
        return self.is_(PhaseType.UPKEEP) and self.nUpkeepsThisGame == 0

    def getNumMain(self) -> int:
        return self.nMainsThisTurn

    def beforeFirstPostCombatMainEnd(self) -> bool:
        return self.nMainsThisTurn <= (2 if self.is_(PhaseType.MAIN2) else 1)

    def skippedDeclareBlockers(self) -> bool:
        return self.skipDamageSteps

    def getNumEndOfTurn(self) -> int:
        return self.nEndOfTurnsThisTurn

    def setupFirstTurn(self, goesFirst: Player, startGameHook) -> None:
        if self.phase is not None:
            raise RuntimeError("Turns already started, call this only once per game")

        self.setPlayerTurn(goesFirst)
        self.advanceToNextPhase()
        self.onPhaseBegin()

        # don't even offer priority, because it's untap of 1st turn now
        self.givePriorityToPlayer = False

        if startGameHook is not None:
            startGameHook()
            self.givePriorityToPlayer = True

    def startFirstTurn(self, goesFirst: Player, startGameHook=None) -> None:
        self.setupFirstTurn(goesFirst, startGameHook)
        self.mainGameLoop()

    def mainGameLoop(self) -> None:
        # MAIN GAME LOOP
        while not self.game.isGameOver() and not (self.game.getAge() == GameStage.RestartedByKarn):
            self.mainLoopStep()

    def mainLoopStep(self) -> None:
        if self.givePriorityToPlayer:
            if PhaseHandler.DEBUG_PHASES:
                self.sw.start()

            self.game.fireEvent(GameEventPlayerPriority(PlayerView.get(self.playerTurn), self.phase, PlayerView.get(self.getPriorityPlayer())))
            chosenSa = None

            loopCount = 0
            while True:
                if self.checkStateBasedEffects():
                    # state-based effects check could lead to game over
                    return
                self.game.stashGameState()

                chosenSa = self.pPlayerPriority.getController().chooseSpellAbilityToPlay()

                # this needs to come after chosenSa so it sees you conceding on own turn
                if self.playerTurn.hasLost() and self.pPlayerPriority.equals(self.playerTurn) and self.pFirstPriority.equals(self.playerTurn):
                    # If the active player has lost, and they have priority, set the next player to have priority
                    print("Active player is no longer in the game...")
                    self.pPlayerPriority = self.game.getNextPlayerAfter(self.getPriorityPlayer())
                    self.pFirstPriority = self.pPlayerPriority

                if chosenSa is None:
                    break  # that means 'I pass'
                if PhaseHandler.DEBUG_PHASES:
                    print("... " + str(self.pPlayerPriority) + " plays " + str(chosenSa), end="")

                rollback = False
                for sa in chosenSa:
                    saHost = sa.getHostCard()
                    originZone = saHost.getZone()
                    triggerList = CardZoneTable(self.game.getLastStateBattlefield(), self.game.getLastStateGraveyard())

                    if self.pPlayerPriority.getController().playChosenSpellAbility(sa):
                        # 117.3c If a player has priority when they cast a spell, activate an ability, [play a land]
                        # that player receives priority afterward.
                        self.pFirstPriority = self.pPlayerPriority  # all opponents have to pass before stack is allowed to resolve
                    elif self.game.EXPERIMENTAL_RESTORE_SNAPSHOT:
                        rollback = True

                    saHost = self.game.getCardState(saHost)
                    currentZone = saHost.getZone()

                    # Need to check if Zone did change
                    if currentZone is not None and originZone is not None and not currentZone.equals(originZone) and (sa.isSpell() or sa.isLandAbility()):
                        # currently there can be only one Spell put on the Stack at once, or Land Abilities be played
                        triggerList.put(originZone.getZoneType(), currentZone.getZoneType(), saHost)
                        triggerList.triggerChangesZoneAll(self.game, sa)
                # Don't copy last state if we're in the middle of rolling back a spell...
                if not rollback:
                    self.game.copyLastState()
                loopCount += 1
                if not (loopCount < 999 or not self.pPlayerPriority.getController().isAI()):
                    break

            if loopCount >= 999 and self.pPlayerPriority.getController().isAI():
                IHasForgeLog.aiLog.warn("AI looped too much with: " + str(chosenSa))

            if PhaseHandler.DEBUG_PHASES:
                self.sw.stop()
                print("... passed in " + str(self.sw.getTime() / 1000.0) + " s")
                print("\t\tStack: " + str(self.game.getStack()))
                self.sw.reset()
        elif PhaseHandler.DEBUG_PHASES:
            print(" >> (no priority given to " + str(self.getPriorityPlayer()) + ")")

        # actingPlayer is the player who may act
        # the firstAction is the player who gained Priority First in this segment
        # of Priority
        nextPlayer = self.game.getNextPlayerAfter(self.getPriorityPlayer())

        if self.game.isGameOver() or nextPlayer is None:
            return  # conceded?

        if PhaseHandler.DEBUG_PHASES:
            print(TextUtil.concatWithSpace(self.playerTurn.toString(), TextUtil.addSuffix(self.phase.toString(), ":"), self.pPlayerPriority.toString(), "is active, previous was", nextPlayer.toString()))
        if self.pFirstPriority == nextPlayer:
            if self.game.getStack().isEmpty():
                if self.playerTurn.hasLost():
                    self.setPriority(self.game.getNextPlayerAfter(self.playerTurn))
                else:
                    self.setPriority(self.playerTurn)

                # end phase
                self.givePriorityToPlayer = True
                self.onPhaseEnd()
                self.advanceToNextPhase()
                self.onPhaseBegin()
            elif not self.game.getStack().hasSimultaneousStackEntries():
                self.game.getStack().resolveStack()
        else:
            # pass the priority to other player
            self.pPlayerPriority = nextPlayer

        # If ever the karn's ultimate resolved
        if self.game.getAge() == GameStage.RestartedByKarn:
            self.setPhase(None)
            self.game.updatePhaseForView()
            self.game.fireEvent(GameEventGameRestarted(PlayerView.get(self.playerTurn)))
            return

        # update Priority for all players
        for p in self.game.getPlayers():
            p.setHasPriority(self.getPriorityPlayer() == p)

    def checkStateBasedEffects(self) -> bool:
        allAffectedCards = set()
        while True:
            # Rule 704.3  Whenever a player would get priority, the game checks ... for state-based actions,
            self.game.getAction().checkStateEffects(False, allAffectedCards)
            if self.game.isGameOver():
                return True  # state-based effects check could lead to game over
            if not self.game.getStack().addAllTriggeredAbilitiesToStack():  # loop so long as something was added to stack
                break

        if len(allAffectedCards) != 0:
            self.game.fireEvent(GameEventCardStatsChanged(allAffectedCards))
            allAffectedCards.clear()
            # Update flashback views after static abilities have been recalculated,
            # so play-from-zone abilities (e.g. Bolas's Citadel) are reflected
            self.game.getPlayers().forEach(Player.updateFlashbackForView)
        return False

    def devAdvanceToPhase(self, targetPhase: PhaseType, resolver=None) -> bool:
        isTopsy = self.playerTurn.isPhasesReversed()
        while self.phase.isBefore(targetPhase, isTopsy):
            if self.checkStateBasedEffects():
                return False
            if resolver is not None:
                resolver()
            self.onPhaseEnd()
            self.advanceToNextPhase()
            self.onPhaseBegin()
        self.checkStateBasedEffects()
        return True

    # this is a hack for the setup game state mode, do not use outside of devSetupGameState code
    # as it avoids calling any of the phase effects that may be necessary in a less enforced context
    def devModeSet(self, phase0: PhaseType, player0: Player, endCombat: bool = True, cturn: int = 1) -> None:
        if phase0 is not None:
            self.setPhase(phase0)
        if player0 is not None:
            self.setPlayerTurn(player0)
        self.turn = cturn

        self.game.fireEvent(GameEventTurnPhase(self.playerTurn, self.phase, "dev"))
        if endCombat:
            self.endCombat()  # not-null can be created only when declare attackers phase begins

    def endCombatPhaseByEffect(self) -> None:
        self.endCombat()
        self.game.getAction().checkStateEffects(True)
        self.setPhase(PhaseType.COMBAT_END)
        self.advanceToNextPhase()

    def endTurnByEffect(self) -> None:
        self.extraPhases.clear()
        self.setPhase(PhaseType.CLEANUP)
        self.game.fireEvent(GameEventTurnPhase(self.playerTurn, self.phase, ""))
        self.onPhaseBegin()

    def getPlanarDiceSpecialActionThisTurn(self) -> int:
        return self.planarDiceSpecialActionThisTurn

    def incPlanarDiceSpecialActionThisTurn(self) -> None:
        self.planarDiceSpecialActionThisTurn += 1

    def debugPrintState(self, hasPriority: bool) -> str:
        return "%s's %s [%sP] %s" % (self.playerTurn, self.phase.nameForUi, "+" if hasPriority else "-", self.getPriorityPlayer())

    # just to avoid exposing variable to outer classes
    def onStackResolved(self) -> None:
        self.givePriorityToPlayer = True

    def endCombat(self) -> None:
        self.game.getEndOfCombat().executeUntil()
        self.game.getEndOfCombat().executeUntilEndOfPhase(self.playerTurn)
        if self.inCombat():
            self.combat.endCombat()
            self.combat = None
        self.game.updateCombatForView()

    def setCombat(self, combat: Combat) -> None:
        self.combat = combat

    def getExtraTurnForPlayer(self, p: Player) -> int:
        if len(self.extraTurns) == 0 or len(self.extraTurns) < 2:
            return 0

        count = 0
        # skip the first element
        for et in self.extraTurns[1:]:
            if not et.getPlayer().equals(p):
                break
            count += 1
        return count

    def handleMultiplayerEffects(self) -> None:
        # CR 800.4m When a player leaves the game, any continuous effects with durations that last until that
        # player's next turn or until a specific point in that turn will last until that turn would have begun
        oldPlayerIdx = self.game.getRegisteredPlayers().indexOf(self.playerPreviousTurn)
        playerIdx = self.game.getRegisteredPlayers().indexOf(self.playerTurn)
        direction = self.game.getTurnOrder().getShift()
        while oldPlayerIdx != playerIdx:
            oldPlayerIdx += direction
            if oldPlayerIdx < 0:
                oldPlayerIdx = self.game.getRegisteredPlayers().size() - 1
            elif oldPlayerIdx > self.game.getRegisteredPlayers().size() - 1:
                oldPlayerIdx = 0
            p = self.game.getRegisteredPlayers().get(oldPlayerIdx)
            if p.hasLost():
                # CR 702.26n
                Untap.doPhasing(p)

                self.game.getUntap().executeUntil(p)
                self.game.getUpkeep().executeUntil(p)
                self.game.getUpkeep().executeUntilEndOfPhase(p)
                self.game.getEndOfCombat().executeUntilEndOfPhase(p)
                self.game.getEndOfTurn().executeUntil(p)
                self.game.getEndOfTurn().executeUntilEndOfPhase(p)
                self.game.getCleanup().executeUntil(p)
```
