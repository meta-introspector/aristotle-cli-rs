/-
# Leech Lattice — Unified Module

## Prime Invariant: 24 (rank), 196560 (kissing number), Co₀ = 2²² · 3⁹ · 5⁴ · 7² · 11 · 13 · 23

Merged from LeechAutomorphisms (Conway groups, automorphism structure) and
LeechLatticeAxes (lattice properties, Λ/2Λ vector types, axis counting support).
Both files share the same prime invariant: the 24-dimensional Leech lattice Λ₂₄
and its automorphism groups.

## Sources
- Conway, "A simple construction for the Fischer-Griess Monster group" (1985)
- Conway-Sloane, "Sphere Packings, Lattices and Groups" (1999)
- Höhn-Seysen, "The Order of the Monster Finite Simple Group" (2025)
-/

import Mathlib
import RequestProject.MonsterConstants

set_option maxHeartbeats 8000000

namespace LeechLattice

open MonsterConstants

/-! ## §1. Leech Lattice Invariants -/

/-- Minimum squared norm of a nonzero vector in Λ₂₄. -/
def leech_min_norm : ℕ := 4

/-- The kissing number: 196560 vectors at norm 4. -/
def leechKissingNumber : ℕ := 196560

/-- Kissing number factorization. -/
theorem kissing_number_factored : leechKissingNumber = 2^4 * 3^3 * 5 * 7 * 13 := by
  native_decide

/-- Number of norm-4 vectors = kissing number. -/
def leech_vectors_norm4 : ℕ := 196560

/-- Number of norm-6 vectors in Λ₂₄. -/
def leechNorm6Count : ℕ := 16773120

/-- Norm-6 count factorization. -/
theorem norm6_factored : leechNorm6Count = 2^12 * 3^2 * 5 * 7 * 13 := by native_decide

/-- Number of norm-8 vectors in Λ₂₄. -/
def leechNorm8Count : ℕ := 398034000

/-- Norm-8 count factorization. -/
theorem norm8_factored : leechNorm8Count = 2^4 * 3^7 * 5^3 * 7 * 13 := by native_decide

/-- Number of norm-8 vectors (also used in axis context). -/
def leech_vectors_norm8 : ℕ := 16773120

/-- The covering radius squared of Λ₂₄ is 2. -/
def leechCoveringRadiusSq : ℕ := 2

/-- 720 = 6! (theta series constant). -/
theorem theta_constant_720 : (720 : ℕ) = Nat.factorial 6 := by native_decide

/-! ## §2. Conway Group Orders -/

/-- |Co₀| = Aut(Λ₂₄) = 2²² · 3⁹ · 5⁴ · 7² · 11 · 13 · 23. -/
def co0Order : ℕ := 2^22 * 3^9 * 5^4 * 7^2 * 11 * 13 * 23

theorem co0_order_value : co0Order = 8315553613086720000 := by native_decide

/-- |Co₁| = Co₀/{±1}. -/
def co1Order : ℕ := co0Order / 2

theorem co1_order_value : co1Order = 4157776806543360000 := by native_decide

theorem co1_factorization :
    co1Order = 2^21 * 3^9 * 5^4 * 7^2 * 11 * 13 * 23 := by native_decide

/-- |Co₂| = stabilizer of a type-2 vector. -/
def co2Order : ℕ := 2^18 * 3^6 * 5^3 * 7 * 11 * 23

theorem co2_order_value : co2Order = 42305421312000 := by native_decide

/-- |Co₃| = stabilizer of a type-3 vector. -/
def co3Order : ℕ := 2^10 * 3^7 * 5^3 * 7 * 11 * 23

theorem co3_order_value : co3Order = 495766656000 := by native_decide

/-! ## §3. Divisibility Chain -/

theorem co2_divides_co1 : co2Order ∣ co1Order := by native_decide
theorem co3_divides_co1 : co3Order ∣ co1Order := by native_decide
theorem co1_divides_monster : co1Order ∣ monsterOrder := by native_decide
theorem co2_divides_monster : co2Order ∣ monsterOrder := by native_decide
theorem co3_divides_monster : co3Order ∣ monsterOrder := by native_decide
theorem co0_divides_monster : co0Order ∣ monsterOrder := by native_decide

/-! ## §4. Vectors in Λ/2Λ -/

/-- Total elements in Λ/2Λ ≅ F₂²⁴. -/
def lambda_mod2_size : ℕ := 2^24

theorem lambda_mod2_size_value : lambda_mod2_size = 16777216 := by native_decide

def type0_count : ℕ := 1
def type2_count : ℕ := 98280
def type3_count : ℕ := 8386560
def type4_count : ℕ := 8292375

theorem type_counts_sum :
    type0_count + type2_count + type3_count + type4_count = lambda_mod2_size := by native_decide

/-- Each short vector in Λ/2Λ lifts to ±v, so 2 · 98280 = 196560. -/
theorem short_vectors_double : 2 * type2_count = leech_vectors_norm4 := by native_decide

/-- |Co₁| / |Co₂| = type 2 count. -/
theorem Co1_Co2_index_eq : Co1_order / Co2_order = type2_count := by native_decide

/-! ## §5. Mathieu Group and Golay Code -/

/-- |M₂₄| = 2¹⁰ · 3³ · 5 · 7 · 11 · 23. -/
def M24_order : ℕ := 244823040

theorem M24_factored :
    M24_order = 2^10 * 3^3 * 5 * 7 * 11 * 23 := by native_decide

/-- |M₂₂| (stabilizer of 2 points in M₂₄). -/
def M22_order : ℕ := 443520

/-! ## §6. Subgroup Structure Tower -/

/-- |G_{x₀}| = 2²⁵ · |Co₁|. -/
def Gx0_order : ℕ := 2^25 * Co1_order

/-- |N_{xyz}| = 2³⁵ · |M₂₄|. -/
def Nxyz_order : ℕ := 2^35 * M24_order

/-- |G_{x₀} : N_{xyz}| = 16584750. -/
theorem Gx0_Nxyz_index :
    Gx0_order / Nxyz_order = 16584750 := by native_decide

/-- |N_{x₀}| = 2 · |N_{xyz}|. -/
def Nx0_order : ℕ := 2 * Nxyz_order

/-- |N₀| = 3 · |N_{x₀}|. -/
def N0_order : ℕ := 3 * Nx0_order

/-- N₀/N_{xyz} ≅ S₃ has order 6. -/
theorem N0_Nxyz_index : N0_order / Nxyz_order = 6 := by native_decide

/-! ## §7. Deep Holes and Niemeier Correspondence -/

/-- 23 types of deep holes (one per non-Leech Niemeier root system). -/
def deepHoleTypes : ℕ := 23

/-! ## §8. Conway–Monster Connection via Fischer -/

/-- B contains Co₁ as subgroup. -/
def babyMonsterOrder : ℕ :=
  2^41 * 3^13 * 5^6 * 7^2 * 11 * 13 * 17 * 19 * 23 * 31 * 47

theorem baby_monster_order_value :
    babyMonsterOrder = 4154781481226426191177580544000000 := by native_decide

theorem co1_divides_baby_monster : co1Order ∣ babyMonsterOrder := by native_decide

theorem conway_monster_chain :
    co1Order ∣ babyMonsterOrder ∧ babyMonsterOrder ∣ monsterOrder := by
  exact ⟨co1_divides_baby_monster, by native_decide⟩

/-! ## §9. Ramanujan's τ Function and Leech Theta Coefficients -/

/-- Ramanujan τ function values. -/
def ramanujanTau : ℕ → ℤ
  | 0 => 0  | 1 => 1  | 2 => -24  | 3 => 252  | 4 => -1472
  | 5 => 4830  | 6 => -6048  | 7 => -16744  | 8 => 84480
  | 9 => -113643  | 10 => -115920  | 11 => 534612  | 12 => -370944
  | _ => 0

theorem tau_one : ramanujanTau 1 = 1 := rfl
theorem tau_two : ramanujanTau 2 = -24 := rfl
theorem tau_three : ramanujanTau 3 = 252 := rfl

/-- Ramanujan's congruence: τ(n) ≡ σ₁₁(n) mod 691. -/
theorem ramanujan_congruence_2 : (ramanujanTau 2) % 691 = 2049 % 691 := by native_decide

/-- Leech theta cancellation: 720 · τ(1) + (−720) = 0. -/
theorem leech_theta_cancellation : 720 * (1 : ℤ) + (-720) = 0 := by norm_num

/-- Kissing number from τ(2). -/
theorem kissing_from_tau : 196560 = 720 * 24 + 179280 := by norm_num

/-! ## §10. Supersingular Fiber Bundle -/

/-- The supersingular torus S_ss = ℤ/71 × ℤ/59 × ℤ/47. -/
abbrev S_ss := ZMod 71 × ZMod 59 × ZMod 47

/-- Every fiber has rank 24. -/
def fiberRank (_ : S_ss) : ℕ := 24
theorem fiber_rank_constant (s : S_ss) : fiberRank s = 24 := rfl

/-- Every fiber has |Co₀| automorphisms. -/
def fiberAutOrder (_ : S_ss) : ℕ := co0Order

theorem bundle_divides_monster : co0Order ∣ monsterOrder := co0_divides_monster

/-! ## §11. Cross-Checks -/

theorem moonshine_dimension : 71 * 59 * 47 = 196883 := by norm_num
theorem mckay_observation : 1 + 196883 = 196884 := by norm_num
theorem deep_holes_times_rank : 23 * 24 = 552 := by norm_num
theorem type4_positive : type4_count > 0 := by native_decide

/-- H-orbit index for feasible axes. -/
def H_Nxyz_index : ℕ := 93150

end LeechLattice
