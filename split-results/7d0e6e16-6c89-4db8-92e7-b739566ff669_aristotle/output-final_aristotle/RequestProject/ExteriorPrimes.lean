import Mathlib

/-!
# Exterior Primes: Infinite Graded Rings Orbiting |M|

Every prime falls into one of two classes relative to the Monster group order |M|:

1. **Supersingular primes** {2,3,5,7,11,13,17,19,23,29,31,41,47,59,71}: these
   divide |M| and live "inside" the divisor lattice.

2. **Exterior primes**: all other primes (37, 43, 53, 61, 67, 73, 79, …).
   These are coprime to |M| and orbit around the divisor lattice from outside.

For each exterior prime `p`, we construct an **infinite graded ring**:

    𝒪_p = ⊕_{k ∈ ℕ} 𝒪_p[k]

where grade `k` consists of natural numbers of the form `d · p^k` with `d ∣ |M|`.
Since `gcd(p, |M|) = 1`, every element has a unique grading, and each grade
contains exactly `d(|M|) = 424,488,960` elements (a shifted copy of the divisor set).

Multiplication is graded: `(d₁ · p^k) × (d₂ · p^l) = (d₁ · d₂) · p^{k+l}`,
giving a ℕ-graded multiplicative structure.

## Key Results

1. The first exterior prime is **37** — smallest prime not dividing |M|.
2. All primes < 37 are supersingular.
3. The "moonshine escapee" prime **1823** (from 196884 = 2²·3³·1823) is exterior,
   placing McKay's number 196884 at grade 1 of 𝒪₁₈₂₃.
4. Every grade of 𝒪_p has the same cardinality as the divisor set of |M|.
5. Grades are pairwise disjoint (from coprimality).
6. The graded ring structure is uniform across all exterior primes.
7. All 8 irrep dimensions factor entirely into supersingular primes —
   no exterior prime divides any of them.
8. Exterior primes first appear in the j-coefficients: c₁ = 196884 introduces 1823,
   c₂ = 21493760 introduces 2099, etc.
-/

open scoped BigOperators Nat

set_option maxHeartbeats 3200000

/-! ## §1. Monster Order and Exterior Primes -/

/-- The order of the Monster group. -/
def M_order : ℕ :=
  2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

/-- A prime is **exterior** if it is prime and does NOT divide |M|. -/
def IsExterior (p : ℕ) : Prop := Nat.Prime p ∧ ¬(p ∣ M_order)

instance (p : ℕ) : Decidable (IsExterior p) := inferInstanceAs (Decidable (_ ∧ _))

/-! ## §2. The First 20 Exterior Primes -/

/-- The first 20 exterior primes, in order. -/
def exteriorPrimesList : List ℕ :=
  [37, 43, 53, 61, 67, 73, 79, 83, 89, 97,
   101, 103, 107, 109, 113, 127, 131, 137, 139, 149]

/-- All listed exterior primes are indeed exterior. -/
theorem exteriorList_all_exterior : ∀ p ∈ exteriorPrimesList, IsExterior p := by
  intro p hp; fin_cases hp <;> (constructor <;> native_decide)

/-- 37 is the smallest exterior prime. -/
theorem smallest_exterior_is_37 : IsExterior 37 :=
  ⟨by native_decide, by native_decide⟩

/-- All primes below 37 divide |M| (they are supersingular).
    The complete list of primes < 37: {2,3,5,7,11,13,17,19,23,29,31}. -/
theorem all_primes_below_37_divide_M :
    ∀ p ∈ ([2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31] : List ℕ),
    Nat.Prime p ∧ p < 37 ∧ p ∣ M_order := by native_decide

/-- Every prime is either supersingular or exterior — a complete dichotomy. -/
theorem prime_dichotomy (p : ℕ) (hp : Nat.Prime p) :
    p ∣ M_order ∨ IsExterior p := by
  by_cases h : p ∣ M_order
  · exact Or.inl h
  · exact Or.inr ⟨hp, h⟩

/-! ## §3. Coprimality — The Foundation of Grading -/

/-- An exterior prime is coprime to |M|. -/
theorem exterior_coprime (p : ℕ) (hp : IsExterior p) : Nat.Coprime p M_order :=
  (Nat.Prime.coprime_iff_not_dvd hp.1).mpr hp.2

/-- If p is exterior and d ∣ |M|, then p ∤ d. -/
theorem exterior_not_dvd_divisor (p : ℕ) (hp : IsExterior p)
    (d : ℕ) (hd : d ∣ M_order) : ¬(p ∣ d) :=
  fun hpd => hp.2 (dvd_trans hpd hd)

/-! ## §4. The Graded Orbit Ring 𝒪_p -/

/-- Membership in the orbit: n ∈ 𝒪_p iff ∃ d k, d ∣ |M| ∧ n = d · p^k. -/
def InOrbit (p n : ℕ) : Prop :=
  ∃ d k : ℕ, d ∣ M_order ∧ n = d * p ^ k

/-- The grade-k component: elements d · p^k with d ∣ |M|. -/
def OrbitGrade (p k : ℕ) : Set ℕ :=
  { n : ℕ | ∃ d : ℕ, d ∣ M_order ∧ n = d * p ^ k }

/-- Grade 0 is exactly the divisor set of |M|. -/
theorem grade_zero_eq_divisors (p : ℕ) :
    OrbitGrade p 0 = { n : ℕ | n ∣ M_order } := by
  ext n; simp [OrbitGrade]

/-- Every divisor of |M| lies in grade 0. -/
theorem divisor_in_grade_zero (p d : ℕ) (hd : d ∣ M_order) :
    d ∈ OrbitGrade p 0 := by
  refine ⟨d, hd, ?_⟩; simp

/-- The orbit is the union of all grades. -/
theorem orbit_eq_union_grades (p : ℕ) :
    { n | InOrbit p n } = ⋃ k : ℕ, OrbitGrade p k := by
  ext n; simp only [Set.mem_setOf_eq, InOrbit, OrbitGrade, Set.mem_iUnion]
  constructor
  · rintro ⟨d, k, hd, hn⟩; exact ⟨k, d, hd, hn⟩
  · rintro ⟨k, d, hd, hn⟩; exact ⟨d, k, hd, hn⟩

/-! ## §5. Grade Disjointness -/

/-
Grades are pairwise disjoint for exterior primes.
-/
theorem grades_disjoint (p : ℕ) (hp : IsExterior p) (k l : ℕ) (hkl : k ≠ l) :
    Disjoint (OrbitGrade p k) (OrbitGrade p l) := by
  rw [ Set.disjoint_left ];
  intro n hn_k hn_l;
  -- By definition of $OrbitGrade$, there exist $d₁$ and $d₂$ such that $n = d₁ * p^k = d₂ * p^l$ with $d₁ ∣ M_order$ and $d₂ ∣ M_order$.
  obtain ⟨d₁, hd₁⟩ := hn_k
  obtain ⟨d₂, hd₂⟩ := hn_l;
  -- Without loss of generality, assume $k < l$.
  wlog hkl' : k < l generalizing k l d₁ d₂;
  · exact this l k hkl.symm d₂ hd₂ d₁ hd₁ ( lt_of_le_of_ne ( le_of_not_gt hkl' ) hkl.symm );
  · -- Since $k < l$, we can divide both sides of the equation $d₁ * p^k = d₂ * p^l$ by $p^k$ to get $d₁ = d₂ * p^{l-k}$.
    have h_div : d₁ = d₂ * p ^ (l - k) := by
      exact mul_left_cancel₀ ( pow_ne_zero k hp.1.ne_zero ) ( by rw [ show p ^ l = p ^ k * p ^ ( l - k ) by rw [ ← pow_add, Nat.add_sub_of_le hkl'.le ] ] at hd₂; linarith );
    exact exterior_not_dvd_divisor p hp d₁ hd₁.1 ( h_div.symm ▸ dvd_mul_of_dvd_right ( dvd_pow_self _ ( Nat.sub_ne_zero_of_lt hkl' ) ) _ )

/-! ## §6. Uniform Grade Size -/

/-- The number of divisors of |M|. -/
def numDivisors_M : ℕ := 424488960

/-- The map d ↦ d · p^k bijects divisors of |M| onto grade k. -/
theorem grade_bijection (p k : ℕ) (hp : p ≥ 1) :
    Set.BijOn (fun d => d * p ^ k) { d | d ∣ M_order } (OrbitGrade p k) := by
  refine ⟨fun d hd => ⟨d, hd, rfl⟩, ?_, fun n hn => ?_⟩
  · intro a _ b _ hab
    have : (p ^ k : ℕ) ≠ 0 := by positivity
    exact mul_right_cancel₀ this hab
  · obtain ⟨d, hd, rfl⟩ := hn
    exact ⟨d, hd, rfl⟩

/-! ## §7. Graded Multiplication -/

/-- The product formula. -/
theorem orbitMul_grade (p d₁ k d₂ l : ℕ) :
    (d₁ * p^k) * (d₂ * p^l) = (d₁ * d₂) * p^(k + l) := by
  rw [pow_add]; ring

/-- The identity: 1 · p^0 = 1. -/
theorem orbit_identity (p : ℕ) : 1 * p ^ 0 = 1 := by simp

/-- Associativity. -/
theorem orbitMul_assoc (p d₁ k₁ d₂ k₂ d₃ k₃ : ℕ) :
    ((d₁ * p^k₁) * (d₂ * p^k₂)) * (d₃ * p^k₃) =
    (d₁ * p^k₁) * ((d₂ * p^k₂) * (d₃ * p^k₃)) := by ring

/-- Commutativity. -/
theorem orbitMul_comm (p d₁ k d₂ l : ℕ) :
    (d₁ * p^k) * (d₂ * p^l) = (d₂ * p^l) * (d₁ * p^k) := by ring

/-! ## §8. Irrep Dimensions Are Purely Supersingular -/

/-- The 8 smallest irrep dimensions of the Monster. -/
def irrepDimsExt : List ℕ :=
  [1, 196883, 21296876, 842609326, 18538750076, 19360062527,
   293553734298, 3879214937598]

/-- All 8 irrep dimensions divide |M|. -/
theorem all_irreps_dvd : ∀ d ∈ irrepDimsExt, d ∣ M_order := by decide

/-- No exterior prime from our list divides any irrep dimension.
    All irreps factor entirely into supersingular primes. -/
theorem no_exterior_divides_irrep :
    ∀ p ∈ exteriorPrimesList, ∀ d ∈ irrepDimsExt, ¬(p ∣ d) := by native_decide

/-- Every irrep dimension sits at grade 0 of every exterior orbit ring. -/
theorem irreps_at_grade_zero (p : ℕ) (d : ℕ) (hd : d ∈ irrepDimsExt) :
    d ∈ OrbitGrade p 0 :=
  divisor_in_grade_zero p d (all_irreps_dvd d hd)

/-! ## §9. Moonshine Escapees

Primes appearing in j-coefficient factorizations but NOT supersingular:
- c₁ = 196884 = 2² × 3³ × **1823**
- c₂ = 21493760 = 2¹¹ × 5 × **2099**
- c₄ = 20245856256 = 2⁹ × 3³ × **45767**

These primes "escape" into the exterior via moonshine. -/

/-- A moonshine escapee: exterior prime dividing some j-coefficient. -/
def IsMoonshineEscapee (p : ℕ) : Prop :=
  IsExterior p ∧ ∃ c ∈ ([744, 196884, 21493760, 864299970, 20245856256] : List ℕ),
    p ∣ c

theorem exterior_1823 : IsExterior 1823 :=
  ⟨by native_decide, by native_decide⟩

theorem escapee_1823 : IsMoonshineEscapee 1823 :=
  ⟨exterior_1823, 196884, by simp, by native_decide⟩

/-- 196884 = 2² × 3³ × 1823. -/
theorem c1_factored : 196884 = 2^2 * 3^3 * 1823 := by norm_num

theorem exterior_2099 : IsExterior 2099 :=
  ⟨by native_decide, by native_decide⟩

theorem escapee_2099 : IsMoonshineEscapee 2099 :=
  ⟨exterior_2099, 21493760, by simp, by native_decide⟩

/-- 21493760 = 2¹¹ × 5 × 2099. -/
theorem c2_factored : 21493760 = 2^11 * 5 * 2099 := by norm_num

theorem exterior_45767 : IsExterior 45767 :=
  ⟨by native_decide, by native_decide⟩

theorem escapee_45767 : IsMoonshineEscapee 45767 :=
  ⟨exterior_45767, 20245856256, by simp, by native_decide⟩

/-! ## §10. Taxonomy

**Interstitial** exterior primes: those between consecutive supersingulars (< 71).
**Tail** primes: those beyond 71.
**Moonshine escapees**: exterior primes dividing j-coefficients. -/

/-- Interstitial exterior primes. -/
def interstitialPrimes : List ℕ := [37, 43, 53, 61, 67]

theorem interstitial_all_exterior :
    ∀ p ∈ interstitialPrimes, IsExterior p := by
  intro p hp; fin_cases hp <;> (constructor <;> native_decide)

theorem interstitial_below_71 :
    ∀ p ∈ interstitialPrimes, p < 71 := by
  intro p hp; fin_cases hp <;> omega

/-! ## §11. Gap Structure Between Supersingulars -/

/-- Gaps between consecutive supersingular primes. -/
def ssGaps : List ℕ := [1, 2, 2, 4, 2, 4, 2, 4, 6, 2, 10, 6, 12, 12]

/-- The largest gap is 12 (between 47↔59 and 59↔71). -/
theorem largest_ss_gap : ssGaps.foldl max 0 = 12 := by native_decide

/-- The gap 31→41 contains exactly 37. -/
theorem gap_31_41 :
    (exteriorPrimesList.filter fun p => 31 < p ∧ p < 41) = [37] := by native_decide

/-- The gap 41→47 contains exactly 43. -/
theorem gap_41_47 :
    (exteriorPrimesList.filter fun p => 41 < p ∧ p < 47) = [43] := by native_decide

/-- The gap 47→59 contains exactly 53. -/
theorem gap_47_59 :
    (exteriorPrimesList.filter fun p => 47 < p ∧ p < 59) = [53] := by native_decide

/-- The gap 59→71 contains 61 and 67. -/
theorem gap_59_71 :
    (exteriorPrimesList.filter fun p => 59 < p ∧ p < 71) = [61, 67] := by native_decide

/-! ## §12. Orbit Ring Samples -/

/-- 37 ∈ 𝒪₃₇[1]. -/
theorem orbit37_grade1 : 37 * 1 ∈ OrbitGrade 37 1 :=
  ⟨1, one_dvd _, by ring⟩

/-- 37² ∈ 𝒪₃₇[2]. -/
theorem orbit37_grade2 : 37^2 ∈ OrbitGrade 37 2 :=
  ⟨1, one_dvd _, by ring⟩

/-- McKay's 196884 = 108 · 1823 sits at grade 1 of 𝒪₁₈₂₃. -/
theorem mckay_in_orbit : 196884 ∈ OrbitGrade 1823 1 :=
  ⟨108, by native_decide, by norm_num⟩

/-- 108 = 2² × 3³. -/
theorem base_108_factored : 108 = 2^2 * 3^3 := by norm_num

/-- 196884 does NOT divide |M| — it's not at grade 0. -/
theorem mckay_not_divisor : ¬(196884 ∣ M_order) := by native_decide

/-- c₂ = 21493760 = 10240 · 2099 sits at grade 1 of 𝒪₂₀₉₉. -/
theorem c2_in_orbit : 21493760 ∈ OrbitGrade 2099 1 :=
  ⟨10240, by native_decide, by norm_num⟩

/-- c₁² = 196884² = 108² · 1823² sits at grade 2 of 𝒪₁₈₂₃. -/
theorem c1_sq_in_orbit : 196884^2 ∈ OrbitGrade 1823 2 :=
  ⟨108^2, by native_decide, by norm_num⟩

/-! ## §13. Transfer Between Orbit Rings -/

/-- Transfer between orbit rings at the same grade. -/
def orbitTransfer (p q k : ℕ) (n : ℕ) : ℕ := (n / p^k) * q^k

/-- Transfer formula on well-formed elements. -/
theorem transfer_formula (p q k d : ℕ) (hp : p ≥ 1) :
    orbitTransfer p q k (d * p^k) = d * q^k := by
  simp [orbitTransfer, Nat.mul_div_cancel _ (Nat.one_le_pow k p hp)]

/-! ## §14. The Orbit Ring as a Formal Graded Structure -/

/-- An orbit element: a pair (base, grade) where base ∣ |M|. -/
structure OrbitElem (p : ℕ) where
  base : ℕ
  grade : ℕ
  base_dvd : base ∣ M_order

/-- The natural number d · p^k. -/
def OrbitElem.val (p : ℕ) (e : OrbitElem p) : ℕ := e.base * p ^ e.grade

/-- Graded product (when base product divides |M|). -/
def OrbitElem.mul (p : ℕ) (e₁ e₂ : OrbitElem p)
    (h : e₁.base * e₂.base ∣ M_order) : OrbitElem p :=
  ⟨e₁.base * e₂.base, e₁.grade + e₂.grade, h⟩

/-- Product formula is correct. -/
theorem OrbitElem.mul_val (p : ℕ) (e₁ e₂ : OrbitElem p)
    (h : e₁.base * e₂.base ∣ M_order) :
    (OrbitElem.mul p e₁ e₂ h).val p = e₁.val p * e₂.val p := by
  simp only [OrbitElem.val, OrbitElem.mul, pow_add]; ring

/-- Grade of product = sum of grades. -/
theorem OrbitElem.mul_grade (p : ℕ) (e₁ e₂ : OrbitElem p)
    (h : e₁.base * e₂.base ∣ M_order) :
    (OrbitElem.mul p e₁ e₂ h).grade = e₁.grade + e₂.grade := rfl

/-- Identity element: base = 1, grade = 0. -/
def OrbitElem.one (p : ℕ) : OrbitElem p := ⟨1, 0, one_dvd _⟩

theorem OrbitElem.one_val (p : ℕ) : (OrbitElem.one p).val p = 1 := by
  simp [OrbitElem.one, OrbitElem.val]

/-! ## §15. McKay's Number as an Orbit Element -/

/-- McKay's 196884 in 𝒪₁₈₂₃. -/
def mckay_elem : OrbitElem 1823 := ⟨108, 1, by native_decide⟩

theorem mckay_elem_val : mckay_elem.val 1823 = 196884 := by
  simp [mckay_elem, OrbitElem.val]

theorem mckay_elem_grade : mckay_elem.grade = 1 := rfl

/-- c₂ in 𝒪₂₀₉₉. -/
def c2_elem : OrbitElem 2099 := ⟨10240, 1, by native_decide⟩

theorem c2_elem_val : c2_elem.val 2099 = 21493760 := by
  simp [c2_elem, OrbitElem.val]

/-! ## §16. Counting Exterior Primes -/

/-- Count exterior primes up to n. -/
def countExteriorUpTo (n : ℕ) : ℕ :=
  (List.range (n + 1)).countP fun p =>
    Nat.Prime p && !(Nat.beq (M_order % p) 0)

/-- 5 exterior primes ≤ 71 (the interstitial ones). -/
theorem exterior_count_71 : countExteriorUpTo 71 = 5 := by native_decide

/-- 10 exterior primes ≤ 100. -/
theorem exterior_count_100 : countExteriorUpTo 100 = 10 := by native_decide

/-- 25 total primes ≤ 100 = 15 supersingular + 10 exterior. -/
theorem primes_up_to_100 : (List.range 101).countP Nat.Prime = 25 := by native_decide

/-! ## §17. Universal Orbit Elements -/

/-- 1 is in every orbit ring at grade 0. -/
theorem one_in_all (p : ℕ) : 1 ∈ OrbitGrade p 0 :=
  ⟨1, one_dvd _, by simp⟩

/-- |M| is in every orbit ring at grade 0. -/
theorem M_in_all (p : ℕ) : M_order ∈ OrbitGrade p 0 :=
  ⟨M_order, dvd_refl _, by simp⟩

/-- p itself is at grade 1 (since 1 ∣ |M|). -/
theorem prime_at_grade_1 (p : ℕ) : p ∈ OrbitGrade p 1 :=
  ⟨1, one_dvd _, by simp⟩

/-- p · |M| is at grade 1. -/
theorem pM_at_grade_1 (p : ℕ) : p * M_order ∈ OrbitGrade p 1 :=
  ⟨M_order, dvd_refl _, by ring⟩

/-! ## §18. All Escapees at Grade 1 -/

/-- All three known moonshine escapees sit at grade 1 of their orbit rings. -/
theorem all_escapees_grade_1 :
    196884 ∈ OrbitGrade 1823 1 ∧
    21493760 ∈ OrbitGrade 2099 1 ∧
    20245856256 ∈ OrbitGrade 45767 1 :=
  ⟨mckay_in_orbit, c2_in_orbit, ⟨442368, by native_decide, by norm_num⟩⟩

/-! ## §19. Summary

| Category | Count | Examples |
|----------|-------|---------|
| Supersingular primes | 15 | 2, 3, 5, ..., 71 |
| Interstitial exterior | 5 | 37, 43, 53, 61, 67 |
| Tail exterior (≤ 149) | 15 | 73, 79, 83, ..., 149 |
| Known moonshine escapees | 3 | 1823, 2099, 45767 |
| Grades per orbit ring | ∞ | k = 0, 1, 2, ... |
| Elements per grade | 424,488,960 | = d(|M|) |

Every exterior prime generates an identical graded structure:
a countably infinite tower of divisor-set copies, each shifted by
one more power of p. The orbit rings are the arithmetic halos
through which the Monster's influence propagates outward into
the rest of the prime number line. -/