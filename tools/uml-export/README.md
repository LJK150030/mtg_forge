# Forge → Obsidian UML exporter

Walks Java source with [JavaParser](https://github.com/javaparser/javaparser)
(using its **symbol solver**, not name matching) and emits one Obsidian
Markdown note per type, each containing a Mermaid `classDiagram` plus
`[[wiki-links]]` that drive Obsidian's graph view.

Targets the three core modules: **forge-core → forge-game → forge-ai**.

## Run

```bash
tools/uml-export/export-uml.sh            # writes to ./uml-vault
tools/uml-export/export-uml.sh ~/Vaults/Forge   # write into an Obsidian vault
```

Or directly via Maven (run from the repo root so the repo's `.mvn` settings
resolve). Pass the output dir as `-Duml.out` — it is a single token, so paths
with spaces are safe; only the source roots ride in `-Dexec.args`:

```bash
MAVEN_OPTS=-Xmx3g mvn -f tools/uml-export/pom.xml compile exec:java \
  -Duml.out="uml-vault" \
  -Dexec.args="forge-core/src/main/java forge-game/src/main/java forge-ai/src/main/java"
```

### Windows (IntelliJ terminal)

Writing straight into an Obsidian vault whose path has spaces.

PowerShell:

```powershell
$env:MAVEN_OPTS="-Xmx3g"
mvn -f tools/uml-export/pom.xml compile exec:java `
  "-Duml.out=G:\My Files\School\sprint 2026\obsidian_valuts\mtg_forge_conversion" `
  "-Dexec.args=forge-core/src/main/java forge-game/src/main/java forge-ai/src/main/java"
```

cmd.exe:

```bat
set MAVEN_OPTS=-Xmx3g
mvn -f tools/uml-export/pom.xml compile exec:java "-Duml.out=G:\My Files\School\sprint 2026\obsidian_valuts\mtg_forge_conversion" "-Dexec.args=forge-core/src/main/java forge-game/src/main/java forge-ai/src/main/java"
```

Requires a modern JDK (11+) and Maven with network access to Maven Central
(to fetch JavaParser 3.26.4). The tool targets Java 11 and pins its compiler/
exec plugin versions, so it builds and runs even on old Maven (verified on
Maven 3.3.9); the running JDK need not match Forge's Java 17, because JavaParser
parses source as text. On the current tree this produces **1,283 notes** from
1,130 source files.

## How it differs from a naive exporter

* **Symbol resolution, not name matching.** Every type reference (including
  generic arguments like the `Card` inside `ListMultimap<ZoneType, Card>`) is
  resolved to a fully-qualified name. Edges are drawn only to types that exist
  in the project, so `forge.game.card.Card` and any other `Card` stay distinct.
* **FQN-keyed notes.** Files and links use the fully-qualified name
  (`forge.game.card.Card.md`), so the ~15 simple-name collisions in these
  modules (e.g. `Reader` appears 6×) and all nested types
  (`Card.StatBreakdown`) get their own notes instead of silently overwriting.
* **Unified graph.** All three roots are parsed in one pass and added to a
  shared solver, so cross-module edges resolve and every link target exists
  (no dangling links).
* **Java 17 language level**, matching Forge's `maven.compiler.release`. Without
  this the parser silently drops ~123 files that use modern syntax.
* **Mermaid-safe rendering.** Generics become `~T~`; nested generics are
  flattened one level and wildcards stripped so diagrams always parse.

## Note anatomy

* YAML frontmatter: `aliases` (simple name, so `[[Card]]` still works), plus
  `tags` for `kind`, `module`, and `package` (filterable in Obsidian).
* A Mermaid `classDiagram` — the per-note visual. Supertypes/JDK types appear
  here for readability even when they aren't project nodes.
* A **Relationships** section of `[[fqn|SimpleName]]` links grouped into
  Extends / Implements / Uses — *this* is what builds the Obsidian graph.
* A **Source** section embedding the raw Java in a ` ```java ` block, as an
  example implementation. Top-level types embed the whole file (package +
  imports + body); nested types (e.g. `Card.StatBreakdown`) embed only their
  own declaration excerpt, so a note never drags in its 8,000-line parent file.
  Disable with `-Duml.source=false`.

## Optional: external (Guava/etc.) edges

Only project types become graph edges, so external libraries are not required.
If you want them resolved too, pass jars after the roots:

```
-Dexec.args="uml-vault <roots...> --jar ~/.m2/.../guava-33.0.0-jre.jar"
```
