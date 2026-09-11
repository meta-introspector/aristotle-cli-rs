import Mathlib
import RequestProject.CborTypes

/-!
# Supersingular Primes and the SSP Vector Map

The 15 supersingular primes are the primes p for which the supersingular
j-invariants in characteristic p are all defined over 𝔽_p.
Equivalently, these are the prime divisors of the order of the Monster group.

We define the SSP vector as a type-5 CBOR map with 15 key/value pairs
(one per supersingular prime), and establish basic properties.

## SSP boundary primes

The three largest SSP primes — 47, 59, 71 — serve as "boundary" primes
marking the transitions between CBOR float precision levels:
- 47: float16 → float32 boundary
- 59: float32 → float64 boundary
- 71: float64 → bignum boundary
-/

/-- The 15 supersingular primes (SSP). -/
def sspPrimes : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-
There are exactly 15 supersingular primes.
-/
theorem sspPrimes_length : sspPrimes.length = 15 := by
  rfl

/-
All entries in `sspPrimes` are prime.
-/
theorem sspPrimes_all_prime : ∀ p ∈ sspPrimes, Nat.Prime p := by
  native_decide

/-- The SSP vector: a function from index (0..14) to residue values. -/
structure SSPVector where
  residues : Fin 15 → ℕ

/-- Encode an SSP vector as a CBOR type-5 map object with 15 pairs. -/
def SSPVector.toCborObj (_ : SSPVector) : CborObj :=
  { ty := .map, arity := 15 }

/-
The SSP map always has major type 5 (map).
-/
theorem SSPVector.toCborObj_type (v : SSPVector) :
    v.toCborObj.ty = MajorType.map := by
      rfl

/-
The SSP map always has arity 15.
-/
theorem SSPVector.toCborObj_arity (v : SSPVector) :
    v.toCborObj.arity = 15 := by
      rfl

-- ============================================================
-- SSP boundary primes
-- ============================================================

/-- The three SSP boundary primes marking float precision transitions. -/
def sspBoundaryPrimes : List ℕ := [47, 59, 71]

/-
All boundary primes are supersingular primes.
-/
theorem sspBoundaryPrimes_subset :
    ∀ p ∈ sspBoundaryPrimes, p ∈ sspPrimes := by
      native_decide +revert

/-- The trivector (n mod 47, p mod 59, q mod 71) for DASL/flake.lock encoding. -/
def sspTrivector (n p q : ℕ) : Fin 47 × Fin 59 × Fin 71 :=
  (⟨n % 47, Nat.mod_lt n (by omega)⟩,
   ⟨p % 59, Nat.mod_lt p (by omega)⟩,
   ⟨q % 71, Nat.mod_lt q (by omega)⟩)

-- ============================================================
-- The 3-tensor: j(ni)^p mod q
-- ============================================================

/-- The 3-tensor entry: given indices n, p, q, compute the residue.
    This is a placeholder for the actual j-invariant computation. -/
noncomputable def tensorEntry (n p q : ℕ) : ℕ := (n ^ p) % q

/-
The tensor entry is always less than q (when q > 0).
-/
theorem tensorEntry_lt (n p q : ℕ) (hq : 0 < q) :
    tensorEntry n p q < q := by
      exact Nat.mod_lt _ hq