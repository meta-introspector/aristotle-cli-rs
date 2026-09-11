import Mathlib

/-!
# Niemeier Lattices and Umbral Moonshine

The 23 Niemeier lattices are the even unimodular lattices of rank 24 that
have a non-empty root system. Together with the Leech lattice (which has
no roots), they form the complete classification of even unimodular lattices
in dimension 24.

Each Niemeier lattice N_X is uniquely determined by its root system X, which
is a direct sum of ADE root systems all sharing the **same Coxeter number** h.
The total rank of the root system equals 24.

## Umbral Moonshine

For each Niemeier root system X, umbral moonshine associates a finite group G^X
and a family of mock modular forms. When X = A₁²⁴ (Coxeter number h = 2),
the group G^X is the Mathieu group M₂₄, recovering Mathieu moonshine.
-/

namespace NiemeierUmbral

/-! ## Root System Types -/

/-- ADE type of a simple root system component. -/
inductive ADEType where
  | A : ℕ → ADEType  -- A_n (rank n, n ≥ 1)
  | D : ℕ → ADEType  -- D_n (rank n, n ≥ 4)
  | E6 : ADEType
  | E7 : ADEType
  | E8 : ADEType
  deriving DecidableEq, Repr

namespace ADEType

/-- The rank of a simple root system. -/
def rank : ADEType → ℕ
  | A n => n
  | D n => n
  | E6 => 6
  | E7 => 7
  | E8 => 8

/-- The Coxeter number of a simple root system. -/
def coxeterNumber : ADEType → ℕ
  | A n => n + 1
  | D n => 2 * (n - 1)
  | E6 => 12
  | E7 => 18
  | E8 => 30

/-- The number of positive roots. -/
def numPositiveRoots : ADEType → ℕ
  | A n => n * (n + 1) / 2
  | D n => n * (n - 1)
  | E6 => 36
  | E7 => 63
  | E8 => 120

/-- The number of roots (= 2 × positive roots). -/
def numRoots : ADEType → ℕ
  | t => 2 * t.numPositiveRoots

/-- The determinant of the Cartan matrix. -/
def cartanDet : ADEType → ℕ
  | A n => n + 1
  | D n => 4
  | E6 => 3
  | E7 => 2
  | E8 => 1

end ADEType

/-! ## Root System Component -/

/-- A component of a Niemeier root system: an ADE type with multiplicity. -/
structure RootComponent where
  type : ADEType
  mult : ℕ
  deriving DecidableEq, Repr

/-- Total rank contributed by a component. -/
def RootComponent.totalRank (c : RootComponent) : ℕ :=
  c.mult * c.type.rank

/-- Total roots contributed by a component. -/
def RootComponent.totalRoots (c : RootComponent) : ℕ :=
  c.mult * c.type.numRoots

/-! ## Niemeier Lattice Data -/

/-- A Niemeier lattice, characterized by its root system. -/
structure NiemeierData where
  /-- Index from 1 to 23 -/
  index : ℕ
  /-- Short label for the root system -/
  label : String
  /-- Components of the root system -/
  components : List RootComponent
  /-- The common Coxeter number -/
  coxeter : ℕ
  deriving Repr

namespace NiemeierData

/-- Total rank of the root system. -/
def totalRank (N : NiemeierData) : ℕ :=
  (N.components.map RootComponent.totalRank).sum

/-- Total number of roots. -/
def totalRoots (N : NiemeierData) : ℕ :=
  (N.components.map RootComponent.totalRoots).sum

/-- Number of irreducible components (with multiplicity). -/
def numComponents (N : NiemeierData) : ℕ :=
  (N.components.map (·.mult)).sum

/-- Check that all components share the same Coxeter number. -/
def coxeterUniform (N : NiemeierData) : Bool :=
  N.components.all (fun c => c.type.coxeterNumber == N.coxeter)

end NiemeierData

/-! ## The 23 Niemeier Lattices -/

def N01 : NiemeierData := ⟨1, "A1^24", [⟨.A 1, 24⟩], 2⟩
def N02 : NiemeierData := ⟨2, "A2^12", [⟨.A 2, 12⟩], 3⟩
def N03 : NiemeierData := ⟨3, "A3^8", [⟨.A 3, 8⟩], 4⟩
def N04 : NiemeierData := ⟨4, "A4^6", [⟨.A 4, 6⟩], 5⟩
def N05 : NiemeierData := ⟨5, "A5^4·D4", [⟨.A 5, 4⟩, ⟨.D 4, 1⟩], 6⟩
def N06 : NiemeierData := ⟨6, "D4^6", [⟨.D 4, 6⟩], 6⟩
def N07 : NiemeierData := ⟨7, "A6^4", [⟨.A 6, 4⟩], 7⟩
def N08 : NiemeierData := ⟨8, "A7^2·D5^2", [⟨.A 7, 2⟩, ⟨.D 5, 2⟩], 8⟩
def N09 : NiemeierData := ⟨9, "A8^3", [⟨.A 8, 3⟩], 9⟩
def N10 : NiemeierData := ⟨10, "A9^2·D6", [⟨.A 9, 2⟩, ⟨.D 6, 1⟩], 10⟩
def N11 : NiemeierData := ⟨11, "D6^4", [⟨.D 6, 4⟩], 10⟩
def N12 : NiemeierData := ⟨12, "A11·D7·E6", [⟨.A 11, 1⟩, ⟨.D 7, 1⟩, ⟨.E6, 1⟩], 12⟩
def N13 : NiemeierData := ⟨13, "E6^4", [⟨.E6, 4⟩], 12⟩
def N14 : NiemeierData := ⟨14, "A12^2", [⟨.A 12, 2⟩], 13⟩
def N15 : NiemeierData := ⟨15, "D8^3", [⟨.D 8, 3⟩], 14⟩
def N16 : NiemeierData := ⟨16, "A15·D9", [⟨.A 15, 1⟩, ⟨.D 9, 1⟩], 16⟩
def N17 : NiemeierData := ⟨17, "A17·E7", [⟨.A 17, 1⟩, ⟨.E7, 1⟩], 18⟩
def N18 : NiemeierData := ⟨18, "D10·E7^2", [⟨.D 10, 1⟩, ⟨.E7, 2⟩], 18⟩
def N19 : NiemeierData := ⟨19, "D12^2", [⟨.D 12, 2⟩], 22⟩
def N20 : NiemeierData := ⟨20, "A24", [⟨.A 24, 1⟩], 25⟩
def N21 : NiemeierData := ⟨21, "D16·E8", [⟨.D 16, 1⟩, ⟨.E8, 1⟩], 30⟩
def N22 : NiemeierData := ⟨22, "E8^3", [⟨.E8, 3⟩], 30⟩
def N23 : NiemeierData := ⟨23, "D24", [⟨.D 24, 1⟩], 46⟩

/-- The complete list of 23 Niemeier lattices. -/
def allNiemeier : List NiemeierData :=
  [N01, N02, N03, N04, N05, N06, N07, N08, N09, N10,
   N11, N12, N13, N14, N15, N16, N17, N18, N19, N20,
   N21, N22, N23]

/-! ## Computational Verification -/

#eval allNiemeier.map (fun N => (N.label, N.totalRank))
#eval allNiemeier.map (fun N => (N.label, N.coxeterUniform))
#eval allNiemeier.map (fun N => (N.label, N.totalRoots))
#eval (allNiemeier.map (·.coxeter)).eraseDups

/-! ## Proved Theorems -/

theorem niemeier_count : allNiemeier.length = 23 := by native_decide

/-- Every Niemeier lattice has rank 24. -/
theorem all_ranks_24 : ∀ N ∈ allNiemeier, N.totalRank = 24 := by native_decide

/-- Every Niemeier lattice has uniform Coxeter number. -/
theorem all_coxeter_uniform : ∀ N ∈ allNiemeier, N.coxeterUniform = true := by native_decide

/-- The indices are 1 through 23. -/
theorem all_indices : (allNiemeier.map (·.index)) = List.range' 1 23 := by native_decide

/-! ## Root Counts -/

theorem N01_roots : N01.totalRoots = 48 := by native_decide
theorem N02_roots : N02.totalRoots = 72 := by native_decide
theorem N03_roots : N03.totalRoots = 96 := by native_decide
theorem N04_roots : N04.totalRoots = 120 := by native_decide
theorem N05_roots : N05.totalRoots = 144 := by native_decide
theorem N06_roots : N06.totalRoots = 144 := by native_decide
theorem N07_roots : N07.totalRoots = 168 := by native_decide
theorem N08_roots : N08.totalRoots = 192 := by native_decide
theorem N09_roots : N09.totalRoots = 216 := by native_decide
theorem N10_roots : N10.totalRoots = 240 := by native_decide
theorem N11_roots : N11.totalRoots = 240 := by native_decide
theorem N12_roots : N12.totalRoots = 288 := by native_decide
theorem N13_roots : N13.totalRoots = 288 := by native_decide
theorem N14_roots : N14.totalRoots = 312 := by native_decide
theorem N15_roots : N15.totalRoots = 336 := by native_decide
theorem N16_roots : N16.totalRoots = 384 := by native_decide
theorem N17_roots : N17.totalRoots = 432 := by native_decide
theorem N18_roots : N18.totalRoots = 432 := by native_decide
theorem N19_roots : N19.totalRoots = 528 := by native_decide
theorem N20_roots : N20.totalRoots = 600 := by native_decide
theorem N21_roots : N21.totalRoots = 720 := by native_decide
theorem N22_roots : N22.totalRoots = 720 := by native_decide
theorem N23_roots : N23.totalRoots = 1104 := by native_decide

/-- A₁²⁴ has 48 roots: each A₁ contributes 2 roots. -/
theorem N01_roots_explanation : 24 * 2 = 48 := by norm_num

/-- E₈³ has 720 roots: each E₈ contributes 240 roots. -/
theorem N22_roots_explanation : 3 * 240 = 720 := by norm_num

/-- D₂₄ has 1104 roots: D_n has 2n(n-1) roots. -/
theorem N23_roots_explanation : 2 * 24 * 23 = 1104 := by norm_num

/-! ## Special Lattices and Monster Connections -/

/-- The Leech lattice has 196560 minimal vectors (kissing number).
    196883 - 196560 = 323 = 17 × 19 (both supersingular primes). -/
theorem leech_monster_gap : 196883 - 196560 = 323 := by norm_num
theorem leech_gap_factors : 323 = 17 * 19 := by norm_num

/-- N₂₁ = D₁₆E₈ has the same Coxeter number as E₈³. -/
theorem D16E8_same_coxeter_as_E8cubed : N21.coxeter = N22.coxeter := by native_decide

/-- N₁ = A₁²⁴ is the Mathieu moonshine lattice (G^X = M₂₄). -/
theorem A1_24_coxeter : N01.coxeter = 2 := by native_decide

/-! ## Umbral Groups -/

/-- Umbral group data: (lattice index, group label, group order). -/
structure UmbralGroupData where
  latticeIndex : ℕ
  groupLabel : String
  groupOrder : ℕ
  deriving Repr, Inhabited

/-- Known umbral group data for the 23 Niemeier lattices. -/
def umbralGroups : List UmbralGroupData := [
  ⟨1, "M24", 244823040⟩,
  ⟨2, "2.M12", 190080⟩,
  ⟨3, "2.AGL3(2)", 2688⟩,
  ⟨4, "2.S5", 240⟩,
  ⟨5, "GL2(3)/Q8", 48⟩,
  ⟨6, "3.S6", 2160⟩,
  ⟨7, "SL2(3)", 24⟩,
  ⟨8, "Dih4", 8⟩,
  ⟨9, "Dih6", 12⟩,
  ⟨10, "Z4", 4⟩,
  ⟨11, "2^2.S3", 24⟩,
  ⟨12, "Z2", 2⟩,
  ⟨13, "S3", 6⟩,
  ⟨14, "Z2", 2⟩,
  ⟨15, "S3", 6⟩,
  ⟨16, "Z2", 2⟩,
  ⟨17, "Z2", 2⟩,
  ⟨18, "Z2", 2⟩,
  ⟨19, "Z2", 2⟩,
  ⟨20, "1", 1⟩,
  ⟨21, "Z2", 2⟩,
  ⟨22, "1", 1⟩,
  ⟨23, "1", 1⟩
]

/-- |M₂₄| = 2¹⁰ · 3³ · 5 · 7 · 11 · 23. -/
theorem M24_order : 244823040 = 2^10 * 3^3 * 5 * 7 * 11 * 23 := by norm_num

/-- The first umbral group is M₂₄. -/
theorem umbral_N01_is_M24 : (umbralGroups.head!).groupLabel = "M24" := by native_decide

/-- 23 umbral groups (one per Niemeier lattice). -/
theorem umbral_count : umbralGroups.length = 23 := by native_decide

/-! ## Coxeter Number Distribution -/

/-- List of all Coxeter numbers (with multiplicity). -/
def allCoxeterNumbers : List ℕ := allNiemeier.map (·.coxeter)

theorem coxeter_numbers_list :
    allCoxeterNumbers = [2, 3, 4, 5, 6, 6, 7, 8, 9, 10, 10, 12, 12, 13, 14, 16, 18, 18, 22, 25, 30, 30, 46] := by
  native_decide

/-- Number of distinct Coxeter numbers. -/
theorem num_distinct_coxeter : allCoxeterNumbers.eraseDups.length = 18 := by native_decide

/-- Niemeier lattices sorted by Coxeter number. -/
theorem niemeier_sorted_by_coxeter :
    List.Pairwise (· ≤ ·) (allNiemeier.map (·.coxeter)) := by native_decide

/-! ## Mixed vs Pure Type -/

/-- Count lattices with more than one component type. -/
def numMixedType : ℕ := (allNiemeier.filter (fun N => N.components.length > 1)).length

theorem mixed_type_count : numMixedType = 8 := by native_decide

def numPureType : ℕ := (allNiemeier.filter (fun N => N.components.length == 1)).length

theorem pure_type_count : numPureType = 15 := by native_decide

theorem mixed_plus_pure : numMixedType + numPureType = 23 := by native_decide

/-! ## Total Roots Across All Lattices -/

def totalRootsAll : ℕ := (allNiemeier.map (·.totalRoots)).sum

#eval totalRootsAll

/-- The number of even unimodular lattices in dimension 24 is 24 (= 23 Niemeier + Leech). -/
theorem even_unimodular_24 : allNiemeier.length + 1 = 24 := by native_decide

/-! ## Root System Properties -/

/-- E₈ has 240 roots. -/
theorem E8_roots : ADEType.E8.numRoots = 240 := by native_decide

/-- E₇ has 126 roots. -/
theorem E7_roots : ADEType.E7.numRoots = 126 := by native_decide

/-- E₆ has 72 roots. -/
theorem E6_roots : ADEType.E6.numRoots = 72 := by native_decide

/-- Coxeter number of A_n is n+1. -/
theorem A_coxeter (n : ℕ) : (ADEType.A n).coxeterNumber = n + 1 := rfl

/-- Coxeter number of D_n is 2(n-1). -/
theorem D_coxeter (n : ℕ) : (ADEType.D n).coxeterNumber = 2 * (n - 1) := rfl

/-! ## Rank-Coxeter Relationship -/

def rankTimesCoxeter (N : NiemeierData) : ℕ := N.totalRank * N.coxeter

#eval allNiemeier.map (fun N => (N.label, rankTimesCoxeter N, N.totalRoots))

end NiemeierUmbral
