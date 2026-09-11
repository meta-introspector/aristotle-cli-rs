import Mathlib

noncomputable section
open scoped BigOperators
open Classical

set_option maxHeartbeats 800000

/-- The non-principal Dirichlet character mod 3, via the Jacobi symbol. -/
def chi3 (n : ℕ) : ℂ := ((jacobiSym (n : ℤ) 3 : ℤ) : ℂ)

/-- Primes ≡ 1 (mod 6). -/
def P1 : Set ℕ := {p | p.Prime ∧ p % 6 = 1}

/-- Primes ≡ 5 (mod 6). -/
def P5 : Set ℕ := {p | p.Prime ∧ p % 6 = 5}

/-- All primes coprime to 6 (i.e., primes > 3). -/
def P : Set ℕ := P1 ∪ P5

/-- A natural has only P-primes if every prime factor lies in P. -/
def has_P_primes_only (n : ℕ) : Prop := ∀ p : ℕ, p.Prime → p ∣ n → p ∈ P

/-- The submonoid S of positive integers with all prime factors in P. -/
def S_submonoid : Submonoid ℕ where
  carrier := {n | has_P_primes_only n ∧ n ≠ 0}
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

abbrev S := S_submonoid

/-- The P5-valuation: counts prime factors of n that are ≡ 5 (mod 6),
    with multiplicity. -/
def m_count (n : ℕ) : ℕ :=
  n.factorization.sum (fun p k => if p % 6 = 5 then k else 0)

/-- The DULA grading: psi_factored n = (-1)^(m_count n) as an integer. -/
def psi_factored : ℕ → ℤ := fun n => (-1) ^ (m_count n)

/-- psi_ext: chi3 on odd naturals, 0 on even. -/
def psi_ext : ℕ → ℂ := fun n => if Even n then 0 else chi3 n

/-- The even-part of chi3: chi3 on even naturals, 0 on odd. -/
def chi3_even : ℕ → ℂ := fun n => if Even n then chi3 n else 0

-- ============================================================
-- Theorems
-- ============================================================

theorem chi3_zero : chi3 0 = 0 := by
  simp [chi3, jacobiSym.zero_left (by norm_num : (1 : ℕ) < 3)]

theorem chi3_one : chi3 1 = 1 := by
  simp [chi3, jacobiSym.one_left]

theorem chi3_two : chi3 2 = -1 := by
  simp [chi3]; norm_num

theorem chi3_three : chi3 3 = 0 := by
  simp [chi3]; norm_num

theorem chi3_mul (a b : ℕ) : chi3 (a * b) = chi3 a * chi3 b := by
  simp only [chi3]
  push_cast
  rw [jacobiSym.mul_left]
  push_cast; ring

theorem norm_chi3_le_one (n : ℕ) : ‖chi3 n‖ ≤ 1 := by
  unfold chi3; norm_num;
  rw [ jacobiSym.mod_left ] ; norm_num;
  have := Int.emod_nonneg n ( by decide : ( 3 : ℤ ) ≠ 0 ) ; have := Int.emod_lt_of_pos n ( by decide : ( 3 : ℤ ) > 0 ) ; interval_cases ( n % 3 : ℤ ) <;> norm_num;

theorem chi3_P1 {p : ℕ} (hp : p ∈ P1) : chi3 p = 1 := by
  -- By definition of $P1$, we know that $p \equiv 1 \pmod{6}$.
  obtain ⟨hp_prime, hp_mod⟩ : p.Prime ∧ p % 6 = 1 := by
    exact hp;
  unfold chi3; norm_num [ hp_mod, jacobiSym.mod_left ] ;
  norm_cast; rw [ ← Nat.mod_mod_of_dvd p ( by decide : 3 ∣ 6 ), hp_mod ] ; norm_num;

theorem chi3_P5 {p : ℕ} (hp : p ∈ P5) : chi3 p = -1 := by
  have h_jacobi : jacobiSym p 3 = -1 := by
    rw [ jacobiSym.mod_left ] ; norm_num;
    rw [ ← Nat.mod_add_div p 6, hp.2 ] ; norm_num [ Int.add_emod, Int.mul_emod ];
  unfold chi3; aesop;

theorem chi3_two_mul (n : ℕ) : chi3 (2 * n) = -chi3 n := by
  rw [chi3_mul, chi3_two, neg_one_mul]

theorem m_count_mul {a b : ℕ} (ha : a ≠ 0) (hb : b ≠ 0) :
    m_count (a * b) = m_count a + m_count b := by
  unfold m_count
  rw [Nat.factorization_mul ha hb]
  rw [Finsupp.sum_add_index' (by intro p; simp) (by intro p k1 k2; split <;> omega)]

theorem psi_factored_mul {a b : ℕ} (ha : a ≠ 0) (hb : b ≠ 0) :
    psi_factored (a * b) = psi_factored a * psi_factored b := by
  simp only [psi_factored, m_count_mul ha hb, pow_add]

theorem m_count_one : m_count 1 = 0 := by
  simp [m_count, Nat.factorization_one]

theorem psi_factored_one : psi_factored 1 = 1 := by
  simp [psi_factored, m_count_one]

theorem psi_factored_P1 {p : ℕ} (hp : p ∈ P1) : psi_factored p = 1 := by
  -- From hp : p ∈ P1, we have p.Prime (definition of P1).
  -- Then use:

  have hp_prime : p.Prime := hp.1

  -- From hp : p ∈ P1, we have p % 6 = 1.
  -- Then use:

  have hp_mod : p % 6 = 1 := hp.2

  -- From hp_mod : p % 6 = 1, we know that p is not ≡ 5 (mod 6).
  -- Then use:

  have h_p_factor : p.factorization.sum (fun q k => if q % 6 = 5 then k else 0) = 0 := by
    simp [hp_prime.factorization, hp_mod]

  -- Finally, we get psi_factored p = (-1)^(m_count p) = (-1)^0 = 1.
  simp [psi_factored, m_count, h_p_factor]

theorem psi_factored_P5 {p : ℕ} (hp : p ∈ P5) : psi_factored p = -1 := by
  -- By definition of $P5$, we know that $p$ is a prime number congruent to $5 \mod 6$.
  obtain ⟨hp_prime, hp_mod⟩ := hp;
  unfold psi_factored m_count; norm_num [ hp_prime.factorization, hp_mod ] ;

/-
The DULA equivalence theorem: prime-factorization grading equals
    chi3 on the monoid S. Proved by strong induction on n.val using
    the smallest prime factor decomposition.
-/
theorem psi_factored_eq_chi3_on_S (n : S) :
    ((psi_factored n.val : ℤ) : ℂ) = chi3 n.val := by
  obtain ⟨ n, hn ⟩ := n;
  induction' n using Nat.strongRecOn with n ih;
  rcases eq_or_ne n 1 <;> simp_all +decide [ Nat.succ_eq_add_one ];
  · norm_num [ psi_factored_one, chi3_one ];
  · -- Let $p = n.minFac$ (the smallest prime factor) and $m = n / p$.
    obtain ⟨p, hp_prime, hp_div⟩ : ∃ p, Nat.Prime p ∧ p ∣ n ∧ ∀ q, Nat.Prime q → q ∣ n → p ≤ q := by
      exact ⟨ Nat.minFac n, Nat.minFac_prime ‹_›, Nat.minFac_dvd n, fun q hq hqn => Nat.minFac_le_of_dvd hq.two_le hqn ⟩
    obtain ⟨m, hm⟩ : ∃ m, n = p * m := hp_div.left
    have hm_lt_n : m < n := by
      rcases p with ( _ | _ | p ) <;> rcases m with ( _ | _ | m ) <;> simp_all +decide;
      exact absurd ( hn.2 ) ( by norm_num )
    have hm_in_S : m ∈ S := by
      exact ⟨ fun q hq hqm => hn.1 q hq ( dvd_trans hqm ( hm.symm ▸ dvd_mul_left _ _ ) ), by aesop ⟩
    have hp_in_P : p ∈ P := by
      exact hn.1 p hp_prime hp_div.1
    have hp_in_P1_or_P5 : p ∈ P1 ∨ p ∈ P5 := by
      exact hp_in_P
    have hp_psi_factored : psi_factored p = chi3 p := by
      cases hp_in_P1_or_P5 <;> simp_all +decide [ P1, P5 ];
      · rw [ psi_factored_P1 ] <;> norm_num [ chi3_P1, ‹p % 6 = _› ];
        · exact Eq.symm ( chi3_P1 ⟨ hp_prime, by assumption ⟩ );
        · exact ⟨ hp_prime, by assumption ⟩;
      · rw [ show psi_factored p = -1 from psi_factored_P5 <| show p ∈ P5 from ⟨ hp_prime, by assumption ⟩ ] ; norm_num [ chi3_P5 <| show p ∈ P5 from ⟨ hp_prime, by assumption ⟩ ];
    have := ih m hm_lt_n hm_in_S; simp_all +decide [ psi_factored_mul, chi3_mul ] ;
    rw [ ← hp_psi_factored, ← ih m hm_lt_n hm_in_S, psi_factored_mul ] <;> aesop

theorem chi3_LSeriesSummable {s : ℂ} (hs : 1 < s.re) : LSeriesSummable chi3 s := by
  convert LSeriesSummable_of_bounded_of_one_lt_re _ _ using 1;
  exacts [ 1, fun n hn => norm_chi3_le_one n, hs ]

theorem psi_ext_LSeriesSummable {s : ℂ} (hs : 1 < s.re) : LSeriesSummable psi_ext s := by
  -- Since $|psi_ext n| \leq 1$ for all $n$, and $1 < s.re$, we can apply the comparison test.
  have h_comparison : ∀ n : ℕ, ‖psi_ext n‖ ≤ 1 := by
    unfold psi_ext;
    intro n; split_ifs <;> norm_num [ norm_chi3_le_one ] ;
  exact LSeriesSummable_of_bounded_of_one_lt_re (fun n _ => h_comparison n) hs

theorem chi3_even_LSeriesSummable {s : ℂ} (hs : 1 < s.re) : LSeriesSummable chi3_even s := by
  have h_bounded : ∀ n : ℕ, ‖chi3_even n‖ ≤ 1 := by
    exact fun n => by unfold chi3_even; split_ifs <;> simpa using norm_chi3_le_one n;
  apply LSeriesSummable_of_bounded_of_one_lt_re;
  exacts [ fun n hn => h_bounded n, hs ]

theorem LSeries_chi3_split {s : ℂ} (hs : 1 < s.re) :
    LSeries chi3 s = LSeries psi_ext s + LSeries chi3_even s := by
  have h_lseries_sum : LSeries (fun n => psi_ext n + chi3_even n) s = LSeries psi_ext s + LSeries chi3_even s := by
    -- Apply the LSeries_add theorem with the summability conditions.
    apply LSeries_add (psi_ext_LSeriesSummable hs) (chi3_even_LSeriesSummable hs);
  rw [ ← h_lseries_sum, LSeries_congr ];
  unfold psi_ext chi3_even; aesop;

theorem LSeries_chi3_even_eq {s : ℂ} (hs : 1 < s.re) :
    LSeries chi3_even s = -(2 : ℂ) ^ (-s) * LSeries chi3 s := by
  -- Express the even part in terms of the sum over even n.
  have h_even_sum : LSeries chi3_even s = ∑' n : ℕ, (chi3 (2 * n)) / (2 * n : ℂ) ^ s := by
    rw [LSeries];
    rw [ ← tsum_even_add_odd ];
    · simp [LSeries.term, chi3_even];
      grind +suggestions;
    · have := chi3_even_LSeriesSummable hs;
      convert this.comp_injective ( mul_right_injective₀ two_ne_zero ) using 1;
    · simp +decide [ LSeries.term, chi3_even ];
  rw [ h_even_sum, LSeries ];
  rw [ ← tsum_mul_left ] ; congr ; ext n ; by_cases hn : n = 0 <;> simp +decide [ hn, chi3_two_mul, mul_assoc, mul_left_comm, div_eq_mul_inv, Complex.cpow_neg ] ; ring;
  · exact Or.inl chi3_zero;
  · rw [ ← mul_inv, mul_comm, Complex.cpow_def_of_ne_zero, Complex.cpow_def_of_ne_zero, Complex.cpow_def_of_ne_zero ] <;> norm_num [ hn ];
    rw [ ← mul_inv, ← Complex.exp_add, Complex.log_mul ] <;> norm_num [ hn ];
    · exact Or.inl <| congr_arg Complex.exp <| by ring;
    · exact ⟨ Real.pi_pos, Real.pi_pos.le ⟩

/-- THE MAIN THEOREM. -/
theorem LSeries_psi_ext_eq {s : ℂ} (hs : 1 < s.re) :
    LSeries psi_ext s = (1 + (2 : ℂ) ^ (-s)) * LSeries chi3 s := by
  calc LSeries psi_ext s
      = LSeries chi3 s - LSeries chi3_even s := by
        rw [LSeries_chi3_split hs]; ring
    _ = LSeries chi3 s - (-(2 : ℂ) ^ (-s) * LSeries chi3 s) := by
        rw [LSeries_chi3_even_eq hs]
    _ = (1 + (2 : ℂ) ^ (-s)) * LSeries chi3 s := by
        ring

#print axioms LSeries_psi_ext_eq
#check @LSeries_psi_ext_eq