---
aliases:
  - SpellApiToAi
tags:
  - java/enum
  - module/forge-ai
  - pkg/forge/ai
fqn: forge.ai.SpellApiToAi
package: forge.ai
module: forge-ai
kind: Enum
---

# SpellApiToAi

**Package:** `forge.ai` &nbsp; **Module:** `forge-ai` &nbsp; **Kind:** Enum

```mermaid
classDiagram
    class SpellApiToAi {
        <<enumeration>>
        Converter
        -Map~ApiType,SpellAbilityAi~ apiToInstance
        -Map~ApiType,Class~ apiToClass
        +get(SpellAbility sa) SpellAbilityAi
        +get(ApiType api) SpellAbilityAi
    }
    SpellApiToAi ..> ActivateAbilityAi : uses
    SpellApiToAi ..> AddPhaseAi : uses
    SpellApiToAi ..> AddTurnAi : uses
    SpellApiToAi ..> AdvanceCrankAi : uses
    SpellApiToAi ..> AirbendAi : uses
    SpellApiToAi ..> AlterAttributeAi : uses
    SpellApiToAi ..> AlwaysPlayAi : uses
    SpellApiToAi ..> AmassAi : uses
    SpellApiToAi ..> AnimateAi : uses
    SpellApiToAi ..> AnimateAllAi : uses
    SpellApiToAi ..> ApiType : uses
    SpellApiToAi ..> AssembleContraptionAi : uses
    SpellApiToAi ..> AssignGroupAi : uses
    SpellApiToAi ..> AttachAi : uses
    SpellApiToAi ..> BalanceAi : uses
    SpellApiToAi ..> BecomesBlockedAi : uses
    SpellApiToAi ..> BidLifeAi : uses
    SpellApiToAi ..> BlightAi : uses
    SpellApiToAi ..> BondAi : uses
    SpellApiToAi ..> BranchAi : uses
    SpellApiToAi ..> CannotPlayAi : uses
    SpellApiToAi ..> ChangeCombatantsAi : uses
    SpellApiToAi ..> ChangeTargetsAi : uses
    SpellApiToAi ..> ChangeZoneAi : uses
    SpellApiToAi ..> ChangeZoneAllAi : uses
    SpellApiToAi ..> CharmAi : uses
    SpellApiToAi ..> ChooseCardAi : uses
    SpellApiToAi ..> ChooseCardNameAi : uses
    SpellApiToAi ..> ChooseColorAi : uses
    SpellApiToAi ..> ChooseCompanionAi : uses
    SpellApiToAi ..> ChooseDirectionAi : uses
    SpellApiToAi ..> ChooseEvenOddAi : uses
    SpellApiToAi ..> ChooseGenericAi : uses
    SpellApiToAi ..> ChooseNumberAi : uses
    SpellApiToAi ..> ChoosePlayerAi : uses
    SpellApiToAi ..> ChooseSourceAi : uses
    SpellApiToAi ..> ChooseTypeAi : uses
    SpellApiToAi ..> ClashAi : uses
    SpellApiToAi ..> ClassLevelUpAi : uses
    SpellApiToAi ..> CloakAi : uses
    SpellApiToAi ..> CloneAi : uses
    SpellApiToAi ..> ConniveAi : uses
    SpellApiToAi ..> ControlExchangeAi : uses
    SpellApiToAi ..> ControlGainAi : uses
    SpellApiToAi ..> ControlGainVariantAi : uses
    SpellApiToAi ..> CopyPermanentAi : uses
    SpellApiToAi ..> CopySpellAbilityAi : uses
    SpellApiToAi ..> CounterAi : uses
    SpellApiToAi ..> CountersMoveAi : uses
    SpellApiToAi ..> CountersMultiplyAi : uses
    SpellApiToAi ..> CountersProliferateAi : uses
    SpellApiToAi ..> CountersPutAi : uses
    SpellApiToAi ..> CountersPutAllAi : uses
    SpellApiToAi ..> CountersPutOrRemoveAi : uses
    SpellApiToAi ..> CountersRemoveAi : uses
    SpellApiToAi ..> DamageAllAi : uses
    SpellApiToAi ..> DamageDealAi : uses
    SpellApiToAi ..> DamageEachAi : uses
    SpellApiToAi ..> DamagePreventAi : uses
    SpellApiToAi ..> DayTimeAi : uses
    SpellApiToAi ..> DebuffAi : uses
    SpellApiToAi ..> DelayedTriggerAi : uses
    SpellApiToAi ..> DestroyAi : uses
    SpellApiToAi ..> DestroyAllAi : uses
    SpellApiToAi ..> DetainAi : uses
    SpellApiToAi ..> DigAi : uses
    SpellApiToAi ..> DigMultipleAi : uses
    SpellApiToAi ..> DigUntilAi : uses
    SpellApiToAi ..> DiscardAi : uses
    SpellApiToAi ..> DiscoverAi : uses
    SpellApiToAi ..> DrainManaAi : uses
    SpellApiToAi ..> DrawAi : uses
    SpellApiToAi ..> EarthbendAi : uses
    SpellApiToAi ..> EffectAi : uses
    SpellApiToAi ..> EncodeAi : uses
    SpellApiToAi ..> EndTurnAi : uses
    SpellApiToAi ..> EndureAi : uses
    SpellApiToAi ..> ExploreAi : uses
    SpellApiToAi ..> FightAi : uses
    SpellApiToAi ..> FlipCoinAi : uses
    SpellApiToAi ..> FlipOntoBattlefieldAi : uses
    SpellApiToAi ..> FogAi : uses
    SpellApiToAi ..> GameLossAi : uses
    SpellApiToAi ..> GameWinAi : uses
    SpellApiToAi ..> GoadAi : uses
    SpellApiToAi ..> HauntAi : uses
    SpellApiToAi ..> ImmediateTriggerAi : uses
    SpellApiToAi ..> InvestigateAi : uses
    SpellApiToAi ..> LearnAi : uses
    SpellApiToAi ..> LegendaryRuleAi : uses
    SpellApiToAi ..> LifeExchangeAi : uses
    SpellApiToAi ..> LifeExchangeVariantAi : uses
    SpellApiToAi ..> LifeGainAi : uses
    SpellApiToAi ..> LifeLoseAi : uses
    SpellApiToAi ..> LifeSetAi : uses
    SpellApiToAi ..> ManaAi : uses
    SpellApiToAi ..> ManifestAi : uses
    SpellApiToAi ..> MeldAi : uses
    SpellApiToAi ..> MillAi : uses
    SpellApiToAi ..> MustBlockAi : uses
    SpellApiToAi ..> MutateAi : uses
    SpellApiToAi ..> PeekAndRevealAi : uses
    SpellApiToAi ..> PermanentCreatureAi : uses
    SpellApiToAi ..> PermanentNoncreatureAi : uses
    SpellApiToAi ..> PhasesAi : uses
    SpellApiToAi ..> PlayAi : uses
    SpellApiToAi ..> PoisonAi : uses
    SpellApiToAi ..> PowerExchangeAi : uses
    SpellApiToAi ..> ProtectAi : uses
    SpellApiToAi ..> ProtectAllAi : uses
    SpellApiToAi ..> PumpAi : uses
    SpellApiToAi ..> PumpAllAi : uses
    SpellApiToAi ..> RearrangeTopOfLibraryAi : uses
    SpellApiToAi ..> RegenerateAi : uses
    SpellApiToAi ..> RemoveFromCombatAi : uses
    SpellApiToAi ..> RepeatAi : uses
    SpellApiToAi ..> RepeatEachAi : uses
    SpellApiToAi ..> ReplaceDamageAi : uses
    SpellApiToAi ..> RestartGameAi : uses
    SpellApiToAi ..> RevealAi : uses
    SpellApiToAi ..> RevealHandAi : uses
    SpellApiToAi ..> RollDiceAi : uses
    SpellApiToAi ..> RollPlanarDiceAi : uses
    SpellApiToAi ..> SacrificeAi : uses
    SpellApiToAi ..> SacrificeAllAi : uses
    SpellApiToAi ..> ScryAi : uses
    SpellApiToAi ..> SetStateAi : uses
    SpellApiToAi ..> ShuffleAi : uses
    SpellApiToAi ..> SkipPhaseAi : uses
    SpellApiToAi ..> SkipTurnAi : uses
    SpellApiToAi ..> SpellAbility : uses
    SpellApiToAi ..> SpellAbilityAi : uses
    SpellApiToAi ..> StoreSVarAi : uses
    SpellApiToAi ..> SurveilAi : uses
    SpellApiToAi ..> TapAi : uses
    SpellApiToAi ..> TapAllAi : uses
    SpellApiToAi ..> TapOrUntapAi : uses
    SpellApiToAi ..> TapOrUntapAllAi : uses
    SpellApiToAi ..> TimeTravelAi : uses
    SpellApiToAi ..> TokenAi : uses
    SpellApiToAi ..> TwoPilesAi : uses
    SpellApiToAi ..> UnattachAi : uses
    SpellApiToAi ..> UntapAi : uses
    SpellApiToAi ..> UntapAllAi : uses
    SpellApiToAi ..> VentureAi : uses
    SpellApiToAi ..> VoteAi : uses
    SpellApiToAi ..> ZoneExchangeAi : uses
```

## Relationships
**Uses:**
- [[forge.ai.SpellAbilityAi|SpellAbilityAi]]
- [[forge.ai.ability.ActivateAbilityAi|ActivateAbilityAi]]
- [[forge.ai.ability.AddPhaseAi|AddPhaseAi]]
- [[forge.ai.ability.AddTurnAi|AddTurnAi]]
- [[forge.ai.ability.AdvanceCrankAi|AdvanceCrankAi]]
- [[forge.ai.ability.AirbendAi|AirbendAi]]
- [[forge.ai.ability.AlterAttributeAi|AlterAttributeAi]]
- [[forge.ai.ability.AlwaysPlayAi|AlwaysPlayAi]]
- [[forge.ai.ability.AmassAi|AmassAi]]
- [[forge.ai.ability.AnimateAi|AnimateAi]]
- [[forge.ai.ability.AnimateAllAi|AnimateAllAi]]
- [[forge.ai.ability.AssembleContraptionAi|AssembleContraptionAi]]
- [[forge.ai.ability.AssignGroupAi|AssignGroupAi]]
- [[forge.ai.ability.AttachAi|AttachAi]]
- [[forge.ai.ability.BalanceAi|BalanceAi]]
- [[forge.ai.ability.BecomesBlockedAi|BecomesBlockedAi]]
- [[forge.ai.ability.BidLifeAi|BidLifeAi]]
- [[forge.ai.ability.BlightAi|BlightAi]]
- [[forge.ai.ability.BondAi|BondAi]]
- [[forge.ai.ability.BranchAi|BranchAi]]
- [[forge.ai.ability.CannotPlayAi|CannotPlayAi]]
- [[forge.ai.ability.ChangeCombatantsAi|ChangeCombatantsAi]]
- [[forge.ai.ability.ChangeTargetsAi|ChangeTargetsAi]]
- [[forge.ai.ability.ChangeZoneAi|ChangeZoneAi]]
- [[forge.ai.ability.ChangeZoneAllAi|ChangeZoneAllAi]]
- [[forge.ai.ability.CharmAi|CharmAi]]
- [[forge.ai.ability.ChooseCardAi|ChooseCardAi]]
- [[forge.ai.ability.ChooseCardNameAi|ChooseCardNameAi]]
- [[forge.ai.ability.ChooseColorAi|ChooseColorAi]]
- [[forge.ai.ability.ChooseCompanionAi|ChooseCompanionAi]]
- [[forge.ai.ability.ChooseDirectionAi|ChooseDirectionAi]]
- [[forge.ai.ability.ChooseEvenOddAi|ChooseEvenOddAi]]
- [[forge.ai.ability.ChooseGenericAi|ChooseGenericAi]]
- [[forge.ai.ability.ChooseNumberAi|ChooseNumberAi]]
- [[forge.ai.ability.ChoosePlayerAi|ChoosePlayerAi]]
- [[forge.ai.ability.ChooseSourceAi|ChooseSourceAi]]
- [[forge.ai.ability.ChooseTypeAi|ChooseTypeAi]]
- [[forge.ai.ability.ClashAi|ClashAi]]
- [[forge.ai.ability.ClassLevelUpAi|ClassLevelUpAi]]
- [[forge.ai.ability.CloakAi|CloakAi]]
- [[forge.ai.ability.CloneAi|CloneAi]]
- [[forge.ai.ability.ConniveAi|ConniveAi]]
- [[forge.ai.ability.ControlExchangeAi|ControlExchangeAi]]
- [[forge.ai.ability.ControlGainAi|ControlGainAi]]
- [[forge.ai.ability.ControlGainVariantAi|ControlGainVariantAi]]
- [[forge.ai.ability.CopyPermanentAi|CopyPermanentAi]]
- [[forge.ai.ability.CopySpellAbilityAi|CopySpellAbilityAi]]
- [[forge.ai.ability.CounterAi|CounterAi]]
- [[forge.ai.ability.CountersMoveAi|CountersMoveAi]]
- [[forge.ai.ability.CountersMultiplyAi|CountersMultiplyAi]]
- [[forge.ai.ability.CountersProliferateAi|CountersProliferateAi]]
- [[forge.ai.ability.CountersPutAi|CountersPutAi]]
- [[forge.ai.ability.CountersPutAllAi|CountersPutAllAi]]
- [[forge.ai.ability.CountersPutOrRemoveAi|CountersPutOrRemoveAi]]
- [[forge.ai.ability.CountersRemoveAi|CountersRemoveAi]]
- [[forge.ai.ability.DamageAllAi|DamageAllAi]]
- [[forge.ai.ability.DamageDealAi|DamageDealAi]]
- [[forge.ai.ability.DamageEachAi|DamageEachAi]]
- [[forge.ai.ability.DamagePreventAi|DamagePreventAi]]
- [[forge.ai.ability.DayTimeAi|DayTimeAi]]
- [[forge.ai.ability.DebuffAi|DebuffAi]]
- [[forge.ai.ability.DelayedTriggerAi|DelayedTriggerAi]]
- [[forge.ai.ability.DestroyAi|DestroyAi]]
- [[forge.ai.ability.DestroyAllAi|DestroyAllAi]]
- [[forge.ai.ability.DetainAi|DetainAi]]
- [[forge.ai.ability.DigAi|DigAi]]
- [[forge.ai.ability.DigMultipleAi|DigMultipleAi]]
- [[forge.ai.ability.DigUntilAi|DigUntilAi]]
- [[forge.ai.ability.DiscardAi|DiscardAi]]
- [[forge.ai.ability.DiscoverAi|DiscoverAi]]
- [[forge.ai.ability.DrainManaAi|DrainManaAi]]
- [[forge.ai.ability.DrawAi|DrawAi]]
- [[forge.ai.ability.EarthbendAi|EarthbendAi]]
- [[forge.ai.ability.EffectAi|EffectAi]]
- [[forge.ai.ability.EncodeAi|EncodeAi]]
- [[forge.ai.ability.EndTurnAi|EndTurnAi]]
- [[forge.ai.ability.EndureAi|EndureAi]]
- [[forge.ai.ability.ExploreAi|ExploreAi]]
- [[forge.ai.ability.FightAi|FightAi]]
- [[forge.ai.ability.FlipCoinAi|FlipCoinAi]]
- [[forge.ai.ability.FlipOntoBattlefieldAi|FlipOntoBattlefieldAi]]
- [[forge.ai.ability.FogAi|FogAi]]
- [[forge.ai.ability.GameLossAi|GameLossAi]]
- [[forge.ai.ability.GameWinAi|GameWinAi]]
- [[forge.ai.ability.GoadAi|GoadAi]]
- [[forge.ai.ability.HauntAi|HauntAi]]
- [[forge.ai.ability.ImmediateTriggerAi|ImmediateTriggerAi]]
- [[forge.ai.ability.InvestigateAi|InvestigateAi]]
- [[forge.ai.ability.LearnAi|LearnAi]]
- [[forge.ai.ability.LegendaryRuleAi|LegendaryRuleAi]]
- [[forge.ai.ability.LifeExchangeAi|LifeExchangeAi]]
- [[forge.ai.ability.LifeExchangeVariantAi|LifeExchangeVariantAi]]
- [[forge.ai.ability.LifeGainAi|LifeGainAi]]
- [[forge.ai.ability.LifeLoseAi|LifeLoseAi]]
- [[forge.ai.ability.LifeSetAi|LifeSetAi]]
- [[forge.ai.ability.ManaAi|ManaAi]]
- [[forge.ai.ability.ManifestAi|ManifestAi]]
- [[forge.ai.ability.MeldAi|MeldAi]]
- [[forge.ai.ability.MillAi|MillAi]]
- [[forge.ai.ability.MustBlockAi|MustBlockAi]]
- [[forge.ai.ability.MutateAi|MutateAi]]
- [[forge.ai.ability.PeekAndRevealAi|PeekAndRevealAi]]
- [[forge.ai.ability.PermanentCreatureAi|PermanentCreatureAi]]
- [[forge.ai.ability.PermanentNoncreatureAi|PermanentNoncreatureAi]]
- [[forge.ai.ability.PhasesAi|PhasesAi]]
- [[forge.ai.ability.PlayAi|PlayAi]]
- [[forge.ai.ability.PoisonAi|PoisonAi]]
- [[forge.ai.ability.PowerExchangeAi|PowerExchangeAi]]
- [[forge.ai.ability.ProtectAi|ProtectAi]]
- [[forge.ai.ability.ProtectAllAi|ProtectAllAi]]
- [[forge.ai.ability.PumpAi|PumpAi]]
- [[forge.ai.ability.PumpAllAi|PumpAllAi]]
- [[forge.ai.ability.RearrangeTopOfLibraryAi|RearrangeTopOfLibraryAi]]
- [[forge.ai.ability.RegenerateAi|RegenerateAi]]
- [[forge.ai.ability.RemoveFromCombatAi|RemoveFromCombatAi]]
- [[forge.ai.ability.RepeatAi|RepeatAi]]
- [[forge.ai.ability.RepeatEachAi|RepeatEachAi]]
- [[forge.ai.ability.ReplaceDamageAi|ReplaceDamageAi]]
- [[forge.ai.ability.RestartGameAi|RestartGameAi]]
- [[forge.ai.ability.RevealAi|RevealAi]]
- [[forge.ai.ability.RevealHandAi|RevealHandAi]]
- [[forge.ai.ability.RollDiceAi|RollDiceAi]]
- [[forge.ai.ability.RollPlanarDiceAi|RollPlanarDiceAi]]
- [[forge.ai.ability.SacrificeAi|SacrificeAi]]
- [[forge.ai.ability.SacrificeAllAi|SacrificeAllAi]]
- [[forge.ai.ability.ScryAi|ScryAi]]
- [[forge.ai.ability.SetStateAi|SetStateAi]]
- [[forge.ai.ability.ShuffleAi|ShuffleAi]]
- [[forge.ai.ability.SkipPhaseAi|SkipPhaseAi]]
- [[forge.ai.ability.SkipTurnAi|SkipTurnAi]]
- [[forge.ai.ability.StoreSVarAi|StoreSVarAi]]
- [[forge.ai.ability.SurveilAi|SurveilAi]]
- [[forge.ai.ability.TapAi|TapAi]]
- [[forge.ai.ability.TapAllAi|TapAllAi]]
- [[forge.ai.ability.TapOrUntapAi|TapOrUntapAi]]
- [[forge.ai.ability.TapOrUntapAllAi|TapOrUntapAllAi]]
- [[forge.ai.ability.TimeTravelAi|TimeTravelAi]]
- [[forge.ai.ability.TokenAi|TokenAi]]
- [[forge.ai.ability.TwoPilesAi|TwoPilesAi]]
- [[forge.ai.ability.UnattachAi|UnattachAi]]
- [[forge.ai.ability.UntapAi|UntapAi]]
- [[forge.ai.ability.UntapAllAi|UntapAllAi]]
- [[forge.ai.ability.VentureAi|VentureAi]]
- [[forge.ai.ability.VoteAi|VoteAi]]
- [[forge.ai.ability.ZoneExchangeAi|ZoneExchangeAi]]
- [[forge.game.ability.ApiType|ApiType]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]


## Design Description

The SpellApiToAi enum is a singleton registry that maps each gameplay effect type to the AI logic responsible for evaluating it. Implemented as a single-constant enum (`Converter`), it holds an immutable `ApiType`-to-class table pairing every `ApiType` with a concrete `SpellAbilityAi` subclass, alongside a lazily populated `EnumMap` cache of instantiated handlers. Its overloaded `get` methods resolve a `SpellAbility` (via its `ApiType`) to the appropriate `SpellAbilityAi`, reflectively constructing and caching one instance per type on first request.

The design centralizes the AI dispatch wiring in one place, decoupling the core `SpellAbility`/`ApiType` model in forge-game from the forge-ai handler hierarchy. It favors `EnumMap`s for fast, type-safe lookups and shares stateless handlers like `AlwaysPlayAi` and `CannotPlayAi` across many APIs. Unmapped or unsupported effects fall back to `CannotPlayAi` (with a logged warning), while non-API-based abilities are rejected outright—so the AI degrades gracefully rather than failing when an effect has no dedicated strategy.

## Source
`forge-ai/src/main/java/forge/ai/SpellApiToAi.java`

```java
package forge.ai;

import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Maps;
import forge.ai.ability.*;
import forge.game.ability.ApiType;
import forge.game.spellability.SpellAbility;
import forge.util.ReflectionUtil;

import java.security.InvalidParameterException;
import java.util.Map;

public enum SpellApiToAi {
    Converter;

    private final Map<ApiType, SpellAbilityAi> apiToInstance = Maps.newEnumMap(ApiType.class);

    // Do the extra copy to make an actual EnumMap (faster)
    private final Map<ApiType, Class<? extends SpellAbilityAi>> apiToClass = Maps.newEnumMap(ImmutableMap
            .<ApiType, Class<? extends SpellAbilityAi>>builder()
            .put(ApiType.Abandon, AlwaysPlayAi.class)
            .put(ApiType.ActivateAbility, ActivateAbilityAi.class)
            .put(ApiType.AddOrRemoveCounter, CountersPutOrRemoveAi.class)
            .put(ApiType.AddPhase, AddPhaseAi.class)
            .put(ApiType.AddTurn, AddTurnAi.class)
            .put(ApiType.AdvanceCrank, AdvanceCrankAi.class)
            .put(ApiType.Airbend, AirbendAi.class)
            .put(ApiType.AlterAttribute, AlterAttributeAi.class)
            .put(ApiType.Amass, AmassAi.class)
            .put(ApiType.Animate, AnimateAi.class)
            .put(ApiType.AnimateAll, AnimateAllAi.class)
            .put(ApiType.Attach, AttachAi.class)
            .put(ApiType.Ascend, AlwaysPlayAi.class)
            .put(ApiType.AssembleContraption, AssembleContraptionAi.class)
            .put(ApiType.AssignGroup, AssignGroupAi.class)
            .put(ApiType.Balance, BalanceAi.class)
            .put(ApiType.BecomeMonarch, AlwaysPlayAi.class)
            .put(ApiType.BecomesBlocked, BecomesBlockedAi.class)
            .put(ApiType.BidLife, BidLifeAi.class)
            .put(ApiType.BlankLine, AlwaysPlayAi.class)
            .put(ApiType.Blight, BlightAi.class)
            .put(ApiType.Bond, BondAi.class)
            .put(ApiType.Branch, BranchAi.class)
            .put(ApiType.Camouflage, ChooseCardAi.class)
            .put(ApiType.ChangeCombatants, ChangeCombatantsAi.class)
            .put(ApiType.ChangeSpeed, AlwaysPlayAi.class)
            .put(ApiType.ChangeTargets, ChangeTargetsAi.class)
            .put(ApiType.ChangeX, AlwaysPlayAi.class)
            .put(ApiType.ChangeZone, ChangeZoneAi.class)
            .put(ApiType.ChangeZoneAll, ChangeZoneAllAi.class)
            .put(ApiType.ChaosEnsues, AlwaysPlayAi.class)
            .put(ApiType.Charm, CharmAi.class)
            .put(ApiType.ChooseCard, ChooseCardAi.class)
            .put(ApiType.ChooseColor, ChooseColorAi.class)
            .put(ApiType.ChooseDirection, ChooseDirectionAi.class)
            .put(ApiType.ChooseEvenOdd, ChooseEvenOddAi.class)
            .put(ApiType.ChooseNumber, ChooseNumberAi.class)
            .put(ApiType.ChoosePlayer, ChoosePlayerAi.class)
            .put(ApiType.ChooseSector, AlwaysPlayAi.class)
            .put(ApiType.ChooseSource, ChooseSourceAi.class)
            .put(ApiType.ChooseType, ChooseTypeAi.class)
            .put(ApiType.ClaimThePrize, AlwaysPlayAi.class)
            .put(ApiType.Clash, ClashAi.class)
            .put(ApiType.ClassLevelUp, ClassLevelUpAi.class)
            .put(ApiType.Cleanup, AlwaysPlayAi.class)
            .put(ApiType.Cloak, CloakAi.class)
            .put(ApiType.Clone, CloneAi.class)
            .put(ApiType.CompanionChoose, ChooseCompanionAi.class)
            .put(ApiType.Connive, ConniveAi.class)
            .put(ApiType.CopyPermanent, CopyPermanentAi.class)
            .put(ApiType.CopySpellAbility, CopySpellAbilityAi.class)
            .put(ApiType.ControlPlayer, CannotPlayAi.class)
            .put(ApiType.ControlSpell, CannotPlayAi.class)
            .put(ApiType.Counter, CounterAi.class)
            .put(ApiType.DamageAll, DamageAllAi.class)
            .put(ApiType.DayTime, DayTimeAi.class)
            .put(ApiType.DealDamage, DamageDealAi.class)
            .put(ApiType.Debuff, DebuffAi.class)
            .put(ApiType.DelayedTrigger, DelayedTriggerAi.class)
            .put(ApiType.Destroy, DestroyAi.class)
            .put(ApiType.DestroyAll, DestroyAllAi.class)
            .put(ApiType.Detain, DetainAi.class)
            .put(ApiType.Dig, DigAi.class)
            .put(ApiType.DigMultiple, DigMultipleAi.class)
            .put(ApiType.DigUntil, DigUntilAi.class)
            .put(ApiType.Discard, DiscardAi.class)
            .put(ApiType.Discover, DiscoverAi.class)
            .put(ApiType.Draft, ChooseCardNameAi.class)
            .put(ApiType.DrainMana, DrainManaAi.class)
            .put(ApiType.Draw, DrawAi.class)
            .put(ApiType.EachDamage, DamageEachAi.class)
            .put(ApiType.Earthbend, EarthbendAi.class)
            .put(ApiType.Effect, EffectAi.class)
            .put(ApiType.Encode, EncodeAi.class)
            .put(ApiType.Endure, EndureAi.class)
            .put(ApiType.EndCombatPhase, EndTurnAi.class)
            .put(ApiType.EndTurn, EndTurnAi.class)
            .put(ApiType.ExchangeLife, LifeExchangeAi.class)
            .put(ApiType.ExchangeLifeVariant, LifeExchangeVariantAi.class)
            .put(ApiType.ExchangeControl, ControlExchangeAi.class)
            .put(ApiType.ExchangeControlVariant, CannotPlayAi.class)
            .put(ApiType.ExchangePower, PowerExchangeAi.class)
            .put(ApiType.ExchangeZone, ZoneExchangeAi.class)
            .put(ApiType.Explore, ExploreAi.class)
            .put(ApiType.Fight, FightAi.class)
            .put(ApiType.FlipCoin, FlipCoinAi.class)
            .put(ApiType.FlipOntoBattlefield, FlipOntoBattlefieldAi.class)
            .put(ApiType.Fog, FogAi.class)
            .put(ApiType.GainControl, ControlGainAi.class)
            .put(ApiType.GainControlVariant, ControlGainVariantAi.class)
            .put(ApiType.GainLife, LifeGainAi.class)
            .put(ApiType.GainOwnership, CannotPlayAi.class)
            .put(ApiType.GameDrawn, CannotPlayAi.class)
            .put(ApiType.GenericChoice, ChooseGenericAi.class)
            .put(ApiType.Goad, GoadAi.class)
            .put(ApiType.Heist, AlwaysPlayAi.class)
            .put(ApiType.Haunt, HauntAi.class)
            .put(ApiType.ImmediateTrigger, ImmediateTriggerAi.class)
            .put(ApiType.Investigate, InvestigateAi.class)
            .put(ApiType.Learn, LearnAi.class)
            .put(ApiType.LoseLife, LifeLoseAi.class)
            .put(ApiType.LosePerpetual, AlwaysPlayAi.class)
            .put(ApiType.LosesGame, GameLossAi.class)
            .put(ApiType.MakeCard, AlwaysPlayAi.class)
            .put(ApiType.Mana, ManaAi.class)
            .put(ApiType.ManaReflected, CannotPlayAi.class)
            .put(ApiType.Manifest, ManifestAi.class)
            .put(ApiType.ManifestDread, ManifestAi.class)
            .put(ApiType.Meld, MeldAi.class)
            .put(ApiType.Mill, MillAi.class)
            .put(ApiType.MoveCounter, CountersMoveAi.class)
            .put(ApiType.MultiplePiles, CannotPlayAi.class)
            .put(ApiType.MultiplyCounter, CountersMultiplyAi.class)
            .put(ApiType.MustBlock, MustBlockAi.class)
            .put(ApiType.Mutate, MutateAi.class)
            .put(ApiType.NameCard, ChooseCardNameAi.class)
            //.put(ApiType.NoteCounters, AlwaysPlayAi.class)
            .put(ApiType.OpenAttraction, AssembleContraptionAi.class)
            .put(ApiType.PeekAndReveal, PeekAndRevealAi.class)
            .put(ApiType.PermanentCreature, PermanentCreatureAi.class)
            .put(ApiType.PermanentNoncreature, PermanentNoncreatureAi.class)
            .put(ApiType.Phases, PhasesAi.class)
            .put(ApiType.Planeswalk, AlwaysPlayAi.class)
            .put(ApiType.Play, PlayAi.class)
            .put(ApiType.PlayLandVariant, CannotPlayAi.class)
            .put(ApiType.Poison, PoisonAi.class)
            .put(ApiType.PreventDamage, DamagePreventAi.class)
            .put(ApiType.Proliferate, CountersProliferateAi.class)
            .put(ApiType.Protection, ProtectAi.class)
            .put(ApiType.ProtectionAll, ProtectAllAi.class)
            .put(ApiType.Pump, PumpAi.class)
            .put(ApiType.PumpAll, PumpAllAi.class)
            .put(ApiType.PutCounter, CountersPutAi.class)
            .put(ApiType.PutCounterAll, CountersPutAllAi.class)
            .put(ApiType.Radiation, AlwaysPlayAi.class)
            .put(ApiType.RearrangeTopOfLibrary, RearrangeTopOfLibraryAi.class)
            .put(ApiType.Regenerate, RegenerateAi.class)
            .put(ApiType.Regeneration, AlwaysPlayAi.class)
            .put(ApiType.RemoveCounter, CountersRemoveAi.class)
            .put(ApiType.RemoveCounterAll, CannotPlayAi.class)
            .put(ApiType.RemoveFromCombat, RemoveFromCombatAi.class)
            .put(ApiType.RemoveFromGame, AlwaysPlayAi.class)
            .put(ApiType.RemoveFromMatch, AlwaysPlayAi.class)
            .put(ApiType.ReorderZone, AlwaysPlayAi.class)
            .put(ApiType.Repeat, RepeatAi.class)
            .put(ApiType.RepeatEach, RepeatEachAi.class)
            .put(ApiType.ReplaceCounter, AlwaysPlayAi.class)
            .put(ApiType.ReplaceEffect, AlwaysPlayAi.class)
            .put(ApiType.ReplaceDamage, ReplaceDamageAi.class)
            .put(ApiType.ReplaceMana, AlwaysPlayAi.class)
            .put(ApiType.ReplaceSplitDamage, ReplaceDamageAi.class)
            .put(ApiType.ReplaceToken, AlwaysPlayAi.class)
            .put(ApiType.RestartGame, RestartGameAi.class)
            .put(ApiType.Reveal, RevealAi.class)
            .put(ApiType.RevealHand, RevealHandAi.class)
            .put(ApiType.ReverseTurnOrder, AlwaysPlayAi.class)
            .put(ApiType.RingTemptsYou, AlwaysPlayAi.class)
            .put(ApiType.RollDice, RollDiceAi.class)
            .put(ApiType.RollPlanarDice, RollPlanarDiceAi.class)
            .put(ApiType.RunChaos, AlwaysPlayAi.class)
            .put(ApiType.Sacrifice, SacrificeAi.class)
            .put(ApiType.SacrificeAll, SacrificeAllAi.class)
            .put(ApiType.Scry, ScryAi.class)
            .put(ApiType.Seek, AlwaysPlayAi.class)
            .put(ApiType.SetInMotion, AlwaysPlayAi.class)
            .put(ApiType.SetLife, LifeSetAi.class)
            .put(ApiType.SetState, SetStateAi.class)
            .put(ApiType.Shuffle, ShuffleAi.class)
            .put(ApiType.SkipPhase, SkipPhaseAi.class)
            .put(ApiType.SkipTurn, SkipTurnAi.class)
            .put(ApiType.StoreSVar, StoreSVarAi.class)
            .put(ApiType.Subgame, AlwaysPlayAi.class)
            .put(ApiType.Surveil, SurveilAi.class)
            .put(ApiType.TakeInitiative, AlwaysPlayAi.class)
            .put(ApiType.Tap, TapAi.class)
            .put(ApiType.TapAll, TapAllAi.class)
            .put(ApiType.TapOrUntap, TapOrUntapAi.class)
            .put(ApiType.TapOrUntapAll, TapOrUntapAllAi.class)
            .put(ApiType.TimeTravel, TimeTravelAi.class)
            .put(ApiType.Token, TokenAi.class)
            .put(ApiType.TwoPiles, TwoPilesAi.class)
            .put(ApiType.Unattach, UnattachAi.class)
            .put(ApiType.UnlockDoor, AlwaysPlayAi.class)
            .put(ApiType.Untap, UntapAi.class)
            .put(ApiType.UntapAll, UntapAllAi.class)
            .put(ApiType.Venture, VentureAi.class)
            .put(ApiType.VillainousChoice, AlwaysPlayAi.class)
            .put(ApiType.Vote, VoteAi.class)
            .put(ApiType.WinsGame, GameWinAi.class)

            .put(ApiType.DamageResolve, AlwaysPlayAi.class)
            .put(ApiType.InternalLegendaryRule, LegendaryRuleAi.class)
            .put(ApiType.InternalIgnoreEffect, CannotPlayAi.class)
            .put(ApiType.InternalRadiation, AlwaysPlayAi.class)
            .build());

    public SpellAbilityAi get(final SpellAbility sa) {
        ApiType api = sa.getApi();
        if (null == api) {
            throw new InvalidParameterException("SA is not api-based, this is not supported yet");
        }
        return get(api);
    }

    public SpellAbilityAi get(final ApiType api) {
        SpellAbilityAi result = apiToInstance.get(api);
        if (null == result) {
            Class<? extends SpellAbilityAi> clz = apiToClass.get(api);
            if (null == clz) {
                System.err.println("No AI assigned for API: " + api);
                clz = CannotPlayAi.class;
            }
            result = ReflectionUtil.makeDefaultInstanceOf(clz);
            apiToInstance.put(api, result);
        }
        return result;
    }
}
```
