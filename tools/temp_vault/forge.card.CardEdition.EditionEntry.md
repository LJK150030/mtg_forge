---
aliases:
  - EditionEntry
tags:
  - java/record
  - module/forge-core
  - pkg/forge/card
fqn: forge.card.CardEdition.EditionEntry
package: forge.card
module: forge-core
kind: Record
---

# EditionEntry

**Package:** `forge.card` &nbsp; **Module:** `forge-core` &nbsp; **Kind:** Record

```mermaid
classDiagram
    class EditionEntry {
        <<record>>
        +toString() String
        +compareTo(EditionEntry o) int
        +getFlavorName() String
        +getFunctionalVariantName() String
    }
    EditionEntry ..|> Comparable : implements
    EditionEntry ..> CardRarity : uses
```

## Relationships
**Uses:**
- [[forge.card.CardRarity|CardRarity]]

## Design Description

EditionEntry is an immutable record nested within `CardEdition` that captures a single card's printing details within a set: its name, collector number, rarity, artist, and an open-ended map of extra parameters. It implements `Comparable` to define a canonical sort order—first by name (case-insensitive), then by a normalized collector number, then by rarity—so entries can be ordered consistently in collections and listings.

Beyond storage, it provides presentation and accessor logic: `toString()` renders a compact human-readable form that conditionally includes collector number, meaningful rarity (suppressing `CardRarity.Unknown`/`Token`), artist, and serialized extra parameters. The `getFlavorName()` and `getFunctionalVariantName()` helpers expose specific well-known keys ("flavorname", "variant") from the extraParams map, keeping that loosely-typed bag's conventions encapsulated. Its sole domain collaborator is `CardRarity`.

## Source
`forge-core/src/main/java/forge/card/CardEdition.java` â€” declaration excerpt

```java
    public record EditionEntry(String name, String collectorNumber, CardRarity rarity, String artistName, Map<String, String> extraParams) implements Comparable<EditionEntry> {

        public String toString() {
            StringBuilder sb = new StringBuilder();
            if (collectorNumber != null) {
                sb.append(collectorNumber);
                sb.append(' ');
            }
            if (rarity != CardRarity.Unknown && rarity != CardRarity.Token) {
                sb.append(rarity);
                sb.append(' ');
            }
            sb.append(name);
            if (artistName != null) {
                sb.append(" @");
                sb.append(artistName);
            }
            if (extraParams != null) {
                sb.append(" $");
                sb.append(extraParams.entrySet().stream().map(e -> String.format("\"%s\"=\"%s\"", e.getKey(), e.getValue())).collect(Collectors.joining(", ")));
            }
            return sb.toString();
        }

        @Override
        public int compareTo(EditionEntry o) {
            final int nameCmp = name.compareToIgnoreCase(o.name);
            if (0 != nameCmp) {
                return nameCmp;
            }
            String thisCollNr = getSortableCollectorNumber(collectorNumber);
            String othrCollNr = getSortableCollectorNumber(o.collectorNumber);
            final int collNrCmp = thisCollNr.compareTo(othrCollNr);
            if (0 != collNrCmp) {
                return collNrCmp;
            }
            return rarity.compareTo(o.rarity);
        }

        public String getFlavorName() {
            if (extraParams == null)
                return null;
            return extraParams.get("flavorname");
        }

        public String getFunctionalVariantName() {
            if (extraParams == null)
                return null;
            return extraParams.get("variant");
        }
    }
```
