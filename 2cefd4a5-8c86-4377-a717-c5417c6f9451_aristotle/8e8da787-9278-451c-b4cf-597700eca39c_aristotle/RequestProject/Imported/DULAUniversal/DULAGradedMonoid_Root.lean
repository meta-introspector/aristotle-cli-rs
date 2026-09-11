import Mathlib
import RequestProject.Imported.DULAUniversal.CharTwistedEta_Root

/-!
# DULA Graded Monoid: Connecting χ mod 6 to Group Structure

This file builds the bridge from the integer-valued character `chi : ℕ → ℤ`
(defined in `CharTwistedEta.lean`) to a genuine group-theoretic grading.

## Overall structure

The character `chi` is complete multiplicative on ℕ but takes values in
the monoid {0, +1, -1} ⊂ ℤ (multiplicative), which is **not** a group —
the value 0 is absorbing. To get an honest group homomorphism, we
restrict to integers coprime to 6:

  `M := { n ∈ ℕ_{>0} : gcd(n, 6) = 1 }`

This is a submonoid of `(ℕ_{>0}, ·)`, and `chi` restricted to `M` takes
values in `{±1} ⊂ ℤ`, which is isomorphic to the cyclic group `ZMod 2`
(written multiplicatively as `Multiplicative (ZMod 2)`).

## What this file builds

1. **`coprimeSixMonoid`** : the submonoid `M ⊂ ℕ_{>0}` of integers coprime to 6.
2. **`chiToZMod2`** : the group homomorphism `M →* Multiplicative (ZMod 2)`
   induced by `chi` restricted to `M`.
3. **`lanePlus`, `laneMinus`** : the two graded pieces
   `M_+ = chi⁻¹(+1)`, `M_- = chi⁻¹(-1)`.
4. **`grading_correct`** : the partition `M = M_+ ⊔ M_-`.
5. **`twin_prime_lane_crossing`** : the structural theorem stating that
   every twin prime pair `(p, p+2)` with `p > 3` is a lane-crossing
   pair `p ∈ M_-`, `p+2 ∈ M_+`. *(Statement only — proof relies on the
   classical fact that `p > 3` prime implies `p % 6 ∈ {1, 5}`.)*

## Connection to the analytic side

The grading homomorphism `chiToZMod2` is the multiplicative-monoid
counterpart of the Dirichlet character `chiDir : DirichletCharacter ℂ 6`
declared in `CharTwistedEta.lean`. Specifically, for n coprime to 6:
  `chiDir n = (chiToZMod2 n).val · ((-1) : ℂ)^?`
(precise form depends on conventions; the connection lemma is left as a
target for downstream work.)

## Status

Skeleton with statements and a mixture of complete proofs and `sorry`s.
The `sorry`s are deliberately *targeted* — each is at a place where the
real mathematical content lives, not at routine plumbing.
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
  refine ⟨one_pos, ?_⟩
  decide

theorem mul_mem_coprimeSixSet {a b : ℕ}
    (ha : a ∈ coprimeSixSet) (hb : b ∈ coprimeSixSet) :
    a * b ∈ coprimeSixSet := by
  obtain ⟨ha_pos, ha_cop⟩ := ha
  obtain ⟨hb_pos, hb_cop⟩ := hb
  exact ⟨Nat.mul_pos ha_pos hb_pos, ha_cop.mul_left hb_cop⟩

/-
Membership in `coprimeSixSet` is exactly: positive, and `n % 6 ∈ {1, 5}`.
-/
theorem mem_coprimeSixSet_iff_mod (n : ℕ) :
    n ∈ coprimeSixSet ↔ 0 < n ∧ (n % 6 = 1 ∨ n % 6 = 5) := by
      constructor <;> intro hn <;> simp_all +decide [ coprimeSixSet, Nat.Coprime ];
      · rcases hn with ⟨ hn₁, hn₂ ⟩;
        exact ⟨ hn₁, by rw [ Nat.Coprime, Nat.gcd_comm, Nat.gcd_rec ] at hn₂; have := Nat.mod_lt n ( by decide : 6 > 0 ) ; interval_cases n % 6 <;> trivial ⟩;
      · exact ⟨ hn.1, Nat.Coprime.symm <| Nat.Coprime.gcd_eq_one <| by rw [ ← Nat.mod_add_div n 6 ] ; rcases hn.2 with ( hn | hn ) <;> norm_num [ Nat.add_mod, Nat.mul_mod, hn ] ⟩

/-! ### The grading: `chi` on `coprimeSixSet` lands in `{+1, -1}` -/

/-- On the coprime-to-6 part, `chi` never vanishes — it takes values in `{+1, -1}`. -/
theorem chi_ne_zero_of_coprime {n : ℕ} (h : n ∈ coprimeSixSet) : chi n ≠ 0 := by
  rw [mem_coprimeSixSet_iff_mod] at h
  obtain ⟨_, hmod⟩ := h
  unfold chi
  rcases hmod with h1 | h5
  · have h2 : ¬ (n % 2 = 0) := by omega
    have h3 : ¬ (n % 3 = 0) := by omega
    simp [h2, h3, h1]
  · have h2 : ¬ (n % 2 = 0) := by omega
    have h3 : ¬ (n % 3 = 0) := by omega
    have h1 : ¬ (n % 6 = 1) := by omega
    simp [h2, h3, h1]

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
      constructor <;> intro hn;
      · rcases hn with ⟨ ⟨ hn₁, hn₂ ⟩, hn₃ ⟩ ; unfold chi at hn₃ ; aesop;
      · exact ⟨ ⟨ hn.1, by exact Nat.Coprime.symm <| Nat.Coprime.gcd_eq_one <| by rw [ ← Nat.mod_add_div n 6, hn.2 ] ; norm_num ⟩, by unfold chi; omega ⟩

theorem mem_laneMinus_iff (n : ℕ) :
    n ∈ laneMinus ↔ 0 < n ∧ n % 6 = 5 := by
      constructor <;> intro hn <;> simp_all +decide [ laneMinus ];
      · rcases hn with ⟨ hn₁, hn₂ ⟩ ; rcases mem_coprimeSixSet_iff_mod n |>.1 hn₁ with ⟨ hn₃, hn₄ ⟩ ; rcases hn₄ with ( hn₄ | hn₄ ) <;> simp_all +decide [ chi ] ;
        split_ifs at hn₂;
      · exact ⟨ mem_coprimeSixSet_iff_mod n |>.2 ⟨ hn.1, by omega ⟩, by unfold chi; omega ⟩

/-- **The grading is a partition**: every element of `coprimeSixSet` is
    in exactly one lane. -/
theorem coprimeSixSet_eq_lanePlus_union_laneMinus :
    coprimeSixSet = lanePlus ∪ laneMinus := by
  ext n
  simp only [Set.mem_union]
  rw [mem_coprimeSixSet_iff_mod, mem_lanePlus_iff, mem_laneMinus_iff]
  constructor
  · intro ⟨hpos, hmod⟩
    rcases hmod with h | h
    · left; exact ⟨hpos, h⟩
    · right; exact ⟨hpos, h⟩
  · intro h
    rcases h with ⟨hpos, hmod⟩ | ⟨hpos, hmod⟩
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

/-- A prime greater than 3 has residue 1 or 5 mod 6. -/
theorem prime_mod_six_of_three_lt {p : ℕ}
    (hp : p.Prime) (h3 : 3 < p) : p % 6 = 1 ∨ p % 6 = 5 := by
  have h2 : ¬ (2 : ℕ) ∣ p := by
    intro h; have := hp.eq_one_or_self_of_dvd 2 h; omega
  have h3d : ¬ (3 : ℕ) ∣ p := by
    intro h; have := hp.eq_one_or_self_of_dvd 3 h; omega
  have h2m : p % 2 ≠ 0 := fun h => h2 (Nat.dvd_of_mod_eq_zero h)
  have h3m : p % 3 ≠ 0 := fun h => h3d (Nat.dvd_of_mod_eq_zero h)
  omega

/-- **Twin prime lane-crossing theorem.** -/
theorem twin_prime_lane_crossing
    {p : ℕ} (hp : p.Prime) (hp' : (p + 2).Prime) (h3 : 3 < p) :
    p ∈ laneMinus ∧ (p + 2) ∈ lanePlus := by
  rcases prime_mod_six_of_three_lt hp h3 with h1 | h5
  · -- Case p % 6 = 1: then (p+2) % 6 = 3, so 3 ∣ p+2. Contradiction.
    exfalso
    have h3_dvd : (3 : ℕ) ∣ (p + 2) := by omega
    have := hp'.eq_one_or_self_of_dvd 3 h3_dvd
    omega
  · constructor
    · rw [mem_laneMinus_iff]; exact ⟨by omega, h5⟩
    · rw [mem_lanePlus_iff]; exact ⟨by omega, by omega⟩

/-- **Sign-determinacy corollary**: `χ(p) · χ(p+2) = -1` for all twin primes
    `(p, p+2)` with `p > 3`. -/
theorem chi_twin_prime_sign
    {p : ℕ} (hp : p.Prime) (hp' : (p + 2).Prime) (h3 : 3 < p) :
    chi p * chi (p + 2) = -1 := by
  obtain ⟨hp_minus, hp2_plus⟩ := twin_prime_lane_crossing hp hp' h3
  obtain ⟨_, hχp⟩ := hp_minus
  obtain ⟨_, hχp2⟩ := hp2_plus
  rw [hχp, hχp2]
  ring

/-! ### Connection to DirichletCharacter (forward declaration) -/

theorem chiDir_eq_chi_on_coprimeSix
    (n : ℕ) (h : n ∈ coprimeSixSet) :
    (chi n : ℂ) = (-1 : ℂ) ^ (laneIndex n).val := by
  unfold laneIndex
  rcases chi_eq_pm_one_of_coprime h with h1 | h_neg
  · simp [h1]
  · simp [h_neg]
    norm_num [show ZMod.val (1 : ZMod 2) = 1 from rfl]

end DULAGradedMonoid

end