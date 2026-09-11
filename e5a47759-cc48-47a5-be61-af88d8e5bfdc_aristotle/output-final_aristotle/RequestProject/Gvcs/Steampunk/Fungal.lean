import Mathlib

/-!
# A fungal colony as an analogue solver for a boundary value problem

Can something grown rather than built *compute*?  For one classical problem the
answer is yes, and this file proves it.

A colony is spread across a line of `N + 2` sites, `0 … N + 1`.  The two end
sites sit on nutrient reservoirs held at fixed concentrations `a` and `b`;
every interior site relaxes, in one time step, to the mean of the
concentrations either side of it.  That is `spread`, and it is exactly the
explicit finite-difference scheme for the diffusion equation
`∂ₜu = ½ Δu` (`spread_eq_heat_step`).

The problem being solved is the discrete Dirichlet problem: find `u` with
`Δu = 0` inside and `u 0 = a`, `u (N+1) = b`, where
`Δu i = u(i-1) - 2u i + u(i+1)`.  Its solution is the straight line
`linearProfile` (`harmonic_linearProfile`).

The results:

* `weight_avg` — the exact eigen-relation
  `(sin(π(i-1)/(N+1)) + sin(π(i+1)/(N+1)))/2 = cos(π/(N+1)) · sin(πi/(N+1))`,
  which is what makes the colony converge, and at what speed;
* `spread_error_bound` — the error after `t` steps is at most
  `cos(π/(N+1))ᵗ` times its initial size, site by site, in the weighted
  measure `sin(πi/(N+1))`;
* `colony_solves_dirichlet` — **the colony solves the equation**: from *any*
  starting concentration profile with the right values at the reservoirs, the
  concentration at every site converges to the solution of the boundary value
  problem;
* `dirichlet_unique` — and to nothing else: a colony already at rest is the
  solution.

Honest limits.  This is a discrete, one-dimensional, deterministic model of
diffusion in a colony; it says nothing about hyphal branching, growth, or
whether a real mycelium realises this dynamic within a useful tolerance.  What
is proved is that *the dynamics named here* converge to the solution of *the
boundary value problem named here*, at the rate named here.
-/

namespace LifeTrac
namespace Steampunk

open Filter Real

/-! ## The colony and the equation -/

/-- One time step of the colony: interior sites take the mean of their
neighbours, the two end sites are pinned to the reservoirs `a` and `b`. -/
noncomputable def spread (N : ℕ) (a b : ℝ) (u : ℕ → ℝ) : ℕ → ℝ :=
  fun i => if 1 ≤ i ∧ i ≤ N then (u (i - 1) + u (i + 1)) / 2 else if i = 0 then a else b

theorem spread_interior (N : ℕ) (a b : ℝ) (u : ℕ → ℝ) {i : ℕ} (h1 : 1 ≤ i) (h2 : i ≤ N) :
    spread N a b u i = (u (i - 1) + u (i + 1)) / 2 := by
  simp [spread, h1, h2]

theorem spread_left (N : ℕ) (a b : ℝ) (u : ℕ → ℝ) : spread N a b u 0 = a := by
  simp [spread]

theorem spread_right (N : ℕ) (a b : ℝ) (u : ℕ → ℝ) : spread N a b u (N + 1) = b := by
  simp [spread]

/-- The discrete Laplacian at an interior site. -/
noncomputable def lap (u : ℕ → ℝ) (i : ℕ) : ℝ := u (i - 1) - 2 * u i + u (i + 1)

/-- **The step is the diffusion equation.**  At an interior site, one step of
the colony is one explicit Euler step of `∂ₜu = ½ Δu`. -/
theorem spread_eq_heat_step (N : ℕ) (a b : ℝ) (u : ℕ → ℝ) {i : ℕ}
    (h1 : 1 ≤ i) (h2 : i ≤ N) :
    spread N a b u i = u i + (1 / 2) * lap u i := by
  rw [spread_interior N a b u h1 h2, lap]
  ring

/-- The solution of the boundary value problem: the straight line from `a` to
`b`. -/
noncomputable def linearProfile (N : ℕ) (a b : ℝ) : ℕ → ℝ :=
  fun i => a + (b - a) * i / (N + 1)

/-- The straight line is discrete-harmonic inside. -/
theorem harmonic_linearProfile (N : ℕ) (a b : ℝ) {i : ℕ} (h1 : 1 ≤ i) :
    lap (linearProfile N a b) i = 0 := by
  have hcast : ((i - 1 : ℕ) : ℝ) = (i : ℝ) - 1 := by
    push_cast [Nat.cast_sub h1]; ring
  have hN : ((N : ℝ) + 1) ≠ 0 := by positivity
  simp only [lap, linearProfile, hcast]
  push_cast
  field_simp
  ring

/-- The straight line takes the reservoir values at the two ends. -/
theorem linearProfile_left (N : ℕ) (a b : ℝ) : linearProfile N a b 0 = a := by
  simp [linearProfile]

theorem linearProfile_right (N : ℕ) (a b : ℝ) : linearProfile N a b (N + 1) = b := by
  have hN : ((N : ℝ) + 1) ≠ 0 := by positivity
  simp only [linearProfile]
  push_cast
  field_simp
  ring

/-! ## The eigenvector that measures the error -/

/-- The weight `sin(πi/(N+1))`: zero at the reservoirs, positive inside, and an
eigenvector of the averaging step. -/
noncomputable def weight (N : ℕ) (i : ℕ) : ℝ := Real.sin (π * i / (N + 1))

/-- The contraction factor `cos(π/(N+1))`. -/
noncomputable def rate (N : ℕ) : ℝ := Real.cos (π / (N + 1))

@[simp] theorem weight_zero (N : ℕ) : weight N 0 = 0 := by simp [weight]

@[simp] theorem weight_end (N : ℕ) : weight N (N + 1) = 0 := by
  have hN : ((N : ℝ) + 1) ≠ 0 := by positivity
  have h : π * (((N + 1 : ℕ)) : ℝ) / ((N : ℝ) + 1) = π := by push_cast; field_simp
  rw [weight, h, Real.sin_pi]

theorem weight_nonneg (N : ℕ) {i : ℕ} (hi : i ≤ N + 1) : 0 ≤ weight N i := by
  have hN : (0 : ℝ) < (N : ℝ) + 1 := by positivity
  have hcast : (i : ℝ) ≤ (N : ℝ) + 1 := by exact_mod_cast hi
  have h1 : 0 ≤ π * (i : ℝ) / ((N : ℝ) + 1) := by positivity
  have h2 : π * (i : ℝ) / ((N : ℝ) + 1) ≤ π := by
    rw [div_le_iff₀ hN]
    nlinarith [Real.pi_pos]
  exact Real.sin_nonneg_of_nonneg_of_le_pi h1 h2

theorem weight_pos (N : ℕ) {i : ℕ} (h1 : 1 ≤ i) (h2 : i ≤ N) : 0 < weight N i := by
  have hN : (0 : ℝ) < (N : ℝ) + 1 := by positivity
  have hi1 : (1 : ℝ) ≤ (i : ℝ) := by exact_mod_cast h1
  have hi2 : (i : ℝ) ≤ (N : ℝ) := by exact_mod_cast h2
  have hlo : 0 < π * (i : ℝ) / ((N : ℝ) + 1) := by
    have : (0 : ℝ) < (i : ℝ) := by linarith
    positivity
  have hhi : π * (i : ℝ) / ((N : ℝ) + 1) < π := by
    rw [div_lt_iff₀ hN]
    nlinarith [Real.pi_pos]
  exact Real.sin_pos_of_pos_of_lt_pi hlo hhi

/-- **The eigen-relation.**  Averaging the weight over the two neighbours of an
interior site multiplies it by `cos(π/(N+1))`. -/
theorem weight_avg (N : ℕ) {i : ℕ} (h1 : 1 ≤ i) :
    (weight N (i - 1) + weight N (i + 1)) / 2 = rate N * weight N i := by
  have hcast : ((i - 1 : ℕ) : ℝ) = (i : ℝ) - 1 := by
    push_cast [Nat.cast_sub h1]; ring
  have hN : ((N : ℝ) + 1) ≠ 0 := by positivity
  have e1 : π * ((i : ℝ) - 1) / ((N : ℝ) + 1)
      = π * (i : ℝ) / ((N : ℝ) + 1) - π / ((N : ℝ) + 1) := by
    field_simp
  have e2 : π * ((i : ℝ) + 1) / ((N : ℝ) + 1)
      = π * (i : ℝ) / ((N : ℝ) + 1) + π / ((N : ℝ) + 1) := by
    field_simp
  simp only [weight, rate, hcast]
  push_cast
  rw [e1, e2, Real.sin_sub, Real.sin_add]
  ring

theorem rate_nonneg (N : ℕ) (hN : 1 ≤ N) : 0 ≤ rate N := by
  have hN1 : (1 : ℝ) ≤ (N : ℝ) := by exact_mod_cast hN
  have hpos : (0 : ℝ) < π / ((N : ℝ) + 1) := by positivity
  refine Real.cos_nonneg_of_mem_Icc ⟨by linarith [Real.pi_pos], ?_⟩
  rw [div_le_div_iff₀ (by linarith : (0:ℝ) < (N:ℝ) + 1) (by norm_num : (0:ℝ) < 2)]
  nlinarith [Real.pi_pos]

theorem rate_lt_one (N : ℕ) (hN : 1 ≤ N) : rate N < 1 := by
  have hN1 : (1 : ℝ) ≤ (N : ℝ) := by exact_mod_cast hN
  have hpos : 0 < π / ((N : ℝ) + 1) := by positivity
  have hle : π / ((N : ℝ) + 1) ≤ π := by
    rw [div_le_iff₀ (by linarith : (0:ℝ) < (N:ℝ) + 1)]
    nlinarith [Real.pi_pos]
  have h := Real.cos_lt_cos_of_nonneg_of_le_pi (le_refl (0:ℝ)) hle hpos
  simpa [rate] using h

/-! ## The error contracts -/

/-- The linear part of the step: the same averaging, with the reservoirs held
at zero.  The difference of two colonies obeys it. -/
noncomputable def homStep (N : ℕ) (e : ℕ → ℝ) : ℕ → ℝ :=
  fun i => if 1 ≤ i ∧ i ≤ N then (e (i - 1) + e (i + 1)) / 2 else 0

theorem homStep_interior (N : ℕ) (e : ℕ → ℝ) {i : ℕ} (h1 : 1 ≤ i) (h2 : i ≤ N) :
    homStep N e i = (e (i - 1) + e (i + 1)) / 2 := by
  simp [homStep, h1, h2]

theorem spread_sub (N : ℕ) (a b : ℝ) (u v : ℕ → ℝ) :
    (fun i => spread N a b u i - spread N a b v i) = homStep N (fun i => u i - v i) := by
  funext i
  by_cases h : 1 ≤ i ∧ i ≤ N
  · rw [spread_interior N a b u h.1 h.2, spread_interior N a b v h.1 h.2,
      homStep_interior N _ h.1 h.2]
    ring
  · simp only [spread, homStep, if_neg h]
    split <;> ring

/-- One step of the error: bounded by `cos(π/(N+1))` times the bound, in the
weighted measure. -/
theorem homStep_bound (N : ℕ) (hN : 1 ≤ N) (e : ℕ → ℝ) (K : ℝ) (hK : 0 ≤ K)
    (h : ∀ i ≤ N + 1, |e i| ≤ K * weight N i) :
    ∀ i ≤ N + 1, |homStep N e i| ≤ rate N * K * weight N i := by
  intro i hi
  by_cases hin : 1 ≤ i ∧ i ≤ N
  · obtain ⟨h1, h2⟩ := hin
    have hb1 : |e (i - 1)| ≤ K * weight N (i - 1) := h _ (by omega)
    have hb2 : |e (i + 1)| ≤ K * weight N (i + 1) := h _ (by omega)
    have habs : |homStep N e i| ≤ (|e (i - 1)| + |e (i + 1)|) / 2 := by
      rw [homStep_interior N e h1 h2]
      have hd : |(e (i - 1) + e (i + 1)) / 2| = |e (i - 1) + e (i + 1)| / 2 := by
        rw [abs_div]; norm_num
      rw [hd]
      have := abs_add_le (e (i - 1)) (e (i + 1))
      linarith
    have havg : (K * weight N (i - 1) + K * weight N (i + 1)) / 2 = rate N * K * weight N i := by
      have hw := weight_avg N h1
      nlinarith [hw]
    linarith
  · simp only [homStep, if_neg hin, abs_zero]
    have hw := weight_nonneg N hi
    have hr := rate_nonneg N hN
    positivity

/-- After `t` steps the error is down by `cos(π/(N+1))ᵗ`. -/
theorem homStep_iterate_bound (N : ℕ) (hN : 1 ≤ N) :
    ∀ (t : ℕ) (K : ℝ) (e : ℕ → ℝ), 0 ≤ K → (∀ i ≤ N + 1, |e i| ≤ K * weight N i) →
      ∀ i ≤ N + 1, |(homStep N)^[t] e i| ≤ rate N ^ t * K * weight N i := by
  intro t
  induction t with
  | zero => intro K e _ h i hi; simpa using h i hi
  | succ t ih =>
      intro K e hK h i hi
      have hK' : 0 ≤ rate N * K := mul_nonneg (rate_nonneg N hN) hK
      have hstep : ∀ j ≤ N + 1, |homStep N e j| ≤ (rate N * K) * weight N j := by
        intro j hj
        have := homStep_bound N hN e K hK h j hj
        linarith
      have hres := ih (rate N * K) (homStep N e) hK' hstep i hi
      rw [Function.iterate_succ_apply]
      calc |(homStep N)^[t] (homStep N e) i| ≤ rate N ^ t * (rate N * K) * weight N i := hres
        _ = rate N ^ (t + 1) * K * weight N i := by ring

/-! ## The colony converges to the solution -/

/-- A colony already sitting on the solution stays there. -/
theorem spread_agree (N : ℕ) (a b : ℝ) (u : ℕ → ℝ)
    (h : ∀ i ≤ N + 1, u i = linearProfile N a b i) :
    ∀ i ≤ N + 1, spread N a b u i = linearProfile N a b i := by
  intro i hi
  by_cases hin : 1 ≤ i ∧ i ≤ N
  · obtain ⟨h1, h2⟩ := hin
    have hcast : ((i - 1 : ℕ) : ℝ) = (i : ℝ) - 1 := by
      push_cast [Nat.cast_sub h1]; ring
    have hN : ((N : ℝ) + 1) ≠ 0 := by positivity
    rw [spread_interior N a b u h1 h2, h (i - 1) (by omega), h (i + 1) (by omega)]
    simp only [linearProfile, hcast]
    push_cast
    field_simp
    ring
  · rcases Nat.eq_zero_or_pos i with rfl | hpos
    · rw [spread_left, linearProfile_left]
    · have hiN : i = N + 1 := by omega
      subst hiN
      rw [spread_right, linearProfile_right]

theorem spread_iterate_fixed (N : ℕ) (a b : ℝ) :
    ∀ (t : ℕ), ∀ i ≤ N + 1,
      (spread N a b)^[t] (linearProfile N a b) i = linearProfile N a b i := by
  intro t
  induction t with
  | zero => intro i _; rfl
  | succ t ih =>
      intro i hi
      rw [Function.iterate_succ_apply']
      exact spread_agree N a b _ ih i hi

theorem iterate_sub (N : ℕ) (a b : ℝ) :
    ∀ (t : ℕ) (u v : ℕ → ℝ), (fun i => (spread N a b)^[t] u i - (spread N a b)^[t] v i)
      = (homStep N)^[t] (fun i => u i - v i) := by
  intro t
  induction t with
  | zero => intro u v; rfl
  | succ t ih =>
      intro u v
      rw [Function.iterate_succ_apply, Function.iterate_succ_apply, Function.iterate_succ_apply,
        ← spread_sub N a b u v]
      exact ih (spread N a b u) (spread N a b v)

/-- There is a starting bound in the weighted measure, provided the colony is
inoculated with the reservoir values at the two ends. -/
theorem exists_start_bound (N : ℕ) (a b : ℝ) (u : ℕ → ℝ)
    (h0 : u 0 = a) (hN1 : u (N + 1) = b) :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ i ≤ N + 1, |u i - linearProfile N a b i| ≤ K * weight N i := by
  classical
  have hterms : ∀ j ∈ Finset.range (N + 2),
      0 ≤ |u j - linearProfile N a b j| / weight N j := by
    intro j hj
    rw [Finset.mem_range] at hj
    exact div_nonneg (abs_nonneg _) (weight_nonneg N (by omega))
  refine ⟨∑ j ∈ Finset.range (N + 2), |u j - linearProfile N a b j| / weight N j,
    Finset.sum_nonneg hterms, ?_⟩
  intro i hi
  by_cases hin : 1 ≤ i ∧ i ≤ N
  · obtain ⟨h1, h2⟩ := hin
    have hw : 0 < weight N i := weight_pos N h1 h2
    have hmem : i ∈ Finset.range (N + 2) := by rw [Finset.mem_range]; omega
    have hle : |u i - linearProfile N a b i| / weight N i
        ≤ ∑ j ∈ Finset.range (N + 2), |u j - linearProfile N a b j| / weight N j :=
      Finset.single_le_sum (f := fun j => |u j - linearProfile N a b j| / weight N j)
        hterms hmem
    calc |u i - linearProfile N a b i|
        = (|u i - linearProfile N a b i| / weight N i) * weight N i := by field_simp
      _ ≤ (∑ j ∈ Finset.range (N + 2), |u j - linearProfile N a b j| / weight N j)
            * weight N i := mul_le_mul_of_nonneg_right hle (le_of_lt hw)
  · have hzero : u i - linearProfile N a b i = 0 := by
      rcases Nat.eq_zero_or_pos i with rfl | hpos
      · rw [h0, linearProfile_left]; ring
      · have hiN : i = N + 1 := by omega
        subst hiN
        rw [hN1, linearProfile_right]; ring
    rw [hzero, abs_zero]
    exact mul_nonneg (Finset.sum_nonneg hterms) (weight_nonneg N hi)

/-- **The error after `t` steps.**  From a colony inoculated at the reservoir
values, the deviation from the solution decays like `cos(π/(N+1))ᵗ` at every
site. -/
theorem spread_error_bound (N : ℕ) (hN : 1 ≤ N) (a b : ℝ) (u : ℕ → ℝ)
    (h0 : u 0 = a) (hN1 : u (N + 1) = b) :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ (t : ℕ), ∀ i ≤ N + 1,
      |(spread N a b)^[t] u i - linearProfile N a b i| ≤ rate N ^ t * K * weight N i := by
  obtain ⟨K, hK, hbound⟩ := exists_start_bound N a b u h0 hN1
  refine ⟨K, hK, fun t i hi => ?_⟩
  have hfix := spread_iterate_fixed N a b t i hi
  have hsub := congrFun (iterate_sub N a b t u (linearProfile N a b)) i
  have hrw : (spread N a b)^[t] u i - linearProfile N a b i
      = (homStep N)^[t] (fun j => u j - linearProfile N a b j) i := by
    rw [← hsub, hfix]
  rw [hrw]
  exact homStep_iterate_bound N hN t K _ hK hbound i hi

/-- **The colony solves the boundary value problem.**  Whatever concentration
profile it starts from (matching the reservoirs at the two ends), the
concentration at every site converges to the solution of `Δu = 0`,
`u 0 = a`, `u (N+1) = b`. -/
theorem colony_solves_dirichlet (N : ℕ) (hN : 1 ≤ N) (a b : ℝ) (u : ℕ → ℝ)
    (h0 : u 0 = a) (hN1 : u (N + 1) = b) {i : ℕ} (hi : i ≤ N + 1) :
    Tendsto (fun t => (spread N a b)^[t] u i) atTop (nhds (linearProfile N a b i)) := by
  obtain ⟨K, hK, hbound⟩ := spread_error_bound N hN a b u h0 hN1
  have hrate : |rate N| < 1 := by
    rw [abs_of_nonneg (rate_nonneg N hN)]
    exact rate_lt_one N hN
  have hzero : Tendsto (fun t : ℕ => rate N ^ t * K * weight N i) atTop (nhds 0) := by
    have hp := (tendsto_pow_atTop_nhds_zero_of_abs_lt_one hrate).mul_const (K * weight N i)
    simpa [mul_assoc] using hp
  have hsq : Tendsto (fun t => (spread N a b)^[t] u i - linearProfile N a b i) atTop (nhds 0) := by
    refine squeeze_zero_norm (fun t => ?_) hzero
    simpa using hbound t i hi
  have hfin := hsq.add_const (linearProfile N a b i)
  simpa using hfin

/-- **And there is nothing else it could settle on.**  A colony at rest — one
already invariant under the dynamics on the whole domain — is the solution. -/
theorem dirichlet_unique (N : ℕ) (hN : 1 ≤ N) (a b : ℝ) (u : ℕ → ℝ)
    (h0 : u 0 = a) (hN1 : u (N + 1) = b)
    (hfix : ∀ i ≤ N + 1, spread N a b u i = u i) :
    ∀ i ≤ N + 1, u i = linearProfile N a b i := by
  intro i hi
  have hiter : ∀ t : ℕ, ∀ j ≤ N + 1, (spread N a b)^[t] u j = u j := by
    intro t
    induction t with
    | zero => intro j _; rfl
    | succ t ih =>
        intro j hj
        rw [Function.iterate_succ_apply']
        by_cases hin : 1 ≤ j ∧ j ≤ N
        · obtain ⟨h1, h2⟩ := hin
          rw [spread_interior N a b _ h1 h2, ih (j - 1) (by omega), ih (j + 1) (by omega)]
          have hj' := hfix j hj
          rw [spread_interior N a b u h1 h2] at hj'
          exact hj'
        · rcases Nat.eq_zero_or_pos j with rfl | hpos
          · rw [spread_left]
            have hj' := hfix 0 (by omega)
            rw [spread_left] at hj'
            exact hj'
          · have hjN : j = N + 1 := by omega
            subst hjN
            rw [spread_right]
            have hj' := hfix (N + 1) (by omega)
            rw [spread_right] at hj'
            exact hj'
  have hlim := colony_solves_dirichlet N hN a b u h0 hN1 hi
  have hconst : (fun t : ℕ => (spread N a b)^[t] u i) = fun _ => u i := by
    funext t; exact hiter t i hi
  rw [hconst] at hlim
  exact tendsto_nhds_unique tendsto_const_nhds hlim

end Steampunk
end LifeTrac
