/-
Original to this repository (not part of the upstream ZetaZeros development).
-/

import RequestProject.Analysis.ArgumentPrinciple
import RequestProject.Analysis.RectangleArgumentPrinciple
import RequestProject.Analysis.StirlingGamma
import RequestProject.Analysis.ZetaArgumentPrinciple

/-! # The analytic infrastructure layer

The two pieces of general analytic machinery that the derivation of the Riemann–von Mangoldt
formula needs and that the pinned Mathlib does not provide, together with their first application
to the Riemann zeta function:

* `RequestProject/Analysis/ArgumentPrinciple.lean` — the argument principle for holomorphic
  functions on a disc: `∮ f'/f` counts the zeros inside, with multiplicity. This supersedes the
  toy instances of `RequestProject/Experiments/ArgumentPrinciple.lean`.
* `RequestProject/Analysis/StirlingGamma.lean` — Stirling's asymptotic for `log Γ` on the real
  axis, proved from Mathlib's Stirling formula for factorials and the log-convexity of `Γ`.
* `RequestProject/Analysis/ZetaArgumentPrinciple.lean` — the argument principle for `riemannZeta`,
  stated with the multiplicity `ZetaZeros.zeroMultiplicity` used by the headline results.

Everything here is unconditional: no external input is assumed.
-/
