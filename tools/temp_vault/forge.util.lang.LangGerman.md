---
aliases:
  - LangGerman
tags:
  - java/class
  - module/forge-core
  - pkg/forge/util/lang
fqn: forge.util.lang.LangGerman
package: forge.util.lang
module: forge-core
kind: Class
---

# LangGerman

**Package:** `forge.util.lang` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class LangGerman {
        +getOrdinal(int position) String
        +getPossesive(String name) String
        +getPossessedObject(String owner, String object) String
    }
    LangGerman --|> Lang : extends
```

## Relationships
**Extends:**
- [[forge.util.Lang|Lang]]

## Source
`forge-core/src/main/java/forge/util/lang/LangGerman.java`

```java
package forge.util.lang;

import forge.util.Lang;

public class LangGerman extends Lang {
    
    @Override
    public String getOrdinal(final int position) {
        if (position < 20) {
            return position + "te";
        }
        return position + "ste";
    }

    // TODO: Please update this when you modified lblYou in de-DE.properties
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
