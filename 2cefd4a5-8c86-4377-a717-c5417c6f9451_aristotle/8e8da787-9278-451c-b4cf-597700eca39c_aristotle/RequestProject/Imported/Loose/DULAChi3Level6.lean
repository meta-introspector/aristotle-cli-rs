import Mathlib
/-!
# L-Series Identity for the Non-Principal Dirichlet Character mod 3
  Lifted to Level 6 — DULA Prime-Factorization Presentation
This self-contained file proves two main results:
1. **Connector theorem** (`psi_factored_eq_chi3_on_S`): On the submonoid `S`
   of positive integers whose prime factors all lie in
   `P = {primes ≡ ±1 (mod 6)}`, the prime-factorization-based grading
   `psi_factored(n) = (-1)^(m_count n)` — where `m_count n` counts the
   prime factors of `n` congruent to `5 (mod 6)` with multiplicity —
   agrees with the Legendre symbol mod 3.
2. **L-Series identity** (`LSeries_psi_ext_eq`): For `Re(s) > 1`,
   `LSeries psi_ext s = (1 + 2^(-s)) * LSeries chi3 s`,
   where `psi_ext` is `chi3` masked to odd naturals (the imprimitive
   lift of `chi3` from level 3 to level 6).
All theorems are proved without `sorry`, depending only on the
standard axioms `propext`, `Classical.choice`, and `Quot.sound`.
-/
noncomputable section
open scoped BigOperators
open Classical
set_option maxHeartbeats 800000
/-! ## Definitions -/
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
/-! ## Basic Properties of chi3 -/
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
  unfold chi3
  norm_num
  rw [jacobiSym.mod_left]
  norm_num
  have h1 := Int.emod_nonneg n (by decide : (3 : ℤ) ≠ 0)
  have h2 := Int.emod_lt_of_pos n (by decide : (3 : ℤ) > 0)
  interval_cases (n % 3 : ℤ) <;> norm_num
theorem chi3_P1 {p : ℕ} (hp : p ∈ P1) : chi3 p = 1 := by
  obtain ⟨_, hp_mod⟩ := hp
  unfold chi3
  norm_num [hp_mod, jacobiSym.mod_left]
  norm_cast
  rw [← Nat.mod_mod_of_dvd p (by decide : 3 ∣ 6), hp_mod]
  norm_num
theorem chi3_P5 {p : ℕ} (hp : p ∈ P5) : chi3 p = -1 := by
  have h_jacobi : jacobiSym p 3 = -1 := by
    rw [jacobiSym.mod_left]
    norm_num
    rw [← Nat.mod_add_div p 6, hp.2]
    norm_num [Int.add_emod, Int.mul_emod]
  unfold chi3
  rw [h_jacobi]
  norm_num
theorem chi3_two_mul (n : ℕ) : chi3 (2 * n) = -chi3 n := by
  rw [chi3_mul, chi3_two, neg_one_mul]
/-! ## The DULA Prime-Factorization Grading -/
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
  have hp_prime : p.Prime := hp.1
  have hp_mod : p % 6 = 1 := hp.2
  have h_p_factor :
      p.factorization.sum (fun q k => if q % 6 = 5 then k else 0) = 0 := by
    simp [hp_prime.factorization, hp_mod]
  simp [psi_factored, m_count, h_p_factor]
theorem psi_factored_P5 {p : ℕ} (hp : p ∈ P5) : psi_factored p = -1 := by
  obtain ⟨hp_prime, hp_mod⟩ := hp
  unfold psi_factored m_count
  norm_num [hp_prime.factorization, hp_mod]
/-! ## The DULA Equivalence Theorem (Connector)
  The central non-trivial result: on the monoid `S`, the prime-factorization
  grading `psi_factored` equals `chi3`. Proved by strong induction on `n.val`
  via the smallest prime factor decomposition.
-/
theorem psi_factored_eq_chi3_on_S (n : S) :
    ((psi_factored n.val : ℤ) : ℂ) = chi3 n.val := by
  obtain ⟨n, hn⟩ := n
  induction' n using Nat.strongRecOn with n ih
  rcases eq_or_ne n 1 with rfl | hn_ne
  · -- Base case n = 1
    norm_num [psi_factored_one, chi3_one]
  · -- Step case n ≠ 1
    -- Set up the smallest prime factor and the quotient
    have hn_pos : n ≠ 0 := hn.2
    have hn_gt_one : 1 < n := by
      cases n with
      | zero => exact absurd rfl hn_pos
      | succ k =>
        cases k with
        | zero => exact absurd rfl hn_ne
        | succ _ => omega
    set p := n.minFac with hp_def
    have hp_prime : p.Prime := Nat.minFac_prime hn_ne
    have hp_div : p ∣ n := Nat.minFac_dvd n
    have hp_in_P : p ∈ P := hn.1 p hp_prime hp_div
    obtain ⟨m, hm⟩ : ∃ m, n = p * m := hp_div
    have hp_pos : 0 < p := hp_prime.pos
    have hp_ne : p ≠ 0 := hp_prime.ne_zero
    have hm_pos : m ≠ 0 := by
      intro h
      rw [h, mul_zero] at hm
      exact hn_pos hm
    have hm_lt_n : m < n := by
      rw [hm]
      have : 1 < p := hp_prime.one_lt
      have h_m_pos : 0 < m := Nat.pos_of_ne_zero hm_pos
      calc m = 1 * m := (one_mul m).symm
        _ < p * m := by exact Nat.mul_lt_mul_of_pos_right this h_m_pos
    have hm_P : has_P_primes_only m := by
      intro q hq hqm
      apply hn.1 q hq
      rw [hm]
      exact Dvd.dvd.mul_left hqm p
    have hm_in_S : m ∈ S := ⟨hm_P, hm_pos⟩
    -- Apply induction hypothesis to m
    have ih_m : ((psi_factored m : ℤ) : ℂ) = chi3 m := ih m hm_lt_n hm_in_S
    -- Show psi_factored p = chi3 p, depending on whether p ∈ P1 or P5
    have hp_psi : ((psi_factored p : ℤ) : ℂ) = chi3 p := by
      rcases hp_in_P with hp1 | hp5
      · rw [psi_factored_P1 hp1, chi3_P1 hp1]; norm_num
      · rw [psi_factored_P5 hp5, chi3_P5 hp5]; norm_num
    -- Combine: psi_factored (p * m) = psi_factored p * psi_factored m,
    --         chi3 (p * m) = chi3 p * chi3 m, then use ih_m and hp_psi.
    show ((psi_factored n : ℤ) : ℂ) = chi3 n
    rw [hm, psi_factored_mul hp_ne hm_pos, chi3_mul]
    push_cast
    rw [hp_psi, ih_m]
/-! ## L-Series Summability -/
theorem chi3_LSeriesSummable {s : ℂ} (hs : 1 < s.re) :
    LSeriesSummable chi3 s :=
  LSeriesSummable_of_bounded_of_one_lt_re (fun n _ => norm_chi3_le_one n) hs
theorem psi_ext_LSeriesSummable {s : ℂ} (hs : 1 < s.re) :
    LSeriesSummable psi_ext s := by
  have h_bound : ∀ n : ℕ, ‖psi_ext n‖ ≤ 1 := by
    intro n
    unfold psi_ext
    split_ifs
    · simp
    · exact norm_chi3_le_one n
  exact LSeriesSummable_of_bounded_of_one_lt_re (fun n _ => h_bound n) hs
theorem chi3_even_LSeriesSummable {s : ℂ} (hs : 1 < s.re) :
    LSeriesSummable chi3_even s := by
  have h_bound : ∀ n : ℕ, ‖chi3_even n‖ ≤ 1 := by
    intro n
    unfold chi3_even
    split_ifs
    · exact norm_chi3_le_one n
    · simp
  exact LSeriesSummable_of_bounded_of_one_lt_re (fun n _ => h_bound n) hs
/-! ## The Splitting and Reindexing Identities -/
theorem LSeries_chi3_split {s : ℂ} (hs : 1 < s.re) :
    LSeries chi3 s = LSeries psi_ext s + LSeries chi3_even s := by
  have h_sum : LSeries (fun n => psi_ext n + chi3_even n) s
      = LSeries psi_ext s + LSeries chi3_even s :=
    LSeries_add (psi_ext_LSeriesSummable hs) (chi3_even_LSeriesSummable hs)
  rw [← h_sum, LSeries_congr]
  intro n _
  unfold psi_ext chi3_even
  split_ifs with h
  · simp
  · simp
theorem LSeries_chi3_even_eq {s : ℂ} (hs : 1 < s.re) :
    LSeries chi3_even s = -(2 : ℂ) ^ (-s) * LSeries chi3 s := by
  -- Express the even part as a sum over n where we substitute n = 2m.
  have h_even_sum :
      LSeries chi3_even s = ∑' n : ℕ, chi3 (2 * n) / ((2 * n : ℕ) : ℂ) ^ s := by
    rw [LSeries, ← tsum_even_add_odd]
    · simp [LSeries.term, chi3_even]
      congr 1; ext k; split_ifs with h
      · subst h; simp [chi3_zero]
      · rfl
    · have := chi3_even_LSeriesSummable hs
      convert this.comp_injective (mul_right_injective₀ two_ne_zero) using 1
    · simp [LSeries.term, chi3_even]
  rw [h_even_sum, LSeries, ← tsum_mul_left]
  congr 1; ext n
  by_cases hn : n = 0
  · simp [hn, chi3_zero]
  · simp only [LSeries.term, hn, ↓reduceIte, chi3_two_mul]
    rw [show ((2 * n : ℕ) : ℂ) = 2 * (n : ℂ) from by push_cast; ring]
    conv_lhs =>
      rw [show (2:ℂ) = ((2:ℝ):ℂ) from by norm_num,
          show (n:ℂ) = ((n:ℝ):ℂ) from by push_cast; rfl]
    rw [Complex.mul_cpow_ofReal_nonneg (by norm_num : (0:ℝ) ≤ 2)
        (by exact_mod_cast Nat.zero_le n)]
    rw [show ((2:ℝ):ℂ) ^ s = (2:ℂ) ^ s from by norm_num]
    rw [show ((n:ℝ):ℂ) ^ s = (n:ℂ) ^ s from by push_cast; rfl]
    rw [Complex.cpow_neg, div_mul_eq_div_div, div_eq_mul_inv, div_eq_mul_inv]
    ring
/-! ## The Main L-Series Identity -/
theorem LSeries_psi_ext_eq {s : ℂ} (hs : 1 < s.re) :
    LSeries psi_ext s = (1 + (2 : ℂ) ^ (-s)) * LSeries chi3 s := by
  calc LSeries psi_ext s
      = LSeries chi3 s - LSeries chi3_even s := by
          rw [LSeries_chi3_split hs]; ring
    _ = LSeries chi3 s - (-(2 : ℂ) ^ (-s) * LSeries chi3 s) := by
          rw [LSeries_chi3_even_eq hs]
    _ = (1 + (2 : ℂ) ^ (-s)) * LSeries chi3 s := by ring
#print axioms LSeries_psi_ext_eq
#check @LSeries_psi_ext_eq
