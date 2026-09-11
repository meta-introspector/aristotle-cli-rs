/-
# MetricEngineMonoidal — a monoidal composition of engines and the Clifford metric

`RequestProject.Math.Bridge.CliffordMetricLift` isolated the **Clifford metric**
— the anticommutator of two address generators, which equals the polarized
quadratic form realized as a scalar (`cliffordMetric_eq_polar`).  This file
executes the roadmap step **"a monoidal composition structure tracking how
tensoring engines affects the Clifford-metric invariants"**.

## The objects

A `MetricEngine R` bundles the data needed to read off a Clifford metric: a
module `Carrier` over `R`, a quadratic form `form` on it, and a generator family
`gen : ℕ → Carrier`.  Its **metric invariant** `MetricEngine.metric e m n` is the
polar form `polar e.form (e.gen m) (e.gen n)` — exactly the scalar that
`cliffordMetric` of the two generators reduces to (`metric_eq_cliffordMetric`).

## The monoidal composition

`MetricEngine.tensor` composes two engines on the direct-sum module
`e₁.Carrier × e₂.Carrier`, with the orthogonal-sum quadratic form
`e₁.form.prod e₂.form` and the diagonal generator family.  The headline tracking
theorem is

```
(e₁.tensor e₂).metric m n = e₁.metric m n + e₂.metric m n,
```

i.e. **the Clifford-metric invariant is additive under monoidal composition of
engines** (`MetricEngine.tensor_metric`).  From this the structure inherits the
usual monoidal laws *at the level of the metric invariant*:

* **Unit** — `unitEngine` (the zero form on the trivial module) is a two-sided
  unit: tensoring with it leaves every metric unchanged
  (`unitEngine_metric`, `tensor_unit_metric`, `unit_tensor_metric`).
* **Symmetry** — `tensor_metric_comm`: the metric of `e₁ ⊗ e₂` equals that of
  `e₂ ⊗ e₁`.
* **Associativity** — `tensor_metric_assoc`: both bracketings of a triple tensor
  have the same metric, namely the threefold sum of the factors' metrics
  (`tensor_metric_triple`).

Finally `tensor_cliffordMetric` lifts the additivity back to the genuine Clifford
algebra: the anticommutator of the composite generators is the scalar
`algebraMap (e₁.metric m n + e₂.metric m n)`.
-/

import Mathlib
import RequestProject.Math.Bridge.CliffordMetricLift

namespace RequestProject.Compute.CFT

open QuadraticMap

universe u

/-! ## §1. Metric engines -/

/-- A **metric engine** over `R`: a module with a quadratic form and a generator
    family.  It carries exactly the data from which a Clifford metric is read. -/
structure MetricEngine (R : Type u) [CommRing R] : Type (u + 1) where
  /-- The underlying module of the engine. -/
  Carrier : Type u
  [acg : AddCommGroup Carrier]
  [mod : Module R Carrier]
  /-- The quadratic form (metric data) carried by the engine. -/
  form : QuadraticForm R Carrier
  /-- The address-indexed generator family. -/
  gen : ℕ → Carrier

attribute [instance] MetricEngine.acg MetricEngine.mod

variable {R : Type u} [CommRing R]

/-- The **Clifford-metric invariant** of an engine between two address
    generators: the polar form of the two generator vectors. -/
def MetricEngine.metric (e : MetricEngine R) (m n : ℕ) : R :=
  QuadraticMap.polar e.form (e.gen m) (e.gen n)

/-- The metric invariant is symmetric (the polar form is symmetric). -/
theorem MetricEngine.metric_symm (e : MetricEngine R) (m n : ℕ) :
    e.metric m n = e.metric n m := by
  unfold MetricEngine.metric; rw [QuadraticMap.polar_comm]

/-- The engine's metric invariant is exactly the scalar that the Clifford metric
    (anticommutator) of its two generators reduces to. -/
theorem MetricEngine.metric_eq_cliffordMetric (e : MetricEngine R) (m n : ℕ) :
    cliffordMetric e.form e.gen m n
      = (algebraMap R (CliffordAlgebra e.form)) (e.metric m n) :=
  cliffordMetric_eq_polar e.form e.gen m n

/-! ## §2. The monoidal composition (orthogonal-sum tensor) -/

/-- The **monoidal composition** of two engines: the orthogonal direct sum of the
    underlying quadratic modules, with the diagonal generator family. -/
def MetricEngine.tensor (e₁ e₂ : MetricEngine R) : MetricEngine R where
  Carrier := e₁.Carrier × e₂.Carrier
  form := e₁.form.prod e₂.form
  gen := fun n => (e₁.gen n, e₂.gen n)

@[inherit_doc] infixl:70 " ⊗ₘ " => MetricEngine.tensor

/-- **The Clifford-metric invariant is additive under monoidal composition.** -/
theorem MetricEngine.tensor_metric (e₁ e₂ : MetricEngine R) (m n : ℕ) :
    (e₁ ⊗ₘ e₂).metric m n = e₁.metric m n + e₂.metric m n := by
  simp only [MetricEngine.tensor, MetricEngine.metric, QuadraticMap.polar,
    QuadraticMap.prod_apply, Prod.fst_add, Prod.snd_add]
  ring

/-! ## §3. The monoidal unit -/

/-- The **monoidal unit**: the zero quadratic form on the trivial module. -/
def unitEngine (R : Type u) [CommRing R] : MetricEngine R where
  Carrier := PUnit
  form := 0
  gen := fun _ => PUnit.unit

/-- The unit engine has vanishing metric. -/
@[simp] theorem unitEngine_metric (m n : ℕ) : (unitEngine R).metric m n = 0 := by
  simp [MetricEngine.metric, unitEngine, QuadraticMap.polar]

/-- **Right unit law (on the metric).**  Tensoring with the unit on the right
    leaves every metric invariant unchanged. -/
theorem MetricEngine.tensor_unit_metric (e : MetricEngine R) (m n : ℕ) :
    (e ⊗ₘ unitEngine R).metric m n = e.metric m n := by
  rw [MetricEngine.tensor_metric, unitEngine_metric, add_zero]

/-- **Left unit law (on the metric).**  Tensoring with the unit on the left
    leaves every metric invariant unchanged. -/
theorem MetricEngine.unit_tensor_metric (e : MetricEngine R) (m n : ℕ) :
    (unitEngine R ⊗ₘ e).metric m n = e.metric m n := by
  rw [MetricEngine.tensor_metric, unitEngine_metric, zero_add]

/-! ## §4. Symmetry and associativity of the composition -/

/-- **Symmetry (on the metric).**  The composite metric is independent of the
    order of composition. -/
theorem MetricEngine.tensor_metric_comm (e₁ e₂ : MetricEngine R) (m n : ℕ) :
    (e₁ ⊗ₘ e₂).metric m n = (e₂ ⊗ₘ e₁).metric m n := by
  rw [MetricEngine.tensor_metric, MetricEngine.tensor_metric, add_comm]

/-- The metric of a triple composition is the threefold sum of the factor
    metrics. -/
theorem MetricEngine.tensor_metric_triple (e₁ e₂ e₃ : MetricEngine R) (m n : ℕ) :
    ((e₁ ⊗ₘ e₂) ⊗ₘ e₃).metric m n
      = e₁.metric m n + e₂.metric m n + e₃.metric m n := by
  rw [MetricEngine.tensor_metric, MetricEngine.tensor_metric]

/-- **Associativity (on the metric).**  The two bracketings of a triple
    composition carry the same metric invariant. -/
theorem MetricEngine.tensor_metric_assoc (e₁ e₂ e₃ : MetricEngine R) (m n : ℕ) :
    ((e₁ ⊗ₘ e₂) ⊗ₘ e₃).metric m n = (e₁ ⊗ₘ (e₂ ⊗ₘ e₃)).metric m n := by
  rw [MetricEngine.tensor_metric, MetricEngine.tensor_metric,
    MetricEngine.tensor_metric, MetricEngine.tensor_metric, add_assoc]

/-! ## §5. Lifting additivity back to the Clifford algebra -/

/-- **The composite anticommutator is the sum of the factor metrics, as a
    scalar.**  The Clifford metric of the composite engine's generators equals
    `algebraMap (e₁.metric m n + e₂.metric m n)` in the composite Clifford
    algebra. -/
theorem MetricEngine.tensor_cliffordMetric (e₁ e₂ : MetricEngine R) (m n : ℕ) :
    cliffordMetric (e₁ ⊗ₘ e₂).form (e₁ ⊗ₘ e₂).gen m n
      = (algebraMap R (CliffordAlgebra (e₁ ⊗ₘ e₂).form))
          (e₁.metric m n + e₂.metric m n) := by
  rw [(e₁ ⊗ₘ e₂).metric_eq_cliffordMetric m n, MetricEngine.tensor_metric]

/-! ## §6. A worked example: doubling an engine -/

/-- Self-composition doubles every metric invariant: `(e ⊗ₘ e).metric = 2 • e.metric`. -/
theorem MetricEngine.tensor_self_metric (e : MetricEngine R) (m n : ℕ) :
    (e ⊗ₘ e).metric m n = 2 * e.metric m n := by
  rw [MetricEngine.tensor_metric, two_mul]

end RequestProject.Compute.CFT
