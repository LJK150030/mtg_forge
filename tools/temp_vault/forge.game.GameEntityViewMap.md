---
aliases:
  - GameEntityViewMap
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game
fqn: forge.game.GameEntityViewMap
package: forge.game
module: forge-game
kind: Class
---

# GameEntityViewMap

**Package:** `forge.game` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class GameEntityViewMap {
        -Map~View,Entity~ dataMap
        #delegate() Map~View,Entity~
        +put(Entity e) void
        +putAll(Iterable~Entity~ entities) void
        +remove(Entity e) void
        +removeAll(Iterable~Entity~ entities) void
        +addToList(Iterable~View~ views, List~Entity~ list) List~Entity~
        +getTrackableKeys() TrackableCollection~View~
    }
    GameEntityViewMap --|> ForwardingMap : extends
    GameEntityViewMap ..> GameEntity : uses
    GameEntityViewMap ..> GameEntityView : uses
    GameEntityViewMap ..> TrackableCollection : uses
```

## Relationships
**Uses:**
- [[forge.game.GameEntity|GameEntity]]
- [[forge.game.GameEntityView|GameEntityView]]
- [[forge.trackable.TrackableCollection|TrackableCollection]]

## Design Description

`GameEntityViewMap` is a typed bidirectional lookup that maps each game entity's lightweight view object back to its authoritative model entity. Parameterized over `Entity extends GameEntity` and `View extends GameEntityView`, it extends Guava's `ForwardingMap`, delegating storage to a `LinkedHashMap` so insertion order is preserved while inheriting the full `Map` contract.

Its design intent is to keep the view-to-entity correspondence in sync with minimal caller effort: convenience overloads derive each key automatically via `e.getView()`, so callers `put`/`remove` entities without manually managing keys, and bulk `putAll`/`removeAll` variants iterate over collections. `addToList` resolves a sequence of views back into their entities (skipping unmatched ones), supporting the common need to translate UI-side view references into model objects. `getTrackableKeys` exposes the view keys as a `TrackableCollection`, bridging the map into Forge's trackable/observable layer used to relay game state to the UI.

## Source
`forge-game/src/main/java/forge/game/GameEntityViewMap.java`

```java
package forge.game;

import java.util.List;
import java.util.Map;

import com.google.common.collect.ForwardingMap;
import com.google.common.collect.Maps;

import forge.trackable.TrackableCollection;

public class GameEntityViewMap<Entity extends GameEntity, View extends GameEntityView> extends ForwardingMap<View, Entity> {
    private Map<View, Entity> dataMap = Maps.newLinkedHashMap();

    @Override
    protected Map<View, Entity> delegate() {
        return dataMap;
    }

    @SuppressWarnings("unchecked")
    public void put(Entity e) {
        this.put((View) e.getView(), e);
    }

    public void putAll(Iterable<Entity> entities) {
        for (Entity e : entities) {
            put(e);
        }
    }

    public void remove(Entity e) {
        this.remove(e.getView());
    }

    public void removeAll(Iterable<Entity> entities) {
        for (Entity e : entities) {
            remove(e);
        }
    }

    public List<Entity> addToList(Iterable<View> views, List<Entity> list) {
        if (views == null) {
            return list;
        }
        for (View view : views) {
            Entity entity = get(view);
            if (entity != null) {
                list.add(entity);
            }
        }
        return list;
    }

    public TrackableCollection<View> getTrackableKeys() {
        return new TrackableCollection<View>(this.keySet());
    }
}
```
