---
aliases:
  - Landwalk
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/keyword
fqn: forge.game.keyword.Landwalk
package: forge.game.keyword
module: forge-game
kind: Class
---

# Landwalk

**Package:** `forge.game.keyword` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class Landwalk {
        +getTitle() String
    }
    Landwalk --|> KeywordWithType : extends
```

## Relationships
**Extends:**
- [[forge.game.keyword.KeywordWithType|KeywordWithType]]

## Source
`forge-game/src/main/java/forge/game/keyword/Landwalk.java`

```java
package forge.game.keyword;

public class Landwalk extends KeywordWithType {
    @Override
    public String getTitle() {
        return getTypeDescription() + "walk";
    }
}
```
