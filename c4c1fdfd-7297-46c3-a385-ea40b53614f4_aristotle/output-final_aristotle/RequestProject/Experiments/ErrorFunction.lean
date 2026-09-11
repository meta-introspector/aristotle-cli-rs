/-
Original to this repository (not part of the upstream ZetaZeros development).
-/

import RequestProject.Experiments.Interface

/-! # The shared candidate family, its error function, and the admissibility polytope

This file fixes, once and for all, the objects the experiment dashboard
(`web/experiments.html`) and every submitted experiment are scored against.

A **candidate** is a point `p = (a, b, c, d)` of the four-dimensional parameter space, standing
for the approximation

`p.eval T = a · T · log T + b · T + c · log T + d`

of the zero-counting function `N(T)`. Two points of the family are distinguished:

* `rvmCandidate = (1/2π, 0, 0, 0)`, i.e. `rvmMain T = (T/2π) log T`;
* `sharpCandidate = (1/2π, -(log 2π + 1)/2π, 0, 0)`, i.e. the sharper main term
  `rvmSharp T = (T/2π) log (T/2π) - T/2π` (`sharpCandidate_eval`).

The **error function** is the one the front end plots: `Candidate.err` is the absolute error
`|N T - p.eval T|`, `Candidate.errRel` the signed error relative to `rvmMain`, and
`Candidate.errAlpha` the interpolation between the two that the dashboard's slider exposes.

The central result is `tendsto_errRel`: assuming the Riemann–von Mangoldt input, the relative
error of *every* candidate converges, and its limit is

`1 - 2π·a`,

depending on the leading coefficient `a` alone. So

* the admissible set — the candidates whose relative error vanishes, equivalently the candidates
  asymptotically equivalent to `N` — is exactly the hyperplane `a = 1/2π`
  (`isEquivalent_iff_admissible`, `admissible_iff_leading`), a face of the parameter space that
  is *independent of `b`, `c`, `d`*;
* the remaining coefficients `b`, `c`, `d` are invisible to any asymptotic criterion, even though
  they change the finite-height error a lot. Ranking candidates numerically and ranking them
  formally are genuinely different orders, and this is the theorem that says so.

Nothing here proves the Riemann–von Mangoldt formula; results depending on it take it as a
hypothesis.
-/

open Filter Topology Asymptotics

namespace ZetaZeros.Experiments

/-- A candidate approximation `T ↦ a·T·log T + b·T + c·log T + d` of the zero-counting
function, recorded by its four coefficients. This is the parameter space the front end exposes
as sliders. -/
structure Candidate where
  /-- Coefficient of `T log T`. -/
  a : ℝ
  /-- Coefficient of `T`. -/
  b : ℝ
  /-- Coefficient of `log T`. -/
  c : ℝ
  /-- Constant coefficient. -/
  d : ℝ

namespace Candidate

/-- The function a candidate stands for. -/
noncomputable def eval (p : Candidate) (T : ℝ) : ℝ :=
  p.a * T * Real.log T + p.b * T + p.c * Real.log T + p.d

/-- The absolute error of a candidate against a counting function `N`. -/
noncomputable def err (p : Candidate) (N : ℝ → ℝ) (T : ℝ) : ℝ := |N T - p.eval T|

/-- The signed error of a candidate relative to the Riemann–von Mangoldt main term. This is the
quantity whose limit the dashboard reports. -/
noncomputable def errRel (p : Candidate) (N : ℝ → ℝ) (T : ℝ) : ℝ := (N T - p.eval T) / rvmMain T

/-- The interpolated error metric of the dashboard's `absolute ↔ relative` slider:
`alpha = 0` is the absolute error, `alpha = 1` the relative error. -/
noncomputable def errAlpha (p : Candidate) (N : ℝ → ℝ) (alpha T : ℝ) : ℝ :=
  |N T - p.eval T| / max 1 |p.eval T| ^ alpha

open scoped Classical in
/-- The complexity of a candidate: how many of its four coefficients are nonzero. -/
noncomputable def complexity (p : Candidate) : ℕ :=
  (if p.a = 0 then 0 else 1) + (if p.b = 0 then 0 else 1) + (if p.c = 0 then 0 else 1) +
    (if p.d = 0 then 0 else 1)

/-- A candidate is *admissible* when its leading coefficient is `1/2π`, i.e. when it lies on the
face of the parameter space cut out by the Riemann–von Mangoldt main term. -/
def Admissible (p : Candidate) : Prop := p.a = 1 / (2 * Real.pi)

end Candidate

/-- The Riemann–von Mangoldt main term `(T/2π) log T` as a candidate. -/
noncomputable def rvmCandidate : Candidate := ⟨1 / (2 * Real.pi), 0, 0, 0⟩

/-- The sharper main term `(T/2π) log (T/2π) - T/2π` as a candidate. -/
noncomputable def sharpCandidate : Candidate :=
  ⟨1 / (2 * Real.pi), -(Real.log (2 * Real.pi) + 1) / (2 * Real.pi), 0, 0⟩

@[simp] lemma rvmCandidate_eval (T : ℝ) : rvmCandidate.eval T = rvmMain T := by
  simp only [Candidate.eval, rvmCandidate, rvmMain]
  ring

lemma sharpCandidate_eval {T : ℝ} (hT : 0 < T) : sharpCandidate.eval T = rvmSharp T := by
  have hpi : (0 : ℝ) < 2 * Real.pi := by positivity
  have hsplit : Real.log (T / (2 * Real.pi)) = Real.log T - Real.log (2 * Real.pi) :=
    Real.log_div hT.ne' hpi.ne'
  simp only [Candidate.eval, sharpCandidate, rvmSharp, hsplit]
  field_simp
  ring

lemma rvmCandidate_admissible : rvmCandidate.Admissible := rfl

lemma sharpCandidate_admissible : sharpCandidate.Admissible := rfl

/-- Admissibility only constrains the leading coefficient: the admissible set is the hyperplane
`a = 1/2π`, and `b`, `c`, `d` are free. -/
lemma admissible_iff_leading (p : Candidate) : p.Admissible ↔ p.a = 1 / (2 * Real.pi) := Iff.rfl

/-- Changing the lower-order coefficients of an admissible candidate keeps it admissible: the
admissible set is a whole face of the parameter space, not a point. -/
lemma admissible_of_leading_eq {p : Candidate} (hp : p.Admissible) (b c d : ℝ) :
    (Candidate.mk p.a b c d).Admissible := hp

/-- Every admissible candidate has at least one nonzero coefficient. -/
lemma one_le_complexity_of_admissible (p : Candidate) (hp : p.Admissible) : 1 ≤ p.complexity := by
  have hpi : (0 : ℝ) < 2 * Real.pi := by positivity
  have ha : p.a ≠ 0 := by rw [Candidate.Admissible] at hp; rw [hp]; positivity
  simp only [Candidate.complexity, if_neg ha]
  split_ifs <;> omega

/-- The Riemann–von Mangoldt main term is an admissible candidate of minimal complexity. -/
@[simp] lemma rvmCandidate_complexity : rvmCandidate.complexity = 1 := by
  simp [Candidate.complexity, rvmCandidate, Real.pi_ne_zero]

/-! ### The limit of the error function -/

/-- Every candidate is comparable with the main term: the ratio `p.eval T / rvmMain T` converges
to `2π·a`. -/
lemma tendsto_eval_div_rvmMain (p : Candidate) :
    Tendsto (fun T : ℝ => p.eval T / rvmMain T) atTop (𝓝 (2 * Real.pi * p.a)) := by
  have key : Tendsto (fun T : ℝ => 2 * Real.pi *
      (p.a + p.b * (Real.log T)⁻¹ + p.c * T⁻¹ + p.d * (T * Real.log T)⁻¹)) atTop
      (𝓝 (2 * Real.pi * (p.a + p.b * 0 + p.c * 0 + p.d * 0))) := by
    refine tendsto_const_nhds.mul (((tendsto_const_nhds.add
      (tendsto_const_nhds.mul Real.tendsto_log_atTop.inv_tendsto_atTop)).add
      (tendsto_const_nhds.mul tendsto_inv_atTop_zero)).add
      (tendsto_const_nhds.mul ?_))
    exact (Filter.Tendsto.atTop_mul_atTop₀ tendsto_id Real.tendsto_log_atTop).inv_tendsto_atTop
  simp only [mul_zero, add_zero] at key
  refine key.congr' ?_
  filter_upwards [eventually_gt_atTop (1 : ℝ)] with T hT
  have hT0 : T ≠ 0 := (lt_trans one_pos hT).ne'
  have hlog : Real.log T ≠ 0 := (Real.log_pos hT).ne'
  simp only [Candidate.eval, rvmMain]
  field_simp

/-- A candidate is asymptotically equivalent to the Riemann–von Mangoldt main term exactly when
it is admissible. -/
theorem eval_isEquivalent_rvmMain_iff (p : Candidate) :
    Asymptotics.IsEquivalent atTop p.eval rvmMain ↔ p.Admissible := by
  have hpi : (0 : ℝ) < 2 * Real.pi := by positivity
  rw [Asymptotics.isEquivalent_iff_tendsto_one eventually_rvmMain_ne_zero]
  constructor
  · intro hone
    have h1 : (2 : ℝ) * Real.pi * p.a = 1 :=
      tendsto_nhds_unique (tendsto_eval_div_rvmMain p) hone
    rw [Candidate.Admissible]
    field_simp
    linear_combination h1
  · intro hp
    rw [Candidate.Admissible] at hp
    have h1 : (2 : ℝ) * Real.pi * p.a = 1 := by rw [hp]; field_simp
    have := tendsto_eval_div_rvmMain p
    rw [h1] at this
    exact this.congr fun T => rfl

/-- **The error function has a limit, and it sees only the leading coefficient.** Assuming the
Riemann–von Mangoldt input, the relative error of a candidate tends to `1 - 2π·a`. -/
theorem tendsto_errRel (h : RiemannVonMangoldt) (p : Candidate) :
    Tendsto (p.errRel (fun T => (zeroCount T : ℝ))) atTop (𝓝 (1 - 2 * Real.pi * p.a)) := by
  have hN : Tendsto (fun T : ℝ => (zeroCount T : ℝ) / rvmMain T) atTop (𝓝 1) :=
    (Asymptotics.isEquivalent_iff_tendsto_one eventually_rvmMain_ne_zero).1
      (riemannVonMangoldt_iff_isEquivalent.1 h)
  refine (hN.sub (tendsto_eval_div_rvmMain p)).congr fun T => ?_
  simp [Candidate.errRel, sub_div]

/-- Assuming the Riemann–von Mangoldt input, a candidate is asymptotically equivalent to the
zero-counting function exactly when it is admissible, i.e. exactly when its leading coefficient
is `1/2π`. The lower-order coefficients are invisible to this criterion. -/
theorem isEquivalent_iff_admissible (h : RiemannVonMangoldt) (p : Candidate) :
    Asymptotics.IsEquivalent atTop (fun T : ℝ => (zeroCount T : ℝ)) p.eval ↔ p.Admissible := by
  have hrvm := riemannVonMangoldt_iff_isEquivalent.1 h
  constructor
  · intro hEq
    exact (eval_isEquivalent_rvmMain_iff p).1 (hEq.symm.trans hrvm)
  · intro hp
    exact hrvm.trans ((eval_isEquivalent_rvmMain_iff p).2 hp).symm

/-- The candidate the repository's hypothesis is stated with is equivalent to the zero count. -/
theorem isEquivalent_rvmCandidate (h : RiemannVonMangoldt) :
    Asymptotics.IsEquivalent atTop (fun T : ℝ => (zeroCount T : ℝ)) rvmCandidate.eval :=
  (isEquivalent_iff_admissible h rvmCandidate).2 rvmCandidate_admissible

/-- **Numerical ranking is not formal ranking.** At any single height, some inadmissible
candidate reproduces the counting function exactly, so a leaderboard built from finite-height
error alone can put an asymptotically wrong candidate first. -/
theorem exists_inadmissible_err_zero (N : ℝ → ℝ) (T₀ : ℝ) :
    ∃ p : Candidate, ¬ p.Admissible ∧ p.err N T₀ = 0 := by
  refine ⟨⟨0, 0, 0, N T₀⟩, ?_, ?_⟩
  · simp [Candidate.Admissible]
  · simp [Candidate.err, Candidate.eval]

/-- A candidate whose leading coefficient is wrong has relative error bounded away from `0`:
numerically fitting `b`, `c`, `d` can never repair it. -/
theorem not_tendsto_errRel_zero (h : RiemannVonMangoldt) (p : Candidate) (hp : ¬ p.Admissible) :
    ¬ Tendsto (p.errRel (fun T => (zeroCount T : ℝ))) atTop (𝓝 0) := by
  intro h0
  have hpi : (0 : ℝ) < 2 * Real.pi := by positivity
  have hne : (1 : ℝ) - 2 * Real.pi * p.a ≠ 0 := by
    intro hcon
    refine hp ?_
    rw [Candidate.Admissible]
    field_simp
    linear_combination -hcon
  exact hne (tendsto_nhds_unique (tendsto_errRel h p) h0)

end ZetaZeros.Experiments
