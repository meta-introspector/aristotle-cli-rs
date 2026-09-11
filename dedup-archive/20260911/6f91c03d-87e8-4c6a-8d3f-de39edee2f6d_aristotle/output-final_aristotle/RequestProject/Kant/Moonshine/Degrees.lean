/-
# The degree layer: 194 irreducible indices, degrees, and prime support

The legacy markup hard-wired one triple, `(71, 59, 47)`, as though it were
*the* basis.  It is not: `196883 = 47 · 59 · 71` is a property of **one**
degree, and the Monster's character table has 194 irreducible characters,
whose degrees are listed by OEIS A001379.

This module fixes the layering:

```
irrep index  ──degree──▶  a natural number  ──factorization──▶  prime support
                                             ──(only if declared)──▶  CRT coordinates
```

Each arrow is a function, so nothing downstream is ever asserted
independently of what it is derived from.

Two honesty results are proved here, and both are the reason for the
layering:

* **degree is not an identifier.**  A table whose image has fewer than 194
  values cannot be injective (`DegreeTable.degree_not_injective`), and then
  no decoder recovers the index from the degree
  (`DegreeTable.no_degree_decoder`).  Code that keys on a dimension rather
  than on an index is wrong, whatever the table says.
* **CRT coordinates are not universal.**  They exist for a degree exactly
  when a modulus system has been declared for it; the `(71, 59, 47)` system
  is recovered as the instance belonging to the degree `196883`
  (`moduliOfSquarefreeTriple`, `monsterModuli_of_196883`).

Lean has no Monster character table and neither does Mathlib, so the table
is **carried as data** (`DegreeTable`) and every statement about a specific
degree takes the relevant equation as an explicit hypothesis.  Nothing here
claims to know A001379's entries.
-/
import Mathlib
import RequestProject.Kant.Moonshine.Crt

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Moonshine

/-- The Monster has 194 conjugacy classes and hence 194 irreducible
characters; an index into that basis is the identity of a representation. -/
abbrev IrrepIndex := Fin 194

theorem irrepIndex_card : Fintype.card IrrepIndex = 194 := by simp

/-- A degree lookup, i.e. what A001379 supplies: the dimension of each
irreducible.  Carried as data — no character table is proved here. -/
structure DegreeTable where
  /-- `degree i` is the dimension of the `i`-th irreducible. -/
  degree : IrrepIndex → ℕ
  /-- Dimensions are positive. -/
  degree_pos : ∀ i, 0 < degree i

namespace DegreeTable

variable (T : DegreeTable)

theorem degree_ne_zero (i : IrrepIndex) : T.degree i ≠ 0 := Nat.ne_of_gt (T.degree_pos i)

/-- **Degrees are not identifiers.**  If the table takes fewer than 194
distinct values — as the Monster's does, several irreducibles sharing a
dimension — then the degree map is not injective. -/
theorem degree_not_injective
    (h : (Finset.image T.degree Finset.univ).card < 194) :
    ¬ Function.Injective T.degree := by
  intro hinj
  have : (Finset.image T.degree Finset.univ).card = 194 := by
    rw [Finset.card_image_of_injective _ hinj]
    simp
  omega

/-- Two distinct irreducibles of equal dimension: the concrete form of the
same fact. -/
theorem exists_degree_collision
    (h : (Finset.image T.degree Finset.univ).card < 194) :
    ∃ i j : IrrepIndex, i ≠ j ∧ T.degree i = T.degree j := by
  by_contra hc
  push_neg at hc
  exact T.degree_not_injective h (fun i j hij => by
    by_contra hne
    exact absurd hij (hc i j hne))

/-- **No decoder from degree back to index.**  Once two irreducibles share a
dimension, no function whatsoever recovers the index from the degree, so a
catalogue keyed on dimension is unsound by construction. -/
theorem no_degree_decoder {i j : IrrepIndex} (hne : i ≠ j) (heq : T.degree i = T.degree j)
    (f : ℕ → IrrepIndex) : ¬ (∀ k, f (T.degree k) = k) := by
  intro hf
  exact hne (by rw [← hf i, heq, hf j])

/-! ### Prime support, derived from the degree -/

/-- The prime support of an irreducible's degree: exponents of its prime
factorization.  Derived from the degree, never stored beside it. -/
def primeSupport (i : IrrepIndex) : ℕ →₀ ℕ := (T.degree i).factorization

/-- **The factorization round trip.**  The prime support loses nothing: the
degree is recovered from it. -/
theorem primeSupport_prod (i : IrrepIndex) :
    (T.primeSupport i).prod (fun p e => p ^ e) = T.degree i :=
  Nat.factorization_prod_pow_eq_self (T.degree_ne_zero i)

/-- Every prime in the support really is prime, and really divides. -/
theorem primeSupport_mem {i : IrrepIndex} {p : ℕ} (hp : p ∈ (T.primeSupport i).support) :
    Nat.Prime p ∧ p ∣ T.degree i := by
  rw [primeSupport, Nat.support_factorization] at hp
  exact ⟨Nat.prime_of_mem_primeFactors hp, Nat.dvd_of_mem_primeFactors hp⟩

end DegreeTable

/-! ## When a degree admits a CRT coordinate system -/

/-- A modulus system built from three pairwise distinct primes.  This is the
*only* way a CRT triple enters: from a declared, verified factorization. -/
def moduliOfSquarefreeTriple {a b c : ℕ} (ha : Nat.Prime a) (hb : Nat.Prime b)
    (hc : Nat.Prime c) (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c) : Moduli where
  p := a
  q := b
  r := c
  hp := ha.pos
  hq := hb.pos
  hr := hc.pos
  hpq := (Nat.coprime_primes ha hb).mpr hab
  hpr := (Nat.coprime_primes ha hc).mpr hac
  hqr := (Nat.coprime_primes hb hc).mpr hbc

/-- The prime support of `196883`: exactly `{47, 59, 71}`, each to the first
power. -/
theorem primeFactorsList_196883 : Nat.primeFactorsList 196883 = [47, 59, 71] := by
  native_decide

theorem primeFactors_196883 : Nat.primeFactors 196883 = {47, 59, 71} := by
  rw [Nat.primeFactors, primeFactorsList_196883]
  decide

/-- The declared system of the legacy markup is exactly the system the
degree `196883` admits: its modulus is that degree. -/
theorem monsterModuli_of_196883 {T : DegreeTable} {i : IrrepIndex} (h : T.degree i = 196883) :
    monsterModuli.modulus = T.degree i := by
  rw [h, monsterModuli_modulus]

/-- …and the moduli are exactly the prime support of that degree. -/
theorem monsterModuli_primeFactors {T : DegreeTable} {i : IrrepIndex} (h : T.degree i = 196883) :
    (T.primeSupport i).support = {71, 59, 47} := by
  rw [DegreeTable.primeSupport, h, Nat.support_factorization, primeFactors_196883]
  decide

/-- A degree with a repeated prime factor, or with more or fewer than three,
gets **no** three-coordinate system — the schema must leave the field
absent rather than invent one.  Stated as: a squarefree three-prime system
forces the modulus to be that product. -/
theorem moduliOfSquarefreeTriple_modulus {a b c : ℕ} (ha : Nat.Prime a) (hb : Nat.Prime b)
    (hc : Nat.Prime c) (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c) :
    (moduliOfSquarefreeTriple ha hb hc hab hac hbc).modulus = a * b * c := rfl

end Kant.Moonshine
