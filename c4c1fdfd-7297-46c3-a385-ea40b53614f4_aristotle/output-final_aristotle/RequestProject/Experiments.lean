/-
Original to this repository (not part of the upstream ZetaZeros development).
-/

import RequestProject.Experiments.Interface
import RequestProject.Experiments.ErrorFunction
import RequestProject.Experiments.Counting
import RequestProject.Experiments.GammaSequence
import RequestProject.Experiments.Lattice
import RequestProject.Experiments.ArgumentPrinciple
import RequestProject.Experiments.Batch
import RequestProject.Experiments.Independence

/-! # The experiment layer

This module gathers the formal side of the experiment laboratory described in
`docs/EXPERIMENTS.md`. The repository proves its six headline results *relative to* two analytic
inputs; the experiment layer fixes the interfaces along which contributors can attack, replace or
merely approximate those inputs, and — crucially — proves the statements that say what the
numerical dashboard in `web/experiments.html` can and cannot establish.

* `RequestProject.Experiments.Interface` — the Riemann–von Mangoldt input in every idiom a
  contributor might prove it in (`IsEquivalent`, little-o, `ε`-form, sharp main term), all shown
  equivalent, so no submission has to restate the hypothesis.
* `RequestProject.Experiments.ErrorFunction` — the shared candidate family
  `a·T log T + b·T + c·log T + d`, the shared error function, and the theorem
  (`tendsto_errRel`) that its limit is `1 - 2π·a`: the asymptotic criterion sees the leading
  coefficient alone, so the admissible set is a hyperplane in the parameter space and numerical
  ranking and formal ranking are different orders (`exists_inadmissible_err_zero`).
* `RequestProject.Experiments.Counting` — the zero-counting model problems: bounded-difference
  and floor models, and the asymptotic inversion theorem turning "the `n`-th zero sits at height
  `g n`" into "`N(T) ∼ M(T)`".
* `RequestProject.Experiments.Lattice` — the complexity lattice of coordinate faces: a larger face
  always fits at least as well (`faceError_anti`), while asymptotic correctness is available only
  on the faces containing the leading coefficient (`exists_admissible_onFace_iff`).
* `RequestProject.Experiments.GammaSequence` — the model in the form it is usually posed: a zero
  sequence with `γ_n ∼ 2π n / log n` has counting function `N(T) ∼ (T/2π) log T`.
* `RequestProject.Experiments.ArgumentPrinciple` — the toy argument principles: the algebraic
  count of the `n`-th roots of unity, and the contour count for `z ^ n` and for a polynomial in
  factored form.
-/
