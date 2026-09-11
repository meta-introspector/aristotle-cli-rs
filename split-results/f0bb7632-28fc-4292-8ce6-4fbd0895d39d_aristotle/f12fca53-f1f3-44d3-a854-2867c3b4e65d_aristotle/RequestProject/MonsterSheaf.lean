/-
# Presheaf on the Divisor Poset and Moonshine Golden Ratios

This module formalizes:
1. The subgroup-box construction as a presheaf (contravariant functor)
   from the divisor poset to the lattice of additive subgroups.
2. The "two sheaf sections" corresponding to the 2-axis (multiplicative)
   and 3-axis (additive) from the user's framework.
3. Golden ratios for various moonshine groups, computed as ln(q)/ln(p)
   for different prime pairs (p, q).
4. Irrationality of the moonshine golden ratios for distinct primes.
5. The q-expansion / j-function spiral: first coefficients and McKay's observation.

## The Sheaf Picture

The divisor poset `Div(n)` has:
- Objects: natural numbers `d` with `d ∣ n`
- Morphisms: `d₁ → d₂` when `d₁ ∣ d₂`

The presheaf `F : Div(n)ᵒᵖ → AddSubgroup(ℤ/nℤ)` sends:
- `d ↦ d·(ℤ/nℤ)` (the subgroup box)
- `(d₁ ∣ d₂) ↦ (d₂·(ℤ/nℤ) ↪ d₁·(ℤ/nℤ))` (inclusion, by antitone property)

The "two sheaf sections" are:
- F₂: the multiplicative/structural stalk at each divisor (2-axis)
- F₃: the additive/enumerative stalk at each divisor (3-axis)
-/

import Mathlib
import RequestProject.MonsterLattice

/-! ## The Subgroup Presheaf

We formalize the assignment `d ↦ subgroupBox n d` as a map that reverses
the divisibility order. For `d₁ ∣ d₂`, we have `subgroupBox n d₂ ≤ subgroupBox n d₁`.

This is the "presheaf on the divisor poset" in categorical language:
a contravariant functor from the divisibility order to the subgroup lattice.
The restriction maps are the natural inclusions of subgroups. -/

/-- The subgroup-box map reverses the divisibility order:
    if `d₁ ∣ d₂`, then the box for `d₂` is contained in the box for `d₁`.
    This is the defining property of a presheaf on the divisor poset. -/
theorem subgroupBox_dvd_antitone (n d₁ d₂ : ℕ) (h : d₁ ∣ d₂) :
    subgroupBox n d₂ ≤ subgroupBox n d₁ :=
  subgroupBox_antitone n d₁ d₂ h

/-! ## Two sheaf sections: the 2-axis and 3-axis stalks

The user's framework assigns:
- **2-axis (multiplicative/struct):** For each `d`, the "2-stalk" captures
  the multiplicative structure — the units group `(ℤ/dℤ)ˣ` and its order `φ(d)`.
- **3-axis (additive/enum):** For each `d`, the "3-stalk" captures
  the additive/graded structure — the subgroup `d·(ℤ/nℤ)` and its index `n/d`.

These two data are "orthogonal" in the sense that:
- The 2-data (Euler totient) is multiplicative: φ(d₁d₂) = φ(d₁)φ(d₂) for coprime d₁, d₂
- The 3-data (subgroup index) is multiplicative: [n:d₁d₂] = [n:d₁]·[n:d₂] for coprime d₁, d₂
-/

/-- The "multiplicative stalk" at divisor `d`: the Euler totient φ(d),
    measuring the size of the units group (ℤ/dℤ)ˣ. This is the 2-axis data. -/
def multiplicativeStalk (d : ℕ) : ℕ := Nat.totient d

/-- The "additive stalk" at divisor `d` relative to `n`: the index `gcd(n,d)`,
    which equals `d` when `d ∣ n`. This is the 3-axis data. -/
def additiveStalk (n d : ℕ) : ℕ := Nat.gcd n d

/-- When `d ∣ n`, the additive stalk equals `d` itself. -/
theorem additiveStalk_of_dvd (n d : ℕ) (h : d ∣ n) : additiveStalk n d = d := by
  simp [additiveStalk, Nat.gcd_eq_right h]

/-! ## Golden ratios for moonshine groups

For each moonshine group G, pick the two dominant primes (p, q) dividing |G|.
The "moonshine golden ratio" is φ_G = ln(q)/ln(p).

Key examples (using the two smallest prime divisors of each group):
- Monster M: (2, 3) → φ_M = ln(3)/ln(2) ≈ 1.585
- Baby Monster B: (2, 3) → φ_B = ln(3)/ln(2) ≈ 1.585
- Fischer Fi₂₄: (2, 3) → same ratio
- Conway Co₁: (2, 3) → same ratio
- Mathieu M₂₄: (2, 3) → same ratio

All sporadic simple groups have 2 and 3 as their two smallest prime divisors,
so they all share the same "base golden ratio" ln(3)/ln(2).

However, the *next* pair (3, 5) gives a secondary ratio, and here
different groups diverge based on their 5-adic valuation.
-/

/-- Golden ratio for prime pair (2, 3): shared by all sporadic groups. -/
noncomputable def goldenRatio_2_3 : ℝ := moonshineGoldenRatio 2 3

/-- Golden ratio for prime pair (3, 5): the "secondary spiral" ratio. -/
noncomputable def goldenRatio_3_5 : ℝ := moonshineGoldenRatio 3 5

/-- Golden ratio for prime pair (2, 5): the "diagonal" ratio. -/
noncomputable def goldenRatio_2_5 : ℝ := moonshineGoldenRatio 2 5

/-- The (2,3) golden ratio equals logb 2 3. -/
theorem goldenRatio_2_3_eq : goldenRatio_2_3 = Real.logb 2 3 := by
  simp [goldenRatio_2_3, moonshineGoldenRatio, Real.log_div_log]

/-- The (3,5) golden ratio equals logb 3 5. -/
theorem goldenRatio_3_5_eq : goldenRatio_3_5 = Real.logb 3 5 := by
  simp [goldenRatio_3_5, moonshineGoldenRatio, Real.log_div_log]

/-- The (2,5) golden ratio equals logb 2 5. -/
theorem goldenRatio_2_5_eq : goldenRatio_2_5 = Real.logb 2 5 := by
  simp [goldenRatio_2_5, moonshineGoldenRatio, Real.log_div_log]

/-
The golden ratios satisfy the "tower law": φ(2,5) = φ(2,3) · φ(3,5).
    This is the change-of-base formula: logb 2 5 = logb 2 3 · logb 3 5.
-/
theorem goldenRatio_tower :
    goldenRatio_2_5 = goldenRatio_2_3 * goldenRatio_3_5 := by
  unfold goldenRatio_2_5 goldenRatio_2_3 goldenRatio_3_5;
  unfold moonshineGoldenRatio;
  ring_nf; norm_num;

/-! ## Irrationality of moonshine golden ratios

The ratio ln(q)/ln(p) is irrational whenever p and q are distinct primes.
This follows from unique prime factorization: if ln(q)/ln(p) = a/b,
then q^b = p^a, contradicting the fundamental theorem of arithmetic.

This irrationality means the spiral never closes — it is a true logarithmic
spiral, not a periodic orbit. -/

/-
The moonshine golden ratio ln(q)/ln(p) is irrational for distinct primes p, q.
-/
theorem moonshineGoldenRatio_irrational (p q : ℕ) (hp : Nat.Prime p) (hq : Nat.Prime q)
    (hpq : p ≠ q) : Irrational (moonshineGoldenRatio p q) := by
  -- Use the fact that the logarithm of a prime number base another prime number is irrational.
  have h_irr : ∀ {p q : ℕ}, p.Prime → q.Prime → p ≠ q → Irrational (Real.log q / Real.log p) := by
    intros p q hp hq hpq
    by_contra h_contra
    obtain ⟨a, b, ha, hb, hab⟩ : ∃ a b : ℕ, a ≠ 0 ∧ b ≠ 0 ∧ Real.log q / Real.log p = a / b := by
      unfold Irrational at h_contra;
      obtain ⟨ x, hx ⟩ := Classical.not_not.1 h_contra;
      exact ⟨ x.num.natAbs, x.den, by simpa using ne_of_gt ( Rat.num_pos.mpr ( show 0 < x from by exact_mod_cast hx.symm ▸ div_pos ( Real.log_pos <| Nat.one_lt_cast.mpr hq.one_lt ) ( Real.log_pos <| Nat.one_lt_cast.mpr hp.one_lt ) ) ), by simp +decide, by simpa [ abs_of_nonneg <| Rat.num_nonneg.mpr <| show 0 ≤ x from by exact_mod_cast hx.symm ▸ div_nonneg ( Real.log_nonneg <| Nat.one_le_cast.mpr hq.pos ) ( Real.log_nonneg <| Nat.one_le_cast.mpr hp.pos ), Rat.cast_def ] using hx.symm ⟩;
    -- Then we have $q^b = p^a$.
    have h_eq : q^b = p^a := by
      rw [ div_eq_div_iff ] at hab;
      · rw [ ← @Nat.cast_inj ℝ ] ; push_cast ; rw [ ← Real.exp_log ( Nat.cast_pos.mpr hq.pos ), ← Real.exp_log ( Nat.cast_pos.mpr hp.pos ), ← Real.exp_nat_mul, ← Real.exp_nat_mul ] ; norm_num ; linarith;
      · exact ne_of_gt <| Real.log_pos <| Nat.one_lt_cast.mpr hp.one_lt;
      · positivity;
    exact hpq ( Nat.prime_dvd_prime_iff_eq hp hq |>.1 ( hp.dvd_of_dvd_pow <| h_eq.symm ▸ dvd_pow_self _ ha ) );
  exact h_irr hp hq hpq

/-! ## q-expansion and the Fibonacci spiral

The j-invariant has the q-expansion:
  j(τ) = q⁻¹ + 744 + 196884q + 21493760q² + 864299970q³ + ...

McKay's observation: 196884 = 1 + 196883
where 1 and 196883 are the dimensions of the two smallest irreps of the Monster.

In the (log₂, log₃) plane, each coefficient c(n) traces a point:
  (log₂|c(n)|, log₃|c(n)|)

The asymptotic growth c(n) ~ e^(4π√n) / (√2 · n^(3/4)) means these points
expand outward, and the irrational slope ln(3)/ln(2) prevents the trajectory
from ever repeating — creating a logarithmic (Fibonacci-like) spiral. -/

/-- First few coefficients of the j-invariant q-expansion (starting from q⁻¹).
    j(τ) = q⁻¹ + 744 + 196884q + 21493760q² + 864299970q³ + ... -/
def jCoefficients : List ℤ :=
  [1, 744, 196884, 21493760, 864299970, 20245856256, 333202640600]

/-- McKay's observation: the first non-trivial j-coefficient equals the sum of the
    dimensions of the two smallest Monster irreps: 196884 = 1 + 196883. -/
theorem mckay_observation : (196884 : ℕ) = 1 + 196883 := by norm_num

/-- The second j-coefficient decomposes into Monster irrep dimensions:
    21493760 = 1 + 196883 + 21296876. -/
theorem j_coeff_2_decomp : (21493760 : ℕ) = 1 + 196883 + 21296876 := by norm_num

/-- The spiral "radius" at coefficient c(n) is log|c(n)|, which grows as 4π√n. -/
noncomputable def spiralRadius (n : ℕ) (c : ℕ → ℕ) : ℝ :=
  Real.log (c n)

/-- The spiral "angle" relative to the (2,3) axes.
    This is arctan(ln 2 / ln 3), which is the constant angle of the
    logarithmic spiral in the (log₂, log₃) plane.
    The constant angle confirms the spiral structure. -/
noncomputable def spiralAngle (p q : ℕ) : ℝ :=
  Real.arctan (Real.log p / Real.log q)

/-- The Monster's spiral angle is arctan(ln 2 / ln 3). -/
noncomputable def monsterSpiralAngle : ℝ := spiralAngle 2 3

/-! ## Sporadic group orders and their golden ratios -/

/-- Order of the Baby Monster group. -/
def BabyMonsterOrder : ℕ :=
  4154781481226426191177580544000000

/-- Order of the Fischer group Fi₂₃. -/
def Fi23Order : ℕ :=
  4089470473293004800

/-- Order of the Conway group Co₁. -/
def Co1Order : ℕ :=
  4157776806543360000

/-- Order of the Mathieu group M₂₄. -/
def M24Order : ℕ :=
  244823040

/-- All sporadic groups listed have 2 and 3 as factors. -/
example : (2 : ℕ) ∣ BabyMonsterOrder := by native_decide
example : (3 : ℕ) ∣ BabyMonsterOrder := by native_decide
example : (2 : ℕ) ∣ M24Order := by native_decide
example : (3 : ℕ) ∣ M24Order := by native_decide

/-- The (v₂, v₃) valuation pairs for different sporadic groups.
    These determine the "grid size" of each group's spiral. -/
theorem babyMonster_val_pair :
    (BabyMonsterOrder.factorization 2, BabyMonsterOrder.factorization 3) = (41, 13) := by
  exact Prod.mk.injEq .. |>.mpr ⟨by native_decide, by native_decide⟩

theorem m24_val_pair :
    (M24Order.factorization 2, M24Order.factorization 3) = (10, 3) := by
  exact Prod.mk.injEq .. |>.mpr ⟨by native_decide, by native_decide⟩

-- Each group's "grid area" (v₂+1)(v₃+1):
-- Monster: 47 × 21 = 987 = F₁₆
-- Baby Monster: 42 × 14 = 588
-- M₂₄: 11 × 4 = 44
example : (41 + 1) * (13 + 1) = 588 := by norm_num
example : (10 + 1) * (3 + 1) = 44 := by norm_num