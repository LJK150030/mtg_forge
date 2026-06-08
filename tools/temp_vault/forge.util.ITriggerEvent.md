---
aliases:
  - ITriggerEvent
tags:
  - java/interface
  - module/forge-core
  - pkg/forge/util
fqn: forge.util.ITriggerEvent
package: forge.util
module: forge-core
kind: Interface
---

# ITriggerEvent

**Package:** `forge.util` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Interface

```mermaid
classDiagram
    class ITriggerEvent {
        <<interface>>
        ~getButton() int
        ~getX() int
        ~getY() int
    }
```

## Source
`forge-core/src/main/java/forge/util/ITriggerEvent.java`

```java
package forge.util;

public interface ITriggerEvent {
    int getButton();
    int getX();
    int getY();
}
```
