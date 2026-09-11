/-
# The 2×3 Sieve Tower of Complexity
Formalization of the "four elements" decomposition of positive natural numbers
based on their 2-adic and 3-adic valuations, inspired by the structure of Monster
group irreducible representations.
Every positive natural number falls into exactly one of four quadrants:
- **Void** (v₂ = 0, v₃ = 0): numbers coprime to 6, the "flat" sector
- **TwoOnly** (v₂ > 0, v₃ = 0): numbers divisible by 2 but not 3
- **ThreeOnly** (v₂ = 0, v₃ > 0): numbers divisible by 3 but not 2
- **Fusion** (v₂ > 0, v₃ > 0): numbers divisible by both 2 and 3
The "shadow mass" of a number measures its complexity beyond the 2×3 base plane:
it is the sum of p-adic valuations for all primes p ≥ 5.
-/
import Mathlib
open scoped BigOperators Classical
set_option maxHeartbeats 800000
noncomputable section
/-! ## Quadrant Classification -/
/-- The four quadrants of the (v₂, v₃) base plane. -/
inductive SieveQuadrant where
  | Void      -- v₂ = 0, v₃ = 0 : coprime to 6
  | TwoOnly   -- v₂ > 0, v₃ = 0 : divisible by 2, not 3
  | ThreeOnly  -- v₂ = 0, v₃ > 0 : divisible by 3, not 2
  | Fusion    -- v₂ > 0, v₃ > 0 : divisible by both 2 and 3
  deriving DecidableEq, Repr
/-- Classify a positive natural number into its sieve quadrant. -/
def classifyQuadrant (n : ℕ) : SieveQuadrant :=
  match padicValNat 2 n, padicValNat 3 n with
  | 0, 0 => .Void
  | 0, _ + 1 => .ThreeOnly
  | _ + 1, 0 => .TwoOnly
  | _ + 1, _ + 1 => .Fusion
/-! ## Shadow Mass -/
/-- The shadow mass of n: the total p-adic valuation from primes p ≥ 5.
    This measures the "complexity beyond the 2×3 base plane". -/
def shadowMass (n : ℕ) : ℕ :=
  (n.primeFactors.filter (· ≥ 5)).sum (fun p => padicValNat p n)
/-- The 2-3 core weight: v₂(n) + v₃(n). -/
def coreWeight (n : ℕ) : ℕ :=
  padicValNat 2 n + padicValNat 3 n
/-- The shadow complexity triple: (v₂, v₃, shadow_mass). -/
def shadowComplexity (n : ℕ) : ℕ × ℕ × ℕ :=
  (padicValNat 2 n, padicValNat 3 n, shadowMass n)
/-! ## Computational verification -/
-- Verify shadow complexity on small examples
#eval shadowComplexity 6   -- (1, 1, 0) : 6 = 2¹ · 3¹
#eval shadowComplexity 30  -- (1, 1, 1) : 30 = 2 · 3 · 5
#eval shadowComplexity 8   -- (3, 0, 0) : 8 = 2³
#eval shadowComplexity 1   -- (0, 0, 0) : trivial
#eval shadowComplexity 35  -- (0, 0, 2) : 35 = 5 · 7
#eval shadowComplexity 210 -- (1, 1, 2) : 210 = 2 · 3 · 5 · 7
#eval classifyQuadrant 6   -- Fusion
#eval classifyQuadrant 8   -- TwoOnly
#eval classifyQuadrant 9   -- ThreeOnly
#eval classifyQuadrant 35  -- Void
#eval classifyQuadrant 1   -- Void
/-! ## The 2-3 sieve: numbers whose only prime factors are 2 and 3 -/
/-- A number is in the 2-3 sieve if all its prime factors are in {2, 3}. -/
def inTwoThreeSieve (n : ℕ) : Prop :=
  ∀ p : ℕ, p.Prime → p ∣ n → p = 2 ∨ p = 3
/-
A number is in the 2-3 sieve iff its shadow mass is zero (for n ≥ 2).
-/
theorem inTwoThreeSieve_iff_shadowMass_zero {n : ℕ} (hn : 2 ≤ n) :
    inTwoThreeSieve n ↔ shadowMass n = 0 := by
      constructor <;> intro h;
      · exact Finset.sum_eq_zero fun p hp => by have := h p ( Nat.prime_of_mem_primeFactors ( Finset.mem_filter.mp hp |>.1 ) ) ( Nat.dvd_of_mem_primeFactors ( Finset.mem_filter.mp hp |>.1 ) ) ; rcases this with ( rfl | rfl ) <;> norm_num at *;
      · intro p pp dp; contrapose! h; simp_all +decide [ shadowMass ] ;
        exact ⟨ p, pp, dp, by linarith, le_of_not_gt fun h' => by interval_cases p <;> simp_all +decide, pp.ne_one ⟩
/-! ## Quadrant partition properties -/
/-
A number is in the Void quadrant iff it is coprime to 6.
-/
theorem classifyQuadrant_void_iff {n : ℕ} (hn : 0 < n) :
    classifyQuadrant n = .Void ↔ ¬(2 ∣ n) ∧ ¬(3 ∣ n) := by
      constructor;
      · -- By definition of `classifyQuadrant`, if `classifyQuadrant n = .Void`, then `padicValNat 2 n = 0` and `padicValNat 3 n = 0`.
        intro h_void
        have h2 : padicValNat 2 n = 0 := by
          unfold classifyQuadrant at h_void ; aesop
        have h3 : padicValNat 3 n = 0 := by
          unfold classifyQuadrant at h_void ; aesop;
        aesop;
      · unfold classifyQuadrant;
        simp +contextual [ padicValNat.eq_zero_of_not_dvd ]
/-
A number is in the TwoOnly quadrant iff 2 divides it but 3 does not.
-/
theorem classifyQuadrant_twoOnly_iff {n : ℕ} (hn : 0 < n) :
    classifyQuadrant n = .TwoOnly ↔ (2 ∣ n) ∧ ¬(3 ∣ n) := by
      constructor;
      · intro h
        unfold classifyQuadrant at h;
        rcases k : padicValNat 2 n with ( _ | k ) <;> rcases l : padicValNat 3 n with ( _ | l ) <;> simp_all +decide [ Nat.dvd_iff_mod_eq_zero ];
        exact ⟨ Nat.mod_eq_zero_of_dvd <| by contrapose! k; simp_all +decide [ padicValNat.eq_zero_of_not_dvd ], l.resolve_left hn.ne' ⟩;
      · unfold classifyQuadrant;
        rcases k : padicValNat 2 n with ( _ | k ) <;> rcases l : padicValNat 3 n with ( _ | l ) <;> simp_all +decide;
        · omega;
        · omega;
        · exact fun h => Nat.dvd_of_mod_eq_zero ( Nat.mod_eq_zero_of_dvd <| by contrapose! l; simp_all +decide [ padicValNat.eq_zero_of_not_dvd ] )
/-
A number is in the ThreeOnly quadrant iff 3 divides it but 2 does not.
-/
theorem classifyQuadrant_threeOnly_iff {n : ℕ} (hn : 0 < n) :
    classifyQuadrant n = .ThreeOnly ↔ ¬(2 ∣ n) ∧ (3 ∣ n) := by
      unfold classifyQuadrant;
      constructor <;> intro h;
      · rcases k : padicValNat 2 n with ( _ | k ) <;> rcases l : padicValNat 3 n with ( _ | l ) <;> simp_all +decide;
        exact ⟨ k.resolve_left hn.ne', Nat.dvd_of_mod_eq_zero ( Nat.mod_eq_zero_of_dvd <| by contrapose! l; simp_all +decide [ padicValNat.eq_zero_of_not_dvd ] ) ⟩;
      · rw [ padicValNat.eq_zero_of_not_dvd h.1 ];
        rcases k : padicValNat 3 n with ( _ | _ | k ) <;> simp_all +decide
/-
A number is in the Fusion quadrant iff both 2 and 3 divide it.
-/
theorem classifyQuadrant_fusion_iff {n : ℕ} (hn : 0 < n) :
    classifyQuadrant n = .Fusion ↔ (2 ∣ n) ∧ (3 ∣ n) := by
      have h₂ : 2 ∣ n ↔ padicValNat 2 n > 0 := by
        exact ⟨ fun h => Nat.pos_of_ne_zero ( by aesop ), fun h => Nat.dvd_of_mod_eq_zero ( by rw [ Nat.mod_eq_zero_of_dvd ] ; exact ( by contrapose! h; simp_all +decide [ padicValNat.eq_zero_iff ] ) ) ⟩
      have h₃ : 3 ∣ n ↔ padicValNat 3 n > 0 := by
        norm_num [ padicValNat.eq_zero_iff, hn.ne' ];
        rw [ pos_iff_ne_zero, Ne, padicValNat.eq_zero_iff ] ; aesop;
      unfold classifyQuadrant; aesop;
/-- The four quadrants are exhaustive: every positive natural number
    belongs to exactly one quadrant. -/
theorem quadrant_exhaustive (n : ℕ) :
    classifyQuadrant n = .Void ∨ classifyQuadrant n = .TwoOnly ∨
    classifyQuadrant n = .ThreeOnly ∨ classifyQuadrant n = .Fusion := by
  unfold classifyQuadrant
  rcases padicValNat 2 n, padicValNat 3 n with ⟨_ | _, _ | _⟩ <;> simp
/-! ## Shadow structure of each quadrant -/
/-
Numbers in the Void quadrant have zero core weight.
-/
theorem void_coreWeight_zero {n : ℕ} (_hn : 0 < n)
    (hq : classifyQuadrant n = .Void) : coreWeight n = 0 := by
      grind +locals
/-
Numbers in the Fusion quadrant have core weight ≥ 2.
-/
theorem fusion_coreWeight_ge_two {n : ℕ} (_hn : 0 < n)
    (hq : classifyQuadrant n = .Fusion) : coreWeight n ≥ 2 := by
      unfold classifyQuadrant at hq;
      unfold coreWeight;
      grind
/-- The smallest Fusion number is 6 = 2 · 3. -/
theorem six_is_fusion : classifyQuadrant 6 = .Fusion := by native_decide
/-- 6 has zero shadow mass (it lives entirely in the 2×3 base plane). -/
theorem six_shadowMass : shadowMass 6 = 0 := by native_decide
/-- 30 = 2 · 3 · 5 is the smallest Fusion number with nonzero shadow. -/
theorem thirty_fusion : classifyQuadrant 30 = .Fusion := by native_decide
theorem thirty_shadowMass : shadowMass 30 = 1 := by native_decide
/-! ## The 2×3 Sieve Core -/
/-
The 2-3 sieve core consists of numbers of the form 2^a * 3^b.
-/
theorem two_three_sieve_form {n : ℕ} (hn : 0 < n) (h : inTwoThreeSieve n) :
    ∃ a b : ℕ, n = 2 ^ a * 3 ^ b := by
      rw [ ← Nat.factorization_prod_pow_eq_self hn.ne' ];
      rw [ Finsupp.prod_of_support_subset ];
      case s => exact { 2, 3 };
      · aesop;
      · intro p hp; specialize h p; aesop;
      · norm_num
/-
Conversely, numbers of the form 2^a * 3^b are in the 2-3 sieve.
-/
theorem two_three_sieve_of_form (a b : ℕ) :
    inTwoThreeSieve (2 ^ a * 3 ^ b) := by
      intro p pp dp; rw [ Nat.Prime.dvd_mul pp ] at dp; rcases dp with ( dp | dp ) <;> have := pp.dvd_of_dvd_pow dp <;> have := Nat.le_of_dvd ( by positivity ) this <;> interval_cases p <;> norm_num at *;
/-
The 2-3 sieve is a multiplicative submonoid of ℕ.
-/
theorem two_three_sieve_mul {m n : ℕ} (hm : inTwoThreeSieve m) (hn : inTwoThreeSieve n) :
    inTwoThreeSieve (m * n) := by
      intro p pp dp; rw [ Nat.Prime.dvd_mul pp ] at dp; aesop;
/-
The Void quadrant numbers in the 2-3 sieve are exactly {1}.
-/
theorem void_sieve_eq_one {n : ℕ} (hn : 0 < n)
    (hv : classifyQuadrant n = .Void) (hs : inTwoThreeSieve n) : n = 1 := by
      -- By definition of Void quadrant, n is coprime to 6.
      have h_coprime : Nat.gcd n 6 = 1 := by
        exact Nat.Coprime.symm ( Nat.Coprime.mul_left ( Nat.prime_two.coprime_iff_not_dvd.mpr <| by simpa using ( classifyQuadrant_void_iff hn ) |>.1 hv |>.1 ) ( Nat.prime_three.coprime_iff_not_dvd.mpr <| by simpa using ( classifyQuadrant_void_iff hn ) |>.1 hv |>.2 ) );
      rcases two_three_sieve_form hn hs with ⟨ a, b, rfl ⟩ ; simp_all +decide [ Nat.coprime_mul_iff_left ] ;
      rcases a with ( _ | a ) <;> rcases b with ( _ | b ) <;> simp_all +decide [ Nat.Coprime ]
end
