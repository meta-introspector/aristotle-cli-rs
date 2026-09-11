/-
Original to this repository (not part of the upstream ZetaZeros development).
-/

import RequestProject.Experiments.ErrorFunction

/-! # The complexity lattice of candidate faces

The dashboard plots the sixteen coordinate faces of the candidate parameter space — which of
`a`, `b`, `c`, `d` are allowed to be nonzero — against the smallest error attainable on each. This
file states and proves what that picture is claiming.

* `Candidate.OnFace p S` — the coefficients of `p` outside `S` vanish.
* `faceError` — the infimum of the total error over a face.
* `faceError_anti` — a larger face fits at least as well: the lattice plot slopes downwards, and
  it does so for a trivial reason, not a mathematical one.
* `exists_admissible_onFace_iff` — a face contains an admissible candidate exactly when it
  contains the leading coefficient. Fitting error can be driven down on any face; asymptotic
  correctness is available only on the eight faces containing `a`.
-/

open Filter Topology

namespace ZetaZeros.Experiments

namespace Candidate

/-- The coefficients of a candidate, indexed by `Fin 4` in the order `a, b, c, d`. -/
def coeff (p : Candidate) (i : Fin 4) : ℝ :=
  if i = 0 then p.a else if i = 1 then p.b else if i = 2 then p.c else p.d

@[simp] lemma coeff_zero (p : Candidate) : p.coeff 0 = p.a := rfl
@[simp] lemma coeff_one (p : Candidate) : p.coeff 1 = p.b := rfl
@[simp] lemma coeff_two (p : Candidate) : p.coeff 2 = p.c := rfl
@[simp] lemma coeff_three (p : Candidate) : p.coeff 3 = p.d := rfl

/-- `p` lies on the face `S`: every coefficient outside `S` is zero. -/
def OnFace (p : Candidate) (S : Set (Fin 4)) : Prop := ∀ i ∉ S, p.coeff i = 0

lemma OnFace.mono {p : Candidate} {S S' : Set (Fin 4)} (h : p.OnFace S) (hS : S ⊆ S') :
    p.OnFace S' := fun i hi => h i fun hiS => hi (hS hiS)

/-- The zero candidate lies on every face. -/
lemma onFace_zero (S : Set (Fin 4)) : (Candidate.mk 0 0 0 0).OnFace S := by
  intro i _
  fin_cases i <;> rfl

lemma errAlpha_nonneg (p : Candidate) (N : ℝ → ℝ) (alpha T : ℝ) : 0 ≤ p.errAlpha N alpha T := by
  have h : (0 : ℝ) < max 1 |p.eval T| ^ alpha :=
    Real.rpow_pos_of_pos (lt_of_lt_of_le one_pos (le_max_left _ _)) _
  exact div_nonneg (abs_nonneg _) h.le

end Candidate

/-- The total error of a candidate over a finite set of sample heights: the quantity the
dashboard's fits minimise. -/
noncomputable def totalError (p : Candidate) (N : ℝ → ℝ) (alpha : ℝ) (ts : Finset ℝ) : ℝ :=
  ∑ T ∈ ts, p.errAlpha N alpha T

lemma totalError_nonneg (p : Candidate) (N : ℝ → ℝ) (alpha : ℝ) (ts : Finset ℝ) :
    0 ≤ totalError p N alpha ts :=
  Finset.sum_nonneg fun T _ => p.errAlpha_nonneg N alpha T

/-- The errors attainable on a face. -/
def faceErrors (N : ℝ → ℝ) (alpha : ℝ) (ts : Finset ℝ) (S : Set (Fin 4)) : Set ℝ :=
  {e | ∃ p : Candidate, p.OnFace S ∧ e = totalError p N alpha ts}

lemma faceErrors_nonempty (N : ℝ → ℝ) (alpha : ℝ) (ts : Finset ℝ) (S : Set (Fin 4)) :
    (faceErrors N alpha ts S).Nonempty :=
  ⟨_, ⟨Candidate.mk 0 0 0 0, Candidate.onFace_zero S, rfl⟩⟩

lemma faceErrors_bddBelow (N : ℝ → ℝ) (alpha : ℝ) (ts : Finset ℝ) (S : Set (Fin 4)) :
    BddBelow (faceErrors N alpha ts S) := by
  refine ⟨0, ?_⟩
  rintro e ⟨p, -, rfl⟩
  exact totalError_nonneg p N alpha ts

/-- The best total error attainable on a face. -/
noncomputable def faceError (N : ℝ → ℝ) (alpha : ℝ) (ts : Finset ℝ) (S : Set (Fin 4)) : ℝ :=
  sInf (faceErrors N alpha ts S)

lemma faceError_nonneg (N : ℝ → ℝ) (alpha : ℝ) (ts : Finset ℝ) (S : Set (Fin 4)) :
    0 ≤ faceError N alpha ts S := by
  refine le_csInf (faceErrors_nonempty N alpha ts S) ?_
  rintro e ⟨p, -, rfl⟩
  exact totalError_nonneg p N alpha ts

lemma faceError_le {N : ℝ → ℝ} {alpha : ℝ} {ts : Finset ℝ} {S : Set (Fin 4)} {p : Candidate}
    (hp : p.OnFace S) : faceError N alpha ts S ≤ totalError p N alpha ts :=
  csInf_le (faceErrors_bddBelow N alpha ts S) ⟨p, hp, rfl⟩

/-- **A larger face fits at least as well.** Moving up the complexity lattice can only decrease
the attainable error, so a downward slope in the lattice plot carries no information about which
candidate is asymptotically right. -/
theorem faceError_anti (N : ℝ → ℝ) (alpha : ℝ) (ts : Finset ℝ) {S S' : Set (Fin 4)} (h : S ⊆ S') :
    faceError N alpha ts S' ≤ faceError N alpha ts S := by
  refine csInf_le_csInf (faceErrors_bddBelow N alpha ts S') (faceErrors_nonempty N alpha ts S) ?_
  rintro e ⟨p, hp, rfl⟩
  exact ⟨p, hp.mono h, rfl⟩

/-- **Asymptotic correctness is a property of the face, not of the fit.** A face carries an
admissible candidate exactly when it contains the leading coefficient. -/
theorem exists_admissible_onFace_iff (S : Set (Fin 4)) :
    (∃ p : Candidate, p.Admissible ∧ p.OnFace S) ↔ (0 : Fin 4) ∈ S := by
  constructor
  · rintro ⟨p, hadm, hface⟩
    by_contra h0
    have hzero : p.coeff 0 = 0 := hface 0 h0
    rw [Candidate.coeff_zero, show p.a = 1 / (2 * Real.pi) from hadm] at hzero
    have hpos : (0 : ℝ) < 1 / (2 * Real.pi) := by positivity
    exact absurd hzero hpos.ne'
  · intro h0
    refine ⟨⟨1 / (2 * Real.pi), 0, 0, 0⟩, rfl, ?_⟩
    intro i hi
    fin_cases i
    · exact absurd h0 hi
    · rfl
    · rfl
    · rfl

end ZetaZeros.Experiments
