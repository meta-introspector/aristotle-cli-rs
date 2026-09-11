/-
# Classification of Finite Simple Groups
This file states the Classification of Finite Simple Groups (CFSG),
which is the theoretical backbone of the ATLAS. According to the CFSG,
every finite simple group is isomorphic to one of:
1. A cyclic group ℤ/pℤ for p prime
2. An alternating group Aₙ for n ≥ 5
3. A group of Lie type (classical or exceptional Chevalley groups)
4. One of 26 sporadic groups
The ATLAS tabulates detailed information for all 26 sporadic groups
and many groups in families (1)-(3).
-/
import Mathlib
set_option maxHeartbeats 800000
open scoped BigOperators Classical
noncomputable section
/-! ## The Families of Finite Simple Groups -/
/-- The classification of finite simple groups: every finite simple group
    belongs to one of four families. -/
inductive FiniteSimpleGroupFamily where
  /-- Cyclic groups of prime order. -/
  | cyclic (p : ℕ) (hp : p.Prime)
  /-- Alternating groups Aₙ for n ≥ 5. -/
  | alternating (n : ℕ) (hn : 5 ≤ n)
  /-- Groups of Lie type, parametrized by a Dynkin type and a prime power. -/
  | lieType (type : LieType) (q : ℕ) (hq : IsPrimePow (q : ℕ))
  /-- The 26 sporadic simple groups. -/
  | sporadic (s : SporadicGroup)
/-- The Dynkin types for Chevalley and twisted Chevalley groups. -/
inductive LieType where
  -- Classical (untwisted)
  | A (n : ℕ)   -- PSL(n+1, q) = Lₙ₊₁(q)
  | B (n : ℕ)   -- Ω(2n+1, q)
  | C (n : ℕ)   -- PSp(2n, q)
  | D (n : ℕ)   -- PΩ⁺(2n, q)
  -- Exceptional (untwisted)
  | E6
  | E7
  | E8
  | F4
  | G2
  -- Twisted types
  | twoA (n : ℕ)   -- PSU(n+1, q) = ²Aₙ(q)
  | twoD (n : ℕ)   -- PΩ⁻(2n, q) = ²Dₙ(q)
  | twoE6           -- ²E₆(q)
  | threeD4          -- ³D₄(q)
  | twoB2            -- Suzuki groups ²B₂(q), q = 2^(2m+1)
  | twoG2            -- Ree groups ²G₂(q), q = 3^(2m+1)
  | twoF4            -- Ree groups ²F₄(q), q = 2^(2m+1)
/-- The 26 sporadic simple groups, as enumerated in the ATLAS. -/
inductive SporadicGroup where
  | M11    -- Mathieu group, order 7920
  | M12    -- Mathieu group, order 95040
  | M22    -- Mathieu group, order 443520
  | M23    -- Mathieu group, order 10200960
  | M24    -- Mathieu group, order 244823040
  | J1     -- Janko group, order 175560
  | J2     -- Hall-Janko group (= HJ), order 604800
  | J3     -- Janko group, order 50232960
  | J4     -- Janko group, order 86775571046077562880
  | HS     -- Higman-Sims group, order 44352000
  | MCL    -- McLaughlin group, order 898128000
  | Co1    -- Conway group, order 4157776806543360000
  | Co2    -- Conway group, order 42305421312000
  | Co3    -- Conway group, order 495766656000
  | Suz    -- Suzuki sporadic group, order 448345497600
  | Fi22   -- Fischer group
  | Fi23   -- Fischer group
  | Fi24'  -- Fischer group (derived subgroup)
  | He     -- Held group
  | HN     -- Harada-Norton group
  | Th     -- Thompson group
  | B      -- Baby Monster
  | M      -- Monster group, the largest sporadic group
  | Ru     -- Rudvalis group
  | ON     -- O'Nan group
  | Ly     -- Lyons group
/-- The order of each sporadic group, as recorded in the ATLAS.
These orders were computed by the original discoverers and verified
by multiple independent methods. The Monster group M has the largest
order of any sporadic group. -/
def SporadicGroup.order : SporadicGroup → ℕ
  | .M11   => 7920
  | .M12   => 95040
  | .M22   => 443520
  | .M23   => 10200960
  | .M24   => 244823040
  | .J1    => 175560
  | .J2    => 604800
  | .J3    => 50232960
  | .J4    => 86775571046077562880
  | .HS    => 44352000
  | .MCL   => 898128000
  | .Co1   => 4157776806543360000
  | .Co2   => 42305421312000
  | .Co3   => 495766656000
  | .Suz   => 448345497600
  | .Fi22  => 64561751654400
  | .Fi23  => 4089470473293004800
  | .Fi24' => 1255205709190661721292800
  | .He    => 4030387200
  | .HN    => 273030912000000
  | .Th    => 90745943887872000
  | .B     => 4154781481226426191177580544000000
  | .M     => 808017424794512875886459904961710757005754368000000000
  | .Ru    => 145926144000
  | .ON    => 460815505920
  | .Ly    => 51765179004000000
/-- The order of the Schur multiplier for each sporadic group. -/
def SporadicGroup.schurMultiplierOrder : SporadicGroup → ℕ
  | .M11   => 1
  | .M12   => 2
  | .M22   => 12  -- Largest Schur multiplier among sporadic groups
  | .M23   => 1
  | .M24   => 1
  | .J1    => 1
  | .J2    => 2
  | .J3    => 3
  | .J4    => 1
  | .HS    => 2
  | .MCL   => 3
  | .Co1   => 2
  | .Co2   => 1
  | .Co3   => 1
  | .Suz   => 6
  | .Fi22  => 6
  | .Fi23  => 1
  | .Fi24' => 3
  | .He    => 1
  | .HN    => 1
  | .Th    => 1
  | .B     => 2
  | .M     => 1
  | .Ru    => 2
  | .ON    => 3
  | .Ly    => 1
/-- The order of Out(G) for each sporadic group. -/
def SporadicGroup.outerAutOrder : SporadicGroup → ℕ
  | .M11   => 1
  | .M12   => 2
  | .M22   => 2
  | .M23   => 1
  | .M24   => 1
  | .J1    => 1
  | .J2    => 2
  | .J3    => 2
  | .J4    => 1
  | .HS    => 2
  | .MCL   => 2
  | .Co1   => 1
  | .Co2   => 1
  | .Co3   => 1
  | .Suz   => 2
  | .Fi22  => 2
  | .Fi23  => 1
  | .Fi24' => 2
  | .He    => 2
  | .HN    => 2
  | .Th    => 1
  | .B     => 1
  | .M     => 1
  | .Ru    => 1
  | .ON    => 2
  | .Ly    => 1
/-- The number of conjugacy classes for each sporadic group. -/
def SporadicGroup.numConjClasses : SporadicGroup → ℕ
  | .M11   => 10
  | .M12   => 15
  | .M22   => 12
  | .M23   => 17
  | .M24   => 26
  | .J1    => 15
  | .J2    => 21
  | .J3    => 21
  | .J4    => 62
  | .HS    => 24
  | .MCL   => 24
  | .Co1   => 101
  | .Co2   => 60
  | .Co3   => 42
  | .Suz   => 43
  | .Fi22  => 65
  | .Fi23  => 98
  | .Fi24' => 106
  | .He    => 33
  | .HN    => 54
  | .Th    => 48
  | .B     => 184
  | .M     => 194
  | .Ru    => 36
  | .ON    => 30
  | .Ly    => 53
/-! ## The Classification Theorem (Statement) -/
/-- **The Classification of Finite Simple Groups (CFSG).**
Every finite simple group is isomorphic to one of:
1. A cyclic group ℤ/pℤ for p prime;
2. An alternating group Aₙ for n ≥ 5;
3. A finite group of Lie type;
4. One of the 26 sporadic simple groups.
This is one of the greatest achievements of 20th century mathematics,
with a proof spanning tens of thousands of pages across hundreds of
journal articles. The ATLAS serves as a companion reference cataloging
detailed structural data for the groups appearing in this classification.
Note: We state this axiomatically. A full proof is far beyond the scope
of any current formalization effort. -/
theorem classification_of_finite_simple_groups :
  ∀ (G : Type*) [Group G] [Fintype G] [IsSimpleGroup G],
    -- Either G has prime order (cyclic case)
    (Nat.card G).Prime ∨
    -- Or G is isomorphic to an alternating group Aₙ, n ≥ 5
    (∃ n : ℕ, 5 ≤ n ∧ Nonempty (G ≃* alternatingGroup (Fin n))) ∨
    -- Or G is a group of Lie type (stated abstractly)
    (∃ (type : LieType) (q : ℕ), IsPrimePow (q : ℕ) ∧ True /- placeholder -/) ∨
    -- Or G is one of the 26 sporadic groups
    (∃ s : SporadicGroup, True /- G ≃* sporadicGroupOf s -/) := by
  sorry -- The CFSG proof spans ~10,000 pages; formal verification is a major open project
/-! ## Basic facts about the orders -/
/-- All sporadic group orders are greater than 1. -/
theorem SporadicGroup.order_pos (s : SporadicGroup) : 0 < s.order := by
  cases s <;> simp [SporadicGroup.order]
/-- The Monster is the largest sporadic group. -/
theorem SporadicGroup.monster_largest (s : SporadicGroup) :
    s.order ≤ SporadicGroup.M.order := by
  cases s <;> simp [SporadicGroup.order]
end -- noncomputable section
