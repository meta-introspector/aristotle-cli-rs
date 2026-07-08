# Declaration Alchemy — Architecture Plan

## The Vision

Take all declarations from a Lean project, load them into memory as structured
data, fuse them with dependency information and source text, and extract a new
compilable version with exact dependency metadata.

This is "alchemy" — transforming raw declaration data into new code.

---

## The Three Ingredients

### 1. Introspector JSON (The Soul)

**Source**: Lean4Introspector at `/mnt/data1/nix/time/2025/05/10/Lean4Introspector/`

The introspector serializes every Lean internal type to JSON:
- `Lean.Expr` — full recursive serialization (bvar, fvar, mvar, sort, const, app, lam, forallE, letE, lit, mdata, proj)
- `Lean.ConstantInfo` — all constant kinds (axiomInfo, defnInfo, thmInfo, opaqueInfo, quotInfo, inductInfo, ctorInfo, recInfo)
- `Lean.RecursorVal` — recursor rules, numParams, numIndices, numMotives, numMinors
- `Lean.Position` — `{"line": ..., "column": ...}`
- `Lean.BinderInfo`, `Lean.Literal`, `Lean.OpenDecl`, `Lean.Elab.Command.Scope`

The `data/` and `data2/` directories contain hundreds of JSON files, each with
a content-addressed hash filename. Each file is a complete serialization of one
declaration's internal representation.

**What this gives us**: The complete internal structure of every declaration —
its type, value, kind, level parameters, constructor fields, recursor rules.
This is the "soul" — what each declaration IS inside the kernel.

### 2. Kernel Dependency Graph (The Skeleton)

**Source**: Our SplitDecls.lean at `~/projects/arist/splitter-engine/RequestProject/SplitDecls.lean`

The kernel API gives us exact dependency tracking:
- `Expr.foldConsts` — walks the AST collecting all constant references
- `constDeps` — gets dependencies from both type AND value of a constant
- `bfsClosure` — BFS from root declarations to find transitive closure
- `topoSort` — iterative DFS post-order, O(V+E), handles cycles
- `filterDeps` — restricts to project closure (not all 471K declarations)
- `classifyDeps` — splits into "split-imports" (in our closure) vs "builtin-imports"

**What this gives us**: The exact dependency graph — which declarations depend
on which. This is the "skeleton" — how everything connects. No guessing, no
regex, no approximation. The kernel knows the truth.

### 3. Original Source Files (The Body)

**Source**: The original `.lean` files in the project tree

The author-written source code that the compiler parsed:
- `namespace IPLDMonsterSchema` ... `end IPLDMonsterSchema`
- Short names (`TypeKind` not `IPLDMonsterSchema.TypeKind`)
- Proper universe binders, valid pattern variables, real proof terms
- Everything that makes code COMPILE

**What this gives us**: Compilable text. This is the "body" — what actually
works when you feed it to `lake build`. The source was always compilable; we
just need to find the right lines.

---

## The Fusion Process

```
                    ┌─────────────────────────────────┐
                    │  PHASE 1: LOAD                  │
                    │                                 │
                    │  Introspector JSON ──→ Memory   │
                    │  (every decl as structured obj)  │
                    │                                 │
                    │  Kernel Environment ──→ Memory  │
                    │  (exact dep graph)              │
                    │                                 │
                    │  Source Files ──→ Memory        │
                    │  (raw text, line-indexed)       │
                    └────────────┬────────────────────┘
                                 │
                    ┌────────────▼────────────────────┐
                    │  PHASE 2: CROSS-REFERENCE       │
                    │                                 │
                    │  For each declaration:          │
                    │  • Introspector JSON →          │
                    │    kind, type, levels, value    │
                    │  • Kernel env →                │
                    │    dependencies (exact)         │
                    │  • declRangeExt →              │
                    │    source file + line range     │
                    │  • Source file →               │
                    │    raw compilable text          │
                    └────────────┬────────────────────┘
                                 │
                    ┌────────────▼────────────────────┐
                    │  PHASE 3: FUSE                  │
                    │                                 │
                    │  For each declaration:          │
                    │  1. Get source text (body)      │
                    │  2. Get dependencies (skeleton) │
                    │  3. Get metadata (soul)         │
                    │  4. Compute namespace from name │
                    │  5. Classify deps:              │
                    │     - split-imports (in closure) │
                    │     - builtin-imports (Init.*)   │
                    │  6. Wrap in namespace           │
                    │  7. Prepend split imports       │
                    └────────────┬────────────────────┘
                                 │
                    ┌────────────▼────────────────────┐
                    │  PHASE 4: EXTRACT                │
                    │                                 │
                    │  Output per declaration:        │
                    │  • <name>.lean (compilable)     │
                    │  • dag.json (dep graph)         │
                    │  • sourceMap.json (line ranges) │
                    │  • declMeta.json (kind, levels)  │
                    │  • lakefile.toml (project)      │
                    │                                 │
                    │  The new version:               │
                    │  • Every file compiles          │
                    │  • Every dep is exact           │
                    │  • Every decl has metadata     │
                    │  • Self-contained project       │
                    └─────────────────────────────────┘
```

---

## Detailed Data Flow

### Input Files

```
Lean4Introspector/
├── data/
│   ├── TypeKind_<hash>.json          # Expr tree for TypeKind's type
│   ├── TypeKind.rec_<hash>.json      # Recursor for TypeKind
│   ├── instDecidableEqTypeKind_<hash>.json
│   └── ... (hundreds more)
├── data2/
│   └── ... (same, different run)
└── src/
    ├── LeanIntrospector.lean          # The introspector source
    └── LeanEnvironmentShim.lean      # Stubs for private types

splitter-engine/
└── RequestProject/
    └── SplitDecls.lean                # Our kernel API splitter

dasl-verification/
└── RequestProject/
    ├── IPLDMonsterSchema.lean        # Original source (245 lines)
    └── ... (174 more .lean files)
```

### In-Memory Representation

For each declaration, we build a fused record:

```json
{
  "name": "IPLDMonsterSchema.instDecidableEqTypeKind",
  "shortName": "instDecidableEqTypeKind",
  "namespace": "IPLDMonsterSchema",
  "kind": "instance",                    // from introspector
  "levelParams": ["u_1"],               // from introspector
  "type": { ... },                       // Expr JSON from introspector
  "dependencies": [                      // from kernel (exact)
    "IPLDMonsterSchema.TypeKind",
    "DecidableEq",
    "Nat",
    "Bool"
  ],
  "splitImports": [                      // deps in our closure
    "IPLDMonsterSchema.TypeKind"
  ],
  "builtinImports": [                    // deps from Init/Std
    "DecidableEq",
    "Nat",
    "Bool"
  ],
  "sourceFile": "RequestProject/IPLDMonsterSchema.lean",
  "sourceStartLine": 52,                // from declRangeExt
  "sourceEndLine": 58,                  // from declRangeExt
  "sourceText": "instance : DecidableEq TypeKind where\n  ..."  // raw source
}
```

### Output Files

```
output/
├── lakefile.toml                        # Self-contained project
├── dag.json                             # Exact dependency graph
├── sourceMap.json                       # Decl → source file + lines
├── declMeta.json                        # Decl → kind, levels, type JSON
└── Split/
    ├── IPLDMonsterSchema_TypeKind.lean
    ├── IPLDMonsterSchema_instDecidableEqTypeKind.lean
    ├── IPLDMonsterSchema_type_kind_count.lean
    └── ... (one per declaration)
```

Each `.lean` file looks like:

```lean
-- Split/IPLDMonsterSchema_instDecidableEqTypeKind.lean
import Split.IPLDMonsterSchema_TypeKind
import Init

namespace IPLDMonsterSchema

instance : DecidableEq TypeKind where
  | .Bool, .Bool => .isTrue rfl
  | .String, .String => .isTrue rfl
  ...

end IPLDMonsterSchema
```

This compiles because:
- The source text is the author's original code (not pretty-printed)
- The namespace resolves short names (`TypeKind` → `IPLDMonsterSchema.TypeKind`)
- The split imports bring in dependencies that are in our closure
- `import Init` brings in builtins (`DecidableEq`, `Nat`, `Bool`)

---

## Implementation Steps

### Step 1: Extend SplitDecls.lean with Source Extraction

Add to `SplitDecls.lean`:

```lean
import Lean.DeclarationRange  -- gives us declRangeExt
```

**`findSourceFile`**: Convert module name to file path
- `RequestProject.IPLDMonsterSchema` → `RequestProject/IPLDMonsterSchema.lean`
- Search in: cwd, `.lake/packages/*/`, search path entries

**`extractSourceText`**: Get raw source for a declaration
- Call `declRangeExt.find? (level := .exported) env declName`
- Get `DeclarationRanges.range` → `DeclarationRange` with `pos` and `endPos`
- Read source file, extract lines from `pos.line` to `endPos.line` (1-indexed)
- Return raw source text

**`getNamespace`**: Extract namespace from declaration name
- `IPLDMonsterSchema.TypeKind` → namespace `IPLDMonsterSchema`, short name `TypeKind`
- `TypeKind` (no dot) → no namespace, short name `TypeKind`

### Step 2: Modify `emitDeclFile` to Use Source Extraction

Replace pretty-printing with source extraction:

```lean
def emitDeclFile (env : Environment) (closure : NameSet) (outDir : String)
    (declName : Name) (deps : List Name) : IO Unit := do
  -- 1. Try source extraction
  match ← extractSourceText env declName with
  | some sourceText =>
    -- Success: use raw source
    let (ns, shortName) := getNamespace declName
    let (splitImports, builtinImports) := classifyDeps deps closure
    let header := buildImportHeader splitImports builtinImports
    let body := wrapInNamespace ns sourceText
    writeDeclFile outDir declName (header ++ body)
  | none =>
    -- Fallback: pretty-print (won't compile for defs/theorems, but has metadata)
    let expr := ppExpr env declName
    writeDeclFile outDir declName expr
```

### Step 3: Add Metadata Output

**`sourceMap.json`**: Maps each declaration to its source location
```json
{
  "IPLDMonsterSchema.TypeKind": {
    "file": "RequestProject/IPLDMonsterSchema.lean",
    "startLine": 46,
    "endLine": 51
  },
  "IPLDMonsterSchema.instDecidableEqTypeKind": {
    "file": "RequestProject/IPLDMonsterSchema.lean",
    "startLine": 52,
    "endLine": 58
  }
}
```

**`declMeta.json`**: Maps each declaration to its introspector metadata
```json
{
  "IPLDMonsterSchema.TypeKind": {
    "kind": "inductInfo",
    "levelParams": ["u_1"],
    "numParams": 0,
    "numIndices": 0,
    "ctors": ["TypeKind.Bool", "TypeKind.String", ...],
    "isUnsafe": false
  },
  "IPLDMonsterSchema.instDecidableEqTypeKind": {
    "kind": "defnInfo",
    "levelParams": [],
    "type": { ... Expr JSON ... }
  }
}
```

### Step 4: Integrate Introspector Data

Load the introspector's JSON files and cross-reference with our kernel data:

1. Parse all JSON files from `data/` (or `data2/`)
2. Index by declaration name (extract from `name` field in JSON)
3. For each declaration in our kernel closure, look up its introspector JSON
4. Merge the metadata into `declMeta.json`

This gives us the "soul" — the full internal representation — alongside the
compilable source text and exact dependency graph.

---

## Why This Works (And The Old Approach Didn't)

### Old approach: Pretty-print from kernel
```
Kernel Expr → ppExpr → "x._@.RequestProject..._hygCtx._hyg.1"
→ NOT compilable (hygienic names, universe vars, proof refs)
→ 8/180 compile (inductives only)
```

### New approach: Extract from source
```
Kernel Environment → declRangeExt → line 52-58
→ Read source file lines 52-58
→ "instance : DecidableEq TypeKind where ..."
→ COMPILES (it's the author's original code)
→ 180/180 should compile
```

The source was always compilable. The kernel just doesn't store it in a form
that survives pretty-printing. By going back to the source file, we get
compilable code. By using the kernel for dependency tracking, we get exact
deps. By using the introspector for metadata, we get the full internal
representation. The three together give us everything.

---

## The "New Version" Output

The extracted project is a **new version** of the original:

1. **Same declarations** — every def, theorem, instance, inductive from the original
2. **Same dependencies** — exact kernel-verified dependency graph
3. **Same compilability** — the code compiles because it's the original source
4. **New structure** — one file per declaration, with imports
5. **New metadata** — dag.json, sourceMap.json, declMeta.json
6. **Self-contained** — no Mathlib dependency, just `import Init`

This is the alchemy: we take the raw materials (declarations, dependencies,
source) and transform them into a new, structured, self-contained version with
exact metadata. The new version is both compilable AND introspectable.

---

## Connection to Aristotle

The Aristotle verification system can then verify the extracted project:
- Each declaration file can be individually checked
- The dependency graph can be verified (are all deps present?)
- The source map can be used to trace back to the original
- The metadata can be used for semantic analysis

This creates a verified, structured, self-contained version of any Lean project.

---

## File Locations

| Component | Location |
|-----------|----------|
| Introspector source | `/mnt/data1/nix/time/2025/05/10/Lean4Introspector/src/` |
| Introspector data | `/mnt/data1/nix/time/2025/05/10/Lean4Introspector/data/` |
| Introspector binary | `/mnt/data1/nix-store/store/.../bin/lean4introspector` |
| Splitter source | `~/projects/arist/splitter-engine/RequestProject/SplitDecls.lean` |
| Target project | `~/projects/lean-split-tool/dasl-verification/` |
| Test output | `/tmp/test-split-v2/` |
| Status report | `~/projects/arist/splitter-engine/STATUS.md` |
| This document | `~/projects/arist/splitter-engine/ALCHEMY.md` |
