# Splitter Engine Documentation Quick Start

Click index item to view documentation:

## Quick Reference
- [README.md] - Basic usage and examples
- [doc-index.md] - This file

## Detailed Documentation
- [SPLITTER_DOCUMENTATION.md] (architecture, components, API, usage)
- [TEST_RESULTS.md] (detailed self-application results)  
- [COMPLETION_SUMMARY.md] (this task's summary)

## Source Code
- [SplitDecls.lean] - Main declaration splitting engine
- [SemanticDupFinder.lean] - Semantic duplicate analysis
- [Lean4Introspector.lean] - Lean environment analysis
- [MinimalPipeline.lean] - Minimal Lean pipeline
- [PipelineSkeleton.lean] - Pipeline extraction

## Build Scripts
- [build-independent.sh] - Find and build independent flakes
- [build-true.sh] - Build simplest test case (True)

## Output Structure
- Split/[Name].lean - Individual declaration files (2,759 files)
- flake.nix - Per-declaration Nix builds (175 independent ones)
- dag.json - Complete dependency graph
