---
aliases:
  - CardChangedWords
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/card
fqn: forge.game.card.CardChangedWords
package: forge.game.card
module: forge-game
kind: Class
---

# CardChangedWords

**Package:** `forge.game.card` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class CardChangedWords {
        -Table~Long,Long,WordHolder~ map
        -boolean isDirty
        -Map~String,String~ resultCache
        +addEmpty(long timestamp, long staticId) Long
        +add(long timestamp, long staticId, String originalWord, String newWord) Long
        +remove(Long timestamp, long staticId) boolean
        +clear() void
        ~copyFrom(CardChangedWords other) void
        #delegate() Map~String,String~
        -refreshCache() void
        +CardChangedWords()
    }
    CardChangedWords --|> ForwardingMap : extends
    CardChangedWords ..> WordHolder : uses
```

## Relationships
**Uses:**
- [[forge.game.card.CardChangedWords.WordHolder|WordHolder]]

## Design Description

`CardChangedWords` records timestamped word-substitution effects applied to a card (Magic's text-changing abilities, e.g. Volrath's Shapeshifter) and resolves them into a flat originalWordâ†’newWord mapping. It extends Guava's `ForwardingMap<String,String>`, so it behaves as a read-only `Map` to consumers while internally storing each change in a `TreeBasedTable` keyed by timestamp and static-effect id, paired with a private `WordHolder` capturing the old/new words or a reset flag.

Its central design intent is lazy, ordered resolution: mutations merely set an `isDirty` flag, and `delegate()` triggers `refreshCache()` only when needed, replaying changes in timestamp order so chained substitutions (aâ†’b then bâ†’c yielding aâ†’c) and clear-pairs compose correctly. The cached result avoids recomputation between edits. Helpers like `addEmpty`, `add`, `remove`, and the package-private `copyFrom` support layered effect bookkeeping and card-state copying.

## Source
`forge-game/src/main/java/forge/game/card/CardChangedWords.java`

```java
package forge.game.card;

import com.google.common.collect.ForwardingMap;
import com.google.common.collect.Maps;
import com.google.common.collect.Table;
import com.google.common.collect.TreeBasedTable;

import java.util.Map;

public final class CardChangedWords extends ForwardingMap<String, String> {

    class WordHolder {
        public String oldWord;
        public String newWord;

        public boolean clear = false;

        WordHolder() {
            this.clear = true;
        }
        WordHolder(String oldWord, String newWord) {
            this.oldWord = oldWord;
            this.newWord = newWord;
        }
    }

    private final Table<Long, Long, WordHolder> map = TreeBasedTable.create();

    private boolean isDirty = false;
    private Map<String, String> resultCache = Maps.newHashMap();

    public CardChangedWords() {
    }

    public Long addEmpty(final long timestamp, final long staticId) {
        final Long stamp = timestamp;
        map.put(stamp, staticId, new WordHolder()); // Table doesn't allow null value
        isDirty = true;
        return stamp;
    }

    public Long add(final long timestamp, final long staticId, final String originalWord, final String newWord) {
        final Long stamp = timestamp;
        map.put(stamp, staticId, new WordHolder(originalWord, newWord));
        isDirty = true;
        return stamp;
    }

    public boolean remove(final Long timestamp, final long staticId) {
        isDirty = true;
        return map.remove(timestamp, staticId) != null;
    }

    @Override
    public void clear() {
        super.clear();
        map.clear();
        isDirty = true;
    }

    void copyFrom(final CardChangedWords other) {
        map.clear();
        map.putAll(other.map);
        isDirty = true;
    }

    /**
     * Converts this object to a {@link Map}.
     *
     * @return a map of strings to strings, where each changed word in this
     * object is mapped to its corresponding replacement word.
     */
    @Override
    protected Map<String, String> delegate() {
        refreshCache();
        return resultCache;
    }

    private void refreshCache() {
        if (isDirty) {
            resultCache.clear();
            for (final WordHolder ccw : this.map.values()) {
                // is empty pair is for resetting the data, it is done for VolrathÃ¢â‚¬â„¢s Shapeshifter
                if (ccw.clear) {
                    resultCache.clear();
                    continue;
                }

                // changes because a->b and b->c (resulting in a->c)
                final Map<String, String> toBeChanged = Maps.newHashMap();
                for (final Entry<String, String> e : resultCache.entrySet()) {
                    if (e.getValue().equals(ccw.oldWord)) {
                        toBeChanged.put(e.getKey(), ccw.newWord);
                    }
                }
                resultCache.putAll(toBeChanged);

                // the actual change (b->c)
                resultCache.put(ccw.oldWord, ccw.newWord);
            }

            isDirty = false;
        }
    }
}
```

## Python
`forge/game/card/CardChangedWords.py`

```python
from com.google.common.collect.ForwardingMap import ForwardingMap


class CardChangedWords(ForwardingMap):

    class WordHolder:
        def __init__(self, oldWord=None, newWord=None):
            if oldWord is None and newWord is None:
                self.oldWord = None
                self.newWord = None
                self.clear = True
            else:
                self.oldWord = oldWord
                self.newWord = newWord
                self.clear = False

    def __init__(self):
        # Table<Long, Long, WordHolder>, kept sorted by (timestamp, staticId)
        self.map: dict[tuple[int, int], "CardChangedWords.WordHolder"] = {}
        self.isDirty = False
        self.resultCache: dict[str, str] = {}

    def addEmpty(self, timestamp: int, staticId: int) -> int:
        stamp = timestamp
        self.map[(stamp, staticId)] = CardChangedWords.WordHolder()  # Table doesn't allow null value
        self.isDirty = True
        return stamp

    def add(self, timestamp: int, staticId: int, originalWord: str, newWord: str) -> int:
        stamp = timestamp
        self.map[(stamp, staticId)] = CardChangedWords.WordHolder(originalWord, newWord)
        self.isDirty = True
        return stamp

    def remove(self, timestamp: int, staticId: int) -> bool:
        self.isDirty = True
        return self.map.pop((timestamp, staticId), None) is not None

    def clear(self) -> None:
        super().clear()
        self.map.clear()
        self.isDirty = True

    def copyFrom(self, other: "CardChangedWords") -> None:
        self.map.clear()
        self.map.update(other.map)
        self.isDirty = True

    def delegate(self) -> dict[str, str]:
        """
        Converts this object to a Map.

        :return: a map of strings to strings, where each changed word in this
        object is mapped to its corresponding replacement word.
        """
        self.refreshCache()
        return self.resultCache

    def refreshCache(self) -> None:
        if self.isDirty:
            self.resultCache.clear()
            for ccw in (self.map[k] for k in sorted(self.map)):
                # is empty pair is for resetting the data, it is done for Volrath's Shapeshifter
                if ccw.clear:
                    self.resultCache.clear()
                    continue

                # changes because a->b and b->c (resulting in a->c)
                toBeChanged: dict[str, str] = {}
                for key, value in self.resultCache.items():
                    if value == ccw.oldWord:
                        toBeChanged[key] = ccw.newWord
                self.resultCache.update(toBeChanged)

                # the actual change (b->c)
                self.resultCache[ccw.oldWord] = ccw.newWord

            self.isDirty = False
```
