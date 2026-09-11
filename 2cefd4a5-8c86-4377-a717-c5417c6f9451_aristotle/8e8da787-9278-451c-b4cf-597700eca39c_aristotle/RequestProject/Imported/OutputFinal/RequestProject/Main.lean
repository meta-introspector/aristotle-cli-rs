/-
Top-level import file for the formalization of

  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771.

Every module of the project is imported here, so that `lake build` of this file
elaborates the whole development, with two deliberate exceptions:

* `RequestProject.AxiomAudit`, which only runs `#print axioms` on the headline theorems
  (its output is the audit recorded in `RequestProject/VERIFICATION.md`), and
* `RequestProject.A5Artin`, a separate self-contained development (local Artin
  factorisation for `A₅`, backing `docs/A5_even_Artin.md` and `scripts/a5`) that is
  unrelated to the Weil-positivity chain.

Both are matched by the library glob `RequestProject.+`, so a plain `lake build`
elaborates them as well.

See `RequestProject/Skeleton.lean` for a summary of what is formalized and what is not,
including the record of the modules that were removed in the clean-up of the repository.
-/
import RequestProject.Imported.OutputFinal.RequestProject.Basic
import RequestProject.Imported.OutputFinal.RequestProject.SineIntegral
import RequestProject.Imported.OutputFinal.RequestProject.SiPositivity
import RequestProject.Imported.OutputFinal.RequestProject.SiSmooth
import RequestProject.Imported.OutputFinal.RequestProject.TraceRemainder
import RequestProject.Imported.OutputFinal.RequestProject.Sonin
import RequestProject.Imported.OutputFinal.RequestProject.Scaling
import RequestProject.Imported.OutputFinal.RequestProject.WeilDistribution
import RequestProject.Imported.OutputFinal.RequestProject.Mellin
import RequestProject.Imported.OutputFinal.RequestProject.JumpFormula
import RequestProject.Imported.OutputFinal.RequestProject.DeltaSmooth
import RequestProject.Imported.OutputFinal.RequestProject.RemainderBound
import RequestProject.Imported.OutputFinal.RequestProject.Positivity
import RequestProject.Imported.OutputFinal.RequestProject.KernelBound
import RequestProject.Imported.OutputFinal.RequestProject.Effective
import RequestProject.Imported.OutputFinal.RequestProject.FourierSide
import RequestProject.Imported.OutputFinal.RequestProject.Parseval
import RequestProject.Imported.OutputFinal.RequestProject.Digamma
import RequestProject.Imported.OutputFinal.RequestProject.DigammaAsymptotic
import RequestProject.Imported.OutputFinal.RequestProject.ArchimedeanKernel
import RequestProject.Imported.OutputFinal.RequestProject.ArchimedeanExplicit
import RequestProject.Imported.OutputFinal.RequestProject.DeltaDecay
import RequestProject.Imported.OutputFinal.RequestProject.ThetaGrowth
import RequestProject.Imported.OutputFinal.RequestProject.DeltaDecaySharp
import RequestProject.Imported.OutputFinal.RequestProject.DeltaVariation
import RequestProject.Imported.OutputFinal.RequestProject.FourierSideAnalysis
import RequestProject.Imported.OutputFinal.RequestProject.SiAsymptotic
import RequestProject.Imported.OutputFinal.RequestProject.TaylorBounds
import RequestProject.Imported.OutputFinal.RequestProject.CompactInterval
import RequestProject.Imported.OutputFinal.RequestProject.DeltaFourierZero
import RequestProject.Imported.OutputFinal.RequestProject.GammaBound
import RequestProject.Imported.OutputFinal.RequestProject.NearOrigin
import RequestProject.Imported.OutputFinal.RequestProject.MidThreshold
import RequestProject.Imported.OutputFinal.RequestProject.Skeleton
import RequestProject.Imported.OutputFinal.RequestProject.PolyaThreshold
import RequestProject.Imported.OutputFinal.RequestProject.PolyaOscThreshold
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLinThreshold
import RequestProject.Imported.OutputFinal.RequestProject.PolyaLowThreshold
import RequestProject.Imported.OutputFinal.RequestProject.FourierDecay
import RequestProject.Imported.OutputFinal.RequestProject.ArchimedeanPositivity
import RequestProject.Imported.OutputFinal.RequestProject.QuarticDecay
import RequestProject.Imported.OutputFinal.RequestProject.NormalizedPositivity
-- The refutation of the unnormalized positivity statement `LPositivity`.
import RequestProject.Imported.OutputFinal.RequestProject.UnnormalizedCounterexample
-- Operator-theoretic infrastructure originally intended for `L_positive`
-- (a statement now known to be false, see `RequestProject.UnnormalizedCounterexample`):
-- the integrated scaling representation, the convolution algebra of test functions,
-- the Sonin sandwich and the trace-class groundwork.
import RequestProject.Imported.OutputFinal.RequestProject.ScalingIntegrated
import RequestProject.Imported.OutputFinal.RequestProject.TestConvolution
import RequestProject.Imported.OutputFinal.RequestProject.SoninJoin
import RequestProject.Imported.OutputFinal.RequestProject.TraceClass
import RequestProject.Imported.OutputFinal.RequestProject.TraceProperty
import RequestProject.Imported.OutputFinal.RequestProject.TraceBasisIndep
import RequestProject.Imported.OutputFinal.RequestProject.TraceScaling
import RequestProject.Imported.OutputFinal.RequestProject.TracePositivity
import RequestProject.Imported.OutputFinal.RequestProject.SoninSandwich
-- Operator-theoretic infrastructure aimed at the *normalized* trace identity
-- `L_Norm(f) = Tr(ϑ(f) P P̂ P)`: the Hilbert–Schmidt criterion for kernel operators,
-- the identification of the `L²` Fourier transform with the Fourier integral, the
-- Hilbert–Schmidt property of `P̂₁ P₁` (hence trace-classness of the Sonin sandwich),
-- the logarithmic picture of the integrated scaling representation, and the statement of
-- the trace identity together with the positivity it yields.
import RequestProject.Imported.OutputFinal.RequestProject.HilbertSchmidtKernel
import RequestProject.Imported.OutputFinal.RequestProject.FourierL2Integral
import RequestProject.Imported.OutputFinal.RequestProject.CutoffHilbertSchmidt
import RequestProject.Imported.OutputFinal.RequestProject.LogPicture
import RequestProject.Imported.OutputFinal.RequestProject.TraceIdentityNorm
-- The paper's unitary identification of the two pictures (the "log picture" of §1),
-- the kernel form of the local trace formula, the structure of the trace density, and
-- the resulting refutation of the normalized trace identity with a fixed cutoff.
import RequestProject.Imported.OutputFinal.RequestProject.EvenPicture
import RequestProject.Imported.OutputFinal.RequestProject.TraceDensity
import RequestProject.Imported.OutputFinal.RequestProject.TraceDensitySymmetry
import RequestProject.Imported.OutputFinal.RequestProject.TraceIdentityObstruction
-- The renormalized-trace programme: the one-parameter family of cut-offs `P^{(Λ)}`,
-- `P̂^{(Λ)}`, the renormalized Sonin sandwich `S^{(Λ)} = P^{(Λ)} P̂^{(Λ)} P^{(Λ)}`, its
-- trace-classness, the strong exhaustion `S^{(Λ)} → 1`, the divergence of `Tr(S^{(Λ)})`,
-- and the renormalized trace functional with its logarithmic counter-term.
import RequestProject.Imported.OutputFinal.RequestProject.CutoffFamily
import RequestProject.Imported.OutputFinal.RequestProject.CutoffFamilyHS
import RequestProject.Imported.OutputFinal.RequestProject.CutoffExhaustion
import RequestProject.Imported.OutputFinal.RequestProject.TraceDivergence
import RequestProject.Imported.OutputFinal.RequestProject.RenormalizedTrace
import RequestProject.Imported.OutputFinal.RequestProject.RenormalizedTraceDensity
import RequestProject.Imported.OutputFinal.RequestProject.RenormalizedDensitySymmetry
import RequestProject.Imported.OutputFinal.RequestProject.RenormalizedDensityBound
import RequestProject.Imported.OutputFinal.RequestProject.RenormalizedTraceUniqueness
import RequestProject.Imported.OutputFinal.RequestProject.SemiLocalDiagonal
import RequestProject.Imported.OutputFinal.RequestProject.NearDiagonalKernel
-- The semi-local kernel in closed form, its off-diagonal limit (the archimedean Weil
-- kernel), and the extraction of the finite part of the renormalized cut-off trace.
import RequestProject.Imported.OutputFinal.RequestProject.SemiLocalKernel
import RequestProject.Imported.OutputFinal.RequestProject.SemiLocalSi
import RequestProject.Imported.OutputFinal.RequestProject.RenormalizedFinitePart
import RequestProject.Imported.OutputFinal.RequestProject.WeilKernelComparison
import RequestProject.Imported.OutputFinal.RequestProject.RenormalizedAsymptotics
import RequestProject.Imported.OutputFinal.RequestProject.CutoffLogProfileAux
import RequestProject.Imported.OutputFinal.RequestProject.CutoffLogProfile
-- The same analysis restricted to the even (Sonin) subspace: the even semi-local density,
-- the even cut-off trace with logarithmic coefficient exactly `2 f(1)`, and the value of
-- the remaining universal constant.
import RequestProject.Imported.OutputFinal.RequestProject.EvenSemiLocalKernel
import RequestProject.Imported.OutputFinal.RequestProject.EvenCutoffTrace
import RequestProject.Imported.OutputFinal.RequestProject.EvenConstantAux
import RequestProject.Imported.OutputFinal.RequestProject.EvenConstant
