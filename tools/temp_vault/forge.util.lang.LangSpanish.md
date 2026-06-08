---
aliases:
  - LangSpanish
tags:
  - java/class
  - module/forge-core
  - pkg/forge/util/lang
fqn: forge.util.lang.LangSpanish
package: forge.util.lang
module: forge-core
kind: Class
---

# LangSpanish

**Package:** `forge.util.lang` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class LangSpanish {
        +getOrdinal(int position) String
        +getPossesive(String name) String
        +getPossessedObject(String owner, String object) String
    }
    LangSpanish --|> Lang : extends
```

## Relationships
**Extends:**
- [[forge.util.Lang|Lang]]

## Source
`forge-core/src/main/java/forge/util/lang/LangSpanish.java`

```java
package forge.util.lang;

import forge.util.Lang;

public class LangSpanish extends Lang {
    
    @Override
    public String getOrdinal(final int position) {
        return position + "º";
    }

    @Override
    public String getPossesive(final String name) {
        if ("Tu".equalsIgnoreCase(name)) {
            return name;
        }
        return "de " + name;
    }

    @Override
    public String getPossessedObject(final String owner, final String object) {
        if ("Tu".equalsIgnoreCase(owner)) {
            return getPossesive(owner) + " " + object;
        }
        return object + " " + getPossesive(owner);
    }

}
```
