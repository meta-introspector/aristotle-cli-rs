import Mathlib

/-!
# DULA: Prime-Factorization Grading and L-Series Identity

This file is a single self-contained Lean 4 formalization of:

1. The DULA prime-factorization construction: P1, P5, P, has_P_primes_only,
   the submonoid S of integers coprime to 6, and the grading
   `psi_factored n = (-1)^(m_count n)` where `m_count` counts the prime
   factors of n that are ≡ 5 (mod 6) with multiplicity.

2. The connector theorem `psi_factored_eq_chi3_on_S`: on S, the
   prime-factorization-based grading equals the Jacobi symbol mod 3,
   proved by strong induction via the smallest prime factor.

3. The L-series identity for the imprimitive lift of χ₃:
   `LSeries psi_ext s = (1 + 2^(-s)) · LSeries chi3 s` for Re(s) > 1.

4. The DULA corollary: the same L-series identity, but for the
   prime-factorization-based grading extended by zero outside S.
-/

open scoped BigOperators

noncomputable section

open Classical

set_option maxHeartbeats 800000

/-! ## Part 1: Basic Definitions -/

/-- The non-principal Dirichlet character mod 3, via the Jacobi symbol. -/
def chi3 (n : ℕ) : ℂ := ((jacobiSym (n : ℤ) 3 : ℤ) : ℂ)

/-- Primes ≡ 1 (mod 6). -/
def P1 : Set ℕ := {p | p.Prime ∧ p % 6 = 1}

/-- Primes ≡ 5 (mod 6). -/
def P5 : Set ℕ := {p | p.Prime ∧ p % 6 = 5}

/-- All primes coprime to 6 (i.e., primes ≠ 2 and ≠ 3). -/
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

/-- S as a type. -/
abbrev S := S_submonoid

/-! ## Part 2: Basic chi3 Properties -/

lemma chi3_zero : chi3 0 = 0 := by
  simp [chi3, show jacobiSym (0 : ℤ) 3 = 0 from by norm_num]

lemma chi3_one : chi3 1 = 1 := by
  simp [chi3, show jacobiSym (1 : ℤ) 3 = 1 from by norm_num]

lemma chi3_two : chi3 2 = -1 := by
  simp [chi3, show jacobiSym (2 : ℤ) 3 = -1 from by norm_num]

lemma chi3_three : chi3 3 = 0 := by
  simp [chi3, show jacobiSym (3 : ℤ) 3 = 0 from by norm_num]

/-- chi3 is completely multiplicative. -/
theorem chi3_mul (a b : ℕ) : chi3 (a * b) = chi3 a * chi3 b := by
  simp only [chi3, Nat.cast_mul, jacobiSym.mul_left, Int.cast_mul]

/-- |chi3 n| ≤ 1, since jacobiSym ∈ {-1, 0, 1}. -/
lemma norm_chi3_le_one (n : ℕ) : ‖chi3 n‖ ≤ 1 := by
  simp only [chi3]
  rcases jacobiSym.trichotomy (n : ℤ) 3 with h | h | h <;> simp [h]

/-- chi3 of a P1-prime is 1. -/
theorem chi3_P1 {p : ℕ} (hp : p ∈ P1) : chi3 p = 1 := by
  obtain ⟨_, hp_mod⟩ := hp
  unfold chi3
  rw [jacobiSym.mod_left]
  norm_cast
  rw [← Nat.mod_mod_of_dvd p (by decide : 3 ∣ 6), hp_mod]
  norm_num

/-- chi3 of a P5-prime is -1. -/
theorem chi3_P5 {p : ℕ} (hp : p ∈ P5) : chi3 p = -1 := by
  unfold chi3
  rw [jacobiSym.mod_left]
  norm_cast
  rw [← Nat.mod_mod_of_dvd p (by decide : 3 ∣ 6), hp.2]
  norm_num
  rfl

/-- chi3 of 2m is -chi3 m. -/
theorem chi3_two_mul (n : ℕ) : chi3 (2 * n) = -chi3 n := by
  rw [chi3_mul, chi3_two]; ring

/-! ## Part 3: The DULA prime-factorization grading -/

/-- The P5-valuation: counts prime factors of n that are ≡ 5 (mod 6),
    with multiplicity. -/
def m_count (n : ℕ) : ℕ :=
  n.factorization.sum (fun p k => if p % 6 = 5 then k else 0)

/-- The DULA grading: psi_factored n = (-1)^(m_count n). -/
def psi_factored : ℕ → ℤ := fun n => (-1) ^ (m_count n)

/-- m_count is additive on nonzero arguments. -/
theorem m_count_mul {a b : ℕ} (ha : a ≠ 0) (hb : b ≠ 0) :
    m_count (a * b) = m_count a + m_count b := by
  unfold m_count
  rw [Nat.factorization_mul ha hb]
  rw [Finsupp.sum_add_index'] <;> aesop

/-- psi_factored is completely multiplicative on nonzero arguments. -/
theorem psi_factored_mul {a b : ℕ} (ha : a ≠ 0) (hb : b ≠ 0) :
    psi_factored (a * b) = psi_factored a * psi_factored b := by
  unfold psi_factored
  rw [m_count_mul ha hb, pow_add]

/-- m_count 1 = 0. -/
theorem m_count_one : m_count 1 = 0 := by
  unfold m_count
  rw [Nat.factorization_one]
  exact Finsupp.sum_zero_index

/-- psi_factored 1 = 1. -/
theorem psi_factored_one : psi_factored 1 = 1 := by
  unfold psi_factored
  rw [m_count_one]
  exact pow_zero _

/-- For p ∈ P1, psi_factored p = 1. -/
theorem psi_factored_P1 {p : ℕ} (hp : p ∈ P1) : psi_factored p = 1 := by
  unfold psi_factored m_count
  rw [hp.1.factorization]
  rw [Finsupp.sum_single_index (by simp)]
  rw [if_neg]
  · exact pow_zero _
  · have := hp.2; omega

/-- For p ∈ P5, psi_factored p = -1. -/
theorem psi_factored_P5 {p : ℕ} (hp : p ∈ P5) : psi_factored p = -1 := by
  unfold psi_factored m_count
  rw [hp.1.factorization]
  rw [Finsupp.sum_single_index (by simp)]
  rw [if_pos hp.2]
  exact pow_one _

/-! ## Part 4: The DULA Equivalence Theorem (Connector)

The central non-trivial result. On the monoid S, the prime-factorization
grading psi_factored equals chi3. Proved by strong induction on n.val via
the smallest prime factor.
-/

theorem psi_factored_eq_chi3_on_S (n : S) :
    ((psi_factored n.val : ℤ) : ℂ) = chi3 n.val := by
  obtain ⟨k, hP, hk0⟩ := n
  show ((psi_factored k : ℤ) : ℂ) = chi3 k
  induction k using Nat.strong_induction_on with
  | _ k ih =>
    by_cases hk1 : k = 1
    · -- Base case: k = 1
      subst hk1
      rw [psi_factored_one, chi3_one]
      norm_num
    · -- Step case: 1 < k
      have hk_gt1 : 1 < k := by
        rcases Nat.lt_or_ge k 1 with h | h
        · interval_cases k; exact absurd rfl hk0
        · omega
      set p := k.minFac with hp_def
      have hp_prime : p.Prime := Nat.minFac_prime hk1
      have hp_dvd : p ∣ k := Nat.minFac_dvd k
      have hp_in_P : p ∈ P := hP p hp_prime hp_dvd
      set m := k / p with hm_def
      have hp_pos : 0 < p := hp_prime.pos
      have hm0 : m ≠ 0 := by
        rw [hm_def]
        exact Nat.div_ne_zero_iff.mpr ⟨by omega, Nat.le_of_dvd (by omega) hp_dvd⟩
      have hm_lt : m < k := Nat.div_lt_self (by omega) hp_prime.one_lt
      have hk_eq : k = p * m := (Nat.mul_div_cancel' hp_dvd).symm
      have hm_P : has_P_primes_only m := fun q hq hqd =>
        hP q hq (hqd.trans (Nat.div_dvd_of_dvd hp_dvd))
      -- Apply induction hypothesis to m
      have ih_m : ((psi_factored m : ℤ) : ℂ) = chi3 m := ih m hm_lt hm_P hm0
      -- Apply multiplicativity on both sides
      rw [hk_eq, chi3_mul, psi_factored_mul hp_prime.ne_zero hm0]
      push_cast
      rw [ih_m]
      congr 1
      -- Now goal is: ((psi_factored p : ℤ) : ℂ) = chi3 p
      rcases hp_in_P with hp1 | hp5
      · rw [psi_factored_P1 hp1, chi3_P1 hp1]
        norm_num
      · rw [psi_factored_P5 hp5, chi3_P5 hp5]
        norm_num

/-! ## Part 5: psi_ext and the L-series identity

We define psi_ext as the indicator-style extension of chi3 to odd integers.
By the connector, this also equals the DULA prime-factorization grading
extended by zero outside S (proven later as a corollary).
-/

/-- psi_ext: chi3 on odd naturals, 0 on even. -/
def psi_ext : ℕ → ℂ := fun n => if Even n then 0 else chi3 n

/-- The even-part of chi3: chi3 on even naturals, 0 on odd. -/
def chi3_even : ℕ → ℂ := fun n => if Even n then chi3 n else 0

lemma chi3_eq_psi_add_even (n : ℕ) : chi3 n = psi_ext n + chi3_even n := by
  unfold psi_ext chi3_even
  split <;> simp

lemma LSeries_term_split (s : ℂ) (n : ℕ) :
    LSeries.term chi3 s n = LSeries.term psi_ext s n + LSeries.term chi3_even s n := by
  simp only [LSeries.term_def, psi_ext, chi3_even]
  split
  · simp
  · next hn => split <;> simp

lemma norm_psi_ext_le_one (n : ℕ) : ‖psi_ext n‖ ≤ 1 := by
  unfold psi_ext
  split
  · simp
  · exact norm_chi3_le_one n

lemma norm_chi3_even_le_one (n : ℕ) : ‖chi3_even n‖ ≤ 1 := by
  unfold chi3_even
  split
  · exact norm_chi3_le_one n
  · simp

/-! ### Summability -/

/-- LSeries summability of chi3 for Re(s) > 1, from |chi3| ≤ 1 dominating ∑ 1/n^s. -/
lemma chi3_LSeriesSummable {s : ℂ} (hs : 1 < s.re) : LSeriesSummable chi3 s :=
  LSeriesSummable_of_bounded_of_one_lt_re (fun n _ => norm_chi3_le_one n) hs

/-- LSeries summability of psi_ext, by the same bound. -/
lemma psi_ext_LSeriesSummable {s : ℂ} (hs : 1 < s.re) : LSeriesSummable psi_ext s :=
  LSeriesSummable_of_bounded_of_one_lt_re (fun n _ => norm_psi_ext_le_one n) hs

/-- LSeries summability of chi3_even, by the same bound. -/
lemma chi3_even_LSeriesSummable {s : ℂ} (hs : 1 < s.re) : LSeriesSummable chi3_even s :=
  LSeriesSummable_of_bounded_of_one_lt_re (fun n _ => norm_chi3_even_le_one n) hs

/-! ### Splitting identity -/

lemma LSeries_chi3_split {s : ℂ} (hs : 1 < s.re) :
    LSeries chi3 s = LSeries psi_ext s + LSeries chi3_even s := by
  unfold LSeries
  rw [← (psi_ext_LSeriesSummable hs).tsum_add (chi3_even_LSeriesSummable hs)]
  exact tsum_congr (fun n => LSeries_term_split s n)

/-! ### Even-part reindexing -/

/-
Reindexing the even sum via n = 2m, using chi3_two_mul to factor out -1.
-/
lemma LSeries_chi3_even_eq {s : ℂ} (hs : 1 < s.re) :
    LSeries chi3_even s = -(2 : ℂ) ^ (-s) * LSeries chi3 s := by
  -- By definition of $chi3_even$, we can write its L-series as a sum over even terms.
  have h_even_series : LSeries chi3_even s = ∑' n : ℕ, (if Even (2 * n) then (chi3 (2 * n) : ℂ) / ((2 * n) : ℂ) ^ s else 0) := by
    unfold LSeries;
    rw [ ← tsum_eq_tsum_of_ne_zero_bij ];
    use fun x => x.val / 2;
    · norm_num [ Function.Injective ];
      intro a ha b hb hab; have := Nat.div_add_mod a 2; have := Nat.div_add_mod b 2; simp_all +decide [ LSeries.term ] ;
      unfold chi3_even at *; simp_all +decide [ Nat.even_iff ] ;
    · intro x hx; use ⟨ 2 * x, by
        simp_all +decide [ LSeries.term, chi3_even ];
        rintro rfl; simp_all +decide [ chi3 ];
        norm_num at hs ⟩ ; aesop;
    · simp_all +decide [ LSeries.term, Function.support ];
      intro a ha h; rcases Nat.even_or_odd' a with ⟨ b, rfl | rfl ⟩ <;> simp_all +decide [ chi3_even ] ;
  -- Substitute $\chi_3(2n) = -\chi_3(n)$ into the series.
  have h_subst : LSeries chi3_even s = ∑' n : ℕ, (-chi3 n) / ((2 * n) : ℂ) ^ s := by
    convert h_even_series using 3 ; norm_num [ chi3_two_mul ];
  rw [ h_subst, LSeries ];
  rw [ ← tsum_mul_left ] ; congr ; ext n ; by_cases hn : n = 0 <;> simp +decide [ hn, LSeries.term_def, mul_comm, mul_assoc, mul_left_comm, div_eq_mul_inv, Complex.cpow_neg ] ; ring;
  · exact Or.inl <| by rintro rfl; norm_num at hs;
  · rw [ ← mul_inv, mul_comm, Complex.cpow_def_of_ne_zero, Complex.cpow_def_of_ne_zero, Complex.cpow_def_of_ne_zero ] <;> norm_num [ hn ];
    rw [ ← mul_inv, ← Complex.exp_add, Complex.log_mul ] <;> norm_num [ hn ];
    · exact Or.inl <| congr_arg Complex.exp <| by ring;
    · exact ⟨ Real.pi_pos, Real.pi_pos.le ⟩

/-! ## Part 6: The Main L-Series Identity -/

/-- **Main Theorem**: The L-series of psi_ext equals (1 + 2^(-s)) · L(s, chi3). -/
theorem LSeries_psi_ext_eq {s : ℂ} (hs : 1 < s.re) :
    LSeries psi_ext s = (1 + (2 : ℂ) ^ (-s)) * LSeries chi3 s :=
  calc LSeries psi_ext s
      = LSeries chi3 s - LSeries chi3_even s := by
          have := LSeries_chi3_split hs; rw [this]; ring
    _ = LSeries chi3 s - (-(2 : ℂ) ^ (-s) * LSeries chi3 s) := by
          rw [LSeries_chi3_even_eq hs]
    _ = (1 + (2 : ℂ) ^ (-s)) * LSeries chi3 s := by ring

/-! ## Part 7: The DULA Corollary

Now we connect the prime-factorization grading (psi_factored) to psi_ext.
The DULA-style extension is `dula_psi_ext n = if n ∈ S then psi_factored n else 0`
(viewing the result in ℂ). We show this equals psi_ext, hence has the
same L-series.
-/

/-- Helper: if n has only P-primes (n ≠ 0), then n is odd. -/
lemma odd_of_has_P_primes_only {n : ℕ} (hP : has_P_primes_only n) (hn0 : n ≠ 0) :
    ¬ Even n := by
  intro heven
  have h2 : (2 : ℕ) ∣ n := heven.two_dvd
  have h2P : (2 : ℕ) ∈ P := hP 2 Nat.prime_two h2
  rcases h2P with ⟨_, h⟩ | ⟨_, h⟩ <;> norm_num at h

/-- Helper: if n is odd and not in S, then 3 ∣ n. -/
lemma three_dvd_of_odd_not_P {n : ℕ} (hodd : ¬ Even n) (hnotP : ¬ has_P_primes_only n)
    (hn0 : n ≠ 0) : (3 : ℕ) ∣ n := by
  unfold has_P_primes_only at hnotP
  push_neg at hnotP
  obtain ⟨q, hq, hqd, hqnotP⟩ := hnotP
  unfold P P1 P5 at hqnotP
  simp only [Set.mem_union, Set.mem_setOf_eq, not_or, not_and] at hqnotP
  have hq2 : q ≠ 2 := fun heq => hodd ⟨n / 2, by rw [heq] at hqd; omega⟩
  have hq_mod : q % 6 ≠ 1 ∧ q % 6 ≠ 5 := ⟨hqnotP.1 hq, hqnotP.2 hq⟩
  rcases hq.eq_two_or_odd with rfl | hq_odd
  · exact (hq2 rfl).elim
  · have hq_mod6 : q % 6 = 3 := by
      have : q % 6 < 6 := Nat.mod_lt q (by omega)
      have : q % 2 = 1 := hq_odd
      have hmod6_mod2 : q % 6 % 2 = q % 2 := Nat.mod_mod_of_dvd q (by decide : (2 : ℕ) ∣ 6)
      omega
    have h3dvdq : (3 : ℕ) ∣ q := by
      have : q = 6 * (q / 6) + 3 := by omega
      omega
    have hq_eq3 : q = 3 :=
      ((hq.eq_one_or_self_of_dvd 3 h3dvdq).resolve_left (by decide)).symm
    rw [← hq_eq3]; exact hqd

/-- Helper: chi3 vanishes when 3 ∣ n. -/
lemma chi3_eq_zero_of_three_dvd {n : ℕ} (h : (3 : ℕ) ∣ n) : chi3 n = 0 := by
  unfold chi3
  have : jacobiSym (n : ℤ) 3 = 0 := by
    rw [jacobiSym.mod_left]
    have : (n : ℤ) % ↑(3 : ℕ) = 0 := by omega
    rw [this]; norm_num
  simp [this]

/-- The bridge: the DULA-style extension equals psi_ext pointwise. -/
theorem bridge (n : ℕ) :
    (if h : has_P_primes_only n ∧ n ≠ 0 then ((psi_factored n : ℤ) : ℂ) else 0) =
    psi_ext n := by
  unfold psi_ext
  split_ifs with hS heven
  · -- n ∈ S, n even: contradiction (n in S is odd)
    exact absurd heven (odd_of_has_P_primes_only hS.1 hS.2)
  · -- n ∈ S, n odd: psi_factored n = chi3 n by connector
    exact psi_factored_eq_chi3_on_S ⟨n, hS⟩
  · -- n ∉ S, n even: psi_ext n = 0, so LHS = 0 ✓
    rfl
  · -- n ∉ S, n odd: must show 0 = chi3 n. Since n odd ∉ S, 3 ∣ n, so chi3 n = 0.
    rename_i hodd
    by_cases hn0 : n = 0
    · subst hn0; simp [chi3_zero]
    · have hnotP : ¬ has_P_primes_only n := fun h => hS ⟨h, hn0⟩
      have h3 := three_dvd_of_odd_not_P hodd hnotP hn0
      rw [chi3_eq_zero_of_three_dvd h3]

/-- The DULA-style extended grading. -/
def dula_psi_ext (n : ℕ) : ℂ :=
  if h : has_P_primes_only n ∧ n ≠ 0 then ((psi_factored n : ℤ) : ℂ) else 0

/-- dula_psi_ext = psi_ext pointwise (the bridge). -/
theorem dula_psi_ext_eq_psi_ext : dula_psi_ext = psi_ext := by
  ext n; exact bridge n

/-- **DULA L-Series Corollary**: the L-series of the DULA prime-factorization
    grading (extended by zero outside S) equals (1 + 2^(-s)) · L(s, χ₃)
    for Re(s) > 1. -/
theorem LSeries_dula_psi_ext_eq {s : ℂ} (hs : 1 < s.re) :
    LSeries dula_psi_ext s = (1 + (2 : ℂ) ^ (-s)) * LSeries chi3 s := by
  rw [dula_psi_ext_eq_psi_ext]
  exact LSeries_psi_ext_eq hs

end
