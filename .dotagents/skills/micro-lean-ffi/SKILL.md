---
name: micro-lean-ffi
description: >-
  Micro-Lean4 FFI extraction meta-system. Verified micro-core type AST
  with polyglot emitters (Rust, C++, JS, Python, Emoji), C ABI boxing,
  reference counting, and custom meta_lean_export command. All sorry-free
  with machine-checked theorems. Use when generating FFI bindings from
  Lean types or working with the splitter-engine/MicroLean.lean.
---

# Micro-Lean4 — FFI Extraction Meta-System

A verified, machine-checked system that projects Lean types onto a micro-core
AST and generates polyglot FFI templates. Lives in
`splitter-engine/RequestProject/MicroLean.lean`.

## When to Use

- "Generate FFI bindings for a Lean type"
- "Project Lean types to C ABI"
- "Use meta_lean_export command"
- "Work with MicroLean type AST"

## Micro-Core Type AST

```lean
inductive MicroLeanType where
  | nat                           -- Lean Nat, boxed as lean_object*
  | bool                          -- Lean Bool, unboxed scalar
  | function (domain codomain : MicroLeanType)
  | array (elem : MicroLeanType)
  | prod (fst snd : MicroLeanType)
  deriving Repr, DecidableEq, Inhabited
```

## Polyglot Emitters

Each emitter maps `MicroLeanType → String`:

| Eitter | Target | Example (.nat) | Example (.bool) |
|--------|--------|----------------|-----------------|
| `emitRust` | Rust FFI | `*mut lean_object` | `bool` |
| `emitCpp` | C++ FFI | `lean_object*` | `bool` |
| `emitJs` | koffi/ffi-napi | `'pointer'` | `'bool'` |
| `emitPython` | ctypes/typing | `ctypes.c_void_p` | `ctypes.c_bool` |
| `emitEmoji` | Human-readable | `🔢` | `🔘` |
| `emitCABI` | C ABI canonical | `lean_object*` | `uint8_t` |

## Custom Command

```lean
meta_lean_export definitive_proven_micro_core : Nat → Nat
meta_lean_export array_pipeline : Array Nat → Bool
meta_lean_export struct_codec : Nat × Bool → Nat
```

At compile time, this elaborates the genuine Lean type, projects to micro-core,
and prints multi-language FFI templates.

## Memory Management

- `isBoxed` — `bool` is unboxed, everything else is boxed
- `memOps` — generates `lean_inc`/`lean_dec` ops for boxed values
- `genFFI` — full template: Rust + C++ + JS + Python + Emoji + memory ops

## Verified Theorems (sorry-free)

- **ABI preservation**: `abi_boxed_iff` — boxed ↔ C ABI = `lean_object*`
- **C ABI totality**: `emitCABI_total` — every type maps to `lean_object*` or `uint8_t`
- **Memory alignment**: `mem_iff_boxed` — refcount ops iff boxed
- **Emitter totality**: `emitRust_ne`, `emitCpp_ne`, `emitPython_ne`, `emitJs_ne`, `emitEmoji_ne`, `emitCABI_ne`, `genFFI_ne` — no emitter produces empty string
- **Negation soundness**: `not_all_boxed` — disproved by `counterTerm = .bool`
- **Round-trip**: `ofExprPure_reify` — projection recovers every micro-core type
- **Elaboration path totality**: `elaboration_path_total` — command always emits well-formed template
- **Cross-target fidelity**: `richer_targets_distinguish` — Python/Rust/C++ keep structure, JS collapses to `'pointer'`

## Key Functions

- `ofExpr` — MetaM projection from genuine Lean Expr to micro-core
- `ofExprPure` — total pure model of the projection
- `reify` — inverse: micro-core → genuine Lean Expr
- `projectOr` — total model: `some mt → mt`, `none → .function .nat .nat`
