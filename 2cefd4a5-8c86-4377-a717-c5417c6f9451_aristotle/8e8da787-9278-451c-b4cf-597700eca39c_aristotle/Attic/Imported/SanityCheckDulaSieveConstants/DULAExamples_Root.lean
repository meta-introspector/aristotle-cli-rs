import Mathlib
import DULAUniversal
import DULAGradedMonoid
import Polignac

/-!
# DULA Examples – Closure, Admissibility, and Surviving-Hole Density
This file records the core combinatorial closure property and completes
the density analysis of surviving twin-prime candidates after sieving
by the first m primes.
-/

noncomputable section

namespace DULAExamples

open DULAUniversal DULAGradedMonoid

/-! ### Named lemma for the fundamental closure property -/

theorem primes_gt_three_are_pm_one_mod_six
    {p : ℕ} (hp : p.Prime) (h3 : 3 < p) :
    p % 6 = 1 ∨ p % 6 = 5 := by
  exact prime_mod_six_of_three_lt hp h3

/-! ### Admissibility of small even-gap tuples -/

/-- A finite set of linear forms is admissible if it does not cover all
    residue classes modulo any prime. -/
def IsAdmissible (hs : List ℕ) : Prop :=
  ∀ p : ℕ, p.Prime → ∃ r : ℕ, r < p ∧ ∀ h ∈ hs, (r + h) % p ≠ 0

/-- Twin-prime tuple {0, 2} is admissible. -/
theorem twin_prime_admissible : IsAdmissible [0, 2] := by
  intro p
  by_cases h : p = 2 ∨ p = 3;
  · rcases h with ( rfl | rfl ) <;> simp_all +decide;
  · intro hp
    use 1;
    rcases p with ( _ | _ | _ | _ | _ | p ) <;> simp_all +arith +decide [ Nat.mod_eq_of_lt ]

/-- Sexy-prime tuple {0, 6} is admissible. -/
theorem sexy_prime_admissible : IsAdmissible [0, 6] := by
  intro p hp; by_cases h : p ≤ 3 <;> simp_all +decide;
  · interval_cases p <;> exists 1;
  · by_contra h_contra;
    rcases p with ( _ | _ | _ | _ | _ | _ | _ | _ | _ | _ | p ) <;> simp_all +arith +decide [ Nat.mod_eq_of_lt ];
    exact absurd ( h_contra 1 ( by linarith ) ( by norm_num ) ) ( by rw [ Nat.mod_eq_of_lt ] <;> linarith )

/-- Cousin-prime tuple {0, 4} is admissible. -/
theorem cousin_prime_admissible : IsAdmissible [0, 4] := by
  intro p hp
  by_cases h_cases : p = 2 ∨ p = 3 ∨ p = 5;
  · rcases h_cases with ( rfl | rfl | rfl ) <;> decide;
  · use 1;
    exact ⟨ hp.one_lt, by rcases p with ( _ | _ | _ | _ | _ | _ | p ) <;> simp_all +arith +decide [ Nat.mod_eq_of_lt ] ⟩

/-! ### Density of surviving twin-prime holes after sieving by first m primes -/

/-- The set of candidates n > 3 with n ≡ 5 mod 6, n+2 ≡ 1 mod 6,
    whose smallest prime factor exceeds the m-th prime p_m. -/
def TwinPrimeSurvivingHoles (m : ℕ) : Set ℕ :=
  { n | 3 < n ∧ n % 6 = 5 ∧ (n + 2) % 6 = 1 ∧
        ∀ p ≤ (Nat.nth Nat.Prime m), p.Prime → ¬(p ∣ n ∨ p ∣ (n + 2)) }

/-! ### General density lemma for periodic subsets of ℕ -/

/-- A predicate on ℕ is periodic with period M if P(n) ↔ P(n + M) for all n. -/
def IsPeriodic (P : ℕ → Prop) (M : ℕ) : Prop :=
  0 < M ∧ ∀ n, P n ↔ P (n + M)

/-- Count of elements satisfying P in [0, N). -/
def countIn (P : ℕ → Prop) [DecidablePred P] (N : ℕ) : ℕ :=
  (Finset.range N).filter P |>.card

/-
Density convergence for periodic decidable predicates on ℕ.
    If P is periodic with period M and has k elements in [0, M),
    then countIn P N / N → k / M.
-/
theorem periodic_density_tendsto (P : ℕ → Prop) [DecidablePred P] (M : ℕ)
    (hper : IsPeriodic P M) :
    Filter.Tendsto
      (fun N => (countIn P (N + 1) : ℝ) / N)
      Filter.atTop
      (nhds ((countIn P M : ℝ) / M)) := by
  cases eq_or_ne M 0 <;> simp_all +decide [ IsPeriodic ];
  -- Let $k = \text{countIn } P M$. For $N$, write $N = qM + r$ with $0 \leq r < M$.
  set k := countIn P M
  have h_div : ∀ N, countIn P (N + 1) = (N / M) * k + countIn P ((N % M) + 1) := by
    -- By periodicity, the count in each block of M numbers is k.
    have h_block_count : ∀ q, countIn P (q * M) = q * k := by
      intro q
      induction' q with q ih;
      · simp [countIn];
      · -- By periodicity, the count in the interval $[qM, (q+1)M)$ is the same as the count in $[0, M)$.
        have h_periodic : ∀ n, countIn P (n + M) = countIn P n + k := by
          intro n
          simp [countIn] ; simp +decide [ Nat.succ_add, Finset.sum_range_succ, countIn ] at *;
          induction' n with n ih <;> simp +decide [ Nat.succ_add, Finset.sum_range_succ, Finset.filter ] at *;
          · rfl;
          · by_cases h : P ( n + M ) <;> simp +decide [ h, ih, hper.2 n ];
            ring;
        rw [ Nat.succ_mul, h_periodic, ih, add_mul, one_mul ];
    intro N
    have h_div : N + 1 = (N / M) * M + (N % M + 1) := by
      linarith [ Nat.mod_add_div N M ];
    rw [ h_div, ← h_block_count ];
    unfold countIn;
    rw [ Finset.range_add, Finset.filter_union, Finset.card_union_of_disjoint ];
    · norm_num [ Finset.filter_map ];
      congr! 1;
      ext; simp +decide [ Function.comp ];
      induction' N / M with q IH <;> simp +decide [ Nat.succ_mul, ← add_assoc, ← hper.2 ];
      grind;
    · norm_num [ Finset.disjoint_right ];
  -- Using the division result, we can rewrite the limit expression.
  suffices h_rewrite : Filter.Tendsto (fun N => ((N / M : ℕ) * k + countIn P ((N % M) + 1) : ℝ) / N) Filter.atTop (nhds ((k : ℝ) / M)) by
    convert h_rewrite using 2 ; norm_cast ; aesop ( simp_config := { singlePass := true } ) ;
  -- We can factor out $k$ and use the fact that $\frac{N}{M} \to \infty$ as $N \to \infty$.
  have h_factor : Filter.Tendsto (fun N => ((N / M : ℕ) : ℝ) / N) Filter.atTop (nhds (1 / M)) := by
    -- We can use the fact that $N / M$ is approximately $N / M$ for large $N$.
    have h_approx : Filter.Tendsto (fun N => ((N : ℝ) / M - 1) / N) Filter.atTop (nhds (1 / M)) := by
      ring_nf;
      exact le_trans ( Filter.Tendsto.sub ( tendsto_const_nhds.congr' ( by filter_upwards [ Filter.eventually_ne_atTop 0 ] with N hN; rw [ mul_right_comm, mul_inv_cancel₀ hN, one_mul ] ) ) ( tendsto_inv_atTop_zero ) ) ( by norm_num );
    refine' tendsto_of_tendsto_of_tendsto_of_le_of_le' ( h_approx.comp tendsto_natCast_atTop_atTop ) tendsto_const_nhds _ _;
    · filter_upwards [ Filter.eventually_gt_atTop 0 ] with N hN using by rw [ Function.comp_apply ] ; exact div_le_div_of_nonneg_right ( sub_le_iff_le_add.mpr <| by rw [ div_le_iff₀ <| Nat.cast_pos.mpr hper.1 ] ; norm_cast ; linarith [ Nat.div_add_mod N M, Nat.mod_lt N hper.1 ] ) <| Nat.cast_nonneg _;
    · filter_upwards [ Filter.eventually_gt_atTop 0 ] with N hN using by rw [ div_le_div_iff₀ ] <;> norm_cast <;> nlinarith [ Nat.div_mul_le_self N M ] ;
  -- We can use the fact that $\frac{countIn P ((N % M) + 1)}{N}$ tends to $0$ as $N$ tends to infinity.
  have h_zero : Filter.Tendsto (fun N => (countIn P ((N % M) + 1) : ℝ) / N) Filter.atTop (nhds 0) := by
    -- Since $countIn P ((N % M) + 1)$ is bounded, we can use the fact that $\frac{countIn P ((N % M) + 1)}{N}$ tends to $0$ as $N$ tends to infinity.
    have h_bounded : ∃ C : ℝ, ∀ N, (countIn P ((N % M) + 1) : ℝ) ≤ C := by
      use M + 1;
      intro N; norm_cast; exact le_trans ( Finset.card_filter_le _ _ ) ( by norm_num; linarith [ Nat.mod_lt N hper.1 ] ) ;
    exact squeeze_zero ( fun N => by positivity ) ( fun N => mul_le_mul_of_nonneg_right ( h_bounded.choose_spec N ) ( by positivity ) ) ( tendsto_const_nhds.div_atTop tendsto_natCast_atTop_atTop );
  convert h_factor.const_mul ( k : ℝ ) |> Filter.Tendsto.add <| h_zero using 2 <;> ring

/-
If P is periodic with period M and has at least one element in [0, M),
    then countIn P M > 0.
-/
theorem periodic_count_pos_of_exists (P : ℕ → Prop) [DecidablePred P] (M : ℕ)
    (hper : IsPeriodic P M) (hex : ∃ n < M, P n) :
    0 < countIn P M := by
  exact Finset.card_pos.mpr ⟨ hex.choose, Finset.mem_filter.mpr ⟨ Finset.mem_range.mpr hex.choose_spec.1, hex.choose_spec.2 ⟩ ⟩

/-- The membership predicate for TwinPrimeSurvivingHoles is decidable. -/
instance decidableTwinPrimeSurvivingHoles (m : ℕ) :
    DecidablePred (· ∈ TwinPrimeSurvivingHoles m) := by
  intro n
  simp only [TwinPrimeSurvivingHoles, Set.mem_setOf_eq]
  exact inferInstance

/-- Period for the twin-prime surviving holes sieve. -/
def sievePeriod (m : ℕ) : ℕ :=
  6 * ∏ p ∈ (Finset.range (Nat.nth Nat.Prime m + 1)).filter Nat.Prime, p

theorem sievePeriod_pos (m : ℕ) : 0 < sievePeriod m := by
  exact mul_pos ( by decide ) ( Finset.prod_pos fun p hp => Nat.Prime.pos <| Finset.mem_filter.mp hp |>.2 )

/-
TwinPrimeSurvivingHoles m is periodic with period sievePeriod m.
-/
theorem twinPrimeSurvivingHoles_periodic (m : ℕ) :
    IsPeriodic (· ∈ TwinPrimeSurvivingHoles m) (sievePeriod m) := by
  have h_periodic : ∀ n, n ∈ TwinPrimeSurvivingHoles m ↔ n + sievePeriod m ∈ TwinPrimeSurvivingHoles m := by
    intro n
    constructor;
    · intro hn
      obtain ⟨hn_gt, hn_mod, hn_mod2, hn_not_div⟩ := hn;
      refine' ⟨ _, _, _, _ ⟩;
      · exact lt_add_of_lt_of_nonneg hn_gt ( Nat.zero_le _ );
      · unfold sievePeriod; norm_num [ Nat.add_mod, Nat.mul_mod, hn_mod ] ;
      · unfold sievePeriod; norm_num [ Nat.add_mod, Nat.mul_mod, hn_mod, hn_mod2 ] ;
      · intro p hp hp_prime
        have hp_div : p ∣ sievePeriod m := by
          exact dvd_mul_of_dvd_right ( Finset.dvd_prod_of_mem _ ( Finset.mem_filter.mpr ⟨ Finset.mem_range.mpr ( Nat.lt_succ_of_le hp ), hp_prime ⟩ ) ) _;
        simp_all +decide [ Nat.dvd_iff_mod_eq_zero, Nat.add_mod ];
    · intro hn
      obtain ⟨hn_gt, hn_mod, hn_mod2, hn_not_div⟩ := hn;
      refine' ⟨ _, _, _, _ ⟩;
      · contrapose! hn_not_div; interval_cases n <;> norm_num at *;
        · exact absurd hn_mod ( by rw [ show sievePeriod m = 6 * ∏ p ∈ Finset.filter Nat.Prime ( Finset.range ( Nat.nth Nat.Prime m + 1 ) ), p from rfl ] ; norm_num [ Nat.add_mod, Nat.mul_mod ] );
        · unfold sievePeriod at *; norm_num [ Nat.add_mod, Nat.mul_mod ] at *;
        · unfold sievePeriod at *; norm_num [ Nat.add_mod, Nat.mul_mod ] at *;
        · unfold sievePeriod at *; norm_num [ Nat.add_mod, Nat.mul_mod ] at *;
      · unfold sievePeriod at *; norm_num [ Nat.add_mod, Nat.mul_mod ] at *; aesop;
      · unfold sievePeriod at *; norm_num [ Nat.add_mod, Nat.mul_mod ] at *; aesop;
      · intro p hp hp_prime
        have hp_div : p ∣ sievePeriod m := by
          exact dvd_mul_of_dvd_right ( Finset.dvd_prod_of_mem _ ( Finset.mem_filter.mpr ⟨ Finset.mem_range.mpr ( Nat.lt_succ_of_le hp ), hp_prime ⟩ ) ) _;
        exact fun h => hn_not_div p hp hp_prime <| by simpa [ Nat.dvd_iff_mod_eq_zero, Nat.add_mod, Nat.mod_eq_zero_of_dvd hp_div ] using h;
  -- To prove that sievePeriod m is positive, we can use the fact that sievePeriod m is defined as 6 times the product of primes up to the m-th prime, and since primes are positive, their product is also positive.
  apply And.intro (sievePeriod_pos m) h_periodic

/-
There exists at least one surviving hole in [0, sievePeriod m).
-/
theorem twinPrimeSurvivingHoles_exists (m : ℕ) :
    ∃ n < sievePeriod m, n ∈ TwinPrimeSurvivingHoles m := by
  -- Let's choose any $n$ such that $n \equiv -1 \pmod{6}$ and $n+2 \equiv 1 \pmod{6}$.
  obtain ⟨n, hn⟩ : ∃ n, n < sievePeriod m ∧ n % 6 = 5 ∧ (n + 2) % 6 = 1 ∧ ∀ p ≤ Nat.nth Nat.Prime m, Nat.Prime p → ¬(p ∣ n ∨ p ∣ (n + 2)) := by
    -- By the Chinese Remainder Theorem, there exists an $n$ such that $n \equiv -1 \pmod{6}$ and $n \equiv 1 \pmod{p}$ for all primes $p \leq m$.
    obtain ⟨n, hn⟩ : ∃ n, n ≡ 5 [MOD 6] ∧ ∀ p ≤ Nat.nth Nat.Prime m, Nat.Prime p → p ≠ 2 → p ≠ 3 → n ≡ 1 [MOD p] := by
      -- We can use the Chinese Remainder Theorem to find such an $n$.
      have h_crt : ∃ n, n ≡ 5 [MOD 6] ∧ n ≡ 1 [MOD (∏ p ∈ Finset.filter Nat.Prime (Finset.range (Nat.nth Nat.Prime m + 1)) \ {2, 3}, p)] := by
        have h_crt : Nat.gcd 6 (∏ p ∈ Finset.filter Nat.Prime (Finset.range (Nat.nth Nat.Prime m + 1)) \ {2, 3}, p) = 1 := by
          refine' Nat.Coprime.prod_right fun p hp => _;
          exact Nat.Coprime.symm ( Nat.Prime.coprime_iff_not_dvd ( Finset.mem_filter.mp ( Finset.mem_sdiff.mp hp |>.1 ) |>.2 ) |>.2 fun h => by have := Nat.le_of_dvd ( by norm_num ) h; interval_cases p <;> simp_all +decide );
        have := Nat.chineseRemainder h_crt;
        exact ⟨ _, this 5 1 |>.2 ⟩;
      exact ⟨ h_crt.choose, h_crt.choose_spec.1, fun p hp₁ hp₂ hp₃ hp₄ => h_crt.choose_spec.2.of_dvd <| Finset.dvd_prod_of_mem _ <| by aesop ⟩;
    refine' ⟨ n % sievePeriod m, Nat.mod_lt _ ( sievePeriod_pos m ), _, _, _ ⟩ <;> simp_all +decide [ Nat.ModEq, Nat.dvd_iff_mod_eq_zero ];
    · rw [ Nat.mod_mod_of_dvd _ ( show 6 ∣ sievePeriod m from dvd_mul_right _ _ ), hn.1 ];
    · unfold sievePeriod; norm_num [ Nat.add_mod, Nat.mul_mod, hn ] ;
    · intro p hp hp'; rcases p with ( _ | _ | _ | _ | _ | _ | p ) <;> simp_all +arith +decide [ Nat.mod_eq_of_lt ] ;
      · rw [ Nat.mod_mod_of_dvd _ ( show 2 ∣ sievePeriod m from dvd_mul_of_dvd_left ( by decide ) _ ) ] ; norm_num [ ← Nat.mod_mod_of_dvd n ( by decide : 2 ∣ 6 ), hn.1 ];
      · unfold sievePeriod; norm_num [ Nat.add_mod, Nat.mul_mod, hn.1 ] ;
        rw [ Nat.mod_mod_of_dvd _ ( dvd_mul_of_dvd_left ( by decide ) _ ) ] ; norm_num [ hn.1 ];
        norm_num [ Nat.add_mod, ← Nat.mod_mod_of_dvd n ( by decide : 3 ∣ 6 ), hn.1 ];
      · have := hn.2 5 hp ( by norm_num ) ( by norm_num ) ( by norm_num ) ; norm_num [ Nat.add_mod, Nat.mul_mod, sievePeriod ] at * ; simp_all +decide [ Nat.mod_eq_of_lt ] ;
        rw [ Nat.mod_mod_of_dvd _ ( dvd_mul_of_dvd_right ( Finset.dvd_prod_of_mem _ ( by norm_num; linarith ) ) _ ) ] ; norm_num [ Nat.add_mod, Nat.mul_mod, hn.1, hn.2 5 hp ( by norm_num ) ( by norm_num ) ( by norm_num ) ] ;
        rw [ Nat.mod_mod_of_dvd _ ( dvd_mul_of_dvd_right ( Finset.dvd_prod_of_mem _ ( by norm_num; linarith ) ) _ ) ] ; norm_num [ Nat.add_mod, Nat.mul_mod, hn.1, hn.2 5 hp ( by norm_num ) ( by norm_num ) ( by norm_num ) ] ;
      · have h_mod : n % (p + 6) = 1 := by
          exact hn.2 _ hp hp' ( by linarith ) ( by linarith ) ▸ by norm_num;
        have h_mod : n % sievePeriod m % (p + 6) = 1 := by
          rw [ ← h_mod, Nat.mod_mod_of_dvd _ ];
          exact dvd_mul_of_dvd_right ( Finset.dvd_prod_of_mem _ ( Finset.mem_filter.mpr ⟨ Finset.mem_range.mpr ( by linarith ), hp' ⟩ ) ) _;
        norm_num [ Nat.add_mod, h_mod ];
        rcases p with ( _ | _ | p ) <;> simp_all +arith +decide [ Nat.mod_eq_of_lt ];
  -- We need to ensure that $n > 3$.
  by_cases hn_gt_3 : 3 < n;
  · exact ⟨ n, hn.1, ⟨ hn_gt_3, hn.2.1, hn.2.2.1, hn.2.2.2 ⟩ ⟩;
  · interval_cases n <;> simp_all +decide

/-
The density of surviving twin-prime candidates after sieving by the
    first m primes is positive.
-/
theorem twin_prime_surviving_holes_positive_density (m : ℕ) :
    ∃ c_m : ℝ, 0 < c_m ∧
      Filter.Tendsto
        (fun N => (Set.ncard {n ∈ Finset.range (N + 1) | n ∈ TwinPrimeSurvivingHoles m} : ℝ) / N)
        Filter.atTop (nhds c_m) := by
  have h_surviving_density : ∃ c_m, 0 < c_m ∧ Filter.Tendsto
    (fun N => (countIn (· ∈ TwinPrimeSurvivingHoles m) (N + 1) : ℝ) / N)
    Filter.atTop
    (nhds c_m) := by
      refine' ⟨ _, _, periodic_density_tendsto _ _ ( twinPrimeSurvivingHoles_periodic m ) ⟩;
      exact div_pos ( Nat.cast_pos.mpr ( periodic_count_pos_of_exists _ _ ( twinPrimeSurvivingHoles_periodic m ) ( twinPrimeSurvivingHoles_exists m ) ) ) ( Nat.cast_pos.mpr ( sievePeriod_pos m ) );
  convert h_surviving_density using 6;
  simp +decide [ Set.setOf_and, Set.ncard_eq_toFinset_card' ];
  congr 1 with ( _ | i ) <;> simp +decide [ Nat.lt_succ_iff ]

end DULAExamples

end