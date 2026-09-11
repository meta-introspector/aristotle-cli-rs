import Mathlib
import RequestProject.Imported.EisensteinAlgebra.EisensteinIntegers_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinTheta_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinThetaBridge_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinUnits_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinOrbit_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinPrimeSplit_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinPrimeSplitHard_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinEuclidean_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinAlgebra_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinIdealCount_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinDivSum_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinExtensions_Root

/-!
# The 𝔽₃ quotient of the Eisenstein integers

This file proves `Eisenstein ⧸ (θ) ≅ 𝔽₃`, where `θ = 1 - ω`. This complements
the `Eisenstein ⧸ (2) ≅ 𝔽₄` result already in `EisensteinExtensions.lean`.

The two quotients arise from the two non-split rational primes:

* `p = 2` is inert in `Eisenstein`: `(2)` remains prime, with `N(2) = 4`.
  Quotient `Eisenstein/(2) = 𝔽₄`.

* `p = 3` is ramified: `(3) = (θ)²` where `θ = 1 - ω`. The prime ideal above 3
  is `(θ)`, with `N(θ) = 3`. Quotient `Eisenstein/(θ) = 𝔽₃`.

The ramification fact `ramified_three : ∃ z, norm z = 3` is in
`EisensteinPrimeSplit.lean` (Piece 4a). Here we package the corresponding
field quotient.

## Why this matters

The field `Eisenstein/(θ) ≅ 𝔽₃` is the natural finite field for several
constructions in lattice theory — notably, the Coxeter-Todd lattice `K₁₂` is
defined via a code over `𝔽₃` lifted to `Eisenstein^6`. This file is the
foundational step toward any such construction, though the construction
itself is a separate, much larger piece of work.

## What this file does NOT claim

This file establishes a single algebraic fact: a quotient ring is a field of
order 3. It does NOT establish any connection to `K₁₂`, Λ₂₄, modular forms,
or RH. Those are separate (much larger) projects.

## Strategy

Following the pattern Aristotle established for `Eisenstein/(2) ≅ 𝔽₄`:

1. Compute `Ideal.absNorm (Ideal.span {θ}) = 3` via our existing
   `absNorm_span_singleton` bridge + `norm_θ = 3`.
2. Derive `Fintype.card (Eisenstein/(θ)) = 3` via `Submodule.cardQuot`.
3. Show `θ` is irreducible (factoring `θ = a*b` gives `norm a · norm b = 3`,
   so one factor is a unit).
4. In a PID, irreducible ⟹ prime ideal ⟹ maximal ideal (in a Dedekind domain).
5. Quotient by a maximal ideal is a field.
-/

noncomputable section

open scoped Classical
open EisensteinUnits

namespace Eisenstein

/-! ## The ideal `(θ)` -/

/-- The ideal `(θ) = (1 - ω)` in `Eisenstein`. -/
def idealTheta : Ideal Eisenstein := Ideal.span {θ}

/-- The ideal `(θ)` is nonzero. -/
theorem idealTheta_ne_bot : idealTheta ≠ ⊥ := by
  intro h
  rw [idealTheta, Ideal.span_singleton_eq_bot] at h
  have hnorm : norm θ = 3 := norm_θ
  rw [h, norm_zero] at hnorm
  norm_num at hnorm

/-- The absolute norm of `(θ)` is 3. -/
theorem absNorm_idealTheta : Ideal.absNorm idealTheta = 3 := by
  unfold idealTheta
  rw [Eisenstein.absNorm_span_singleton]
  rw [norm_θ]
  rfl

/-! ## Cardinality and finiteness of the quotient -/

/-- The quotient `Eisenstein ⧸ (θ)` is finite. -/
instance : Finite (Eisenstein ⧸ idealTheta) := by
  rw [← Ideal.absNorm_ne_zero_iff]
  rw [absNorm_idealTheta]
  norm_num

/-- The quotient `Eisenstein ⧸ (θ)` has a `Fintype` instance. -/
instance : Fintype (Eisenstein ⧸ idealTheta) := Fintype.ofFinite _

/-
The quotient `Eisenstein ⧸ (θ)` has exactly 3 elements.
-/
theorem quotient_theta_card :
    Fintype.card (Eisenstein ⧸ idealTheta) = 3 := by
  convert Nat.card_eq_fintype_card;
  rotate_left;
  convert Nat.card_eq_fintype_card.symm;
  convert absNorm_idealTheta.symm;
  any_goals exact Eisenstein ⧸ idealTheta;
  all_goals try infer_instance;
  · convert Nat.card_eq_fintype_card.symm;
  · rw [ Nat.card_eq_fintype_card ];
  · rw [ Nat.card_eq_fintype_card ]

/-! ## Maximality of `(θ)` and field structure -/

/-
`θ` is irreducible in `Eisenstein`. Proof: if `θ = a · b`, then
`norm a · norm b = norm θ = 3`. Since `3` is prime in `ℕ`, one of `norm a` or
`norm b` equals 1, so the corresponding element is a unit.
-/
theorem theta_irreducible : Irreducible θ := by
  constructor;
  · exact fun h => by have := norm_eq_one_of_isUnit θ h; simp_all +decide ;
  · intros a b hab
    have h_norm : norm a * norm b = 3 := by
      rw [ ← Eisenstein.norm_mul, ← hab, Eisenstein.norm_θ ];
    have h_cases : norm a = 1 ∨ norm b = 1 := by
      have h_cases : norm a ∣ 3 ∧ norm b ∣ 3 := by
        exact ⟨ h_norm ▸ dvd_mul_right _ _, h_norm ▸ dvd_mul_left _ _ ⟩;
      have : a.norm ≤ 3 := Int.le_of_dvd ( by decide ) h_cases.1; ( have : b.norm ≤ 3 := Int.le_of_dvd ( by decide ) h_cases.2; ( have : a.norm ≥ 0 := Eisenstein.norm_nonneg a; ( have : b.norm ≥ 0 := Eisenstein.norm_nonneg b; interval_cases a.norm <;> interval_cases b.norm <;> trivial; ) ) );
    exact Or.imp ( fun h => Eisenstein.isUnit_of_norm_one a h ) ( fun h => Eisenstein.isUnit_of_norm_one b h ) h_cases

/-- The ideal `(θ)` is maximal. In `Eisenstein` (a PID), the ideal generated by
an irreducible element is maximal. -/
theorem idealTheta_isMaximal : idealTheta.IsMaximal := by
  unfold idealTheta
  exact PrincipalIdealRing.isMaximal_of_irreducible theta_irreducible

/-- The quotient `Eisenstein ⧸ (θ)` is a field of order 3. -/
instance : Field (Eisenstein ⧸ idealTheta) :=
  haveI := idealTheta_isMaximal
  Ideal.Quotient.field idealTheta

end Eisenstein