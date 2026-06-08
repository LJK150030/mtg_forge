---
aliases:
  - KeywordInterface
tags:
  - java/interface
  - module/forge-game
  - pkg/forge/game/keyword
fqn: forge.game.keyword.KeywordInterface
package: forge.game.keyword
module: forge-game
kind: Interface
---

# KeywordInterface

**Package:** `forge.game.keyword` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Interface

```mermaid
classDiagram
    class KeywordInterface {
        <<interface>>
        ~getHostCard() Card
        ~setHostCard(Card host) void
        ~isIntrinsic() boolean
        ~setIntrinsic(boolean value) void
        ~getOriginal() String
        ~getKeyword() Keyword
        ~getTitle() String
        ~getReminderText() String
        ~getAmount() int
        ~getAmountString() String
        ~getStatic() StaticAbility
        ~setStatic(StaticAbility st) void
        ~getIdx() long
        ~setIdx(long i) void
        ~createTraits(Card host, boolean intrinsic) void
        ~createTraits(Card host, boolean intrinsic, boolean clear) void
        ~createTraits(Player player) void
        ~createTraits(Player player, boolean clear) void
        ~hasTraits() boolean
        ~addTrigger(Trigger trg) void
        ~addReplacement(ReplacementEffect trg) void
        ~addSpellAbility(SpellAbility s) void
        ~addStaticAbility(StaticAbility st) void
        ~getTriggers() Collection~Trigger~
        ~getReplacements() Collection~ReplacementEffect~
        ~getAbilities() Collection~SpellAbility~
        ~getStaticAbilities() Collection~StaticAbility~
        ~copy(Card host, boolean lki) KeywordInterface
        ~redundant(Collection~KeywordInterface~ list) boolean
        ~getView() KeywordView
    }
    KeywordInterface --|> Cloneable : extends
    KeywordInterface --|> IHasSVars : extends
    KeywordInterface --|> ICardTraitChanges : extends
    KeywordInterface ..> Card : uses
    KeywordInterface ..> DefaultKeywordView : uses
    KeywordInterface ..> Keyword : uses
    KeywordInterface ..> KeywordView : uses
    KeywordInterface ..> Player : uses
    KeywordInterface ..> ReplacementEffect : uses
    KeywordInterface ..> SpellAbility : uses
    KeywordInterface ..> StaticAbility : uses
    KeywordInterface ..> Trigger : uses
```

## Relationships
**Extends:**
- [[forge.game.IHasSVars|IHasSVars]]
- [[forge.game.card.ICardTraitChanges|ICardTraitChanges]]
**Uses:**
- [[forge.game.card.Card|Card]]
- [[forge.game.keyword.DefaultKeywordView|DefaultKeywordView]]
- [[forge.game.keyword.Keyword|Keyword]]
- [[forge.game.keyword.KeywordView|KeywordView]]
- [[forge.game.player.Player|Player]]
- [[forge.game.replacement.ReplacementEffect|ReplacementEffect]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]
- [[forge.game.trigger.Trigger|Trigger]]

## Source
`forge-game/src/main/java/forge/game/keyword/KeywordInterface.java`

```java
package forge.game.keyword;

import java.util.Collection;

import forge.game.IHasSVars;
import forge.game.card.Card;
import forge.game.card.ICardTraitChanges;
import forge.game.player.Player;
import forge.game.replacement.ReplacementEffect;
import forge.game.spellability.SpellAbility;
import forge.game.staticability.StaticAbility;
import forge.game.trigger.Trigger;

public interface KeywordInterface extends Cloneable, IHasSVars, ICardTraitChanges {

    Card getHostCard();
    void setHostCard(final Card host);
    boolean isIntrinsic();
    void setIntrinsic(final boolean value);

    String getOriginal();

    Keyword getKeyword();

    String getTitle();
    String getReminderText();

    int getAmount();
    String getAmountString();

    StaticAbility getStatic();
    void setStatic(StaticAbility st);

    long getIdx();
    void setIdx(long i);

    void createTraits(final Card host, final boolean intrinsic);
    void createTraits(final Card host, final boolean intrinsic, final boolean clear);

    void createTraits(final Player player);
    void createTraits(final Player player, final boolean clear);

    boolean hasTraits();

    void addTrigger(final Trigger trg);

    void addReplacement(final ReplacementEffect trg);

    void addSpellAbility(final SpellAbility s);
    void addStaticAbility(final StaticAbility st);


    /**
     * @return the triggers
     */
    Collection<Trigger> getTriggers();
    /**
     * @return the replacements
     */
    Collection<ReplacementEffect> getReplacements();
    /**
     * @return the abilities
     */
    Collection<SpellAbility> getAbilities();
    /**
     * @return the staticAbilities
     */
    Collection<StaticAbility> getStaticAbilities();

    KeywordInterface copy(final Card host, final boolean lki);

    boolean redundant(final Collection<KeywordInterface> list);

    default KeywordView getView() {
        return new DefaultKeywordView(getOriginal(), getKeyword(), getTitle(), getReminderText());
    }
}
```
