---
aliases:
  - LandTraitChanges
tags:
  - java/record
  - module/forge-game
  - pkg/forge/game/card
fqn: forge.game.card.CardState.LandTraitChanges
package: forge.game.card
module: forge-game
kind: Record
---

# LandTraitChanges

**Package:** `forge.game.card` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Record

```mermaid
classDiagram
    class LandTraitChanges {
        <<record>>
        +applySpellAbility(List~SpellAbility~ list) List~SpellAbility~
        +applyTrigger(List~Trigger~ list) List~Trigger~
        +applyReplacementEffect(List~ReplacementEffect~ list) List~ReplacementEffect~
        +applyStaticAbility(List~StaticAbility~ list) List~StaticAbility~
        +applyKeywords(KeywordCollection list) void
        +copy(Card host, boolean lki) LandTraitChanges
        ~LandTraitChanges(CardState state)
    }
    LandTraitChanges ..|> ICardTraitChanges : implements
    LandTraitChanges ..|> IKeywordsChange : implements
    LandTraitChanges ..> Card : uses
    LandTraitChanges ..> CardState : uses
    LandTraitChanges ..> CardTypeView : uses
    LandTraitChanges ..> Color : uses
    LandTraitChanges ..> KeywordCollection : uses
    LandTraitChanges ..> MagicColor : uses
    LandTraitChanges ..> ReplacementEffect : uses
    LandTraitChanges ..> SpellAbility : uses
    LandTraitChanges ..> StaticAbility : uses
    LandTraitChanges ..> Trigger : uses
```

## Relationships
**Implements:**
- [[forge.game.card.ICardTraitChanges|ICardTraitChanges]]
- [[forge.game.keyword.IKeywordsChange|IKeywordsChange]]
**Uses:**
- [[forge.card.CardTypeView|CardTypeView]]
- [[forge.card.MagicColor|MagicColor]]
- [[forge.card.MagicColor.Color|Color]]
- [[forge.game.card.Card|Card]]
- [[forge.game.card.CardState|CardState]]
- [[forge.game.keyword.KeywordCollection|KeywordCollection]]
- [[forge.game.replacement.ReplacementEffect|ReplacementEffect]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]
- [[forge.game.trigger.Trigger|Trigger]]

## Design Description

`LandTraitChanges` is a nested record within `CardState` that models the trait modifications a card acquires when it becomes (or behaves as) a land. As an implementation of `ICardTraitChanges` and `IKeywordsChange`, it participates in Forge's layered trait-application pipeline, contributing the intrinsic mana abilities that basic land subtypes confer. Its central `applySpellAbility` method inspects the card's effective `CardTypeView`, and for each basic land subtype present synthesizes a tap-for-mana `SpellAbility` of the matching color, caching results in an `EnumMap` keyed by `MagicColor.Color` so generated abilities are reused.

The remaining `apply*` methods are deliberately minimal, only honoring `hasRemoveIntrinsic()` by clearing the supplied collections, since lands contribute no triggers, replacement effects, static abilities, or keywords. Being an immutable record, its `copy` simply returns `this`, reflecting that all state derives from the referenced `CardState` rather than from mutable per-instance data.

## Source
`forge-game/src/main/java/forge/game/card/CardState.java` â€” declaration excerpt

```java
    record LandTraitChanges(CardState state, Map<MagicColor.Color, SpellAbility> map) implements ICardTraitChanges, IKeywordsChange
    {
        LandTraitChanges(CardState state) {
            this(state, Maps.newEnumMap(MagicColor.Color.class));
        }

        public List<SpellAbility> applySpellAbility(List<SpellAbility> list) {
            if (state.getCard().hasRemoveIntrinsic()) {
                list.clear();
            }
            CardTypeView type = state.getTypeWithChanges();
            if (!type.isLand()) {
                return list;
            }
            for (MagicColor.Color c : MagicColor.Color.values()) {
               if (c.getBasicLandType() == null) {
                   continue;
               }
               if (type.hasSubtype(c.getBasicLandType())) {
                   list.add(map.computeIfAbsent(c, a -> {
                       String abString  = "AB$ Mana | Cost$ T | Produced$ " + a.getShortName() +
                               " | Secondary$ True | SpellDescription$ Add " + a.getSymbol() + ".";
                       SpellAbility sa = AbilityFactory.getAbility(abString, state);
                       sa.setIntrinsic(true); // always intrinsic
                       return sa;
                   }));
               }
            }
            return list;
        }
        public List<Trigger> applyTrigger(List<Trigger> list) {
            if (state.getCard().hasRemoveIntrinsic()) {
                list.clear();
            }
            return list;
        }
        public List<ReplacementEffect> applyReplacementEffect(List<ReplacementEffect> list) {
            if (state.getCard().hasRemoveIntrinsic()) {
                list.clear();
            }
            return list;
        }
        public List<StaticAbility> applyStaticAbility(List<StaticAbility> list) {
            if (state.getCard().hasRemoveIntrinsic()) {
                list.clear();
            }
            return list;
        }
        public void applyKeywords(KeywordCollection list) {
            if (state.getCard().hasRemoveIntrinsic()) {
                list.clear();
            }
        }
        public LandTraitChanges copy(Card host, boolean lki) { return this; }
    }
```
