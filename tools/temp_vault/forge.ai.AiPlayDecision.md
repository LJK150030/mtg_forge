---
aliases:
  - AiPlayDecision
tags:
  - java/enum
  - module/forge-ai
  - pkg/forge/ai
fqn: forge.ai.AiPlayDecision
package: forge.ai
module: forge-ai
kind: Enum
---

# AiPlayDecision

**Package:** `forge.ai` &nbsp; **Module:** `forge-ai` &nbsp; **Kind:** Enum

```mermaid
classDiagram
    class AiPlayDecision {
        <<enumeration>>
        WillPlay
        MandatoryPlay
        PlayToEmptyHand
        ImpactCombat
        ResponseToStackResolve
        AddBoardPresence
        Removal
        Tempo
        CardAdvantage
        WaitForCombat
        WaitForMain2
        WaitForEndOfTurn
        StackNotEmpty
        AnotherTime
        CantPlaySa
        CantPlayAi
        CantAfford
        CantAffordX
        DoesntImpactCombat
        DoesntImpactGame
        MissingLogic
        MissingNeededCards
        TimingRestrictions
        MissingPhaseRestrictions
        ConditionsNotMet
        NeedsToPlayCriteriaNotMet
        StopRunawayActivations
        TargetingFailed
        CostNotAcceptable
        LifeInDanger
        WouldDestroyLegend
        WouldDestroyOtherPlaneswalker
        WouldBecomeZeroToughnessCreature
        WouldDestroyWorldEnchantment
        BadEtbEffects
        CurseEffects
        +willingToPlay() boolean
    }
```


## Design Description

`AiPlayDecision` is an enumeration in the `forge-ai` module that captures the AI engine's verdict on whether, when, and why a spell or ability should be played. Its constants are organized into three intent groups by inline comments: reasons to play immediately (`WillPlay`, `Removal`, `Tempo`, `CardAdvantage`), reasons to defer (`WaitForMain2`, `StackNotEmpty`, `AnotherTime`), and reasons to decline (`CantAfford`, `TargetingFailed`, `LifeInDanger`). This gives the decision logic a single, self-documenting vocabulary for both choosing and explaining actions.

As a pure enum it holds no state and collaborates with no other types; its sole behavior is the `willingToPlay()` predicate, which uses a `switch` expression to map the affirmative constants to `true` and all others to `false`. The design intent is to centralize the "should act" test in one place while preserving the finer-grained reason, so callers branch on a typed result rather than scattered booleans yet retain the specific rationale for logging and diagnostics.

## Source
`forge-ai/src/main/java/forge/ai/AiPlayDecision.java`

```java
package forge.ai;

public enum AiPlayDecision {
    // Play decision reasons
    WillPlay,
    MandatoryPlay,
    PlayToEmptyHand,
    ImpactCombat,
    ResponseToStackResolve,
    AddBoardPresence,
    Removal,
    Tempo,
    CardAdvantage,

    // Play later decisions
    WaitForCombat,
    WaitForMain2,
    WaitForEndOfTurn,
    StackNotEmpty,
    AnotherTime,

    // Don't play decision reasons
    CantPlaySa,
    CantPlayAi,
    CantAfford,
    CantAffordX,
    DoesntImpactCombat,
    DoesntImpactGame,
    MissingLogic,
    MissingNeededCards,
    TimingRestrictions,
    MissingPhaseRestrictions,
    ConditionsNotMet,
    NeedsToPlayCriteriaNotMet,
    StopRunawayActivations,
    TargetingFailed,
    CostNotAcceptable,
    LifeInDanger,
    WouldDestroyLegend,
    WouldDestroyOtherPlaneswalker,
    WouldBecomeZeroToughnessCreature,
    WouldDestroyWorldEnchantment,
    BadEtbEffects,
    CurseEffects;

    public boolean willingToPlay() {
        return switch (this) {
            case WillPlay, MandatoryPlay, PlayToEmptyHand, AddBoardPresence, ImpactCombat, ResponseToStackResolve, Removal, Tempo, CardAdvantage -> true;
            default -> false;
        };
    }
}
```

## Python
`forge/ai/AiPlayDecision.py`

```python
from enum import Enum


class AiPlayDecision(Enum):
    # Play decision reasons
    WillPlay = 1
    MandatoryPlay = 2
    PlayToEmptyHand = 3
    ImpactCombat = 4
    ResponseToStackResolve = 5
    AddBoardPresence = 6
    Removal = 7
    Tempo = 8
    CardAdvantage = 9

    # Play later decisions
    WaitForCombat = 10
    WaitForMain2 = 11
    WaitForEndOfTurn = 12
    StackNotEmpty = 13
    AnotherTime = 14

    # Don't play decision reasons
    CantPlaySa = 15
    CantPlayAi = 16
    CantAfford = 17
    CantAffordX = 18
    DoesntImpactCombat = 19
    DoesntImpactGame = 20
    MissingLogic = 21
    MissingNeededCards = 22
    TimingRestrictions = 23
    MissingPhaseRestrictions = 24
    ConditionsNotMet = 25
    NeedsToPlayCriteriaNotMet = 26
    StopRunawayActivations = 27
    TargetingFailed = 28
    CostNotAcceptable = 29
    LifeInDanger = 30
    WouldDestroyLegend = 31
    WouldDestroyOtherPlaneswalker = 32
    WouldBecomeZeroToughnessCreature = 33
    WouldDestroyWorldEnchantment = 34
    BadEtbEffects = 35
    CurseEffects = 36

    def willingToPlay(self) -> bool:
        return self in (
            AiPlayDecision.WillPlay,
            AiPlayDecision.MandatoryPlay,
            AiPlayDecision.PlayToEmptyHand,
            AiPlayDecision.AddBoardPresence,
            AiPlayDecision.ImpactCombat,
            AiPlayDecision.ResponseToStackResolve,
            AiPlayDecision.Removal,
            AiPlayDecision.Tempo,
            AiPlayDecision.CardAdvantage,
        )
```
