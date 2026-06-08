---
aliases:
  - LangChinese
tags:
  - java/class
  - module/forge-core
  - pkg/forge/util/lang
fqn: forge.util.lang.LangChinese
package: forge.util.lang
module: forge-core
kind: Class
---

# LangChinese

**Package:** `forge.util.lang` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class LangChinese {
        +getOrdinal(int position) String
        +getPossesive(String name) String
        +getPossessedObject(String owner, String object) String
        +getNickName(String name) String
        +getFontFile() String
        +canDisplayCheck() char
    }
    LangChinese --|> Lang : extends
```

## Relationships
**Extends:**
- [[forge.util.Lang|Lang]]

## Source
`forge-core/src/main/java/forge/util/lang/LangChinese.java`

```java
package forge.util.lang;

import forge.util.Lang;

public class LangChinese extends Lang {
    
    @Override
    public String getOrdinal(final int position) {
        return "第" + position;
    }

    @Override
    public String getPossesive(final String name) {
        return name + "的";
    }

    @Override
    public String getPossessedObject(final String owner, final String object) {
        return getPossesive(owner) + object;
    }

    @Override
    public String getNickName(final String name) {
        return name;
    }

    @Override
    public String getFontFile() {
        return "SourceHanSansCN";
    }
    public char canDisplayCheck() {
        return '鹫';
    }
}
```
