/-
# CliffordMetricLift — the Clifford *metric* under address-preserving lifts

`RequestProject.Math.Bridge.CliffordMorphismLift` established the morphism
dichotomy for the scale tower: address-preserving scale morphisms lift to an
honest algebra homomorphism of the `CliffordAlgebra`, while merely
weight-preserving morphisms (e.g. `swapHom`) need not.  This file zooms in on the
*metric* — the quadratic / polar structure carried by the Clifford algebra — and
records exactly how it transforms under those lifts.

## The Clifford metric

For a quadratic form `Q : QuadraticForm R M` and a chosen generator family
`b : ℕ → M`, the **Clifford metric** between two address generators `m, n` is the
anticommutator

```
cliffordMetric Q b m n = ι_Q (b m) * ι_Q (b n) + ι_Q (b n) * ι_Q (b m)
```

which, by the defining relation of the Clifford algebra
(`CliffordAlgebra.ι_mul_ι_add_swap`), equals the scalar
`algebraMap R (polar Q (b m) (b n))`.  So the anticommutator of two generators
*is* the polarized quadratic form — the genuine metric of the geometry.

## What is built here

1. `cliffordMetric` and `cliffordMetric_eq_polar` — the anticommutator of two
   generators is the polar form, realized as a scalar of the algebra.

2. **Address-preserving lifts are isometries.**  An address-preserving morphism
   preserves every piece of the metric *for every* `Q` and `b`:
   * the quadratic value of a generator (`IsAddrPreserving.quadratic_eq`),
   * the polar form (`IsAddrPreserving.polar_eq`),
   * the Clifford metric / anticommutator (`IsAddrPreserving.cliffordMetric_eq`),
   * the Clifford square of a blade (`IsAddrPreserving.bladeSq_eq`),
   and the lifted algebra homomorphism intertwines the metric
   (`IsAddrPreserving.lift_cliffordMetric`).

3. **Weight-preservation is not enough.**  `swapHom` (the weight-preserving
   address swap `196883 ↔ 196885`) fails to be an isometry: there is a quadratic
   form and generator family for which it changes the quadratic value of the
   generator (`swapHom_not_isometry`).  Hence weight-preservation alone does not
   descend to a metric-preserving map of the Clifford algebra.
-/

import Mathlib
import RequestProject.Compute.ScaleCategory
import RequestProject.Math.Bridge.CliffordBladeEmbedding
import RequestProject.Math.Bridge.CliffordMorphismLift

namespace RequestProject.Compute.CFT

open RequestProject.Compute.DistanceFromJ
open CategoryTheory

/-! ## §1. The Clifford metric of two generators -/

section Metric

variable {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]

/-- The **Clifford metric** between two address generators `m, n`: the
    anticommutator of the corresponding generator vectors in `CliffordAlgebra Q`. -/
noncomputable def cliffordMetric (Q : QuadraticForm R M) (b : ℕ → M) (m n : ℕ) :
    CliffordAlgebra Q :=
  CliffordAlgebra.ι Q (b m) * CliffordAlgebra.ι Q (b n)
    + CliffordAlgebra.ι Q (b n) * CliffordAlgebra.ι Q (b m)

/-- The Clifford metric is the polarized quadratic form realized as a scalar: the
    anticommutator of two generators equals `algebraMap (polar Q (b m) (b n))`.
    This is the defining relation of the Clifford geometry. -/
theorem cliffordMetric_eq_polar (Q : QuadraticForm R M) (b : ℕ → M) (m n : ℕ) :
    cliffordMetric Q b m n
      = (algebraMap R (CliffordAlgebra Q)) (QuadraticMap.polar (⇑Q) (b m) (b n)) :=
  CliffordAlgebra.ι_mul_ι_add_swap (b m) (b n)

/-- The Clifford metric is symmetric (the polar form is symmetric). -/
theorem cliffordMetric_symm (Q : QuadraticForm R M) (b : ℕ → M) (m n : ℕ) :
    cliffordMetric Q b m n = cliffordMetric Q b n m := by
  unfold cliffordMetric; rw [add_comm]

/-- The diagonal of the metric is twice the quadratic value: the anticommutator of
    a generator with itself is `2 • Q (b n)` as a scalar. -/
theorem cliffordMetric_self (Q : QuadraticForm R M) (b : ℕ → M) (n : ℕ) :
    cliffordMetric Q b n n
      = (algebraMap R (CliffordAlgebra Q)) (2 • Q (b n)) := by
  rw [cliffordMetric_eq_polar, QuadraticMap.polar_self]

end Metric

/-! ## §2. Address-preserving lifts are isometries -/

section Isometry

variable {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]

/-- An address-preserving morphism preserves the quadratic value of each
    generator, for **every** quadratic form and generator family. -/
theorem ScaleHom.IsAddrPreserving.quadratic_eq (Q : QuadraticForm R M) (b : ℕ → M)
    {s t : Scale} {f : ScaleHom s t} (hf : f.IsAddrPreserving) (n : ℕ) :
    Q (b (f.map n)) = Q (b n) := by
  rw [hf n]

/-- An address-preserving morphism preserves the polar form between any two
    generators. -/
theorem ScaleHom.IsAddrPreserving.polar_eq (Q : QuadraticForm R M) (b : ℕ → M)
    {s t : Scale} {f : ScaleHom s t} (hf : f.IsAddrPreserving) (m n : ℕ) :
    QuadraticMap.polar (⇑Q) (b (f.map m)) (b (f.map n))
      = QuadraticMap.polar (⇑Q) (b m) (b n) := by
  rw [hf m, hf n]

/-- **Address-preserving lifts are isometries.**  The Clifford metric
    (anticommutator) between two generators is unchanged after relabelling along
    an address-preserving morphism. -/
theorem ScaleHom.IsAddrPreserving.cliffordMetric_eq (Q : QuadraticForm R M) (b : ℕ → M)
    {s t : Scale} {f : ScaleHom s t} (hf : f.IsAddrPreserving) (m n : ℕ) :
    cliffordMetric Q b (f.map m) (f.map n) = cliffordMetric Q b m n := by
  rw [cliffordMetric_eq_polar, cliffordMetric_eq_polar, hf.polar_eq Q b m n]

/-- An address-preserving morphism preserves the Clifford square of a blade
    element (the full multivector, not just a generator). -/
theorem ScaleHom.IsAddrPreserving.bladeSq_eq (Q : QuadraticForm R M) (b : ℕ → M)
    {s t : Scale} {f : ScaleHom s t} (hf : f.IsAddrPreserving) (n : ℕ) :
    bladeElement Q b (f.map n) * bladeElement Q b (f.map n)
      = bladeElement Q b n * bladeElement Q b n := by
  rw [hf.bladeElement_eq Q b n]

/-- The lifted algebra homomorphism (the identity automorphism realizing an
    address-preserving morphism) **intertwines the Clifford metric**: applying the
    lift to the metric of `(m, n)` yields the metric of the relabelled
    `(f.map m, f.map n)`. -/
theorem ScaleHom.IsAddrPreserving.lift_cliffordMetric (Q : QuadraticForm R M) (b : ℕ → M)
    {s t : Scale} {f : ScaleHom s t} (hf : f.IsAddrPreserving) (m n : ℕ) :
    (AlgHom.id R (CliffordAlgebra Q)) (cliffordMetric Q b m n)
      = cliffordMetric Q b (f.map m) (f.map n) := by
  rw [AlgHom.id_apply, hf.cliffordMetric_eq Q b m n]

end Isometry

/-! ## §3. Weight-preservation is not enough: `swapHom` is not an isometry -/

/-- A generator family on `ℝ` distinguishing the two swapped addresses: it sends
    `196885` to `0` and every other address to `1`. -/
noncomputable def swapWitnessGen (n : ℕ) : ℝ := if n = 196885 then 0 else 1

/-- **Weight-preservation does not imply isometry.**  The weight-preserving swap
    `swapHom` changes the quadratic value of a generator: with the squaring form
    on `ℝ` and the witness family, the generator at `196883` has value `1`, but its
    image `swapHom.map 196883 = 196885` has value `0`. -/
theorem swapHom_not_isometry :
    ∃ (Q : QuadraticForm ℝ ℝ) (b : ℕ → ℝ),
      Q (b (swapHom.map 196883)) ≠ Q (b 196883) := by
  refine ⟨QuadraticMap.sq, swapWitnessGen, ?_⟩
  rw [swapHom_map_196883]
  unfold swapWitnessGen
  norm_num [QuadraticMap.sq]

end RequestProject.Compute.CFT
