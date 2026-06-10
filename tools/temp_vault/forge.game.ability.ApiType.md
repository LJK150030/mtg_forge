---
aliases:
  - ApiType
tags:
  - java/enum
  - module/forge-game
  - pkg/forge/game/ability
fqn: forge.game.ability.ApiType
package: forge.game.ability
module: forge-game
kind: Enum
---

# ApiType

**Package:** `forge.game.ability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Enum

```mermaid
classDiagram
    class ApiType {
        <<enumeration>>
        Abandon
        ActivateAbility
        AddOrRemoveCounter
        AddPhase
        AddTurn
        AdvanceCrank
        Airbend
        AlterAttribute
        Amass
        Animate
        AnimateAll
        Attach
        Ascend
        AssembleContraption
        AssignGroup
        Balance
        BecomeMonarch
        BecomesBlocked
        BidLife
        Blight
        Block
        Bond
        Branch
        Camouflage
        ChangeCombatants
        ChangeSpeed
        ChangeTargets
        ChangeText
        ChangeX
        ChangeZone
        ChangeZoneAll
        ChaosEnsues
        Charm
        ChooseCard
        ChooseColor
        ChooseDirection
        ChooseEvenOdd
        ChooseNumber
        ChoosePlayer
        ChooseSector
        ChooseSource
        ChooseType
        ClaimThePrize
        Clash
        ClassLevelUp
        Cleanup
        Cloak
        Clone
        Connive
        CopyPermanent
        CopySpellAbility
        ControlSpell
        ControlPlayer
        Counter
        DamageAll
        DealDamage
        Detain
        DayTime
        Debuff
        DelayedTrigger
        Destroy
        DestroyAll
        Dig
        DigMultiple
        DigUntil
        Discard
        Discover
        DrainMana
        Draft
        Draw
        EachDamage
        Earthbend
        Effect
        Encode
        EndCombatPhase
        EndTurn
        Endure
        ExchangeLife
        ExchangeLifeVariant
        ExchangeControl
        ExchangeControlVariant
        ExchangePower
        ExchangeZone
        ExchangeTextBox
        Explore
        Fight
        FlipCoin
        FlipOntoBattlefield
        Fog
        GainControl
        GainControlVariant
        GainLife
        GainOwnership
        GameDrawn
        GenericChoice
        Goad
        Haunt
        Heist
        Investigate
        Intensify
        ImmediateTrigger
        Incubate
        Learn
        LookAt
        LoseLife
        LosePerpetual
        LosesGame
        MakeCard
        Mana
        ManaReflected
        Manifest
        ManifestDread
        Meld
        Mill
        MoveCounter
        MultiplePiles
        MultiplyCounter
        MustBlock
        Mutate
        NameCard
        OpenAttraction
        PeekAndReveal
        PermanentCreature
        PermanentNoncreature
        Phases
        Planeswalk
        Play
        PlayLandVariant
        Poison
        PreventDamage
        Proliferate
        Protection
        ProtectionAll
        Pump
        PumpAll
        PutCounter
        PutCounterAll
        Radiation
        RearrangeTopOfLibrary
        Regenerate
        Regeneration
        RemoveCounter
        RemoveCounterAll
        RemoveFromCombat
        RemoveFromGame
        RemoveFromMatch
        ReorderZone
        Repeat
        RepeatEach
        ReplaceCounter
        ReplaceEffect
        ReplaceMana
        ReplaceDamage
        ReplaceToken
        ReplaceSplitDamage
        RestartGame
        Reveal
        RevealHand
        ReverseTurnOrder
        RingTemptsYou
        RollDice
        RollPlanarDice
        RunChaos
        Sacrifice
        SacrificeAll
        Scry
        Seek
        SetInMotion
        SetLife
        SetState
        Shuffle
        SkipPhase
        SkipTurn
        StoreSVar
        Subgame
        Surveil
        SwitchBlock
        TakeInitiative
        Tap
        TapAll
        TapOrUntap
        TapOrUntapAll
        TimeTravel
        Token
        TwoPiles
        Unattach
        UnlockDoor
        Untap
        UntapAll
        Venture
        VillainousChoice
        Vote
        WinsGame
        BlankLine
        DamageResolve
        ChangeZoneResolve
        CompanionChoose
        InternalLegendaryRule
        InternalIgnoreEffect
        InternalRadiation
        -SpellAbilityEffect instanceEffect
        -Class~SpellAbilityEffect~ clsEffect
        -Map~String,ApiType~ allValues
        +smartValueOf(String value) ApiType
        +getSpellEffect() SpellAbilityEffect
        ~ApiType(Class~SpellAbilityEffect~ clsEf)
        ~ApiType(Class~SpellAbilityEffect~ clsEf, boolean isStateLess)
    }
    ApiType ..> AbandonEffect : uses
    ApiType ..> ActivateAbilityEffect : uses
    ApiType ..> AddPhaseEffect : uses
    ApiType ..> AddTurnEffect : uses
    ApiType ..> AdvanceCrankEffect : uses
    ApiType ..> AirbendEffect : uses
    ApiType ..> AlterAttributeEffect : uses
    ApiType ..> AmassEffect : uses
    ApiType ..> AnimateAllEffect : uses
    ApiType ..> AnimateEffect : uses
    ApiType ..> AscendEffect : uses
    ApiType ..> AssembleContraptionEffect : uses
    ApiType ..> AssignGroupEffect : uses
    ApiType ..> AttachEffect : uses
    ApiType ..> BalanceEffect : uses
    ApiType ..> BecomeMonarchEffect : uses
    ApiType ..> BecomesBlockedEffect : uses
    ApiType ..> BidLifeEffect : uses
    ApiType ..> BlankLineEffect : uses
    ApiType ..> BlightEffect : uses
    ApiType ..> BlockEffect : uses
    ApiType ..> BondEffect : uses
    ApiType ..> BranchEffect : uses
    ApiType ..> CamouflageEffect : uses
    ApiType ..> ChangeCombatantsEffect : uses
    ApiType ..> ChangeSpeedEffect : uses
    ApiType ..> ChangeTargetsEffect : uses
    ApiType ..> ChangeTextEffect : uses
    ApiType ..> ChangeXEffect : uses
    ApiType ..> ChangeZoneAllEffect : uses
    ApiType ..> ChangeZoneEffect : uses
    ApiType ..> ChangeZoneResolveEffect : uses
    ApiType ..> ChaosEnsuesEffect : uses
    ApiType ..> CharmEffect : uses
    ApiType ..> ChooseCardEffect : uses
    ApiType ..> ChooseCardNameEffect : uses
    ApiType ..> ChooseColorEffect : uses
    ApiType ..> ChooseDirectionEffect : uses
    ApiType ..> ChooseEvenOddEffect : uses
    ApiType ..> ChooseGenericEffect : uses
    ApiType ..> ChooseNumberEffect : uses
    ApiType ..> ChoosePlayerEffect : uses
    ApiType ..> ChooseSectorEffect : uses
    ApiType ..> ChooseSourceEffect : uses
    ApiType ..> ChooseTypeEffect : uses
    ApiType ..> ClaimThePrizeEffect : uses
    ApiType ..> ClashEffect : uses
    ApiType ..> ClassLevelUpEffect : uses
    ApiType ..> CleanUpEffect : uses
    ApiType ..> CloakEffect : uses
    ApiType ..> CloneEffect : uses
    ApiType ..> ConniveEffect : uses
    ApiType ..> ControlExchangeEffect : uses
    ApiType ..> ControlExchangeVariantEffect : uses
    ApiType ..> ControlGainEffect : uses
    ApiType ..> ControlGainVariantEffect : uses
    ApiType ..> ControlPlayerEffect : uses
    ApiType ..> ControlSpellEffect : uses
    ApiType ..> CopyPermanentEffect : uses
    ApiType ..> CopySpellAbilityEffect : uses
    ApiType ..> CounterEffect : uses
    ApiType ..> CountersMoveEffect : uses
    ApiType ..> CountersMultiplyEffect : uses
    ApiType ..> CountersProliferateEffect : uses
    ApiType ..> CountersPutAllEffect : uses
    ApiType ..> CountersPutEffect : uses
    ApiType ..> CountersPutOrRemoveEffect : uses
    ApiType ..> CountersRemoveAllEffect : uses
    ApiType ..> CountersRemoveEffect : uses
    ApiType ..> DamageAllEffect : uses
    ApiType ..> DamageDealEffect : uses
    ApiType ..> DamageEachEffect : uses
    ApiType ..> DamagePreventEffect : uses
    ApiType ..> DamageResolveEffect : uses
    ApiType ..> DayTimeEffect : uses
    ApiType ..> DebuffEffect : uses
    ApiType ..> DelayedTriggerEffect : uses
    ApiType ..> DestroyAllEffect : uses
    ApiType ..> DestroyEffect : uses
    ApiType ..> DetainEffect : uses
    ApiType ..> DigEffect : uses
    ApiType ..> DigMultipleEffect : uses
    ApiType ..> DigUntilEffect : uses
    ApiType ..> DiscardEffect : uses
    ApiType ..> DiscoverEffect : uses
    ApiType ..> DraftEffect : uses
    ApiType ..> DrainManaEffect : uses
    ApiType ..> DrawEffect : uses
    ApiType ..> EarthbendEffect : uses
    ApiType ..> EffectEffect : uses
    ApiType ..> EncodeEffect : uses
    ApiType ..> EndCombatPhaseEffect : uses
    ApiType ..> EndTurnEffect : uses
    ApiType ..> EndureEffect : uses
    ApiType ..> ExploreEffect : uses
    ApiType ..> FightEffect : uses
    ApiType ..> FlipCoinEffect : uses
    ApiType ..> FlipOntoBattlefieldEffect : uses
    ApiType ..> FogEffect : uses
    ApiType ..> GameDrawEffect : uses
    ApiType ..> GameLossEffect : uses
    ApiType ..> GameWinEffect : uses
    ApiType ..> GoadEffect : uses
    ApiType ..> HauntEffect : uses
    ApiType ..> HeistEffect : uses
    ApiType ..> ImmediateTriggerEffect : uses
    ApiType ..> IncubateEffect : uses
    ApiType ..> IntensifyEffect : uses
    ApiType ..> InternalRadiationEffect : uses
    ApiType ..> InvestigateEffect : uses
    ApiType ..> LearnEffect : uses
    ApiType ..> LifeExchangeEffect : uses
    ApiType ..> LifeExchangeVariantEffect : uses
    ApiType ..> LifeGainEffect : uses
    ApiType ..> LifeLoseEffect : uses
    ApiType ..> LifeSetEffect : uses
    ApiType ..> LookAtEffect : uses
    ApiType ..> LosePerpetualEffect : uses
    ApiType ..> MakeCardEffect : uses
    ApiType ..> ManaEffect : uses
    ApiType ..> ManaReflectedEffect : uses
    ApiType ..> ManifestDreadEffect : uses
    ApiType ..> ManifestEffect : uses
    ApiType ..> MeldEffect : uses
    ApiType ..> MillEffect : uses
    ApiType ..> MultiplePilesEffect : uses
    ApiType ..> MustBlockEffect : uses
    ApiType ..> MutateEffect : uses
    ApiType ..> OpenAttractionEffect : uses
    ApiType ..> OwnershipGainEffect : uses
    ApiType ..> PeekAndRevealEffect : uses
    ApiType ..> PermanentCreatureEffect : uses
    ApiType ..> PermanentNoncreatureEffect : uses
    ApiType ..> PhasesEffect : uses
    ApiType ..> PlaneswalkEffect : uses
    ApiType ..> PlayEffect : uses
    ApiType ..> PlayLandVariantEffect : uses
    ApiType ..> PoisonEffect : uses
    ApiType ..> PowerExchangeEffect : uses
    ApiType ..> ProtectAllEffect : uses
    ApiType ..> ProtectEffect : uses
    ApiType ..> PumpAllEffect : uses
    ApiType ..> PumpEffect : uses
    ApiType ..> RadiationEffect : uses
    ApiType ..> RearrangeTopOfLibraryEffect : uses
    ApiType ..> RegenerateEffect : uses
    ApiType ..> RegenerationEffect : uses
    ApiType ..> RemoveFromCombatEffect : uses
    ApiType ..> RemoveFromGameEffect : uses
    ApiType ..> RemoveFromMatchEffect : uses
    ApiType ..> ReorderZoneEffect : uses
    ApiType ..> RepeatEachEffect : uses
    ApiType ..> RepeatEffect : uses
    ApiType ..> ReplaceCounterEffect : uses
    ApiType ..> ReplaceDamageEffect : uses
    ApiType ..> ReplaceEffect : uses
    ApiType ..> ReplaceManaEffect : uses
    ApiType ..> ReplaceSplitDamageEffect : uses
    ApiType ..> ReplaceTokenEffect : uses
    ApiType ..> RestartGameEffect : uses
    ApiType ..> RevealEffect : uses
    ApiType ..> RevealHandEffect : uses
    ApiType ..> ReverseTurnOrderEffect : uses
    ApiType ..> RingTemptsYouEffect : uses
    ApiType ..> RollDiceEffect : uses
    ApiType ..> RollPlanarDiceEffect : uses
    ApiType ..> RunChaosEffect : uses
    ApiType ..> SacrificeAllEffect : uses
    ApiType ..> SacrificeEffect : uses
    ApiType ..> ScryEffect : uses
    ApiType ..> SeekEffect : uses
    ApiType ..> SetInMotionEffect : uses
    ApiType ..> SetStateEffect : uses
    ApiType ..> ShuffleEffect : uses
    ApiType ..> SkipPhaseEffect : uses
    ApiType ..> SkipTurnEffect : uses
    ApiType ..> SpellAbilityEffect : uses
    ApiType ..> StoreSVarEffect : uses
    ApiType ..> SubgameEffect : uses
    ApiType ..> SurveilEffect : uses
    ApiType ..> SwitchBlockEffect : uses
    ApiType ..> TakeInitiativeEffect : uses
    ApiType ..> TapAllEffect : uses
    ApiType ..> TapEffect : uses
    ApiType ..> TapOrUntapAllEffect : uses
    ApiType ..> TapOrUntapEffect : uses
    ApiType ..> TextBoxExchangeEffect : uses
    ApiType ..> TimeTravelEffect : uses
    ApiType ..> TokenEffect : uses
    ApiType ..> TwoPilesEffect : uses
    ApiType ..> UnattachEffect : uses
    ApiType ..> UnlockDoorEffect : uses
    ApiType ..> UntapAllEffect : uses
    ApiType ..> UntapEffect : uses
    ApiType ..> VentureEffect : uses
    ApiType ..> VillainousChoiceEffect : uses
    ApiType ..> VoteEffect : uses
    ApiType ..> ZoneExchangeEffect : uses
```

## Relationships
**Uses:**
- [[forge.game.ability.SpellAbilityEffect|SpellAbilityEffect]]
- [[forge.game.ability.effects.AbandonEffect|AbandonEffect]]
- [[forge.game.ability.effects.ActivateAbilityEffect|ActivateAbilityEffect]]
- [[forge.game.ability.effects.AddPhaseEffect|AddPhaseEffect]]
- [[forge.game.ability.effects.AddTurnEffect|AddTurnEffect]]
- [[forge.game.ability.effects.AdvanceCrankEffect|AdvanceCrankEffect]]
- [[forge.game.ability.effects.AirbendEffect|AirbendEffect]]
- [[forge.game.ability.effects.AlterAttributeEffect|AlterAttributeEffect]]
- [[forge.game.ability.effects.AmassEffect|AmassEffect]]
- [[forge.game.ability.effects.AnimateAllEffect|AnimateAllEffect]]
- [[forge.game.ability.effects.AnimateEffect|AnimateEffect]]
- [[forge.game.ability.effects.AscendEffect|AscendEffect]]
- [[forge.game.ability.effects.AssembleContraptionEffect|AssembleContraptionEffect]]
- [[forge.game.ability.effects.AssignGroupEffect|AssignGroupEffect]]
- [[forge.game.ability.effects.AttachEffect|AttachEffect]]
- [[forge.game.ability.effects.BalanceEffect|BalanceEffect]]
- [[forge.game.ability.effects.BecomeMonarchEffect|BecomeMonarchEffect]]
- [[forge.game.ability.effects.BecomesBlockedEffect|BecomesBlockedEffect]]
- [[forge.game.ability.effects.BidLifeEffect|BidLifeEffect]]
- [[forge.game.ability.effects.BlankLineEffect|BlankLineEffect]]
- [[forge.game.ability.effects.BlightEffect|BlightEffect]]
- [[forge.game.ability.effects.BlockEffect|BlockEffect]]
- [[forge.game.ability.effects.BondEffect|BondEffect]]
- [[forge.game.ability.effects.BranchEffect|BranchEffect]]
- [[forge.game.ability.effects.CamouflageEffect|CamouflageEffect]]
- [[forge.game.ability.effects.ChangeCombatantsEffect|ChangeCombatantsEffect]]
- [[forge.game.ability.effects.ChangeSpeedEffect|ChangeSpeedEffect]]
- [[forge.game.ability.effects.ChangeTargetsEffect|ChangeTargetsEffect]]
- [[forge.game.ability.effects.ChangeTextEffect|ChangeTextEffect]]
- [[forge.game.ability.effects.ChangeXEffect|ChangeXEffect]]
- [[forge.game.ability.effects.ChangeZoneAllEffect|ChangeZoneAllEffect]]
- [[forge.game.ability.effects.ChangeZoneEffect|ChangeZoneEffect]]
- [[forge.game.ability.effects.ChangeZoneResolveEffect|ChangeZoneResolveEffect]]
- [[forge.game.ability.effects.ChaosEnsuesEffect|ChaosEnsuesEffect]]
- [[forge.game.ability.effects.CharmEffect|CharmEffect]]
- [[forge.game.ability.effects.ChooseCardEffect|ChooseCardEffect]]
- [[forge.game.ability.effects.ChooseCardNameEffect|ChooseCardNameEffect]]
- [[forge.game.ability.effects.ChooseColorEffect|ChooseColorEffect]]
- [[forge.game.ability.effects.ChooseDirectionEffect|ChooseDirectionEffect]]
- [[forge.game.ability.effects.ChooseEvenOddEffect|ChooseEvenOddEffect]]
- [[forge.game.ability.effects.ChooseGenericEffect|ChooseGenericEffect]]
- [[forge.game.ability.effects.ChooseNumberEffect|ChooseNumberEffect]]
- [[forge.game.ability.effects.ChoosePlayerEffect|ChoosePlayerEffect]]
- [[forge.game.ability.effects.ChooseSectorEffect|ChooseSectorEffect]]
- [[forge.game.ability.effects.ChooseSourceEffect|ChooseSourceEffect]]
- [[forge.game.ability.effects.ChooseTypeEffect|ChooseTypeEffect]]
- [[forge.game.ability.effects.ClaimThePrizeEffect|ClaimThePrizeEffect]]
- [[forge.game.ability.effects.ClashEffect|ClashEffect]]
- [[forge.game.ability.effects.ClassLevelUpEffect|ClassLevelUpEffect]]
- [[forge.game.ability.effects.CleanUpEffect|CleanUpEffect]]
- [[forge.game.ability.effects.CloakEffect|CloakEffect]]
- [[forge.game.ability.effects.CloneEffect|CloneEffect]]
- [[forge.game.ability.effects.ConniveEffect|ConniveEffect]]
- [[forge.game.ability.effects.ControlExchangeEffect|ControlExchangeEffect]]
- [[forge.game.ability.effects.ControlExchangeVariantEffect|ControlExchangeVariantEffect]]
- [[forge.game.ability.effects.ControlGainEffect|ControlGainEffect]]
- [[forge.game.ability.effects.ControlGainVariantEffect|ControlGainVariantEffect]]
- [[forge.game.ability.effects.ControlPlayerEffect|ControlPlayerEffect]]
- [[forge.game.ability.effects.ControlSpellEffect|ControlSpellEffect]]
- [[forge.game.ability.effects.CopyPermanentEffect|CopyPermanentEffect]]
- [[forge.game.ability.effects.CopySpellAbilityEffect|CopySpellAbilityEffect]]
- [[forge.game.ability.effects.CounterEffect|CounterEffect]]
- [[forge.game.ability.effects.CountersMoveEffect|CountersMoveEffect]]
- [[forge.game.ability.effects.CountersMultiplyEffect|CountersMultiplyEffect]]
- [[forge.game.ability.effects.CountersProliferateEffect|CountersProliferateEffect]]
- [[forge.game.ability.effects.CountersPutAllEffect|CountersPutAllEffect]]
- [[forge.game.ability.effects.CountersPutEffect|CountersPutEffect]]
- [[forge.game.ability.effects.CountersPutOrRemoveEffect|CountersPutOrRemoveEffect]]
- [[forge.game.ability.effects.CountersRemoveAllEffect|CountersRemoveAllEffect]]
- [[forge.game.ability.effects.CountersRemoveEffect|CountersRemoveEffect]]
- [[forge.game.ability.effects.DamageAllEffect|DamageAllEffect]]
- [[forge.game.ability.effects.DamageDealEffect|DamageDealEffect]]
- [[forge.game.ability.effects.DamageEachEffect|DamageEachEffect]]
- [[forge.game.ability.effects.DamagePreventEffect|DamagePreventEffect]]
- [[forge.game.ability.effects.DamageResolveEffect|DamageResolveEffect]]
- [[forge.game.ability.effects.DayTimeEffect|DayTimeEffect]]
- [[forge.game.ability.effects.DebuffEffect|DebuffEffect]]
- [[forge.game.ability.effects.DelayedTriggerEffect|DelayedTriggerEffect]]
- [[forge.game.ability.effects.DestroyAllEffect|DestroyAllEffect]]
- [[forge.game.ability.effects.DestroyEffect|DestroyEffect]]
- [[forge.game.ability.effects.DetainEffect|DetainEffect]]
- [[forge.game.ability.effects.DigEffect|DigEffect]]
- [[forge.game.ability.effects.DigMultipleEffect|DigMultipleEffect]]
- [[forge.game.ability.effects.DigUntilEffect|DigUntilEffect]]
- [[forge.game.ability.effects.DiscardEffect|DiscardEffect]]
- [[forge.game.ability.effects.DiscoverEffect|DiscoverEffect]]
- [[forge.game.ability.effects.DraftEffect|DraftEffect]]
- [[forge.game.ability.effects.DrainManaEffect|DrainManaEffect]]
- [[forge.game.ability.effects.DrawEffect|DrawEffect]]
- [[forge.game.ability.effects.EarthbendEffect|EarthbendEffect]]
- [[forge.game.ability.effects.EffectEffect|EffectEffect]]
- [[forge.game.ability.effects.EncodeEffect|EncodeEffect]]
- [[forge.game.ability.effects.EndCombatPhaseEffect|EndCombatPhaseEffect]]
- [[forge.game.ability.effects.EndTurnEffect|EndTurnEffect]]
- [[forge.game.ability.effects.EndureEffect|EndureEffect]]
- [[forge.game.ability.effects.ExploreEffect|ExploreEffect]]
- [[forge.game.ability.effects.FightEffect|FightEffect]]
- [[forge.game.ability.effects.FlipCoinEffect|FlipCoinEffect]]
- [[forge.game.ability.effects.FlipOntoBattlefieldEffect|FlipOntoBattlefieldEffect]]
- [[forge.game.ability.effects.FogEffect|FogEffect]]
- [[forge.game.ability.effects.GameDrawEffect|GameDrawEffect]]
- [[forge.game.ability.effects.GameLossEffect|GameLossEffect]]
- [[forge.game.ability.effects.GameWinEffect|GameWinEffect]]
- [[forge.game.ability.effects.GoadEffect|GoadEffect]]
- [[forge.game.ability.effects.HauntEffect|HauntEffect]]
- [[forge.game.ability.effects.HeistEffect|HeistEffect]]
- [[forge.game.ability.effects.ImmediateTriggerEffect|ImmediateTriggerEffect]]
- [[forge.game.ability.effects.IncubateEffect|IncubateEffect]]
- [[forge.game.ability.effects.IntensifyEffect|IntensifyEffect]]
- [[forge.game.ability.effects.InternalRadiationEffect|InternalRadiationEffect]]
- [[forge.game.ability.effects.InvestigateEffect|InvestigateEffect]]
- [[forge.game.ability.effects.LearnEffect|LearnEffect]]
- [[forge.game.ability.effects.LifeExchangeEffect|LifeExchangeEffect]]
- [[forge.game.ability.effects.LifeExchangeVariantEffect|LifeExchangeVariantEffect]]
- [[forge.game.ability.effects.LifeGainEffect|LifeGainEffect]]
- [[forge.game.ability.effects.LifeLoseEffect|LifeLoseEffect]]
- [[forge.game.ability.effects.LifeSetEffect|LifeSetEffect]]
- [[forge.game.ability.effects.LookAtEffect|LookAtEffect]]
- [[forge.game.ability.effects.LosePerpetualEffect|LosePerpetualEffect]]
- [[forge.game.ability.effects.MakeCardEffect|MakeCardEffect]]
- [[forge.game.ability.effects.ManaEffect|ManaEffect]]
- [[forge.game.ability.effects.ManaReflectedEffect|ManaReflectedEffect]]
- [[forge.game.ability.effects.ManifestDreadEffect|ManifestDreadEffect]]
- [[forge.game.ability.effects.ManifestEffect|ManifestEffect]]
- [[forge.game.ability.effects.MeldEffect|MeldEffect]]
- [[forge.game.ability.effects.MillEffect|MillEffect]]
- [[forge.game.ability.effects.MultiplePilesEffect|MultiplePilesEffect]]
- [[forge.game.ability.effects.MustBlockEffect|MustBlockEffect]]
- [[forge.game.ability.effects.MutateEffect|MutateEffect]]
- [[forge.game.ability.effects.OpenAttractionEffect|OpenAttractionEffect]]
- [[forge.game.ability.effects.OwnershipGainEffect|OwnershipGainEffect]]
- [[forge.game.ability.effects.PeekAndRevealEffect|PeekAndRevealEffect]]
- [[forge.game.ability.effects.PermanentCreatureEffect|PermanentCreatureEffect]]
- [[forge.game.ability.effects.PermanentNoncreatureEffect|PermanentNoncreatureEffect]]
- [[forge.game.ability.effects.PhasesEffect|PhasesEffect]]
- [[forge.game.ability.effects.PlaneswalkEffect|PlaneswalkEffect]]
- [[forge.game.ability.effects.PlayEffect|PlayEffect]]
- [[forge.game.ability.effects.PlayLandVariantEffect|PlayLandVariantEffect]]
- [[forge.game.ability.effects.PoisonEffect|PoisonEffect]]
- [[forge.game.ability.effects.PowerExchangeEffect|PowerExchangeEffect]]
- [[forge.game.ability.effects.ProtectAllEffect|ProtectAllEffect]]
- [[forge.game.ability.effects.ProtectEffect|ProtectEffect]]
- [[forge.game.ability.effects.PumpAllEffect|PumpAllEffect]]
- [[forge.game.ability.effects.PumpEffect|PumpEffect]]
- [[forge.game.ability.effects.RadiationEffect|RadiationEffect]]
- [[forge.game.ability.effects.RearrangeTopOfLibraryEffect|RearrangeTopOfLibraryEffect]]
- [[forge.game.ability.effects.RegenerateEffect|RegenerateEffect]]
- [[forge.game.ability.effects.RegenerationEffect|RegenerationEffect]]
- [[forge.game.ability.effects.RemoveFromCombatEffect|RemoveFromCombatEffect]]
- [[forge.game.ability.effects.RemoveFromGameEffect|RemoveFromGameEffect]]
- [[forge.game.ability.effects.RemoveFromMatchEffect|RemoveFromMatchEffect]]
- [[forge.game.ability.effects.ReorderZoneEffect|ReorderZoneEffect]]
- [[forge.game.ability.effects.RepeatEachEffect|RepeatEachEffect]]
- [[forge.game.ability.effects.RepeatEffect|RepeatEffect]]
- [[forge.game.ability.effects.ReplaceCounterEffect|ReplaceCounterEffect]]
- [[forge.game.ability.effects.ReplaceDamageEffect|ReplaceDamageEffect]]
- [[forge.game.ability.effects.ReplaceEffect|ReplaceEffect]]
- [[forge.game.ability.effects.ReplaceManaEffect|ReplaceManaEffect]]
- [[forge.game.ability.effects.ReplaceSplitDamageEffect|ReplaceSplitDamageEffect]]
- [[forge.game.ability.effects.ReplaceTokenEffect|ReplaceTokenEffect]]
- [[forge.game.ability.effects.RestartGameEffect|RestartGameEffect]]
- [[forge.game.ability.effects.RevealEffect|RevealEffect]]
- [[forge.game.ability.effects.RevealHandEffect|RevealHandEffect]]
- [[forge.game.ability.effects.ReverseTurnOrderEffect|ReverseTurnOrderEffect]]
- [[forge.game.ability.effects.RingTemptsYouEffect|RingTemptsYouEffect]]
- [[forge.game.ability.effects.RollDiceEffect|RollDiceEffect]]
- [[forge.game.ability.effects.RollPlanarDiceEffect|RollPlanarDiceEffect]]
- [[forge.game.ability.effects.RunChaosEffect|RunChaosEffect]]
- [[forge.game.ability.effects.SacrificeAllEffect|SacrificeAllEffect]]
- [[forge.game.ability.effects.SacrificeEffect|SacrificeEffect]]
- [[forge.game.ability.effects.ScryEffect|ScryEffect]]
- [[forge.game.ability.effects.SeekEffect|SeekEffect]]
- [[forge.game.ability.effects.SetInMotionEffect|SetInMotionEffect]]
- [[forge.game.ability.effects.SetStateEffect|SetStateEffect]]
- [[forge.game.ability.effects.ShuffleEffect|ShuffleEffect]]
- [[forge.game.ability.effects.SkipPhaseEffect|SkipPhaseEffect]]
- [[forge.game.ability.effects.SkipTurnEffect|SkipTurnEffect]]
- [[forge.game.ability.effects.StoreSVarEffect|StoreSVarEffect]]
- [[forge.game.ability.effects.SubgameEffect|SubgameEffect]]
- [[forge.game.ability.effects.SurveilEffect|SurveilEffect]]
- [[forge.game.ability.effects.SwitchBlockEffect|SwitchBlockEffect]]
- [[forge.game.ability.effects.TakeInitiativeEffect|TakeInitiativeEffect]]
- [[forge.game.ability.effects.TapAllEffect|TapAllEffect]]
- [[forge.game.ability.effects.TapEffect|TapEffect]]
- [[forge.game.ability.effects.TapOrUntapAllEffect|TapOrUntapAllEffect]]
- [[forge.game.ability.effects.TapOrUntapEffect|TapOrUntapEffect]]
- [[forge.game.ability.effects.TextBoxExchangeEffect|TextBoxExchangeEffect]]
- [[forge.game.ability.effects.TimeTravelEffect|TimeTravelEffect]]
- [[forge.game.ability.effects.TokenEffect|TokenEffect]]
- [[forge.game.ability.effects.TwoPilesEffect|TwoPilesEffect]]
- [[forge.game.ability.effects.UnattachEffect|UnattachEffect]]
- [[forge.game.ability.effects.UnlockDoorEffect|UnlockDoorEffect]]
- [[forge.game.ability.effects.UntapAllEffect|UntapAllEffect]]
- [[forge.game.ability.effects.UntapEffect|UntapEffect]]
- [[forge.game.ability.effects.VentureEffect|VentureEffect]]
- [[forge.game.ability.effects.VillainousChoiceEffect|VillainousChoiceEffect]]
- [[forge.game.ability.effects.VoteEffect|VoteEffect]]
- [[forge.game.ability.effects.ZoneExchangeEffect|ZoneExchangeEffect]]


## Design Description

The `ApiType` enum is the central registry that maps every Magic: The Gathering ability keyword in Forge's card-scripting language to the `SpellAbilityEffect` subclass that resolves it. Each constant pairs a script-facing API name (e.g., `DealDamage`, `ChangeZone`, `Counter`) with a concrete effect class from the `forge.game.ability.effects` package, so the enum acts as the single dispatch table the engine consults to turn a parsed ability declaration into executable game behavior.

Its design favors fast, mostly stateless resolution: a static `Map` populated at class-load time backs `smartValueOf` for case-insensitive name lookup from card scripts, and each constant eagerly caches a shared stateless effect instance via `ReflectionUtil`, while a secondary constructor flag lets non-stateless effects defer to fresh instantiation on each `getSpellEffect` call. Internal-only constants such as `InternalLegendaryRule`, `InternalRadiation`, and `BlankLine`â€”several reusing `CharmEffect`â€”show the enum also backs engine-internal mechanics beyond directly scripted abilities.

## Source
`forge-game/src/main/java/forge/game/ability/ApiType.java`

```java
package forge.game.ability;


import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import forge.game.ability.effects.*;
import forge.util.ReflectionUtil;

/**
 * TODO: Write javadoc for this type.
 *
 */
public enum ApiType {
    Abandon (AbandonEffect.class),
    ActivateAbility (ActivateAbilityEffect.class),
    AddOrRemoveCounter (CountersPutOrRemoveEffect.class),
    AddPhase (AddPhaseEffect.class),
    AddTurn (AddTurnEffect.class),
    AdvanceCrank (AdvanceCrankEffect.class),
    Airbend (AirbendEffect.class),
    AlterAttribute (AlterAttributeEffect.class),
    Amass (AmassEffect.class),
    Animate (AnimateEffect.class),
    AnimateAll (AnimateAllEffect.class),
    Attach (AttachEffect.class),
    Ascend (AscendEffect.class),
    AssembleContraption (AssembleContraptionEffect.class),
    AssignGroup (AssignGroupEffect.class),
    Balance (BalanceEffect.class),
    BecomeMonarch (BecomeMonarchEffect.class),
    BecomesBlocked (BecomesBlockedEffect.class),
    BidLife (BidLifeEffect.class),
    Blight (BlightEffect.class),
    Block (BlockEffect.class),
    Bond (BondEffect.class),
    Branch (BranchEffect.class),
    Camouflage (CamouflageEffect.class),
    ChangeCombatants (ChangeCombatantsEffect.class),
    ChangeSpeed (ChangeSpeedEffect.class),
    ChangeTargets (ChangeTargetsEffect.class),
    ChangeText (ChangeTextEffect.class),
    ChangeX (ChangeXEffect.class),
    ChangeZone (ChangeZoneEffect.class),
    ChangeZoneAll (ChangeZoneAllEffect.class),
    ChaosEnsues (ChaosEnsuesEffect.class),
    Charm (CharmEffect.class),
    ChooseCard (ChooseCardEffect.class),
    ChooseColor (ChooseColorEffect.class),
    ChooseDirection (ChooseDirectionEffect.class),
    ChooseEvenOdd (ChooseEvenOddEffect.class),
    ChooseNumber (ChooseNumberEffect.class),
    ChoosePlayer (ChoosePlayerEffect.class),
    ChooseSector (ChooseSectorEffect.class),
    ChooseSource (ChooseSourceEffect.class),
    ChooseType (ChooseTypeEffect.class),
    ClaimThePrize (ClaimThePrizeEffect.class),
    Clash (ClashEffect.class),
    ClassLevelUp (ClassLevelUpEffect.class),
    Cleanup (CleanUpEffect.class),
    Cloak (CloakEffect.class),
    Clone (CloneEffect.class),
    Connive (ConniveEffect.class),
    CopyPermanent (CopyPermanentEffect.class),
    CopySpellAbility (CopySpellAbilityEffect.class),
    ControlSpell (ControlSpellEffect.class),
    ControlPlayer (ControlPlayerEffect.class),
    Counter (CounterEffect.class),
    DamageAll (DamageAllEffect.class),
    DealDamage (DamageDealEffect.class),
    Detain (DetainEffect.class),
    DayTime (DayTimeEffect.class),
    Debuff (DebuffEffect.class),
    DelayedTrigger (DelayedTriggerEffect.class),
    Destroy (DestroyEffect.class),
    DestroyAll (DestroyAllEffect.class),
    Dig (DigEffect.class),
    DigMultiple (DigMultipleEffect.class),
    DigUntil (DigUntilEffect.class),
    Discard (DiscardEffect.class),
    Discover (DiscoverEffect.class),
    DrainMana (DrainManaEffect.class),
    Draft (DraftEffect.class),
    Draw (DrawEffect.class),
    EachDamage (DamageEachEffect.class),
    Earthbend (EarthbendEffect.class),
    Effect (EffectEffect.class),
    Encode (EncodeEffect.class),
    EndCombatPhase (EndCombatPhaseEffect.class),
    EndTurn (EndTurnEffect.class),
    Endure (EndureEffect.class),
    ExchangeLife (LifeExchangeEffect.class),
    ExchangeLifeVariant (LifeExchangeVariantEffect.class),
    ExchangeControl (ControlExchangeEffect.class),
    ExchangeControlVariant (ControlExchangeVariantEffect.class),
    ExchangePower (PowerExchangeEffect.class),
    ExchangeZone (ZoneExchangeEffect.class),
    ExchangeTextBox (TextBoxExchangeEffect.class),
    Explore (ExploreEffect.class),
    Fight (FightEffect.class),
    FlipCoin(FlipCoinEffect.class),
    FlipOntoBattlefield (FlipOntoBattlefieldEffect.class),
    Fog (FogEffect.class),
    GainControl (ControlGainEffect.class),
    GainControlVariant (ControlGainVariantEffect.class),
    GainLife (LifeGainEffect.class),
    GainOwnership (OwnershipGainEffect.class),
    GameDrawn (GameDrawEffect.class),
    GenericChoice (ChooseGenericEffect.class),
    Goad (GoadEffect.class),
    Haunt (HauntEffect.class),
    Heist (HeistEffect.class),
    Investigate (InvestigateEffect.class),
    Intensify (IntensifyEffect.class),
    ImmediateTrigger (ImmediateTriggerEffect.class),
    Incubate (IncubateEffect.class),
    Learn (LearnEffect.class),
    LookAt (LookAtEffect.class),
    LoseLife (LifeLoseEffect.class),
    LosePerpetual (LosePerpetualEffect.class),
    LosesGame (GameLossEffect.class),
    MakeCard (MakeCardEffect.class),
    Mana (ManaEffect.class),
    ManaReflected (ManaReflectedEffect.class),
    Manifest (ManifestEffect.class),
    ManifestDread (ManifestDreadEffect.class),
    Meld (MeldEffect.class),
    Mill (MillEffect.class),
    MoveCounter (CountersMoveEffect.class),
    MultiplePiles (MultiplePilesEffect.class),
    MultiplyCounter (CountersMultiplyEffect.class),
    MustBlock (MustBlockEffect.class),
    Mutate (MutateEffect.class),
    NameCard (ChooseCardNameEffect.class),
    //NoteCounters (CountersNoteEffect.class),
    OpenAttraction (OpenAttractionEffect.class),
    PeekAndReveal (PeekAndRevealEffect.class),
    PermanentCreature (PermanentCreatureEffect.class),
    PermanentNoncreature (PermanentNoncreatureEffect.class),
    Phases (PhasesEffect.class),
    Planeswalk (PlaneswalkEffect.class),
    Play (PlayEffect.class),
    PlayLandVariant (PlayLandVariantEffect.class),
    Poison (PoisonEffect.class),
    PreventDamage (DamagePreventEffect.class),
    Proliferate (CountersProliferateEffect.class),
    Protection (ProtectEffect.class),
    ProtectionAll (ProtectAllEffect.class),
    Pump (PumpEffect.class),
    PumpAll (PumpAllEffect.class),
    PutCounter (CountersPutEffect.class),
    PutCounterAll (CountersPutAllEffect.class),
    Radiation (RadiationEffect.class),
    RearrangeTopOfLibrary (RearrangeTopOfLibraryEffect.class),
    Regenerate (RegenerateEffect.class),
    Regeneration (RegenerationEffect.class),
    RemoveCounter (CountersRemoveEffect.class),
    RemoveCounterAll (CountersRemoveAllEffect.class),
    RemoveFromCombat (RemoveFromCombatEffect.class),
    RemoveFromGame (RemoveFromGameEffect.class),
    RemoveFromMatch (RemoveFromMatchEffect.class),
    ReorderZone (ReorderZoneEffect.class),
    Repeat (RepeatEffect.class),
    RepeatEach (RepeatEachEffect.class),
    ReplaceCounter (ReplaceCounterEffect.class),
    ReplaceEffect (ReplaceEffect.class),
    ReplaceMana (ReplaceManaEffect.class),
    ReplaceDamage (ReplaceDamageEffect.class),
    ReplaceToken (ReplaceTokenEffect.class),
    ReplaceSplitDamage (ReplaceSplitDamageEffect.class),
    RestartGame (RestartGameEffect.class),
    Reveal (RevealEffect.class),
    RevealHand (RevealHandEffect.class),
    ReverseTurnOrder (ReverseTurnOrderEffect.class),
    RingTemptsYou (RingTemptsYouEffect.class),
    RollDice (RollDiceEffect.class),
    RollPlanarDice (RollPlanarDiceEffect.class),
    RunChaos (RunChaosEffect.class),
    Sacrifice (SacrificeEffect.class),
    SacrificeAll (SacrificeAllEffect.class),
    Scry (ScryEffect.class),
    Seek (SeekEffect.class),
    SetInMotion (SetInMotionEffect.class),
    SetLife (LifeSetEffect.class),
    SetState (SetStateEffect.class),
    Shuffle (ShuffleEffect.class),
    SkipPhase (SkipPhaseEffect.class),
    SkipTurn (SkipTurnEffect.class),
    StoreSVar (StoreSVarEffect.class),
    Subgame (SubgameEffect.class),
    Surveil (SurveilEffect.class),
    SwitchBlock (SwitchBlockEffect.class),
    TakeInitiative (TakeInitiativeEffect.class),
    Tap (TapEffect.class),
    TapAll (TapAllEffect.class),
    TapOrUntap (TapOrUntapEffect.class),
    TapOrUntapAll (TapOrUntapAllEffect.class),
    TimeTravel (TimeTravelEffect.class),
    Token (TokenEffect.class),
    TwoPiles (TwoPilesEffect.class),
    Unattach (UnattachEffect.class),
    UnlockDoor (UnlockDoorEffect.class),
    Untap (UntapEffect.class),
    UntapAll (UntapAllEffect.class),
    Venture (VentureEffect.class),
    VillainousChoice (VillainousChoiceEffect.class),
    Vote (VoteEffect.class),
    WinsGame (GameWinEffect.class),

    BlankLine (BlankLineEffect.class),
    DamageResolve (DamageResolveEffect.class),
    ChangeZoneResolve (ChangeZoneResolveEffect.class),
    CompanionChoose (CharmEffect.class),
    InternalLegendaryRule (CharmEffect.class),
    InternalIgnoreEffect (CharmEffect.class),
    InternalRadiation (InternalRadiationEffect.class),
    ;

    private final SpellAbilityEffect instanceEffect;
    private final Class<? extends SpellAbilityEffect> clsEffect;

    private static final Map<String, ApiType> allValues = new HashMap<>();

    static {
        for (ApiType t : ApiType.values()) {
            allValues.put(t.name().toLowerCase(Locale.ENGLISH), t);
        }
    }

    ApiType(Class<? extends SpellAbilityEffect> clsEf) { this(clsEf, true); }
    ApiType(Class<? extends SpellAbilityEffect> clsEf, final boolean isStateLess) {
        clsEffect = clsEf;
        instanceEffect = isStateLess ? ReflectionUtil.makeDefaultInstanceOf(clsEf) : null;
    }

    public static ApiType smartValueOf(String value) {
        ApiType v = allValues.get(value.toLowerCase(Locale.ENGLISH));
        if ( v == null )
            throw new RuntimeException("Element " + value + " not found in ApiType enum");
        return v;
    }

    public SpellAbilityEffect getSpellEffect() {
        return instanceEffect != null ? instanceEffect : ReflectionUtil.makeDefaultInstanceOf(clsEffect);
    }
}
```

## Python
`forge/game/ability/ApiType.py`

```python
package forge.game.ability -> module forge/game/ability/ApiType.py

I'll produce the faithful Python port directly.

from enum import Enum

from forge.game.ability.SpellAbilityEffect import SpellAbilityEffect
from forge.util.ReflectionUtil import ReflectionUtil

from forge.game.ability.effects.AbandonEffect import AbandonEffect
from forge.game.ability.effects.ActivateAbilityEffect import ActivateAbilityEffect
from forge.game.ability.effects.AddPhaseEffect import AddPhaseEffect
from forge.game.ability.effects.AddTurnEffect import AddTurnEffect
from forge.game.ability.effects.AdvanceCrankEffect import AdvanceCrankEffect
from forge.game.ability.effects.AirbendEffect import AirbendEffect
from forge.game.ability.effects.AlterAttributeEffect import AlterAttributeEffect
from forge.game.ability.effects.AmassEffect import AmassEffect
from forge.game.ability.effects.AnimateAllEffect import AnimateAllEffect
from forge.game.ability.effects.AnimateEffect import AnimateEffect
from forge.game.ability.effects.AscendEffect import AscendEffect
from forge.game.ability.effects.AssembleContraptionEffect import AssembleContraptionEffect
from forge.game.ability.effects.AssignGroupEffect import AssignGroupEffect
from forge.game.ability.effects.AttachEffect import AttachEffect
from forge.game.ability.effects.BalanceEffect import BalanceEffect
from forge.game.ability.effects.BecomeMonarchEffect import BecomeMonarchEffect
from forge.game.ability.effects.BecomesBlockedEffect import BecomesBlockedEffect
from forge.game.ability.effects.BidLifeEffect import BidLifeEffect
from forge.game.ability.effects.BlankLineEffect import BlankLineEffect
from forge.game.ability.effects.BlightEffect import BlightEffect
from forge.game.ability.effects.BlockEffect import BlockEffect
from forge.game.ability.effects.BondEffect import BondEffect
from forge.game.ability.effects.BranchEffect import BranchEffect
from forge.game.ability.effects.CamouflageEffect import CamouflageEffect
from forge.game.ability.effects.ChangeCombatantsEffect import ChangeCombatantsEffect
from forge.game.ability.effects.ChangeSpeedEffect import ChangeSpeedEffect
from forge.game.ability.effects.ChangeTargetsEffect import ChangeTargetsEffect
from forge.game.ability.effects.ChangeTextEffect import ChangeTextEffect
from forge.game.ability.effects.ChangeXEffect import ChangeXEffect
from forge.game.ability.effects.ChangeZoneAllEffect import ChangeZoneAllEffect
from forge.game.ability.effects.ChangeZoneEffect import ChangeZoneEffect
from forge.game.ability.effects.ChangeZoneResolveEffect import ChangeZoneResolveEffect
from forge.game.ability.effects.ChaosEnsuesEffect import ChaosEnsuesEffect
from forge.game.ability.effects.CharmEffect import CharmEffect
from forge.game.ability.effects.ChooseCardEffect import ChooseCardEffect
from forge.game.ability.effects.ChooseCardNameEffect import ChooseCardNameEffect
from forge.game.ability.effects.ChooseColorEffect import ChooseColorEffect
from forge.game.ability.effects.ChooseDirectionEffect import ChooseDirectionEffect
from forge.game.ability.effects.ChooseEvenOddEffect import ChooseEvenOddEffect
from forge.game.ability.effects.ChooseGenericEffect import ChooseGenericEffect
from forge.game.ability.effects.ChooseNumberEffect import ChooseNumberEffect
from forge.game.ability.effects.ChoosePlayerEffect import ChoosePlayerEffect
from forge.game.ability.effects.ChooseSectorEffect import ChooseSectorEffect
from forge.game.ability.effects.ChooseSourceEffect import ChooseSourceEffect
from forge.game.ability.effects.ChooseTypeEffect import ChooseTypeEffect
from forge.game.ability.effects.ClaimThePrizeEffect import ClaimThePrizeEffect
from forge.game.ability.effects.ClashEffect import ClashEffect
from forge.game.ability.effects.ClassLevelUpEffect import ClassLevelUpEffect
from forge.game.ability.effects.CleanUpEffect import CleanUpEffect
from forge.game.ability.effects.CloakEffect import CloakEffect
from forge.game.ability.effects.CloneEffect import CloneEffect
from forge.game.ability.effects.ConniveEffect import ConniveEffect
from forge.game.ability.effects.ControlExchangeEffect import ControlExchangeEffect
from forge.game.ability.effects.ControlExchangeVariantEffect import ControlExchangeVariantEffect
from forge.game.ability.effects.ControlGainEffect import ControlGainEffect
from forge.game.ability.effects.ControlGainVariantEffect import ControlGainVariantEffect
from forge.game.ability.effects.ControlPlayerEffect import ControlPlayerEffect
from forge.game.ability.effects.ControlSpellEffect import ControlSpellEffect
from forge.game.ability.effects.CopyPermanentEffect import CopyPermanentEffect
from forge.game.ability.effects.CopySpellAbilityEffect import CopySpellAbilityEffect
from forge.game.ability.effects.CounterEffect import CounterEffect
from forge.game.ability.effects.CountersMoveEffect import CountersMoveEffect
from forge.game.ability.effects.CountersMultiplyEffect import CountersMultiplyEffect
from forge.game.ability.effects.CountersProliferateEffect import CountersProliferateEffect
from forge.game.ability.effects.CountersPutAllEffect import CountersPutAllEffect
from forge.game.ability.effects.CountersPutEffect import CountersPutEffect
from forge.game.ability.effects.CountersPutOrRemoveEffect import CountersPutOrRemoveEffect
from forge.game.ability.effects.CountersRemoveAllEffect import CountersRemoveAllEffect
from forge.game.ability.effects.CountersRemoveEffect import CountersRemoveEffect
from forge.game.ability.effects.DamageAllEffect import DamageAllEffect
from forge.game.ability.effects.DamageDealEffect import DamageDealEffect
from forge.game.ability.effects.DamageEachEffect import DamageEachEffect
from forge.game.ability.effects.DamagePreventEffect import DamagePreventEffect
from forge.game.ability.effects.DamageResolveEffect import DamageResolveEffect
from forge.game.ability.effects.DayTimeEffect import DayTimeEffect
from forge.game.ability.effects.DebuffEffect import DebuffEffect
from forge.game.ability.effects.DelayedTriggerEffect import DelayedTriggerEffect
from forge.game.ability.effects.DestroyAllEffect import DestroyAllEffect
from forge.game.ability.effects.DestroyEffect import DestroyEffect
from forge.game.ability.effects.DetainEffect import DetainEffect
from forge.game.ability.effects.DigEffect import DigEffect
from forge.game.ability.effects.DigMultipleEffect import DigMultipleEffect
from forge.game.ability.effects.DigUntilEffect import DigUntilEffect
from forge.game.ability.effects.DiscardEffect import DiscardEffect
from forge.game.ability.effects.DiscoverEffect import DiscoverEffect
from forge.game.ability.effects.DraftEffect import DraftEffect
from forge.game.ability.effects.DrainManaEffect import DrainManaEffect
from forge.game.ability.effects.DrawEffect import DrawEffect
from forge.game.ability.effects.EarthbendEffect import EarthbendEffect
from forge.game.ability.effects.EffectEffect import EffectEffect
from forge.game.ability.effects.EncodeEffect import EncodeEffect
from forge.game.ability.effects.EndCombatPhaseEffect import EndCombatPhaseEffect
from forge.game.ability.effects.EndTurnEffect import EndTurnEffect
from forge.game.ability.effects.EndureEffect import EndureEffect
from forge.game.ability.effects.ExploreEffect import ExploreEffect
from forge.game.ability.effects.FightEffect import FightEffect
from forge.game.ability.effects.FlipCoinEffect import FlipCoinEffect
from forge.game.ability.effects.FlipOntoBattlefieldEffect import FlipOntoBattlefieldEffect
from forge.game.ability.effects.FogEffect import FogEffect
from forge.game.ability.effects.GameDrawEffect import GameDrawEffect
from forge.game.ability.effects.GameLossEffect import GameLossEffect
from forge.game.ability.effects.GameWinEffect import GameWinEffect
from forge.game.ability.effects.GoadEffect import GoadEffect
from forge.game.ability.effects.HauntEffect import HauntEffect
from forge.game.ability.effects.HeistEffect import HeistEffect
from forge.game.ability.effects.ImmediateTriggerEffect import ImmediateTriggerEffect
from forge.game.ability.effects.IncubateEffect import IncubateEffect
from forge.game.ability.effects.IntensifyEffect import IntensifyEffect
from forge.game.ability.effects.InternalRadiationEffect import InternalRadiationEffect
from forge.game.ability.effects.InvestigateEffect import InvestigateEffect
from forge.game.ability.effects.LearnEffect import LearnEffect
from forge.game.ability.effects.LifeExchangeEffect import LifeExchangeEffect
from forge.game.ability.effects.LifeExchangeVariantEffect import LifeExchangeVariantEffect
from forge.game.ability.effects.LifeGainEffect import LifeGainEffect
from forge.game.ability.effects.LifeLoseEffect import LifeLoseEffect
from forge.game.ability.effects.LifeSetEffect import LifeSetEffect
from forge.game.ability.effects.LookAtEffect import LookAtEffect
from forge.game.ability.effects.LosePerpetualEffect import LosePerpetualEffect
from forge.game.ability.effects.MakeCardEffect import MakeCardEffect
from forge.game.ability.effects.ManaEffect import ManaEffect
from forge.game.ability.effects.ManaReflectedEffect import ManaReflectedEffect
from forge.game.ability.effects.ManifestDreadEffect import ManifestDreadEffect
from forge.game.ability.effects.ManifestEffect import ManifestEffect
from forge.game.ability.effects.MeldEffect import MeldEffect
from forge.game.ability.effects.MillEffect import MillEffect
from forge.game.ability.effects.MultiplePilesEffect import MultiplePilesEffect
from forge.game.ability.effects.MustBlockEffect import MustBlockEffect
from forge.game.ability.effects.MutateEffect import MutateEffect
from forge.game.ability.effects.OpenAttractionEffect import OpenAttractionEffect
from forge.game.ability.effects.OwnershipGainEffect import OwnershipGainEffect
from forge.game.ability.effects.PeekAndRevealEffect import PeekAndRevealEffect
from forge.game.ability.effects.PermanentCreatureEffect import PermanentCreatureEffect
from forge.game.ability.effects.PermanentNoncreatureEffect import PermanentNoncreatureEffect
from forge.game.ability.effects.PhasesEffect import PhasesEffect
from forge.game.ability.effects.PlaneswalkEffect import PlaneswalkEffect
from forge.game.ability.effects.PlayEffect import PlayEffect
from forge.game.ability.effects.PlayLandVariantEffect import PlayLandVariantEffect
from forge.game.ability.effects.PoisonEffect import PoisonEffect
from forge.game.ability.effects.PowerExchangeEffect import PowerExchangeEffect
from forge.game.ability.effects.ProtectAllEffect import ProtectAllEffect
from forge.game.ability.effects.ProtectEffect import ProtectEffect
from forge.game.ability.effects.PumpAllEffect import PumpAllEffect
from forge.game.ability.effects.PumpEffect import PumpEffect
from forge.game.ability.effects.RadiationEffect import RadiationEffect
from forge.game.ability.effects.RearrangeTopOfLibraryEffect import RearrangeTopOfLibraryEffect
from forge.game.ability.effects.RegenerateEffect import RegenerateEffect
from forge.game.ability.effects.RegenerationEffect import RegenerationEffect
from forge.game.ability.effects.RemoveFromCombatEffect import RemoveFromCombatEffect
from forge.game.ability.effects.RemoveFromGameEffect import RemoveFromGameEffect
from forge.game.ability.effects.RemoveFromMatchEffect import RemoveFromMatchEffect
from forge.game.ability.effects.ReorderZoneEffect import ReorderZoneEffect
from forge.game.ability.effects.RepeatEachEffect import RepeatEachEffect
from forge.game.ability.effects.RepeatEffect import RepeatEffect
from forge.game.ability.effects.ReplaceCounterEffect import ReplaceCounterEffect
from forge.game.ability.effects.ReplaceDamageEffect import ReplaceDamageEffect
from forge.game.ability.effects.ReplaceEffect import ReplaceEffect
from forge.game.ability.effects.ReplaceManaEffect import ReplaceManaEffect
from forge.game.ability.effects.ReplaceSplitDamageEffect import ReplaceSplitDamageEffect
from forge.game.ability.effects.ReplaceTokenEffect import ReplaceTokenEffect
from forge.game.ability.effects.RestartGameEffect import RestartGameEffect
from forge.game.ability.effects.RevealEffect import RevealEffect
from forge.game.ability.effects.RevealHandEffect import RevealHandEffect
from forge.game.ability.effects.ReverseTurnOrderEffect import ReverseTurnOrderEffect
from forge.game.ability.effects.RingTemptsYouEffect import RingTemptsYouEffect
from forge.game.ability.effects.RollDiceEffect import RollDiceEffect
from forge.game.ability.effects.RollPlanarDiceEffect import RollPlanarDiceEffect
from forge.game.ability.effects.RunChaosEffect import RunChaosEffect
from forge.game.ability.effects.SacrificeAllEffect import SacrificeAllEffect
from forge.game.ability.effects.SacrificeEffect import SacrificeEffect
from forge.game.ability.effects.ScryEffect import ScryEffect
from forge.game.ability.effects.SeekEffect import SeekEffect
from forge.game.ability.effects.SetInMotionEffect import SetInMotionEffect
from forge.game.ability.effects.SetStateEffect import SetStateEffect
from forge.game.ability.effects.ShuffleEffect import ShuffleEffect
from forge.game.ability.effects.SkipPhaseEffect import SkipPhaseEffect
from forge.game.ability.effects.SkipTurnEffect import SkipTurnEffect
from forge.game.ability.effects.StoreSVarEffect import StoreSVarEffect
from forge.game.ability.effects.SubgameEffect import SubgameEffect
from forge.game.ability.effects.SurveilEffect import SurveilEffect
from forge.game.ability.effects.SwitchBlockEffect import SwitchBlockEffect
from forge.game.ability.effects.TakeInitiativeEffect import TakeInitiativeEffect
from forge.game.ability.effects.TapAllEffect import TapAllEffect
from forge.game.ability.effects.TapEffect import TapEffect
from forge.game.ability.effects.TapOrUntapAllEffect import TapOrUntapAllEffect
from forge.game.ability.effects.TapOrUntapEffect import TapOrUntapEffect
from forge.game.ability.effects.TextBoxExchangeEffect import TextBoxExchangeEffect
from forge.game.ability.effects.TimeTravelEffect import TimeTravelEffect
from forge.game.ability.effects.TokenEffect import TokenEffect
from forge.game.ability.effects.TwoPilesEffect import TwoPilesEffect
from forge.game.ability.effects.UnattachEffect import UnattachEffect
from forge.game.ability.effects.UnlockDoorEffect import UnlockDoorEffect
from forge.game.ability.effects.UntapAllEffect import UntapAllEffect
from forge.game.ability.effects.UntapEffect import UntapEffect
from forge.game.ability.effects.VentureEffect import VentureEffect
from forge.game.ability.effects.VillainousChoiceEffect import VillainousChoiceEffect
from forge.game.ability.effects.VoteEffect import VoteEffect
from forge.game.ability.effects.ZoneExchangeEffect import ZoneExchangeEffect


# TODO: Write javadoc for this type.
class ApiType(Enum):
    def __new__(cls, clsEf, isStateLess=True):
        obj = object.__new__(cls)
        obj._value_ = len(cls.__members__) + 1
        return obj

    def __init__(self, clsEf, isStateLess=True):
        self.clsEffect = clsEf
        self.instanceEffect = ReflectionUtil.makeDefaultInstanceOf(clsEf) if isStateLess else None

    Abandon = (AbandonEffect,)
    ActivateAbility = (ActivateAbilityEffect,)
    AddOrRemoveCounter = (CountersPutOrRemoveEffect,)
    AddPhase = (AddPhaseEffect,)
    AddTurn = (AddTurnEffect,)
    AdvanceCrank = (AdvanceCrankEffect,)
    Airbend = (AirbendEffect,)
    AlterAttribute = (AlterAttributeEffect,)
    Amass = (AmassEffect,)
    Animate = (AnimateEffect,)
    AnimateAll = (AnimateAllEffect,)
    Attach = (AttachEffect,)
    Ascend = (AscendEffect,)
    AssembleContraption = (AssembleContraptionEffect,)
    AssignGroup = (AssignGroupEffect,)
    Balance = (BalanceEffect,)
    BecomeMonarch = (BecomeMonarchEffect,)
    BecomesBlocked = (BecomesBlockedEffect,)
    BidLife = (BidLifeEffect,)
    Blight = (BlightEffect,)
    Block = (BlockEffect,)
    Bond = (BondEffect,)
    Branch = (BranchEffect,)
    Camouflage = (CamouflageEffect,)
    ChangeCombatants = (ChangeCombatantsEffect,)
    ChangeSpeed = (ChangeSpeedEffect,)
    ChangeTargets = (ChangeTargetsEffect,)
    ChangeText = (ChangeTextEffect,)
    ChangeX = (ChangeXEffect,)
    ChangeZone = (ChangeZoneEffect,)
    ChangeZoneAll = (ChangeZoneAllEffect,)
    ChaosEnsues = (ChaosEnsuesEffect,)
    Charm = (CharmEffect,)
    ChooseCard = (ChooseCardEffect,)
    ChooseColor = (ChooseColorEffect,)
    ChooseDirection = (ChooseDirectionEffect,)
    ChooseEvenOdd = (ChooseEvenOddEffect,)
    ChooseNumber = (ChooseNumberEffect,)
    ChoosePlayer = (ChoosePlayerEffect,)
    ChooseSector = (ChooseSectorEffect,)
    ChooseSource = (ChooseSourceEffect,)
    ChooseType = (ChooseTypeEffect,)
    ClaimThePrize = (ClaimThePrizeEffect,)
    Clash = (ClashEffect,)
    ClassLevelUp = (ClassLevelUpEffect,)
    Cleanup = (CleanUpEffect,)
    Cloak = (CloakEffect,)
    Clone = (CloneEffect,)
    Connive = (ConniveEffect,)
    CopyPermanent = (CopyPermanentEffect,)
    CopySpellAbility = (CopySpellAbilityEffect,)
    ControlSpell = (ControlSpellEffect,)
    ControlPlayer = (ControlPlayerEffect,)
    Counter = (CounterEffect,)
    DamageAll = (DamageAllEffect,)
    DealDamage = (DamageDealEffect,)
    Detain = (DetainEffect,)
    DayTime = (DayTimeEffect,)
    Debuff = (DebuffEffect,)
    DelayedTrigger = (DelayedTriggerEffect,)
    Destroy = (DestroyEffect,)
    DestroyAll = (DestroyAllEffect,)
    Dig = (DigEffect,)
    DigMultiple = (DigMultipleEffect,)
    DigUntil = (DigUntilEffect,)
    Discard = (DiscardEffect,)
    Discover = (DiscoverEffect,)
    DrainMana = (DrainManaEffect,)
    Draft = (DraftEffect,)
    Draw = (DrawEffect,)
    EachDamage = (DamageEachEffect,)
    Earthbend = (EarthbendEffect,)
    Effect = (EffectEffect,)
    Encode = (EncodeEffect,)
    EndCombatPhase = (EndCombatPhaseEffect,)
    EndTurn = (EndTurnEffect,)
    Endure = (EndureEffect,)
    ExchangeLife = (LifeExchangeEffect,)
    ExchangeLifeVariant = (LifeExchangeVariantEffect,)
    ExchangeControl = (ControlExchangeEffect,)
    ExchangeControlVariant = (ControlExchangeVariantEffect,)
    ExchangePower = (PowerExchangeEffect,)
    ExchangeZone = (ZoneExchangeEffect,)
    ExchangeTextBox = (TextBoxExchangeEffect,)
    Explore = (ExploreEffect,)
    Fight = (FightEffect,)
    FlipCoin = (FlipCoinEffect,)
    FlipOntoBattlefield = (FlipOntoBattlefieldEffect,)
    Fog = (FogEffect,)
    GainControl = (ControlGainEffect,)
    GainControlVariant = (ControlGainVariantEffect,)
    GainLife = (LifeGainEffect,)
    GainOwnership = (OwnershipGainEffect,)
    GameDrawn = (GameDrawEffect,)
    GenericChoice = (ChooseGenericEffect,)
    Goad = (GoadEffect,)
    Haunt = (HauntEffect,)
    Heist = (HeistEffect,)
    Investigate = (InvestigateEffect,)
    Intensify = (IntensifyEffect,)
    ImmediateTrigger = (ImmediateTriggerEffect,)
    Incubate = (IncubateEffect,)
    Learn = (LearnEffect,)
    LookAt = (LookAtEffect,)
    LoseLife = (LifeLoseEffect,)
    LosePerpetual = (LosePerpetualEffect,)
    LosesGame = (GameLossEffect,)
    MakeCard = (MakeCardEffect,)
    Mana = (ManaEffect,)
    ManaReflected = (ManaReflectedEffect,)
    Manifest = (ManifestEffect,)
    ManifestDread = (ManifestDreadEffect,)
    Meld = (MeldEffect,)
    Mill = (MillEffect,)
    MoveCounter = (CountersMoveEffect,)
    MultiplePiles = (MultiplePilesEffect,)
    MultiplyCounter = (CountersMultiplyEffect,)
    MustBlock = (MustBlockEffect,)
    Mutate = (MutateEffect,)
    NameCard = (ChooseCardNameEffect,)
    # NoteCounters (CountersNoteEffect.class),
    OpenAttraction = (OpenAttractionEffect,)
    PeekAndReveal = (PeekAndRevealEffect,)
    PermanentCreature = (PermanentCreatureEffect,)
    PermanentNoncreature = (PermanentNoncreatureEffect,)
    Phases = (PhasesEffect,)
    Planeswalk = (PlaneswalkEffect,)
    Play = (PlayEffect,)
    PlayLandVariant = (PlayLandVariantEffect,)
    Poison = (PoisonEffect,)
    PreventDamage = (DamagePreventEffect,)
    Proliferate = (CountersProliferateEffect,)
    Protection = (ProtectEffect,)
    ProtectionAll = (ProtectAllEffect,)
    Pump = (PumpEffect,)
    PumpAll = (PumpAllEffect,)
    PutCounter = (CountersPutEffect,)
    PutCounterAll = (CountersPutAllEffect,)
    Radiation = (RadiationEffect,)
    RearrangeTopOfLibrary = (RearrangeTopOfLibraryEffect,)
    Regenerate = (RegenerateEffect,)
    Regeneration = (RegenerationEffect,)
    RemoveCounter = (CountersRemoveEffect,)
    RemoveCounterAll = (CountersRemoveAllEffect,)
    RemoveFromCombat = (RemoveFromCombatEffect,)
    RemoveFromGame = (RemoveFromGameEffect,)
    RemoveFromMatch = (RemoveFromMatchEffect,)
    ReorderZone = (ReorderZoneEffect,)
    Repeat = (RepeatEffect,)
    RepeatEach = (RepeatEachEffect,)
    ReplaceCounter = (ReplaceCounterEffect,)
    ReplaceEffect = (ReplaceEffect,)
    ReplaceMana = (ReplaceManaEffect,)
    ReplaceDamage = (ReplaceDamageEffect,)
    ReplaceToken = (ReplaceTokenEffect,)
    ReplaceSplitDamage = (ReplaceSplitDamageEffect,)
    RestartGame = (RestartGameEffect,)
    Reveal = (RevealEffect,)
    RevealHand = (RevealHandEffect,)
    ReverseTurnOrder = (ReverseTurnOrderEffect,)
    RingTemptsYou = (RingTemptsYouEffect,)
    RollDice = (RollDiceEffect,)
    RollPlanarDice = (RollPlanarDiceEffect,)
    RunChaos = (RunChaosEffect,)
    Sacrifice = (SacrificeEffect,)
    SacrificeAll = (SacrificeAllEffect,)
    Scry = (ScryEffect,)
    Seek = (SeekEffect,)
    SetInMotion = (SetInMotionEffect,)
    SetLife = (LifeSetEffect,)
    SetState = (SetStateEffect,)
    Shuffle = (ShuffleEffect,)
    SkipPhase = (SkipPhaseEffect,)
    SkipTurn = (SkipTurnEffect,)
    StoreSVar = (StoreSVarEffect,)
    Subgame = (SubgameEffect,)
    Surveil = (SurveilEffect,)
    SwitchBlock = (SwitchBlockEffect,)
    TakeInitiative = (TakeInitiativeEffect,)
    Tap = (TapEffect,)
    TapAll = (TapAllEffect,)
    TapOrUntap = (TapOrUntapEffect,)
    TapOrUntapAll = (TapOrUntapAllEffect,)
    TimeTravel = (TimeTravelEffect,)
    Token = (TokenEffect,)
    TwoPiles = (TwoPilesEffect,)
    Unattach = (UnattachEffect,)
    UnlockDoor = (UnlockDoorEffect,)
    Untap = (UntapEffect,)
    UntapAll = (UntapAllEffect,)
    Venture = (VentureEffect,)
    VillainousChoice = (VillainousChoiceEffect,)
    Vote = (VoteEffect,)
    WinsGame = (GameWinEffect,)

    BlankLine = (BlankLineEffect,)
    DamageResolve = (DamageResolveEffect,)
    ChangeZoneResolve = (ChangeZoneResolveEffect,)
    CompanionChoose = (CharmEffect,)
    InternalLegendaryRule = (CharmEffect,)
    InternalIgnoreEffect = (CharmEffect,)
    InternalRadiation = (InternalRadiationEffect,)

    @staticmethod
    def smartValueOf(value):
        v = ApiType.allValues.get(value.lower())
        if v is None:
            raise RuntimeError("Element " + value + " not found in ApiType enum")
        return v

    def getSpellEffect(self):
        return self.instanceEffect if self.instanceEffect is not None else ReflectionUtil.makeDefaultInstanceOf(self.clsEffect)


allValues: dict[str, ApiType] = {}
for t in ApiType:
    allValues[t.name.lower()] = t
ApiType.allValues = allValues
```
