---
aliases:
  - Suspend
tags:
  - java/class
  - module/forge-game
  - pkg/forge/game/keyword
fqn: forge.game.keyword.Suspend
package: forge.game.keyword
module: forge-game
kind: Class
---

# Suspend

**Package:** `forge.game.keyword` &nbsp; **Module:** `forge-game` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class Suspend {
        ~boolean withoutCostAndAmount
        +getTitle() String
        #parse(String details) void
        #formatReminderText(String reminderText) String
    }
    Suspend --|> KeywordWithCostAndAmount : extends
```

## Relationships
**Extends:**
- [[forge.game.keyword.KeywordWithCostAndAmount|KeywordWithCostAndAmount]]

## Source
`forge-game/src/main/java/forge/game/keyword/Suspend.java`

```java
package forge.game.keyword;

public class Suspend extends KeywordWithCostAndAmount {

    boolean withoutCostAndAmount = false;

    @Override
    public String getTitle() {
        if (withoutCostAndAmount) {
            return getKeyword().toString();
        }
        return super.getTitle();
    }

    @Override
    protected void parse(String details) {
        if ("".equals(details)) {
            withoutCostAndAmount = true;
        } else {
            super.parse(details);
        }
    }

    @Override
    protected String formatReminderText(String reminderText) {
        if (withoutCostAndAmount) {
            return "At the beginning of its owner's upkeep, remove a time counter from that card. When the last is removed, the player plays it without paying its mana cost. If it's a creature, it has haste.";
        } else {
            return super.formatReminderText(reminderText);
        }
    }
}
```
