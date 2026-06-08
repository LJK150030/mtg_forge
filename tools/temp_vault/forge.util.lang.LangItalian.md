---
aliases:
  - LangItalian
tags:
  - java/class
  - module/forge-core
  - pkg/forge/util/lang
fqn: forge.util.lang.LangItalian
package: forge.util.lang
module: forge-core
kind: Class
---

# LangItalian

**Package:** `forge.util.lang` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class LangItalian {
        +getOrdinal(int position) String
        +getPossesive(String name) String
        +getPossessedObject(String owner, String object) String
    }
    LangItalian --|> Lang : extends
```

## Relationships
**Extends:**
- [[forge.util.Lang|Lang]]

## Source
`forge-core/src/main/java/forge/util/lang/LangItalian.java`

```java
package forge.util.lang;

import forge.util.Lang;

public class LangItalian extends Lang {
    
    @Override
    public String getOrdinal(final int position) {
        return position + "º";
    }

    // TODO: Please update this when you modified lblYou in it-IT.properties
    @Override
    public String getPossesive(final String name) {
        if ("You".equalsIgnoreCase(name)) {
            return name + "r"; // to get "your"
        }
        return name.endsWith("s") ? name + "'" : name + "'s";
    }

    @Override
    public String getPossessedObject(final String owner, final String object) {
        return getPossesive(owner) + " " + object;
    }

}
```
