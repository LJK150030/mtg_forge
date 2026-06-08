---
aliases:
  - KeywordsChange
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/keyword
fqn: forge.game.keyword.KeywordsChange
package: forge.game.keyword
module: forge-game
kind: Class
---

# KeywordsChange

**Package:** `forge.game.keyword` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class KeywordsChange {
        -KeywordCollection keywords
        -KeywordCollection removeKeywordInterfaces
        -List~String~ removeKeywords
        -boolean removeAllKeywords
        +getKeywords() Collection~KeywordInterface~
        +getRemovedKeywordInstances() Collection~KeywordInterface~
        +getRemoveKeywords() List~String~
        +isRemoveAllKeywords() boolean
        +isEmpty() boolean
        +setHostCard(Card host) void
        +copy(Card host, boolean lki) KeywordsChange
        +applySpellAbility(List~SpellAbility~ list) List~SpellAbility~
        +applyTrigger(List~Trigger~ list) List~Trigger~
        +applyReplacementEffect(List~ReplacementEffect~ list) List~ReplacementEffect~
        +applyStaticAbility(List~StaticAbility~ list) List~StaticAbility~
        +applyKeywords(KeywordCollection list) void
        +hasTraits() boolean
        +toString() String
        +KeywordsChange(Iterable~KeywordInterface~ keywordList, Collection~String~ removeKeywordList, boolean removeAll)
        +KeywordsChange(Collection~KeywordInterface~ keywordList, Collection~KeywordInterface~ removeKeywordInterfaces, boolean removeAll)
    }
    KeywordsChange ..|> ICardTraitChanges : implements
    KeywordsChange ..|> IKeywordsChange : implements
    KeywordsChange ..|> Cloneable : implements
    KeywordsChange ..> Card : uses
    KeywordsChange ..> KeywordCollection : uses
    KeywordsChange ..> KeywordInterface : uses
    KeywordsChange ..> ReplacementEffect : uses
    KeywordsChange ..> SpellAbility : uses
    KeywordsChange ..> StaticAbility : uses
    KeywordsChange ..> Trigger : uses
```

## Relationships
**Implements:**
- [[forge.game.card.ICardTraitChanges|ICardTraitChanges]]
- [[forge.game.keyword.IKeywordsChange|IKeywordsChange]]
**Uses:**
- [[forge.game.card.Card|Card]]
- [[forge.game.keyword.KeywordCollection|KeywordCollection]]
- [[forge.game.keyword.KeywordInterface|KeywordInterface]]
- [[forge.game.replacement.ReplacementEffect|ReplacementEffect]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]
- [[forge.game.trigger.Trigger|Trigger]]

## Source
`forge-game/src/main/java/forge/game/keyword/KeywordsChange.java`

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
package forge.game.keyword;

import java.util.Collection;
import java.util.List;

import com.google.common.collect.Lists;

import forge.game.card.Card;
import forge.game.card.ICardTraitChanges;
import forge.game.replacement.ReplacementEffect;
import forge.game.spellability.SpellAbility;
import forge.game.staticability.StaticAbility;
import forge.game.trigger.Trigger;

/**
 * <p>
 * Card_Keywords class.
 * </p>
 *
 * @author Forge
 */
public class KeywordsChange implements ICardTraitChanges, IKeywordsChange, Cloneable {
    private KeywordCollection keywords = new KeywordCollection();
    private KeywordCollection removeKeywordInterfaces = new KeywordCollection();
    private List<String> removeKeywords = Lists.newArrayList();
    private boolean removeAllKeywords;

    /**
     *
     * Construct a new {@link KeywordsChange}.
     *
     * @param keywordList the list of keywords to add.
     * @param removeKeywordList the list of keywords to remove.
     * @param removeAll whether to remove all keywords.
     */
    public KeywordsChange(
            final Iterable<KeywordInterface> keywordList,
            final Collection<String> removeKeywordList,
            final boolean removeAll) {
        if (keywordList != null) {
            this.keywords.insertAll(keywordList);
        }

        if (removeKeywordList != null) {
            this.removeKeywords.addAll(removeKeywordList);
        }

        this.removeAllKeywords = removeAll;
    }
    public KeywordsChange(
            final Collection<KeywordInterface> keywordList,
            final Collection<KeywordInterface> removeKeywordInterfaces,
            final boolean removeAll) {
        if (keywordList != null) {
            this.keywords.insertAll(keywordList);
        }

        if (removeKeywordInterfaces != null) {
            this.removeKeywordInterfaces.insertAll(removeKeywordInterfaces);
        }

        this.removeAllKeywords = removeAll;
    }

    /**
     *
     * getKeywords.
     *
     * @return ArrayList<String>
     */
    public final Collection<KeywordInterface> getKeywords() {
        return this.keywords.getValues();
    }

    public final Collection<KeywordInterface> getRemovedKeywordInstances() {
        return this.removeKeywordInterfaces.getValues();
    }
    /**
     *
     * getRemoveKeywords.
     *
     * @return ArrayList<String>
     */
    public final List<String> getRemoveKeywords() {
        return this.removeKeywords;
    }

    /**
     *
     * isRemoveAllKeywords.
     *
     * @return boolean
     */
    public final boolean isRemoveAllKeywords() {
        return this.removeAllKeywords;
    }

    /**
     * @return whether this KeywordsChange doesn't have any effect.
     */
    public final boolean isEmpty() {
        return !this.removeAllKeywords
                && this.keywords.isEmpty()
                && this.removeKeywords.isEmpty();
    }

    public void setHostCard(final Card host) {
        keywords.setHostCard(host);
        for (KeywordInterface k : removeKeywordInterfaces) {
            k.setHostCard(host);
        }
    }

    public KeywordsChange copy(final Card host, final boolean lki) {
        try {
            KeywordsChange result = (KeywordsChange)super.clone();

            result.keywords = this.keywords.copy(host, lki);
            result.removeKeywords = Lists.newArrayList(removeKeywords);
            result.removeKeywordInterfaces = this.removeKeywordInterfaces.copy(host, lki);

            return result;
        }  catch (final Exception ex) {
            throw new RuntimeException("KeywordsChange : clone() error", ex);
        }
    }

    public List<SpellAbility> applySpellAbility(List<SpellAbility> list) {
        return keywords.applySpellAbility(list);
    }
    public List<Trigger> applyTrigger(List<Trigger> list) {
        return keywords.applyTrigger(list);
    }
    public List<ReplacementEffect> applyReplacementEffect(List<ReplacementEffect> list) {
        return keywords.applyReplacementEffect(list);
    }
    public List<StaticAbility> applyStaticAbility(List<StaticAbility> list) {
        return keywords.applyStaticAbility(list);
    }

    public void applyKeywords(KeywordCollection list) {
        if (isRemoveAllKeywords()) {
            list.clear();
        }
        else if (getRemoveKeywords() != null) {
            list.removeAll(getRemoveKeywords());
        }

        list.removeInstances(getRemovedKeywordInstances());

        if (getKeywords() != null) {
            list.insertAll(getKeywords());
        }
    }

    public boolean hasTraits() {
        for (KeywordInterface k : this.keywords.getValues()) {
            if (k.hasTraits()) {
                return true;
            }
        }
        return false;
    }

    /* (non-Javadoc)
     * @see java.lang.Object#toString()
     */
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("<+");
        sb.append(this.keywords);
        sb.append("|-");
        sb.append(this.removeKeywordInterfaces);
        sb.append("|-");
        sb.append(this.removeKeywords);
        sb.append(">");
        return sb.toString();
    }
}
```
