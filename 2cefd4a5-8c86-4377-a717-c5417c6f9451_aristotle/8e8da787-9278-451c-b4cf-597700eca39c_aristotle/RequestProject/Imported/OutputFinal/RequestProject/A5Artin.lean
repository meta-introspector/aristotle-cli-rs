/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Artin L-functions of even A5 representations: the representation-theoretic
backbone of the numerical work in `scripts/a5` and `docs/A5_even_Artin.md`.
-/
import Mathlib

/-!
# Local Artin factorisation for `A₅`

Let `N/ℚ` be Galois with `Gal(N/ℚ) ≃ A₅`, let `K` be the quintic subfield fixed
by a point stabiliser `A₄`, let `K₆` be the sextic field fixed by a dihedral
group of order 10, and let `K₁₂` be the field fixed by a Sylow 5-subgroup.
`A₅` has five irreducible complex representations, of dimensions `1, 3, 3, 4, 5`;
we write `ρ₃, ρ₃'` for the two three dimensional ones (they are conjugate over
`ℚ(√5)`), `ρ₄` for the standard representation inside the permutation
representation on 5 points, and `ρ₅` for the five dimensional one.

Everything about the *Euler factors* of the associated Artin L-functions at a
prime `p` unramified in `N` is a function of the conjugacy class of `Frob_p`.
`A₅` has five classes: the identity, the class of `(1 2)(3 4)`, the class of
`(1 2 3)`, and the two classes `5A`, `5B` of 5-cycles.  For each class we write
down the local polynomials `det(1 - ρ(Frob) T)` explicitly and prove the four
identities that the numerical computation relies on:

* `permPoly5 = (1 - T) * E4`  — i.e. `ζ_K(s) = ζ(s) · L(ρ₄, s)`;
* `permPoly6 = (1 - T) * E5`  — i.e. `ζ_{K₆}(s) = ζ(s) · L(ρ₅, s)`;
* `permPoly12 = (1 - T) * (E3 * E3') * E5` — i.e.
  `ζ_{K₁₂}(s) = ζ(s) L(ρ₃,s) L(ρ₃',s) L(ρ₅,s)`;
* `regPoly = (1 - T) * (E3 * E3')^3 * E4^4 * E5^5` — i.e.
  `ζ_N(s) = ζ(s) L(ρ₃,s)³ L(ρ₃',s)³ L(ρ₄,s)⁴ L(ρ₅,s)⁵`.

The product `E3 * E3'` has rational coefficients (`E3E3'` below) even though the
two factors separately involve `√5`; this is proved in `E3_mul_E3b`.

The identities are stated over an arbitrary commutative ring, i.e. as identities
of polynomials in the variable `T`.
-/

namespace A5Artin

/-- The five conjugacy classes of `A₅`. -/
inductive Cls
  | c1     -- identity
  | c2     -- (1 2)(3 4)
  | c3     -- (1 2 3)
  | c5A    -- the class of (1 2 3 4 5)
  | c5B    -- the class of (1 3 5 2 4)
  deriving DecidableEq, Repr

open Cls

/-- The order of an element in each class. -/
def ord : Cls → ℕ
  | c1 => 1 | c2 => 2 | c3 => 3 | c5A => 5 | c5B => 5

/-- The size of each conjugacy class. -/
def classSize : Cls → ℕ
  | c1 => 1 | c2 => 15 | c3 => 20 | c5A => 12 | c5B => 12

section EulerFactors

variable {R : Type*} [CommRing R]

/-- `det(1 - Frob T)` on the 5-point permutation representation:
the product of `1 - T ^ (cycle length)`. -/
def permPoly5 : Cls → R → R
  | c1, T => (1 - T) ^ 5
  | c2, T => (1 - T ^ 2) ^ 2 * (1 - T)
  | c3, T => (1 - T ^ 3) * (1 - T) ^ 2
  | c5A, T => 1 - T ^ 5
  | c5B, T => 1 - T ^ 5

/-- `det(1 - Frob T)` on the 6-point permutation representation
(`A₅ ≃ PSL₂(𝔽₅)` acting on `ℙ¹(𝔽₅)`). -/
def permPoly6 : Cls → R → R
  | c1, T => (1 - T) ^ 6
  | c2, T => (1 - T ^ 2) ^ 2 * (1 - T) ^ 2
  | c3, T => (1 - T ^ 3) ^ 2
  | c5A, T => (1 - T ^ 5) * (1 - T)
  | c5B, T => (1 - T ^ 5) * (1 - T)

/-- `det(1 - Frob T)` on the 12-point permutation representation
(cosets of a Sylow 5-subgroup). -/
def permPoly12 : Cls → R → R
  | c1, T => (1 - T) ^ 12
  | c2, T => (1 - T ^ 2) ^ 6
  | c3, T => (1 - T ^ 3) ^ 4
  | c5A, T => (1 - T ^ 5) ^ 2 * (1 - T) ^ 2
  | c5B, T => (1 - T ^ 5) ^ 2 * (1 - T) ^ 2

/-- `det(1 - Frob T)` on the regular representation: `(1 - T^ord)^(60/ord)`. -/
def regPoly : Cls → R → R
  | c1, T => (1 - T) ^ 60
  | c2, T => (1 - T ^ 2) ^ 30
  | c3, T => (1 - T ^ 3) ^ 20
  | c5A, T => (1 - T ^ 5) ^ 12
  | c5B, T => (1 - T ^ 5) ^ 12

/-- Local factor of the standard 4-dimensional representation. -/
def E4 : Cls → R → R
  | c1, T => (1 - T) ^ 4
  | c2, T => (1 - T ^ 2) ^ 2
  | c3, T => (1 - T ^ 3) * (1 - T)
  | c5A, T => 1 + T + T ^ 2 + T ^ 3 + T ^ 4
  | c5B, T => 1 + T + T ^ 2 + T ^ 3 + T ^ 4

/-- Local factor of the 5-dimensional representation. -/
def E5 : Cls → R → R
  | c1, T => (1 - T) ^ 5
  | c2, T => (1 - T ^ 2) ^ 2 * (1 - T)
  | c3, T => (1 - T) * (1 + T + T ^ 2) ^ 2
  | c5A, T => 1 - T ^ 5
  | c5B, T => 1 - T ^ 5

/-- The product of the local factors of the two 3-dimensional representations.
It has rational (indeed integral) coefficients; see `E3_mul_E3b`. -/
def E3E3b : Cls → R → R
  | c1, T => (1 - T) ^ 6
  | c2, T => (1 - T) ^ 2 * (1 + T) ^ 4
  | c3, T => (1 - T ^ 3) ^ 2
  | c5A, T => (1 - T) ^ 2 * (1 + T + T ^ 2 + T ^ 3 + T ^ 4)
  | c5B, T => (1 - T) ^ 2 * (1 + T + T ^ 2 + T ^ 3 + T ^ 4)

/-- `ζ_K = ζ · L(ρ₄)`, locally at every unramified prime. -/
theorem permPoly5_eq (c : Cls) (T : R) : permPoly5 c T = (1 - T) * E4 c T := by
  cases c <;> simp [permPoly5, E4] <;> ring

/-- `ζ_{K₆} = ζ · L(ρ₅)`, locally at every unramified prime. -/
theorem permPoly6_eq (c : Cls) (T : R) : permPoly6 c T = (1 - T) * E5 c T := by
  cases c <;> simp [permPoly6, E5] <;> ring

/-- `ζ_{K₁₂} = ζ · L(ρ₃) · L(ρ₃') · L(ρ₅)`, locally at every unramified prime. -/
theorem permPoly12_eq (c : Cls) (T : R) :
    permPoly12 c T = (1 - T) * E3E3b c T * E5 c T := by
  cases c <;> simp [permPoly12, E3E3b, E5] <;> ring

/-- `ζ_N = ζ · L(ρ₃)³ L(ρ₃')³ L(ρ₄)⁴ L(ρ₅)⁵`, locally at every unramified
prime: the Artin factorisation of the Dedekind zeta function of the Galois
closure. -/
theorem regPoly_eq (c : Cls) (T : R) :
    regPoly c T = (1 - T) * (E3E3b c T) ^ 3 * (E4 c T) ^ 4 * (E5 c T) ^ 5 := by
  cases c <;> simp [regPoly, E3E3b, E4, E5] <;> ring

end EulerFactors

section Characters

open Real

/-- `φ = (1 + √5)/2 = χ₃(5A)` is Mathlib's golden ratio. -/
noncomputable abbrev phi : ℝ := Real.goldenRatio

/-- `ψ = (1 - √5)/2 = χ₃(5B)`. -/
noncomputable abbrev phi' : ℝ := Real.goldenConj

lemma phi_add : phi + phi' = 1 := Real.goldenRatio_add_goldenConj

lemma phi_mul : phi * phi' = -1 := Real.goldenRatio_mul_goldenConj

/-! ### The character table of `A₅` -/

noncomputable def chi1 : Cls → ℝ := fun _ => 1

noncomputable def chi3 : Cls → ℝ
  | c1 => 3 | c2 => -1 | c3 => 0 | c5A => phi | c5B => phi'

noncomputable def chi3b : Cls → ℝ
  | c1 => 3 | c2 => -1 | c3 => 0 | c5A => phi' | c5B => phi

noncomputable def chi4 : Cls → ℝ
  | c1 => 4 | c2 => 0 | c3 => 1 | c5A => -1 | c5B => -1

noncomputable def chi5 : Cls → ℝ
  | c1 => 5 | c2 => 1 | c3 => -1 | c5A => 0 | c5B => 0

/-- Local factor of the 3-dimensional representation `ρ₃`. -/
noncomputable def E3 : Cls → ℝ → ℝ
  | c1, T => (1 - T) ^ 3
  | c2, T => (1 - T) * (1 + T) ^ 2
  | c3, T => 1 - T ^ 3
  | c5A, T => 1 - phi * T + phi * T ^ 2 - T ^ 3
  | c5B, T => 1 - phi' * T + phi' * T ^ 2 - T ^ 3

/-- Local factor of the conjugate 3-dimensional representation `ρ₃'`. -/
noncomputable def E3b : Cls → ℝ → ℝ
  | c1, T => (1 - T) ^ 3
  | c2, T => (1 - T) * (1 + T) ^ 2
  | c3, T => 1 - T ^ 3
  | c5A, T => 1 - phi' * T + phi' * T ^ 2 - T ^ 3
  | c5B, T => 1 - phi * T + phi * T ^ 2 - T ^ 3

/-- The local factor of `ρ₃` is determined by its character:
`det(1 - ρ₃(g)T) = 1 - χ₃(g) T + χ₃(g) T² - T³`
(the two middle coefficients agree because `ρ₃` is self-dual with
determinant 1). -/
theorem E3_eq_char (c : Cls) (T : ℝ) :
    E3 c T = 1 - chi3 c * T + chi3 c * T ^ 2 - T ^ 3 := by
  cases c <;> simp only [E3, chi3] <;> ring

theorem E3b_eq_char (c : Cls) (T : ℝ) :
    E3b c T = 1 - chi3b c * T + chi3b c * T ^ 2 - T ^ 3 := by
  cases c <;> simp only [E3b, chi3b] <;> ring

/-- The two 3-dimensional local factors are conjugate over `ℚ(√5)`, and their
product `E3E3b` is rational. -/
theorem E3_mul_E3b (c : Cls) (T : ℝ) : E3 c T * E3b c T = E3E3b c T := by
  have hs := phi_add
  have hm := phi_mul
  cases c
  · simp only [E3, E3b, E3E3b]; ring
  · simp only [E3, E3b, E3E3b]; ring
  · simp only [E3, E3b, E3E3b]; ring
  · simp only [E3, E3b, E3E3b]
    linear_combination (-T + T ^ 2 + T ^ 4 - T ^ 5) * hs + (T ^ 2 - 2 * T ^ 3 + T ^ 4) * hm
  · simp only [E3, E3b, E3E3b]
    linear_combination (-T + T ^ 2 + T ^ 4 - T ^ 5) * hs + (T ^ 2 - 2 * T ^ 3 + T ^ 4) * hm

/-- Row orthogonality for `χ₃`: `Σ_c |c| χ₃(c)² = 60 = |A₅|`, so `ρ₃` is
irreducible. -/
theorem chi3_norm :
    (classSize c1 : ℝ) * chi3 c1 ^ 2 + classSize c2 * chi3 c2 ^ 2 +
      classSize c3 * chi3 c3 ^ 2 + classSize c5A * chi3 c5A ^ 2 +
      classSize c5B * chi3 c5B ^ 2 = 60 := by
  have hs := phi_add
  have hm := phi_mul
  simp only [classSize, chi3, Nat.cast_ofNat, Nat.cast_one]
  linear_combination (12 * phi + 12 * phi' + 12) * hs - 24 * hm

/-- `χ₃` and `χ₃'` are orthogonal, so `ρ₃` and `ρ₃'` are not isomorphic. -/
theorem chi3_chi3b_orthogonal :
    (classSize c1 : ℝ) * chi3 c1 * chi3b c1 + classSize c2 * chi3 c2 * chi3b c2 +
      classSize c3 * chi3 c3 * chi3b c3 + classSize c5A * chi3 c5A * chi3b c5A +
      classSize c5B * chi3 c5B * chi3b c5B = 0 := by
  have hm := phi_mul
  simp only [classSize, chi3, chi3b, Nat.cast_ofNat, Nat.cast_one]
  linear_combination 24 * hm

/-- `χ₄` and `χ₅` are orthogonal. -/
theorem chi4_chi5_orthogonal :
    (classSize c1 : ℝ) * chi4 c1 * chi5 c1 + classSize c2 * chi4 c2 * chi5 c2 +
      classSize c3 * chi4 c3 * chi5 c3 + classSize c5A * chi4 c5A * chi5 c5A +
      classSize c5B * chi4 c5B * chi5 c5B = 0 := by
  simp only [classSize, chi4, chi5, Nat.cast_ofNat, Nat.cast_one]
  norm_num

/-- Row orthogonality for `χ₅`. -/
theorem chi5_norm :
    (classSize c1 : ℝ) * chi5 c1 ^ 2 + classSize c2 * chi5 c2 ^ 2 +
      classSize c3 * chi5 c3 ^ 2 + classSize c5A * chi5 c5A ^ 2 +
      classSize c5B * chi5 c5B ^ 2 = 60 := by
  simp only [classSize, chi5, Nat.cast_ofNat, Nat.cast_one]
  norm_num

/-- Row orthogonality for `χ₄`. -/
theorem chi4_norm :
    (classSize c1 : ℝ) * chi4 c1 ^ 2 + classSize c2 * chi4 c2 ^ 2 +
      classSize c3 * chi4 c3 ^ 2 + classSize c5A * chi4 c5A ^ 2 +
      classSize c5B * chi4 c5B ^ 2 = 60 := by
  simp only [classSize, chi4, Nat.cast_ofNat, Nat.cast_one]
  norm_num

/-- The dimensions satisfy `1² + 3² + 3² + 4² + 5² = 60 = |A₅|`. -/
theorem sum_dim_sq : 1 ^ 2 + 3 ^ 2 + 3 ^ 2 + 4 ^ 2 + 5 ^ 2 = 60 := by norm_num

end Characters

/-!
## Total reality of two explicit defining polynomials

The numerical work uses a table of totally real quintic fields whose Galois
closure has group `A₅`.  Here we prove, for the two fields that carry the bulk
of the numerical evidence, that the defining polynomial really does have five
distinct real roots — i.e. that the quintic field is totally real, so that the
Artin representations attached to it are *even*.

* `f₁ = X⁵ + X⁴ - 11X³ - X² + 12X + 4` defines the field of discriminant
  `3104644 = 2²·881²`, the smallest totally real `A₅` quintic field found by the
  Hunter-bound search;
* `f₂ = X⁵ + X⁴ - 15X³ - 36X² - 21X - 1` defines the field of discriminant
  `30991489 = 5567²`, the smallest one for which all four nontrivial Artin
  L-functions — including the five dimensional one — are numerically accessible.
-/

section TotallyReal

open Set

/-- Sign change from `-` to `+` produces a root. -/
private lemma root_neg_pos {f : ℝ → ℝ} (hf : Continuous f) {a b : ℝ} (hab : a ≤ b)
    (h1 : f a < 0) (h2 : 0 < f b) : ∃ x ∈ Ioo a b, f x = 0 := by
  obtain ⟨x, hx, hx0⟩ := intermediate_value_Ioo hab hf.continuousOn
    (mem_Ioo.2 ⟨h1, h2⟩)
  exact ⟨x, hx, hx0⟩

/-- Sign change from `+` to `-` produces a root. -/
private lemma root_pos_neg {f : ℝ → ℝ} (hf : Continuous f) {a b : ℝ} (hab : a ≤ b)
    (h1 : 0 < f a) (h2 : f b < 0) : ∃ x ∈ Ioo a b, f x = 0 := by
  obtain ⟨x, hx, hx0⟩ := intermediate_value_Ioo' hab hf.continuousOn
    (mem_Ioo.2 ⟨h2, h1⟩)
  exact ⟨x, hx, hx0⟩

/-- Defining polynomial of the totally real `A₅` quintic field of discriminant
`3104644`. -/
noncomputable def f₁ : ℝ → ℝ := fun x => x ^ 5 + x ^ 4 - 11 * x ^ 3 - x ^ 2 + 12 * x + 4

/-- Defining polynomial of the totally real `A₅` quintic field of discriminant
`30991489`. -/
noncomputable def f₂ : ℝ → ℝ := fun x => x ^ 5 + x ^ 4 - 15 * x ^ 3 - 36 * x ^ 2 - 21 * x - 1

private lemma cont_f₁ : Continuous f₁ := by unfold f₁; fun_prop

private lemma cont_f₂ : Continuous f₂ := by unfold f₂; fun_prop

/-- `X⁵ + X⁴ - 11X³ - X² + 12X + 4` has five distinct real roots, so the quintic
field it defines is totally real. -/
theorem f₁_totally_real :
    ∃ r₁ r₂ r₃ r₄ r₅ : ℝ,
      r₁ < r₂ ∧ r₂ < r₃ ∧ r₃ < r₄ ∧ r₄ < r₅ ∧
      f₁ r₁ = 0 ∧ f₁ r₂ = 0 ∧ f₁ r₃ = 0 ∧ f₁ r₄ = 0 ∧ f₁ r₅ = 0 := by
  obtain ⟨r₁, h₁, e₁⟩ : ∃ x ∈ Ioo (-4 : ℝ) (-3), f₁ x = 0 := by
    apply root_neg_pos cont_f₁ (by norm_num) <;> · simp only [f₁]; norm_num
  obtain ⟨r₂, h₂, e₂⟩ : ∃ x ∈ Ioo (-(9 : ℝ) / 10) (-(7 : ℝ) / 10), f₁ x = 0 := by
    apply root_pos_neg cont_f₁ (by norm_num) <;> · simp only [f₁]; norm_num
  obtain ⟨r₃, h₃, e₃⟩ : ∃ x ∈ Ioo (-(2 : ℝ) / 5) (-(3 : ℝ) / 10), f₁ x = 0 := by
    apply root_neg_pos cont_f₁ (by norm_num) <;> · simp only [f₁]; norm_num
  obtain ⟨r₄, h₄, e₄⟩ : ∃ x ∈ Ioo (1 : ℝ) 2, f₁ x = 0 := by
    apply root_pos_neg cont_f₁ (by norm_num) <;> · simp only [f₁]; norm_num
  obtain ⟨r₅, h₅, e₅⟩ : ∃ x ∈ Ioo (2 : ℝ) 3, f₁ x = 0 := by
    apply root_neg_pos cont_f₁ (by norm_num) <;> · simp only [f₁]; norm_num
  refine ⟨r₁, r₂, r₃, r₄, r₅, ?_, ?_, ?_, ?_, e₁, e₂, e₃, e₄, e₅⟩
  · exact h₁.2.trans (by linarith [h₂.1])
  · exact h₂.2.trans (by linarith [h₃.1])
  · exact h₃.2.trans (by linarith [h₄.1])
  · exact h₄.2.trans (by linarith [h₅.1])

/-- `X⁵ + X⁴ - 15X³ - 36X² - 21X - 1` has five distinct real roots, so the
quintic field it defines is totally real. -/
theorem f₂_totally_real :
    ∃ r₁ r₂ r₃ r₄ r₅ : ℝ,
      r₁ < r₂ ∧ r₂ < r₃ ∧ r₃ < r₄ ∧ r₄ < r₅ ∧
      f₂ r₁ = 0 ∧ f₂ r₂ = 0 ∧ f₂ r₃ = 0 ∧ f₂ r₄ = 0 ∧ f₂ r₅ = 0 := by
  obtain ⟨r₁, h₁, e₁⟩ : ∃ x ∈ Ioo (-3 : ℝ) (-2), f₂ x = 0 := by
    apply root_neg_pos cont_f₂ (by norm_num) <;> · simp only [f₂]; norm_num
  obtain ⟨r₂, h₂, e₂⟩ : ∃ x ∈ Ioo (-2 : ℝ) (-1), f₂ x = 0 := by
    apply root_pos_neg cont_f₂ (by norm_num) <;> · simp only [f₂]; norm_num
  obtain ⟨r₃, h₃, e₃⟩ : ∃ x ∈ Ioo (-1 : ℝ) (-(1 : ℝ) / 2), f₂ x = 0 := by
    apply root_neg_pos cont_f₂ (by norm_num) <;> · simp only [f₂]; norm_num
  obtain ⟨r₄, h₄, e₄⟩ : ∃ x ∈ Ioo (-(1 : ℝ) / 10) (-(1 : ℝ) / 20), f₂ x = 0 := by
    apply root_pos_neg cont_f₂ (by norm_num) <;> · simp only [f₂]; norm_num
  obtain ⟨r₅, h₅, e₅⟩ : ∃ x ∈ Ioo (4 : ℝ) 5, f₂ x = 0 := by
    apply root_neg_pos cont_f₂ (by norm_num) <;> · simp only [f₂]; norm_num
  refine ⟨r₁, r₂, r₃, r₄, r₅, ?_, ?_, ?_, ?_, e₁, e₂, e₃, e₄, e₅⟩
  · exact h₁.2.trans_le (by linarith [h₂.1])
  · exact h₂.2.trans (by linarith [h₃.1])
  · exact h₃.2.trans (by linarith [h₄.1])
  · exact h₄.2.trans (by linarith [h₅.1])

end TotallyReal

end A5Artin
