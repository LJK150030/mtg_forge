---
aliases:
  - ChaosBoosterSupplier
tags:
  - java/class
  - module/forge-core
  - pkg/forge/item/generation
fqn: forge.item.generation.ChaosBoosterSupplier
package: forge.item.generation
module: forge-core
kind: Class
---

# ChaosBoosterSupplier

**Package:** `forge.item.generation` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Class

```mermaid
classDiagram
    class ChaosBoosterSupplier {
        -BagRandomizer~CardEdition~ randomizer
        +get() List~PaperCard~
        +ChaosBoosterSupplier(Iterable~CardEdition~ sets)
    }
    ChaosBoosterSupplier ..|> IUnOpenedProduct : implements
    ChaosBoosterSupplier ..> BagRandomizer : uses
    ChaosBoosterSupplier ..> BoosterPack : uses
    ChaosBoosterSupplier ..> CardEdition : uses
    ChaosBoosterSupplier ..> PaperCard : uses
```

## Relationships
**Implements:**
- [[forge.item.generation.IUnOpenedProduct|IUnOpenedProduct]]
**Uses:**
- [[forge.card.CardEdition|CardEdition]]
- [[forge.item.BoosterPack|BoosterPack]]
- [[forge.item.PaperCard|PaperCard]]
- [[forge.util.BagRandomizer|BagRandomizer]]

## Source
`forge-core/src/main/java/forge/item/generation/ChaosBoosterSupplier.java`

```java
package forge.item.generation;

import forge.card.CardEdition;
import forge.item.BoosterPack;
import forge.item.PaperCard;
import forge.util.BagRandomizer;

import java.util.List;

public class ChaosBoosterSupplier implements IUnOpenedProduct {
    private BagRandomizer<CardEdition> randomizer;

    public ChaosBoosterSupplier(Iterable<CardEdition> sets) throws IllegalArgumentException {
        randomizer = new BagRandomizer<>(sets);
    }

    @Override
    public List<PaperCard> get() {
        final CardEdition set = randomizer.getNextItem();
        final BoosterPack pack = new BoosterPack(set.getCode(), set.getBoosterTemplate());
        return pack.getCards();
    }
}
```
