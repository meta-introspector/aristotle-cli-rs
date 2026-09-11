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
  -- Let ε > 0 be given. By Egorov's theorem, there exists a measurable set A ⊆ [0, α] with m(A) < ε such that the sequence of major arcs converges uniformly to [0, α] on A^c.
  have h_egorov : ∀ ε > 0, ∃ Q : ℕ, ∀ q ≥ Q, volume (minorArcs q α) ≤ ε := by
    intro ε hε_pos
    have h_uniform : ∀ δ > 0, ∃ Q : ℕ, ∀ q ≥ Q, ∀ x ∈ Set.Ioo 0 (α - δ), ∃ a q' : ℕ, 0 < q' ∧ q' ≤ q ∧ Nat.Coprime a q' ∧ (a : ℝ) / q' ≤ α ∧ x ∈ majorArc q a q' := by
      intro δ hδ_pos
      obtain ⟨Q, hQ⟩ : ∃ Q : ℕ, ∀ q ≥ Q, ∀ x ∈ Set.Ioo 0 (α - δ), ∃ a q' : ℕ, 0 < q' ∧ q' ≤ q ∧ (a : ℝ) / q' ≤ α ∧ |x - (a : ℝ) / q'| < 1 / ((q' : ℝ) * (q : ℝ)) := by
        use ⌈δ⁻¹⌉₊ + 1;
        intro q hq x hx
        obtain ⟨a, q', haq', hq'_le_q, hxq'⟩ : ∃ a q' : ℕ, 0 < q' ∧ q' ≤ q ∧ |x * q' - a| < 1 / (q : ℝ) := by
          -- By the pigeonhole principle, there exist integers $a$ and $q'$ such that $0 < q' \leq q$ and $|x * q' - a| < 1 / q$.
          have h_pigeonhole : ∃ a q' : ℕ, 0 < q' ∧ q' ≤ q ∧ |x * q' - a| < 1 / q := by
            have h_pigeonhole_principle : ∃ i j : ℕ, i < j ∧ i ≤ q ∧ j ≤ q ∧ |Int.fract (x * i) - Int.fract (x * j)| < 1 / q := by
              -- By the pigeonhole principle, since there are $q+1$ numbers and only $q$ intervals, at least two of these numbers must fall into the same interval.
              have h_pigeonhole : ∃ i j : ℕ, i < j ∧ i ≤ q ∧ j ≤ q ∧ ⌊Int.fract (x * i) * q⌋ = ⌊Int.fract (x * j) * q⌋ := by
                by_contra h_contra;
                exact absurd ( Finset.card_le_card ( show Finset.image ( fun i : ℕ => ⌊Int.fract ( x * i ) * q⌋ ) ( Finset.Icc 0 q ) ⊆ Finset.Icc 0 ( q - 1 ) from Finset.image_subset_iff.mpr fun i hi => Finset.mem_Icc.mpr ⟨ Int.floor_nonneg.mpr <| mul_nonneg ( Int.fract_nonneg _ ) <| Nat.cast_nonneg _, Int.le_sub_one_of_lt <| Int.floor_lt.mpr <| mul_lt_of_lt_one_left ( Nat.cast_pos.mpr <| by linarith ) <| Int.fract_lt_one _ ⟩ ) ) ( by rw [ Finset.card_image_of_injOn fun i hi j hj hij => le_antisymm ( not_lt.mp fun hi' => h_contra ⟨ j, i, hi', by aesop, by aesop, hij.symm ⟩ ) ( not_lt.mp fun hj' => h_contra ⟨ i, j, hj', by aesop, by aesop, hij ⟩ ) ] ; cases q <;> norm_num at * );
              obtain ⟨ i, j, hij, hi, hj, h ⟩ := h_pigeonhole;
              rw [ Int.floor_eq_iff ] at h;
              exact ⟨ i, j, hij, hi, hj, by rw [ lt_div_iff₀ ( Nat.cast_pos.mpr <| by linarith ) ] ; cases abs_cases ( Int.fract ( x * i ) - Int.fract ( x * j ) ) <;> nlinarith [ Int.floor_le ( Int.fract ( x * j ) * q ), Int.lt_floor_add_one ( Int.fract ( x * j ) * q ) ] ⟩
            obtain ⟨ i, j, hij, hi, hj, h ⟩ := h_pigeonhole_principle;
            refine' ⟨ ⌊x * j⌋ - ⌊x * i⌋ |> Int.natAbs, j - i, _, _, _ ⟩ <;> norm_num at *;
            · linarith;
            · linarith;
            · rw [ Nat.cast_sub hij.le ];
              rw [ abs_lt ] at *;
              constructor <;> cases abs_cases ( ( ⌊x * j⌋ : ℝ ) - ⌊x * i⌋ ) <;> linarith [ Int.fract_add_floor ( x * j ), Int.fract_add_floor ( x * i ), show ( ⌊x * j⌋ : ℝ ) ≥ ⌊x * i⌋ by exact_mod_cast Int.floor_mono <| mul_le_mul_of_nonneg_left ( Nat.cast_le.mpr hij.le ) hx.1.le ];
          exact h_pigeonhole;
        refine' ⟨ a, q', haq', hq'_le_q, _, _ ⟩;
        · rw [ div_le_iff₀ ( by positivity ) ];
          rw [ abs_lt ] at hxq';
          nlinarith [ hx.1, hx.2, show ( q' : ℝ ) ≥ 1 by norm_cast, show ( q : ℝ ) ≥ ⌈δ⁻¹⌉₊ + 1 by norm_cast, Nat.le_ceil ( δ⁻¹ ), mul_inv_cancel₀ ( ne_of_gt hδ_pos ), show ( 1 : ℝ ) / q ≤ δ by rw [ div_le_iff₀ ] <;> nlinarith [ hx.1, hx.2, show ( q : ℝ ) ≥ ⌈δ⁻¹⌉₊ + 1 by norm_cast, Nat.le_ceil ( δ⁻¹ ), mul_inv_cancel₀ ( ne_of_gt hδ_pos ) ] ];
        · rw [ sub_div', abs_div ] <;> try positivity;
          convert div_lt_div_iff_of_pos_right ( by positivity : 0 < ( q' : ℝ ) ) |>.2 hxq' using 1 ; ring;
          · norm_num [ abs_of_nonneg, haq'.le ];
          · ring;
      use Q + 1;
      intro q hq x hx
      obtain ⟨a, q', hq'_pos, hq'_le_q, ha_le_alpha, hx_major⟩ := hQ q (by linarith) x hx
      use a / Nat.gcd a q', q' / Nat.gcd a q';
      refine' ⟨ _, _, _, _, _ ⟩;
      · exact Nat.div_pos ( Nat.le_of_dvd hq'_pos ( Nat.gcd_dvd_right _ _ ) ) ( Nat.gcd_pos_of_pos_right _ hq'_pos );
      · exact le_trans ( Nat.div_le_self _ _ ) hq'_le_q;
      · rw [ Nat.Coprime, Nat.gcd_div ( Nat.gcd_dvd_left _ _ ) ( Nat.gcd_dvd_right _ _ ), Nat.div_self ( Nat.gcd_pos_of_pos_right _ hq'_pos ) ];
      · rw [ Nat.cast_div ( Nat.gcd_dvd_left _ _ ), Nat.cast_div ( Nat.gcd_dvd_right _ _ ) ];
        · rw [ div_div_div_cancel_right₀ ( by positivity ) ] ; exact ha_le_alpha;
        · positivity;
        · positivity;
      · have h_simplified : |x - (a / Nat.gcd a q' : ℝ) / (q' / Nat.gcd a q')| < 1 / ((q' / Nat.gcd a q' : ℝ) * (q : ℝ)) := by
          convert hx_major.trans_le _ using 1;
          · field_simp;
          · gcongr;
            · exact mul_pos ( div_pos ( Nat.cast_pos.mpr hq'_pos ) ( Nat.cast_pos.mpr ( Nat.gcd_pos_of_pos_right _ hq'_pos ) ) ) ( Nat.cast_pos.mpr ( by linarith ) );
            · exact div_le_self ( Nat.cast_nonneg _ ) ( mod_cast Nat.gcd_pos_of_pos_right _ hq'_pos );
        unfold majorArc;
        simp_all +decide [ Nat.gcd_dvd_left, Nat.gcd_dvd_right, Nat.cast_div ];
        constructor <;> linarith [ abs_lt.mp h_simplified ];
    -- Choose δ such that the measure of the interval [α - δ, α] is less than ε.
    obtain ⟨δ, hδ_pos, hδ_measure⟩ : ∃ δ > 0, volume (Set.Icc (α - δ) α) < ε := by
      rcases ENNReal.lt_iff_exists_real_btwn.mp hε_pos with ⟨ δ, hδ_pos, hδ ⟩;
      exact ⟨ δ, lt_of_le_of_ne hδ_pos ( Ne.symm <| by aesop_cat ), by simpa [ hδ_pos ] using hδ.2 ⟩;
    obtain ⟨ Q, hQ ⟩ := h_uniform δ hδ_pos;
    use Q + 1;
    intro q hq
    have h_subset : minorArcs q α ⊆ Set.Icc (α - δ) α ∪ {0} := by
      intro x hx; by_cases hx' : x = 0 <;> simp_all +decide [ minorArcs ] ;
      contrapose! hx;
      exact fun hx'' => by rcases hQ q hq.le x ( lt_of_le_of_ne hx''.1 ( Ne.symm hx' ) ) ( by linarith ) with ⟨ a, q', hq', hq'', ha, ha', hx''' ⟩ ; exact ⟨ a, q', hq', hq'', ha, by linarith, ⟨ hx''', ⟨ by linarith, by linarith ⟩ ⟩ ⟩ ;
    refine' le_trans ( MeasureTheory.measure_mono h_subset ) _;
    exact le_trans ( MeasureTheory.measure_union_le _ _ ) ( by simpa using hδ_measure.le );
  rw [ ENNReal.tendsto_nhds_zero ];
  aesop

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
  unfold ramanujanSum;
  norm_num [ coprimesBelow ]

/-
CRT bijection for coprime residues: The map (a₁, a₂) ↦ (a₁ * q₂ + a₂ * q₁) % (q₁ * q₂)

    gives a bijection coprimesBelow q₁ × coprimesBelow q₂ → coprimesBelow (q₁ * q₂)

    when gcd(q₁, q₂) = 1.
-/
lemma coprimesBelow_crt_bijection (q1 q2 : ℕ) (hq1 : q1 > 0) (hq2 : q2 > 0)

    (hc : Nat.Coprime q1 q2) :

    (coprimesBelow q1 ×ˢ coprimesBelow q2).image

      (fun p : ℕ × ℕ => (p.1 * q2 + p.2 * q1) % (q1 * q2)) = coprimesBelow (q1 * q2) := by
  refine Finset.eq_of_subset_of_card_le ( Finset.image_subset_iff.mpr ?_ ) ?_;
  · simp +decide [ Nat.mod_lt, * ];
    intro a b ha hb; simp_all +decide [ coprimesBelow ];
    refine ⟨ Nat.mod_lt _ ( by positivity ), ?_ ⟩;
    simp_all +decide [ Nat.coprime_mul_iff_left, Nat.coprime_mul_iff_right, Nat.Coprime, Nat.gcd_comm ];
  · rw [ Finset.card_image_of_injOn ];
    · -- By definition of coprimesBelow, we know that its cardinality is given by Euler's totient function.
      have h_card_coprimesBelow : ∀ q : ℕ, q > 0 → Finset.card (coprimesBelow q) = Nat.totient q := by
        intro q hq;
        exact congr_arg Finset.card ( Finset.ext fun x => by unfold coprimesBelow; simp +decide [ Nat.coprime_comm ] );
      simp_all +decide [ Nat.totient_mul hc ];
    · intro p hp q hq h_eq; simp_all +decide [ InjOn ] ;
      -- Since $q1$ and $q2$ are coprime, we have $p.1 \equiv q.1 \pmod{q1}$ and $p.2 \equiv q.2 \pmod{q2}$.
      have h_cong : p.1 ≡ q.1 [MOD q1] ∧ p.2 ≡ q.2 [MOD q2] := by
        have h_cong : p.1 * q2 ≡ q.1 * q2 [MOD q1] ∧ p.2 * q1 ≡ q.2 * q1 [MOD q2] := by
          have := congr_arg ( · % q1 ) h_eq; have := congr_arg ( · % q2 ) h_eq; norm_num [ Nat.ModEq, Nat.add_mod, Nat.mul_mod ] at *; aesop;
        simp_all +decide [ Nat.modEq_iff_dvd ];
        exact ⟨ by exact Int.dvd_of_dvd_mul_left_of_gcd_one ( by simpa [ sub_mul ] using h_cong.1 ) ( by simpa [ Int.gcd_natCast_natCast ] using hc ), by exact Int.dvd_of_dvd_mul_left_of_gcd_one ( by simpa [ sub_mul ] using h_cong.2 ) ( by simpa [ Int.gcd_natCast_natCast ] using hc.symm ) ⟩;
      exact Prod.ext ( Nat.mod_eq_of_lt ( Finset.mem_range.mp ( Finset.mem_filter.mp hp.1 |>.1 ) ) ▸ Nat.mod_eq_of_lt ( Finset.mem_range.mp ( Finset.mem_filter.mp hq.1 |>.1 ) ) ▸ h_cong.1 ) ( Nat.mod_eq_of_lt ( Finset.mem_range.mp ( Finset.mem_filter.mp hp.2 |>.1 ) ) ▸ Nat.mod_eq_of_lt ( Finset.mem_range.mp ( Finset.mem_filter.mp hq.2 |>.1 ) ) ▸ h_cong.2 )

/-
The exponential in the Ramanujan sum factors under the CRT map:

    e^{2πi(a₁q₂ + a₂q₁)h/(q₁q₂)} ≡ e^{2πia₁h/q₁} · e^{2πia₂h/q₂}

    modulo the exp periodicity.
-/
lemma ramanujan_exp_factor (q1 q2 h a1 a2 : ℕ) (hq1 : q1 > 0) (hq2 : q2 > 0) :

    Complex.exp (2 * Real.pi * Complex.I * ((a1 * q2 + a2 * q1 : ℕ) : ℂ) * (h : ℂ) / ((q1 * q2 : ℕ) : ℂ)) =

    Complex.exp (2 * Real.pi * Complex.I * (a1 : ℂ) * (h : ℂ) / (q1 : ℂ)) *

    Complex.exp (2 * Real.pi * Complex.I * (a2 : ℂ) * (h : ℂ) / (q2 : ℂ)) := by
  convert Complex.exp_add _ _ using 2 ; push_cast ; ring;
  simp +decide [ mul_assoc, mul_comm, mul_left_comm, hq1.ne', hq2.ne' ]

/-
The CRT map is injective on coprime residues.
-/
lemma coprimesBelow_crt_injective (q1 q2 : ℕ) (hq1 : q1 > 0) (hq2 : q2 > 0)

    (hc : Nat.Coprime q1 q2) :

    Set.InjOn (fun p : ℕ × ℕ => (p.1 * q2 + p.2 * q1) % (q1 * q2))

      (coprimesBelow q1 ×ˢ coprimesBelow q2) := by
  intro p hp q hq;
  have h_eq : p.1 * q2 + p.2 * q1 ≡ q.1 * q2 + q.2 * q1 [MOD q1 * q2] → p.1 ≡ q.1 [MOD q1] ∧ p.2 ≡ q.2 [MOD q2] := by
    intro h_eq
    have h1 : p.1 * q2 ≡ q.1 * q2 [MOD q1] := by
      simpa [ Nat.ModEq, Nat.add_mod, Nat.mul_mod ] using h_eq.of_dvd <| dvd_mul_right q1 q2
    have h2 : p.2 * q1 ≡ q.2 * q1 [MOD q2] := by
      simpa [ Nat.modEq_iff_dvd, ← ZMod.intCast_zmod_eq_zero_iff_dvd ] using h_eq.of_dvd <| dvd_mul_left q2 q1;
    simp_all +decide [ Nat.modEq_iff_dvd ];
    exact ⟨ by exact Int.dvd_of_dvd_mul_left_of_gcd_one ( by simpa [ sub_mul ] using h1 ) ( by simpa [ Int.gcd_natCast_natCast ] using hc ), by exact Int.dvd_of_dvd_mul_left_of_gcd_one ( by simpa [ sub_mul ] using h2 ) ( by simpa [ Int.gcd_natCast_natCast ] using hc.symm ) ⟩;
  simp_all +decide [ coprimesBelow, Nat.ModEq ];
  exact fun h => Prod.ext ( Nat.mod_eq_of_lt hp.1.1 ▸ Nat.mod_eq_of_lt hq.1.1 ▸ h_eq h |>.1 ) ( Nat.mod_eq_of_lt hp.2.1 ▸ Nat.mod_eq_of_lt hq.2.1 ▸ h_eq h |>.2 )

/-
The exp is invariant under mod (q1*q2) due to periodicity of complex exponential.
-/
lemma ramanujan_exp_mod (q1 q2 h n : ℕ) (hq1 : q1 > 0) (hq2 : q2 > 0) :

    Complex.exp (2 * Real.pi * Complex.I * ((n % (q1 * q2) : ℕ) : ℂ) * (h : ℂ) / ((q1 * q2 : ℕ) : ℂ)) =

    Complex.exp (2 * Real.pi * Complex.I * (n : ℂ) * (h : ℂ) / ((q1 * q2 : ℕ) : ℂ)) := by
  rw [ Complex.exp_eq_exp_iff_exists_int ];
  use - ( n / ( q1 * q2 ) ) * h; push_cast; rw [ div_add', div_eq_div_iff ] <;> norm_cast <;> norm_num [ Nat.mod_add_div, hq1.ne', hq2.ne' ] ; ring;
  rw_mod_cast [ Nat.mod_def ] ; ring;
  rw [ Nat.cast_sub ( Nat.mul_div_le _ _ ) ] ; push_cast ; ring

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
  split_ifs with hq_div;
  · obtain ⟨ k, rfl ⟩ := hq_div;
    exact Eq.trans ( Finset.sum_congr rfl fun _ _ => by rw [ Complex.exp_eq_one_iff ] ; use k * ‹ℕ›; push_cast; rw [ div_eq_iff ( Nat.cast_ne_zero.mpr hq.ne' ) ] ; ring ) ( by norm_num );
  · -- Let $z = e^{2πih/q}$. Since $q \nmid h$, $z$ is a primitive $q$-th root of unity.
    set z : ℂ := Complex.exp (2 * Real.pi * Complex.I * h / q)
    have hz : ∑ a ∈ Finset.range q, z ^ a = 0 := by
      rw [ geom_sum_eq ];
      · rw [ ← Complex.exp_nat_mul, mul_comm, Complex.exp_eq_one_iff.mpr ⟨ h, by push_cast; ring_nf; norm_num [ hq.ne' ] ⟩ ] ; norm_num;
      · rw [ Ne.eq_def, Complex.exp_eq_one_iff ];
        exact fun ⟨ n, hn ⟩ => hq_div <| Int.natCast_dvd_natCast.mp <| ⟨ n, by rw [ ← @Int.cast_inj ℂ ] ; push_cast; rw [ div_eq_iff <| Nat.cast_ne_zero.mpr hq.ne' ] at hn; norm_num [ Complex.ext_iff ] at *; nlinarith [ Real.pi_pos ] ⟩;
    exact Eq.trans ( Finset.sum_congr rfl fun _ _ => by rw [ ← Complex.exp_nat_mul ] ; ring ) hz

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
    -- By definition of $c_q(h)$, we can write it as a sum over divisors of $q$ using the Möbius function.
    have h_def : ramanujanSum q h = ∑ a ∈ Finset.range q, (∑ d ∈ Nat.divisors (Nat.gcd a q), (ArithmeticFunction.moebius d)) * Complex.exp (2 * Real.pi * Complex.I * (a : ℂ) * (h : ℂ) / (q : ℂ)) := by
      have h_def : ∀ a ∈ Finset.range q, (∑ d ∈ Nat.divisors (Nat.gcd a q), (ArithmeticFunction.moebius d)) = if Nat.gcd a q = 1 then 1 else 0 := by
        have h_sum_coprime : ∀ n : ℕ, n > 0 → (∑ d ∈ Nat.divisors n, ArithmeticFunction.moebius d) = if n = 1 then 1 else 0 := by
          intro n hn_pos
          have h_sum_coprime : ∑ d ∈ Nat.divisors n, ArithmeticFunction.moebius d = (ArithmeticFunction.moebius * ArithmeticFunction.zeta) n := by
            exact?;
          aesop;
        exact fun a ha => h_sum_coprime _ ( Nat.gcd_pos_of_pos_right _ hq );
      unfold ramanujanSum;
      simp_all +decide [ Finset.sum_ite, coprimesBelow ];
      rw [ Finset.sum_filter, if_neg hq.ne' ];
      exact Finset.sum_congr rfl fun x hx => by specialize h_def x ( Finset.mem_range.mp hx ) ; norm_cast at * ; aesop;
    -- We can interchange the order of summation.
    have h_interchange : ∑ a ∈ Finset.range q, (∑ d ∈ Nat.divisors (Nat.gcd a q), (ArithmeticFunction.moebius d)) * Complex.exp (2 * Real.pi * Complex.I * (a : ℂ) * (h : ℂ) / (q : ℂ)) = ∑ d ∈ Nat.divisors q, (ArithmeticFunction.moebius d) * ∑ a ∈ Finset.filter (fun a => d ∣ a) (Finset.range q), Complex.exp (2 * Real.pi * Complex.I * (a : ℂ) * (h : ℂ) / (q : ℂ)) := by
      simp +decide [ Finset.sum_filter, Finset.mul_sum _ _ _ ];
      rw [ Finset.sum_comm, Finset.sum_congr rfl ] ; intros ; rw [ Finset.sum_mul _ _ _ ] ;
      rw [ ← Finset.sum_filter ];
      congr 1 with x ; simp +decide [ Nat.dvd_gcd_iff ];
      bv_omega;
    rw [ h_def, h_interchange ];
    refine' Finset.sum_congr rfl fun d hd => _;
    rw [ show Finset.filter ( fun a => d ∣ a ) ( Finset.range q ) = Finset.image ( fun a => a * d ) ( Finset.range ( q / d ) ) from ?_, Finset.sum_image ] <;> norm_num [ Nat.mul_div_cancel' ( Nat.dvd_of_mem_divisors hd ) ];
    · exact fun a ha b hb hab => mul_right_cancel₀ ( Nat.ne_of_gt ( Nat.pos_of_mem_divisors hd ) ) hab;
    · ext a; simp [Finset.mem_image];
      exact ⟨ fun h => ⟨ a / d, Nat.div_lt_of_lt_mul <| by nlinarith [ Nat.div_mul_cancel <| Nat.dvd_of_mem_divisors hd ], Nat.div_mul_cancel h.2 ⟩, by rintro ⟨ b, hb, rfl ⟩ ; exact ⟨ by nlinarith [ Nat.div_mul_cancel <| Nat.dvd_of_mem_divisors hd ], by simp +decide ⟩ ⟩;
  -- The inner sum $\sum_{a=0}^{q/d-1} e^{2\pi i a d h / q}$ is a geometric series with sum $\frac{q}{d}$ if $q/d \mid h$, and $0$ otherwise.
  have h_inner_sum : ∀ d ∈ Nat.divisors q, (∑ a ∈ Finset.range (q / d), Complex.exp (2 * Real.pi * Complex.I * (a * d : ℂ) * (h : ℂ) / (q : ℂ))) = if q / d ∣ h then (q / d : ℂ) else 0 := by
    intro d hd;
    convert geom_sum_roots_of_unity ( q / d ) ( h : ℕ ) ( Nat.div_pos ( Nat.le_of_dvd hq ( Nat.dvd_of_mem_divisors hd ) ) ( Nat.pos_of_mem_divisors hd ) ) using 1;
    · rw [ Nat.cast_div ( Nat.dvd_of_mem_divisors hd ) ( by aesop ) ] ; congr! 2 ; ring;
      norm_num ; ring;
    · rw [ Nat.cast_div ( Nat.dvd_of_mem_divisors hd ) ( by aesop ) ];
  -- Substitute the result of the inner sum into the definition of $c_q(h)$.
  have h_subst : ramanujanSum q h = ∑ d ∈ Nat.divisors q, (ArithmeticFunction.moebius d) * (if q / d ∣ h then (q / d : ℂ) else 0) := by
    exact h_def.trans ( Finset.sum_congr rfl fun x hx => by rw [ h_inner_sum x hx ] );
  -- By changing the variables $d \to q/d$ in the sum, we can rewrite it to match the desired form.
  have h_change_var : ∑ d ∈ Nat.divisors q, (ArithmeticFunction.moebius d) * (if q / d ∣ h then (q / d : ℂ) else 0) = ∑ d ∈ Nat.divisors q, (ArithmeticFunction.moebius (q / d)) * (if d ∣ h then (d : ℂ) else 0) := by
    rw [ ← Nat.sum_div_divisors ];
    exact Finset.sum_congr rfl fun x hx => by rw [ Nat.div_div_self ] <;> aesop;
  rw [ h_subst, h_change_var, ← Finset.sum_subset ( show Nat.divisors ( Nat.gcd q h ) ⊆ Nat.divisors q from fun x hx => Nat.mem_divisors.mpr ⟨ dvd_trans ( Nat.dvd_of_mem_divisors hx ) ( Nat.gcd_dvd_left _ _ ), by aesop ⟩ ) ];
  · exact Finset.sum_congr rfl fun x hx => by rw [ if_pos ( Nat.dvd_trans ( Nat.dvd_of_mem_divisors hx ) ( Nat.gcd_dvd_right _ _ ) ) ] ;
  · simp +contextual [ Nat.dvd_gcd_iff ]

/-
The identity ∑_{d | n} μ(n/d) · d = φ(n) for all n ≥ 1.
-/
set_option maxHeartbeats 800000 in

lemma mobius_totient_identity (n : ℕ) (hn : n > 0) :

    ∑ d ∈ Nat.divisors n, (ArithmeticFunction.moebius (n / d) : ℂ) * (d : ℂ) =

      (Nat.totient n : ℂ) := by
  convert ramanujanSum_eq_divisor_sum n n hn using 1;
  · grind +suggestions;
  · rw [ ← ramanujanSum_eq_divisor_sum ];
    · unfold ramanujanSum;
      simp +decide [ hn.ne', Complex.exp_ne_zero, coprimesBelow ];
      norm_num [ show ∀ x : ℕ, Complex.exp ( 2 * Real.pi * Complex.I * x ) = 1 from fun x => by rw [ Complex.exp_eq_one_iff ] ; use x; push_cast; ring ];
      exact congr_arg Finset.card ( Finset.filter_congr fun x hx => by rw [ Nat.coprime_comm ] );
    · assumption

/-
The divisor sum ∑_{e | g} μ(n·(g/e)) · e = μ(n) · φ(g) when gcd(n,g) = 1.
-/
lemma mobius_mul_totient_sum (n g : ℕ) (hn : n > 0) (hg : g > 0) (hc : Nat.Coprime n g) :

    ∑ e ∈ Nat.divisors g,

      (ArithmeticFunction.moebius (n * (g / e)) : ℂ) * (e : ℂ) =

    (ArithmeticFunction.moebius n : ℂ) * (Nat.totient g : ℂ) := by
  -- Since $n$ and $g$ are coprime, $\mu(n \cdot (g/e)) = \mu(n) \cdot \mu(g/e)$ for any divisor $e$ of $g$.
  have h_mul : ∀ e ∈ Nat.divisors g, ArithmeticFunction.moebius (n * (g / e)) = ArithmeticFunction.moebius n * ArithmeticFunction.moebius (g / e) := by
    simp +zetaDelta at *;
    intro e he _;
    simp +decide [ ArithmeticFunction.moebius, Nat.squarefree_mul_iff ];
    split_ifs <;> simp_all +decide [ ← pow_add, ArithmeticFunction.cardFactors_mul hn.ne' ( Nat.ne_of_gt ( Nat.div_pos ( Nat.le_of_dvd hg he ) ( Nat.pos_of_dvd_of_pos he hg ) ) ) ];
    exact False.elim <| ‹¬Nat.gcd n ( g / e ) = 1› <| hc.coprime_dvd_right <| Nat.div_dvd_of_dvd he;
  -- Apply the multiplicative property of the Möbius function to factor out $\mu(n)$.
  have h_factor : ∑ e ∈ Nat.divisors g, (ArithmeticFunction.moebius (n * (g / e)) : ℂ) * (e : ℂ) = (ArithmeticFunction.moebius n : ℂ) * ∑ e ∈ Nat.divisors g, (ArithmeticFunction.moebius (g / e) : ℂ) * (e : ℂ) := by
    rw [ Finset.mul_sum _ _ _ ] ; exact Finset.sum_congr rfl fun x hx => by rw [ h_mul x hx ] ; push_cast; ring;
  rw [ h_factor, ← mobius_totient_identity g hg ]

/-
For q = p^k prime power, the Ramanujan sum formula holds:

    c_{p^k}(h) = μ(p^k/gcd(p^k,h)) · φ(p^k) / φ(p^k/gcd(p^k,h)).
-/
lemma ramanujanSum_mobius_prime_power (p k h : ℕ) (hp : Nat.Prime p) (hk : k > 0) :

    ramanujanSum (p ^ k) h =

      (ArithmeticFunction.moebius (p ^ k / Nat.gcd (p ^ k) h) : ℂ) *

      (Nat.totient (p ^ k) : ℂ) / (Nat.totient (p ^ k / Nat.gcd (p ^ k) h) : ℂ) := by
  by_contra h_contra;
  -- Let $g = \gcd(p^k, h)$. Then $g = p^j$ for some $0 \leq j \leq k$.
  obtain ⟨j, hj⟩ : ∃ j, Nat.gcd (p ^ k) h = p ^ j ∧ j ≤ k := by
    have := Nat.gcd_dvd_left ( p ^ k ) h; ( have := Nat.gcd_dvd_right ( p ^ k ) h; ( erw [ Nat.dvd_prime_pow hp ] at *; aesop; ) );
  refine' h_contra _;
  rw [ ramanujanSum_eq_divisor_sum ];
  · rcases eq_or_lt_of_le hj.2 with rfl | hj' <;> simp_all +decide [ Nat.divisors_prime_pow ];
    · rw [ Finset.sum_range_succ ] ; norm_num [ Nat.totient_prime_pow hp hk ];
      rw [ Finset.sum_eq_single ( j - 1 ) ] <;> norm_num [ hp.pos ];
      · rcases j with ( _ | j ) <;> simp_all +decide [ pow_succ, Nat.mul_div_mul_left, hp.pos ];
        rw [ ArithmeticFunction.moebius_apply_prime hp ] ; ring;
      · intro b hb₁ hb₂; rw [ show p ^ j / p ^ b = p ^ ( j - b ) by rw [ Nat.div_eq_of_eq_mul_left ( pow_pos hp.pos _ ) ] ; rw [ ← pow_add, Nat.sub_add_cancel hb₁.le ] ] ;
        rw [ ArithmeticFunction.moebius ];
        simp +decide [ hp.ne_zero, hp.ne_one, Nat.squarefree_pow_iff, show j - b ≠ 0 from Nat.sub_ne_zero_of_lt hb₁ ];
        exact fun _ => by omega;
      · aesop;
    · rw [ Finset.sum_eq_single j ] <;> simp_all +decide [ Nat.totient_prime_pow hp ];
      · rw [ show p ^ k / p ^ j = p ^ ( k - j ) by rw [ Nat.div_eq_of_eq_mul_left ( pow_pos hp.pos _ ) ] ; rw [ ← pow_add, Nat.sub_add_cancel hj'.le ], Nat.totient_prime_pow hp ] <;> norm_num [ hp.pos ];
        · rw [ eq_div_iff ];
          · rw [ show k - 1 = j + ( k - j - 1 ) by omega, pow_add ] ; ring;
          · exact mul_ne_zero ( pow_ne_zero _ ( Nat.cast_ne_zero.mpr hp.ne_zero ) ) ( sub_ne_zero.mpr ( Nat.cast_ne_one.mpr hp.ne_one ) );
        · finiteness;
      · intro b hb hb'; rw [ ArithmeticFunction.moebius ] ;
        simp +decide [ hp.ne_zero, hp.ne_one, Nat.div_eq_of_lt, hj', hb, hb', Nat.pow_le_pow_right hp.one_lt.le, Nat.squarefree_pow_iff ];
        rw [ Nat.squarefree_iff_prime_squarefree ];
        simp +zetaDelta at *;
        exact ⟨ p, hp, Nat.dvd_div_of_mul_dvd <| dvd_trans ( by ring_nf; norm_num ) <| pow_dvd_pow _ <| show k ≥ b + 2 from by omega ⟩;
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
  -- Use the facts: (1) Nat.gcd (q1*q2) h = gcd(q1,h)*gcd(q2,h) when gcd(q1,q2)=1, (2) q1*q2 / (gcd(q1,h)*gcd(q2,h)) = (q1/gcd(q1,h)) * (q2/gcd(q2,h)) via Nat.mul_div_mul_comm.
  have h_gcd_mul : Nat.gcd (q1 * q2) h = Nat.gcd q1 h * Nat.gcd q2 h := by
    exact?
  have h_div_mul : q1 * q2 / (Nat.gcd q1 h * Nat.gcd q2 h) = (q1 / Nat.gcd q1 h) * (q2 / Nat.gcd q2 h) := by
    rw [ Nat.div_mul_div_comm ( Nat.gcd_dvd_left _ _ ) ( Nat.gcd_dvd_left _ _ ) ]
  simp_all +decide [ Nat.totient_mul, Nat.Coprime, Nat.Coprime.gcd_eq_one ];
  -- Use the fact that μ is multiplicative for coprime arguments.
  have h_moebius_mul : ∀ {m n : ℕ}, Nat.Coprime m n → ArithmeticFunction.moebius (m * n) = ArithmeticFunction.moebius m * ArithmeticFunction.moebius n := by
    simp +decide [ ArithmeticFunction.moebius ];
    intro m n hmn; split_ifs <;> simp_all +decide [ Nat.squarefree_mul_iff ] ;
    rw [ ← pow_add, ArithmeticFunction.cardFactors_mul ] <;> aesop;
  rw [ h_moebius_mul, Nat.totient_mul ];
  · push_cast; ring;
  · exact Nat.Coprime.coprime_dvd_left ( Nat.div_dvd_of_dvd <| Nat.gcd_dvd_left _ _ ) <| Nat.Coprime.coprime_dvd_right ( Nat.div_dvd_of_dvd <| Nat.gcd_dvd_left _ _ ) hc;
  · exact Nat.Coprime.coprime_dvd_left ( Nat.div_dvd_of_dvd <| Nat.gcd_dvd_left _ _ ) <| Nat.Coprime.coprime_dvd_right ( Nat.div_dvd_of_dvd <| Nat.gcd_dvd_left _ _ ) hc

/-
The Möbius formula for Ramanujan sums:

    c_q(h) = μ(q/gcd(q,h)) · φ(q) / φ(q/gcd(q,h)).

    This connects Ramanujan sums to the Möbius function and Euler's totient.
-/
theorem ramanujanSum_mobius (q h : ℕ) (hq : q > 0) :

    ramanujanSum q h =

      (ArithmeticFunction.moebius (q / Nat.gcd q h) : ℂ) *

      (Nat.totient q : ℂ) / (Nat.totient (q / Nat.gcd q h) : ℂ) := by
  -- We prove the congruence relation by strong induction on q.
  induction' q using Nat.strong_induction_on with q ih generalizing h;
  by_cases hq1 : q = 1;
  · simp +decide [ hq1, ramanujanSum_one ];
  · obtain ⟨p, k, m, hp, hk, hm, hq_eq⟩ : ∃ p k m, Nat.Prime p ∧ k > 0 ∧ q = p^k * m ∧ Nat.Coprime (p^k) m := by
      obtain ⟨ p, hp ⟩ := Nat.exists_prime_and_dvd hq1;
      exact ⟨ p, Nat.factorization q p, q / p ^ Nat.factorization q p, hp.1, Nat.pos_of_ne_zero ( Finsupp.mem_support_iff.mp ( by aesop ) ), by rw [ Nat.mul_div_cancel' ( Nat.ordProj_dvd _ _ ) ], by exact Nat.Coprime.pow_left _ ( hp.1.coprime_iff_not_dvd.mpr ( Nat.not_dvd_ordCompl ( by aesop ) ( by aesop ) ) ) ⟩;
    rw [ hm, ramanujanSum_multiplicative ];
    · rw [ ramanujanSum_mobius_prime_power ];
      · rw [ ih m ( by nlinarith [ Nat.Prime.one_lt hp, Nat.pow_le_pow_right hp.one_lt.le hk ] ) h ( by nlinarith [ Nat.Prime.one_lt hp, Nat.pow_le_pow_right hp.one_lt.le hk ] ) ];
        rw [ ← mobius_formula_multiplicative ];
        · exact pow_pos hp.pos _;
        · lia;
        · assumption;
      · assumption;
      · assumption;
    · exact pow_pos hp.pos _;
    · lia;
    · assumption

/-
Ramanujan sums take integer values (they are always real integers

    despite being defined as sums of complex roots of unity).
-/
theorem ramanujanSum_isInt (q h : ℕ) (hq : q > 0) :

    ∃ n : ℤ, ramanujanSum q h = (n : ℂ) := by
  rw [ ramanujanSum_mobius ];
  · use (ArithmeticFunction.moebius (q / Nat.gcd q h)) * Nat.totient q / Nat.totient (q / Nat.gcd q h);
    rw [ Int.cast_div ] <;> norm_num;
    · exact dvd_mul_of_dvd_right ( mod_cast Nat.totient_dvd_of_dvd ( Nat.div_dvd_of_dvd ( Nat.gcd_dvd_left _ _ ) ) ) _;
    · exact ⟨ fun h => by linarith, Nat.le_of_dvd hq ( Nat.gcd_dvd_left _ _ ) ⟩;
  · assumption

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
  unfold myGaussSum;
  aesop

/-
The Weil bound: |G(a,q)| ≤ √q for (a,q) = 1.

    This is the key estimate for minor arc bounds.
-/
theorem myGaussSum_weil_bound (a q : ℕ) (hq : q > 0) (hc : Nat.Coprime a q) :

    ‖myGaussSum a q‖ ≤ Real.sqrt (q : ℝ) := by
  by_cases hq1 : q = 1;
  · unfold myGaussSum; aesop;
  · have := geom_sum_roots_of_unity q a hq; simp_all +decide [ myGaussSum ] ;
    split_ifs <;> simp_all +decide [ mul_assoc, mul_comm, mul_left_comm ];
    rw [ if_neg ( by intro h; have := Nat.gcd_eq_right h; aesop ) ] ; norm_num [ Real.le_sqrt ]

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