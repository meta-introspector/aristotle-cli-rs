import Mathlib
import RequestProject.Monster

/-!
# An adaptive, self-correcting runtime predictor — with a machine-verified core

The conversation proposed building a self-measuring feedback loop directly inside Lean: a
runtime cost model `predict(p) = θ·p²` that is repeatedly *measured* against the real native
execution time and then *corrected* by a gradient-descent step on `θ`. This file makes that
idea precise and, crucially, **proves the mathematics of the feedback loop is sound** rather
than merely running it.

Following the project's established pattern (a proved core over an exact field, plus an
executable mirror), it has two layers:

1. **A machine-verified convergence core over `ℝ`** (§1). For a single sample `(p, actual)`
   with cost `c = p²`, prediction `predict θ = θ·c`, residual `r(θ) = actual − θ·c`, and the
   gradient-descent update `θ ↦ θ + 2·α·r(θ)·c`, we prove:
   * `residual_after_update`: the residual is rescaled exactly by the contraction factor,
     `r(θ') = (1 − 2·α·c²)·r(θ)`;
   * `residual_abs_after_update` / `residual_abs_le_of_factor`: hence `|r|` never grows when
     `|1 − 2·α·c²| ≤ 1`, and strictly shrinks when `|1 − 2·α·c²| < 1` and `r ≠ 0` — the loop
     provably converges for an appropriate learning rate;
   * `update_fixed_iff`: `θ` is a fixed point iff the prediction is already exact;
   * `predict_exactFit`: the unique exact-fit coefficient is `θ = actual / p²`.

   This turns the informal "watch the prediction error collapse toward zero" claim into a
   theorem.

2. **An executable `Float` mirror** (§2): the real benchmark loop (`benchmark`,
   `runBenchmarkAndAdapt`, `runAdaptiveSuite`) that times the project's *actual*
   supersingularity computation `Monster.ssCountFp` across the supersingular primes, feeding
   each measurement back into the predictor. (`Float` is opaque to the kernel, so this layer
   is only *run* via `#eval`, not proved; the proved guarantees live in §1.)
-/

namespace AdaptiveModel

open scoped BigOperators

set_option autoImplicit false

/-! ## 1. The verified convergence core (over `ℝ`)

We model the predictor's state by a single coefficient `θ`. The workload cost for prime `p`
is `c = p²` (the naive `O(p²)` polynomial-arithmetic estimate). All statements are about real
numbers, so they are genuine theorems (no `native_decide`, standard axioms only). -/

/-- The modelled cost of the task at prime `p`: the `O(p²)` estimate, as a real number. -/
noncomputable def cost (p : ℕ) : ℝ := (p : ℝ) * (p : ℝ)

/-- Predicted runtime: `predict θ p = θ · p²`. -/
noncomputable def predict (theta : ℝ) (p : ℕ) : ℝ := theta * cost p

/-- Residual (signed prediction error): `actual − predict θ p`. -/
noncomputable def residual (theta actual : ℝ) (p : ℕ) : ℝ := actual - predict theta p

/-- One gradient-descent feedback step on `θ` with learning rate `α`. The squared-error
gradient is `∂/∂θ (actual − θ·c)² = −2·r·c`, so `θ ↦ θ − α·(−2·r·c) = θ + 2·α·r·c`. -/
noncomputable def updateTheta (alpha theta actual : ℝ) (p : ℕ) : ℝ :=
  theta - alpha * (-2 * residual theta actual p * cost p)

/-
**Exact-fit coefficient.** Setting `θ = actual / p²` makes the prediction exact (for
`p ≠ 0`).
-/
theorem predict_exactFit (actual : ℝ) (p : ℕ) (hp : (p : ℝ) ≠ 0) :
    predict (actual / cost p) p = actual := by
      unfold predict cost; ring_nf; aesop;

/-
**The feedback step rescales the residual by an exact contraction factor.** After one
update the residual is multiplied by `1 − 2·α·c²`. This is the heart of the convergence
analysis.
-/
theorem residual_after_update (alpha theta actual : ℝ) (p : ℕ) :
    residual (updateTheta alpha theta actual p) actual p
      = (1 - 2 * alpha * (cost p * cost p)) * residual theta actual p := by
        simp only [residual, predict, updateTheta, cost]
        ring

/-
The magnitude of the residual after one update is `|1 − 2·α·c²|` times the previous
magnitude.
-/
theorem residual_abs_after_update (alpha theta actual : ℝ) (p : ℕ) :
    |residual (updateTheta alpha theta actual p) actual p|
      = |1 - 2 * alpha * (cost p * cost p)| * |residual theta actual p| := by
        rw [ ← abs_mul, residual_after_update ]

/-
**Non-expansiveness.** If the contraction factor has magnitude `≤ 1`, the error never
grows.
-/
theorem residual_abs_le_of_factor (alpha theta actual : ℝ) (p : ℕ)
    (hk : |1 - 2 * alpha * (cost p * cost p)| ≤ 1) :
    |residual (updateTheta alpha theta actual p) actual p| ≤ |residual theta actual p| := by
  convert mul_le_of_le_one_left ( abs_nonneg _ ) hk using 1;
  rw [ ← abs_mul, residual_after_update ]

/-
**Strict contraction.** If the factor has magnitude `< 1` and the error is nonzero, the
update strictly reduces the error — the loop provably converges toward zero error.
-/
theorem residual_abs_lt_of_factor (alpha theta actual : ℝ) (p : ℕ)
    (hk : |1 - 2 * alpha * (cost p * cost p)| < 1)
    (hr : residual theta actual p ≠ 0) :
    |residual (updateTheta alpha theta actual p) actual p| < |residual theta actual p| := by
  rw [ residual_abs_after_update, mul_comm ];
  exact mul_lt_of_lt_one_right ( abs_pos.mpr hr ) hk

/-
**Fixed-point characterization.** With a genuine learning rate (`α ≠ 0`) and a real task
(`p ≠ 0`), `θ` is unchanged by the update iff the prediction is already exact.
-/
theorem update_fixed_iff (alpha theta actual : ℝ) (p : ℕ)
    (ha : alpha ≠ 0) (hp : (p : ℝ) ≠ 0) :
    updateTheta alpha theta actual p = theta ↔ predict theta p = actual := by
      unfold updateTheta residual predict cost;
      grind

end AdaptiveModel

/-! ## 2. The executable `Float` mirror

This is the runnable benchmark loop. It times the project's *real* computational payload —
`Monster.ssCountFp p`, the honest supersingularity count over `𝔽ₚ` — and feeds each measured
wall-clock time back into a `Float` copy of the model from §1. Because `Float` is opaque to
the kernel, nothing here is proved; the guarantees are the theorems above. -/

namespace AdaptiveBench

/-- A `Float` runtime model: coefficient `theta` for the `O(p²)` cost and learning rate
`alpha`. -/
structure RuntimeModel where
  theta : Float
  alpha : Float
deriving Repr

/-- Predicted runtime in seconds, `θ · p²`. -/
def RuntimeModel.predict (m : RuntimeModel) (p : Nat) : Float :=
  m.theta * (p.toFloat * p.toFloat)

/-- One gradient-descent feedback step, mirroring `AdaptiveModel.updateTheta`. -/
def RuntimeModel.update (m : RuntimeModel) (p : Nat) (actual : Float) : RuntimeModel :=
  let c := p.toFloat * p.toFloat
  let residual := actual - m.predict p
  let gradient := -2.0 * residual * c
  { m with theta := m.theta - m.alpha * gradient }

/-- Run `task` `iterations` times after a warm-up and return the average wall-clock time per
iteration, in seconds. The results are accumulated through an `IO.Ref` so the compiler cannot
optimise the repeated calls away. -/
def benchmark (iterations : Nat) (task : Unit → Nat) : IO Float := do
  if iterations == 0 then return 0.0
  let _ := task ()                       -- warm-up (prime caches; result discarded)
  let acc ← IO.mkRef 0
  let start ← IO.monoNanosNow
  for _ in [0:iterations] do
    acc.modify (· + task ())             -- forces honest evaluation each iteration
  let stop ← IO.monoNanosNow
  let _ ← acc.get
  let totalNs := (stop - start).toFloat
  return (totalNs / iterations.toFloat) / 1.0e9

/-- Benchmark one prime, report predicted vs. measured time, and adapt the model. -/
def runBenchmarkAndAdapt (m : RuntimeModel) (p iterations : Nat)
    (task : Unit → Nat) : IO RuntimeModel := do
  let avg ← benchmark iterations task
  let predicted := m.predict p
  IO.println s!"  [p={p}] predicted={predicted}s  measured={avg}s"
  let m' := m.update p avg
  IO.println s!"    -> updated theta (×1e9) = {m'.theta * 1.0e9}"
  return m'

/-- The adaptive suite: sweep the supersingular primes `> 3`, benchmarking the real
`Monster.ssCountFp` payload and letting the model refine `θ` after every prime. -/
def runAdaptiveSuite : IO Unit := do
  IO.println "Adaptive runtime predictor over Monster.ssCountFp (cost model θ·p²):"
  let mut m : RuntimeModel := { theta := 1.0e-9, alpha := 1.0e-8 }
  for p in [5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71] do
    m ← runBenchmarkAndAdapt m p 200 (fun _ => Monster.ssCountFp p)
  IO.println s!"Final learned coefficient theta (×1e9) = {m.theta * 1.0e9}"

#eval runAdaptiveSuite

end AdaptiveBench