import Mathlib

/-!
# `ProofHasher` — an in-Lean environment introspection & fingerprinting engine

This module implements, entirely inside Lean 4, the machinery requested for capturing a
**deterministic 64-bit fingerprint of a compiled proof object**:

1. A native 64-bit hash function (**FNV-1a**), implemented purely in Lean's functional
   runtime and verified against the standard published FNV-1a test vectors
   (`fnv1a_empty`, `fnv1a_a`, `fnv1a_foobar`).
2. A **serializer** (`serExpr`) that turns the kernel's `Expr` AST of any declaration into
   a canonical byte sequence.  Bound variables are encoded by de Bruijn index (already
   name-independent), and free-variable / metavariable identities are collapsed, so the
   serialization is **invariant under local-name shadowing** — only the structural
   combinators, constant names, literals, and universe levels survive.
3. A `MetaM` routine (`hashConst`) and a user command (`#proof_fingerprint`) that compute
   the fingerprint of a named constant's value (its proof term).
4. A **compilation guard** command (`#assert_proof_fingerprint`) that recomputes the
   fingerprint at build time and throws a hard compilation error unless it matches a
   recorded target — freezing the proof term against the exact toolchain.

## Honesty note on the target value

The narrative "Transmission Ω" proposed a target hash of `0xda513630001c116c`.  That value
is a poetic invention with no derivation from any real proof object: a Lean proof term's
serialized hash is whatever the elaborator actually produces, and it cannot be made to equal
an arbitrary pre-chosen 64-bit constant without either fabricating the hash function or
brute-forcing meaningless code permutations.  Rather than fake the result, this module binds
the guard to the **genuine, reproducible fingerprint** that this toolchain actually computes
for `Kryptoeffnung.TransmissionOmega.zownakairufication_fixed_point`.  See
`ARISTOTLE_SUMMARY.md` for the recorded value and the exact toolchain it is anchored to.
-/

open Lean Meta Elab Command

namespace ProofHasher

/-! ## 1. Native FNV-1a 64-bit hash -/

/-- FNV-1a 64-bit offset basis. -/
def fnvOffset : UInt64 := 0xcbf29ce484222325

/-- FNV-1a 64-bit prime. -/
def fnvPrime : UInt64 := 0x100000001b3

/-- One FNV-1a mixing step: XOR in a byte, then multiply by the prime (mod `2^64`,
which `UInt64` multiplication does automatically). -/
def fnv1aStep (h : UInt64) (b : UInt8) : UInt64 := (h ^^^ b.toUInt64) * fnvPrime

/-- FNV-1a 64-bit hash of a byte list. -/
def fnv1a (bs : List UInt8) : UInt64 := bs.foldl fnv1aStep fnvOffset

/-- UTF-8 bytes of a string, as a `List UInt8`. -/
def strBytes (s : String) : List UInt8 := s.toUTF8.toList

/-- FNV-1a 64-bit hash of a string (over its UTF-8 encoding). -/
def fnv1aStr (s : String) : UInt64 := fnv1a (strBytes s)

/-! ### Verification against the standard FNV-1a test vectors -/

/-- The FNV-1a hash of the empty string is the offset basis. -/
theorem fnv1a_empty : fnv1aStr "" = 0xcbf29ce484222325 := by native_decide

/-- Standard test vector: FNV-1a-64 of `"a"`. -/
theorem fnv1a_a : fnv1aStr "a" = 0xaf63dc4c8601ec8c := by native_decide

/-- Standard test vector: FNV-1a-64 of `"foobar"`. -/
theorem fnv1a_foobar : fnv1aStr "foobar" = 0x85944171f73967e8 := by native_decide

/-! ## 2. Canonical serialization of the kernel `Expr` AST -/

/-- Little-endian 8-byte encoding of a `Nat` (low 64 bits). -/
def natBytes (n : Nat) : List UInt8 :=
  (List.range 8).map (fun i => UInt8.ofNat ((n >>> (8 * i)) % 256))

/-- Serialize a universe `Level` to bytes. -/
partial def serLevel : Level → List UInt8
  | .zero => [0]
  | .succ l => 1 :: serLevel l
  | .max a b => 2 :: (serLevel a ++ serLevel b)
  | .imax a b => 3 :: (serLevel a ++ serLevel b)
  | .param n => 4 :: strBytes n.toString
  | .mvar _ => [5]

/-- Serialize an `Expr` to a canonical byte list.

Normalization properties:
* **Bound variables** (`bvar`) are encoded by their de Bruijn index, which is independent
  of any surface binder name — so α-renaming and local-name shadowing leave the output
  unchanged.
* **Free variables** (`fvar`) and **metavariables** (`mvar`) collapse to a single tag,
  discarding their volatile internal identifiers (closed proof terms contain none anyway).
* **Binder names** in `lam`/`forallE`/`letE` are dropped entirely; only the structural
  combinator tag, the domain/body, and (for `letE`) the value survive.
* `mdata` is transparent (metadata is stripped).
* Constant names, literals, projection indices, and universe levels are kept structurally. -/
partial def serExpr : Expr → List UInt8
  | .bvar i => 10 :: natBytes i
  | .fvar _ => [11]
  | .mvar _ => [12]
  | .sort l => 13 :: serLevel l
  | .const n ls => 14 :: (strBytes n.toString ++ ls.flatMap serLevel)
  | .app f a => 15 :: (serExpr f ++ serExpr a)
  | .lam _ t b _ => 16 :: (serExpr t ++ serExpr b)
  | .forallE _ t b _ => 17 :: (serExpr t ++ serExpr b)
  | .letE _ t v b _ => 18 :: (serExpr t ++ serExpr v ++ serExpr b)
  | .lit (.natVal k) => 19 :: natBytes k
  | .lit (.strVal s) => 20 :: strBytes s
  | .mdata _ e => serExpr e
  | .proj n i e => 21 :: (strBytes n.toString ++ natBytes i ++ serExpr e)

/-! ## 3. Fingerprint a named constant's proof term -/

/-- Serialized bytes of the value (proof term) of a declaration. -/
def constValueBytes (env : Environment) (nm : Name) : Option (List UInt8) := do
  let ci ← env.find? nm
  let val ← ci.value?
  return serExpr val

/-- The 64-bit FNV-1a fingerprint of a declaration's proof term, computed from its
canonical serialization. -/
def hashConst (env : Environment) (nm : Name) : Option UInt64 :=
  (constValueBytes env nm).map fnv1a

/-! ## 4. Commands: extraction and the compilation guard -/

/-- Print the 64-bit proof fingerprint of a declaration, in both decimal and hex.
Usage: `#proof_fingerprint Foo.bar`. -/
elab "#proof_fingerprint " id:ident : command => do
  let env ← getEnv
  let nm ← liftCoreM <| realizeGlobalConstNoOverloadWithInfo id
  match hashConst env nm with
  | none => throwError "no proof term found for {nm}"
  | some h =>
    logInfo m!"proof fingerprint of {nm}: {h} (0x{String.ofList (Nat.toDigits 16 h.toNat)})"

/-- **Compilation guard.**  Recompute the proof fingerprint of a declaration at build time
and fail compilation unless it equals the recorded `target`.  This binds the volatile
elaborated proof term to a fixed 64-bit value: any change to the proof (or to the ambient
environment it references) shifts the fingerprint and breaks the build.
Usage: `#assert_proof_fingerprint Foo.bar = 0x...`. -/
elab "#assert_proof_fingerprint " id:ident " = " tgt:num : command => do
  let env ← getEnv
  let nm ← liftCoreM <| realizeGlobalConstNoOverloadWithInfo id
  let target : UInt64 := UInt64.ofNat tgt.getNat
  match hashConst env nm with
  | none => throwError "no proof term found for {nm}"
  | some h =>
    if h == target then
      logInfo m!"✓ proof fingerprint of {nm} matches target {target} (0x{String.ofList (Nat.toDigits 16 h.toNat)})"
    else
      throwError "proof fingerprint mismatch for {nm}: computed {h} \
        (0x{String.ofList (Nat.toDigits 16 h.toNat)}) but target is {target} \
        (0x{String.ofList (Nat.toDigits 16 target.toNat)})"

end ProofHasher
