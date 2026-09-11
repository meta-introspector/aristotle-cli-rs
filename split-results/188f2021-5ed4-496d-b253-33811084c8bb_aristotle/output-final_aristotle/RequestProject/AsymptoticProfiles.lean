import RequestProject.AltSplittings

/-!
# Asymptotic limits of the gauge-chart profiles as the chart scales

`RequestProject.GaugeChart` and `RequestProject.AltSplittings` study the **profiles** of the
fixed `194`-row arithmetic gauge chart: the bosonic/fermionic `H⁰` super-dimension under the
Liouville parity grading `(2761 | 2670)`, and more generally the **residue-class profile**
`resClassProfile k` recording the `H⁰` dimension carried by each residue class of `Ω(n)`
modulo `k`.

That chart is a *fixed* finite transcription, so there is no literal limit to take.  What this
file makes precise is the **asymptotic behaviour of the very same profile constructions when
the chart is allowed to scale**: we feed the splitting/profile machinery the *complete* chart
whose rows realise every twist `Ω = 0, 1, 2, …, N - 1` exactly once (`idealChart N`), and let
`N → ∞`.

Each row with twist `w = Ω(n)` still contributes the line bundle `O(w)` of `H⁰`-dimension
`w + 1` (the building block proved in `LaurentCohomology.finrank_cechH0`), exactly as in the
real chart, and the residue-class dimensions are computed by the **same** `resClassDim`
function used on the real chart.

## Main results

* `cechH0_dim_linear_growth` — the building block scales linearly: `dim H⁰(O(d)) / d → 1`.
* `residue_profile_equidistributes` — **equidistribution of the residue-class profile.**  For
  every modulus `k ≥ 1` and residue `r < k`, the fraction of the total `H⁰` dimension carried
  by residue class `r` tends to `1 / k`: the profile becomes uniform as the chart scales.
* `liouville_bosonic_balance` / `liouville_fermionic_balance` — the headline special case
  `k = 2`: the bosonic and fermionic sectors of the Liouville-parity super-dimension each tend
  to half of the total.  (On the real `194`-row chart the split is already nearly balanced,
  `(2761 | 2670)`, i.e. bosonic fraction `2761/5431 ≈ 0.508`.)
-/

open SuperBundleP1 GaugeChart LaurentCohomology Filter Topology

namespace AsymptoticProfiles

set_option maxRecDepth 100000

/-! ### The scaling family of charts -/

/-- An idealised chart row with a prescribed twist `w = Ω(n)` and all `p`-adic valuations set
to zero.  Only its `rowExponentSum` (hence its twist `O(w)`) matters for the profiles. -/
def idealRow (w : ℕ) : GaugeRow :=
  ⟨0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, w⟩

@[simp] theorem idealRow_rowExponentSum (w : ℕ) : (idealRow w).rowExponentSum = w := rfl

@[simp] theorem idealRow_twist (w : ℕ) : (idealRow w).twist = (w : ℤ) := rfl

/-- The complete chart at scale `N`: one row realising each twist `w = 0, 1, …, N - 1`. -/
def idealChart (N : ℕ) : List GaugeRow := (List.range N).map idealRow

/-- The total `H⁰` dimension of the complete chart at scale `N`: `∑_{w < N} (w + 1)`. -/
def idealTotalDim (N : ℕ) : ℕ := ∑ w ∈ Finset.range N, (w + 1)

/-! ### Closed forms -/

/-- The residue-class dimension of the complete chart, as a `Finset` sum: it is the same
`resClassDim` construction used on the real chart. -/
theorem resClassDim_idealChart (k res N : ℕ) :
    resClassDim k res (idealChart N)
      = ∑ w ∈ (Finset.range N).filter (fun w => w % k = res), (w + 1) := by
  unfold resClassDim idealChart; simp +decide [Finset.sum_filter] ;
  rw [ Finset.sum_eq_multiset_sum ] ; simp +decide [ List.filter_map, List.map_map ] ;
  induction N <;> simp_all +decide [ List.range_succ ];
  by_cases h : ‹_› % k = res <;> simp_all +decide;
  ring

/-- Total dimension closed form (Gauss): `2 · ∑_{w < N}(w+1) = N·(N+1)`. -/
theorem idealTotalDim_eq (N : ℕ) : 2 * idealTotalDim N = N * (N + 1) := by
  unfold idealTotalDim;
  induction N <;> norm_num [ Finset.sum_range_succ ] at * ; linarith

/-- Residue-class dimension closed form at the aligned scale `N = k·M`, where each residue
class contains exactly `M` twists `r, r+k, …, r+k(M-1)`:
`2 · resClassDim = 2·M·(r+1) + k·M·(M-1)`. -/
theorem resClassDim_block (k r M : ℕ) (hk : 0 < k) (hr : r < k) :
    2 * (∑ w ∈ (Finset.range (k * M)).filter (fun w => w % k = r), (w + 1))
      = 2 * M * (r + 1) + k * M * (M - 1) := by
  -- The elements of `(Finset.range (k*M)).filter (fun w => w % k = r)` are exactly `{ r + k*t : t ∈ Finset.range M }`.
  have h_filter : (Finset.range (k * M)).filter (fun w => w % k = r) = Finset.image (fun t => r + k * t) (Finset.range M) := by
    ext w
    simp [Finset.mem_image];
    exact ⟨ fun h => ⟨ w / k, Nat.div_lt_of_lt_mul <| by linarith, by linarith [ Nat.mod_add_div w k ] ⟩, by rintro ⟨ a, ha, rfl ⟩ ; exact ⟨ by nlinarith, by simp +decide [ Nat.add_mod, Nat.mod_eq_of_lt hr ] ⟩ ⟩;
  rcases M with ( _ | M ) <;> simp_all +decide [ Finset.sum_add_distrib, mul_add, add_assoc ];
  rw [ Finset.sum_image <| by intros a ha b hb hab; nlinarith, Finset.card_image_of_injective _ fun a b hab => by nlinarith ] ; norm_num [ Finset.sum_range_succ' ];
  exact Nat.recOn M ( by norm_num ) fun n ih => by norm_num [ Finset.sum_range_succ ] at * ; linarith;

/-! ### A real-analysis helper -/

/-- The limit of a ratio of two affine functions of `M` is the ratio of the leading
coefficients. -/
theorem tendsto_linear_ratio (a b c d : ℝ) (hc : c ≠ 0) :
    Tendsto (fun M : ℕ => (a * M + b) / (c * M + d)) atTop (𝓝 (a / c)) := by
  -- Divide numerator and denominator by $M$:
  suffices h_suff : Filter.Tendsto (fun M : ℕ => (a + b / (M : ℝ)) / (c + d / (M : ℝ))) Filter.atTop (nhds ((a / c))) by
    refine h_suff.congr' ( by filter_upwards [ Filter.eventually_gt_atTop 0 ] with M hM using by rw [ show a * ↑M + b = ( a + b / ↑M ) * ↑M by nlinarith [ mul_div_cancel₀ b ( by positivity : ( M : ℝ ) ≠ 0 ) ], show c * ↑M + d = ( c + d / ↑M ) * ↑M by nlinarith [ mul_div_cancel₀ d ( by positivity : ( M : ℝ ) ≠ 0 ) ] ] ; rw [ mul_div_mul_right _ _ ( by positivity ) ] );
  exact le_trans ( Filter.Tendsto.div ( tendsto_const_nhds.add ( tendsto_const_nhds.div_atTop tendsto_natCast_atTop_atTop ) ) ( tendsto_const_nhds.add ( tendsto_const_nhds.div_atTop tendsto_natCast_atTop_atTop ) ) ( by aesop ) ) ( by aesop )

/-! ### Linear growth of the building block -/

/-- As the twist `d` scales, the dimension of `H⁰(O(d))` grows linearly: `dim / d → 1`. -/
theorem cechH0_dim_linear_growth (K : Type*) [Field K] :
    Tendsto (fun d : ℕ => (Module.finrank K (cechH0 K (d : ℤ)) : ℝ) / (d : ℝ))
      atTop (𝓝 1) := by
  convert Tendsto.congr' _ ( tendsto_linear_ratio 1 1 1 0 ( by norm_num : ( 1 : ℝ ) ≠ 0 ) ) using 2;
  · grind;
  · filter_upwards [ Filter.eventually_gt_atTop 0 ] with d hd;
    rw [ LaurentCohomology.finrank_cechH0 ] ; norm_cast ; aesop

/-! ### Equidistribution of the residue-class profile -/

/-- **Equidistribution of the residue-class profile.**  For every modulus `k ≥ 1` and residue
`r < k`, the fraction of the total `H⁰` dimension carried by the residue class `r` of `Ω(n)`
tends to `1 / k` as the chart scales: the profile becomes uniform. -/
theorem residue_profile_equidistributes (k r : ℕ) (hk : 0 < k) (hr : r < k) :
    Tendsto (fun M : ℕ =>
        (resClassDim k r (idealChart (k * M)) : ℝ) / (idealTotalDim (k * M) : ℝ))
      atTop (𝓝 (1 / (k : ℝ))) := by
  have h_resClassDim_idealChart : ∀ M : ℕ, 2 * (resClassDim k r (idealChart (k * M)) : ℝ) = 2 * M * (r + 1) + k * M * (M - 1) := by
    intro M; norm_cast; rcases M.eq_zero_or_pos with hM | hM <;> simp_all +decide ;
    rw [ Int.subNatNat_of_le hM ] ; norm_cast; rw [ resClassDim_idealChart ] ; exact resClassDim_block k r M hk hr;
  convert Tendsto.congr' _ ( tendsto_linear_ratio ( k : ℝ ) ( 2 * ( r + 1 ) - k ) ( k * k : ℝ ) ( k : ℝ ) _ ) using 2;
  · rw [ div_mul_eq_div_div, div_self ( by positivity ) ];
  · filter_upwards [ Filter.eventually_gt_atTop 0 ] with M hM;
    rw [ div_eq_div_iff ];
    · have h_idealTotalDim : 2 * (idealTotalDim (k * M) : ℝ) = (k * M) * (k * M + 1) := by
        exact_mod_cast idealTotalDim_eq ( k * M );
      grind;
    · positivity;
    · exact ne_of_gt <| Nat.cast_pos.mpr <| Finset.sum_pos ( fun _ _ => Nat.succ_pos _ ) ⟨ _, Finset.mem_range.mpr <| Nat.mul_pos hk hM ⟩;
  · positivity

/-! ### The Liouville parity profile balances -/

/-- The Liouville-parity bundle of the complete chart has the residue classes `0` and `1`
of `Ω(n) mod 2` as its bosonic and fermionic sectors. -/
theorem sdimH0_idealChart_liouville (N : ℕ) :
    sdimH0 (chartBundleBy splitLiouville (idealChart N))
      = (resClassDim 2 0 (idealChart N), resClassDim 2 1 (idealChart N)) := by
  unfold chartBundleBy sdimH0 resClassDim;
  simp +decide [splitLiouville];
  constructor <;> congr! 2;
  grind

/-
**Liouville balance (bosonic).**  As the chart scales, the bosonic sector of the
Liouville-parity super-dimension tends to half of the total.
-/
theorem liouville_bosonic_balance :
    Tendsto (fun M : ℕ =>
        ((sdimH0 (chartBundleBy splitLiouville (idealChart (2 * M)))).1 : ℝ)
          / (idealTotalDim (2 * M) : ℝ)) atTop (𝓝 (1 / 2)) := by
  convert residue_profile_equidistributes 2 0 (by norm_num) (by norm_num) using 1;
  norm_num [ sdimH0_idealChart_liouville ]

/-
**Liouville balance (fermionic).**  As the chart scales, the fermionic sector of the
Liouville-parity super-dimension tends to half of the total.
-/
theorem liouville_fermionic_balance :
    Tendsto (fun M : ℕ =>
        ((sdimH0 (chartBundleBy splitLiouville (idealChart (2 * M)))).2 : ℝ)
          / (idealTotalDim (2 * M) : ℝ)) atTop (𝓝 (1 / 2)) := by
  convert residue_profile_equidistributes 2 1 ( by norm_num ) ( by norm_num ) using 2 ; norm_num [ sdimH0_idealChart_liouville ]

/-! ### Higher-moment profiles: variance of the residue-class contributions

Equidistribution (`residue_profile_equidistributes`) is a *first-order* statement: each
residue-class fraction tends to the uniform value `1/k`.  The following results push the
analysis to higher moments of the residue-class distribution, confirming that the profile not
only centres on `1/k` but concentrates there. -/

/-- The fraction of the total `H⁰` dimension carried by residue class `r` modulo `k` at the
aligned scale `N = k·M`. -/
noncomputable def resFraction (k r M : ℕ) : ℝ :=
  (resClassDim k r (idealChart (k * M)) : ℝ) / (idealTotalDim (k * M) : ℝ)

/-- Restatement of equidistribution in terms of `resFraction`: each class fraction tends to
`1/k`. -/
theorem resFraction_tendsto (k r : ℕ) (hk : 0 < k) (hr : r < k) :
    Tendsto (fun M : ℕ => resFraction k r M) atTop (𝓝 (1 / (k : ℝ))) :=
  residue_profile_equidistributes k r hk hr

/-- **Vanishing variance of the residue-class profile.**  As the chart scales, the sum over all
residue classes of the squared deviation of each class's fraction from the uniform value `1/k`
tends to `0`: equidistribution holds at second order, so the profile concentrates on the
uniform distribution. -/
theorem residue_profile_variance_vanishes (k : ℕ) (hk : 0 < k) :
    Tendsto (fun M : ℕ =>
        ∑ r ∈ Finset.range k, (resFraction k r M - 1 / (k : ℝ)) ^ 2)
      atTop (𝓝 0) := by
  have h0 : (0 : ℝ) = ∑ _r ∈ Finset.range k, ((1 / (k : ℝ) - 1 / (k : ℝ)) ^ 2) := by simp
  rw [h0]
  apply tendsto_finset_sum
  intro r hr
  exact ((resFraction_tendsto k r hk (Finset.mem_range.mp hr)).sub tendsto_const_nhds).pow 2

/-- **Second moment of the residue-class profile.**  As the chart scales, the sum over all
residue classes of the squared fraction tends to `1/k = ∑ (1/k)² = k·(1/k)²`, the second
moment of the uniform distribution on `ℤ/kℤ`. -/
theorem residue_profile_second_moment (k : ℕ) (hk : 0 < k) :
    Tendsto (fun M : ℕ => ∑ r ∈ Finset.range k, (resFraction k r M) ^ 2)
      atTop (𝓝 (1 / (k : ℝ))) := by
  have hkR : (k : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr hk.ne'
  have hsum : (1 / (k : ℝ)) = ∑ _r ∈ Finset.range k, ((1 / (k : ℝ)) ^ 2) := by
    rw [Finset.sum_const, Finset.card_range, nsmul_eq_mul]
    field_simp
  rw [hsum]
  apply tendsto_finset_sum
  intro r hr
  exact (resFraction_tendsto k r hk (Finset.mem_range.mp hr)).pow 2

/-- **Higher central moments vanish.**  For every exponent `p ≥ 1`, the sum over all residue
classes of the `p`-th power of the absolute deviation of each class's fraction from `1/k` tends
to `0`.  The variance (`residue_profile_variance_vanishes`) is the case `p = 2`. -/
theorem residue_profile_central_moment_vanishes (k p : ℕ) (hk : 0 < k) (hp : 1 ≤ p) :
    Tendsto (fun M : ℕ =>
        ∑ r ∈ Finset.range k, |resFraction k r M - 1 / (k : ℝ)| ^ p)
      atTop (𝓝 0) := by
  have h0 : (0 : ℝ) = ∑ _r ∈ Finset.range k, (|1 / (k : ℝ) - 1 / (k : ℝ)| ^ p) := by
    simp [zero_pow (by omega : p ≠ 0)]
  rw [h0]
  apply tendsto_finset_sum
  intro r hr
  exact (((resFraction_tendsto k r hk (Finset.mem_range.mp hr)).sub tendsto_const_nhds).abs).pow p

end AsymptoticProfiles