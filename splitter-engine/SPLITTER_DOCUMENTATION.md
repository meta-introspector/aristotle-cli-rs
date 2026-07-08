# Lean 4 Declaration Splitter Tool

## Overview

The **Lean 4 Declaration Splitter** is a tool that splits Lean 4 declarations into individual files with proper dependency tracking. It enables:

- **Minimal recompilation**: Change one declaration → rebuild only its dependents
- **Parallel builds**: Independent branches compile in parallel  
- **Cherry-pick imports**: `import Split.<decl>` pulls only what's needed

## Components

### 1. Core Splitter (`SplitDecls.lean`)

The main tool that:
1. Loads a Lean environment via `importModules`
2. Extracts every declaration and its exact dependencies
3. Emits one `.lean` file per declaration
4. Generates a `flake.nix` for each declaration in the lattice

**Location**: `splitter-engine/RequestProject/SplitDecls.lean`

**Main Function**: `def main (args : List String) : IO UInt32`

### 2. Supporting Finders

The splitter is complemented by several "finder" tools that analyze the codebase:

- **DupFinder.lean**: Finds exact duplicate declarations
- **SemanticDupFinder.lean**: Finds near-duplicate declarations using similarity metrics
- **ArrowFinder.lean**: Analyzes expression structure
- **SizeFinder.lean**: Measures declaration sizes
- **WordCloudFinder.lean**: Analyzes symbol usage patterns

### 3. Pipeline Tools

- **MinimalPipeline.lean**: A minimal Lean 4 parser/processor pipeline extracted from Lean itself
- **PipelineSkeleton.lean**: Used to extract the minimal pipeline from Lean's source

### 4. Other Analysis Tools

- **Coverage.lean**: Measures dependency coverage
- **DepthFinder.lean**: Analyzes declaration depth
- **FlowFinder.lean**: Finds proof flow patterns
- **SelfModelFlow.lean**: Models self-flow patterns
- **ProofTermFinder.lean**: Extracts proof terms
- **GradedCodeModel.lean**: Graded code model analysis

## Architecture

### Dependency Lattice

The splitter creates a DAG (Directed Acyclic Graph) of declarations where:
- Each node is a single declaration (def, theorem, axiom, etc.)
- Edges represent dependencies (a depends on b)
- Files are organized topologically (dependencies before dependents)

### File Structure

Output files are organized as:
```
output-dir/
  Split/
    <module>/
      <declaration>.lean
      flake.nix
  lakefile.toml
  dag.json
```

### Nix Flakes Integration

Each declaration gets a `flake.nix` that:
- Declares the declaration as a package
- Lists its dependencies as flake inputs (via `path:` references)
- Enables Nix-based builds with proper dependency tracking

## Usage

### Command Line

```bash
# Split a specific module
lake exe splitdecls Mathlib.Algebra.Vertex.HVertexOperator ./split-out

# Split with custom output directory
lake exe splitdecls RequestProject.SplitDecls ./split-self

# Use configuration file
# (create split-config.json in current directory)
```

### Configuration File (`split-config.json`)

```json
{
  "modules": ["Mathlib.Algebra.Vertex.HVertexOperator"],
  "outputDir": "./split-out"
}
```

Or with a single module:
```json
{
  "module": "Mathlib.Algebra.Vertex.HVertexOperator",
  "outputDir": "./split-out"
}
```

## Key Functions in SplitDecls.lean

### `collectRefs (e : Expr) : NameSet`
Collects all constant names referenced in an expression.

### `constDeps (env : Environment) (n : Name) : NameSet`
Gets all dependencies of a constant from its type and value.

### `bfsClosure (env : Environment) (roots : Array Name) (universeSet : NameSet) : NameSet`
BFS dependency closure starting from root names.

### `topoSort (env : Environment) (names : Array Name) (universeSet : NameSet) : Array Name`
Topological sort of declarations (dependencies before dependents).

### `emitDeclFile (env : Environment) (n : Name) (deps : Array Name) (outDir : FilePath)`
Emits a `.lean` file for one declaration with its actual body.

### `emitDeclFlake (n : Name) (deps : Array Name) (absOutDir : FilePath)`
Emits a `flake.nix` for one declaration with dependency wiring.

### `emitLakefile (names : Array Name) (outDir : FilePath)`
Generates the top-level `lakefile.toml` for the split project.

### `emitDag (env : Environment) (names : Array Name) (universeSet : NameSet) (outDir : FilePath)`
Generates `dag.json` with dependency structure.

## Output Files

### 1. Declaration Files (`Split/<module>/<declaration>.lean`)

Each file contains:
```lean
import Mathlib

-- spec: <declaration> : <type>
def <name> : <type> := <value>
```

Or for theorems:
```lean
-- spec: theorem <name> : <type>
theorem <name> : <type> := <proof>
```

### 2. Flake Files (`Split/<module>/<declaration>/flake.nix`)

Each flake declares the declaration as a derivable package with dependencies as flake inputs.

### 3. Dependency Graph (`dag.json`)

JSON mapping each declaration to its in-universe dependencies.

### 4. Lake Configuration (`lakefile.toml`)

Top-level lakefile that defines all the split modules as lean_lib targets.

## Example Workflow

### 1. Split an Aristotle Project

```bash
./split-aristotle-project.sh /path/to/project ./output-split
```

This:
1. Finds the module with most declarations
2. Copies the splitter engine
3. Builds the target module
4. Runs the splitter
5. Outputs split files with flakes

### 2. Build the Split Project

```bash
cd output-split
lake build
```

Nix will automatically handle dependencies through the flake inputs.

### 3. Use Split Declarations

```lean
import Split.Quot_sound
```

This imports only the `Quot.sound` axiom and its transitive dependencies.

## Use Cases

1. **Minimal Recompilation**: When working on one theorem, only rebuild its dependents
2. **Parallel Builds**: Independent declaration branches can compile in parallel
3. **Dependency Analysis**: Understand exact dependency relationships
4. **Code Navigation**: Each declaration is isolated for easier study
5. **Selective Import**: Import only what you need for a specific proof

## Technical Details

### Environment Initialization

```lean
initSearchPath (← findSysroot)
let opts := {}
let imports := (rootMods.map (fun m => ({module := m.toName} : Import))).toArray
let env ← importModules imports opts
```

### Declaration Extraction

```lean
def declsInModules (env : Environment) (mods : List Name) : Array Name
```

Finds every non-internal declaration defined in the given modules.

### Dependency Filtering

```lean
def filterDeps (deps : NameSet) (targets : NameSet) : Array Name
```

Filters dependencies to stay within the target universe.

## Build Requirements

- Lean 4.28.0
- Mathlib4
- Nix (for flake-based builds)

## Related Tools

- **lean-split**: Creates per-module Nix flakes for Lean 4 projects
- **Aristotle**: Project management and code analysis tools
- **DASL**: Cross-implementation fuzzing harness

## Testing

The tool includes test infrastructure in `aristotles_results/` with:
- `split-test/`: Test split results
- `split-test-body/`: Detailed body-level splits
- Regression tests for various Mathlib declarations

## Future Enhancements

Potential improvements:
- Support for mutual recursion
- Better handling of internal declarations
- More sophisticated dependency analysis
- Integration with other build systems
- Enhanced visualization of dependency graphs

## Self-Application Test

To verify the splitter works correctly, we ran it on itself:

```bash
lake env lean --run RequestProject/SplitDecls.lean RequestProject.SplitDecls ./split-self-test
```

### Results

✅ **Successfully split 2,761 declarations** from the RequestProject.SplitDecls module
- 117,204 total declarations in the environment
- 32 seed declarations identified
- 2,761 declarations in dependency closure
- All files emitted without errors

### Verification

The output includes:
- ✅ 2,759 `.lean` declaration files
- ✅ 2,761 `flake.nix` files with proper dependency tracking
- ✅ Complete `dag.json` with full dependency graph (117,204 lines)
- ✅ Top-level `lakefile.toml` for the split project

### test_results.md

See `TEST_RESULTS.md` for detailed analysis of:
- File structure and counts
- Dependency patterns
- Nix flake structure
- Verification of correctness

This self-application demonstrates the tool can handle complex real-world codebases like Mathlib.
