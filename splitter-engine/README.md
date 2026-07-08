# Splitter Engine - Lean 4 Declaration Splitter

A tool for splitting Lean 4 declarations into individual files with Nix flake dependencies.

## Quick Start

```bash
# Build the splitter
cd splitter-engine
lake build

# Split a module
lake exe splitdecls Mathlib.Data.Nat.Basic ./split-out

# Or use the config file
cat > split-config.json <<EOF
{
  "modules": ["Mathlib.Data.Nat.Basic"],
  "outputDir": "./split-out"
}
EOF
lake exe splitdecls
```

## What It Does

1. **Loads** a Lean environment with all dependencies
2. **Extracts** every declaration and its exact dependencies
3. **Emits** one `.lean` file per declaration
4. **Generates** Nix flakes for each declaration
5. **Creates** a dependency graph for minimal recompilation

## Key Files

- `RequestProject/SplitDecls.lean` - Main splitter implementation
- `RequestProject/*.lean` - Various analysis tools
- `split-aristotle-project.sh` - Script to split Aristotle projects

## Example Output

```
split-out/
├── Split/
│   ├── Data/
│   │   ├── Nat/
│   │   │   ├── Basic.lean
│   │   │   ├── Nat.succ.lean
│   │   │   ├── Nat.zero.lean
│   │   │   └── ...
│   │   │   └── flake.nix
│   │   └── ...
├── lakefile.toml
└── dag.json
```

## Benefits

- **Minimal Recompilation**: Only rebuild what's affected
- **Parallel Builds**: Independent declarations compile concurrently
- **Selective Import**: Import only needed declarations
- **Dependency Visualization**: Clear dependency graph

## Documentation

See `SPLITTER_DOCUMENTATION.md` for detailed documentation.

## License

MIT or similar permissive license (check individual files).
