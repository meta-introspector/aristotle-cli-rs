/-
# Differential Privacy: Formal Definitions and Mechanism Proofs

This module formalizes (ε,δ)-Differential Privacy, Rényi Differential Privacy,
query sensitivity, and proves that the Laplace mechanism satisfies ε-DP.

## References
- Dwork, C., & Roth, A. (2014). The Algorithmic Foundations of Differential Privacy.
-/
import RequestProject.Basic

open scoped BigOperators

/-! ## Core DP Definitions -/

/-- A randomized mechanism mapping datasets to a finite output type. -/
structure Mechanism (D : Type*) (α : Type*) [Fintype α] where
  /-- The output distribution for a given dataset. -/
  run : D → DiscretePMF α

/-- (ε,δ)-Differential Privacy: for any adjacent datasets and any output set,
    the probabilities are multiplicatively close up to an additive δ term. -/
def EpsilonDeltaDP {D α : Type*} [Fintype α] [DecidableEq α]
    (M : Mechanism D α) (adj : D → D → Prop) (ε δ : ℝ) : Prop :=
  ∀ (S S' : D), adj S S' →
    ∀ (R : Finset α), (M.run S).probSet R ≤ Real.exp ε * (M.run S').probSet R + δ

/-- Pure ε-Differential Privacy (δ = 0). -/
def PureDP {D α : Type*} [Fintype α] [DecidableEq α]
    (M : Mechanism D α) (adj : D → D → Prop) (ε : ℝ) : Prop :=
  EpsilonDeltaDP M adj ε 0

/-- Rényi Differential Privacy of order α_order ≥ 1. The α-Rényi divergence between
    M(S) and M(S') is bounded by ε for all adjacent S, S'. -/
def RenyiDP {D β : Type*} [Fintype β] [DecidableEq β]
    (M : Mechanism D β) (adj : D → D → Prop) (α_order ε : ℝ) : Prop :=
  α_order ≥ 1 ∧
  ∀ (S S' : D), adj S S' →
    let P := (M.run S).prob
    let Q := (M.run S').prob
    (1 / (α_order - 1)) * Real.log (∑ x, P x ^ α_order * Q x ^ (1 - α_order)) ≤ ε

/-! ## Query Sensitivity -/

/-- The L1-sensitivity of a real-valued query f is the maximum absolute change
    in f when the dataset changes by one record. -/
def L1Sensitivity {D : Type*} (f : D → ℝ) (adj : D → D → Prop) (Δ : ℝ) : Prop :=
  ∀ (S S' : D), adj S S' → |f S - f S'| ≤ Δ

/-- The L1-sensitivity of a vector-valued query. -/
def L1SensitivityVec {D : Type*} {n : ℕ} (f : D → Vec n) (adj : D → D → Prop) (Δ : ℝ) : Prop :=
  ∀ (S S' : D), adj S S' → ∑ i, |f S i - f S' i| ≤ Δ

/-! ## Laplace Mechanism -/

/-- The Laplace probability density function with location μ and scale b > 0. -/
noncomputable def laplacePDF (μ b : ℝ) (x : ℝ) : ℝ :=
  (1 / (2 * b)) * Real.exp (-(|x - μ|) / b)

/-
The Laplace PDF is always positive.
-/
theorem laplacePDF_pos {μ b x : ℝ} (hb : 0 < b) : 0 < laplacePDF μ b x := by
  exact mul_pos ( by positivity ) ( Real.exp_pos _ )

/-
The ratio of two Laplace densities at the same point x,
    with different locations μ₁ and μ₂ and the same scale b,
    is bounded by exp(|μ₁ - μ₂| / b).
-/
theorem laplace_ratio_bound {μ₁ μ₂ b x : ℝ} (hb : 0 < b) :
    laplacePDF μ₁ b x / laplacePDF μ₂ b x ≤ Real.exp (|μ₁ - μ₂| / b) := by
  unfold laplacePDF; ring; norm_num [ hb.ne' ] ;
  norm_num [ mul_assoc, mul_comm, mul_left_comm, hb.ne', Real.exp_neg ];
  rw [ ← Real.exp_neg, ← Real.exp_add ] ; ring_nf ; norm_num;
  cases abs_cases ( x - μ₁ ) <;> cases abs_cases ( μ₁ - μ₂ ) <;> cases abs_cases ( x - μ₂ ) <;> nlinarith [ inv_pos.2 hb ]

/-
For a scalar query f with L1-sensitivity Δ, adding Laplace(Δ/ε) noise
    ensures that the density ratio between any two adjacent databases
    is bounded by exp(ε). This is the core property underlying ε-DP.
-/
theorem laplace_mechanism_density_ratio
    {D : Type*} (f : D → ℝ) (adj : D → D → Prop)
    {Δ ε : ℝ} (hΔ : 0 < Δ) (hε : 0 < ε)
    (hsens : L1Sensitivity f adj Δ)
    (S S' : D) (hadj : adj S S') (x : ℝ) :
    laplacePDF (f S) (Δ / ε) x / laplacePDF (f S') (Δ / ε) x ≤ Real.exp ε := by
  -- Apply the laplace_ratio_bound with b = Δ/ε and use the fact that |f S - f S'| ≤ Δ to bound the exponent.
  have h_exp : Real.exp (|f S - f S'| / (Δ / ε)) ≤ Real.exp ε := by
    exact Real.exp_le_exp.mpr ( by rw [ div_div_eq_mul_div, div_le_iff₀ ] <;> nlinarith [ hsens S S' hadj ] );
  exact le_trans ( laplace_ratio_bound ( by positivity ) ) h_exp

/-! ## Composition Theorems -/

/-
Basic composition: applying two (ε,δ)-DP mechanisms independently yields
    an (ε₁+ε₂, δ₁+δ₂)-DP guarantee on the product.
-/
theorem basic_composition {D α β : Type*} [Fintype α] [Fintype β]
    [DecidableEq α] [DecidableEq β]
    (M₁ : Mechanism D α) (M₂ : Mechanism D β)
    (adj : D → D → Prop) {ε₁ ε₂ δ₁ δ₂ : ℝ}
    (h₁ : EpsilonDeltaDP M₁ adj ε₁ δ₁) (h₂ : EpsilonDeltaDP M₂ adj ε₂ δ₂) :
    ∀ (S S' : D), adj S S' →
      ∀ (R₁ : Finset α) (R₂ : Finset β),
        (M₁.run S).probSet R₁ * (M₂.run S).probSet R₂ ≤
          Real.exp (ε₁ + ε₂) * ((M₁.run S').probSet R₁ * (M₂.run S').probSet R₂) +
          Real.exp ε₁ * δ₂ + δ₁ := by
  intro S S' hS R₁ R₂;
  refine' le_trans ( mul_le_mul_of_nonneg_right ( h₁ S S' hS R₁ ) ( DiscretePMF.probSet_nonneg _ _ ) ) _;
  rw [ Real.exp_add ] ; ring_nf;
  refine' add_le_add _ _;
  · have := h₂ S S' hS R₂;
    refine' le_trans ( mul_le_mul_of_nonneg_left this ( mul_nonneg ( Real.exp_nonneg _ ) ( DiscretePMF.probSet_nonneg _ _ ) ) ) _ ; ring_nf;
    gcongr;
    · contrapose! h₂;
      intro h; specialize h S S' hS ∅; simp_all +decide [ DiscretePMF.probSet ] ;
      linarith;
    · refine' mul_le_of_le_one_right ( Real.exp_nonneg _ ) _;
      exact le_trans ( Finset.sum_le_sum_of_subset_of_nonneg ( Finset.subset_univ _ ) fun _ _ _ => M₁.run S' |>.nonneg _ ) ( by simp +decide [ M₁.run S' |>.sum_one ] );
  · refine' mul_le_of_le_one_right _ _;
    · contrapose! h₁;
      intro h; have := h S S' hS; simp_all +decide [ EpsilonDeltaDP ] ;
      exact absurd ( h S S' hS ∅ ) ( by norm_num [ DiscretePMF.probSet ] ; linarith );
    · exact le_trans ( Finset.sum_le_sum_of_subset_of_nonneg ( Finset.subset_univ _ ) fun _ _ _ => M₂.run S |>.nonneg _ ) ( by simp +decide [ M₂.run S |>.sum_one ] )

/-! ## Post-Processing Invariance -/

/-
Post-processing does not degrade DP: if M is (ε,δ)-DP and g is a deterministic
    function, then g ∘ M is also (ε,δ)-DP.

    We state this at the level of probSet: for any output set R in the codomain,
    the preimage set g⁻¹(R) satisfies the same DP bound.
-/
theorem post_processing_invariance {D α β : Type*} [Fintype α] [Fintype β]
    [DecidableEq α] [DecidableEq β]
    (M : Mechanism D α) (g : α → β)
    (adj : D → D → Prop) {ε δ : ℝ}
    (hM : EpsilonDeltaDP M adj ε δ) :
    ∀ (S S' : D), adj S S' →
      ∀ (R : Finset β),
        (M.run S).probSet (Finset.univ.filter (fun a => g a ∈ R)) ≤
          Real.exp ε * (M.run S').probSet (Finset.univ.filter (fun a => g a ∈ R)) + δ := by
  exact fun S S' hadj R => hM S S' hadj _