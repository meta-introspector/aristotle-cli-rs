/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

**The trace of the cut-off sandwich diverges**: `Tr(S^{(Λ)}) → ∞` as `Λ → ∞`, where
`S^{(Λ)} = P^{(Λ)} P̂^{(Λ)} P^{(Λ)}` is the renormalized Sonin sandwich of
`RequestProject/CutoffFamily.lean`.

This is the rigorous form of the statement that a *renormalization* is unavoidable in the
local trace formula of arXiv:2006.13771 (Connes–Consani, *Weil positivity and Trace formula
– the archimedean place*): at each finite scale the sandwich is trace class
(`isTraceClass_soninSandwichCut`), but its trace grows without bound, so the limit
`Λ → ∞` of `Tr(ϑ(f) S^{(Λ)})` can only exist after a counter-term has been subtracted.

The proof combines two facts:

* `S^{(Λ)} → 1` strongly (`RequestProject/CutoffExhaustion.lean`), so each diagonal matrix
  element `⟪e, S^{(Λ)} e⟫` of a unit vector tends to `1`;
* `L²(ℝ)` is infinite dimensional — proved here from scratch, by exhibiting the infinite
  orthonormal family of normalized indicator functions of the unit blocks `[n, n+1)` — so a
  Hilbert basis has arbitrarily large finite subsets, and the trace of the positive operator
  `S^{(Λ)}` dominates every partial sum.
-/
import RequestProject.Imported.OutputFinal.RequestProject.CutoffExhaustion
import RequestProject.Imported.OutputFinal.RequestProject.CutoffFamilyHS

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory Filter Topology Set

open scoped ENNReal

namespace ConnesConsani.WeilPositivity

/-! ## An infinite orthonormal family in `L²(ℝ)` -/

/-- The unit block `[n, n+1)`. -/
def unitBlock (n : ℕ) : Set ℝ := Set.Ico (n : ℝ) (n + 1)

theorem measurableSet_unitBlock (n : ℕ) : MeasurableSet (unitBlock n) := measurableSet_Ico

theorem volume_unitBlock (n : ℕ) : volume (unitBlock n) = 1 := by
  rw [unitBlock, Real.volume_Ico]
  simp

theorem unitBlock_disjoint {m n : ℕ} (h : m ≠ n) : Disjoint (unitBlock m) (unitBlock n) := by
  rcases lt_or_gt_of_ne h with hlt | hlt
  · refine Set.disjoint_left.2 fun x hx hx' => ?_
    have h1 : x < (m : ℝ) + 1 := hx.2
    have h2 : (n : ℝ) ≤ x := hx'.1
    have : (m : ℝ) + 1 ≤ (n : ℝ) := by exact_mod_cast Nat.succ_le_of_lt hlt
    linarith
  · refine Set.disjoint_left.2 fun x hx hx' => ?_
    have h1 : x < (n : ℝ) + 1 := hx'.2
    have h2 : (m : ℝ) ≤ x := hx.1
    have : (n : ℝ) + 1 ≤ (m : ℝ) := by exact_mod_cast Nat.succ_le_of_lt hlt
    linarith

theorem memLp_indicator_unitBlock (n : ℕ) :
    MemLp ((unitBlock n).indicator fun _ : ℝ => (1 : ℂ)) 2 volume :=
  memLp_indicator_const 2 (measurableSet_unitBlock n) 1 (Or.inr (by rw [volume_unitBlock]; simp))

/-- The normalized indicator function of the unit block `[n, n+1)`, as an element of
`L²(ℝ)`. -/
def blockVec (n : ℕ) : L2R := (memLp_indicator_unitBlock n).toLp _

theorem coeFn_blockVec (n : ℕ) :
    (blockVec n : ℝ → ℂ) =ᵐ[volume] (unitBlock n).indicator fun _ : ℝ => (1 : ℂ) :=
  MemLp.coeFn_toLp _

theorem norm_blockVec (n : ℕ) : ‖blockVec n‖ = 1 := by
  rw [Lp.norm_def, eLpNorm_congr_ae (coeFn_blockVec n),
    eLpNorm_indicator_const (measurableSet_unitBlock n) (by norm_num) (by norm_num),
    volume_unitBlock]
  simp

theorem inner_blockVec_eq_zero {m n : ℕ} (h : m ≠ n) :
    (inner ℂ (blockVec m) (blockVec n) : ℂ) = 0 := by
  rw [L2.inner_def]
  refine integral_eq_zero_of_ae ?_
  filter_upwards [coeFn_blockVec m, coeFn_blockVec n] with x hm hn
  rw [hm, hn]
  by_cases hx : x ∈ unitBlock m
  · have hx' : x ∉ unitBlock n := Set.disjoint_left.1 (unitBlock_disjoint h) hx
    simp [hx']
  · simp [hx]

theorem orthonormal_blockVec : Orthonormal ℂ blockVec :=
  ⟨norm_blockVec, fun _ _ h => inner_blockVec_eq_zero h⟩

/-- **`L²(ℝ)` is infinite dimensional**: the index type of any Hilbert basis is infinite. -/
theorem infinite_of_hilbertBasis {ι : Type*} (b : HilbertBasis ι ℂ L2R) : Infinite ι := by
  rw [← not_finite_iff_infinite]
  intro hfin
  haveI : Fintype ι := Fintype.ofFinite ι
  haveI : FiniteDimensional ℂ L2R :=
    b.toOrthonormalBasis.toBasis.finiteDimensional_of_finite
  have hfinN : Finite ℕ := orthonormal_blockVec.linearIndependent.finite_of_isNoetherian
  exact (not_finite ℕ)

/-! ## Divergence of the trace of the cut-off sandwich -/

variable {ι : Type*}

theorem summable_re_inner_soninSandwichCut (b : HilbertBasis ι ℂ L2R) (lam : ℝ) :
    Summable fun i => RCLike.re (inner ℂ (b i) (soninSandwichCut lam (b i))) := by
  refine Summable.of_nonneg_of_le (fun i => re_inner_soninSandwichCut_nonneg lam (b i))
    (fun i => ?_) (summable_norm_inner_of_isTraceClass (isTraceClass_soninSandwichCut lam b))
  exact (le_abs_self _).trans (Complex.abs_re_le_norm _)

/-- Every finite partial sum of diagonal matrix elements is bounded by the trace. -/
theorem sum_le_traceAlongRe_soninSandwichCut (b : HilbertBasis ι ℂ L2R) (lam : ℝ)
    (F : Finset ι) :
    ∑ i ∈ F, RCLike.re (inner ℂ (b i) (soninSandwichCut lam (b i)))
      ≤ traceAlongRe b (soninSandwichCut lam) :=
  Summable.sum_le_tsum F (fun i _ => re_inner_soninSandwichCut_nonneg lam (b i))
    (summable_re_inner_soninSandwichCut b lam)

/-- Each diagonal matrix element of `S^{(Λ)}` in a Hilbert basis tends to `1`. -/
theorem tendsto_re_inner_soninSandwichCut_basis (b : HilbertBasis ι ℂ L2R) (i : ι) :
    Tendsto (fun lam : ℝ => RCLike.re (inner ℂ (b i) (soninSandwichCut lam (b i)))) atTop
      (𝓝 1) := by
  have h := tendsto_inner_soninSandwichCut (b i)
  have hn : ‖b i‖ = 1 := b.orthonormal.1 i
  have := (Complex.continuous_re.tendsto _).comp h
  simpa [Function.comp, hn] using this

/-- **`Tr(S^{(Λ)}) → ∞`.**  The trace of the cut-off sandwich diverges as the cut-off scale
grows: the local trace formula at the archimedean place is necessarily a renormalized
statement. -/
theorem tendsto_traceAlongRe_soninSandwichCut_atTop (b : HilbertBasis ι ℂ L2R) :
    Tendsto (fun lam : ℝ => traceAlongRe b (soninSandwichCut lam)) atTop atTop := by
  haveI : Infinite ι := infinite_of_hilbertBasis b
  refine tendsto_atTop.2 fun C => ?_
  obtain ⟨N, hN⟩ := exists_nat_gt C
  obtain ⟨F, hF⟩ := Infinite.exists_subset_card_eq ι N
  have hsum : Tendsto
      (fun lam : ℝ => ∑ i ∈ F, RCLike.re (inner ℂ (b i) (soninSandwichCut lam (b i))))
      atTop (𝓝 (N : ℝ)) := by
    have := tendsto_finset_sum F
      (fun i (_ : i ∈ F) => tendsto_re_inner_soninSandwichCut_basis b i)
    simpa [hF] using this
  have hev : ∀ᶠ lam : ℝ in atTop,
      C ≤ ∑ i ∈ F, RCLike.re (inner ℂ (b i) (soninSandwichCut lam (b i))) := by
    filter_upwards [hsum.eventually_const_lt hN] with lam hlam using hlam.le
  filter_upwards [hev] with lam hlam
  exact hlam.trans (sum_le_traceAlongRe_soninSandwichCut b lam F)

end ConnesConsani.WeilPositivity
