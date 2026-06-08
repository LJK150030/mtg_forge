package uml;

import com.github.javaparser.ParseResult;
import com.github.javaparser.ParserConfiguration;
import com.github.javaparser.ast.CompilationUnit;
import com.github.javaparser.ast.Modifier;
import com.github.javaparser.ast.NodeList;
import com.github.javaparser.ast.body.*;
import com.github.javaparser.ast.type.ClassOrInterfaceType;
import com.github.javaparser.ast.type.Type;
import com.github.javaparser.resolution.types.ResolvedType;
import com.github.javaparser.symbolsolver.JavaSymbolSolver;
import com.github.javaparser.symbolsolver.resolution.typesolvers.CombinedTypeSolver;
import com.github.javaparser.symbolsolver.resolution.typesolvers.JarTypeSolver;
import com.github.javaparser.symbolsolver.resolution.typesolvers.JavaParserTypeSolver;
import com.github.javaparser.symbolsolver.resolution.typesolvers.ReflectionTypeSolver;
import com.github.javaparser.utils.SourceRoot;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Walk one or more Java source roots, resolve type references with JavaParser's
 * symbol solver, and emit one Obsidian-friendly Markdown note per type, each with
 * a Mermaid {@code classDiagram}.
 *
 * <p>Every source root passed on the command line is BOTH parsed (its types get
 * notes) AND added to the shared symbol solver, so cross-module references
 * (e.g. {@code forge-ai} -> {@code forge-game} -> {@code forge-core}) resolve to
 * the correct fully-qualified name. The result is a single, unified knowledge
 * graph spanning all the roots.
 *
 * <p>Notes are keyed by fully-qualified name (FQN), not simple name. This is the
 * key correctness fix over a naive exporter: Forge has many types that share a
 * simple name across packages, plus nested types like {@code Card.StatBreakdown}.
 * Naming files / wiki-links by simple name silently overwrites them and corrupts
 * the graph. Files are {@code <fqn>.md}; wiki-links are {@code [[fqn|SimpleName]]}
 * so Obsidian's graph connects unambiguous nodes while still reading nicely.
 *
 * <pre>
 *   Usage: JavaToUml &lt;outDir&gt; &lt;srcRoot1&gt; [srcRoot2 ...] [--jar path.jar ...]
 * </pre>
 *
 * {@code --jar} entries are added to the solver only (for external libraries such
 * as Guava). They are optional: only project types ever become graph edges, so
 * unresolved external types degrade gracefully (the edge is simply skipped).
 */
public final class JavaToUml {

    /** Everything extracted about a single type declaration. */
    static final class TypeInfo {
        String name;        // simple name, e.g. "Card" or "StatBreakdown"
        String fqn;         // fully-qualified, e.g. "forge.game.card.Card"
        String pkg;         // package, e.g. "forge.game.card"
        String module;      // owning source-root label, e.g. "forge-game"
        String kind;        // Class / Interface / Enum / Record / Annotation
        final List<String> enumConstants = new ArrayList<>(); // enum entry names
        final List<String[]> fields  = new ArrayList<>(); // {vis, type, name}
        final List<String[]> methods = new ArrayList<>(); // {vis, returnType, name, params}
        final List<String> extSimple  = new ArrayList<>(); // supertypes, simple names (diagram)
        final List<String> implSimple = new ArrayList<>(); // interfaces, simple names (diagram)
        final Set<String> usesSimple   = new TreeSet<>();  // referenced project types, simple (diagram)
        // FQN -> relation ("extends" / "implements" / "uses"); drives wiki-links + graph.
        final Map<String, String> relatedFqn = new TreeMap<>();
    }

    public static void main(String[] args) throws Exception {
        // The output dir may be supplied as a system property (-Duml.out=...).
        // Prefer this for paths with spaces (e.g. Windows Obsidian vaults): a
        // -D value is a single shell-quoted token, whereas -Dexec.args is
        // re-split on whitespace by the exec plugin and would fragment the path.
        String outProp = System.getProperty("uml.out");
        boolean outFromProp = outProp != null && !outProp.isBlank();

        int firstArg = outFromProp ? 0 : 1; // when out is positional it's args[0]
        if (!outFromProp && args.length < 2 || outFromProp && args.length < 1) {
            System.err.println("Usage:");
            System.err.println("  JavaToUml <outDir> <srcRoot1> [srcRoot2 ...] [--jar path.jar ...]");
            System.err.println("  -Duml.out=<outDir> ... <srcRoot1> [srcRoot2 ...]   (spaces-safe)");
            System.exit(1);
        }

        Path outDir = outFromProp ? Paths.get(outProp) : Paths.get(args[0]);
        List<Path> srcRoots = new ArrayList<>();
        List<Path> jars = new ArrayList<>();
        for (int i = firstArg; i < args.length; i++) {
            if ("--jar".equals(args[i]) && i + 1 < args.length) {
                jars.add(Paths.get(args[++i]));
            } else {
                srcRoots.add(Paths.get(args[i]));
            }
        }
        if (srcRoots.isEmpty()) {
            System.err.println("Error: at least one source root is required.");
            System.exit(1);
        }
        Files.createDirectories(outDir);

        // --- configure the symbol solver: JDK + every source root + optional jars ---
        CombinedTypeSolver typeSolver = new CombinedTypeSolver();
        typeSolver.add(new ReflectionTypeSolver());
        for (Path root : srcRoots) {
            typeSolver.add(new JavaParserTypeSolver(root.toFile()));
        }
        for (Path jar : jars) {
            if (jar.toString().endsWith(".jar") && Files.exists(jar)) {
                typeSolver.add(new JarTypeSolver(jar));
            }
        }
        ParserConfiguration config = new ParserConfiguration()
                .setLanguageLevel(ParserConfiguration.LanguageLevel.JAVA_17) // matches Forge's release
                .setSymbolResolver(new JavaSymbolSolver(typeSolver));

        // --- parse every root, remembering which module each unit came from ----
        // Map of CompilationUnit -> module label, so notes can record their module.
        Map<CompilationUnit, String> unitModule = new IdentityHashMap<>();
        List<CompilationUnit> units = new ArrayList<>();
        int failed = 0;
        for (Path root : srcRoots) {
            String module = moduleLabel(root);
            SourceRoot sourceRoot = new SourceRoot(root, config);
            for (ParseResult<CompilationUnit> r : sourceRoot.tryToParse()) {
                if (r.isSuccessful() && r.getResult().isPresent()) {
                    CompilationUnit cu = r.getResult().get();
                    unitModule.put(cu, module);
                    units.add(cu);
                } else {
                    failed++;
                    if (failed <= 10) { // sample of why files were skipped
                        System.err.println("  parse failed: " + r.getProblems().stream()
                                .findFirst().map(Object::toString).orElse("unknown"));
                    }
                }
            }
            System.out.println("Parsed root " + root + "  (module=" + module + ")");
        }
        System.out.println("Total compilation units: " + units.size()
                + (failed > 0 ? "  (parse failures: " + failed + ")" : ""));

        // --- pass 1: every project type's FQN (top-level AND nested) ----------
        Set<String> projectFqns = new HashSet<>();
        for (CompilationUnit cu : units) {
            for (TypeDeclaration<?> td : cu.findAll(TypeDeclaration.class)) {
                td.getFullyQualifiedName().ifPresent(projectFqns::add);
            }
        }
        System.out.println("Project types discovered: " + projectFqns.size());

        // --- pass 2: extract + resolve every type -----------------------------
        List<TypeInfo> all = new ArrayList<>();
        for (CompilationUnit cu : units) {
            String module = unitModule.get(cu);
            String pkg = cu.getPackageDeclaration().map(p -> p.getNameAsString()).orElse("");
            for (TypeDeclaration<?> td : cu.findAll(TypeDeclaration.class)) {
                Optional<String> fqn = td.getFullyQualifiedName();
                if (fqn.isEmpty()) continue; // skip local/anonymous (no stable graph node)
                all.add(extract(td, fqn.get(), pkg, module, projectFqns));
            }
        }

        // --- write one note per type ------------------------------------------
        int written = 0;
        for (TypeInfo info : all) {
            Files.writeString(outDir.resolve(info.fqn + ".md"), toMarkdown(info));
            written++;
        }
        System.out.println("Wrote " + written + " markdown notes to " + outDir);
    }

    /** Derive a readable module label from a source root like ".../forge-game/src/main/java". */
    static String moduleLabel(Path root) {
        Path p = root.toAbsolutePath().normalize();
        for (Path part = p; part != null; part = part.getParent()) {
            Path parent = part.getParent();
            if (parent != null && "src".equals(part.getFileName().toString())
                    && parent.getFileName() != null) {
                return parent.getFileName().toString();
            }
        }
        return p.getFileName() == null ? "unknown" : p.getFileName().toString();
    }

    // ----------------------------------------------------------------------
    static TypeInfo extract(TypeDeclaration<?> td, String fqn, String pkg,
                            String module, Set<String> projectFqns) {
        TypeInfo info = new TypeInfo();
        info.name = td.getNameAsString();
        info.fqn = fqn;
        info.pkg = pkg;
        info.module = module;

        // Classic instanceof + cast (no pattern variables) so the tool compiles
        // at a low release level on whatever JDK the user has. JavaParser parses
        // Forge's Java 17 source as text regardless of this tool's own level.
        if (td instanceof ClassOrInterfaceDeclaration) {
            ClassOrInterfaceDeclaration cid = (ClassOrInterfaceDeclaration) td;
            info.kind = cid.isInterface() ? "Interface" : "Class";
            cid.getExtendedTypes().forEach(t -> {
                info.extSimple.add(t.getNameAsString());
                addRelated(info, t, projectFqns, "extends");
            });
            cid.getImplementedTypes().forEach(t -> {
                info.implSimple.add(t.getNameAsString());
                addRelated(info, t, projectFqns, "implements");
            });
        } else if (td instanceof EnumDeclaration) {
            EnumDeclaration ed = (EnumDeclaration) td;
            info.kind = "Enum";
            ed.getEntries().forEach(e -> info.enumConstants.add(e.getNameAsString()));
            ed.getImplementedTypes().forEach(t -> {
                info.implSimple.add(t.getNameAsString());
                addRelated(info, t, projectFqns, "implements");
            });
        } else if (td instanceof RecordDeclaration) {
            RecordDeclaration rd = (RecordDeclaration) td;
            info.kind = "Record";
            rd.getImplementedTypes().forEach(t -> {
                info.implSimple.add(t.getNameAsString());
                addRelated(info, t, projectFqns, "implements");
            });
        } else if (td instanceof AnnotationDeclaration) {
            info.kind = "Annotation";
        } else {
            info.kind = "Type";
        }

        for (FieldDeclaration fd : td.getFields()) {
            String vis = visibility(fd.getModifiers());
            for (VariableDeclarator v : fd.getVariables()) {
                info.fields.add(new String[]{vis, mermaidType(v.getType()), v.getNameAsString()});
            }
        }
        for (MethodDeclaration md : td.getMethods()) {
            info.methods.add(new String[]{visibility(md.getModifiers()),
                    mermaidType(md.getType()), md.getNameAsString(), params(md.getParameters())});
        }
        for (ConstructorDeclaration cd : td.getConstructors()) {
            info.methods.add(new String[]{visibility(cd.getModifiers()), "",
                    cd.getNameAsString(), params(cd.getParameters())});
        }

        // "uses" edges: every resolvable class/interface type reference in the
        // declaration (incl. generic arguments, which are separate AST nodes)
        // whose FQN is a project type.
        for (ClassOrInterfaceType cit : td.findAll(ClassOrInterfaceType.class)) {
            String depFqn = resolveProjectFqn(cit, projectFqns);
            if (depFqn != null && !depFqn.equals(info.fqn)) {
                String simple = simpleName(depFqn);
                if (!simple.equals(info.name)) info.usesSimple.add(simple);
                info.relatedFqn.putIfAbsent(depFqn, "uses"); // never downgrade extends/implements
            }
        }
        return info;
    }

    /** Resolve a type to its FQN if (and only if) it is one of the project's types. */
    static String resolveProjectFqn(ClassOrInterfaceType cit, Set<String> projectFqns) {
        try {
            ResolvedType rt = cit.resolve();
            if (rt.isReferenceType()) {
                String fqn = rt.asReferenceType().getQualifiedName();
                if (projectFqns.contains(fqn)) return fqn;
            }
        } catch (Exception | StackOverflowError ignored) {
            // external/unresolved type -> no edge
        }
        return null;
    }

    static void addRelated(TypeInfo info, ClassOrInterfaceType t,
                           Set<String> projectFqns, String relation) {
        String fqn = resolveProjectFqn(t, projectFqns);
        if (fqn != null && !fqn.equals(info.fqn)) {
            info.relatedFqn.put(fqn, relation); // overrides a prior "uses"
        }
    }

    static String params(NodeList<Parameter> ps) {
        return ps.stream()
                .map(p -> mermaidType(p.getType()) + " " + p.getNameAsString())
                .collect(Collectors.joining(", "));
    }

    static String visibility(NodeList<Modifier> mods) {
        for (Modifier m : mods) {
            switch (m.getKeyword()) {
                case PRIVATE:   return "-";
                case PROTECTED: return "#";
                case PUBLIC:    return "+";
                default:        break;
            }
        }
        return "~"; // package-private
    }

    static String simpleName(String fqn) {
        int dot = fqn.lastIndexOf('.');
        return dot < 0 ? fqn : fqn.substring(dot + 1);
    }

    /**
     * Render a Java type for a Mermaid member line. Mermaid's classDiagram uses
     * {@code ~T~} for generics and chokes on nested {@code <>} and wildcards, so
     * we flatten to one generic level and drop wildcard noise. Full fidelity is
     * preserved in the type name itself; only the angle-bracket nesting is lost.
     */
    static String mermaidType(Type t) {
        String s = t.asString();
        int lt = s.indexOf('<');
        if (lt < 0) return cleanType(s);
        int gt = s.lastIndexOf('>');
        if (gt < lt) return cleanType(s);
        String base = s.substring(0, lt);
        String inner = s.substring(lt + 1, gt)
                .replaceAll("<[^<>]*>", "")  // strip one nested level
                .replaceAll("<.*?>", "")      // strip any remaining nesting
                .replace("<", "").replace(">", "");
        String tail = s.substring(gt + 1);    // e.g. "[]" on a generic array
        return cleanType(base) + "~" + cleanType(inner.trim()) + "~" + cleanType(tail);
    }

    /** Remove tokens that break Mermaid member parsing. */
    static String cleanType(String s) {
        return s.replace("? extends ", "")
                .replace("? super ", "")
                .replace("?", "Object")
                .replace("[]", "[]")   // arrays render fine; kept explicit for clarity
                .trim();
    }

    // ----------------------------------------------------------------------
    static String toMarkdown(TypeInfo info) {
        StringBuilder sb = new StringBuilder();

        // YAML frontmatter: aliases let you type [[Card]]; tags drive Obsidian filters.
        sb.append("---\n");
        sb.append("aliases:\n  - ").append(info.name).append("\n");
        sb.append("tags:\n");
        sb.append("  - java/").append(info.kind.toLowerCase()).append("\n");
        if (!info.module.isEmpty()) sb.append("  - module/").append(info.module).append("\n");
        if (!info.pkg.isEmpty())    sb.append("  - pkg/").append(info.pkg.replace('.', '/')).append("\n");
        sb.append("fqn: ").append(info.fqn).append("\n");
        sb.append("package: ").append(info.pkg).append("\n");
        sb.append("module: ").append(info.module).append("\n");
        sb.append("kind: ").append(info.kind).append("\n");
        sb.append("---\n\n");

        sb.append("# ").append(info.name).append("\n\n");
        sb.append("**Package:** `").append(info.pkg).append("` &nbsp; ");
        sb.append("**Module:** `").append(info.module).append("` &nbsp; ");
        sb.append("**Kind:** ").append(info.kind).append("\n\n");

        // --- Mermaid class diagram (per-note local visual) ---
        sb.append("```mermaid\nclassDiagram\n");
        sb.append("    class ").append(info.name).append(" {\n");
        if ("Interface".equals(info.kind))  sb.append("        <<interface>>\n");
        else if ("Enum".equals(info.kind))  sb.append("        <<enumeration>>\n");
        else if ("Record".equals(info.kind)) sb.append("        <<record>>\n");
        else if ("Annotation".equals(info.kind)) sb.append("        <<annotation>>\n");
        for (String c : info.enumConstants) {
            sb.append("        ").append(c).append("\n");
        }
        for (String[] f : info.fields) {
            sb.append("        ").append(f[0]).append(f[1]).append(" ").append(f[2]).append("\n");
        }
        for (String[] m : info.methods) {
            String ret = m[1].isEmpty() ? "" : " " + m[1];
            sb.append("        ").append(m[0]).append(m[2])
              .append("(").append(m[3]).append(")").append(ret).append("\n");
        }
        sb.append("    }\n");

        for (String p : info.extSimple)
            sb.append("    ").append(info.name).append(" --|> ").append(p).append(" : extends\n");
        for (String i : info.implSimple)
            sb.append("    ").append(info.name).append(" ..|> ").append(i).append(" : implements\n");
        Set<String> inheritance = new HashSet<>(info.extSimple);
        inheritance.addAll(info.implSimple);
        for (String dep : info.usesSimple)
            if (!inheritance.contains(dep))
                sb.append("    ").append(info.name).append(" ..> ").append(dep).append(" : uses\n");
        sb.append("```\n\n");

        // --- Obsidian wiki-links (these drive the graph view) ---
        if (!info.relatedFqn.isEmpty()) {
            sb.append("## Relationships\n");
            appendLinks(sb, info, "extends");
            appendLinks(sb, info, "implements");
            appendLinks(sb, info, "uses");
            sb.append("\n");
        }
        return sb.toString();
    }

    private static void appendLinks(StringBuilder sb, TypeInfo info, String relation) {
        List<String> targets = info.relatedFqn.entrySet().stream()
                .filter(e -> e.getValue().equals(relation))
                .map(Map.Entry::getKey)
                .collect(Collectors.toList());
        if (targets.isEmpty()) return;
        sb.append("**").append(Character.toUpperCase(relation.charAt(0)))
          .append(relation.substring(1)).append(":**\n");
        for (String fqn : targets) {
            sb.append("- [[").append(fqn).append("|").append(simpleName(fqn)).append("]]\n");
        }
    }

    private JavaToUml() {}
}
