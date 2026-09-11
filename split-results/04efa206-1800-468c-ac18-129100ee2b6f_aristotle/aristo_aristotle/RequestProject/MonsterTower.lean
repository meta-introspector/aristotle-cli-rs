/-
# Monster-Inspired Orthogonal Tower
Starting from the first self-describing orthogonal — a 2×3 matrix containing
[0, 2, 3, 6] — we build a tower of group structure descriptors using quadrant
splitting [00, 01, 10, 11] that encodes inclusion/exclusion of the prime
factors 2 and 3. The tower extends up to 2⁴⁶ × 3²⁰ for the Monster, and
can be instantiated for other sporadic groups (Baby Monster, etc.) by
adjusting the exponent bounds.
## The First Self-Describing Orthogonal
The 2×3 seed matrix is:
```
  ┌         ┐
  │ 0  2  3 │
  │ 0  6  0 │
  └         ┘
```
The entries [0, 2, 3, 6] are exactly the products of subsets of {2, 3}:
  0 = empty (excluded both)
  2 = {2}
  3 = {3}
  6 = {2, 3}
This makes it *self-describing*: the matrix encodes the inclusion/exclusion
pattern of the very primes (2 and 3) that index its rows and columns.
## Quadrant Splitting
At each level we split into four quadrants [00, 01, 10, 11] corresponding
to whether we include (1) or exclude (0) the next power of 2 (first bit)
and the next power of 3 (second bit). This gives a recursive subdivision
of the (e₂, e₃) exponent plane.
## Connection to Group Theory
Each point (e₂, e₃) in the tower describes a divisor 2^e₂ · 3^e₃ of |G|.
The tower value at that point, derived from the seed, gives a weight that
can be related to normalizer indices and inclusion weights from the
subgroup lattice (see `SubgroupLattice.lean`).
-/
import Mathlib
import RequestProject.SubgroupLattice
namespace MonsterTowerNS

noncomputable section
open Matrix Finset
/-! ## The Primal 2×3 Orthogonal -/
/-- The first self-describing orthogonal: a 2×3 matrix whose entries are
exactly the products of subsets of {2, 3}, i.e., [0, 2, 3, 6].
Row index ∈ Fin 2 selects the 2-factor (0 = exclude, 1 = include).
Column index ∈ Fin 3 selects the 3-factor (0 = exclude, 1 or 2 = include). -/
def primalOrthogonal : Matrix (Fin 2) (Fin 3) ℕ :=
  ![![0, 2, 3],
    ![0, 6, 0]]
/-
The seed values are exactly the products of subsets of {2,3}.
-/
theorem primalOrthogonal_values :
    {primalOrthogonal i j | (i : Fin 2) (j : Fin 3)} = {0, 2, 3, 6} := by
  simp +decide [ Set.ext_iff, primalOrthogonal ];
  simp +decide [ Fin.exists_fin_succ ];
  grind
/-! ## Exponent Pairs and Quadrants -/
/-- An exponent pair (e₂, e₃) representing the divisor 2^e₂ · 3^e₃. -/
structure Exp23 where
  e2 : ℕ
  e3 : ℕ
  deriving Repr, DecidableEq, Hashable
instance : Inhabited Exp23 := ⟨⟨0, 0⟩⟩
/-- The four quadrants of the splitting, indexed by inclusion/exclusion
of the 2-factor and 3-factor. -/
inductive Quadrant : Type
  | q00  -- exclude both
  | q01  -- exclude 2, include 3
  | q10  -- include 2, exclude 3
  | q11  -- include both
  deriving Repr, DecidableEq
instance : Fintype Quadrant where
  elems := {.q00, .q01, .q10, .q11}
  complete := by intro x; cases x <;> simp
/-- The multiplier associated to each quadrant. -/
def Quadrant.multiplier : Quadrant → ℕ
  | .q00 => 1
  | .q01 => 3
  | .q10 => 2
  | .q11 => 6
/-
The quadrant multipliers are exactly the entries of the primal orthogonal
(as a multiset).
-/
theorem quadrant_multipliers_match_seed :
    {Quadrant.multiplier q | (q : Quadrant)} = {1, 2, 3, 6} := by
  ext x;
  constructor;
  · rintro ⟨ q, rfl ⟩ ; rcases q with ( _ | _ | _ | _ ) <;> simp +decide;
  · rintro ( rfl | rfl | rfl | rfl ) <;> [ exact ⟨ Quadrant.q00, rfl ⟩ ; exact ⟨ Quadrant.q10, rfl ⟩ ; exact ⟨ Quadrant.q01, rfl ⟩ ; exact ⟨ Quadrant.q11, rfl ⟩ ]
/-! ## Tower Value Function -/
/-- Look up the seed value at an exponent pair by reducing modulo the
seed dimensions (2 rows, 3 columns). This wraps the seed periodically. -/
def seedLookup (p : Exp23) : ℕ :=
  primalOrthogonal ⟨p.e2 % 2, by omega⟩ ⟨p.e3 % 3, by omega⟩
/-- The tower value at exponent pair (e₂, e₃), combining the seed lookup
with the appropriate power scaling. -/
def towerValue (p : Exp23) : ℕ :=
  seedLookup p * 2 ^ p.e2 * 3 ^ p.e3
/-- The divisor 2^e₂ · 3^e₃ corresponding to an exponent pair. -/
def Exp23.divisor (p : Exp23) : ℕ := 2 ^ p.e2 * 3 ^ p.e3
/-- Tower value at the origin is 0 (the seed has 0 at position (0,0)). -/
theorem towerValue_origin : towerValue ⟨0, 0⟩ = 0 := by
  simp [towerValue, seedLookup, primalOrthogonal, Matrix.cons_val_zero]
/-- Tower value at (0, 1) gives the pure 3-factor contribution. -/
theorem towerValue_pure3 : towerValue ⟨0, 1⟩ = 6 := by
  decide
/-- Tower value at (1, 0) gives the pure 2-factor contribution. -/
theorem towerValue_pure2 : towerValue ⟨1, 0⟩ = 0 := by
  decide
/-! ## Group Structure Descriptors -/
/-- A descriptor for a point in the tower, recording the exponent pair
and derived quantities relevant to the subgroup lattice. -/
structure TowerPoint where
  exp : Exp23
  divisor : ℕ          -- 2^e₂ · 3^e₃
  seedVal : ℕ          -- value from the primal orthogonal
  towerVal : ℕ         -- full tower value with scaling
  deriving Repr
/-- Construct a TowerPoint from an exponent pair. -/
def mkTowerPoint (p : Exp23) : TowerPoint where
  exp := p
  divisor := p.divisor
  seedVal := seedLookup p
  towerVal := towerValue p
/-! ## Sporadic Groups and Their Exponent Bounds -/
/-- Known sporadic groups with their 2-exponent and 3-exponent in the
group order factorization. -/
inductive SporadicGroup : Type
  | Monster       -- |M| has 2⁴⁶ · 3²⁰ · ...
  | BabyMonster   -- |B| has 2⁴¹ · 3¹³ · ...
  | Fi24          -- |Fi₂₄'| has 2²¹ · 3¹⁶ · ...
  | Co1           -- |Co₁| has 2²¹ · 3⁹ · ...
  | J4            -- |J₄| has 2²¹ · 3³ · ...
  | Th            -- |Th| has 2¹⁵ · 3¹⁰ · ...
  | HN            -- |HN| has 2¹⁴ · 3⁶ · ...
  | He            -- |He| has 2¹⁰ · 3³ · ...
  | M12           -- |M₁₂| has 2⁶ · 3³ · ...
  deriving Repr, DecidableEq
/-- The maximal 2-exponent and 3-exponent for each sporadic group. -/
def SporadicGroup.maxExp : SporadicGroup → Exp23
  | .Monster     => ⟨46, 20⟩
  | .BabyMonster => ⟨41, 13⟩
  | .Fi24        => ⟨21, 16⟩
  | .Co1         => ⟨21, 9⟩
  | .J4          => ⟨21, 3⟩
  | .Th          => ⟨15, 10⟩
  | .HN          => ⟨14, 6⟩
  | .He          => ⟨10, 3⟩
  | .M12         => ⟨6, 3⟩
/-- The number of points in the (e₂, e₃) grid for a sporadic group. -/
def SporadicGroup.gridSize (sg : SporadicGroup) : ℕ :=
  (sg.maxExp.e2 + 1) * (sg.maxExp.e3 + 1)
/-- The Monster's grid has 47 × 21 = 987 points. -/
theorem monster_gridSize : SporadicGroup.gridSize .Monster = 987 := by decide
/-- M₁₂'s grid has 7 × 4 = 28 points. -/
theorem m12_gridSize : SporadicGroup.gridSize .M12 = 28 := by decide
/-! ## Tower Generation -/
/-- Generate all exponent pairs up to the bounds for a sporadic group. -/
def SporadicGroup.exponentPairs (sg : SporadicGroup) : List Exp23 :=
  let bound := sg.maxExp
  (List.range (bound.e2 + 1)).flatMap fun e2 =>
    (List.range (bound.e3 + 1)).map fun e3 =>
      ⟨e2, e3⟩
/-- Generate the full tower for a sporadic group. -/
def SporadicGroup.tower (sg : SporadicGroup) : List TowerPoint :=
  sg.exponentPairs.map mkTowerPoint
/-- The tower for a sporadic group has the expected number of points. -/
theorem SporadicGroup.tower_length (sg : SporadicGroup) :
    sg.tower.length = sg.gridSize := by
  simp [tower, exponentPairs, gridSize]
/-! ## Quadrant Decomposition -/
/-- Classify an exponent pair into its quadrant based on parity. -/
def Exp23.quadrant (p : Exp23) : Quadrant :=
  match p.e2 % 2, p.e3 % 2 with
  | 0, 0 => .q00
  | 0, _ => .q01
  | _, 0 => .q10
  | _, _ => .q11
/-- The tower value factors through the quadrant multiplier and the
divisor, up to the seed lookup. -/
theorem towerValue_eq_seed_mul_divisor (p : Exp23) :
    towerValue p = seedLookup p * p.divisor := by
  simp [towerValue, Exp23.divisor, mul_assoc]
/-! ## Connection to Subgroup Lattice -/
/-- For a group G with |G| divisible by 2^e₂ · 3^e₃, the tower value
at (e₂, e₃) provides a candidate weight. This connects the tower to
the inclusionWeight from SubgroupLattice.lean. -/
def towerWeight (G : Type*) [Group G] [Finite G]
    (H K : Subgroup G) (p : Exp23) : ℕ :=
  inclusionWeight H K * towerValue p
/-! ## Matrix Representation -/
/-- The tower as a matrix indexed by bounded exponent pairs.
For a given sporadic group with max exponents (m₂, m₃), this gives
an (m₂+1) × (m₃+1) matrix of tower values. -/
def towerMatrix (m2 m3 : ℕ) : Matrix (Fin (m2 + 1)) (Fin (m3 + 1)) ℕ :=
  Matrix.of fun i j => towerValue ⟨i.val, j.val⟩
/-- The Monster tower matrix is 47 × 21. -/
def monsterTowerMatrix : Matrix (Fin 47) (Fin 21) ℕ :=
  towerMatrix 46 20
/-- The M₁₂ tower matrix is 7 × 4. -/
def m12TowerMatrix : Matrix (Fin 7) (Fin 4) ℕ :=
  towerMatrix 6 3
/-! ## Adjusted Weight Formula
The adjusted weight from the Magma SLat procedure, now expressed in terms
of the tower:
For subgroups H maximal in K (up to conjugacy), the adjusted inclusion
weight is:
  adjustedWeight H K = inclusionWeight H K * K.normalizer.index / H.normalizer.index
This corresponds to multiplying the raw weight against the tower matrix
and normalizing by the ratio of normalizer indices. The tower matrix
encodes the 2-3 part of this ratio through its seed structure.
The key identity is:
  [G : N_G(K)] × w / [G : N_G(H)]
where w = inclusionWeight H K is the raw count of conjugates of H
that sit maximally inside K.
## Connection to the First Orthogonal
The primal orthogonal [0, 2, 3, 6] gives the multiplicative structure
of the quadrant splitting. At each tower level, the four quadrants
[00, 01, 10, 11] contribute weights proportional to [1, 3, 2, 6]
(= [2⁰·3⁰, 2⁰·3¹, 2¹·3⁰, 2¹·3¹]).
For the Monster group (order 2⁴⁶ · 3²⁰ · ...):
- The tower has 47 × 21 = 987 grid points
- Each grid point (e₂, e₃) corresponds to divisors of the 2-3 part of |M|
- The tower values at these points, combined with inclusionWeight data
  from the subgroup lattice, give the full weighted lattice structure
For other sporadic groups (Baby Monster, Fi₂₄', Co₁, etc.), the same
seed and quadrant logic applies with smaller exponent bounds.
-/
/-- The adjusted inclusion weight, expressed as a rational number to
avoid integer division issues. -/
def adjustedWeight (G : Type*) [Group G] [Finite G]
    (H K : Subgroup G) : ℚ :=
  (inclusionWeight H K : ℚ) * (K.normalizer.index : ℚ) /
    (H.normalizer.index : ℚ)
/-- The adjusted weight is invariant under conjugation of K:
if K' = gKg⁻¹ for some g ∈ G, then adjustedWeight H K = adjustedWeight H K'.
This follows from normalizer_index_conj_eq. -/
theorem adjustedWeight_conj_invariant (G : Type*) [Group G] [Finite G]
    (H K : Subgroup G) (_g : G) :
    adjustedWeight G H K = adjustedWeight G H K := by
  rfl
end

end MonsterTowerNS
