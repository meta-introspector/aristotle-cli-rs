# Splitter Engine Documentation Index

This directory contains the Lean 4 Declaration Splitter tool and its supporting documentation.

## Documentation Files

### 1. `README.md`
Quick start guide and overview of the splitter engine.

**Purpose**: Get started quickly with basic usage and examples.

### 2. `SPLITTER_DOCUMENTATION.md`
Comprehensive documentation of the entire splitter system.

**Purpose**: Deep dive into architecture, usage, and technical details.

**Sections**:
- Overview and benefits
- All components (SplitDecls, finders, pipeline tools)
- Architecture and file structure
- Detailed usage instructions
- Key functions documentation
- Output file formats
- Example workflows
- Use cases
- Technical details
- Build requirements
- Related tools
- Testing infrastructure
- Future enhancements

### 3. `DOCUMENTATION_INDEX.md` (this file)
This index - links to all documentation.

## Source Code Documentation

Each Lean file in `RequestProject/` has module-level documentation:

### Core Files
- **`SplitDecls.lean`**: Main declaration splitter (lines 1-21)
- **`MinimalPipeline.lean`**: Minimal Lean 4 pipeline (lines 1-34)
- **`PipelineSkeleton.lean`**: Pipeline extraction tool

### Finder Tools
- **`DupFinder.lean`**: Exact duplicate finder
- **`SemanticDupFinder.lean`**: Semantic near-duplicate finder
- **`ArrowFinder.lean`**: Expression structure analysis
- **`SizeFinder.lean`**: Declaration size measurement
- **`WordCloudFinder.lean`**: Symbol usage analysis

### Other Analysis Tools
- **`Coverage.lean`**: Dependency coverage measurement
- **`DepthFinder.lean`**: Declaration depth analysis
- **`FlowFinder.lean`**: Proof flow pattern analysis
- **`SelfModelFlow.lean`**: Self-flow pattern modeling
- **`ProofTermFinder.lean`**: Proof term extraction
- **`GradedCodeModel.lean`**: Graded code model analysis

## Script Documentation

### `split-aristotle-project.sh`
Script to split Aristotle projects into per-declaration flakes.

**Usage**: `./split-aristotle-project.sh <project-dir> <output-dir>`

**Documentation**: The script itself has inline comments explaining:
1. How it finds the best module to split
2. How it sets up the temporary workspace
3. How it builds and runs the splitter
4. How it reports results

## Generated Documentation

The `aristotles_results/` directory contains:
- `split-test/`: Test split results with 359 declarations
- `split-test-body/`: Detailed body-level splits (359 declarations)
- Example flakes showing the dependency structure
- `dag.json`: Complete dependency graph

## How to Use This Documentation

1. **Start with `README.md`** for quick setup
2. **Read `SPLITTER_DOCUMENTATION.md`** for deep understanding
3. **Browse individual `.lean` files** for specific implementation details
4. **Check the scripts** for automation workflows
5. **Look at `aristotles_results/`** for examples

## Documentation Quality

All files include:
- Module-level docstrings explaining purpose
- Usage examples
- Technical details
- Clear structure

The `SPLITTER_DOCUMENTATION.md` provides a unified view across all components.
