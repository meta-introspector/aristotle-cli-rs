/-
Copyright (c) 2026. Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal3.KleinSigns

/-!
# Two-dimensional icosahedral characters, and the holomorphy gap for `1951`

This module contains two independent, self-contained pieces, both pure mathematics with no
`L`-function theory in sight.

## 1. The two "two-dimensional characters" of the icosahedral group

Recorded as finite-group data on the five conjugacy classes of `A₅`:

  `χ₂(1) = 2`,  `χ₂(2A) = 0`,  `χ₂(3A) = -1`,  `χ₂(5A) = (1+√5)/2`,  `χ₂(5B) = (1-√5)/2`,

together with `χ₂′`, obtained by exchanging the golden-ratio values `φ = (1+√5)/2` and
`φ′ = (1-√5)/2`.  Proved here: the two characters are Galois conjugates under `√5 ↦ -√5`
(`Icosa.chi2_neg`), orthogonality for the class-size weighted pairing, and the fact that the
**cycle type does not separate `5A` from `5B`** — a `5`-cycle, its inverse and its square all
have cycle type `{5}` in `S₅` (`Icosa.cycleType_fiveCycle_pow`), so the factorisation type of
the quintic modulo a prime cannot distinguish the two classes, while `χ₂` does
(`Icosa.chi2_not_factors_through_cycleType`).

`A₅` has irreducible characters of degrees `1, 3, 3, 4, 5` only; it has **no** two-dimensional
character.  The values above are traces of the two-dimensional representation of the *binary*
icosahedral group `2.A₅ ≅ SL₂(𝔽₅)`, evaluated at a chosen lift of an element of each
`A₅`-class: a **projective** character of `A₅`, well defined only up to a sign at each class.
Honesty about this is enforced by `Icosa.pairing_chi2_trivial`, which computes the pairing of
`χ₂` with the trivial character of `A₅` to be `-1/10 ≠ 0`.  The sign choice is not invented:
`Icosa.chi2_realised_by_sl2` proves that the five values are the traces of the explicit
`SL₂(K)` matrices `X = a`, `Y = (√5)⁻¹ • b` of `ArtinA5Even/KleinSigns.lean`, at the elements
`1`, `Y`, `(XY)²`, `-X`, `-X²` (orders `1, 4, 3, 10, 10` in `SL₂`).

**None of these numbers is an `a_p` of a Galois representation**: no Frobenius, no
`L`-function, no automorphic object occurs anywhere in this file.

## 2. Regular product ⇏ regular factors

`F = 1/(X - a)` and `G = X - a` have `F · G = 1`: the product is a unit (in particular a
polynomial, in particular entire), `G` is a polynomial, and `F` is not
(`Holo.exists_ratFunc_factorisation`).  The analytic twin: `F(z) = z⁻¹` and `G(z) = z²` have
`F · G = id` entire with `G` entire, while `F` is not even continuous at `0`
(`Holo.exists_entire_prod`).

The same logic applies verbatim to `L(s, ρ₃) L(s, ρ₃′) = L_M(s, ψ)` versus each factor: the
entirety of the product — which is the classical input, coming from Hecke's theory and class
field theory, and is **not** proved or assumed anywhere here — says nothing about the
individual factors without a further input excluding the cancellation of a pole of one against
a zero of the other.  `Holo.factorisation_does_not_force_holomorphy` states exactly this in the
shape of the `1951` problem: there are three functions satisfying the factorisation identity,
with the product and one factor entire and the other factor not holomorphic on `(0,1)`.

Nothing here constructs a `GL₂(ℂ)` representation, a Tate lift, an Artin or Hecke `L`-function,
or a Maass form; no `Prop` here is a stand-in for a missing Mathlib theory; `ExistsMaass1951`
is untouched, and the entirety of the two-dimensional even Artin `L`-function of conductor
`1951` is neither stated nor proved in Lean.  See `docs/ARTIN_A5_EVEN_1951.md` §8.
-/

namespace ArtinA5Even

namespace Icosa

/-! ## The five conjugacy classes of `A₅` -/

/-- The five conjugacy classes of `A₅`, as an index type: identity, the double
transpositions, the `3`-cycles, and the two classes of `5`-cycles. -/
inductive A5Class where
  /-- The identity class. -/
  | c1 : A5Class
  /-- The class of the double transpositions. -/
  | c2A : A5Class
  /-- The class of the `3`-cycles. -/
  | c3A : A5Class
  /-- The first class of `5`-cycles. -/
  | c5A : A5Class
  /-- The second class of `5`-cycles. -/
  | c5B : A5Class
  deriving DecidableEq, Repr, Fintype

open A5Class

/-- The size of each conjugacy class of `A₅`. -/
def classSize : A5Class → ℕ
  | c1 => 1
  | c2A => 15
  | c3A => 20
  | c5A => 12
  | c5B => 12

theorem sum_classSize : ∑ c : A5Class, classSize c = 60 := by decide

/-- The cycle type of an element of each class, as a partition of `5`.  The two classes of
`5`-cycles carry the *same* label: cycle type does not see the splitting. -/
def cycleTypeLabel : A5Class → Multiset ℕ
  | c1 => {1, 1, 1, 1, 1}
  | c2A => {2, 2, 1}
  | c3A => {3, 1, 1}
  | c5A => {5}
  | c5B => {5}

/-- **Cycle type does not separate `5A` from `5B`.**  (In `S₅` the two classes fuse; they are
distinguished only by conjugacy in `A₅`, equivalently by the square root of the discriminant.)
-/
theorem cycleTypeLabel_c5A_eq_c5B : cycleTypeLabel c5A = cycleTypeLabel c5B := rfl

/-! ## The two two-dimensional characters -/

variable {K : Type*} [Field K]

/-- The two-dimensional icosahedral character with parameter `s` (intended: `s = √5`).  Its
Galois conjugate is `chi2 (-s)`. -/
def chi2 (s : K) : A5Class → K
  | c1 => 2
  | c2A => 0
  | c3A => -1
  | c5A => (1 + s) / 2
  | c5B => (1 - s) / 2

@[simp] theorem chi2_c1 (s : K) : chi2 s c1 = 2 := rfl
@[simp] theorem chi2_c2A (s : K) : chi2 s c2A = 0 := rfl
@[simp] theorem chi2_c3A (s : K) : chi2 s c3A = -1 := rfl
@[simp] theorem chi2_c5A (s : K) : chi2 s c5A = (1 + s) / 2 := rfl
@[simp] theorem chi2_c5B (s : K) : chi2 s c5B = (1 - s) / 2 := rfl

/-- The Galois conjugate character `χ₂′`, obtained by `√5 ↦ -√5`. -/
def chi2' (s : K) : A5Class → K := chi2 (-s)

/-- The involution of the class set exchanging `5A` and `5B`. -/
def swap5 : A5Class → A5Class
  | c1 => c1
  | c2A => c2A
  | c3A => c3A
  | c5A => c5B
  | c5B => c5A

theorem swap5_involutive : ∀ c : A5Class, swap5 (swap5 c) = c := by decide

/-- **Galois conjugation.**  Substituting `-s` for `s` (i.e. `√5 ↦ -√5`) permutes the values
of `χ₂` by the transposition of the two classes of `5`-cycles: the two two-dimensional
characters are Galois conjugate, and differ only at `5A`, `5B`. -/
theorem chi2_neg (s : K) (c : A5Class) : chi2 (-s) c = chi2 s (swap5 c) := by
  cases c <;> simp [chi2, swap5, sub_eq_add_neg]

/-- The same statement for `χ₂′`. -/
theorem chi2'_eq_chi2_swap5 (s : K) (c : A5Class) : chi2' s c = chi2 s (swap5 c) :=
  chi2_neg s c

@[simp] theorem chi2'_c1 (s : K) : chi2' s c1 = 2 := rfl
@[simp] theorem chi2'_c2A (s : K) : chi2' s c2A = 0 := rfl
@[simp] theorem chi2'_c3A (s : K) : chi2' s c3A = -1 := rfl

@[simp] theorem chi2'_c5A (s : K) : chi2' s c5A = (1 - s) / 2 := by
  simp [chi2', chi2, sub_eq_add_neg]

@[simp] theorem chi2'_c5B (s : K) : chi2' s c5B = (1 + s) / 2 := by
  simp [chi2', chi2, sub_eq_add_neg]

/-- Applying the conjugation twice is the identity. -/
theorem chi2_neg_neg (s : K) (c : A5Class) : chi2 (-(-s)) c = chi2 s c := by
  rw [neg_neg]

/-- The values `(4, 0, -2, 1, 1)` of the rational character `χ₂ + χ₂′`. -/
def chi2Sum : A5Class → K
  | c1 => 4
  | c2A => 0
  | c3A => -2
  | c5A => 1
  | c5B => 1

/-- The sum `χ₂ + χ₂′` is rational: it is independent of `s`, with values `(4, 0, -2, 1, 1)`. -/
theorem chi2_add_chi2' (s : K) (h2 : (2 : K) ≠ 0) (c : A5Class) :
    chi2 s c + chi2' s c = chi2Sum c := by
  cases c <;> simp [chi2', chi2, chi2Sum] <;> field_simp <;> ring

/-! ## Orthogonality, with the `A₅` class sizes -/

/-- A sum over the five classes, expanded. -/
theorem sum_A5Class {M : Type*} [AddCommMonoid M] (f : A5Class → M) :
    ∑ c : A5Class, f c = f c1 + f c2A + f c3A + f c5A + f c5B := by
  rw [show (Finset.univ : Finset A5Class) = {c1, c2A, c3A, c5A, c5B} from rfl]
  rw [Finset.sum_insert (by decide), Finset.sum_insert (by decide),
    Finset.sum_insert (by decide), Finset.sum_insert (by decide), Finset.sum_singleton]
  rw [add_assoc, add_assoc, add_assoc]

/-- The class-size weighted pairing of two (real-valued) class functions on the five classes
of `A₅`.  All characters occurring here are real, so no complex conjugation is needed. -/
def pairing (f g : A5Class → K) : K :=
  (∑ c : A5Class, (classSize c : K) * f c * g c) / 60

theorem pairing_eq (f g : A5Class → K) :
    pairing f g =
      (1 * f c1 * g c1 + 15 * f c2A * g c2A + 20 * f c3A * g c3A + 12 * f c5A * g c5A
        + 12 * f c5B * g c5B) / 60 := by
  rw [pairing, sum_A5Class]
  simp only [classSize, Nat.cast_one, Nat.cast_ofNat]

/-- `60 ≠ 0` in a field where `2, 3, 5 ≠ 0`. -/
theorem sixty_ne_zero (h2 : (2 : K) ≠ 0) (h3 : (3 : K) ≠ 0) (h5 : (5 : K) ≠ 0) :
    (60 : K) ≠ 0 := by
  have h : (60 : K) = 2 * (2 * (3 * 5)) := by norm_num
  rw [h]
  exact mul_ne_zero h2 (mul_ne_zero h2 (mul_ne_zero h3 h5))

/-- `10 ≠ 0` in a field where `2, 5 ≠ 0`. -/
theorem ten_ne_zero (h2 : (2 : K) ≠ 0) (h5 : (5 : K) ≠ 0) : (10 : K) ≠ 0 := by
  have h : (10 : K) = 2 * 5 := by norm_num
  rw [h]
  exact mul_ne_zero h2 h5

variable (s : K)

/-- **`⟨χ₂, χ₂⟩ = 1`.**  With `s² = 5`, the two-dimensional character has norm one for the
class-size weighted pairing: it is "irreducible" in the projective sense. -/
theorem pairing_chi2_self (hs : s ^ 2 = 5) (h2 : (2 : K) ≠ 0) (h3 : (3 : K) ≠ 0)
    (h5 : (5 : K) ≠ 0) : pairing (chi2 s) (chi2 s) = 1 := by
  have h60 : (60 : K) ≠ 0 := sixty_ne_zero h2 h3 h5
  rw [pairing_eq]
  simp only [chi2_c1, chi2_c2A, chi2_c3A, chi2_c5A, chi2_c5B]
  field_simp
  linear_combination (24 : K) * hs

/-- **`⟨χ₂, χ₂′⟩ = 0`.**  The character and its Galois conjugate are orthogonal. -/
theorem pairing_chi2_chi2' (hs : s ^ 2 = 5) (h2 : (2 : K) ≠ 0) (h3 : (3 : K) ≠ 0)
    (h5 : (5 : K) ≠ 0) : pairing (chi2 s) (chi2' s) = 0 := by
  have h60 : (60 : K) ≠ 0 := sixty_ne_zero h2 h3 h5
  rw [pairing_eq]
  simp only [chi2_c1, chi2_c2A, chi2_c3A, chi2'_c1, chi2'_c2A, chi2'_c3A, chi2'_c5A, chi2'_c5B,
    chi2_c5A, chi2_c5B]
  field_simp
  linear_combination (-24 : K) * hs

/-- **Honesty check.**  The pairing of `χ₂` with the trivial character of `A₅` is `-1/10`, not
`0`: `χ₂` is a projective character of `A₅`, *not* a character (nor a virtual character) of
`A₅` itself.  It becomes an honest character only on the double cover `2.A₅ ≅ SL₂(𝔽₅)`. -/
theorem pairing_chi2_trivial (h2 : (2 : K) ≠ 0) (h3 : (3 : K) ≠ 0) (h5 : (5 : K) ≠ 0) :
    pairing (chi2 s) (fun _ => 1) = -1 / 10 := by
  have h60 : (60 : K) ≠ 0 := sixty_ne_zero h2 h3 h5
  have h10 : (10 : K) ≠ 0 := ten_ne_zero h2 h5
  rw [pairing_eq]
  simp only [chi2_c1, chi2_c2A, chi2_c3A, chi2_c5A, chi2_c5B]
  field_simp
  ring

/-! ## Cycle type cannot compute `χ₂` -/

/-- **The one-line lemma.**  Since `cycleTypeLabel c5A = cycleTypeLabel c5B` but
`χ₂(5A) ≠ χ₂(5B)` (as soon as `s ≠ 0` and `2 ≠ 0`), the character `χ₂` does **not** factor
through the cycle type: knowing the factorisation type of the quintic modulo `p` determines the
class of Frobenius only up to the pair `{5A, 5B}`, which is exactly the ambiguity that the two
Galois-conjugate characters exchange. -/
theorem chi2_not_factors_through_cycleType (hs : s ≠ 0) (h2 : (2 : K) ≠ 0) :
    ¬ ∃ g : Multiset ℕ → K, ∀ c : A5Class, chi2 s c = g (cycleTypeLabel c) := by
  rintro ⟨g, hg⟩
  have hA : (1 + s) / 2 = g {5} := by simpa using hg c5A
  have hB : (1 - s) / 2 = g {5} := by simpa using hg c5B
  have hAB : (1 + s) / 2 * 2 = (1 - s) / 2 * 2 := by rw [hA, hB]
  rw [div_mul_cancel₀ _ h2, div_mul_cancel₀ _ h2] at hAB
  have h : (2 : K) * s = 0 := by linear_combination hAB
  rcases mul_eq_zero.mp h with h' | h'
  · exact h2 h'
  · exact hs h'

/-! ## Realisation: the five values are traces of the explicit `SL₂(K)` matrices

The matrices `X = a` and `Y = (√5)⁻¹ • b` of `ArtinA5Even/KleinSigns.lean` lie in `SL₂(K)` and
satisfy `X⁵ = I`, `Y² = -I`, `(XY)³ = -I`.  The five listed character values are the traces of
`1`, `Y`, `(XY)²`, `-X`, `-X²`, i.e. of elements of orders `1, 4, 3, 10, 10` in `SL₂(K)` lying
over the five classes of `A₅`.  This fixes the sign choice in `χ₂`. -/

open Matrix KleinSigns Klein

variable (z : K)

/-- For a `2 × 2` matrix, `tr(M²) = (tr M)² - 2 det M`. -/
theorem trace_sq_fin_two (M : Matrix (Fin 2) (Fin 2) K) :
    trace (M * M) = trace M ^ 2 - 2 * M.det := by
  simp [Matrix.trace_fin_two, Matrix.mul_apply, Fin.sum_univ_two, Matrix.det_fin_two]
  ring

theorem trace_genAMat : trace (genAMat z) = z ^ 2 + z ^ 3 := by
  simp [genAMat, Matrix.trace_fin_two]

theorem trace_genBMat : trace (genBMat z) = 0 := by
  simp [genBMat, Matrix.trace_fin_two]

/-- `z² + z³ = -(1 + √5)/2`. -/
theorem two_mul_trace_genAMat (hz5 : z ^ 5 = 1) (hz1 : z ≠ 1) :
    2 * (z ^ 2 + z ^ 3) = -(1 + sqrtFive z) := by
  have hc := Klein.cyclotomic_rel z hz5 hz1
  rw [KleinSigns.sqrtFive]
  linear_combination 2 * hc

/-- `z + z⁴ = (√5 - 1)/2`. -/
theorem two_mul_trace_genAMat_sq :
    2 * (z + z ^ 4) = sqrtFive z - 1 := by
  rw [KleinSigns.sqrtFive]; ring

/-- **`χ₂(1) = 2`** is the trace of the identity. -/
theorem chi2_c1_eq_trace : chi2 (sqrtFive z) c1 = trace (1 : Matrix (Fin 2) (Fin 2) K) := by
  simp [Matrix.trace_one]

/-- **`χ₂(2A) = 0`** is the trace of `Y`, the `SL₂`-lift of Klein's involution (which has
order `4`, since `Y² = -I`). -/
theorem chi2_c2A_eq_trace (hz5 : z ^ 5 = 1) (hz1 : z ≠ 1) :
    chi2 (sqrtFive z) c2A
      = trace ((liftY z hz5 hz1 : SpecialLinearGroup (Fin 2) K) :
          Matrix (Fin 2) (Fin 2) K) := by
  rw [chi2_c2A, val_liftY, Matrix.trace_smul, trace_genBMat, smul_zero]

/-- **`χ₂(5A) = (1+√5)/2`** is the trace of `-X`, an element of order `10` in `SL₂(K)`. -/
theorem chi2_c5A_eq_trace (hz5 : z ^ 5 = 1) (hz1 : z ≠ 1) (h2 : (2 : K) ≠ 0) :
    chi2 (sqrtFive z) c5A = trace (-(genAMat z)) := by
  rw [chi2_c5A, Matrix.trace_neg, trace_genAMat, eq_comm, eq_div_iff h2]
  linear_combination -two_mul_trace_genAMat z hz5 hz1

/-- **`χ₂(5B) = (1-√5)/2`** is the trace of `-X²`, the other element of order `10` over the
second class of `5`-cycles. -/
theorem chi2_c5B_eq_trace (hz5 : z ^ 5 = 1) (h2 : (2 : K) ≠ 0) :
    chi2 (sqrtFive z) c5B = trace (-(genAMat z * genAMat z)) := by
  have hmul : genAMat z * genAMat z = !![z ^ 4, 0; 0, z ^ 6] := by
    rw [genAMat, Matrix.mul_fin_two]
    congr 1
    ring_nf
  rw [chi2_c5B, hmul, Matrix.trace_neg, Matrix.trace_fin_two_of, eq_comm, eq_div_iff h2]
  have h6 : z ^ 6 = z := by
    calc z ^ 6 = z ^ 5 * z := by ring
    _ = z := by rw [hz5, one_mul]
  rw [h6]
  linear_combination -two_mul_trace_genAMat_sq z

/-- **`χ₂(3A) = -1`** is the trace of `(XY)²`, an element of order `3` in `SL₂(K)` (since
`(XY)³ = -I`). -/
theorem chi2_c3A_eq_trace (hz5 : z ^ 5 = 1) (hz1 : z ≠ 1) :
    chi2 (sqrtFive z) c3A
      = trace (((liftX z hz5 * liftY z hz5 hz1) ^ 2 : SpecialLinearGroup (Fin 2) K) :
          Matrix (Fin 2) (Fin 2) K) := by
  have hs := KleinSigns.sqrtFive_ne_zero z hz5 hz1
  have hsq := KleinSigns.sqrtFive_sq' z hz5 hz1
  have hc := Klein.cyclotomic_rel z hz5 hz1
  set M : Matrix (Fin 2) (Fin 2) K :=
    ((liftX z hz5 * liftY z hz5 hz1 : SpecialLinearGroup (Fin 2) K) :
      Matrix (Fin 2) (Fin 2) K) with hM
  have hMval : M = (sqrtFive z)⁻¹ • (genAMat z * genBMat z) := by
    rw [hM]
    show (genAMat z) * ((sqrtFive z)⁻¹ • genBMat z) = _
    rw [Matrix.mul_smul]
  have htrM : trace M = 1 := by
    rw [hMval, Matrix.trace_smul, genAMat, genBMat, Matrix.mul_fin_two, Matrix.trace_fin_two_of]
    rw [smul_eq_mul, inv_mul_eq_one₀ hs, KleinSigns.sqrtFive]
    linear_combination (z ^ 2 - z) * hz5 + hc
  have hdet : M.det = 1 := by
    rw [hM]
    exact (liftX z hz5 * liftY z hz5 hz1).property
  have hsqM : ((liftX z hz5 * liftY z hz5 hz1) ^ 2 : SpecialLinearGroup (Fin 2) K)
      = (M * M : Matrix (Fin 2) (Fin 2) K) := by
    rw [hM, ← Matrix.SpecialLinearGroup.coe_mul, sq]
  rw [hsqM, trace_sq_fin_two, htrM, hdet, chi2_c3A]
  ring

/-- **All five values at once**, as traces of explicit `SL₂(K)` matrices. -/
theorem chi2_realised_by_sl2 (hz5 : z ^ 5 = 1) (hz1 : z ≠ 1) (h2 : (2 : K) ≠ 0) :
    chi2 (sqrtFive z) c1 = trace (1 : Matrix (Fin 2) (Fin 2) K) ∧
    chi2 (sqrtFive z) c2A = trace ((liftY z hz5 hz1 : SpecialLinearGroup (Fin 2) K) :
        Matrix (Fin 2) (Fin 2) K) ∧
    chi2 (sqrtFive z) c3A = trace (((liftX z hz5 * liftY z hz5 hz1) ^ 2 :
        SpecialLinearGroup (Fin 2) K) : Matrix (Fin 2) (Fin 2) K) ∧
    chi2 (sqrtFive z) c5A = trace (-(genAMat z)) ∧
    chi2 (sqrtFive z) c5B = trace (-(genAMat z * genAMat z)) :=
  ⟨chi2_c1_eq_trace z, chi2_c2A_eq_trace z hz5 hz1, chi2_c3A_eq_trace z hz5 hz1,
    chi2_c5A_eq_trace z hz5 hz1 h2, chi2_c5B_eq_trace z hz5 h2⟩

/-! ## Cycle type in `S₅` cannot see the splitting of the `5`-cycles

A `5`-cycle, its inverse and its square all have cycle type `{5}`.  The two `A₅`-classes of
`5`-cycles are exchanged by conjugation by an odd permutation and are *not* distinguished by
cycle type; equivalently, the factorisation type of the quintic modulo an unramified prime
determines the Frobenius class only up to the pair `{5A, 5B}`.  (Which of the two classes a
given `5`-cycle lies in is decided by the square root of the discriminant, not by cycle
type.) -/

/-- An explicit `5`-cycle in `S₅`. -/
def fiveCycle : Equiv.Perm (Fin 5) := c[(0 : Fin 5), 1, 2, 3, 4]

/-- Every power of a `5`-cycle that is again a `5`-cycle has the same cycle type `{5}`: cycle
type does not separate the two `A₅`-classes of `5`-cycles. -/
theorem cycleType_fiveCycle_pow :
    fiveCycle.cycleType = {5} ∧ (fiveCycle⁻¹).cycleType = {5} ∧
      (fiveCycle ^ 2).cycleType = {5} := by
  refine ⟨by decide, ?_, by decide⟩
  rw [Equiv.Perm.cycleType_inv]
  decide

/-- A `5`-cycle and its inverse have the same cycle type — the general statement, for any
permutation of any finite type. -/
theorem cycleType_inv_eq {α : Type*} [Fintype α] [DecidableEq α] (σ : Equiv.Perm α) :
    (σ⁻¹).cycleType = σ.cycleType := Equiv.Perm.cycleType_inv σ

end Icosa

namespace Holo

open Polynomial

/-! ## Algebraic form: a factorisation of `1` in the rational function field

`F = (X - a)⁻¹` and `G = X - a` satisfy `F · G = 1`, a polynomial, while `F` is not a
polynomial.  This is the whole cancellation phenomenon, with no analysis at all. -/

/-- In `RatFunc ℚ`, the inverse of `X - a` is not a polynomial. -/
theorem inv_sub_C_not_polynomial (a : ℚ) :
    ¬ ∃ p : ℚ[X], algebraMap ℚ[X] (RatFunc ℚ) p = (algebraMap ℚ[X] (RatFunc ℚ) (X - C a))⁻¹ := by
  have hne : (X - C a : ℚ[X]) ≠ 0 := X_sub_C_ne_zero a
  have hne' : algebraMap ℚ[X] (RatFunc ℚ) (X - C a) ≠ 0 := by
    simpa using (RatFunc.algebraMap_ne_zero (K := ℚ) hne)
  rintro ⟨p, hp⟩
  have h1 : algebraMap ℚ[X] (RatFunc ℚ) (p * (X - C a)) = 1 := by
    rw [map_mul, hp, inv_mul_cancel₀ hne']
  have h2 : p * (X - C a) = 1 := by
    have := h1
    rw [show (1 : RatFunc ℚ) = algebraMap ℚ[X] (RatFunc ℚ) 1 by simp] at this
    exact RatFunc.algebraMap_injective ℚ this
  have h3 : (p * (X - C a)).eval a = (1 : ℚ[X]).eval a := by rw [h2]
  simp at h3

/-- **The cancellation warning, algebraically.**  There are `F, G` in the rational function
field with `F · G = 1` (a polynomial) and `G` a polynomial, while `F` is *not* a polynomial.
"The product lies in the good class" does not imply "each factor does". -/
theorem exists_ratFunc_factorisation (a : ℚ) :
    ∃ F G : RatFunc ℚ, F * G = 1 ∧
      (∃ q : ℚ[X], algebraMap ℚ[X] (RatFunc ℚ) q = G) ∧
      ¬ ∃ p : ℚ[X], algebraMap ℚ[X] (RatFunc ℚ) p = F := by
  have hne : (X - C a : ℚ[X]) ≠ 0 := X_sub_C_ne_zero a
  have hne' : algebraMap ℚ[X] (RatFunc ℚ) (X - C a) ≠ 0 := by
    simpa using (RatFunc.algebraMap_ne_zero (K := ℚ) hne)
  exact ⟨(algebraMap ℚ[X] (RatFunc ℚ) (X - C a))⁻¹, algebraMap ℚ[X] (RatFunc ℚ) (X - C a),
    inv_mul_cancel₀ hne', ⟨X - C a, rfl⟩, inv_sub_C_not_polynomial a⟩

/-! ## Analytic form: an entire product with a non-continuous factor -/

/-- `z⁻¹` is not continuous at `0` (recall `(0 : ℂ)⁻¹ = 0`, so the function is defined
everywhere; it is simply not continuous there). -/
theorem not_continuousAt_inv_zero : ¬ ContinuousAt (fun z : ℂ => z⁻¹) 0 := by
  intro h
  rw [Metric.continuousAt_iff] at h
  obtain ⟨d, hd, hdd⟩ := h 1 one_pos
  set t : ℝ := min d 1 / 2 with ht
  have ht0 : 0 < t := by positivity
  have htd : t < d := by
    have : min d 1 ≤ d := min_le_left _ _
    simp only [ht]; linarith
  have ht1 : t ≤ 1 / 2 := by
    have : min d 1 ≤ 1 := min_le_right _ _
    simp only [ht]; linarith
  have key := hdd (x := (t : ℂ)) (by simpa [Complex.dist_eq, abs_of_pos ht0] using htd)
  rw [inv_zero, dist_zero_right] at key
  simp only [norm_inv, Complex.norm_real, Real.norm_eq_abs, abs_of_pos ht0] at key
  have h2 : (1 : ℝ) < t⁻¹ := by
    rw [lt_inv_comm₀ one_pos ht0]
    linarith
  linarith

/-- The pointwise identity `z⁻¹ · z² = z`, valid at `z = 0` as well. -/
theorem inv_mul_sq (z : ℂ) : z⁻¹ * z ^ 2 = z := by
  rcases eq_or_ne z 0 with rfl | hz
  · simp
  · field_simp

/-- **The cancellation warning, analytically.**  There are `F, G : ℂ → ℂ` with

* `F · G` entire (it is the identity function),
* `G` entire (it is `z ↦ z²`),
* `F` not continuous — a fortiori not holomorphic — at `0`.

So the entirety of a product carries **no** information about the individual factors without a
further input ruling out a pole of one being cancelled by a zero of the other.  This is exactly
the gap between "`L(ρ₃) L(ρ₃′) = L_M(ψ)` is entire" and "`L(ρ₃)` is holomorphic". -/
theorem exists_entire_prod :
    ∃ F G : ℂ → ℂ, (∀ z, F z * G z = z) ∧ Differentiable ℂ (fun z => F z * G z) ∧
      Differentiable ℂ G ∧ ¬ ContinuousAt F 0 := by
  refine ⟨fun z => z⁻¹, fun z => z ^ 2, inv_mul_sq, ?_, ?_, not_continuousAt_inv_zero⟩
  · simpa only [inv_mul_sq] using differentiable_id
  · exact (differentiable_id.pow 2)

/-- `(z - a)⁻¹` is not continuous at `a`. -/
theorem not_continuousAt_inv_sub (a : ℂ) : ¬ ContinuousAt (fun z : ℂ => (z - a)⁻¹) a := by
  intro h
  refine not_continuousAt_inv_zero ?_
  have h1 : ContinuousAt (fun z : ℂ => z + a) 0 := by fun_prop
  have h2 : ContinuousAt ((fun z : ℂ => (z - a)⁻¹) ∘ fun z : ℂ => z + a) 0 :=
    ContinuousAt.comp (by simpa using h) h1
  have h3 : ((fun z : ℂ => (z - a)⁻¹) ∘ fun z : ℂ => z + a) = fun z : ℂ => z⁻¹ := by
    funext z; simp
  rwa [h3] at h2

/-- The same example, phrased with a pole and a zero at a prescribed point `a`, and with the
product equal to `1` away from `a`. -/
theorem exists_pole_cancelled_by_zero (a : ℂ) :
    ∃ F G : ℂ → ℂ, (∀ z ≠ a, F z * G z = 1) ∧ Differentiable ℂ G ∧
      ¬ ContinuousAt F a := by
  refine ⟨fun z => (z - a)⁻¹, fun z => z - a, ?_, (differentiable_id.sub_const a),
    not_continuousAt_inv_sub a⟩
  intro z hz
  exact inv_mul_cancel₀ (sub_ne_zero.mpr hz)

/-! ## The gap, in the shape of the `1951` problem

The factorisation `L(s, ρ₃) L(s, ρ₃′) = L_M(s, ψ)` coming from the character identity
`χ₃ + χ₃′ = Ind_{D₁₀}^{A₅} ψ`, together with the entirety of the right-hand side (Hecke, class
field theory), does **not** force either factor to be holomorphic.  Since Mathlib has no Artin
or Hecke `L`-functions, the honest Lean statement is about functions satisfying the same
identity: there are such functions with the product and one factor entire and the other factor
not holomorphic on `(0,1)`.  No `Prop` below stands in for a missing theory, and no reduction
"product entire ⇒ factors holomorphic" is asserted: the missing hypothesis is recorded in the
ledger of `docs/ARTIN_A5_EVEN_1951.md` §8d, not encoded here. -/

/-- **The gap.**  There are `L₃, L₃′, L_M : ℂ → ℂ` with

* `L₃ · L₃′ = L_M` pointwise (the shape of the factorisation identity),
* `L_M` entire and `L₃′` entire,
* `L₃` not holomorphic at some point of the real segment `(0,1)`.

Hence the identity plus entirety of the product is strictly weaker than holomorphy of the
factors; an input excluding pole/zero cancellation is indispensable, and is not supplied by the
classical part. -/
theorem factorisation_does_not_force_holomorphy :
    ∃ L3 L3' LM : ℂ → ℂ, (∀ s, L3 s * L3' s = LM s) ∧ Differentiable ℂ LM ∧
      Differentiable ℂ L3' ∧
      ¬ (∀ t : ℝ, t ∈ Set.Ioo (0 : ℝ) 1 → DifferentiableAt ℂ L3 (t : ℂ)) := by
  refine ⟨fun z => (z - 1 / 2)⁻¹, fun z => (z - 1 / 2) ^ 2, fun z => z - 1 / 2,
    fun s => inv_mul_sq (s - 1 / 2), differentiable_id.sub_const _,
    (differentiable_id.sub_const _).pow 2, ?_⟩
  intro h
  have hmem : ((1 : ℝ) / 2) ∈ Set.Ioo (0 : ℝ) 1 := by constructor <;> norm_num
  have hd := h (1 / 2) hmem
  have hcast : (((1 : ℝ) / 2 : ℝ) : ℂ) = 1 / 2 := by push_cast; ring
  rw [hcast] at hd
  exact not_continuousAt_inv_sub (1 / 2) hd.continuousAt

end Holo

end ArtinA5Even
