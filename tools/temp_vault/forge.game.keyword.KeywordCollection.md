---
aliases:
  - KeywordCollection
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/keyword
fqn: forge.game.keyword.KeywordCollection
package: forge.game.keyword
module: forge-game
kind: Class
---

# KeywordCollection

**Package:** `forge.game.keyword` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class KeywordCollection {
        -Multimap~Keyword,KeywordInterface~ map
        +contains(Keyword keyword) boolean
        +isEmpty() boolean
        +size() int
        +getAmount(Keyword keyword) int
        +add(String k) KeywordInterface
        +insert(KeywordInterface inst) boolean
        +addAll(Iterable~String~ keywords) void
        +insertAll(Iterable~KeywordInterface~ inst) boolean
        +remove(String keyword) boolean
        +remove(KeywordInterface keyword) boolean
        +removeAll(Keyword kenum) boolean
        +removeAll(Iterable~String~ keywords) boolean
        +removeInstances(Iterable~KeywordInterface~ keywords) boolean
        +clear() void
        +contains(String keyword) boolean
        +getAmount(String k) int
        +getValues() Collection~KeywordInterface~
        +getValues(Keyword keyword) Collection~KeywordInterface~
        +asStringList() List~String~
        +getView() KeywordCollectionView
        +setHostCard(Card host) void
        +toString() String
        +applySpellAbility(List~SpellAbility~ list) List~SpellAbility~
        +applyTrigger(List~Trigger~ list) List~Trigger~
        +applyReplacementEffect(List~ReplacementEffect~ list) List~ReplacementEffect~
        +applyStaticAbility(List~StaticAbility~ list) List~StaticAbility~
        +copy(Card host, boolean lki) KeywordCollection
        +applyChanges(Iterable~IKeywordsChange~ changes) void
        +iterator() Iterator~KeywordInterface~
        +KeywordCollection()
    }
    KeywordCollection ..|> ICardTraitChanges : implements
    KeywordCollection ..|> Iterable : implements
    KeywordCollection ..> Card : uses
    KeywordCollection ..> IKeywordsChange : uses
    KeywordCollection ..> Keyword : uses
    KeywordCollection ..> KeywordCollectionView : uses
    KeywordCollection ..> KeywordInterface : uses
    KeywordCollection ..> ReplacementEffect : uses
    KeywordCollection ..> SpellAbility : uses
    KeywordCollection ..> StaticAbility : uses
    KeywordCollection ..> Trigger : uses
```

## Relationships
**Implements:**
- [[forge.game.card.ICardTraitChanges|ICardTraitChanges]]
**Uses:**
- [[forge.game.card.Card|Card]]
- [[forge.game.keyword.IKeywordsChange|IKeywordsChange]]
- [[forge.game.keyword.Keyword|Keyword]]
- [[forge.game.keyword.KeywordCollectionView|KeywordCollectionView]]
- [[forge.game.keyword.KeywordInterface|KeywordInterface]]
- [[forge.game.replacement.ReplacementEffect|ReplacementEffect]]
- [[forge.game.spellability.SpellAbility|SpellAbility]]
- [[forge.game.staticability.StaticAbility|StaticAbility]]
- [[forge.game.trigger.Trigger|Trigger]]

## Source
`forge-game/src/main/java/forge/game/keyword/KeywordCollection.java`

```java
package forge.game.keyword;

import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.stream.Collectors;

import com.google.common.collect.Lists;
import com.google.common.collect.Multimap;
import com.google.common.collect.MultimapBuilder;

import forge.game.card.Card;
import forge.game.card.ICardTraitChanges;
import forge.game.replacement.ReplacementEffect;
import forge.game.spellability.SpellAbility;
import forge.game.staticability.StaticAbility;
import forge.game.trigger.Trigger;

public class KeywordCollection implements ICardTraitChanges, Iterable<KeywordInterface> {
    // don't use enumKeys it causes a slow down
    private final Multimap<Keyword, KeywordInterface> map = MultimapBuilder.hashKeys()
            .linkedHashSetValues().build();

    public KeywordCollection() {
        super();
    }

    public boolean contains(Keyword keyword) {
        return map.containsKey(keyword);
    }

    public boolean isEmpty() {
        return map.isEmpty();
    }

    public int size() {
        return map.values().size();
    }

    public int getAmount(Keyword keyword) {
        int amount = 0;
        for (KeywordInterface inst : map.get(keyword)) {
            amount += inst.getAmount();
        }
        return amount;
    }

    public KeywordInterface add(String k) {
        KeywordInterface inst = Keyword.getInstance(k);
        if (insert(inst)) {
            return inst;
        }
        return null;
    }
    public boolean insert(KeywordInterface inst) {
        Keyword keyword = inst.getKeyword();
        Collection<KeywordInterface> list = map.get(keyword);
        if (list.isEmpty() || !inst.redundant(list)) {
            list.add(inst);
            return true;
        }
        return false;
    }

    public void addAll(Iterable<String> keywords) {
        for (String k : keywords) {
            add(k);
        }
    }

    public boolean insertAll(Iterable<KeywordInterface> inst) {
        boolean result = false;
        for (KeywordInterface k : inst) {
            if (insert(k)) {
                result = true;
            }
        }
        return result;
    }

    public boolean remove(String keyword) {
        Iterator<KeywordInterface> it = map.values().iterator();

        boolean result = false;
        while (it.hasNext()) {
            KeywordInterface k = it.next();
            if (k.getOriginal().startsWith(keyword)) {
                it.remove();
                result = true;
            }
        }

        return result;
    }

    public boolean remove(KeywordInterface keyword) {
        return map.remove(keyword.getKeyword(), keyword);
    }

    public boolean removeAll(Keyword kenum) {
        return !map.removeAll(kenum).isEmpty();
    }

    public boolean removeAll(Iterable<String> keywords) {
        boolean result = false;
        for (String k : keywords) {
            if (remove(k)) {
                result = true;
            }
        }
        return result;
    }

    public boolean removeInstances(Iterable<KeywordInterface> keywords) {
        boolean result = false;
        for (KeywordInterface k : keywords) {
            if (map.remove(k.getKeyword(), k)) {
                result = true;
            }
        }
        return result;
    }

    public void clear() {
        map.clear();
    }

    public boolean contains(String keyword) {
        for (KeywordInterface inst : map.values()) {
            if (keyword.equals(inst.getOriginal())) {
                return true;
            }
        }
        return false;
    }

    public int getAmount(String k) {
        int amount = 0;
        for (KeywordInterface inst : map.values()) {
            if (k.equals(inst.getOriginal())) {
                amount++;
            }
        }
        return amount;
    }

    public Collection<KeywordInterface> getValues() {
        return map.values();
    }

    public Collection<KeywordInterface> getValues(final Keyword keyword) {
        return map.get(keyword);
    }

    public List<String> asStringList() {
        List<String> result = Lists.newArrayList();
        for (KeywordInterface kw : getValues()) {
            result.add(kw.getOriginal());
        }
        return result;
    }

    public KeywordCollectionView getView() {
        return new KeywordCollectionView(getValues().stream().map(KeywordInterface::getView).collect(Collectors.toList()));
    }

    public void setHostCard(final Card host) {
        for (KeywordInterface k : map.values()) {
            k.setHostCard(host);
        }
    }

    /* (non-Javadoc)
     * @see java.lang.Object#toString()
     */
    @Override
    public String toString() {
        StringBuilder sb  = new StringBuilder();

        sb.append(map.values());
        return sb.toString();
    }

    @Override
    public List<SpellAbility> applySpellAbility(List<SpellAbility> list) {
        for (KeywordInterface k : getValues()) {
            k.applySpellAbility(list);
        }
        return list;
    }
    @Override
    public List<Trigger> applyTrigger(List<Trigger> list) {
        for (KeywordInterface k : getValues()) {
            k.applyTrigger(list);
        }
        return list;
    }
    @Override
    public List<ReplacementEffect> applyReplacementEffect(List<ReplacementEffect> list) {
        for (KeywordInterface k : getValues()) {
            k.applyReplacementEffect(list);
        }
        return list;
    }
    @Override
    public List<StaticAbility> applyStaticAbility(List<StaticAbility> list) {
        for (KeywordInterface k : getValues()) {
            k.applyStaticAbility(list);
        }
        return list;
    }
    @Override
    public KeywordCollection copy(Card host, boolean lki) {
        KeywordCollection result = new KeywordCollection();
        for (KeywordInterface ki : getValues()) {
            result.insert(ki.copy(host, lki));
        }
        return result;
    }

    public void applyChanges(Iterable<IKeywordsChange> changes) {
        for (final IKeywordsChange ck : changes) {
            ck.applyKeywords(this);
        }
    }

    @Override
    public Iterator<KeywordInterface> iterator() {
        return this.map.values().iterator();
    }
}
```
