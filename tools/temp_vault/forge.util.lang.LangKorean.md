---
aliases:
  - LangKorean
tags:
  - java/class
  - module/forge-core
  - pkg/forge/util/lang
fqn: forge.util.lang.LangKorean
package: forge.util.lang
module: forge-core
kind: Class
---

# LangKorean

**Package:** `forge.util.lang` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class LangKorean {
        +getOrdinal(int position) String
        +getPossesive(String name) String
        +getPossessedObject(String owner, String object) String
        +getNickName(String name) String
        +getFontFile() String
        +canDisplayCheck() char
    }
    LangKorean --|> Lang : extends
```

## Relationships
**Extends:**
- [[forge.util.Lang|Lang]]

## Source
`forge-core/src/main/java/forge/util/lang/LangKorean.java`

```java
package forge.util.lang;

import forge.util.Lang;

public class LangKorean extends Lang {

    @Override
    public String getOrdinal(final int position) {
        return position + "번째";
    }

    @Override
    public String getPossesive(final String name) {
        if ("당신".equals(name) || "You".equalsIgnoreCase(name)) {
            return "당신의";
        }
        return name + "의";
    }

    @Override
    public String getPossessedObject(final String owner, final String object) {
        return getPossesive(owner) + " " + object;
    }

    @Override
    public String getNickName(final String name) {
        String [] splitName = name.split(",");
        if (splitName.length > 1) return splitName[0].trim();
        return name;
    }

    @Override
    public String getFontFile() {
        return "SourceHanSansKR";
    }
    public char canDisplayCheck() {
        return '째';
    }
}
```
