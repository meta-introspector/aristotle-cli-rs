---
name: "cargo-vendormod-multi-lang"
description: "Detect languages and generate per-language Nix flakes with cargo-vendormod. Use when processing Java, JavaScript, C, Lean4, Python, Go, Ruby, Nix, or mixed-language projects."
---

# Cargo-Vendormod Multi-Language

## Language Detection

```rust
use cargo_vendormod::lang_detect::detect_language;
```

Mapping:

- `Java` -> `stdenv.mkDerivation` + Maven
- `JavaScript` -> `buildNpmPackage`
- `C` -> `stdenv.mkDerivation` + CMake/Make
- `Lean4` -> `lean4-nix` + `lake build`
- `Unknown` -> generic flake template

## Nix Flake Outputs

```bash
cargo run --bin processing -- crates ./flakes/my-java-lib --generate-flakes
cargo run --bin vendormod -- multi-lang-flake --lang lean4 --root ./mathlib
```

## Lean4 Flow

1. Find `lean-toolchain` or `lakefile.toml`.
2. Generate flake using `lean4-nix` or `lean-toolchain`.
3. Build with `nix build` and test with `lean --make`.

## Entrypoints

```rust
use cargo_vendormod::multi_lang_flake::MultiLangFlakeGenerator;
use cargo_vendormod::lean4_driver::{Lean4Driver, Lean4Project};
use cargo_vendormod::language_driver::LanguageDriver;
```
