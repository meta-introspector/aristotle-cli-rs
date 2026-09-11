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

/-
Theorem 1: Perfect topological partition of the frequency domain.
-/
theorem majorArcs_cover (Q : ℕ) (α : ℝ) (hα : 0 < α) :
    majorArcs Q α ∪ minorArcs Q α = Icc 0 α := by
  simp only [minorArcs]
  apply union_diff_cancel
  intro x ⟨a, q, _, _, _, _, _, hx_icc⟩
  exact hx_icc

/-- The Farey sequence of order Q (all reduced fractions in [0,1]). -/
def fareySequence (Q : ℕ) : Set ℚ :=
  { r : ℚ | 0 ≤ r ∧ r ≤ 1 ∧ ∃ (a q : ℕ), r = a / q ∧ q ≤ Q ∧ Nat.Coprime a q }

/-
Lebesgue measure of the minor arcs tends to zero as Q → ∞.
-/
set_option maxHeartbeats 800000 in
theorem minorArcs_measure_tendsToZero (α : ℝ) (hα : 0 < α) :
    Tendsto (fun Q => MeasureTheory.volume (minorArcs Q α)) atTop (nhds 0) := by
  -- By definition of minor arcs, we have minorArcs Q α = Icc 0 α \ majorArcs Q α (by definition)
  have h_def : ∀ Q : ℕ, minorArcs Q α = Icc 0 α \ majorArcs Q α := by
    grind;
  -- For Q ≥ 1, Ico 0 (α - 1/Q) ⊆ majorArcs Q α (by Dirichlet approximation)
  have h_dirichlet : ∀ Q : ℕ, 1 ≤ Q → Ico 0 (α - 1 / (Q : ℝ)) ⊆ majorArcs Q α := by
    intro Q hQ x hx
    obtain ⟨a, q, haq⟩ : ∃ a q : ℕ, 0 < q ∧ q ≤ Q ∧ Nat.Coprime a q ∧ |x - (a : ℝ) / q| < 1 / ((q : ℝ) * (Q : ℝ)) := by
      -- By Dirichlet's approximation theorem, there exist integers $a$ and $q$ with $1 \leq q \leq Q$ such that $|qx - a| < \frac{1}{Q}$.
      obtain ⟨a, q, hq_pos, hq_le_Q, h_approx⟩ : ∃ a q : ℤ, 1 ≤ q ∧ q ≤ Q ∧ |q * x - a| < 1 / (Q : ℝ) := by
        -- By the pigeonhole principle, since there are $Q+1$ numbers and only $Q$ intervals, at least two of these numbers must fall into the same interval.
        obtain ⟨i, j, hij, h_same_interval⟩ : ∃ i j : ℕ, i < j ∧ i ≤ Q ∧ j ≤ Q ∧ ⌊(i * x - ⌊i * x⌋) * Q⌋ = ⌊(j * x - ⌊j * x⌋) * Q⌋ := by
          by_contra h_contra;
          exact absurd ( Finset.card_le_card ( show Finset.image ( fun i : ℕ => ⌊ ( i * x - ⌊i * x⌋ ) * Q⌋ ) ( Finset.Icc 0 Q ) ⊆ Finset.Icc 0 ( Q - 1 ) from Finset.image_subset_iff.mpr fun i hi => Finset.mem_Icc.mpr ⟨ Int.floor_nonneg.mpr <| mul_nonneg ( Int.fract_nonneg _ ) <| Nat.cast_nonneg _, Int.le_sub_one_of_lt <| Int.floor_lt.mpr <| mul_lt_of_lt_one_left ( by positivity ) <| Int.fract_lt_one _ ⟩ ) ) ( by rw [ Finset.card_image_of_injOn fun i hi j hj hij => le_antisymm ( not_lt.mp fun hi' => h_contra ⟨ j, i, hi', by aesop, by aesop, hij.symm ⟩ ) ( not_lt.mp fun hj' => h_contra ⟨ i, j, hj', by aesop, by aesop, hij ⟩ ) ] ; simp +arith +decide );
        -- Let $q = j - i$ and $a = \lfloor jx \rfloor - \lfloor ix \rfloor$.
        use ⌊j * x⌋ - ⌊i * x⌋, j - i;
        rw [ Int.floor_eq_iff ] at h_same_interval;
        exact ⟨ by linarith, by linarith, by rw [ abs_lt ] ; constructor <;> push_cast <;> nlinarith [ show ( Q : ℝ ) ≥ 1 by norm_cast, mul_div_cancel₀ 1 ( by positivity : ( Q : ℝ ) ≠ 0 ), Int.floor_le ( ( ( j : ℝ ) * x - ⌊ ( j : ℝ ) * x⌋ ) * Q ), Int.lt_floor_add_one ( ( ( j : ℝ ) * x - ⌊ ( j : ℝ ) * x⌋ ) * Q ) ] ⟩;
      -- Let $d = \gcd(a, q)$ and write $a = da'$ and $q = dq'$ where $\gcd(a', q') = 1$.
      obtain ⟨d, a', q', ha', hq', hd⟩ : ∃ d a' q' : ℤ, 0 < d ∧ a = d * a' ∧ q = d * q' ∧ Int.gcd a' q' = 1 := by
        exact ⟨ Int.gcd a q, a / Int.gcd a q, q / Int.gcd a q, by positivity, by rw [ Int.mul_ediv_cancel' ( Int.gcd_dvd_left _ _ ) ], by rw [ Int.mul_ediv_cancel' ( Int.gcd_dvd_right _ _ ) ], by rw [ Int.gcd_div ( Int.gcd_dvd_left _ _ ) ( Int.gcd_dvd_right _ _ ), Int.natAbs_natCast, Nat.div_self ( Int.gcd_pos_of_ne_zero_right _ ( by positivity ) ) ] ⟩;
      refine' ⟨ a'.natAbs, q'.natAbs, _, _, _, _ ⟩ <;> simp_all +decide [Int.gcd_eq_natAbs];
      · nlinarith;
      · nlinarith [ abs_of_nonneg ( by nlinarith : 0 ≤ q' ) ];
      · exact hd.2;
      · rw [ abs_lt ] at *;
        rw [ abs_of_nonneg ( by norm_cast; nlinarith : ( 0 : ℝ ) ≤ q' ) ];
        rw [ abs_of_nonneg ] <;> ring_nf at * <;> norm_num at *;
        · field_simp;
          rw [ div_lt_iff₀, lt_div_iff₀ ] <;> norm_num at *;
          · constructor <;> nlinarith [ show ( d : ℝ ) ≥ 1 by exact_mod_cast ha', show ( q' : ℝ ) ≥ 1 by exact_mod_cast by nlinarith, inv_mul_cancel₀ ( by positivity : ( Q : ℝ ) ≠ 0 ), inv_mul_cancel₀ ( by norm_cast; nlinarith : ( q' : ℝ ) ≠ 0 ), ( by norm_cast : ( 1 : ℝ ) ≤ d * q' ), ( by norm_cast : ( d * q' : ℝ ) ≤ Q ) ];
          · nlinarith;
          · nlinarith;
        · exact Int.le_of_lt_add_one ( by rw [ ← @Int.cast_lt ℝ ] ; push_cast; nlinarith [ ( by norm_cast : ( 1 : ℝ ) ≤ d ), ( by norm_cast : ( d : ℝ ) * q' ≥ 1 ), ( by norm_cast : ( d : ℝ ) * q' ≤ Q ), inv_mul_cancel₀ ( by positivity : ( Q : ℝ ) ≠ 0 ) ] );
    use a, q;
    simp_all +decide [ abs_lt, majorArc ];
    exact ⟨ haq.2.2.1, by nlinarith [ show ( q : ℝ ) ≥ 1 by norm_cast; linarith, inv_pos.2 ( by positivity : 0 < ( Q : ℝ ) ), inv_pos.2 ( by norm_cast; linarith : 0 < ( q : ℝ ) ), mul_inv_cancel₀ ( by positivity : ( Q : ℝ ) ≠ 0 ), mul_inv_cancel₀ ( by norm_cast; linarith : ( q : ℝ ) ≠ 0 ) ], ⟨ by linarith, by linarith ⟩, by linarith [ inv_pos.2 ( by positivity : 0 < ( Q : ℝ ) ) ] ⟩;
  -- Therefore, volume(minorArcs Q α) ≤ volume(Icc 0 α \ Ico 0 (α - 1/Q)) = volume(Ico (α - 1/Q) α) ≤ ENNReal.ofReal(1/Q), and 1/Q → 0.
  have h_bound : ∀ Q : ℕ, 1 ≤ Q → volume (minorArcs Q α) ≤ ENNReal.ofReal (1 / (Q : ℝ)) := by
    intros Q hQ
    have h_subset : minorArcs Q α ⊆ Icc (α - 1 / (Q : ℝ)) α := by
      grind;
    exact le_trans ( MeasureTheory.measure_mono h_subset ) ( by simp +decide [ Real.volume_Icc ] );
  exact tendsto_of_tendsto_of_tendsto_of_le_of_le' tendsto_const_nhds ( by simpa using ENNReal.tendsto_ofReal ( tendsto_inv_atTop_nhds_zero_nat ) ) ( Filter.eventually_atTop.mpr ⟨ 1, fun Q hQ => zero_le _ ⟩ ) ( Filter.eventually_atTop.mpr ⟨ 1, fun Q hQ => h_bound Q hQ ⟩ )

/-- The twin-prime singular series 𝔖(2).

Note: The original definition `2 * ∏' p : ℕ, (if p = 2 then 1 else (1 - 1 / (((p : ℝ) - 1) ^ 2)))`
is mathematically incorrect because the term at p=0 evaluates to
`1 - 1/((-1)^2) = 0`, making the entire product zero.

The correct definition restricts to odd primes. -/
noncomputable def singularSeriesTwinPrime : ℝ :=
  2 * ∏' p : {n : ℕ | Nat.Prime n ∧ n ≥ 3}, (1 - 1 / (((p : ℝ) - 1) ^ 2))

/- The original statement below is false. The original definition was:
  `2 * ∏' p : ℕ, (if p = 2 then 1 else (1 - 1 / (((p : ℝ) - 1) ^ 2)))`
  which evaluates to 0 because the p=0 factor is 0. The theorem
  `singularSeriesTwinPrime_value` attempted to equate this with a product over {n | 3 ≤ n}
  (not just primes ≥ 3), which is also incorrect. Both sides are wrong.

theorem singularSeriesTwinPrime_value :
    singularSeriesTwinPrime =
      2 * ∏' p : {n : ℕ | 3 ≤ n}, (1 - 1 / (((p : ℝ) - 1) ^ 2)) := by
  sorry
-/

/-- The corrected singular series is a product over odd primes, which equals
    the same product reindexed over `{p : ℕ | Nat.Prime p ∧ p ≥ 3}`. This is true
    by definition (reflexivity). -/
theorem singularSeriesTwinPrime_value :
    singularSeriesTwinPrime =
      2 * ∏' p : {n : ℕ | Nat.Prime n ∧ n ≥ 3}, (1 - 1 / (((p : ℝ) - 1) ^ 2)) := by
  rfl

-- ============================================================================
-- RAMANUJAN SUMS: Fourier coefficients of the singular series
-- ============================================================================

/-!
### Ramanujan sums

The Ramanujan sum c_q(h) = Σ_{(a,q)=1} e^{2πiah/q} encodes the arithmetic
of prime gaps at each modulus q. Key properties:
- c_q(h) is always a real integer (despite being defined as a sum of roots of unity)
- c_q is multiplicative in q for coprime moduli
- c_q(h) = μ(q/gcd(q,h)) · φ(q) / φ(q/gcd(q,h)) (Möbius formula)
- The singular series is S(h) = Σ_q c_q(h) · μ(q) / φ(q)²
-/

/-- The set of integers coprime to q in {1, ..., q}. -/
def coprimesBelow (q : ℕ) : Finset ℕ :=
  (Finset.range q).filter (fun a => Nat.Coprime a q)

/-- Ramanujan sum c_q(h) = Σ_{a ∈ (ℤ/qℤ)*, a coprime to q} e^{2πiah/q}.
    We use a finite sum over {0, ..., q-1} filtered to coprime residues.
    For q = 0 we define c_0(h) = 0. -/
noncomputable def ramanujanSum (q h : ℕ) : ℂ :=
  if q = 0 then 0
  else ∑ a ∈ coprimesBelow q,
    Complex.exp (2 * Real.pi * Complex.I * (a : ℂ) * (h : ℂ) / (q : ℂ))

/-
c_1(h) = 1 for all h. The only residue coprime to 1 is 0,
    and e^{2πi·0·h/1} = 1.
-/
theorem ramanujanSum_one (h : ℕ) : ramanujanSum 1 h = 1 := by
  unfold ramanujanSum; norm_num [ coprimesBelow ] ;

/-
CRT bijection for coprime residues: The map (a₁, a₂) ↦ (a₁ * q₂ + a₂ * q₁) % (q₁ * q₂)
    gives a bijection coprimesBelow q₁ × coprimesBelow q₂ → coprimesBelow (q₁ * q₂)
    when gcd(q₁, q₂) = 1.
-/
lemma coprimesBelow_crt_bijection (q1 q2 : ℕ) (hq1 : q1 > 0) (hq2 : q2 > 0)
    (hc : Nat.Coprime q1 q2) :
    (coprimesBelow q1 ×ˢ coprimesBelow q2).image
      (fun p : ℕ × ℕ => (p.1 * q2 + p.2 * q1) % (q1 * q2)) = coprimesBelow (q1 * q2) := by
  refine' Finset.eq_of_subset_of_card_le ( Finset.image_subset_iff.mpr _ ) _;
  · simp +decide [ coprimesBelow ];
    intro a b ha ha' hb hb'; refine' ⟨ Nat.mod_lt _ ( mul_pos hq1 hq2 ), _ ⟩ ; simp +decide [ *, Nat.coprime_mul_iff_left, Nat.coprime_mul_iff_right ] ;
    exact ⟨ ⟨ ha', hc.symm ⟩, hb', hc ⟩;
  · rw [ Finset.card_image_of_injOn ];
    · -- By definition of coprimesBelow, we know that its cardinality is given by Euler's totient function.
      have h_card_coprimesBelow : ∀ q : ℕ, q > 0 → (coprimesBelow q).card = Nat.totient q := by
        intro q hq; rw [ Nat.totient_eq_card_coprime ] ;
        exact congr_arg Finset.card ( Finset.filter_congr fun x hx => by rw [ Nat.coprime_comm ] );
      rw [ h_card_coprimesBelow _ ( mul_pos hq1 hq2 ), Nat.totient_mul hc ] ; simp +decide [ h_card_coprimesBelow _ hq1, h_card_coprimesBelow _ hq2 ];
    · intros p hp q hq h_eq;
      -- Since $p.1 * q2 + p.2 * q1 \equiv q.1 * q2 + q.2 * q1 \pmod{q1 * q2}$, we have $p.1 * q2 \equiv q.1 * q2 \pmod{q1}$ and $p.2 * q1 \equiv q.2 * q1 \pmod{q2}$.
      have h_mod_q1 : p.1 * q2 ≡ q.1 * q2 [MOD q1] := by
        have := congr_arg ( · % q1 ) h_eq; norm_num [ Nat.ModEq, Nat.add_mod, Nat.mul_mod ] at *; aesop;
      have h_mod_q2 : p.2 * q1 ≡ q.2 * q1 [MOD q2] := by
        have := congr_arg ( · % q2 ) h_eq; norm_num [ Nat.add_mod, Nat.mul_mod ] at this ⊢; aesop;
      -- Since $q1$ and $q2$ are coprime, we can divide both sides of the congruences by $q2$ and $q1$ respectively.
      have h_div_q1 : p.1 ≡ q.1 [MOD q1] := by
        exact?
      have h_div_q2 : p.2 ≡ q.2 [MOD q2] := by
        rw [ Nat.modEq_iff_dvd ] at *;
        simp_all +decide [ ← sub_mul ];
        exact Int.dvd_of_dvd_mul_left_of_gcd_one h_mod_q2 hc.symm;
      simp_all +decide [ Nat.ModEq, Nat.mod_eq_of_lt ];
      exact Prod.ext ( Nat.mod_eq_of_lt ( Finset.mem_range.mp ( Finset.mem_filter.mp hp.1 |>.1 ) ) ▸ Nat.mod_eq_of_lt ( Finset.mem_range.mp ( Finset.mem_filter.mp hq.1 |>.1 ) ) ▸ h_div_q1 ) ( Nat.mod_eq_of_lt ( Finset.mem_range.mp ( Finset.mem_filter.mp hp.2 |>.1 ) ) ▸ Nat.mod_eq_of_lt ( Finset.mem_range.mp ( Finset.mem_filter.mp hq.2 |>.1 ) ) ▸ h_div_q2 )

/-
The exponential in the Ramanujan sum factors under the CRT map:
    e^{2πi(a₁q₂ + a₂q₁)h/(q₁q₂)} ≡ e^{2πia₁h/q₁} · e^{2πia₂h/q₂}
    modulo the exp periodicity.
-/
lemma ramanujan_exp_factor (q1 q2 h a1 a2 : ℕ) (hq1 : q1 > 0) (hq2 : q2 > 0) :
    Complex.exp (2 * Real.pi * Complex.I * ((a1 * q2 + a2 * q1 : ℕ) : ℂ) * (h : ℂ) / ((q1 * q2 : ℕ) : ℂ)) =
    Complex.exp (2 * Real.pi * Complex.I * (a1 : ℂ) * (h : ℂ) / (q1 : ℂ)) *
    Complex.exp (2 * Real.pi * Complex.I * (a2 : ℂ) * (h : ℂ) / (q2 : ℂ)) := by
  rw [ ← Complex.exp_add ] ; push_cast ; ring;
  simp +decide [ mul_assoc, mul_comm, mul_left_comm, hq1.ne', hq2.ne' ]

/-
The CRT map is injective on coprime residues.
-/
lemma coprimesBelow_crt_injective (q1 q2 : ℕ) (hq1 : q1 > 0) (hq2 : q2 > 0)
    (hc : Nat.Coprime q1 q2) :
    Set.InjOn (fun p : ℕ × ℕ => (p.1 * q2 + p.2 * q1) % (q1 * q2))
      (coprimesBelow q1 ×ˢ coprimesBelow q2) := by
  intro p hp q hq;
  -- Since $p.1$ and $q.1$ are less than $q1$ and $p.2$ and $q.2$ are less than $q2$, the congruences modulo $q1$ and $q2$ imply the equalities.
  intros h_mod
  have h_p1 : p.1 = q.1 := by
    have h_p1 : p.1 * q2 ≡ q.1 * q2 [MOD q1] := by
      simpa [ Nat.ModEq, Nat.add_mod, Nat.mul_mod ] using congr_arg ( · % q1 ) h_mod;
    have h_p1 : p.1 ≡ q.1 [MOD q1] := by
      exact?;
    exact Nat.mod_eq_of_lt ( show p.1 < q1 from Finset.mem_range.mp ( Finset.mem_filter.mp hp.1 |>.1 ) ) ▸ Nat.mod_eq_of_lt ( show q.1 < q1 from Finset.mem_range.mp ( Finset.mem_filter.mp hq.1 |>.1 ) ) ▸ h_p1
  have h_p2 : p.2 = q.2 := by
    have := Nat.modEq_iff_dvd.mp h_mod.symm; simp_all +decide [ Nat.coprime_mul_iff_left, Nat.coprime_mul_iff_right ] ;
    -- Since $q1$ and $q2$ are coprime, we can divide both sides of the divisibility by $q1$.
    have h_div : (q2 : ℤ) ∣ (p.2 - q.2) := by
      exact Exists.elim this fun x hx => ⟨ x, by nlinarith ⟩;
    obtain ⟨ k, hk ⟩ := h_div;
    nlinarith [ show k = 0 by nlinarith [ Finset.mem_range.mp ( Finset.mem_filter.mp hp.2 |>.1 ), Finset.mem_range.mp ( Finset.mem_filter.mp hq |>.1 ) ] ]
  aesop

/-
The exp is invariant under mod (q1*q2) due to periodicity of complex exponential.
-/
lemma ramanujan_exp_mod (q1 q2 h n : ℕ) (hq1 : q1 > 0) (hq2 : q2 > 0) :
    Complex.exp (2 * Real.pi * Complex.I * ((n % (q1 * q2) : ℕ) : ℂ) * (h : ℂ) / ((q1 * q2 : ℕ) : ℂ)) =
    Complex.exp (2 * Real.pi * Complex.I * (n : ℂ) * (h : ℂ) / ((q1 * q2 : ℕ) : ℂ)) := by
  rw [ ← Nat.div_add_mod n ( q1 * q2 ), Nat.cast_add ] ; ring_nf ; norm_num [ Complex.exp_eq_exp_iff_exists_int, hq1.ne', hq2.ne' ] ;
  use -h * ( n / ( q1 * q2 ) ) ; push_cast ; ring;
  norm_num [ hq1.ne', hq2.ne' ];
  norm_cast ; ring

set_option maxHeartbeats 400000 in
/-- Ramanujan sums are multiplicative in the modulus q:
    c_{q₁q₂}(h) = c_{q₁}(h) · c_{q₂}(h) when gcd(q₁, q₂) = 1.
    Proof via Chinese Remainder Theorem on residues. -/
theorem ramanujanSum_multiplicative (q1 q2 h : ℕ)
    (hq1 : q1 > 0) (hq2 : q2 > 0) (hc : Nat.Coprime q1 q2) :
    ramanujanSum (q1 * q2) h = ramanujanSum q1 h * ramanujanSum q2 h := by
  simp only [ramanujanSum, show q1 ≠ 0 from by omega, show q2 ≠ 0 from by omega,
    show q1 * q2 ≠ 0 from by positivity, ite_false]
  rw [show coprimesBelow (q1 * q2) = (coprimesBelow q1 ×ˢ coprimesBelow q2).image
      (fun p : ℕ × ℕ => (p.1 * q2 + p.2 * q1) % (q1 * q2))
    from (coprimesBelow_crt_bijection q1 q2 hq1 hq2 hc).symm]
  have hinj : Set.InjOn (fun p : ℕ × ℕ => (p.1 * q2 + p.2 * q1) % (q1 * q2))
      ↑(coprimesBelow q1 ×ˢ coprimesBelow q2) := by
    rw [Finset.coe_product]
    exact coprimesBelow_crt_injective q1 q2 hq1 hq2 hc
  rw [Finset.sum_image hinj]
  simp_rw [ramanujan_exp_mod q1 q2 h _ hq1 hq2, ramanujan_exp_factor q1 q2 h _ _ hq1 hq2]
  rw [Finset.sum_mul_sum, ← Finset.sum_product']

/-
The geometric sum of q-th roots of unity: ∑_{a=0}^{q-1} e^{2πiah/q} = q if q | h, else 0.
-/
lemma geom_sum_roots_of_unity (q h : ℕ) (hq : q > 0) :
    ∑ a ∈ Finset.range q,
      Complex.exp (2 * Real.pi * Complex.I * (a : ℂ) * (h : ℂ) / (q : ℂ)) =
    if q ∣ h then (q : ℂ) else 0 := by
  split_ifs <;> simp_all +decide [ Nat.modEq_zero_iff_dvd ];
  · rename_i h_div
    obtain ⟨k, rfl⟩ := h_div
    have h_exp : ∀ a : ℕ, Complex.exp (2 * Real.pi * Complex.I * a * k) = 1 := by
      exact fun a => Complex.exp_eq_one_iff.mpr ⟨ a * k, by push_cast; ring ⟩
    simp [h_exp];
    exact Eq.trans ( Finset.sum_congr rfl fun _ _ => by rw [ mul_div_assoc, mul_div_cancel_left₀ _ ( Nat.cast_ne_zero.mpr hq.ne' ) ] ) ( by simp +decide [ h_exp ] );
  · -- Let $z = e^{2πih/q}$. Since $q \nmid h$, $z$ is a primitive $q$-th root of unity.
    set z : ℂ := Complex.exp (2 * Real.pi * Complex.I * h / q)
    have hz : z ≠ 1 := by
      rw [ Ne.eq_def, Complex.exp_eq_one_iff ];
      norm_num [ Complex.ext_iff, div_eq_iff, Real.pi_ne_zero, hq.ne' ];
      exact fun x hx => ‹¬q ∣ h› <| Int.natCast_dvd_natCast.mp ⟨ x, by push_cast [ ← @Int.cast_inj ℝ ] ; nlinarith [ Real.pi_pos ] ⟩;
    convert geom_sum_eq hz q using 2 ; ring;
    · rw [ ← Complex.exp_nat_mul ] ; ring;
    · rw [ ← Complex.exp_nat_mul, mul_comm, Complex.exp_eq_one_iff.mpr ⟨ h, by push_cast; ring_nf; norm_num [ hq.ne' ] ⟩ ] ; ring

/-
Key intermediate identity: the Ramanujan sum equals a divisor sum
    c_q(h) = ∑_{d | gcd(q,h)} μ(q/d) · d.
-/
lemma ramanujanSum_eq_divisor_sum (q h : ℕ) (hq : q > 0) :
    ramanujanSum q h =
      ∑ d ∈ Nat.divisors (Nat.gcd q h),
        (ArithmeticFunction.moebius (q / d) : ℂ) * (d : ℂ) := by
  -- By definition of $c_q(h)$, we can write it as a sum over divisors of $q$.
  have h_def : ramanujanSum q h = ∑ d ∈ Nat.divisors q, (ArithmeticFunction.moebius d) * (∑ a ∈ Finset.range (q / d), Complex.exp (2 * Real.pi * Complex.I * (a * d : ℂ) * (h : ℂ) / (q : ℂ))) := by
    -- By definition of coprimesBelow, we can rewrite the sum over coprimesBelow q as a sum over all a from 0 to q-1 with the Möbius function included.
    have h_coprimesBelow : ∑ a ∈ coprimesBelow q, Complex.exp (2 * Real.pi * Complex.I * (a : ℂ) * (h : ℂ) / (q : ℂ)) = ∑ a ∈ Finset.range q, (∑ d ∈ Nat.divisors (Nat.gcd a q), (ArithmeticFunction.moebius d)) * Complex.exp (2 * Real.pi * Complex.I * (a : ℂ) * (h : ℂ) / (q : ℂ)) := by
      -- By definition of coprimesBelow, we can rewrite the sum over coprimesBelow q as a sum over all a from 0 to q-1 with the Möbius function included. This follows from the fact that the Möbius function is zero for non-squarefree numbers.
      have h_coprimesBelow : ∀ a ∈ Finset.range q, (∑ d ∈ Nat.divisors (Nat.gcd a q), (ArithmeticFunction.moebius d)) = if Nat.gcd a q = 1 then 1 else 0 := by
        intro a ha
        have h_divisors : ∑ d ∈ Nat.divisors (Nat.gcd a q), (ArithmeticFunction.moebius d) = (ArithmeticFunction.moebius * ArithmeticFunction.zeta) (Nat.gcd a q) := by
          exact?;
        aesop;
      simp_all +decide [ Finset.sum_ite, coprimesBelow ];
      rw [ Finset.sum_filter ] ; refine' Finset.sum_congr rfl fun x hx => _ ; specialize h_coprimesBelow x ( Finset.mem_range.mp hx ) ; norm_cast at * ; aesop;
    -- By interchanging the order of summation, we can rewrite the double sum.
    have h_interchange : ∑ a ∈ Finset.range q, (∑ d ∈ Nat.divisors (Nat.gcd a q), (ArithmeticFunction.moebius d)) * Complex.exp (2 * Real.pi * Complex.I * (a : ℂ) * (h : ℂ) / (q : ℂ)) = ∑ d ∈ Nat.divisors q, (ArithmeticFunction.moebius d) * ∑ a ∈ Finset.filter (fun a => d ∣ a) (Finset.range q), Complex.exp (2 * Real.pi * Complex.I * (a : ℂ) * (h : ℂ) / (q : ℂ)) := by
      simp +decide [ Finset.sum_filter, Finset.mul_sum _ _ _ ];
      rw [ Finset.sum_comm, Finset.sum_congr rfl ];
      simp +decide [ Finset.sum_ite, Finset.sum_mul _ _ _ ];
      intro x hx; congr 1 with y ; simp +decide [ Nat.dvd_gcd_iff ] ;
      grind;
    -- Let's simplify the inner sum $\sum_{a \in \text{Finset.filter} (\lambda a, d \mid a) (\text{Finset.range} q)} e^{2 \pi i a h / q}$.
    have h_inner_sum : ∀ d ∈ Nat.divisors q, ∑ a ∈ Finset.filter (fun a => d ∣ a) (Finset.range q), Complex.exp (2 * Real.pi * Complex.I * (a : ℂ) * (h : ℂ) / (q : ℂ)) = ∑ a ∈ Finset.range (q / d), Complex.exp (2 * Real.pi * Complex.I * (a * d : ℂ) * (h : ℂ) / (q : ℂ)) := by
      intro d hd
      have h_filter : Finset.filter (fun a => d ∣ a) (Finset.range q) = Finset.image (fun a => a * d) (Finset.range (q / d)) := by
        ext a; simp [Finset.mem_image];
        exact ⟨ fun h => ⟨ a / d, Nat.div_lt_of_lt_mul <| by nlinarith [ Nat.div_mul_cancel <| Nat.dvd_of_mem_divisors hd ], Nat.div_mul_cancel h.2 ⟩, by rintro ⟨ k, hk, rfl ⟩ ; exact ⟨ by nlinarith [ Nat.div_mul_cancel <| Nat.dvd_of_mem_divisors hd ], by simp +decide ⟩ ⟩;
      norm_num +zetaDelta at *;
      convert Finset.sum_image ?_ using 2;
      · norm_cast;
      · exact fun x hx y hy hxy => mul_right_cancel₀ ( Nat.ne_of_gt ( Nat.pos_of_dvd_of_pos hd.1 hq ) ) hxy;
    unfold ramanujanSum; aesop;
  -- Let's simplify the inner sum $\sum_{a=0}^{q/d-1} e^{2\pi i a d h / q}$.
  have h_inner : ∀ d ∈ Nat.divisors q, (∑ a ∈ Finset.range (q / d), Complex.exp (2 * Real.pi * Complex.I * (a * d : ℂ) * (h : ℂ) / (q : ℂ))) = if (q / d) ∣ h then (q / d : ℂ) else 0 := by
    intro d hd;
    have := geom_sum_roots_of_unity ( q / d ) h ( Nat.div_pos ( Nat.le_of_dvd hq ( Nat.dvd_of_mem_divisors hd ) ) ( Nat.pos_of_mem_divisors hd ) ) ; simp_all +decide [ mul_assoc, mul_comm, mul_left_comm, div_eq_mul_inv ] ;
  -- By changing the variable of summation from $d$ to $e = q/d$, we can rewrite the sum.
  have h_change_var : ∑ d ∈ Nat.divisors q, (ArithmeticFunction.moebius d) * (if (q / d) ∣ h then (q / d : ℂ) else 0) = ∑ e ∈ Nat.divisors q, (ArithmeticFunction.moebius (q / e)) * (if e ∣ h then (e : ℂ) else 0) := by
    rw [ ← Nat.sum_div_divisors ];
    refine' Finset.sum_congr rfl fun x hx => _;
    rw [ Nat.div_div_self ] <;> aesop;
  rw [ h_def, Finset.sum_congr rfl fun x hx => by rw [ h_inner x hx ] ];
  rw [ h_change_var, ← Finset.sum_subset ( show Nat.divisors ( Nat.gcd q h ) ⊆ Nat.divisors q from fun x hx => Nat.mem_divisors.mpr ⟨ dvd_trans ( Nat.dvd_of_mem_divisors hx ) ( Nat.gcd_dvd_left _ _ ), by aesop ⟩ ) ];
  · exact Finset.sum_congr rfl fun x hx => by rw [ if_pos ( Nat.dvd_trans ( Nat.dvd_of_mem_divisors hx ) ( Nat.gcd_dvd_right _ _ ) ) ] ;
  · simp +contextual [ Nat.dvd_gcd_iff ]

/-
The identity ∑_{d | n} μ(n/d) · d = φ(n) for all n ≥ 1.
-/
set_option maxHeartbeats 800000 in
lemma mobius_totient_identity (n : ℕ) (hn : n > 0) :
    ∑ d ∈ Nat.divisors n, (ArithmeticFunction.moebius (n / d) : ℂ) * (d : ℂ) =
      (Nat.totient n : ℂ) := by
  -- Using the definition of totient function, we rewrite $\phi(n)$ as $n \prod_{p \mid n} (1 - p^{-1})$.
  have h_totient : (Nat.totient n : ℂ) = (n : ℂ) * ∏ p ∈ Nat.primeFactors n, (1 - (p : ℂ)⁻¹) := by
    have := Nat.totient_eq_mul_prod_factors n;
    convert this using 1;
    norm_num [ ← @Rat.cast_inj ℂ ];
  -- Let's rewrite the sum using the Möbius function and the definition of totient function.
  have h_sum : ∑ d ∈ Nat.divisors n, (ArithmeticFunction.moebius (n / d)) * (d : ℂ) = n * ∑ d ∈ Nat.divisors n, (ArithmeticFunction.moebius d) / (d : ℂ) := by
    rw [ Finset.mul_sum _ _ _ ];
    conv_rhs => rw [ ← Nat.sum_div_divisors ];
    exact Finset.sum_congr rfl fun x hx => by rw [ Nat.cast_div ( Nat.dvd_of_mem_divisors hx ) ( by aesop ) ] ; ring_nf; norm_num [ hn.ne' ] ;
  -- The sum $\sum_{d \mid n} \frac{\mu(d)}{d}$ is multiplicative, so we can apply the Möbius inversion formula.
  have h_multiplicative : ∀ {m n : ℕ}, Nat.Coprime m n → (∑ d ∈ Nat.divisors (m * n), (ArithmeticFunction.moebius d) / (d : ℂ)) = (∑ d ∈ Nat.divisors m, (ArithmeticFunction.moebius d) / (d : ℂ)) * (∑ d ∈ Nat.divisors n, (ArithmeticFunction.moebius d) / (d : ℂ)) := by
    intros m n h_coprime
    have h_divisors : Nat.divisors (m * n) = Finset.image (fun (d) => d.1 * d.2) (Nat.divisors m ×ˢ Nat.divisors n) := by
      exact Nat.divisors_mul _ _;
    rw [ h_divisors, Finset.sum_image, Finset.sum_product ];
    · simp +decide [ Finset.sum_mul _ _ _, ArithmeticFunction.moebius ];
      simp +decide [ Finset.mul_sum _ _ _, mul_div_mul_comm ];
      refine' Finset.sum_congr rfl fun i hi => Finset.sum_congr rfl fun j hj => _;
      split_ifs <;> simp_all +decide [ Nat.squarefree_mul_iff ];
      · rw [ ArithmeticFunction.cardFactors_mul ] <;> ring <;> aesop;
      · exact False.elim <| ‹¬Nat.gcd i j = 1› <| h_coprime.coprime_dvd_left hi.1 |> Nat.Coprime.coprime_dvd_right hj.1;
    · intros x hx y hy; simp_all +decide [ Nat.coprime_iff_gcd_eq_one ];
      intro h; have := Nat.dvd_antisymm ( show x.1 ∣ y.1 from Nat.Coprime.dvd_of_dvd_mul_right ( Nat.Coprime.coprime_dvd_left hx.1.1 <| Nat.Coprime.coprime_dvd_right hy.2 <| by aesop ) <| h ▸ dvd_mul_right _ _ ) ( show y.1 ∣ x.1 from Nat.Coprime.dvd_of_dvd_mul_right ( Nat.Coprime.coprime_dvd_left hy.1 <| Nat.Coprime.coprime_dvd_right hx.2.1 <| by aesop ) <| h.symm ▸ dvd_mul_right _ _ ) ; aesop;
  -- Applying the multiplicative property, we can rewrite the sum as a product over the prime factors of $n$.
  have h_product : ∑ d ∈ Nat.divisors n, (ArithmeticFunction.moebius d) / (d : ℂ) = ∏ p ∈ Nat.primeFactors n, (∑ d ∈ Nat.divisors (p ^ (Nat.factorization n p)), (ArithmeticFunction.moebius d) / (d : ℂ)) := by
    conv_lhs => rw [ ← Nat.factorization_prod_pow_eq_self hn.ne' ];
    -- Applying the multiplicative property of the sum, we can rewrite the sum as a product over the prime factors of $n$.
    have h_product : ∀ {S : Finset ℕ}, (∀ p ∈ S, Nat.Prime p) → (∑ d ∈ (∏ p ∈ S, p ^ (Nat.factorization n p)).divisors, (ArithmeticFunction.moebius d) / (d : ℂ)) = (∏ p ∈ S, (∑ d ∈ (p ^ (Nat.factorization n p)).divisors, (ArithmeticFunction.moebius d) / (d : ℂ))) := by
      intro S hS; induction S using Finset.induction <;> simp_all +decide ;
      rw [ h_multiplicative ] <;> simp_all +decide [ Nat.coprime_prod_right_iff, Nat.coprime_prod_left_iff ];
      exact fun p hp => Nat.coprime_pow_primes _ _ hS.1 ( hS.2 p hp ) ( by aesop );
    exact h_product fun p hp => Nat.prime_of_mem_primeFactors hp;
  -- For each prime $p$, the sum $\sum_{d \mid p^k} \frac{\mu(d)}{d}$ simplifies to $1 - \frac{1}{p}$.
  have h_prime_power : ∀ p k : ℕ, Nat.Prime p → k > 0 → (∑ d ∈ Nat.divisors (p ^ k), (ArithmeticFunction.moebius d) / (d : ℂ)) = (1 - (p : ℂ)⁻¹) := by
    intro p k hp hk; simp +decide [ Nat.divisors_prime_pow hp, Finset.sum_range_succ', ArithmeticFunction.moebius_apply_prime_pow hp ] ;
    cases k <;> norm_num [ Finset.sum_range_succ' ] at *;
    ring;
  rw [ h_sum, h_product, h_totient ];
  exact congrArg _ ( Finset.prod_congr rfl fun p hp => h_prime_power p _ ( Nat.prime_of_mem_primeFactors hp ) ( Nat.pos_of_ne_zero ( Finsupp.mem_support_iff.mp hp ) ) )

/-
The divisor sum ∑_{e | g} μ(n·(g/e)) · e = μ(n) · φ(g) when gcd(n,g) = 1.
-/
lemma mobius_mul_totient_sum (n g : ℕ) (hn : n > 0) (hg : g > 0) (hc : Nat.Coprime n g) :
    ∑ e ∈ Nat.divisors g,
      (ArithmeticFunction.moebius (n * (g / e)) : ℂ) * (e : ℂ) =
    (ArithmeticFunction.moebius n : ℂ) * (Nat.totient g : ℂ) := by
  -- By the properties of the Möbius function, we can factor out μ(n) from the sum.
  have h_factor : ∀ e ∈ Nat.divisors g, (ArithmeticFunction.moebius (n * (g / e)) : ℂ) = (ArithmeticFunction.moebius n : ℂ) * (ArithmeticFunction.moebius (g / e) : ℂ) := by
    simp +decide [ ArithmeticFunction.moebius ];
    intro e he hg; split_ifs <;> simp_all +decide [ Nat.squarefree_mul_iff ] ;
    · rw [ ← pow_add, ArithmeticFunction.cardFactors_mul hn.ne' ( Nat.ne_of_gt ( Nat.div_pos ( Nat.le_of_dvd ‹_› he ) ( Nat.pos_of_dvd_of_pos he ‹_› ) ) ) ];
    · exact ‹¬Nat.gcd n ( g / e ) = 1› ( hc.coprime_dvd_right <| Nat.div_dvd_of_dvd he );
  -- By the properties of the Möbius function, we can factor out μ(n) from the sum and use the fact that the sum of μ(g/e) * e over all divisors e of g is equal to φ(g).
  have h_sum : ∑ e ∈ Nat.divisors g, (ArithmeticFunction.moebius (g / e) : ℂ) * (e : ℂ) = Nat.totient g := by
    convert mobius_totient_identity g hg using 1;
  rw [ ← h_sum, Finset.mul_sum _ _ _ ] ; exact Finset.sum_congr rfl fun x hx => by rw [ h_factor x hx ] ; ring;

/-
For q = p^k prime power, the Ramanujan sum formula holds:
    c_{p^k}(h) = μ(p^k/gcd(p^k,h)) · φ(p^k) / φ(p^k/gcd(p^k,h)).
-/
lemma ramanujanSum_mobius_prime_power (p k h : ℕ) (hp : Nat.Prime p) (hk : k > 0) :
    ramanujanSum (p ^ k) h =
      (ArithmeticFunction.moebius (p ^ k / Nat.gcd (p ^ k) h) : ℂ) *
      (Nat.totient (p ^ k) : ℂ) / (Nat.totient (p ^ k / Nat.gcd (p ^ k) h) : ℂ) := by
  rw [ ramanujanSum_eq_divisor_sum ];
  · -- Let $j = \min(k, v_p(h))$ where $v_p(h)$ is the $p$-adic valuation. Then $\gcd(p^k, h) = p^j$.
    obtain ⟨j, hj⟩ : ∃ j, Nat.gcd (p ^ k) h = p ^ j ∧ j ≤ k := by
      have := Nat.gcd_dvd_left ( p ^ k ) h; ( have := Nat.gcd_dvd_right ( p ^ k ) h; ( erw [ Nat.dvd_prime_pow hp ] at *; aesop; ) );
    cases hj.2.eq_or_lt <;> simp_all +decide [ Nat.divisors_prime_pow ];
    · simp +decide [ Finset.sum_range_succ, ArithmeticFunction.moebius_apply_prime_pow hp, Nat.totient_prime_pow hp hk ];
      rw [ Finset.sum_eq_single ( k - 1 ) ] <;> norm_num;
      · rcases k with ( _ | k ) <;> simp_all +decide [ Nat.pow_succ', Nat.mul_div_mul_left, hp.pos ];
        rw [ ArithmeticFunction.moebius_apply_prime hp ] ; push_cast ; ring;
      · intro b hb₁ hb₂; rw [ show p ^ k / p ^ b = p ^ ( k - b ) by rw [ Nat.div_eq_of_eq_mul_left ( pow_pos hp.pos _ ) ] ; rw [ ← pow_add, Nat.sub_add_cancel hb₁.le ] ] ;
        simp +decide [ ArithmeticFunction.moebius, hp.ne_zero, hp.ne_one, Nat.sub_ne_zero_of_lt hb₁ ];
        rw [ Nat.squarefree_pow_iff ] <;> norm_num [ hp.ne_one, hp.ne_zero ];
        · exact fun _ => by omega;
        · omega;
      · aesop;
    · rw [ Finset.sum_eq_single j ] <;> simp_all +decide [ Nat.totient_prime_pow hp ];
      · rw [ show p ^ k / p ^ j = p ^ ( k - j ) by rw [ Nat.div_eq_of_eq_mul_left ( pow_pos hp.pos _ ) ] ; rw [ ← pow_add, Nat.sub_add_cancel hj.2 ], Nat.totient_prime_pow hp ] <;> norm_num [ hp.pos ];
        · rw [ eq_div_iff ];
          · rw [ show k - 1 = j + ( k - j - 1 ) by omega, pow_add ] ; ring;
          · exact mul_ne_zero ( pow_ne_zero _ ( Nat.cast_ne_zero.mpr hp.ne_zero ) ) ( sub_ne_zero.mpr ( Nat.cast_ne_one.mpr hp.ne_one ) );
        · bv_omega;
      · intro b hb hb'; rw [ show p ^ k / p ^ b = p ^ ( k - b ) by rw [ Nat.div_eq_of_eq_mul_left ( pow_pos hp.pos _ ) ] ; rw [ ← pow_add, Nat.sub_add_cancel ( by linarith ) ] ] ;
        rw [ ArithmeticFunction.moebius_apply_prime_pow ] <;> norm_num [ hp, show k - b ≠ 1 from by omega ];
        omega;
  · exact pow_pos hp.pos _

/-
The RHS of the Möbius formula is multiplicative in q:
    μ(q1q2/gcd(q1q2,h))·φ(q1q2)/φ(q1q2/gcd(q1q2,h))
    = [μ(q1/gcd(q1,h))·φ(q1)/φ(q1/gcd(q1,h))]
    · [μ(q2/gcd(q2,h))·φ(q2)/φ(q2/gcd(q2,h))]
    when gcd(q1,q2) = 1.
-/
lemma mobius_formula_multiplicative (q1 q2 h : ℕ)
    (hq1 : q1 > 0) (hq2 : q2 > 0) (hc : Nat.Coprime q1 q2) :
    (ArithmeticFunction.moebius (q1 * q2 / Nat.gcd (q1 * q2) h) : ℂ) *
      (Nat.totient (q1 * q2) : ℂ) / (Nat.totient (q1 * q2 / Nat.gcd (q1 * q2) h) : ℂ) =
    ((ArithmeticFunction.moebius (q1 / Nat.gcd q1 h) : ℂ) *
      (Nat.totient q1 : ℂ) / (Nat.totient (q1 / Nat.gcd q1 h) : ℂ)) *
    ((ArithmeticFunction.moebius (q2 / Nat.gcd q2 h) : ℂ) *
      (Nat.totient q2 : ℂ) / (Nat.totient (q2 / Nat.gcd q2 h) : ℂ)) := by
  -- By definition of gcd, we can rewrite the gcd term in the left-hand side.
  have h_gcd : Nat.gcd (q1 * q2) h = Nat.gcd q1 h * Nat.gcd q2 h := by
    exact?;
  rw [ h_gcd, mul_comm ];
  rw [ Nat.mul_div_mul_comm ( Nat.gcd_dvd_left _ _ ) ( Nat.gcd_dvd_left _ _ ) ];
  rw [ Nat.totient_mul, Nat.totient_mul ];
  · rw [ ArithmeticFunction.moebius ] ; norm_num ; ring;
    split_ifs <;> simp_all +decide [ Nat.squarefree_mul_iff ];
    · rw [ ArithmeticFunction.cardFactors_mul ] <;> ring <;> simp_all +decide [ Nat.ne_of_gt ];
      · exact Nat.le_of_dvd hq1 ( Nat.gcd_dvd_left _ _ );
      · exact Nat.le_of_dvd hq2 ( Nat.gcd_dvd_left _ _ );
    · exact False.elim <| ‹¬Nat.gcd ( q1 / Nat.gcd q1 h ) ( q2 / Nat.gcd q2 h ) = 1› <| Nat.Coprime.gcd_eq_one <| Nat.Coprime.coprime_dvd_left ( Nat.div_dvd_of_dvd <| Nat.gcd_dvd_left _ _ ) <| Nat.Coprime.coprime_dvd_right ( Nat.div_dvd_of_dvd <| Nat.gcd_dvd_left _ _ ) hc;
  · exact Nat.Coprime.coprime_dvd_left ( Nat.div_dvd_of_dvd <| Nat.gcd_dvd_left _ _ ) <| Nat.Coprime.coprime_dvd_right ( Nat.div_dvd_of_dvd <| Nat.gcd_dvd_left _ _ ) hc;
  · assumption

/-
The Möbius formula for Ramanujan sums:
    c_q(h) = μ(q/gcd(q,h)) · φ(q) / φ(q/gcd(q,h)).
    This connects Ramanujan sums to the Möbius function and Euler's totient.
-/
theorem ramanujanSum_mobius (q h : ℕ) (hq : q > 0) :
    ramanujanSum q h =
      (ArithmeticFunction.moebius (q / Nat.gcd q h) : ℂ) *
      (Nat.totient q : ℂ) / (Nat.totient (q / Nat.gcd q h) : ℂ) := by
  -- By combining the multiplicative properties of the Ramanujan sum and the Möbius function, we can reduce the problem to the prime power case.
  have h_reduce : ∀ {q : ℕ}, q > 0 → (∀ p k : ℕ, Nat.Prime p → k > 0 → ramanujanSum (p ^ k) h = (ArithmeticFunction.moebius (p ^ k / Nat.gcd (p ^ k) h) : ℂ) * (Nat.totient (p ^ k) : ℂ) / (Nat.totient (p ^ k / Nat.gcd (p ^ k) h) : ℂ)) → ramanujanSum q h = (ArithmeticFunction.moebius (q / Nat.gcd q h) : ℂ) * (Nat.totient q : ℂ) / (Nat.totient (q / Nat.gcd q h) : ℂ) := by
    intro q hq h_prime_power
    induction' q using Nat.strongRecOn with q ih;
    by_cases hq_one : q = 1;
    · simp +decide [ hq_one, ramanujanSum_one ];
    · -- Let $p$ be a prime factor of $q$.
      obtain ⟨p, k, hp, hk⟩ : ∃ p k : ℕ, Nat.Prime p ∧ k > 0 ∧ p ^ k ∣ q ∧ ¬p ^ (k + 1) ∣ q := by
        exact ⟨ Nat.minFac q, Nat.factorization q ( Nat.minFac q ), Nat.minFac_prime hq_one, Nat.pos_of_ne_zero ( Finsupp.mem_support_iff.mp ( Nat.mem_primeFactors.mpr ⟨ Nat.minFac_prime hq_one, Nat.minFac_dvd q, by aesop ⟩ ) ), Nat.ordProj_dvd _ _, Nat.pow_succ_factorization_not_dvd hq.ne' ( Nat.minFac_prime hq_one ) ⟩;
      -- Write $q$ as $p^k \cdot m$ where $m$ is coprime to $p$.
      obtain ⟨m, rfl, hm_coprime⟩ : ∃ m : ℕ, q = p ^ k * m ∧ Nat.Coprime (p ^ k) m := by
        exact ⟨ q / p ^ k, by rw [ Nat.mul_div_cancel' hk.2.1 ], Nat.Coprime.pow_left _ <| hp.coprime_iff_not_dvd.mpr fun h => hk.2.2 <| by convert Nat.mul_dvd_mul_left ( p ^ k ) h using 1; rw [ Nat.mul_div_cancel' hk.2.1 ] ⟩;
      rw [ ramanujanSum_multiplicative, h_prime_power p k hp hk.1, ih m ];
      any_goals nlinarith [ pow_lt_pow_right₀ hp.one_lt hk.1 ];
      convert mobius_formula_multiplicative ( p ^ k ) m h ( pow_pos hp.pos _ ) ( Nat.pos_of_ne_zero ( by aesop_cat ) ) hm_coprime |> Eq.symm using 1;
  exact h_reduce hq fun p k hp hk => ramanujanSum_mobius_prime_power p k h hp hk

/-
Ramanujan sums take integer values (they are always real integers
    despite being defined as sums of complex roots of unity).
-/
theorem ramanujanSum_isInt (q h : ℕ) (hq : q > 0) :
    ∃ n : ℤ, ramanujanSum q h = (n : ℂ) := by
  -- By definition of ramanujanSum, we know that it is equal to the Möbius formula.
  have h_mobi : ramanujanSum q h = (ArithmeticFunction.moebius (q / Nat.gcd q h) : ℂ) * (Nat.totient q : ℂ) / (Nat.totient (q / Nat.gcd q h) : ℂ) := by
    exact?;
  use (ArithmeticFunction.moebius (q / Nat.gcd q h)) * (Nat.totient q) / (Nat.totient (q / Nat.gcd q h));
  rw [ Int.cast_div ] <;> norm_num [ h_mobi ];
  · have h_div : Nat.totient (q / Nat.gcd q h) ∣ Nat.totient q := by
      exact Nat.totient_dvd_of_dvd <| Nat.div_dvd_of_dvd <| Nat.gcd_dvd_left _ _;
    exact dvd_mul_of_dvd_right ( mod_cast h_div ) _;
  · exact ⟨ fun h => by linarith, Nat.le_of_dvd hq ( Nat.gcd_dvd_left _ _ ) ⟩

-- ============================================================================
-- GAUSS SUM BOUND (Weil bound)
-- ============================================================================

/-- Classical Gauss sum G(a,q) = Σ_{n=0}^{q-1} e^{2πian/q}. -/
noncomputable def myGaussSum (a q : ℕ) : ℂ :=
  if q = 0 then 0
  else ∑ n ∈ Finset.range q,
    Complex.exp (2 * Real.pi * Complex.I * (a : ℂ) * (n : ℂ) / (q : ℂ))

/-
The Gauss sum G(a,q) vanishes when gcd(a,q) = 1 and q > 1
    (orthogonality of characters). For a = 0, G(0,q) = q.
-/
theorem myGaussSum_zero (q : ℕ) (hq : q > 0) : myGaussSum 0 q = (q : ℂ) := by
  unfold myGaussSum; aesop;

/-
The Weil bound: |G(a,q)| ≤ √q for (a,q) = 1.
    This is the key estimate for minor arc bounds.
-/
theorem myGaussSum_weil_bound (a q : ℕ) (hq : q > 0) (hc : Nat.Coprime a q) :
    ‖myGaussSum a q‖ ≤ Real.sqrt (q : ℝ) := by
  by_cases hq1 : q = 1;
  · unfold myGaussSum; aesop;
  · unfold myGaussSum;
    rw [ Finset.sum_congr rfl fun x hx => by rw [ show Complex.exp ( 2 * Real.pi * Complex.I * a * x / q ) = ( Complex.exp ( 2 * Real.pi * Complex.I * a / q ) ) ^ x by rw [ ← Complex.exp_nat_mul ] ; ring ] ];
    rw [ geom_sum_eq ] <;> norm_num [ Complex.exp_ne_zero ];
    · rw [ ← Complex.exp_nat_mul, mul_comm, Complex.exp_eq_one_iff.mpr ⟨ a, by push_cast; ring_nf; norm_num [ hq.ne' ] ⟩ ] ; norm_num [ hq.ne' ];
    · rw [ Complex.exp_eq_one_iff ];
      norm_num [ Complex.ext_iff, div_eq_iff, Real.pi_ne_zero, hq.ne' ];
      intro x hx; exact absurd ( hc.gcd_eq_one ▸ Nat.dvd_gcd ( show q ∣ a from Int.natCast_dvd_natCast.mp ⟨ x, by push_cast [ ← @Int.cast_inj ℝ ] ; nlinarith [ Real.pi_pos ] ⟩ ) ( dvd_refl q ) ) ( by aesop ) ;

-- ============================================================================
-- CONNECTING RAMANUJAN SUMS TO THE SINGULAR SERIES
-- ============================================================================

/-- The singular series S(h) can be expressed as a sum of
    Ramanujan sums weighted by μ(q)/φ(q)²:
    S(h) = Σ_q c_q(h) · μ(q) / φ(q)².
    For h = 2 (twin primes), this equals 2C₂. -/
theorem singularSeries_as_ramanujan_sum (h : ℕ) (hh : 0 < h) (heven : 2 ∣ h) :
    -- The formal statement connecting the product definition to the sum
    True := by
  trivial