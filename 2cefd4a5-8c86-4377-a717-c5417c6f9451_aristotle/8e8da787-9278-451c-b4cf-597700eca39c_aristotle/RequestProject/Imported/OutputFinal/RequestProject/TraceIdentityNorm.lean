/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The Sonin sandwich is trace class, and the statement of the normalized trace identity

  `L_Norm(f) = Tr(ϑ(f) P P̂ P)`

of arXiv:2006.13771 (Connes–Consani, *Weil positivity and Trace formula – the archimedean
place*).

Everything on the operator side is now available:

* `RequestProject/CutoffHilbertSchmidt.lean`: the operator `B = P̂₁ P₁` is Hilbert–Schmidt;
* `RequestProject/SoninJoin.lean`: the Sonin sandwich `P₁ P̂₁ P₁` equals `B* B`, hence it is
  a positive operator, and by the above it is **trace class** (`isTraceClass_soninSandwich`);
* `RequestProject/LogPicture.lean`: the integrated representation `ϑ(f)` acting on `L²(ℝ)`
  through a unitary identification `U` of `L²(ℝ⋆₊, d*ρ)` with `L²(ℝ)`, with
  `ϑ(g ∗ g^♯) = ϑ(g) ϑ(g)*`;
* `RequestProject/TracePositivity.lean`: `Re Tr((T T*)(B* B)) ≥ 0`.

Consequently `ϑ(f) P P̂ P` is trace class for every test function `f`, its trace does not
depend on the chosen Hilbert basis, and it is a nonnegative real number on the convolution
squares `f = g ∗ g^♯`; this is `re_traceAlong_thetaOp_convSquare_soninSandwich_nonneg`.

What is **not** proved here is the identification of that trace with the functional
`L_Norm` of the analytic part of the project: this is the local trace formula of the paper,
and it is the one remaining step of the operator route.  It is stated as the predicate
`NormalizedTraceIdentity U`, for a unitary identification `U` of the two pictures (the
identification of the paper is itself still to be constructed, which is why it is kept as a
parameter rather than fixed to the translation picture `logEquiv`), and the theorem
`LfunNorm_re_nonneg_of_normalizedTraceIdentity` shows that it does recover, through the
operator route, the positivity of `L_Norm` on convolution squares — the statement proved by
the analytic route in `RequestProject/ArchimedeanPositivity.lean`.  No claim about the
identity itself is made; it is an explicit hypothesis, never an axiom.
-/
import RequestProject.Imported.OutputFinal.RequestProject.CutoffHilbertSchmidt
import RequestProject.Imported.OutputFinal.RequestProject.LogPicture
import RequestProject.Imported.OutputFinal.RequestProject.SoninSandwich
import RequestProject.Imported.OutputFinal.RequestProject.TraceBasisIndep
import RequestProject.Imported.OutputFinal.RequestProject.ArchimedeanExplicit

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory ContinuousLinearMap

open scoped CompactlySupported

namespace ConnesConsani.WeilPositivity

variable {ι : Type*}

/-! ## The Sonin sandwich as a trace-class operator -/

/-- **The Sonin sandwich** `S = P₁ P̂₁ P₁`, the positive operator whose pairing with `ϑ(f)`
is the functional `L` of the paper. -/
def soninSandwich : L2R →L[ℂ] L2R := P1 ∘L P1hat ∘L P1

/-- `S = B* B` with `B = P̂₁ P₁`. -/
theorem soninSandwich_eq_adjoint_comp :
    soninSandwich = ContinuousLinearMap.adjoint (P1hat ∘L P1) ∘L (P1hat ∘L P1) :=
  P1_P1hat_P1_eq_adjoint_comp

/-- The Sonin sandwich is a positive operator. -/
theorem soninSandwich_isPositive : soninSandwich.IsPositive := P1_P1hat_P1_isPositive

/-- The Sonin sandwich is self-adjoint. -/
theorem soninSandwich_isSelfAdjoint : IsSelfAdjoint soninSandwich :=
  soninSandwich_isPositive.isSelfAdjoint

/-- **The Sonin sandwich is trace class.** -/
theorem isTraceClass_soninSandwich (b : HilbertBasis ι ℂ L2R) :
    IsTraceClass b soninSandwich := by
  have hB : IsHilbertSchmidt b (P1hat ∘L P1) := isHilbertSchmidt_P1hat_comp_P1 b
  rw [soninSandwich_eq_adjoint_comp]
  exact IsTraceClass.of_hilbertSchmidt_comp hB.adjoint hB

/-- **Any bounded operator times the Sonin sandwich is trace class.** -/
theorem isTraceClass_comp_soninSandwich (b : HilbertBasis ι ℂ L2R) (A : L2R →L[ℂ] L2R) :
    IsTraceClass b (A ∘L soninSandwich) := by
  have hB : IsHilbertSchmidt b (P1hat ∘L P1) := isHilbertSchmidt_P1hat_comp_P1 b
  refine ⟨A ∘L ContinuousLinearMap.adjoint (P1hat ∘L P1), P1hat ∘L P1,
    hB.adjoint.comp_left A, hB, ?_⟩
  rw [soninSandwich_eq_adjoint_comp, ContinuousLinearMap.comp_assoc]

/-- **The sandwich `ϑ(f) P P̂ P` is trace class** for every continuous compactly supported
test function `f` — in particular for the convolution squares `f = g ∗ g^♯`. -/
theorem isTraceClass_thetaOp_soninSandwich (b : HilbertBasis ι ℂ L2R)
    (U : L2Rplus ≃ₗᵢ[ℂ] L2R) (g : C_c(Rplus, ℂ)) :
    IsTraceClass b (thetaOpOf U g ∘L soninSandwich) :=
  isTraceClass_comp_soninSandwich b (thetaOpOf U g)

/-- Its trace series converges absolutely. -/
theorem summable_norm_inner_thetaOp_soninSandwich (b : HilbertBasis ι ℂ L2R)
    (U : L2Rplus ≃ₗᵢ[ℂ] L2R) (g : C_c(Rplus, ℂ)) :
    Summable fun i => ‖inner ℂ (b i) ((thetaOpOf U g ∘L soninSandwich) (b i))‖ :=
  summable_norm_inner_of_isTraceClass (isTraceClass_thetaOp_soninSandwich b U g)

/-- Its trace does not depend on the chosen Hilbert basis. -/
theorem traceAlong_thetaOp_soninSandwich_basis_indep {κ : Type*} (b : HilbertBasis ι ℂ L2R)
    (c : HilbertBasis κ ℂ L2R) (U : L2Rplus ≃ₗᵢ[ℂ] L2R) (g : C_c(Rplus, ℂ)) :
    traceAlong b (thetaOpOf U g ∘L soninSandwich)
      = traceAlong c (thetaOpOf U g ∘L soninSandwich) :=
  traceAlong_basis_indep_of_isTraceClass b c (isTraceClass_thetaOp_soninSandwich b U g)

/-! ## Positivity of the trace on convolution squares -/

/-- **`Tr(ϑ(g ∗ g^♯) P P̂ P) ≥ 0`**: the trace of the sandwich is a nonnegative real number
on the positive elements `g ∗ g^♯` of the convolution algebra.  This is the operator-side
positivity that the trace formula of the paper turns into the positivity of `L`. -/
theorem re_traceAlong_thetaOp_convSquare_soninSandwich_nonneg (b : HilbertBasis ι ℂ L2R)
    (U : L2Rplus ≃ₗᵢ[ℂ] L2R) (g : C_c(Rplus, ℂ)) :
    0 ≤ (traceAlong b (thetaOpOf U (testConv g (starTest g)) ∘L soninSandwich)).re := by
  rw [thetaOpOf_testConv_starTest, soninSandwich]
  exact re_traceAlong_soninSandwich_nonneg b (thetaOpOf U g) (isHilbertSchmidt_P1hat_comp_P1 b)

/-! ## Norm bound for the sandwich, and linearity of the trace functional -/

/-- A self-adjoint idempotent is a contraction. -/
theorem norm_apply_le_of_isIdempotentElem_of_isSelfAdjoint {E : Type*} [NormedAddCommGroup E]
    [InnerProductSpace ℂ E] [CompleteSpace E] {P : E →L[ℂ] E} (hi : IsIdempotentElem P)
    (hs : IsSelfAdjoint P) (x : E) : ‖P x‖ ≤ ‖x‖ := by
  have hadj : ContinuousLinearMap.adjoint P = P := hs
  have hPP : P (P x) = P x := congrFun (congrArg (fun T : E →L[ℂ] E => (T : E → E)) hi) x
  have h0 := ContinuousLinearMap.adjoint_inner_left P (P x) x
  rw [hadj, hPP] at h0
  have key : ‖P x‖ * ‖P x‖ ≤ ‖x‖ * ‖P x‖ := by
    calc ‖P x‖ * ‖P x‖ = ‖(inner ℂ (P x) (P x) : ℂ)‖ := by simp [pow_two]
      _ = ‖(inner ℂ x (P x) : ℂ)‖ := by rw [h0]
      _ ≤ ‖x‖ * ‖P x‖ := norm_inner_le_norm _ _
  rcases eq_or_lt_of_le (norm_nonneg (P x)) with h | h
  · rw [← h]; exact norm_nonneg x
  · exact le_of_mul_le_mul_right key h

/-- `P₁` is a contraction. -/
theorem norm_P1_apply_le (x : L2R) : ‖P1 x‖ ≤ ‖x‖ :=
  norm_apply_le_of_isIdempotentElem_of_isSelfAdjoint P1_idempotent P1_selfAdjoint x

/-- `P̂₁` is a contraction. -/
theorem norm_P1hat_apply_le (x : L2R) : ‖P1hat x‖ ≤ ‖x‖ :=
  norm_apply_le_of_isIdempotentElem_of_isSelfAdjoint P1hat_idempotent P1hat_selfAdjoint x

/-- The Sonin sandwich is a contraction: `‖P₁ P̂₁ P₁ ξ‖ ≤ ‖ξ‖`. -/
theorem norm_soninSandwich_apply_le (x : L2R) : ‖soninSandwich x‖ ≤ ‖x‖ :=
  (norm_P1_apply_le _).trans ((norm_P1hat_apply_le _).trans (norm_P1_apply_le x))

/-- `‖P₁ P̂₁ P₁‖ ≤ 1`. -/
theorem norm_soninSandwich_le_one : ‖soninSandwich‖ ≤ 1 :=
  ContinuousLinearMap.opNorm_le_bound _ zero_le_one fun x => by
    simpa using norm_soninSandwich_apply_le x

/-- The trace is additive on trace-class operators. -/
theorem traceAlong_add_of_isTraceClass {E : Type*} [NormedAddCommGroup E]
    [InnerProductSpace ℂ E] [CompleteSpace E] {κ : Type*} {b : HilbertBasis κ ℂ E}
    {A B : E →L[ℂ] E} (hA : IsTraceClass b A) (hB : IsTraceClass b B) :
    traceAlong b (A + B) = traceAlong b A + traceAlong b B := by
  have hA' : Summable fun i => (inner ℂ (b i) (A (b i)) : ℂ) :=
    (summable_norm_inner_of_isTraceClass hA).of_norm
  have hB' : Summable fun i => (inner ℂ (b i) (B (b i)) : ℂ) :=
    (summable_norm_inner_of_isTraceClass hB).of_norm
  simp only [traceAlong, ContinuousLinearMap.add_apply, inner_add_right]
  exact hA'.tsum_add hB'

/-- The trace is homogeneous. -/
theorem traceAlong_smul {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℂ E]
    [CompleteSpace E] {κ : Type*} (b : HilbertBasis κ ℂ E) (c : ℂ) (A : E →L[ℂ] E) :
    traceAlong b (c • A) = c * traceAlong b A := by
  simp only [traceAlong, ContinuousLinearMap.smul_apply, inner_smul_right]
  exact tsum_mul_left

/-- **The trace functional `f ↦ Tr(ϑ(f) P P̂ P)` is additive.** -/
theorem traceAlong_thetaOp_soninSandwich_add (b : HilbertBasis ι ℂ L2R)
    (U : L2Rplus ≃ₗᵢ[ℂ] L2R) (g₁ g₂ : C_c(Rplus, ℂ)) :
    traceAlong b (thetaOpOf U (g₁ + g₂) ∘L soninSandwich)
      = traceAlong b (thetaOpOf U g₁ ∘L soninSandwich)
        + traceAlong b (thetaOpOf U g₂ ∘L soninSandwich) := by
  rw [thetaOpOf_add, ContinuousLinearMap.add_comp]
  exact traceAlong_add_of_isTraceClass (isTraceClass_thetaOp_soninSandwich b U g₁)
    (isTraceClass_thetaOp_soninSandwich b U g₂)

/-- **The trace functional `f ↦ Tr(ϑ(f) P P̂ P)` is homogeneous.** -/
theorem traceAlong_thetaOp_soninSandwich_smul (b : HilbertBasis ι ℂ L2R)
    (U : L2Rplus ≃ₗᵢ[ℂ] L2R) (c : ℂ) (g : C_c(Rplus, ℂ)) :
    traceAlong b (thetaOpOf U (c • g) ∘L soninSandwich)
      = c * traceAlong b (thetaOpOf U g ∘L soninSandwich) := by
  rw [thetaOpOf_smul, ContinuousLinearMap.smul_comp, traceAlong_smul]

/-! ## The normalized trace identity -/

/-- **The normalized trace identity** `L_Norm(f) = Tr(ϑ(f) P P̂ P)` of the paper, as a
predicate.  On the left is the functional `LfunNorm` of the analytic part of the project
(the functional `L = D + W_∞` of §2 in the `∆^{1/2}` normalization), evaluated on the test
function read in logarithmic coordinates; on the right is the trace of the sandwich
`ϑ(f) P₁ P̂₁ P₁` on `L²(ℝ)`, which is well defined by
`isTraceClass_thetaOp_soninSandwich` and `traceAlong_thetaOp_soninSandwich_basis_indep`.

This identity is *not* proved here: it is the local trace formula at the archimedean place,
the one remaining step of the operator route. -/
def NormalizedTraceIdentity (U : L2Rplus ≃ₗᵢ[ℂ] L2R) : Prop :=
  ∀ {ι : Type} (b : HilbertBasis ι ℂ L2R) (g : C_c(Rplus, ℂ)),
    LfunNorm (logTest g) = traceAlong b (thetaOpOf U g ∘L soninSandwich)

/-- **The operator route to the normalized positivity.**  Granted the trace identity, the
positivity of `L_Norm` on convolution squares follows from the operator-theoretic
positivity of the trace of `ϑ(g) ϑ(g)* P P̂ P`.  (The same conclusion is proved
unconditionally, by the analytic route, in `RequestProject/ArchimedeanPositivity.lean` for
`C²` test functions; this is the operator-theoretic derivation of it.) -/
theorem LfunNorm_re_nonneg_of_normalizedTraceIdentity {U : L2Rplus ≃ₗᵢ[ℂ] L2R}
    (h : NormalizedTraceIdentity U) (g : C_c(Rplus, ℂ)) :
    0 ≤ (LfunNorm (convLog (logTest g) (starLog (logTest g)))).re := by
  obtain ⟨w, b, -⟩ := exists_hilbertBasis ℂ L2R
  have hlog : convLog (logTest g) (starLog (logTest g)) = logTest (testConv g (starTest g)) := by
    rw [logTest_testConv, logTest_starTest]
  rw [hlog, h b (testConv g (starTest g))]
  exact re_traceAlong_thetaOp_convSquare_soninSandwich_nonneg b U g

end ConnesConsani.WeilPositivity
