/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Multiplicities in the decomposition of the representations of `A₅`, computed by
the character inner product.
-/
import RequestProject.Imported.OutputFinal.RequestProject.A5ArtinDecomposition

/-!
# The multiplicity list is a theorem

`RequestProject/A5ArtinDecomposition.lean` records the decomposition of the
permutation representations `π₅, π₆, π₁₂` and of the regular representation of
`A₅` into irreducibles in the single datum `decompose : IRep → List (ℕ × IRep)`,
and derives from it the character, conductor and Euler-factor identities.  That
datum was, however, *asserted*.

This file computes the multiplicities independently, from the character table
and the (proved) class sizes, by the standard inner product

  `⟨χ_R, χ_S⟩ = (1/|A₅|) Σ_c |c| χ_R(c) χ_S(c)`,

and proves that the two agree:

* `mult` — the character inner product `⟨χ_R, χ_S⟩` (a real number);
* `IRep.multiplicity` — the multiplicity of `S` in the list `decompose R`;
* `mult_eq_decompose` — for every irreducible `S`, `⟨χ_R, χ_S⟩` equals that
  multiplicity, so the multiplicity list is a theorem about characters;
* `mult_self_irreducible`, `mult_orthogonal` — the five irreducibles are
  pairwise inequivalent and irreducible (`⟨χ_R, χ_R⟩ = 1`, `⟨χ_R, χ_S⟩ = 0`).
-/

namespace A5Artin

open Cls IRep

/-- The five conjugacy classes form a finite type. -/
instance instFintypeCls : Fintype Cls :=
  ⟨{c1, c2, c3, c5A, c5B}, by intro x; cases x <;> decide⟩

/-- Sums over the five conjugacy classes, written out. -/
theorem sum_Cls (f : Cls → ℝ) : ∑ c, f c = f c1 + f c2 + f c3 + f c5A + f c5B := by
  rw [show (Finset.univ : Finset Cls) = {c1, c2, c3, c5A, c5B} from rfl]
  rw [Finset.sum_insert (by decide), Finset.sum_insert (by decide),
    Finset.sum_insert (by decide), Finset.sum_insert (by decide), Finset.sum_singleton]
  ring

/-- The character inner product `⟨χ_R, χ_S⟩ = (1/60) Σ_c |c| χ_R(c) χ_S(c)`.
(The characters of `A₅` are real, so no complex conjugation is needed.) -/
noncomputable def mult (R S : IRep) : ℝ := (1 / 60) * ∑ c, (classSize c : ℝ) * R.chi c * S.chi c

/-- The multiplicity with which `S` occurs in the recorded decomposition of
`R`. -/
def IRep.multiplicity (R S : IRep) : ℕ :=
  ((decompose R).map fun q => if q.2 = S then q.1 else 0).sum

/-- The five irreducible representations of `A₅` among the members of
`IRep`. -/
def IRep.IsIrr : IRep → Prop
  | r1 | r3 | r3b | r4 | r5 => True
  | _ => False

instance : DecidablePred IRep.IsIrr := fun R => by
  cases R <;> unfold IRep.IsIrr <;> infer_instance

/-- **The multiplicity list is a theorem.**  For every irreducible `S`, the
character inner product `⟨χ_R, χ_S⟩` equals the multiplicity of `S` in the
recorded decomposition of `R`.  In particular the four decompositions

  `π₅ = 1 ⊕ ρ₄`, `π₆ = 1 ⊕ ρ₅`, `π₁₂ = 1 ⊕ ρ₃ ⊕ ρ₃′ ⊕ ρ₅`,
  `ρ_reg = 1 ⊕ 3ρ₃ ⊕ 3ρ₃′ ⊕ 4ρ₄ ⊕ 5ρ₅`

are computed, not asserted. -/
theorem mult_eq_decompose (R S : IRep) (hS : S.IsIrr) :
    mult R S = (R.multiplicity S : ℝ) := by
  have hs := phi_add
  have hm := phi_mul
  have hsq : phi ^ 2 = phi + 1 := Real.goldenRatio_sq
  have hsq' : phi' ^ 2 = phi' + 1 := Real.goldenConj_sq
  cases S
  case perm5 => exact hS.elim
  case perm6 => exact hS.elim
  case perm12 => exact hS.elim
  case reg => exact hS.elim
  all_goals
    cases R <;>
      norm_num [mult, IRep.multiplicity, decompose, sum_Cls, classSize, IRep.chi, chi1, chi3,
        chi3b, chi4, chi5, chiPerm5, chiPerm6, chiPerm12, chiReg] <;>
      nlinarith [hs, hm, hsq, hsq']

/-- Each of the five listed irreducibles really is irreducible:
`⟨χ_R, χ_R⟩ = 1`. -/
theorem mult_self_irreducible (R : IRep) (hR : R.IsIrr) : mult R R = 1 := by
  rw [mult_eq_decompose R R hR]
  cases R <;> first
    | exact hR.elim
    | norm_num [IRep.multiplicity, decompose]

/-- The five listed irreducibles are pairwise inequivalent: `⟨χ_R, χ_S⟩ = 0`
for `R ≠ S`. -/
theorem mult_orthogonal (R S : IRep) (hR : R.IsIrr) (hS : S.IsIrr) (hRS : R ≠ S) :
    mult R S = 0 := by
  rw [mult_eq_decompose R S hS]
  cases R <;> cases S <;> first
    | exact hR.elim
    | exact hS.elim
    | exact absurd rfl hRS
    | norm_num [IRep.multiplicity, decompose]

/-- The multiplicity of the trivial representation in each permutation
representation is `1`: all three permutation actions are transitive. -/
theorem mult_r1_perm :
    mult perm5 r1 = 1 ∧ mult perm6 r1 = 1 ∧ mult perm12 r1 = 1 := by
  refine ⟨?_, ?_, ?_⟩ <;>
    · rw [mult_eq_decompose _ r1 trivial]
      norm_num [IRep.multiplicity, decompose]

end A5Artin
