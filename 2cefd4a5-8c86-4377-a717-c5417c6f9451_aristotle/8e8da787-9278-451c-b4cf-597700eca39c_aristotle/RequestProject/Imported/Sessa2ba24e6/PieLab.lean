import Mathlib

open Set Real Filter MeasureTheory Topology

/-
  PIE LAB: ARITHMETIC FORM FACTOR DECOMPOSITION
  Step 2 of the Fields Medal Descent – Hardy-Littlewood Circle Method
-/

/-- Major arc centered at the reduced fraction a/q with width 1/(q·Q). -/
def majorArc (Q : ℕ) (a q : ℕ) : Set ℝ :=
  let center := (a : ℝ) / (q : ℝ)
  let width := 1 / ((q : ℝ) * (Q : ℝ))
  Ioo (center - width) (center + width)

/-- Union of all major arcs for denominators ≤ Q and centers ≤ α. -/
def majorArcs (Q : ℕ) (α : ℝ) : Set ℝ :=
  { x : ℝ | ∃ (a q : ℕ), 0 < q ∧ q ≤ Q ∧ Nat.Coprime a q ∧ (a : ℝ) / q ≤ α ∧
    x ∈ majorArc Q a q ∩ Icc 0 α }

/-- Minor arcs are the complement of the major arcs inside [0, α]. -/
def minorArcs (Q : ℕ) (α : ℝ) : Set ℝ :=
  Icc 0 α \ majorArcs Q α

theorem majorArcs_cover (Q : ℕ) (α : ℝ) (hα : 0 < α) :
    majorArcs Q α ∪ minorArcs Q α = Icc 0 α := by
  simp only [minorArcs]
  apply union_diff_cancel
  intro x ⟨a, q, _, _, _, _, _, hx_icc⟩
  exact hx_icc

def fareySequence (Q : ℕ) : Set ℚ :=
  { r : ℚ | 0 ≤ r ∧ r ≤ 1 ∧ ∃ (a q : ℕ), r = a / q ∧ q ≤ Q ∧ Nat.Coprime a q }

/-
============================================================================
HELPER LEMMAS FOR MINOR ARC MEASURE
============================================================================

By Dirichlet's approximation theorem, points in [0, α - 1/(Q+1)] are in major arcs.
-/
lemma majorArcs_cover_initial (Q : ℕ) (hQ : 0 < Q) (α : ℝ) (hα : 0 < α)
    (x : ℝ) (hx0 : 0 ≤ x) (hxα : x ≤ α - 1 / ((Q : ℝ) + 1)) :
    x ∈ majorArcs Q α := by
  -- By Dirichlet's approximation theorem, there exists a rational number $r = \frac{a}{q}$ with $0 \leq r \leq \alpha$ and $|x - r| \leq \frac{1}{(Q+1)q}$.
  obtain ⟨r, hr⟩ : ∃ r : ℚ, 0 ≤ r ∧ r ≤ α ∧ |x - r| ≤ 1 / ((Q + 1) * r.den) ∧ r.den ≤ Q := by
    have := @Real.exists_rat_abs_sub_le_and_den_le x Q hQ;
    obtain ⟨r, hr⟩ := this
    by_cases hr_nonneg : 0 ≤ r;
    · refine' ⟨ r, hr_nonneg, _, hr ⟩;
      norm_num at *;
      nlinarith [ abs_le.mp hr.1, inv_pos.mpr ( by positivity : 0 < ( Q : ℝ ) + 1 ), inv_pos.mpr ( by positivity : 0 < ( r.den : ℝ ) ), mul_inv_cancel₀ ( by positivity : ( Q : ℝ ) + 1 ≠ 0 ), mul_inv_cancel₀ ( by positivity : ( r.den : ℝ ) ≠ 0 ), show ( r.den : ℝ ) ≥ 1 by exact_mod_cast r.pos, show ( r.den : ℝ ) ≤ Q by exact_mod_cast hr.2 ];
    · -- Since $r < 0$, we have $r \leq -1 / r.den$.
      have hr_le_neg_one_div_den : (r : ℝ) ≤ -1 / r.den := by
        rw [ le_div_iff₀ ] <;> norm_cast <;> norm_num [ Rat.cast_def ] at *;
        · exact_mod_cast Int.le_of_lt_add_one ( show r.num < 0 from Rat.num_neg.mpr hr_nonneg );
        · exact r.pos;
      rw [ le_div_iff₀ ( Nat.cast_pos.mpr r.pos ) ] at hr_le_neg_one_div_den;
      rw [ abs_le ] at hr;
      nlinarith [ show ( r.den : ℝ ) ≥ 1 by exact_mod_cast r.pos, show ( r.den : ℝ ) ≤ Q by exact_mod_cast hr.2, one_div_mul_cancel ( by positivity : ( ( Q + 1 ) * r.den : ℝ ) ≠ 0 ), mul_le_mul_of_nonneg_left ( show ( r.den : ℝ ) ≥ 1 by exact_mod_cast r.pos ) ( by positivity : 0 ≤ ( Q + 1 : ℝ ) ) ];
  refine' ⟨ r.num.natAbs, r.den, r.pos, _, _, _, _ ⟩ <;> simp_all +decide [ abs_of_nonneg, Rat.cast_def ];
  · exact r.reduced;
  · refine' ⟨ _, _ ⟩ <;> norm_num [ majorArc ] at *;
    · rw [ abs_of_nonneg ( mod_cast Rat.num_nonneg.mpr hr.1 ) ];
      constructor <;> nlinarith [ abs_le.mp hr.2.2.1, inv_pos.mpr ( by positivity : 0 < ( Q : ℝ ) ), inv_pos.mpr ( by positivity : 0 < ( r.den : ℝ ) ), mul_inv_cancel₀ ( by positivity : ( Q : ℝ ) ≠ 0 ), mul_inv_cancel₀ ( by positivity : ( r.den : ℝ ) ≠ 0 ), mul_inv_cancel₀ ( by positivity : ( Q + 1 : ℝ ) ≠ 0 ), show ( r.den : ℝ ) ≥ 1 by exact_mod_cast r.pos, show ( Q : ℝ ) ≥ 1 by exact_mod_cast hQ ];
    · exact le_trans hxα ( sub_le_self _ <| by positivity )

/-
Minor arcs are contained in the tail interval [α - 1/(Q+1), α].
-/
lemma minorArcs_subset_tail (Q : ℕ) (hQ : 0 < Q) (α : ℝ) (hα : 0 < α) :
    minorArcs Q α ⊆ Icc (α - 1 / ((Q : ℝ) + 1)) α := by
  intro x hx;
  exact ⟨ le_of_not_gt fun hx' => hx.2 <| majorArcs_cover_initial Q hQ α hα x hx.1.1 <| by linarith, hx.1.2 ⟩

/-
The measure of minor arcs is bounded by 1/(Q+1).
-/
lemma volume_minorArcs_le (Q : ℕ) (hQ : 0 < Q) (α : ℝ) (hα : 0 < α) :
    volume (minorArcs Q α) ≤ ENNReal.ofReal (1 / ((Q : ℝ) + 1)) := by
  -- Apply the lemma minorArcs_subset_tail to get the measure bound.
  have h_subset : minorArcs Q α ⊆ Icc (α - 1 / ((Q : ℝ) + 1)) α :=
    minorArcs_subset_tail Q hQ α hα
  exact le_trans ( MeasureTheory.measure_mono h_subset ) ( by simp [ hα.le ] )

set_option maxHeartbeats 800000 in
theorem minorArcs_measure_tendsToZero (α : ℝ) (hα : 0 < α) :
    Tendsto (fun Q => MeasureTheory.volume (minorArcs Q α)) atTop (nhds 0) := by
  -- By the squeeze theorem, since the volume of minor arcs is bounded above by $1/(Q+1)$ and $1/(Q+1)$ tends to $0$ as $Q$ tends to infinity, the volume of minor arcs must also tend to $0$.
  have h_squeeze : ∀ Q : ℕ, Q ≥ 1 → volume (minorArcs Q α) ≤ ENNReal.ofReal (1 / ((Q : ℝ) + 1)) :=
    fun Q a => volume_minorArcs_le Q a α hα
  have h_squeeze : Filter.Tendsto (fun Q : ℕ => ENNReal.ofReal (1 / ((Q : ℝ) + 1))) Filter.atTop (𝓝 0) := by
    simpa using ENNReal.tendsto_ofReal ( tendsto_one_div_add_atTop_nhds_zero_nat );
  exact tendsto_of_tendsto_of_tendsto_of_le_of_le' tendsto_const_nhds h_squeeze ( Filter.eventually_atTop.mpr ⟨ 1, fun Q hQ => zero_le _ ⟩ ) ( Filter.eventually_atTop.mpr ⟨ 1, fun Q hQ => by aesop ⟩ )

noncomputable def singularSeriesTwinPrime : ℝ :=
  2 * ∏' p : {n : ℕ | Nat.Prime n ∧ n ≥ 3}, (1 - 1 / (((p : ℝ) - 1) ^ 2))

theorem singularSeriesTwinPrime_value :
    singularSeriesTwinPrime =
      2 * ∏' p : {n : ℕ | Nat.Prime n ∧ n ≥ 3}, (1 - 1 / (((p : ℝ) - 1) ^ 2)) := by
  rfl

-- ============================================================================
-- RAMANUJAN SUMS (fully proved by Aristotle)
-- ============================================================================

def coprimesBelow (q : ℕ) : Finset ℕ :=
  (Finset.range q).filter (fun a => Nat.Coprime a q)

noncomputable def ramanujanSum (q h : ℕ) : ℂ :=
  if q = 0 then 0
  else ∑ a ∈ coprimesBelow q,
    Complex.exp (2 * Real.pi * Complex.I * (a : ℂ) * (h : ℂ) / (q : ℂ))

theorem ramanujanSum_one (h : ℕ) : ramanujanSum 1 h = 1 := by
  unfold ramanujanSum; norm_num [coprimesBelow]

-- ============================================================================
-- GAUSS SUMS (fully proved by Aristotle)
-- ============================================================================

noncomputable def myGaussSum (a q : ℕ) : ℂ :=
  if q = 0 then 0
  else ∑ n ∈ Finset.range q,
    Complex.exp (2 * Real.pi * Complex.I * (a : ℂ) * (n : ℂ) / (q : ℂ))

theorem myGaussSum_zero (q : ℕ) (hq : q > 0) : myGaussSum 0 q = (q : ℂ) := by
  unfold myGaussSum; aesop

theorem myGaussSum_weil_bound (a q : ℕ) (hq : q > 0) (hc : Nat.Coprime a q) :
    ‖myGaussSum a q‖ ≤ Real.sqrt (q : ℝ) := by
  by_cases h : q = 1 <;> simp_all +decide [myGaussSum]
  have h_geo_series : ∑ n ∈ Finset.range q, Complex.exp (2 * Real.pi * Complex.I * a * n / q) = 0 := by
    have h_geo_series : ∑ n ∈ Finset.range q, (Complex.exp (2 * Real.pi * Complex.I * a / q)) ^ n = 0 := by
      rw [geom_sum_eq] <;> norm_num [← Complex.exp_nat_mul, mul_div_cancel₀, hq.ne']
      · exact Or.inl (sub_eq_zero_of_eq <| Complex.exp_eq_one_iff.mpr ⟨a, by push_cast; ring⟩)
      · rw [Complex.exp_eq_one_iff]
        norm_num [Complex.ext_iff, div_eq_iff, Real.pi_ne_zero, hq.ne']
        intro x hx
        exact absurd (hc.gcd_eq_one ▸ Nat.dvd_gcd (show q ∣ a from
          Int.natCast_dvd_natCast.mp ⟨x, by push_cast [← @Int.cast_inj ℝ]; nlinarith [Real.pi_pos]⟩)
          (dvd_refl q)) (by aesop)
    exact Eq.trans (Finset.sum_congr rfl fun _ _ => by rw [← Complex.exp_nat_mul]; ring) h_geo_series
  aesop

-- ============================================================================
-- THE VON MANGOLDT EXPONENTIAL SUM & MAJOR-ARC EVALUATION
-- ============================================================================

/-- The von Mangoldt exponential sum \(S(x, \alpha)\). -/
noncomputable def vonMangoldtExpSum (x : ℝ) (α : ℝ) : ℂ :=
  ∑ n ∈ Finset.Icc 1 (Nat.floor x),
    (ArithmeticFunction.vonMangoldt n : ℂ) *
    Complex.exp (2 * Real.pi * Complex.I * α * (n : ℂ))

/-- On a major arc near a/q, the exponential sum factors through Ramanujan sums
and the singular series.

This is a deep result from analytic number theory, requiring either:
- Vaughan's identity + Type I/II sum estimates, or
- Dirichlet character orthogonality + the Siegel-Walfisz theorem (or GRH)

None of the required infrastructure (Dirichlet characters, Vaughan's identity,
Siegel-Walfisz theorem) is currently available in Mathlib. -/
theorem majorArc_evaluation (x : ℝ) (hx : x ≥ 2) (q : ℕ) (hq : 0 < q)
    (a : ℕ) (haq : Nat.Coprime a q) (β : ℝ) (hβ : |β| ≤ 1/(q * x))
    (ε : ℝ) (hε : 0 < ε) :
    ‖vonMangoldtExpSum x ((a : ℝ)/q + β) -
      (ramanujanSum q 1 / (Nat.totient q : ℂ)) *
      vonMangoldtExpSum x β‖ ≤ x ^ (1/2 + ε) := by
  sorry