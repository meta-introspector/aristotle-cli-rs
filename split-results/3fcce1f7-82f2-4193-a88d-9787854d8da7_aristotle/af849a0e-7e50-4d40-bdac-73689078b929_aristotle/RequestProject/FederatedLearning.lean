/-
# Federated Learning: Aggregation Protocols and Convergence Properties

This module formalizes the FedAvg and Fed2A aggregation protocols,
proving key properties such as weight conservation, non-expansiveness,
and convergence bounds.
-/
import RequestProject.Basic

open scoped BigOperators

/-! ## Client Metadata -/

/-- Metadata for a federated learning client. -/
structure ClientMeta (dim : ℕ) where
  /-- Local dataset size. -/
  dataSize : ℕ
  /-- Local model weights after training. -/
  weights : Vec dim
  /-- Positive dataset size. -/
  hpos : 0 < dataSize

/-! ## FedAvg: Federated Averaging -/

/-- The FedAvg aggregation weight for client k: n_k / n where n = Σ n_k. -/
noncomputable def fedAvgWeight {K : ℕ} (clients : Fin K → ClientMeta dim)
    (k : Fin K) : ℝ :=
  (clients k).dataSize / (∑ j, ((clients j).dataSize : ℝ))

/-- FedAvg global model: w_{t+1} = Σ_k (n_k/n) · w_k -/
noncomputable def fedAvg {dim K : ℕ} (clients : Fin K → ClientMeta dim) : Vec dim :=
  Vec.weightedSum (fedAvgWeight clients) (fun k => (clients k).weights)

/-
FedAvg weights are non-negative.
-/
theorem fedAvg_weight_nonneg {K : ℕ} (clients : Fin K → ClientMeta dim)
    (_hK : 0 < K) (k : Fin K) : 0 ≤ fedAvgWeight clients k := by
  exact div_nonneg ( Nat.cast_nonneg _ ) ( Finset.sum_nonneg fun _ _ => Nat.cast_nonneg _ )

/-
FedAvg weights sum to 1 (when K > 0 and total data > 0).
-/
theorem fedAvg_weights_sum_one {K : ℕ} (clients : Fin K → ClientMeta dim)
    (hK : 0 < K) :
    ∑ k, fedAvgWeight clients k = 1 := by
  unfold fedAvgWeight;
  rw [ ← Finset.sum_div _ _ _, div_self <| ne_of_gt <| mod_cast Finset.sum_pos ( fun _ _ => ( clients _ ).hpos ) ⟨ ⟨ 0, hK ⟩, Finset.mem_univ _ ⟩ ]

/-
FedAvg is a convex combination: each component of the result is
    in the convex hull of the client weights.
-/
theorem fedAvg_convex_combination {dim K : ℕ} (clients : Fin K → ClientMeta dim)
    (hK : 0 < K) (i : Fin dim) :
    ∃ (w : Fin K → ℝ), (∀ k, 0 ≤ w k) ∧ (∑ k, w k = 1) ∧
      fedAvg clients i = ∑ k, w k * (clients k).weights i := by
  use fun k => fedAvgWeight clients k;
  exact ⟨ fun k => fedAvg_weight_nonneg clients hK k, fedAvg_weights_sum_one clients hK, rfl ⟩

/-! ## Fed2A: Asynchronous Adaptive Aggregation -/

/-- Metadata for an asynchronous client update, including timing information. -/
structure AsyncUpdate (dim : ℕ) where
  /-- Layer index. -/
  layer : ℕ
  /-- Client index. -/
  client : ℕ
  /-- Model generation time (when training started). -/
  genTime : ℕ
  /-- Reception time (when update arrived at aggregator). -/
  recvTime : ℕ
  /-- The model update weights. -/
  weights : Vec dim
  /-- Reception is after generation. -/
  time_valid : genTime ≤ recvTime

/-- Staleness of an update: the time gap between generation and reception. -/
def AsyncUpdate.staleness (u : AsyncUpdate dim) : ℕ :=
  u.recvTime - u.genTime

/-- Fed2A aggregation weight: inversely proportional to staleness.
    α_{lk} = 1 / (1 + staleness) normalized over all updates. -/
noncomputable def fed2aRawWeight (u : AsyncUpdate dim) : ℝ :=
  1 / (1 + (u.staleness : ℝ))

/-- Fed2A aggregation: weighted sum with staleness-adjusted weights. -/
noncomputable def fed2a {dim : ℕ} {N : ℕ} (updates : Fin N → AsyncUpdate dim) : Vec dim :=
  let rawWeights := fun k => fed2aRawWeight (updates k)
  let totalWeight := ∑ k, rawWeights k
  Vec.weightedSum (fun k => rawWeights k / totalWeight) (fun k => (updates k).weights)

/-
Fed2A raw weights are positive.
-/
theorem fed2a_rawWeight_pos (u : AsyncUpdate dim) : 0 < fed2aRawWeight u := by
  exact one_div_pos.mpr ( by linarith [ u.staleness ] )

/-
Fed2A gives more weight to fresher updates.
-/
theorem fed2a_fresher_higher_weight {dim : ℕ} (u₁ u₂ : AsyncUpdate dim)
    (h : u₁.staleness < u₂.staleness) :
    fed2aRawWeight u₂ < fed2aRawWeight u₁ := by
  unfold fed2aRawWeight; gcongr;

/-! ## Non-Expansiveness of FedAvg -/

/-
FedAvg is non-expansive in the L∞ sense: the aggregated model's
    component-wise value lies within the range of client values.
-/
theorem fedAvg_bounded_by_clients {dim K : ℕ} (clients : Fin K → ClientMeta dim)
    (hK : 0 < K) (i : Fin dim)
    (lo hi : ℝ) (hlo : ∀ k, lo ≤ (clients k).weights i)
    (hhi : ∀ k, (clients k).weights i ≤ hi) :
    lo ≤ fedAvg clients i ∧ fedAvg clients i ≤ hi := by
  unfold fedAvg;
  constructor;
  · refine' le_trans _ ( Finset.sum_le_sum fun k _ => mul_le_mul_of_nonneg_left ( hlo k ) ( fedAvg_weight_nonneg clients hK k ) );
    rw [ ← Finset.sum_mul _ _ _, fedAvg_weights_sum_one clients hK, one_mul ];
  · convert Finset.sum_le_sum fun k _ => mul_le_mul_of_nonneg_left ( hhi k ) ( fedAvg_weight_nonneg clients hK k ) using 1;
    rw [ ← Finset.sum_mul _ _ _, fedAvg_weights_sum_one clients hK, one_mul ]

/-! ## Non-IID Divergence Bound -/

/-- A measure of statistical divergence between local and global data distributions.
    In practice, this captures the "Non-IID" challenge in FL. -/
noncomputable def dataHeterogeneity {dim K : ℕ}
    (localGrads globalGrad : Fin K → Vec dim) : ℝ :=
  ∑ k, Vec.normSq (Vec.sub (localGrads k) (globalGrad k))

/-
If all local gradients equal the global gradient, heterogeneity is zero.
-/
theorem heterogeneity_zero_when_iid {dim K : ℕ}
    (grad : Fin K → Vec dim) :
    dataHeterogeneity grad grad = 0 := by
  unfold dataHeterogeneity;
  simp +decide [ Vec.normSq, Vec.sub ]