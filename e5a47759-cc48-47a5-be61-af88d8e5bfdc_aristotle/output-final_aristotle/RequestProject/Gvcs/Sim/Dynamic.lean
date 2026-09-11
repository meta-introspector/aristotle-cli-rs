import RequestProject.Gvcs.Sim.Electric

/-!
# Dynamic circuits: what happens in the first few milliseconds

A static circuit tells you where a circuit ends up; it says nothing about how
long it takes to get there, and on this machine that delay is what the
controller has to live with.  An energised valve coil does not reach its
holding current at once — its inductance makes the current climb; an
accumulator does not reach supply pressure at once — the restriction feeding it
makes the pressure climb.  Both are the same first-order lag,

```
y(t) = A (1 - e^{-t/τ}),      τ y'(t) + y(t) = A,     y(0) = 0,
```

and this file develops it once and instantiates it three times.

* `lag` and `lag_ode` — the lag really solves the differential equation, proved
  as a `HasDerivAt`; `lag_zero`, `lag_lt_target`, `lag_nonneg`,
  `lag_strictMono`, `lag_tendsto` (it approaches the target and never passes
  it), `lag_tau` (63.2 % of the way after one time constant) and
  `lag_timeToReach` (when it reaches a given level).
* `Coil.currentAt`, `Coil.currentAt_ode`, `Coil.pullIn_at_pullInTime` — the
  solenoid: the coil current, the equation `L i' + R i = V` it satisfies, and
  the delay before the valve shifts.
* `Accumulator` — the hydraulic analogue: a compliance filled through a
  restriction, `Accumulator.pressureAt_ode`, and the stored energy.
* A **discrete** dynamic model for the game loop: `eulerStep` and `eulerIter`,
  with the closed form `eulerIter_eq` (`yₙ = A + (1-h/τ)ⁿ (y₀ - A)`), the
  invariant `eulerIter_mem_Icc` (the discrete solution never leaves the band
  between its start and the target when the step is stable) and
  `eulerIter_tendsto`, so a game running the circuit at a fixed tick converges
  to the same steady state as the continuous circuit.
-/

namespace LifeTrac
namespace Dynamic

open Real Electric Filter Topology

noncomputable section

/-! ## The first-order lag -/

/-- The first-order lag: a quantity released towards the target `A` with time
constant `tau`, starting from zero. -/
def lag (A tau t : ℝ) : ℝ := A * (1 - exp (-(t / tau)))

@[simp] theorem lag_zero (A tau : ℝ) : lag A tau 0 = 0 := by simp [lag]

/-- **The lag solves the first-order equation** `τ y' = A - y`. -/
theorem lag_ode (A tau : ℝ) (htau : tau ≠ 0) (t : ℝ) :
    HasDerivAt (lag A tau) ((A - lag A tau t) / tau) t := by
  have h1 : HasDerivAt (fun t : ℝ => -(t / tau)) (-(1 / tau)) t := by
    simpa using ((hasDerivAt_id t).div_const tau).neg
  have h2 : HasDerivAt (fun t : ℝ => exp (-(t / tau)))
      (exp (-(t / tau)) * -(1 / tau)) t := h1.exp
  have h3 : HasDerivAt (fun t : ℝ => A * (1 - exp (-(t / tau))))
      (A * -(exp (-(t / tau)) * -(1 / tau))) t := (h2.const_sub 1).const_mul A
  have hgoal : (A - lag A tau t) / tau = A * -(exp (-(t / tau)) * -(1 / tau)) := by
    simp only [lag]
    field_simp
    ring
  rw [hgoal]
  exact h3

/-- Rearranged: `τ y' + y = A`, the form the coil and the accumulator are
usually written in. -/
theorem lag_ode' (A tau : ℝ) (htau : tau ≠ 0) (t : ℝ) :
    ∃ d : ℝ, HasDerivAt (lag A tau) d t ∧ tau * d + lag A tau t = A := by
  refine ⟨(A - lag A tau t) / tau, lag_ode A tau htau t, ?_⟩
  field_simp
  ring

/-- The lag never reaches its target. -/
theorem lag_lt_target {A tau t : ℝ} (hA : 0 < A) : lag A tau t < A := by
  have h : 0 < exp (-(t / tau)) := exp_pos _
  simp only [lag]
  nlinarith

/-- After the start, the lag is on its way: nonnegative for a positive
target. -/
theorem lag_nonneg {A tau t : ℝ} (hA : 0 ≤ A) (htau : 0 < tau) (ht : 0 ≤ t) :
    0 ≤ lag A tau t := by
  have h : exp (-(t / tau)) ≤ 1 := by
    rw [exp_le_one_iff]
    have : 0 ≤ t / tau := div_nonneg ht htau.le
    linarith
  simp only [lag]
  nlinarith

/-- The approach is monotone. -/
theorem lag_strictMono {A tau : ℝ} (hA : 0 < A) (htau : 0 < tau) :
    StrictMono (lag A tau) := by
  intro s t hst
  have hexp : exp (-(t / tau)) < exp (-(s / tau)) := by
    apply exp_lt_exp.2
    have hst' : s / tau < t / tau := by gcongr
    linarith
  simp only [lag]
  nlinarith

/-- In the long run the lag settles on its target. -/
theorem lag_tendsto (A : ℝ) {tau : ℝ} (htau : 0 < tau) :
    Tendsto (lag A tau) atTop (𝓝 A) := by
  have h0 : Tendsto (fun t : ℝ => t / tau) atTop atTop :=
    Filter.Tendsto.atTop_div_const htau tendsto_id
  have h1 : Tendsto (fun t : ℝ => -(t / tau)) atTop atBot := tendsto_neg_atTop_atBot.comp h0
  have h2 : Tendsto (fun t : ℝ => exp (-(t / tau))) atTop (𝓝 0) :=
    tendsto_exp_atBot.comp h1
  have := ((tendsto_const_nhds (x := (1 : ℝ)) (f := atTop (α := ℝ))).sub h2).const_mul A
  simpa [lag] using this

/-- One time constant takes the lag `1 - 1/e` — about 63 % — of the way. -/
theorem lag_tau (A : ℝ) {tau : ℝ} (htau : 0 < tau) :
    lag A tau tau = A * (1 - exp (-1)) := by
  rw [lag, div_self (ne_of_gt htau)]

/-- The time at which the lag reaches the level `y`. -/
def timeToReach (A tau y : ℝ) : ℝ := tau * log (A / (A - y))

/-- …and it does reach it there. -/
theorem lag_timeToReach {A tau y : ℝ} (hA : 0 < A) (htau : 0 < tau) (hyA : y < A) :
    lag A tau (timeToReach A tau y) = y := by
  have hAy : 0 < A - y := by linarith
  have hpos : 0 < A / (A - y) := div_pos hA hAy
  have hne : tau ≠ 0 := ne_of_gt htau
  have hdiv : timeToReach A tau y / tau = log (A / (A - y)) := by
    rw [timeToReach]
    field_simp
  rw [lag, hdiv, ← log_inv, exp_log (by positivity)]
  field_simp
  ring

/-! ## The solenoid coil, energised -/

variable (k : Electric.Coil)

/-- Current in the coil `t` seconds after it is put across `v` volts. -/
def coilCurrent (v t : ℝ) : ℝ := lag (k.holdCurrent v) k.tau t

/-- **`L i' + R i = V`**: the coil current obeys the inductor equation. -/
theorem coilCurrent_ode (v t : ℝ) :
    ∃ d : ℝ, HasDerivAt (coilCurrent k v) d t ∧ k.ind * d + k.res * coilCurrent k v t = v := by
  have hne : k.tau ≠ 0 := ne_of_gt k.tau_pos
  obtain ⟨d, hd, heq⟩ := lag_ode' (k.holdCurrent v) k.tau hne t
  refine ⟨d, hd, ?_⟩
  have hres : k.res ≠ 0 := ne_of_gt k.res_pos
  have hsplit : k.ind * d + k.res * lag (k.holdCurrent v) k.tau t
      = k.res * (k.tau * d + lag (k.holdCurrent v) k.tau t) := by
    simp only [Electric.Coil.tau]
    field_simp
  rw [coilCurrent, hsplit, heq, Electric.Coil.holdCurrent]
  field_simp

/-- The coil starts from rest… -/
@[simp] theorem coilCurrent_zero (v : ℝ) : coilCurrent k v 0 = 0 := by
  simp [coilCurrent]

/-- …climbs steadily… -/
theorem coilCurrent_strictMono {v : ℝ} (hv : 0 < v) : StrictMono (coilCurrent k v) :=
  lag_strictMono (div_pos hv k.res_pos) k.tau_pos

/-- …and never exceeds the holding current of the static solution. -/
theorem coilCurrent_lt_hold {v : ℝ} (hv : 0 < v) (t : ℝ) :
    coilCurrent k v t < k.holdCurrent v :=
  lag_lt_target (div_pos hv k.res_pos)

/-- The delay before the valve shifts: the time the current takes to reach the
coil's pull-in level. -/
def pullInTime (v pull : ℝ) : ℝ := timeToReach (k.holdCurrent v) k.tau pull

/-- At that time the current is exactly the pull-in current, so the valve
shifts then and not before. -/
theorem pullIn_at_pullInTime {v pull : ℝ} (hv : 0 < v)
    (hlt : pull < k.holdCurrent v) : coilCurrent k v (pullInTime k v pull) = pull :=
  lag_timeToReach (div_pos hv k.res_pos) k.tau_pos hlt

/-! ## The hydraulic analogue: an accumulator behind a restriction -/

/-- A gas-charged accumulator of hydraulic capacitance `cap` (volume per unit
pressure) filled through a restriction of hydraulic resistance `res`. -/
structure Accumulator where
  /-- Hydraulic capacitance: the volume it takes to raise the pressure by one
  pascal. -/
  cap : ℝ
  /-- Resistance of the line feeding it. -/
  res : ℝ
  cap_pos : 0 < cap
  res_pos : 0 < res

namespace Accumulator

variable (a : Accumulator)

/-- Hydraulic time constant `R C`. -/
def tau : ℝ := a.res * a.cap

theorem tau_pos : 0 < a.tau := mul_pos a.res_pos a.cap_pos

/-- Pressure in the accumulator `t` seconds after it is connected to a supply
held at `p`. -/
def pressureAt (p t : ℝ) : ℝ := lag p a.tau t

/-- **`R C p' + p = p_supply`**: the pressure obeys the charging equation. -/
theorem pressureAt_ode (p t : ℝ) :
    ∃ d : ℝ, HasDerivAt (a.pressureAt p) d t ∧ a.res * a.cap * d + a.pressureAt p t = p :=
  lag_ode' p a.tau (ne_of_gt a.tau_pos) t

/-- The flow into the accumulator: capacitance times the rate of pressure
rise. -/
theorem flowIn (p t : ℝ) :
    ∃ d : ℝ, HasDerivAt (a.pressureAt p) d t ∧ a.cap * d = (p - a.pressureAt p t) / a.res := by
  obtain ⟨d, hd, heq⟩ := a.pressureAt_ode p t
  refine ⟨d, hd, ?_⟩
  have hres : a.res ≠ 0 := ne_of_gt a.res_pos
  field_simp
  linarith [heq]

/-- Energy stored in the accumulator at pressure `p`: `½ C p²`. -/
def energy (p : ℝ) : ℝ := a.cap * p ^ 2 / 2

theorem energy_nonneg (p : ℝ) : 0 ≤ a.energy p := by
  have := a.cap_pos
  unfold energy
  positivity

/-- The accumulator fills monotonically and never overshoots the supply. -/
theorem pressureAt_lt_supply {p : ℝ} (hp : 0 < p) (t : ℝ) : a.pressureAt p t < p :=
  lag_lt_target hp

end Accumulator

/-! ## The discrete dynamic model the game runs -/

/-- One tick of the game's integrator: a step of length `h` towards the target
`A` with time constant `tau`. -/
def eulerStep (A tau h y : ℝ) : ℝ := y + h * (A - y) / tau

/-- `n` ticks. -/
def eulerIter (A tau h : ℝ) : ℕ → ℝ → ℝ
  | 0, y => y
  | n + 1, y => eulerStep A tau h (eulerIter A tau h n y)

/-- Closed form of the discrete solution: the error to the target is multiplied
by `1 - h/τ` every tick. -/
theorem eulerIter_eq (A tau h y : ℝ) (htau : tau ≠ 0) (n : ℕ) :
    eulerIter A tau h n y = A + (1 - h / tau) ^ n * (y - A) := by
  induction n with
  | zero => simp [eulerIter]
  | succ n ih =>
      simp only [eulerIter, eulerStep, ih, pow_succ]
      field_simp
      ring

/-- With a stable tick (`0 < h ≤ τ`) the discrete solution starting below the
target stays between its start and the target: the game can never make the
circuit overshoot. -/
theorem eulerIter_mem_Icc {A tau h y : ℝ} (htau : 0 < tau) (hh : 0 < h) (hle : h ≤ tau)
    (hy : y ≤ A) (n : ℕ) : eulerIter A tau h n y ∈ Set.Icc y A := by
  induction n with
  | zero => exact ⟨le_refl y, hy⟩
  | succ n ih =>
      obtain ⟨h1, h2⟩ := ih
      set z := eulerIter A tau h n y with hz
      have hnn : 0 ≤ h * (A - z) / tau := by
        apply div_nonneg _ htau.le
        exact mul_nonneg hh.le (by linarith)
      have hup : h * (A - z) / tau ≤ A - z := by
        rw [div_le_iff₀ htau]
        nlinarith
      have hstep : eulerIter A tau h (n + 1) y = z + h * (A - z) / tau := rfl
      rw [hstep]
      exact ⟨by linarith, by linarith⟩

/-- And it converges to the same steady state the static circuit predicts. -/
theorem eulerIter_tendsto {A tau h y : ℝ} (htau : 0 < tau) (hh : 0 < h) (hlt : h < 2 * tau) :
    Tendsto (fun n => eulerIter A tau h n y) atTop (𝓝 A) := by
  have hne : tau ≠ 0 := ne_of_gt htau
  have habs : |1 - h / tau| < 1 := by
    rw [abs_lt]
    constructor
    · have : h / tau < 2 := by rw [div_lt_iff₀ htau]; linarith
      linarith
    · have : 0 < h / tau := div_pos hh htau
      linarith
  have hpow : Tendsto (fun n : ℕ => (1 - h / tau) ^ n) atTop (𝓝 0) :=
    tendsto_pow_atTop_nhds_zero_of_abs_lt_one habs
  have := (hpow.mul_const (y - A)).const_add A
  simpa [eulerIter_eq A tau h y hne] using this

end

end Dynamic
end LifeTrac
