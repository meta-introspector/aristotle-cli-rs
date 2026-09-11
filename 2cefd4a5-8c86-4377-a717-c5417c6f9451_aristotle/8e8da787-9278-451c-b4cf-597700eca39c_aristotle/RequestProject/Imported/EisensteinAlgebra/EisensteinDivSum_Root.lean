import Mathlib
import RequestProject.Imported.EisensteinAlgebra.EisensteinIntegers_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinOrbit_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinEuclidean_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinAlgebra_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinUnits_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinThetaBridge_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinTheta_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinPrimeSplit_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinPrimeSplitHard_Root

/-!
# idealCount equals divSum
-/

noncomputable section

open scoped Classical

namespace Eisenstein

open EisensteinTheta

def iCount (n : ℕ) : ℕ :=
  (Ideal.finite_setOf_absNorm_eq (S := Eisenstein) n).toFinset.card

theorem chi3_mul' (m n : ℕ) : chi3 (m * n) = chi3 m * chi3 n :=
  chi3_mul m n

theorem divSum_multiplicative (m n : ℕ) (hm : 0 < m) (hn : 0 < n)
    (hcop : Nat.Coprime m n) :
    divSum (m * n) = divSum m * divSum n := by
  unfold divSum;
  -- Apply the bijection between the divisors of mn and the pairs (d1, d2) to rewrite the sum.
  have h_bij : (m * n).divisors = Finset.image (fun (p : ℕ × ℕ) => p.1 * p.2) (m.divisors ×ˢ n.divisors) := by
    exact Nat.divisors_mul _ _;
  rw [ h_bij, Finset.sum_image, Finset.sum_product ];
  · simp +decide only [chi3_mul', Finset.sum_mul_sum];
  · intros p hp q hq h_eq; simp_all +decide [ Nat.coprime_iff_gcd_eq_one ] ;
    -- Since $p.1 \mid m$ and $q.1 \mid m$, and $\gcd(m, n) = 1$, it follows that $p.1 = q.1$.
    have hp1_eq_q1 : p.1 = q.1 := by
      exact Nat.dvd_antisymm ( by exact Nat.Coprime.dvd_of_dvd_mul_right ( Nat.Coprime.coprime_dvd_left hp.1.1 <| Nat.Coprime.coprime_dvd_right hq.2 hcop ) <| h_eq.symm ▸ dvd_mul_right _ _ ) ( by exact Nat.Coprime.dvd_of_dvd_mul_right ( Nat.Coprime.coprime_dvd_left hq.1 <| Nat.Coprime.coprime_dvd_right hp.2.1 hcop ) <| h_eq.symm ▸ dvd_mul_right _ _ );
    aesop

theorem divSum_prime_pow (p k : ℕ) (hp : Nat.Prime p) :
    divSum (p ^ k) = ∑ i ∈ Finset.range (k + 1), chi3 p ^ i := by
  unfold divSum; simp +decide [ Nat.divisors_prime_pow hp ] ;
  refine' Finset.sum_congr rfl fun i hi => _;
  induction i <;> simp_all +decide [ pow_succ' ];
  rw [ ← ‹ ( _ : ℕ ) ≤ k → chi3 ( p ^ _ ) = chi3 p ^ _ › ( Nat.le_of_lt hi ), chi3_mul' ]

theorem iCount_one : iCount 1 = 1 := by
  refine' Finset.card_eq_one.mpr _;
  use ⊤; ext; aesop;

/-- No element of Eisenstein has norm ≡ 2 mod 3. -/
theorem no_norm_two_mod_three (n : ℕ) (hn : n % 3 = 2) :
    ∀ z : Eisenstein, Eisenstein.norm z ≠ (n : ℤ) :=
  EisensteinPrimeSplit.no_norm_eq_of_two_mod_three_nat n hn

/-- For p ≡ 2 mod 3 and k odd, p^k ≡ 2 mod 3. -/
theorem pow_mod_three_of_inert (p k : ℕ) (hmod : p % 3 = 2) (hk : Odd k) :
    (p ^ k) % 3 = 2 := by
  obtain ⟨j, rfl⟩ := hk
  rw [Nat.pow_mod]; simp [hmod]
  induction j with
  | zero => norm_num
  | succ j ih =>
    rw [show 2 * (j + 1) + 1 = (2 * j + 1) + 2 from by ring, pow_add]
    simp [Nat.mul_mod, ih]

/-
If no element has a given norm, then iCount is 0.
-/
theorem iCount_zero_of_no_norm (n : ℕ) (h : ∀ z : Eisenstein, Eisenstein.norm z ≠ (n : ℤ)) :
    iCount n = 0 := by
  -- If no element has norm n, then no ideal has absNorm n (since in a PID every ideal is principal, I = span{z}, and absNorm(span{z}) = (norm z).natAbs).
  have h_no_ideal : ∀ I : Ideal Eisenstein, I.absNorm = n → False := by
    intro I hI
    obtain ⟨z, hz⟩ : ∃ z : Eisenstein, I = Ideal.span {z} := by
      exact?;
    grind +suggestions;
  unfold iCount; aesop;

/-
iCount = 1 when there is a unique ideal of given absNorm.
-/
theorem iCount_eq_one_of_unique_ideal (n : ℕ) (I₀ : Ideal Eisenstein)
    (hI₀ : Ideal.absNorm I₀ = n)
    (huniq : ∀ I : Ideal Eisenstein, Ideal.absNorm I = n → I = I₀) :
    iCount n = 1 := by
  exact Finset.card_eq_one.mpr ⟨ I₀, by aesop ⟩

/-- The "M-side" predicate: a prime ideal P is M-side iff its absNorm shares a factor with m. -/
def mPred (m : ℕ) (P : Ideal Eisenstein) : Prop := ¬ Nat.Coprime (Ideal.absNorm P) m

/-- The M-side part of an ideal: product of normalizedFactors whose absNorm is not coprime to m. -/
def idealMPart (m : ℕ) (I : Ideal Eisenstein) : Ideal Eisenstein :=
  ((UniqueFactorizationMonoid.normalizedFactors I).filter (mPred m)).prod

/-- The N-side part: product of normalizedFactors whose absNorm IS coprime to m. -/
def idealNPart (m : ℕ) (I : Ideal Eisenstein) : Ideal Eisenstein :=
  ((UniqueFactorizationMonoid.normalizedFactors I).filter (fun P => ¬ mPred m P)).prod

/-
Reconstruction: the M-part times the N-part equals the original ideal (when nonzero).
-/
theorem idealMPart_mul_idealNPart_eq (m : ℕ) (I : Ideal Eisenstein) (hI : I ≠ ⊥) :
    idealMPart m I * idealNPart m I = I := by
      unfold idealMPart idealNPart;
      rw [ ← Multiset.prod_add, Multiset.filter_add_not ];
      exact?

/-- absNorm of span{q} = q² in Eisenstein. -/
theorem absNorm_span_nat (q : ℕ) :
    Ideal.absNorm (Ideal.span {(q : Eisenstein)} : Ideal Eisenstein) = q ^ 2 := by
  rw [absNorm_span_singleton, show (q : Eisenstein) = ⟨(q : ℤ), 0⟩ from intCast_eq q]
  simp [Eisenstein.norm, Int.natAbs_pow, Int.natAbs_natCast]

/-
A nonzero prime ideal in Eisenstein contains some prime natural number.
-/
theorem prime_ideal_contains_prime (P : Ideal Eisenstein) (hP : P.IsPrime) (hP_ne : P ≠ ⊥) :
    ∃ q : ℕ, Nat.Prime q ∧ (q : Eisenstein) ∈ P := by
      obtain ⟨q, hq⟩ : ∃ q : ℕ, q ≠ 0 ∧ (q : Eisenstein) ∈ P := by
        -- Since P is a nonzero prime ideal � in� the Eisenstein integers, P is a nonzero prime ideal of ℤ.
        have h_inter_nonzero : (P.comap (algebraMap ℤ Eisenstein)) ≠ ⊥ := by
          exact?;
        contrapose! h_inter_nonzero;
        ext x; simp [h_inter_nonzero];
        exact ⟨ fun hx => by_contra fun hx' => h_inter_nonzero ( Int.natAbs x ) ( by positivity ) <| by simpa [ abs_of_nonneg ( show 0 ≤ x from le_of_not_gt fun hx'' => h_inter_nonzero ( Int.natAbs x ) ( by positivity ) <| by simpa [ abs_of_neg hx'' ] using P.neg_mem hx ) ] using hx, fun hx => hx.symm ▸ P.zero_mem ⟩;
      have h_prime_div : ∀ {n : ℕ}, n ≠ 0 → (n : Eisenstein) ∈ P → ∃ p : ℕ, Nat.Prime p ∧ (p : Eisenstein) ∈ P := by
        intros n hn hnP
        induction' n using Nat.strong_induction_on with n ih;
        by_cases h_one : n = 1;
        · exact False.elim <| hP.ne_top <| P.eq_top_of_isUnit_mem hnP <| by aesop;
        · obtain ⟨ p, hp₁, hp₂ ⟩ := Nat.exists_prime_and_dvd h_one;
          obtain ⟨ k, rfl ⟩ := hp₂;
          simp_all +decide [ mul_comm, Ideal.mem_span_singleton ];
          cases hP.mem_or_mem hnP <;> [ exact ⟨ p, hp₁, by assumption ⟩ ; exact ih k ( by nlinarith [ hp₁.two_le, Nat.pos_of_ne_zero hn.2 ] ) hn.2 ( by assumption ) ];
      exact h_prime_div hq.1 hq.2

/-
absNorm of a nonzero prime ideal in Eisenstein divides q² for the prime q below it.
-/
theorem absNorm_prime_ideal_dvd_sq (P : Ideal Eisenstein) (hP : P.IsPrime) (hP_ne : P ≠ ⊥)
    (q : ℕ) (hq : Nat.Prime q) (hq_mem : (q : Eisenstein) ∈ P) :
    Ideal.absNorm P ∣ q ^ 2 := by
      convert Ideal.absNorm_dvd_absNorm_of_le ( show Ideal.span { ( q : Eisenstein ) } ≤ P from Ideal.span_le.mpr <| Set.singleton_subset_iff.mpr hq_mem ) using 1;
      exact?

/-
Every prime dividing absNorm of the M-part also divides m.
-/
theorem prime_dvd_absNorm_idealMPart_dvd_m (m : ℕ) (I : Ideal Eisenstein)
    (p : ℕ) (hp : Nat.Prime p) (hdvd : p ∣ Ideal.absNorm (idealMPart m I)) :
    p ∣ m := by
      -- Since $p$ divides the product of the norms of the prime ideals in the M-part of $I$, it must divide at least one of those norms.
      obtain ⟨P, hP⟩ : ∃ P ∈ (UniqueFactorizationMonoid.normalizedFactors I).filter (mPred m), p ∣ Ideal.absNorm P := by
        contrapose! hdvd;
        have h_prod_norm : Ideal.absNorm (idealMPart m I) = Multiset.prod (Multiset.map (fun P => Ideal.absNorm P) (Multiset.filter (mPred m) (UniqueFactorizationMonoid.normalizedFactors I))) := by
          have h_prod_norm : ∀ (s : Multiset (Ideal Eisenstein)), Ideal.absNorm (Multiset.prod s) = Multiset.prod (Multiset.map (fun P => Ideal.absNorm P) s) := by
            intro s; induction s using Multiset.induction <;> simp_all +decide ;
          exact h_prod_norm _;
        simp_all +decide [ Nat.Prime.dvd_iff_not_coprime hp, Nat.coprime_multiset_prod_right_iff ];
      -- Since $P$ is a prime ideal, by `prime_ideal_contains_prime`, $P$ contains some prime number $q$.
      obtain ⟨q, hq_prime, hq_mem⟩ : ∃ q : ℕ, Nat.Prime q ∧ (q : Eisenstein) ∈ P := by
        have hP_prime : P.IsPrime := by
          have := UniqueFactorizationMonoid.prime_of_normalized_factor P ( Multiset.mem_of_mem_filter hP.1 ) ; simp_all +decide [ Ideal.isPrime_iff ] ;
          simp_all +decide [ Prime, Ideal.isPrime_iff ];
          intro x y hxy; specialize this; have := this.2.2 ( Ideal.span { x } ) ( Ideal.span { y } ) ; simp_all +decide [ Ideal.dvd_iff_le ] ;
          exact this.2.2 ( Ideal.span { x } ) ( Ideal.span { y } ) ( by rw [ Ideal.span_singleton_mul_span_singleton ] ; exact Ideal.span_le.mpr ( Set.singleton_subset_iff.mpr hxy ) ) |> Or.imp ( fun h => h <| Ideal.mem_span_singleton_self x ) fun h => h <| Ideal.mem_span_singleton_self y;
        have hP_ne_zero : P ≠ ⊥ := by
          intro h; simp_all +decide [ mPred ] ;
          have := UniqueFactorizationMonoid.prime_of_normalized_factor _ hP.1; simp_all +decide [ Ideal.isPrime_iff ] ;
          exact this.ne_zero rfl
        exact prime_ideal_contains_prime P hP_prime hP_ne_zero;
      -- Since $P$ is a � prime� ideal, its norm divides $q^2$.
      have hP_div_q2 : Ideal.absNorm P ∣ q ^ 2 := by
        apply absNorm_prime_ideal_dvd_sq P (by
        have := UniqueFactorizationMonoid.prime_of_normalized_factor P ( Multiset.mem_of_mem_filter hP.1 ) ; exact?;) (by
        rintro rfl; simp_all +decide [ mPred ]) q hq_prime hq_mem;
      -- Since $p$ divides $q^2$ and $p$ is prime, we have $p = q$.
      have hp_eq_q : p = q := by
        exact ( Nat.prime_dvd_prime_iff_eq hp hq_prime ) |>.1 ( hp.dvd_of_dvd_pow <| dvd_trans hP.2 hP_div_q2 );
      simp_all +decide [ mPred ];
      exact hq_prime.dvd_iff_not_coprime.mpr fun h => hP.1.2 <| Nat.Coprime.coprime_dvd_left hP_div_q2 <| by simp +decide [ hq_prime.coprime_iff_not_dvd ] at h ⊢; aesop;

/-
absNorm of N-part is coprime to m.
-/
theorem absNorm_idealNPart_coprime (m : ℕ) (I : Ideal Eisenstein) :
    Nat.Coprime (Ideal.absNorm (idealNPart m I)) m := by
      -- Each prime factor of the N-part is coprime to m.
      have h_coprime : ∀ P ∈ (UniqueFactorizationMonoid.normalizedFactors I).filter (fun P => ¬ mPred m P), Nat.Coprime (Ideal.absNorm P) m := by
        unfold mPred; aesop;
      -- The product of ideals with coprime norms has a coprime norm.
      have h_prod_coprime : ∀ {S : Multiset (Ideal Eisenstein)}, (∀ P ∈ S, Nat.Coprime (Ideal.absNorm P) m) → Nat.Coprime (Ideal.absNorm (Multiset.prod S)) m := by
        intros S hS; induction S using Multiset.induction <;> simp_all +decide [ Nat.coprime_mul_iff_left, Nat.coprime_mul_iff_right ] ;
        aesop;
      exact h_prod_coprime h_coprime

/-
For I with absNorm = m*n and gcd(m,n) = 1: absNorm(M-part) = m and absNorm(N-part) = n.
-/
theorem absNorm_parts_of_coprime (m n : ℕ) (I : Ideal Eisenstein)
    (hm : 0 < m) (hn : 0 < n) (hcop : Nat.Coprime m n)
    (hI : Ideal.absNorm I = m * n) :
    Ideal.absNorm (idealMPart m I) = m ∧ Ideal.absNorm (idealNPart m I) = n := by
      by_cases hI' : I = 0 <;> simp_all +decide [ Nat.Coprime, Nat.gcd_mul_left, Nat.gcd_mul_right ];
      · grind;
      · -- By definition of idealMPart and idealNPart, we know that their absolute norms multiply to m * n.
        have h_absNorm_mul : Ideal.absNorm (idealMPart m I) * Ideal.absNorm (idealNPart m I) = m * n := by
          rw [ ← hI, ← map_mul ];
          rw [ idealMPart_mul_idealNPart_eq m I hI' ];
        -- Since $m$ and $n$ are coprime, and the � product� of the absolute norms is $m * n$, each absolute norm must be a divisor of $m$ or � $�n$.
        have h_absNorm_div : Ideal.absNorm (idealMPart m I) ∣ m ∧ Ideal.absNorm (idealNPart m I) ∣ n := by
          apply And.intro;
          · refine' Nat.Coprime.dvd_of_dvd_mul_right _ ( h_absNorm_mul ▸ dvd_mul_right _ _ );
            refine' Nat.coprime_of_dvd' _;
            intro k hk hk₁ hk₂; have := prime_dvd_absNorm_idealMPart_dvd_m m I k hk hk₁; have := Nat.dvd_gcd this hk₂; aesop;
          · refine' Nat.Coprime.dvd_of_dvd_mul_left _ ( h_absNorm_mul ▸ dvd_mul_left _ _ );
            exact?;
        exact ⟨ Nat.dvd_antisymm h_absNorm_div.1 ( Nat.dvd_of_mul_dvd_mul_right hn <| h_absNorm_mul ▸ Nat.mul_dvd_mul_left _ h_absNorm_div.2 ), Nat.dvd_antisymm h_absNorm_div.2 ( Nat.dvd_of_mul_dvd_mul_left hm <| h_absNorm_mul ▸ Nat.mul_dvd_mul_right h_absNorm_div.1 _ ) ⟩

/-
normalizedFactors of J*K = normalizedFactors J + normalizedFactors K.
-/
theorem normalizedFactors_mul_ideal (J K : Ideal Eisenstein) (hJ : J ≠ ⊥) (hK : K ≠ ⊥) :
    UniqueFactorizationMonoid.normalizedFactors (J * K) =
    UniqueFactorizationMonoid.normalizedFactors J + UniqueFactorizationMonoid.normalizedFactors K := by
      rw [ ← UniqueFactorizationMonoid.normalizedFactors_mul ] ; aesop;
      exact hK

/-
For J with absNorm m and K with absNorm n (coprime): the round-trip recovers J and K.
-/
theorem idealParts_of_mul (m n : ℕ) (J K : Ideal Eisenstein)
    (hm : 1 < m) (hn : 1 < n) (hcop : Nat.Coprime m n)
    (hJ : Ideal.absNorm J = m) (hK : Ideal.absNorm K = n) :
    idealMPart m (J * K) = J ∧ idealNPart m (J * K) = K := by
      -- By definition of idealMPart and idealNPart, we know that
      have h_parts : idealMPart m (J * K) = J ∧ idealNPart m (J * K) = K := by
        have h_filter_m : (UniqueFactorizationMonoid.normalizedFactors J).filter (mPred m) = UniqueFactorizationMonoid.normalizedFactors J := by
          simp [mPred];
          intro P hP
          have h_div : Ideal.absNorm P ∣ m := by
            grind +suggestions;
          intro h; have := Nat.dvd_gcd ( dvd_refl ( Ideal.absNorm P ) ) h_div; simp_all +decide ;
          exact absurd ( UniqueFactorizationMonoid.irreducible_of_normalized_factor _ hP ) ( by simp +decide [ irreducible_iff ] )
        have h_filter_not_m : (UniqueFactorizationMonoid.normalizedFactors K).filter (fun P => ¬ mPred m P) = UniqueFactorizationMonoid.normalizedFactors K := by
          simp [mPred];
          intro P hP
          have h_div : Ideal.absNorm P ∣ n := by
            rw [ ← hK ];
            exact Ideal.absNorm_dvd_absNorm_of_le ( Ideal.dvd_iff_le.mp ( UniqueFactorizationMonoid.dvd_of_mem_normalizedFactors hP ) )
          generalize_proofs at *;
          exact Nat.Coprime.coprime_dvd_left h_div hcop.symm
        have h_parts : idealMPart m (J * K) = J ∧ idealNPart m (J * K) = K := by
          have h_prod : UniqueFactorizationMonoid.normalizedFactors (J * K) = UniqueFactorizationMonoid.normalizedFactors J + UniqueFactorizationMonoid.normalizedFactors K := by
            apply normalizedFactors_mul_ideal; all_goals aesop
          unfold idealMPart idealNPart; simp_all +decide [ Multiset.filter_add ] ;
          grind +suggestions;
        exact h_parts;
      exact h_parts

theorem iCount_multiplicative (m n : ℕ) (hm : 1 < m) (hn : 1 < n)
    (hcop : Nat.Coprime m n) :
    iCount (m * n) = iCount m * iCount n := by
  -- Set up the three Finsets
  set S_m := (Ideal.finite_setOf_absNorm_eq (S := Eisenstein) m).toFinset
  set S_n := (Ideal.finite_setOf_absNorm_eq (S := Eisenstein) n).toFinset
  set S_mn := (Ideal.finite_setOf_absNorm_eq (S := Eisenstein) (m * n)).toFinset
  have hmem : ∀ {k} (I : Ideal Eisenstein),
      I ∈ (Ideal.finite_setOf_absNorm_eq (S := Eisenstein) k).toFinset ↔ Ideal.absNorm I = k :=
    fun I => by simp [Set.Finite.mem_toFinset]
  -- Forward map is well-defined
  have hfwd : ∀ J ∈ S_m, ∀ K ∈ S_n, J * K ∈ S_mn := by
    intro J hJ K hK; rw [hmem]; rw [map_mul Ideal.absNorm, (hmem J).mp hJ, (hmem K).mp hK]
  -- Backward map
  have hbwd_m : ∀ I ∈ S_mn, idealMPart m I ∈ S_m := by
    intro I hI; rw [hmem]; exact (absNorm_parts_of_coprime m n I (by omega) (by omega) hcop ((hmem I).mp hI)).1
  have hbwd_n : ∀ I ∈ S_mn, idealNPart m I ∈ S_n := by
    intro I hI; rw [hmem]; exact (absNorm_parts_of_coprime m n I (by omega) (by omega) hcop ((hmem I).mp hI)).2
  -- Round-trips
  have hrt1 : ∀ I ∈ S_mn, idealMPart m I * idealNPart m I = I := by
    intro I hI
    apply idealMPart_mul_idealNPart_eq
    intro h; have habs : Ideal.absNorm I = m * n := (hmem I).mp hI
    rw [h, Ideal.absNorm_bot] at habs; exact absurd habs (by positivity)
  have hrt2 : ∀ J ∈ S_m, ∀ K ∈ S_n,
      idealMPart m (J * K) = J ∧ idealNPart m (J * K) = K := by
    intro J hJ K hK
    exact idealParts_of_mul m n J K hm hn hcop ((hmem J).mp hJ) ((hmem K).mp hK)
  -- Apply card_bij'
  show S_mn.card = S_m.card * S_n.card
  rw [← Finset.card_product]
  symm
  apply Finset.card_bij' (fun p _ => p.1 * p.2) (fun I _ => (idealMPart m I, idealNPart m I))
  · intro ⟨J, K⟩ h; exact hfwd J (Finset.mem_product.mp h).1 K (Finset.mem_product.mp h).2
  · intro I hI; exact Finset.mem_product.mpr ⟨hbwd_m I hI, hbwd_n I hI⟩
  · intro ⟨J, K⟩ h
    obtain ⟨h1, h2⟩ := hrt2 J (Finset.mem_product.mp h).1 K (Finset.mem_product.mp h).2
    exact Prod.ext h1 h2
  · intro I hI; exact hrt1 I hI

/-
θ divides z whenever 3 divides norm z.
-/
theorem theta_dvd_of_three_dvd_norm (z : Eisenstein) (h : (3 : ℤ) ∣ Eisenstein.norm z) :
    ∃ w : Eisenstein, z = θ * w := by
  -- Since $3 \mid � z�.norm$, we have that $z.a + z.b \equiv 0 \pmod{3}$.
  have h_mod : (z.a + z.b) % 3 = 0 := by
    unfold Eisenstein.norm at h;
    rw [ Int.dvd_iff_emod_eq_zero ] at *; norm_num [ Int.add_emod, Int.sub_emod, Int.mul_emod, sq ] at *; have := Int.emod_nonneg z.a three_pos.ne'; have := Int.emod_nonneg z.b three_pos.ne'; have := Int.emod_lt_of_pos z.a three_pos; have := Int.emod_lt_of_pos z.b three_pos; interval_cases z.a % 3 <;> interval_cases z.b % 3 <;> trivial;
  -- Let $w = \frac{2z.a - z.b}{3} + \frac{z.a + z.b}{3} \theta$.
  use ⟨(2 * z.a - z.b) / 3, (z.a + z.b) / 3⟩;
  ext <;> norm_num [ ]; all_goals omega

/-
Every element of norm 3^k is an associate of θ^k.
-/
theorem norm_three_pow_associate (k : ℕ) (z : Eisenstein) (hz : Eisenstein.norm z = (3 : ℤ) ^ k) :
    Associated z (θ ^ k) := by
  induction' k with k ih generalizing z;
  · simp +zetaDelta at *;
    exact?;
  · -- If norm z = 3^( �k�+1), then 3 | norm � z�, so by theta_dvd_of_three_dvd_norm, z = θ * w for some w.
    obtain ⟨w, hw⟩ : ∃ w : Eisenstein, z = θ * w := by
      apply theta_dvd_of_three_dvd_norm;
      grind;
    rw [ hw, pow_succ' ];
    -- By the induction hypothesis, since norm w = 3^k, we have that w is associated to θ^k.
    have h_ind : Associated w (θ ^ k) := by
      grind +suggestions;
    exact?

/-
The Eisenstein integer ⟨p, 0⟩ is irreducible when p is an inert prime (p ≡ 2 mod 3).
-/
theorem irreducible_int_of_inert (p : ℕ) (hp : Nat.Prime p) (hmod : p % 3 = 2) :
    Irreducible (⟨(p : ℤ), 0⟩ : Eisenstein) := by
  constructor;
  · rw [ isUnit_iff_exists_inv ];
    rintro ⟨ b, hb ⟩ ; have := congr_arg ( fun z : Eisenstein => z.a ) hb ; norm_num at this ; have := congr_arg ( fun z : Eisenstein => z.b ) hb ; norm_num at this ; nlinarith [ hp.two_le, show b.a = 0 by nlinarith [ hp.two_le ] ] ;
  · intro a b hab
    have h_norm : norm a * norm b = p ^ 2 := by
      convert congr_arg Eisenstein.norm hab.symm using 1 ; norm_num [ Eisenstein.norm ] ; ring
    have h_cases : norm a = 1 ∨ norm b = 1 := by
      -- Since $p$ is prime �,� the only divisors of $p^ �2�$ are $1$, $p$, and $p^2$.
      have h_divisors : ∀ {d : ℤ}, d ∣ p^2 → d = 1 ∨ d = -1 ∨ d = p ∨ d = -p ∨ d = p^2 ∨ d = -p^2 := by
        intro d hd; have := Int.natAbs_dvd_natAbs.mpr hd; simp_all +decide [ Int.natAbs_pow, Nat.dvd_prime_pow ] ;
        rcases this with ⟨ k, hk₁, hk₂ ⟩ ; interval_cases k <;> simp_all +decide [ Int.natAbs_eq_iff ] ;
        · tauto;
        · grind;
      obtain ha | ha | ha | ha | ha | ha := @h_divisors _ ( dvd_of_mul_right_eq _ h_norm ) <;> obtain hb | hb | hb | hb | hb | hb := @h_divisors _ ( dvd_of_mul_left_eq _ h_norm ) <;> simp_all +decide only ;
      any_goals nlinarith [ hp.two_le, pow_pos hp.pos 3 ];
      grind +splitImp;
      · exact absurd ha ( by linarith [ Eisenstein.norm_nonneg a ] );
      · exact absurd ( no_norm_two_mod_three p hmod a ) ( by aesop );
      · linarith [ hp.two_le, Eisenstein.norm_nonneg a, Eisenstein.norm_nonneg b ];
      · grind +suggestions;
      · exact absurd ha ( by nlinarith [ hp.two_le, show 0 ≤ a.norm from Eisenstein.norm_nonneg a ] )
    have h_unit : IsUnit a ∨ IsUnit b := by
      exact Or.imp ( fun h => Eisenstein.isUnit_of_norm_one a h ) ( fun h => Eisenstein.isUnit_of_norm_one b h ) h_cases
    exact h_unit

/-
Every element of norm p^(2j) (p inert) is an associate of ⟨p^j, 0⟩.
-/
theorem norm_inert_pow_associate (p j : ℕ) (hp : Nat.Prime p) (hmod : p % 3 = 2)
    (z : Eisenstein) (hz : Eisenstein.norm z = ((p : ℤ) ^ j) ^ 2) :
    Associated z ⟨(p : ℤ) ^ j, 0⟩ := by
  revert z;
  -- By definition of irreducibility, if p divides z, then z is an associate of p.
  have h_irred_div : ∀ z : Eisenstein, (p : ℤ) ∣ Eisenstein.norm z → (⟨p, 0⟩ : Eisenstein) ∣ z := by
    intro z hz
    have h_div : (⟨p, 0⟩ : Eisenstein) ∣ z * Eisenstein.conj z := by
      obtain ⟨ k, hk ⟩ := hz;
      use ⟨k, 0⟩;
      ext <;> simp +decide [ *, mul_comm ];
      · convert hk using 1 ; ring!;
        · exact Eq.symm ( by unfold Eisenstein.norm; ring );
        · ring;
      · ring;
    have h_irred : Irreducible (⟨p, 0⟩ : Eisenstein) := by
      convert irreducible_int_of_inert p hp hmod using 1;
    have h_prime : Prime (⟨p, 0⟩ : Eisenstein) := by
      rwa [ ← UniqueFactorizationMonoid.irreducible_iff_prime ];
    have h_div_z : (⟨p, 0⟩ : Eisenstein) ∣ z ∨ (⟨p, 0⟩ : Eisenstein) ∣ Eisenstein.conj z := by
      exact h_prime.dvd_or_dvd h_div;
    have h_div_conj : ∀ z : Eisenstein, (⟨p, 0⟩ : Eisenstein) ∣ Eisenstein.conj z → (⟨p, 0⟩ : Eisenstein) ∣ z := by
      intros z h_div_conj
      obtain ⟨w, hw⟩ := h_div_conj
      use Eisenstein.conj w;
      convert congr_arg Eisenstein.conj hw using 1 <;> simp +decide [ Eisenstein.conj ];
      ext <;> simp +decide [ mul_sub ];
    exact h_div_z.elim id fun h => h_div_conj z h;
  intro z hz
  induction' j with j ih generalizing z;
  · have h_unit : IsUnit z := by
      exact Eisenstein.isUnit_of_norm_one z hz;
    obtain ⟨ u, hu ⟩ := h_unit.exists_left_inv;
    use Units.mkOfMulEqOne u z hu;
    convert mul_comm z u using 1;
    exact hu.symm;
  · -- By definition of irreducibility, if � p� divides z, then z is an associate of p. Hence, we can write z as p times some element w.
    obtain ⟨w, hw⟩ : ∃ w : Eisenstein, z = ⟨p, 0⟩ * w := by
      exact h_irred_div z ( hz.symm ▸ dvd_pow ( dvd_pow_self _ ( Nat.succ_ne_zero _ ) ) two_ne_zero );
    have hw_norm : w.norm = (p ^ j) ^ 2 := by
      have := Eisenstein.norm_mul ⟨ p, 0 ⟩ w; simp_all +decide [ pow_succ, mul_assoc ] ;
      simp_all +decide [ Eisenstein.norm ];
      exact mul_left_cancel₀ ( pow_ne_zero 2 ( Nat.cast_ne_zero.mpr hp.ne_zero ) ) ( by linarith );
    obtain ⟨ u, hu ⟩ := ih w hw_norm;
    use u;
    simp_all +decide [ pow_succ', mul_assoc ];
    ext <;> simp +decide [ mul_assoc, pow_succ' ]

/-
An Eisenstein integer with prime norm is irreducible.
-/
theorem irreducible_of_norm_prime (z : Eisenstein) (p : ℕ) (hp : Nat.Prime p)
    (hz : norm z = (p : ℤ)) : Irreducible z := by
      constructor;
      · intro h
        have h_norm : z.norm = 1 := by
          exact?;
        linarith [ hp.two_le ];
      · intro a b hab;
        -- Since $p$ is prime, either $\|a\| = 1$ or $\|b\| = 1$.
        have h_norm_one : norm a = 1 ∨ norm b = 1 := by
          have h_norm_one : norm a * norm b = p := by
            rw [ ← hz, hab, Eisenstein.norm_mul ];
          have h_norm_pos : 0 ≤ a.norm ∧ 0 ≤ b.norm := by
            exact ⟨ Eisenstein.norm_nonneg a, Eisenstein.norm_nonneg b ⟩;
          have h_norm_one : Int.natAbs a.norm * Int.natAbs b.norm = p := by
            rw [ ← Int.natAbs_mul, h_norm_one, Int.natAbs_natCast ];
          cases hp.isUnit_or_isUnit h_norm_one.symm <;> simp_all +decide [ Int.natAbs_eq_iff ]; all_goals grind;
        exact Or.imp ( fun h => Eisenstein.isUnit_of_norm_one a h ) ( fun h => Eisenstein.isUnit_of_norm_one b h ) h_norm_one

/-
For a split prime p ≡ 1 (mod 3), π and conj(π) are NOT associated.
    Proved by case analysis on the 6 units.
-/
theorem not_associated_conj_of_split (π : Eisenstein) (p : ℕ) (hp : Nat.Prime p)
    (hmod : p % 3 = 1) (hπ : norm π = (p : ℤ)) :
    ¬ Associated π (conj π) := by
      by_contra h_assoc;
      -- Let's obtain the unit u � such� that π = u * π.conj.
      obtain ⟨u, hu⟩ : ∃ u : Eisenstein, IsUnit u ∧ π = u * π.conj := by
        cases' h_assoc with u hu;
        exact ⟨ ↑u⁻¹, by simp, by rw [ ← hu, mul_comm ] ; simp +decide ⟩;
      obtain ⟨hu_unit, hu_eq⟩ := hu;
      -- Since u is a unit, we have u = � ±�1, ±ω �,� or ±ω².
      have hu_cases : u = 1 ∨ u = -1 ∨ u = ⟨0, 1⟩ ∨ u = ⟨0, -1⟩ ∨ u = ⟨-1, -1⟩ ∨ u = ⟨1, 1⟩ := by
        have hu_cases : u ∈ EisensteinUnits.unitSet := by
          grind +suggestions;
        fin_cases hu_cases <;> tauto;
      -- Let's consider each case where u is one of the units.
      cases' hu_cases with hu1 hu_neg1 hu_ω hu_neg_ω hu_ω_sq hu_neg_ω_sq;
      · -- If $u = 1$, then $\pi = \pi.conj$, which implies $\pi.b = 0$.
        have h_pi_b_zero : π.b = 0 := by
          replace hu_eq := congr_arg ( fun z => z.b ) hu_eq ; simp +decide [ hu1 ] at hu_eq ; linarith;
        -- If π.b = 0, then π = ⟨π.a, 0⟩, and thus π.norm = π.a^2.
        have h_pi_norm : π.norm = π.a^2 := by
          unfold Eisenstein.norm; simp +decide [ h_pi_b_zero ] ;
        exact absurd hp ( by rw [ show p = π.a.natAbs ^ 2 by linarith [ abs_mul_abs_self π.a ] ] ; exact not_irreducible_pow <| by decide );
      · rcases hu_neg1 with ( rfl | rfl | rfl | rfl | rfl );
        · rw [ eq_comm ] at hu_eq;
          replace hu_eq := congr_arg ( fun z => z.a ) hu_eq ; simp_all +decide [ neg_eq_iff_add_eq_zero ];
          unfold Eisenstein.norm at hπ; simp_all +decide [ sub_eq_iff_eq_add ] ;
          ring_nf at hπ; have := congr_arg ( · % 3 ) hπ; norm_num [ Int.add_emod, Int.sub_emod, Int.mul_emod, sq ] at this; norm_cast at this; have := Nat.mod_lt p zero_lt_three; interval_cases p % 3 <;> simp_all +decide ;
        · rw [ eq_comm ] at hu_eq;
          replace hu_eq := congr_arg Eisenstein.a hu_eq ; simp_all +decide;
          simp_all +decide [ Eisenstein.norm ];
          exact absurd hp ( by rw [ show p = ( Int.natAbs π.a ) ^ 2 by linarith [ abs_mul_abs_self π.a ] ] ; exact not_irreducible_pow <| by decide );
        · norm_num [ Eisenstein.norm ] at hπ;
          replace hu_eq := congr_arg ( fun z => z.a ) hu_eq ; simp +decide at hu_eq;
          norm_num [ hu_eq ] at hπ;
          grind +splitImp;
        · rcases π with ⟨ a, b ⟩;
          injection hu_eq with hu_eq ; norm_num at hu_eq;
          norm_num [ show a = 0 by linarith ] at *;
          norm_num [ Eisenstein.norm ] at hπ;
          exact hp.not_isSquare <| ⟨ b.natAbs, by linarith [ abs_mul_abs_self b ] ⟩;
        · rcases π with ⟨ a, b ⟩;
          erw [ show ( { a := 1, b := 1 } : Eisenstein ) * ( { a := a, b := b } |> Eisenstein.conj ) = ⟨ 1 * ( a - b ) - 1 * ( -b ), 1 * ( -b ) + 1 * ( a - b ) - 1 * ( -b ) ⟩ by rfl ] at hu_eq ; norm_num [ Eisenstein.ext_iff ] at hu_eq;
          norm_num [ show b = a / 2 by omega ] at *;
          rcases Int.even_or_odd' a with ⟨ k, rfl | rfl ⟩ <;> ring_nf at * <;> norm_num at *;
          · norm_num [ Eisenstein.norm ] at hπ;
            grind;
          · grind

/-
Every irreducible of norm p is associated to π or conj(π).
-/
theorem irreducible_norm_p_dichotomy (π z : Eisenstein) (p : ℕ) (hp : Nat.Prime p)
    (hπ : norm π = (p : ℤ)) (hz : norm z = (p : ℤ)) (hirr : Irreducible z) :
    Associated z π ∨ Associated z (conj π) := by
      -- Since $z$ is irreducible, it is prime.
      have hprime : Prime z := by
        rwa [ ← UniqueFactorizationMonoid.irreducible_iff_prime ];
      -- Since $z$ is � prime�, it � divides� $\pi � *� \overline{\pi}$.
      have hdiv : z ∣ π * Eisenstein.conj π := by
        convert hprime.dvd_mul.mp _;
        any_goals tauto;
        simp_all +decide [ mul_assoc, mul_comm, mul_left_comm, Eisenstein.conj_mul_self ];
        simp_all +decide [ ← mul_assoc, ← pow_two, Eisenstein.norm_conj ];
        rw [ ← mul_pow, mul_comm ];
        rw [ Eisenstein.conj_mul_self ];
        rw [ hπ ];
        rw [ ← hz ];
        rw [ ← Eisenstein.conj_mul_self ];
        exact dvd_pow ( dvd_mul_left _ _ ) two_ne_zero;
      cases' hprime.dvd_or_dvd hdiv with h h;
      · cases' h with u hu;
        simp_all +decide [ Eisenstein.norm_mul ];
        by_cases hp : p = 0 <;> simp_all +decide;
        exact Or.inl <| associated_mul_unit_right _ _ <| isUnit_of_norm_one _ hπ;
      · right;
        refine' hirr.associated_of_dvd _ _;
        · grind +suggestions;
        · assumption

/-
The norm of an irreducible Eisenstein integer that divides an element of norm p^n
    must equal p (for a split prime p ≡ 1 mod 3).
-/
theorem norm_irred_factor_eq_prime (α : Eisenstein) (p : ℕ) (n : ℕ) (hp : Nat.Prime p)
    (hmod : p % 3 = 1) (hα : Irreducible α) (hdvd : (norm α).natAbs ∣ p ^ n) :
    norm α = (p : ℤ) := by
      -- Since p is prime and α is irreducible, its norm must be a power of p. Let �’s� write it as p^j for some j ≥ 1.
      obtain ⟨j, hj⟩ : ∃ j : ℕ, 1 ≤ j ∧ α.norm.natAbs = p ^ j := by
        have h_norm_ge_two : 2 ≤ α.norm.natAbs := by
          have h_norm_gt_one : 1 < α.norm := by
            by_contra h_contra
            have h_unit : IsUnit α := by
              exact Eisenstein.isUnit_of_norm_one α <| by linarith [ Eisenstein.norm_pos_of_ne_zero α hα.ne_zero ] ;
            exact hα.not_isUnit h_unit;
          grind;
        rw [ Nat.dvd_prime_pow hp ] at hdvd;
        exact hdvd.imp fun k hk => ⟨ Nat.pos_of_ne_zero fun h => by subst h; linarith, hk.2 ⟩;
      -- If j ≥ 2: since α is irreducible hence prime (in the Eisenstein UFD), and α * conj(α) = ⟨norm(α), 0⟩ = ⟨p^j, 0⟩, we can write ⟨p^j, 0⟩ = ⟨p, 0⟩ * ⟨p^(j-1), 0⟩. Since α is prime and α | ⟨p^j, 0⟩ = ⟨p, 0⟩ * ⟨p^(j-1), 0⟩, either α | ⟨p, 0⟩ or α | ⟨p^(j-1), 0⟩.
      by_cases h_cases : α ∣ ⟨p, 0⟩;
      · -- Since ⟨p, 0⟩ � =� π * conj(π) for some π, and α is irreducible, α must divide either π or conj(π).
        obtain ⟨π, hπ⟩ : ∃ π : Eisenstein, α ∣ π ∧ norm π = p := by
          obtain ⟨π, hπ⟩ : ∃ π : Eisenstein, norm π = p := by
            grind +suggestions;
          -- Since α divides ⟨ �p�, 0⟩ and ⟨p, 0⟩ = π * conj(π), α must divide either π or conj(π).
          have h_div : α ∣ π ∨ α ∣ conj π := by
            have h_div : α ∣ π * conj π := by
              have h_div : π * conj π = ⟨p, 0⟩ := by
                convert Eisenstein.conj_mul_self π using 1;
                · exact mul_comm _ _;
                · grind;
              aesop;
            have h_prime : Prime α := by
              rwa [ ← UniqueFactorizationMonoid.irreducible_iff_prime ];
            exact h_prime.dvd_or_dvd h_div;
          cases' h_div with h_div h_div;
          · use π;
          · use conj π;
            exact ⟨ h_div, by rw [ ← hπ, norm_conj ] ⟩;
        -- Since α is irreducible and divides π, and π is irreducible, α must be associated with π.
        have h_associated : Associated α π := by
          have h_associated : Irreducible π := by
            convert irreducible_of_norm_prime π p hp hπ.2 using 1;
          obtain ⟨ q, rfl ⟩ := hπ.1;
          rw [ irreducible_mul_iff ] at h_associated;
          exact h_associated.elim ( fun h => h.2.elim fun u hu => by aesop ) fun h => False.elim <| hα.not_isUnit h.2;
        -- Since α is associated with � π�, their norms are equal.
        have h_norm_eq : α.norm = π.norm := by
          obtain ⟨ u, hu ⟩ := h_associated;
          rw [ ← hu, Eisenstein.norm_mul ];
          have := u.isUnit.exists_left_inv; obtain ⟨ v, hv ⟩ := this; replace hv := congr_arg ( fun x : Eisenstein => x.norm ) hv; simp_all +decide [ Eisenstein.norm_mul ] ;
          cases' Int.eq_one_or_neg_one_of_mul_eq_one hv with h h <;> simp_all +decide [ Int.natAbs_eq_iff ];
          exact absurd h ( by linarith [ Eisenstein.norm_nonneg v ] );
        grobner;
      · -- If α | ⟨p �^(�j-1), 0⟩, we can repeat the argument (induction on j), eventually reaching α | ⟨p, 0⟩, same contradiction.
        have h_induction : ∀ k : ℕ, 2 ≤ k → k ≤ j → α ∣ ⟨p ^ k, 0⟩ → α ∣ ⟨p ^ (k - 1), 0⟩ := by
          intros k hk2 hkj hk_div
          have h_prime : Prime α := by
            rwa [ ← UniqueFactorizationMonoid.irreducible_iff_prime ];
          have h_div : α ∣ ⟨p, 0⟩ * ⟨p ^ (k - 1), 0⟩ := by
            convert hk_div using 1;
            rcases k with ( _ | _ | k ) <;> simp_all +decide [ pow_succ' ];
            ext <;> simp +decide [ mul_assoc ];
          exact Or.resolve_left ( h_prime.dvd_or_dvd h_div ) h_cases;
        -- By induction on $j$, we can show that if $\alpha \mid \langle p^j �,� 0 \rangle$, then $\alpha \mid \ �langle� p, 0 \rangle$.
        have h_induction_step : ∀ k : ℕ, 2 ≤ k → k ≤ j → α ∣ ⟨p ^ k, 0⟩ → α ∣ ⟨p, 0⟩ := by
          intro k hk₁ hk₂ hk; induction hk₁ <;> simp_all +decide ;
          · exact h_cases ( by simpa using h_induction 2 ( by decide ) hk₂ hk );
          · grind +ring;
        -- Since α is irreducible and divides ⟨p^j, 0⟩, we have α * conj(α) = ⟨p^j, 0⟩.
        have h_div : α * conj α = ⟨p ^ j, 0⟩ := by
          convert Eisenstein.conj_mul_self α using 1;
          · exact mul_comm _ _;
          · rw [ ← Int.natAbs_of_nonneg ( Eisenstein.norm_nonneg α ) ] ; aesop;
        rcases j with ( _ | _ | j ) <;> simp_all +decide;
        · linarith [ abs_of_nonneg ( Eisenstein.norm_nonneg α ) ];
        · exact False.elim <| h_induction_step ( j + 2 ) ( by linarith ) ( by linarith ) <| h_div ▸ dvd_mul_right _ _

/-
Every element of norm p^k (p split) is associated to π^j * conj(π)^(k-j) (natural number version).
-/
theorem norm_split_pow_classification' (π : Eisenstein) (p k : ℕ) (hp : Nat.Prime p)
    (hmod : p % 3 = 1) (hπ : norm π = (p : ℤ))
    (z : Eisenstein) (hz : norm z = (p : ℤ) ^ k) :
    ∃ j ≤ k, Associated z (π ^ j * conj π ^ (k - j)) := by
      induction' k with k ih generalizing z;
      · exact ⟨ 0, by norm_num, by simpa [ hz ] using Eisenstein.isUnit_of_norm_one z hz ⟩;
      · -- By WfDvdMonoid.exists_irreducible_factor, there exists an irreducible α dividing z.
        obtain ⟨α, w, hα, hw⟩ : ∃ α w : Eisenstein, Irreducible α ∧ z = α * w := by
          have h_nonzero : z ≠ 0 := by
            rintro rfl; norm_num at hz; linarith [ pow_pos hp.pos ( k + 1 ) ] ;
          have h_not_unit : ¬IsUnit z := by
            intro h_unit
            have h_norm_one : Eisenstein.norm z = 1 := by
              grind +suggestions;
            exact absurd h_norm_one ( by rw [ hz ] ; exact ne_of_gt ( one_lt_pow₀ ( mod_cast hp.one_lt ) ( Nat.succ_ne_zero _ ) ) );
          obtain ⟨ α, hα₁, hα₂ ⟩ := WfDvdMonoid.exists_irreducible_factor h_not_unit h_nonzero;
          exact ⟨ α, _, hα₁, hα₂.choose_spec ⟩;
        -- By the properties of norms, we have $norm(\alpha) * norm(w) = p^{k+1}$.
        have h_norm : norm α * norm w = p ^ (k + 1) := by
          rw [ ← hz, hw, Eisenstein.norm_mul ];
        -- Since $\alpha$ is irreducible and $norm(\alpha) \mid p^{k+1}$, we have $norm(\alpha) = p$.
        have h_norm_alpha : norm α = p := by
          apply norm_irred_factor_eq_prime α p (k + 1) hp hmod hα;
          simpa [ ← Int.natCast_dvd_natCast ] using dvd_of_mul_right_eq _ h_norm;
        -- By irreducible_norm_p_dichotomy, α is associated to π or conj(π).
        obtain (hα_assoc | hα_assoc) : Associated α π ∨ Associated α (conj π) := by
          apply_rules [ irreducible_norm_p_dichotomy ];
        · -- By the induction hypothesis, there � exists� $j \leq k$ such that $w$ is associated to $\pi^j \cdot \overline{\pi}^{k-j}$.
          obtain ⟨j, hj₁, hj₂⟩ : ∃ j ≤ k, Associated w (π ^ j * (conj π) ^ (k - j)) := by
            simp_all +decide [ pow_succ' ];
            exact ih w ( h_norm.resolve_right hp.ne_zero );
          refine' ⟨ j + 1, _, _ ⟩ <;> simp_all +decide [ pow_succ', mul_assoc ];
          exact Associated.mul_mul hα_assoc hj₂;
        · -- By the induction hypothesis, there exists $j � \�leq k$ such that $w$ is associated to $\pi^j \cdot \pi.conj^{k-j}$.
          obtain ⟨j, hj₁, hj₂⟩ : ∃ j ≤ k, Associated w (π ^ j * π.conj ^ (k - j)) := by
            apply ih w;
            exact mul_left_cancel₀ ( Nat.cast_ne_zero.mpr hp.ne_zero ) ( by rw [ h_norm_alpha ] at h_norm; linear_combination' h_norm );
          refine' ⟨ j, _, _ ⟩;
          · linarith;
          · rw [ hw, Nat.succ_sub hj₁ ];
            rw [ pow_succ' ];
            convert Associated.mul_mul hα_assoc hj₂ using 1 ; ring

/-- Every element of norm p^k (p split) is associated to π^j * conj(π)^(k-j). -/
theorem norm_split_pow_classification (π : Eisenstein) (p k : ℕ) (hp : Nat.Prime p)
    (hmod : p % 3 = 1) (hπ : norm π = (p : ℤ))
    (z : Eisenstein) (hz : norm z = (p : ℤ) ^ k) :
    ∃ j : Fin (k + 1), Associated z (π ^ (j : ℕ) * conj π ^ (k - (j : ℕ))) := by
  obtain ⟨j, hj, hassoc⟩ := norm_split_pow_classification' π p k hp hmod hπ z hz
  exact ⟨⟨j, by omega⟩, hassoc⟩

/-
The k+1 ideals ⟨π^j * conj(π)^(k-j)⟩ are all distinct.
-/
theorem split_ideals_distinct (π : Eisenstein) (p k : ℕ) (hp : Nat.Prime p)
    (hmod : p % 3 = 1) (hπ : norm π = (p : ℤ))
    (j₁ j₂ : Fin (k + 1))
    (heq : Ideal.span ({π ^ (j₁ : ℕ) * conj π ^ (k - (j₁ : ℕ))} : Set Eisenstein) =
           Ideal.span ({π ^ (j₂ : ℕ) * conj π ^ (k - (j₂ : ℕ))} : Set Eisenstein)) :
    j₁ = j₂ := by
      -- Since π is irreducible and not associated with its conjugate, the exponents of π and its conjugate must match on both sides.
      have h_exp : j₁.val = j₂.val := by
        have h_unique_factors : ∀ (j₁ j₂ : ℕ), j₁ ≤ k → j₂ ≤ k → Associated (π ^ j₁ * conj π ^ (k - j₁)) (π ^ j₂ * conj π ^ (k - j₂)) → j₁ = j₂ := by
          intros j₁ j₂ hj₁ hj₂ h_assoc
          have h_exp : j₁ = j₂ := by
            have h_prime : Prime π := by
              convert irreducible_of_norm_prime π p hp hπ using 1;
              exact funext fun x => by rw [ ← UniqueFactorizationMonoid.irreducible_iff_prime ] ;
            have h_conj_prime : Prime (conj π) := by
              rw [ ← UniqueFactorizationMonoid.irreducible_iff_prime ] at *;
              grind +suggestions
            have h_not_assoc : ¬ Associated π (conj π) := by
              apply not_associated_conj_of_split π p hp hmod hπ
            have := h_assoc.symm.dvd;
            have h_exp : j₂ ≤ j₁ := by
              have h_exp : π ^ j₂ ∣ π ^ j₁ := by
                refine' ( IsCoprime.dvd_of_dvd_mul_right _ <| dvd_of_mul_right_dvd this );
                refine' IsCoprime.pow _;
                exact h_prime.coprime_iff_not_dvd.mpr fun h => h_not_assoc <| h_prime.associated_of_dvd h_conj_prime h;
              contrapose! h_exp;
              rw [ pow_dvd_pow_iff ] <;> norm_num [ h_prime.ne_zero, h_exp ];
              exact h_prime.not_unit;
            have h_exp : j₁ ≤ j₂ := by
              have h_exp : π ^ j₁ ∣ π ^ j₂ * conj π ^ (k - j₂) := by
                have := h_assoc.dvd;
                exact dvd_of_mul_right_dvd this;
              have h_exp : π ^ j₁ ∣ π ^ j₂ := by
                refine' ( IsCoprime.pow _ ).dvd_of_dvd_mul_right h_exp;
                exact h_prime.coprime_iff_not_dvd.mpr fun h => h_not_assoc <| h_prime.associated_of_dvd h_conj_prime h;
              contrapose! h_exp;
              rw [ pow_dvd_pow_iff ] <;> norm_num [ h_prime.ne_zero, h_prime.ne_one, h_prime.not_unit, h_exp ];
            linarith
          exact h_exp;
        exact h_unique_factors _ _ ( Fin.is_le _ ) ( Fin.is_le _ ) ( by rwa [ Ideal.span_singleton_eq_span_singleton ] at heq );
      exact Fin.ext h_exp

theorem iCount_prime_pow_split (p k : ℕ) (hp : Nat.Prime p) (hmod : p % 3 = 1) :
    iCount (p ^ k) = k + 1 := by
  -- Get π with norm p from split_prime
  obtain ⟨π, hπ⟩ := split_prime p hp hmod
  -- The k+1 ideals: Ij = ⟨π^j * conj(π)^(k-j)⟩
  set f : Fin (k + 1) → Ideal Eisenstein :=
    fun j => Ideal.span {π ^ (j : ℕ) * conj π ^ (k - (j : ℕ))} with hf_def
  -- Show f is injective
  have hf_inj : Function.Injective f :=
    fun j₁ j₂ h => split_ideals_distinct π p k hp hmod hπ j₁ j₂ h
  -- Show each f j has absNorm p^k
  have norm_pow_eq : ∀ (z : Eisenstein) (n : ℕ), norm (z ^ n) = norm z ^ n := by
    intro z n; induction n with
    | zero => simp [Eisenstein.norm]
    | succ n ih => rw [pow_succ, Eisenstein.norm_mul, ih, pow_succ]
  have hf_norm : ∀ j : Fin (k + 1), Ideal.absNorm (f j) = p ^ k := by
    intro j
    simp only [hf_def, absNorm_span_singleton]
    rw [Eisenstein.norm_mul, norm_pow_eq, norm_pow_eq, hπ, norm_conj, hπ, ← pow_add,
        show (j : ℕ) + (k - (j : ℕ)) = k from by omega]
    simp [Int.natAbs_pow, Int.natAbs_natCast]
  -- Show every ideal of absNorm p^k is in the range of f
  have hf_surj : ∀ I : Ideal Eisenstein, Ideal.absNorm I = p ^ k → I ∈ Set.range f := by
    intro I hI
    obtain ⟨z, hz⟩ : ∃ z : Eisenstein, I = Ideal.span {z} :=
      ⟨_, Eq.symm <| Ideal.span_singleton_generator _⟩
    have hz_norm : norm z = (p : ℤ) ^ k := by
      have h1 : (norm z).natAbs = p ^ k := by rw [← hI, hz, absNorm_span_singleton]
      rw [← Int.natAbs_of_nonneg (norm_nonneg z), h1]; push_cast; simp
    obtain ⟨j, hj⟩ := norm_split_pow_classification π p k hp hmod hπ z hz_norm
    exact ⟨j, by rw [hz, hf_def, Ideal.span_singleton_eq_span_singleton]; exact hj.symm⟩
  -- Count: the set of ideals of absNorm p^k has cardinality k+1
  -- The image of f covers all ideals of absNorm p^k (by hf_surj), and f is injective (by hf_inj).
  -- Moreover each f j has absNorm p^k (by hf_norm). So the finset has cardinality k+1.
  -- Since $f$ is injective and every ideal of norm $p^k$ is in the range of $f$, the set of ideals of norm $p^k$ is exactly the image of $f$.
  have h_image : (Ideal.finite_setOf_absNorm_eq (S := Eisenstein) (p ^ k)).toFinset = Finset.image f Finset.univ := by
    ext; aesop;
  unfold iCount; simp_all +decide [ Finset.card_image_of_injective _ hf_inj ] ;
  rw [ Finset.card_image_of_injective _ hf_inj, Finset.card_fin ]

theorem iCount_prime_pow_inert (p k : ℕ) (hp : Nat.Prime p) (hmod : p % 3 = 2) :
    iCount (p ^ k) = if Even k then 1 else 0 := by
  split_ifs with h_even;
  · obtain ⟨ j, rfl ⟩ := even_iff_two_dvd.mp h_even;
    have h_unique : ∀ I : Ideal Eisenstein, Ideal.absNorm I = p ^ (2 * j) → I = Ideal.span {⟨(p :) ^ j, 0⟩} := by
      intro I hI
      obtain ⟨z, hz⟩ : ∃ z : Eisenstein, I = Ideal.span {z} := by
        exact ⟨ _, Eq.symm <| Ideal.span_singleton_generator _ ⟩;
      have h_norm : Eisenstein.norm z = (p ^ j :) ^ 2 := by
        have h_norm : Ideal.absNorm (Ideal.span {z}) = (Eisenstein.norm z).natAbs := by
          convert Eisenstein.absNorm_span_singleton z;
        rw [ ← Int.natAbs_of_nonneg ( Eisenstein.norm_nonneg z ) ] ; simp_all +decide [ pow_mul' ];
      have h_associated : Associated z ⟨(p :) ^ j, 0⟩ := by
        convert norm_inert_pow_associate p j hp hmod z _;
        aesop;
      obtain ⟨ u, hu ⟩ := h_associated;
      rw [ ← hu, hz, Ideal.span_singleton_mul_right_unit ] ; aesop;
    convert iCount_eq_one_of_unique_ideal ( p ^ ( 2 * j ) ) ( Ideal.span { ⟨ ( p : ℤ ) ^ j, 0 ⟩ } ) _ _ <;> norm_num;
    · erw [ algebraNorm_eq_norm ] ; norm_num [ pow_mul', norm ];
    · assumption;
  · apply iCount_zero_of_no_norm;
    convert no_norm_two_mod_three ( p ^ k ) _ using 1;
    rw [ ← Nat.mod_add_div k 2 ] ; norm_num [ Nat.pow_add, Nat.pow_mul, Nat.odd_iff.mp ( Nat.odd_iff.mpr ( Nat.mod_two_ne_zero.mp fun h => h_even <| even_iff_two_dvd.mpr <| Nat.dvd_of_mod_eq_zero h ) ), Nat.mul_mod, Nat.pow_mod, hmod ] ;

theorem iCount_prime_pow_ramified (k : ℕ) :
    iCount (3 ^ k) = 1 := by
  refine' iCount_eq_one_of_unique_ideal ( 3 ^ k ) ( Ideal.span { θ ^ k } ) _ _ <;> norm_num [ Ideal.absNorm_span_singleton ];
  · exact congr_arg ( · ^ k ) ( by rw [ algebraNorm_eq_norm ] ; exact by rw [ norm_θ ] ; rfl );
  · intro I hI
    obtain ⟨z, hz⟩ : ∃ z : Eisenstein, I = Ideal.span {z} := by
      have h_principal : ∀ I : Ideal Eisenstein, I.IsPrincipal := by
        grind +suggestions;
      obtain ⟨ z, hz ⟩ := h_principal I; use z; aesop;
    have hz_norm : Eisenstein.norm z = (3 : ℤ) ^ k := by
      have hz_norm : (Eisenstein.norm z).natAbs = 3 ^ k := by
        rw [ ← hI, hz, absNorm_span_singleton ];
      rw [ ← Int.natAbs_of_nonneg ( norm_nonneg z ), hz_norm ] ; norm_cast
    have hz_associate : Associated z (θ ^ k) := by
      convert norm_three_pow_associate k z hz_norm using 1
    exact (by
    rw [ hz, Ideal.span_singleton_eq_span_singleton ];
    exact hz_associate)

theorem iCount_eq_divSum_prime_pow_split (p k : ℕ) (hp : Nat.Prime p) (hmod : p % 3 = 1) :
    (iCount (p ^ k) : ℤ) = divSum (p ^ k) := by
  rw [iCount_prime_pow_split p k hp hmod, divSum_prime_pow p k hp]
  have hchi : chi3 p = 1 := by simp [chi3, hmod]
  simp [hchi]

theorem iCount_eq_divSum_prime_pow_inert (p k : ℕ) (hp : Nat.Prime p) (hmod : p % 3 = 2) :
    (iCount (p ^ k) : ℤ) = divSum (p ^ k) := by
  have hchi3_p : chi3 p = -1 := by
    unfold chi3; aesop;
  rw [ iCount_prime_pow_inert p k hp hmod, divSum_prime_pow p k hp ];
  split_ifs <;> simp_all +decide [ Nat.even_add_one ]

theorem iCount_eq_divSum_prime_pow_ramified (k : ℕ) :
    (iCount (3 ^ k) : ℤ) = divSum (3 ^ k) := by
  rw [iCount_prime_pow_ramified k, divSum_prime_pow 3 k (by norm_num)]
  simp [chi3]

theorem iCount_eq_divSum_prime_pow (p k : ℕ) (hp : Nat.Prime p) :
    (iCount (p ^ k) : ℤ) = divSum (p ^ k) := by
  have hp3 : p % 3 = 0 ∨ p % 3 = 1 ∨ p % 3 = 2 := by omega
  rcases hp3 with h0 | h1 | h2
  · have hp3 : p = 3 := by
      have h3 : 3 ∣ p := Nat.dvd_of_mod_eq_zero h0
      rcases hp.eq_one_or_self_of_dvd 3 h3 with h | h
      · exact absurd h (by omega)
      · exact h.symm
    rw [hp3]; exact iCount_eq_divSum_prime_pow_ramified k
  · exact iCount_eq_divSum_prime_pow_split p k hp h1
  · exact iCount_eq_divSum_prime_pow_inert p k hp h2

theorem iCount_eq_divSum (n : ℕ) (hn : 0 < n) :
    (iCount n : ℤ) = divSum n := by
  have h_mul : ∀ {m n : ℕ}, 0 < m → 0 < n → Nat.Coprime m n → iCount (m * n) = iCount m * iCount n ∧ divSum (m * n) = divSum m * divSum n := by
    intros m n hm hn hcop
    constructor;
    · by_cases hm1 : m = 1;
      · have := iCount_one; aesop;
      · by_cases hn1 : n = 1;
        · simp +decide [ hn1, iCount_one ];
        · exact iCount_multiplicative m n ( lt_of_le_of_ne hm ( Ne.symm hm1 ) ) ( lt_of_le_of_ne hn ( Ne.symm hn1 ) ) hcop;
    · convert divSum_multiplicative m n hm hn hcop using 1;
  -- By induction on the prime factors of $n$, we can show that $iCount(n) = divSum(n)$ for any $n$.
  have h_ind : ∀ {S : Finset ℕ} (f : ℕ → ℕ), (∀ p ∈ S, Nat.Prime p) → (∀ p ∈ S, ∀ k : ℕ, iCount (p ^ k) = divSum (p ^ k)) → iCount (∏ p ∈ S, p ^ f p) = divSum (∏ p ∈ S, p ^ f p) := by
    intro S f hf_prime hf_eq
    induction' S using Finset.induction with p S hpS ih;
    · norm_num [ iCount_one, divSum_one ];
    · rw [ Finset.prod_insert hpS, h_mul ( pow_pos ( Nat.Prime.pos ( hf_prime p ( Finset.mem_insert_self p S ) ) ) _ ) ( Finset.prod_pos fun q hq => pow_pos ( Nat.Prime.pos ( hf_prime q ( Finset.mem_insert_of_mem hq ) ) ) _ ) ( Nat.Coprime.prod_right fun q hq => Nat.Coprime.pow _ _ <| hf_prime p ( Finset.mem_insert_self p S ) |> Nat.Prime.coprime_iff_not_dvd |>.2 <| fun h => hpS <| by have := Nat.prime_dvd_prime_iff_eq ( hf_prime p ( Finset.mem_insert_self p S ) ) ( hf_prime q ( Finset.mem_insert_of_mem hq ) ) ; aesop ) |>.1, h_mul ( pow_pos ( Nat.Prime.pos ( hf_prime p ( Finset.mem_insert_self p S ) ) ) _ ) ( Finset.prod_pos fun q hq => pow_pos ( Nat.Prime.pos ( hf_prime q ( Finset.mem_insert_of_mem hq ) ) ) _ ) ( Nat.Coprime.prod_right fun q hq => Nat.Coprime.pow _ _ <| hf_prime p ( Finset.mem_insert_self p S ) |> Nat.Prime.coprime_iff_not_dvd |>.2 <| fun h => hpS <| by have := Nat.prime_dvd_prime_iff_eq ( hf_prime p ( Finset.mem_insert_self p S ) ) ( hf_prime q ( Finset.mem_insert_of_mem hq ) ) ; aesop ) |>.2 ] ; norm_cast at * ; aesop;
  convert h_ind ( fun p => Nat.factorization n p ) ( fun p hp => Nat.prime_of_mem_primeFactors hp ) ( fun p hp k => iCount_eq_divSum_prime_pow p k ( Nat.prime_of_mem_primeFactors hp ) ) using 1;
  any_goals exact n;
  · exact congr_arg _ ( congr_arg _ ( Eq.symm <| Nat.factorization_prod_pow_eq_self hn.ne' ) );
  · exact congr_arg _ ( Eq.symm <| Nat.factorization_prod_pow_eq_self hn.ne' )

end Eisenstein