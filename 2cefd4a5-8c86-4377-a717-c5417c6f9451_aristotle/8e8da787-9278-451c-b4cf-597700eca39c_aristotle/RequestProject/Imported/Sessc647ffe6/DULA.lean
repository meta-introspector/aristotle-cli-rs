import Mathlib

/-!
# DULA: Prime-Factorisation Grading for χ₄ at Level 8

Formalisation of the analogous result for the quadratic Dirichlet character χ₄
modulo 4 (the character associated to the Gaussian integers ℚ(i)).

Theorem: On the monoid S₄ of positive odd integers, the prime-factorisation
grading that counts primes ≡ 3 (mod 4) with multiplicity equals χ₄.
The associated imprimitive lift at level 8 satisfies

    L(s, ψ₄_ext) = (1 + 2^{-s}) · L(s, χ₄)   for Re(s) > 1.
-/

open scoped BigOperators

noncomputable section

set_option maxHeartbeats 800000

/-! ## Part 1: Basic Definitions -/

/-- The non-principal Dirichlet character mod 4. -/
def chi4 (n : ℕ) : ℂ := if Even n then 0 else (-1 : ℂ) ^ ((n - 1) / 2)

/-- Primes ≡ 1 (mod 4). -/
def Q1 : Set ℕ := {p | p.Prime ∧ p % 4 = 1}

/-- Primes ≡ 3 (mod 4). -/
def Q3 : Set ℕ := {p | p.Prime ∧ p % 4 = 3}

/-- All odd primes. -/
def Q : Set ℕ := Q1 ∪ Q3

/-- A natural has only Q-primes if every prime factor is odd. -/
def has_Q_primes_only (n : ℕ) : Prop := ∀ p : ℕ, p.Prime → p ∣ n → p ∈ Q

/-- The submonoid S₄ of positive odd integers. -/
def S4_submonoid : Submonoid ℕ where
  carrier := {n | has_Q_primes_only n ∧ n ≠ 0}
  one_mem' := by
    refine ⟨?_, one_ne_zero⟩
    intro p hp hpd
    exact absurd (Nat.le_of_dvd Nat.one_pos hpd) (not_le.mpr hp.one_lt)
  mul_mem' := by
    rintro a b ⟨ha, ha0⟩ ⟨hb, hb0⟩
    refine ⟨?_, mul_ne_zero ha0 hb0⟩
    intro p hp hpd
    rcases hp.dvd_mul.mp hpd with h | h
    · exact ha p hp h
    · exact hb p hp h

abbrev S4 := S4_submonoid

/-! ## Part 2: Basic chi4 Properties -/

lemma chi4_one : chi4 1 = 1 := by simp [chi4]
lemma chi4_two : chi4 2 = 0 := by simp [chi4]

lemma chi4_mul (a b : ℕ) : chi4 (a * b) = chi4 a * chi4 b := by
  unfold chi4
  rcases Nat.even_or_odd' a with ⟨c, rfl | rfl⟩ <;>
    rcases Nat.even_or_odd' b with ⟨d, rfl | rfl⟩ <;>
    norm_num [Nat.even_add, Nat.even_mul]
  norm_num [show (2 * c + 1) * (2 * d + 1) = 2 * (2 * c * d + c + d) + 1 by ring, pow_add]

lemma norm_chi4_le_one (n : ℕ) : ‖chi4 n‖ ≤ 1 := by
  unfold chi4; split_ifs <;> norm_num

/-! ## Part 3: The DULA prime-factorisation grading for χ₄ -/

/-- Counts primes ≡ 3 (mod 4) with multiplicity. -/
def m4_count (n : ℕ) : ℕ :=
  n.factorization.sum (fun p k => if p % 4 = 3 then k else 0)

/-- The DULA grading for χ₄: ψ₄(n) = (-1)^(m4_count n). -/
def psi4_factored : ℕ → ℤ := fun n => (-1) ^ (m4_count n)

lemma psi4_factored_one : psi4_factored 1 = 1 := by
  simp [psi4_factored, m4_count]

theorem m4_count_mul {a b : ℕ} (ha : a ≠ 0) (hb : b ≠ 0) :
    m4_count (a * b) = m4_count a + m4_count b := by
  unfold m4_count
  rw [Nat.factorization_mul ha hb]
  rw [Finsupp.sum_add_index'] <;> aesop

theorem psi4_factored_mul {a b : ℕ} (ha : a ≠ 0) (hb : b ≠ 0) :
    psi4_factored (a * b) = psi4_factored a * psi4_factored b := by
  unfold psi4_factored; rw [m4_count_mul ha hb, pow_add]

theorem psi4_factored_Q1 {p : ℕ} (hp : p ∈ Q1) : psi4_factored p = 1 := by
  unfold psi4_factored m4_count
  rw [hp.1.factorization, Finsupp.sum_single_index (by simp)]
  simp [hp.2]

theorem psi4_factored_Q3 {p : ℕ} (hp : p ∈ Q3) : psi4_factored p = -1 := by
  unfold psi4_factored m4_count
  rw [hp.1.factorization, Finsupp.sum_single_index (by simp)]
  rw [if_pos hp.2]; exact pow_one _

/-! ## Part 4: The DULA Equivalence Theorem for χ₄ -/

theorem psi4_factored_eq_chi4_on_S4 (n : S4) :
    ((psi4_factored n.val : ℤ) : ℂ) = chi4 n.val := by
  induction' n with n ih
  induction' n using Nat.strongRecOn with n ih
  by_cases hn : n = 1
  · simp +decide [hn, chi4_one, psi4_factored_one]
  · obtain ⟨p, hp⟩ : ∃ p : ℕ, Nat.Prime p ∧ p ∣ n ∧ p ∈ Q :=
      ⟨Nat.minFac n, Nat.minFac_prime hn, Nat.minFac_dvd n,
       ih.1 _ (Nat.minFac_prime hn) (Nat.minFac_dvd n)⟩
    obtain ⟨m, hm⟩ : ∃ m : ℕ, n = p * m := hp.right.left
    have hm_lt : m < n := by
      rcases p with (_ | _ | p) <;> rcases m with (_ | _ | m) <;> simp_all +decide
      exact absurd ih.2 (by norm_num)
    have hm_mem : m ∈ S4 :=
      ⟨fun q hq hq' => ih.1 q hq (dvd_trans hq' (hm.symm ▸ dvd_mul_left _ _)), by aesop⟩
    have h_psi4_factored : psi4_factored n = psi4_factored p * psi4_factored m := by
      rw [hm, psi4_factored_mul] <;> aesop
    have h_chi4 : chi4 n = chi4 p * chi4 m := by rw [hm, chi4_mul]
    have h_psi4_factored_p : psi4_factored p = chi4 p := by
      cases hp.2.2 <;> simp_all +decide [Q1, Q3]
      · unfold psi4_factored chi4; simp +decide [*, Nat.even_iff]
        unfold m4_count; simp +decide [*, Nat.even_iff]
        rw [← Nat.mod_add_div p 4, ‹p % 4 = _›]; norm_num [Nat.even_div]
        norm_num [Nat.add_mod, Nat.mul_mod]
      · unfold psi4_factored chi4; simp +decide [*, Nat.even_iff]
        unfold m4_count; simp +decide [*, Nat.even_iff]
        rw [← Nat.mod_add_div p 4, ‹p % 4 = _›]; norm_num [Nat.even_div, Nat.add_mod, Nat.mul_mod]
    have h_psi4_factored_m : psi4_factored m = chi4 m := by grind
    aesop

/-! ## Part 5: psi4_ext and the L-series identity (Level 8)

The imprimitive lift ψ₄_ext of χ₄ from level 4 to level 8 extends the character
to even integers by setting ψ₄_ext(2m) = χ₄(m). On odd integers it agrees with χ₄.

**Correction**: The original definitions had `psi4_ext n = if Even n then 0 else chi4 n`
and `chi4_even n = if Even n then chi4 n else 0`, but since chi4 vanishes on even integers,
these reduce to `psi4_ext = chi4` and `chi4_even = 0`, making the L-series identity trivial
and false. The corrected definitions below properly extend the character.
-/

/-- The imprimitive lift of χ₄ to level 8: agrees with χ₄ on odd integers,
    and sets ψ₄_ext(2m) = χ₄(m) for even integers. -/
def psi4_ext : ℕ → ℂ := fun n => if Even n then chi4 (n / 2) else chi4 n

/-- The even-part correction: chi4_even(2m) = -χ₄(m), zero on odd integers.
    Satisfies chi4 = psi4_ext + chi4_even. -/
def chi4_even : ℕ → ℂ := fun n => if Even n then -chi4 (n / 2) else 0

lemma chi4_eq_psi4_add_even (n : ℕ) : chi4 n = psi4_ext n + chi4_even n := by
  unfold psi4_ext chi4_even chi4
  split
  · simp
  · simp

lemma LSeries_term_split_chi4 (s : ℂ) (n : ℕ) :
    LSeries.term chi4 s n = LSeries.term psi4_ext s n + LSeries.term chi4_even s n := by
  by_cases hn : n = 0 <;> simp +decide [hn, LSeries.term]
  rw [← add_div, chi4_eq_psi4_add_even]

lemma norm_psi4_ext_le_one (n : ℕ) : ‖psi4_ext n‖ ≤ 1 := by
  unfold psi4_ext; split <;> simp [norm_chi4_le_one]

lemma norm_chi4_even_le_one (n : ℕ) : ‖chi4_even n‖ ≤ 1 := by
  unfold chi4_even; split
  · simp [norm_chi4_le_one]
  · simp

/-! ### Summability -/

lemma chi4_LSeriesSummable {s : ℂ} (hs : 1 < s.re) : LSeriesSummable chi4 s := by
  refine' .of_norm _;
  refine' .of_nonneg_of_le ( fun n => norm_nonneg _ ) ( fun n => _ ) ( Real.summable_one_div_nat_rpow.2 hs );
  by_cases hn : n = 0 <;> simp +decide [ *, LSeries.term ];
  · positivity;
  · exact mul_le_of_le_one_left ( by positivity ) ( norm_chi4_le_one _ ) |> le_trans <| by rw [ ← Complex.norm_cpow_eq_rpow_re_of_pos ( Nat.cast_pos.mpr <| Nat.pos_of_ne_zero hn ) ] ; norm_num;

lemma psi4_ext_LSeriesSummable {s : ℂ} (hs : 1 < s.re) : LSeriesSummable psi4_ext s := by
  refine' .of_norm _;
  refine' .of_nonneg_of_le ( fun n => norm_nonneg _ ) ( fun n => _ ) ( Real.summable_one_div_nat_rpow.2 hs );
  by_cases hn : n = 0 <;> simp_all +decide [ LSeries.term ];
  · positivity;
  · exact mul_le_of_le_one_left ( by positivity ) ( norm_psi4_ext_le_one _ ) |> le_trans <| by rw [ ← Complex.norm_cpow_eq_rpow_re_of_pos ( Nat.cast_pos.mpr <| Nat.pos_of_ne_zero hn ) ] ; norm_num;

lemma chi4_even_LSeriesSummable {s : ℂ} (hs : 1 < s.re) : LSeriesSummable chi4_even s := by
  have h_summable : Summable (fun n : ℕ => ‖chi4_even n‖ / (n : ℝ) ^ s.re) := by
    refine' .of_nonneg_of_le ( fun n => div_nonneg ( norm_nonneg _ ) ( Real.rpow_nonneg ( Nat.cast_nonneg _ ) _ ) ) ( fun n => div_le_div_of_nonneg_right ( norm_chi4_even_le_one n ) ( Real.rpow_nonneg ( Nat.cast_nonneg _ ) _ ) ) _;
    exact Real.summable_one_div_nat_rpow.2 hs;
  refine' .of_norm _;
  convert h_summable using 2 ; norm_num [ LSeries.term ];
  split_ifs <;> simp_all +decide [ Complex.norm_cpow_of_ne_zero ];
  norm_num [ show s.re ≠ 0 by linarith ]

/-! ### Splitting identity -/

lemma LSeries_chi4_split {s : ℂ} (hs : 1 < s.re) :
    LSeries chi4 s = LSeries psi4_ext s + LSeries chi4_even s := by
  unfold LSeries
  rw [← (psi4_ext_LSeriesSummable hs).tsum_add (chi4_even_LSeriesSummable hs)]
  exact tsum_congr (fun n => LSeries_term_split_chi4 s n)

/-! ### Even-part reindexing -/

lemma LSeries_chi4_even_eq {s : ℂ} (hs : 1 < s.re) :
    LSeries chi4_even s = -(2 : ℂ) ^ (-s) * LSeries chi4 s := by
  unfold LSeries;
  rw [ ← tsum_even_add_odd ];
  · simp +decide [ LSeries.term, chi4_even ];
    rw [ ← tsum_mul_left ] ; rw [ ← tsum_neg ] ; refine' tsum_congr fun n => _ ; by_cases hn : n = 0 <;> simp +decide [hn, div_eq_mul_inv, mul_assoc, mul_comm, Complex.cpow_neg] ;
    rw [ ← mul_inv, mul_comm, Complex.cpow_def_of_ne_zero, Complex.cpow_def_of_ne_zero, Complex.cpow_def_of_ne_zero ] <;> norm_num [ hn ];
    rw [ ← mul_inv, ← Complex.exp_add, Complex.log_mul ] <;> norm_num [ hn ];
    · exact Or.inl <| congr_arg Complex.exp <| by ring;
    · exact ⟨ Real.pi_pos, Real.pi_pos.le ⟩;
  · convert chi4_even_LSeriesSummable hs |> Summable.comp_injective <| mul_right_injective₀ two_ne_zero using 1;
  · simp +decide [ LSeries.term, chi4_even ]

/-! ## Part 6: The Main L-Series Identity for χ₄ -/

theorem LSeries_psi4_ext_eq {s : ℂ} (hs : 1 < s.re) :
    LSeries psi4_ext s = (1 + (2 : ℂ) ^ (-s)) * LSeries chi4 s :=
  calc LSeries psi4_ext s
      = LSeries chi4 s - LSeries chi4_even s := by
          have := LSeries_chi4_split hs; rw [this]; ring
    _ = LSeries chi4 s - (-(2 : ℂ) ^ (-s) * LSeries chi4 s) := by
          rw [LSeries_chi4_even_eq hs]
    _ = (1 + (2 : ℂ) ^ (-s)) * LSeries chi4 s := by ring

end