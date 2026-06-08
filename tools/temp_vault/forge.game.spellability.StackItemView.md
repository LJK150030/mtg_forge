---
aliases:
  - StackItemView
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/spellability
fqn: forge.game.spellability.StackItemView
package: forge.game.spellability
module: forge-game
kind: Class
---

# StackItemView

**Package:** `forge.game.spellability` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class StackItemView {
        -long serialVersionUID
        +get(SpellAbilityStackInstance si) StackItemView
        +getCollection(Iterable~SpellAbilityStackInstance~ instances) TrackableCollection~StackItemView~
        +getKey() String
        ~updateKey(SpellAbilityStackInstance si) void
        +getOptionalCostString() String
        ~updateOptionalCost(SpellAbilityStackInstance si) void
        +isTrigger() boolean
        +getSourceTrigger() int
        ~updateSourceTrigger(SpellAbilityStackInstance si) void
        +getText() String
        ~updateText(SpellAbilityStackInstance si) void
        +getSourceCard() CardView
        ~updateSourceCard(SpellAbilityStackInstance si) void
        +getActivatingPlayer() PlayerView
        ~updateActivatingPlayer(SpellAbilityStackInstance si) void
        +getTargetCards() FCollectionView~CardView~
        ~updateTargetCards(SpellAbilityStackInstance si) void
        +getTargetPlayers() FCollectionView~PlayerView~
        ~updateTargetPlayers(SpellAbilityStackInstance si) void
        +isAbility() boolean
        ~updateAbility(SpellAbilityStackInstance si) void
        +isOptionalTrigger() boolean
        ~updateOptionalTrigger(SpellAbilityStackInstance si) void
        +getSubInstance() StackItemView
        ~updateSubInstance(SpellAbilityStackInstance si) void
        +toString() String
        +getCardView() CardView
        +StackItemView(SpellAbilityStackInstance si)
        +StackItemView(int id0, Tracker tracker)
    }
    StackItemView --|> TrackableObject : extends
    StackItemView ..|> IHasCardView : implements
    StackItemView ..> CardView : uses
    StackItemView ..> FCollectionView : uses
    StackItemView ..> OptionalCost : uses
    StackItemView ..> PlayerView : uses
    StackItemView ..> SpellAbilityStackInstance : uses
    StackItemView ..> TrackableCollection : uses
    StackItemView ..> Tracker : uses
```

## Relationships
**Extends:**
- [[forge.trackable.TrackableObject|TrackableObject]]
**Implements:**
- [[forge.game.card.IHasCardView|IHasCardView]]
**Uses:**
- [[forge.game.card.CardView|CardView]]
- [[forge.game.player.PlayerView|PlayerView]]
- [[forge.game.spellability.OptionalCost|OptionalCost]]
- [[forge.game.spellability.SpellAbilityStackInstance|SpellAbilityStackInstance]]
- [[forge.trackable.TrackableCollection|TrackableCollection]]
- [[forge.trackable.Tracker|Tracker]]
- [[forge.util.collect.FCollectionView|FCollectionView]]

## Source
`forge-game/src/main/java/forge/game/spellability/StackItemView.java`

```java
package forge.game.spellability;

import forge.game.card.CardView;
import forge.game.card.IHasCardView;
import forge.game.player.PlayerView;
import forge.trackable.TrackableCollection;
import forge.trackable.TrackableObject;
import forge.trackable.Tracker;
import forge.trackable.TrackableProperty;
import forge.util.collect.FCollectionView;

public class StackItemView extends TrackableObject implements IHasCardView {
    private static final long serialVersionUID = 6733415646691356052L;

    public static StackItemView get(SpellAbilityStackInstance si) {
        return si == null ? null : si.getView();
    }

    public static TrackableCollection<StackItemView> getCollection(Iterable<SpellAbilityStackInstance> instances) {
        if (instances == null) {
            return null;
        }
        TrackableCollection<StackItemView> collection = new TrackableCollection<>();
        for (SpellAbilityStackInstance si : instances) {
            collection.add(si.getView());
        }
        return collection;
    }

    public StackItemView(SpellAbilityStackInstance si) {
        super(si.getId(), si.getSourceCard().getGame().getTracker());
        updateKey(si);
        updateSourceTrigger(si);
        updateText(si);
        updateSourceCard(si);
        updateActivatingPlayer(si);
        updateTargetCards(si);
        updateTargetPlayers(si);
        updateAbility(si);
        updateOptionalTrigger(si);
        updateSubInstance(si);
        updateOptionalCost(si);
    }

    /**
     * Constructor for network deserialization.
     * Creates an empty StackItemView that will be populated via property deserialization.
     */
    public StackItemView(final int id0, final Tracker tracker) {
        super(id0, tracker);
    }

    public String getKey() {
        return get(TrackableProperty.Key);
    }
    void updateKey(SpellAbilityStackInstance si) {
    	set(TrackableProperty.Key, si.getSpellAbility().yieldKey());
    }

    public String getOptionalCostString() {
        return get(TrackableProperty.OptionalCosts);
    }
    void updateOptionalCost(SpellAbilityStackInstance si) {
        String OptionalCostString = "";
        boolean kicked = false;
        boolean entwined = false;
        boolean buyback = false;
        boolean retraced = false;
        boolean jumpstart = false;
        boolean additional = false;
        boolean alternate = false;
        boolean generic = false;

        for (OptionalCost cost : si.getSpellAbility().getOptionalCosts()) {
            if (cost == OptionalCost.Kicker1 || cost == OptionalCost.Kicker2)
                kicked = true;
            if (cost == OptionalCost.Entwine)
                entwined = true;
            if (cost == OptionalCost.Buyback)
                buyback = true;
            if (cost == OptionalCost.Retrace)
                retraced = true;
            if (cost == OptionalCost.Jumpstart)
                jumpstart = true;
            if (cost == OptionalCost.Flash)
                additional = true;
            if (cost == OptionalCost.Generic)
                generic = true;
            if (cost == OptionalCost.AltCost)
                alternate = true;
        }
        if (!alternate) {
            if (kicked && !generic)
                OptionalCostString += "Kicked";
            if (entwined)
                OptionalCostString += OptionalCostString.isEmpty() ? "Entwined" : ", Entwined";
            if (buyback)
                OptionalCostString += OptionalCostString.isEmpty() ? "Buyback" : ", Buyback";
            if (retraced)
                OptionalCostString += OptionalCostString.isEmpty() ? "Retraced" : ", Retraced";
            if (jumpstart)
                OptionalCostString += OptionalCostString.isEmpty() ? "Jumpstart" : ", Jumpstart";
            if (additional || generic)
                OptionalCostString += OptionalCostString.isEmpty() ? "Additional" : ", Additional";
        }
        set(TrackableProperty.OptionalCosts, OptionalCostString);
    }

    public boolean isTrigger() {
        return getSourceTrigger() > 0;
    }

    public int getSourceTrigger() {
        return get(TrackableProperty.SourceTrigger);
    }
    void updateSourceTrigger(SpellAbilityStackInstance si) {
        set(TrackableProperty.SourceTrigger, si.getSpellAbility().getSourceTrigger());
    }

    public String getText() {
        return get(TrackableProperty.Text);
    }
    void updateText(SpellAbilityStackInstance si) {
        set(TrackableProperty.Text, si.getStackDescription());
    }

    public CardView getSourceCard() {
        return get(TrackableProperty.SourceCard);
    }
    void updateSourceCard(SpellAbilityStackInstance si) {
        set(TrackableProperty.SourceCard, CardView.get(si.getSourceCard()));
    }

    public PlayerView getActivatingPlayer() {
        return get(TrackableProperty.ActivatingPlayer);
    }
    void updateActivatingPlayer(SpellAbilityStackInstance si) {
        set(TrackableProperty.ActivatingPlayer, PlayerView.get(si.getActivatingPlayer()));
    }

    public FCollectionView<CardView> getTargetCards() {
        return get(TrackableProperty.TargetCards);
    }
    void updateTargetCards(SpellAbilityStackInstance si) {
        set(TrackableProperty.TargetCards, CardView.getCollection(si.getTargetChoices().getTargetCards()));
    }

    public FCollectionView<PlayerView> getTargetPlayers() {
        return get(TrackableProperty.TargetPlayers);
    }
    void updateTargetPlayers(SpellAbilityStackInstance si) {
        set(TrackableProperty.TargetPlayers, PlayerView.getCollection(si.getTargetChoices().getTargetPlayers()));
    }

    public boolean isAbility() {
        return get(TrackableProperty.Ability);
    }
    void updateAbility(SpellAbilityStackInstance si) {
        set(TrackableProperty.Ability, si.isAbility());
    }

    public boolean isOptionalTrigger() {
        return get(TrackableProperty.OptionalTrigger);
    }
    void updateOptionalTrigger(SpellAbilityStackInstance si) {
        set(TrackableProperty.OptionalTrigger, si.isOptionalTrigger());
    }

    public StackItemView getSubInstance() {
        return get(TrackableProperty.SubInstance);
    }
    void updateSubInstance(SpellAbilityStackInstance si) {
        set(TrackableProperty.SubInstance, si.getSubInstance() == null ? null : new StackItemView(si.getSubInstance()));
    }

    @Override
    public String toString() {
        return getText();
    }

    @Override
    public CardView getCardView() {
        return getSourceCard();
    }
}
```
