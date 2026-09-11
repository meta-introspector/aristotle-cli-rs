import Mathlib
import RequestProject.Imported.SanityCheckGradedMonoid.CharTwistedEta

/-!
# DULA Graded Monoid: Connecting χ mod 6 to Group Structure

This file builds the bridge from the integer-valued character `chi : ℕ → ℤ`
(defined in `CharTwistedEta.lean`) to a genuine group-theoretic grading.
-/

noncomputable section

open Nat

namespace DULAGradedMonoid

/-! ### The submonoid of integers coprime to 6 -/

/-- Predicate: `n` is a positive integer coprime to 6. -/
def isCoprimeSix (n : ℕ) : Prop := 0 < n ∧ Nat.Coprime n 6

instance : DecidablePred isCoprimeSix := fun n =>
  inferInstanceAs (Decidable (0 < n ∧ Nat.Coprime n 6))

/-- The set of positive integers coprime to 6 (the "lanes" mod 6). -/
def coprimeSixSet : Set ℕ := { n | isCoprimeSix n }

theorem coprimeSixSet_iff (n : ℕ) :
    n ∈ coprimeSixSet ↔ 0 < n ∧ Nat.Coprime n 6 := Iff.rfl

theorem one_mem_coprimeSixSet : (1 : ℕ) ∈ coprimeSixSet := by
  exact ⟨one_pos, Nat.coprime_one_left 6⟩

theorem mul_mem_coprimeSixSet {a b : ℕ}
    (ha : a ∈ coprimeSixSet) (hb : b ∈ coprimeSixSet) :
    a * b ∈ coprimeSixSet := by
  obtain ⟨ha_pos, ha_cop⟩ := ha
  obtain ⟨hb_pos, hb_cop⟩ := hb
  exact ⟨Nat.mul_pos ha_pos hb_pos, Nat.Coprime.mul_left ha_cop hb_cop⟩

/-
Membership in `coprimeSixSet` is exactly: positive, and `n % 6 ∈ {1, 5}`.
-/
theorem mem_coprimeSixSet_iff_mod (n : ℕ) :
    n ∈ coprimeSixSet ↔ 0 < n ∧ (n % 6 = 1 ∨ n % 6 = 5) := by
  unfold coprimeSixSet;
  constructor <;> intro hn <;> unfold isCoprimeSix at * <;> simp_all +decide [ Nat.coprime_iff_gcd_eq_one, Nat.gcd_succ ];
  · rw [ ← Nat.mod_add_div n 6 ] at hn; have := Nat.mod_lt n ( by decide : 6 > 0 ) ; interval_cases n % 6 <;> simp_all +arith +decide;
  · rw [ ← Nat.mod_add_div n 6 ] ; rcases hn.2 with ( h | h ) <;> norm_num [ h ] ;

/-! ### The grading: `chi` on `coprimeSixSet` lands in `{+1, -1}` -/

/-- On the coprime-to-6 part, `chi` never vanishes — it takes values in `{+1, -1}`. -/
theorem chi_ne_zero_of_coprime {n : ℕ} (h : n ∈ coprimeSixSet) : chi n ≠ 0 := by
  rw [mem_coprimeSixSet_iff_mod] at h
  obtain ⟨_, hmod⟩ := h
  unfold chi
  rcases hmod with h1 | h5 <;> simp_all <;> omega

theorem chi_eq_pm_one_of_coprime {n : ℕ} (h : n ∈ coprimeSixSet) :
    chi n = 1 ∨ chi n = -1 := by
  rcases chi_values n with h0 | h1 | h_neg
  · exact absurd h0 (chi_ne_zero_of_coprime h)
  · left; exact h1
  · right; exact h_neg

/-! ### The two graded lanes -/

/-- Lane `+1`: integers coprime to 6 with `chi n = +1`, i.e. `n ≡ 1 (mod 6)`. -/
def lanePlus : Set ℕ := { n ∈ coprimeSixSet | chi n = 1 }

/-- Lane `-1`: integers coprime to 6 with `chi n = -1`, i.e. `n ≡ 5 (mod 6)`. -/
def laneMinus : Set ℕ := { n ∈ coprimeSixSet | chi n = -1 }

theorem mem_lanePlus_iff (n : ℕ) :
    n ∈ lanePlus ↔ 0 < n ∧ n % 6 = 1 := by
  constructor <;> intro hn <;> simp_all +decide [ lanePlus, coprimeSixSet ];
  · exact hn.1 |> fun h => ⟨ h.1, by have := h.2; unfold chi at hn; aesop ⟩;
  · unfold isCoprimeSix chi; simp_all +decide [ Nat.add_mod, Nat.mul_mod ];
    exact ⟨ by rw [ ← Nat.mod_add_div n 6, hn.2 ] ; norm_num, by omega, by omega ⟩

theorem mem_laneMinus_iff (n : ℕ) :
    n ∈ laneMinus ↔ 0 < n ∧ n % 6 = 5 := by
  constructor;
  · intro hn
    obtain ⟨hn_pos, hn_mod⟩ := mem_coprimeSixSet_iff_mod n |>.1 (hn.left)
    have hn_mod_cases : n % 6 = 1 ∨ n % 6 = 5 := by
      exact hn_mod;
    cases hn_mod_cases <;> simp_all +decide [ laneMinus ];
    unfold chi at hn; aesop;
  · intro hn
    unfold laneMinus
    simp [hn, chi];
    exact ⟨ ⟨ hn.1, by rw [ ← Nat.mod_add_div n 6, hn.2 ] ; norm_num ⟩, by omega, by omega ⟩

/-- **The grading is a partition**: every element of `coprimeSixSet` is
    in exactly one lane. -/
theorem coprimeSixSet_eq_lanePlus_union_laneMinus :
    coprimeSixSet = lanePlus ∪ laneMinus := by
  ext n
  simp only [Set.mem_union]
  rw [mem_coprimeSixSet_iff_mod, mem_lanePlus_iff, mem_laneMinus_iff]
  constructor
  · rintro ⟨hpos, h | h⟩
    · left; exact ⟨hpos, h⟩
    · right; exact ⟨hpos, h⟩
  · rintro (⟨hpos, hmod⟩ | ⟨hpos, hmod⟩)
    · exact ⟨hpos, Or.inl hmod⟩
    · exact ⟨hpos, Or.inr hmod⟩

theorem lanePlus_disjoint_laneMinus :
    Disjoint lanePlus laneMinus := by
  rw [Set.disjoint_left]
  intro n hp hm
  rw [mem_lanePlus_iff] at hp
  rw [mem_laneMinus_iff] at hm
  omega

/-! ### The group homomorphism to ZMod 2 -/

/-- The lane index of `n ∈ coprimeSixSet`, taking values in `ZMod 2`.
    Lane `+1` ↦ `0`, Lane `-1` ↦ `1`. (Additive notation in `ZMod 2`.) -/
def laneIndex (n : ℕ) : ZMod 2 :=
  if chi n = 1 then 0 else 1

theorem laneIndex_one : laneIndex 1 = 0 := by
  unfold laneIndex
  simp [chi_one]

/-- The key multiplicativity: lane indices add in `ZMod 2`. -/
theorem laneIndex_mul {a b : ℕ}
    (ha : a ∈ coprimeSixSet) (hb : b ∈ coprimeSixSet) :
    laneIndex (a * b) = laneIndex a + laneIndex b := by
  unfold laneIndex
  rcases chi_eq_pm_one_of_coprime ha with hχa | hχa <;>
  rcases chi_eq_pm_one_of_coprime hb with hχb | hχb <;>
  simp [chi_mul, hχa, hχb] <;>
  decide

/-! ### Sign-determinacy for twin primes -/

/-
A prime greater than 3 has residue 1 or 5 mod 6.
-/
theorem prime_mod_six_of_three_lt {p : ℕ}
    (hp : p.Prime) (h3 : 3 < p) : p % 6 = 1 ∨ p % 6 = 5 := by
  by_contra h;
  have := Nat.Prime.eq_two_or_odd hp; ( have := Nat.dvd_of_mod_eq_zero ( show p % 3 = 0 by omega ) ; rw [ hp.dvd_iff_eq ] at this <;> linarith; )

/-- **Twin prime lane-crossing theorem.**
    For any twin prime pair `(p, p+2)` with `p > 3`,
    `p ∈ laneMinus` and `p + 2 ∈ lanePlus`. -/
theorem twin_prime_lane_crossing
    {p : ℕ} (hp : p.Prime) (hp' : (p + 2).Prime) (h3 : 3 < p) :
    p ∈ laneMinus ∧ (p + 2) ∈ lanePlus := by
  rcases prime_mod_six_of_three_lt hp h3 with h1 | h5
  · exfalso
    have h3_dvd : (3 : ℕ) ∣ (p + 2) := by omega
    have h_eq : 3 = p + 2 := (hp'.eq_one_or_self_of_dvd 3 h3_dvd).resolve_left (by omega)
    omega
  · exact ⟨(mem_laneMinus_iff p).mpr ⟨by omega, h5⟩,
           (mem_lanePlus_iff (p + 2)).mpr ⟨by omega, by omega⟩⟩

/-- **Sign-determinacy corollary**: `χ(p) · χ(p+2) = -1` for all twin primes
    `(p, p+2)` with `p > 3`. -/
theorem chi_twin_prime_sign
    {p : ℕ} (hp : p.Prime) (hp' : (p + 2).Prime) (h3 : 3 < p) :
    chi p * chi (p + 2) = -1 := by
  obtain ⟨hp_minus, hp2_plus⟩ := twin_prime_lane_crossing hp hp' h3
  obtain ⟨_, hχp⟩ := hp_minus
  obtain ⟨_, hχp2⟩ := hp2_plus
  rw [hχp, hχp2]; ring

/-! ### Connection to DirichletCharacter -/

theorem chiDir_eq_chi_on_coprimeSix
    (n : ℕ) (h : n ∈ coprimeSixSet) :
    (chi n : ℂ) = (-1 : ℂ) ^ (laneIndex n).val := by
  cases chi_eq_pm_one_of_coprime h <;> simp_all +decide [ laneIndex ]

end DULAGradedMonoid

end