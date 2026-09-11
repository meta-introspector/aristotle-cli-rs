import Mathlib
/-!
# The Four-Element Base Field of the Shape-Sheaf
We formalize the classification of positive natural numbers into four "elements"
based on their 2-adic and 3-adic valuations (equivalently, divisibility by 2 and 3).
## The Four Elements
- **VOID (0,0)**: coprime to 6 — divisible by neither 2 nor 3
- **FIRE (1,0)**: 2-only — divisible by 2 but not 3
- **WATER (0,1)**: 3-only — divisible by 3 but not 2
- **AIR (1,1)**: 2×3 fusion — divisible by both 2 and 3 (i.e., by 6)
These four classes partition ℕ+ (equivalently, ℕ \ {0}).
## Shape Vocabulary
A "shape" is a 25-bit vector (modeled as `Fin 25 → Bool`). Each shape is classified
into one of the four elements by its bits at positions 0 (for prime 2) and 1 (for prime 3).
## Inverted Index
We define the inverted index that maps each element to the set of shapes belonging
to that element class.
-/
open scoped BigOperators Classical
set_option maxHeartbeats 800000
/-! ### The Four Elements -/
/-- The four base elements, classified by (v₂ > 0, v₃ > 0). -/
inductive BaseElement : Type
  | void   -- (0,0): coprime to 6
  | fire   -- (1,0): divisible by 2, not 3
  | water  -- (0,1): divisible by 3, not 2
  | air    -- (1,1): divisible by 6
  deriving DecidableEq, Fintype, Repr
namespace BaseElement
/-- Classify a positive natural number by its divisibility by 2 and 3. -/
def classify (n : ℕ) : BaseElement :=
  if n % 2 = 0 then
    if n % 3 = 0 then .air else .fire
  else
    if n % 3 = 0 then .water else .void
/-- Alternative classification using 2-adic and 3-adic valuations. -/
def classifyByVal (n : ℕ) : BaseElement :=
  if 0 < n.factorization 2 then
    if 0 < n.factorization 3 then .air else .fire
  else
    if 0 < n.factorization 3 then .water else .void
/-
For n ≥ 1, the two classifiers agree.
-/
theorem classify_eq_classifyByVal {n : ℕ} (hn : 0 < n) :
    classify n = classifyByVal n := by
      by_cases h2 : 2 ∣ n <;> by_cases h3 : 3 ∣ n <;> simp_all +decide [ Nat.factorization_eq_zero_iff, Nat.dvd_iff_mod_eq_zero ];
      · unfold classify classifyByVal;
        rw [ if_pos h2, if_pos h3, if_pos ( Nat.pos_of_ne_zero ( Finsupp.mem_support_iff.mp ( by { exact Nat.mem_primeFactors.mpr ⟨ Nat.prime_two, Nat.dvd_of_mod_eq_zero h2, by linarith ⟩ } ) ) ), if_pos ( Nat.pos_of_ne_zero ( Finsupp.mem_support_iff.mp ( by { exact Nat.mem_primeFactors.mpr ⟨ Nat.prime_three, Nat.dvd_of_mod_eq_zero h3, by linarith ⟩ } ) ) ) ];
      · unfold classify classifyByVal;
        simp +decide [ h2, h3, Nat.factorization_eq_zero_of_not_dvd, Nat.dvd_iff_mod_eq_zero ];
        exact Finsupp.mem_support_iff.mp ( by contrapose! h3; simp_all +decide [ ← Nat.dvd_iff_mod_eq_zero, Nat.Prime.dvd_iff_one_le_factorization ] );
      · -- Since $n$ is odd and divisible by 3, we have $n.factorization 2 = 0$ and $n.factorization 3 > 0$.
        have h_fact : n.factorization 2 = 0 ∧ n.factorization 3 > 0 := by
          exact ⟨ Nat.factorization_eq_zero_of_not_dvd fun h => by have := Nat.mod_eq_zero_of_dvd h; aesop, Nat.pos_of_ne_zero fun h => by have := Nat.dvd_of_mod_eq_zero h3; simp_all +decide [ Nat.factorization_eq_zero_iff ] ⟩;
        unfold classify classifyByVal; aesop;
      · unfold classify classifyByVal;
        rw [ Nat.factorization_eq_zero_of_not_dvd, Nat.factorization_eq_zero_of_not_dvd ] <;> simp_all +decide [ Nat.dvd_iff_mod_eq_zero ]
/-! ### Partition Properties -/
/-- The set of positive naturals in each element class. -/
def elementClass (e : BaseElement) : Set ℕ :=
  {n : ℕ | 0 < n ∧ classify n = e}
/-
VOID consists of numbers coprime to 6.
-/
theorem void_iff {n : ℕ} (hn : 0 < n) :
    classify n = .void ↔ ¬(2 ∣ n) ∧ ¬(3 ∣ n) := by
      unfold classify;
      lia
/-
FIRE consists of numbers divisible by 2 but not 3.
-/
theorem fire_iff {n : ℕ} (hn : 0 < n) :
    classify n = .fire ↔ (2 ∣ n) ∧ ¬(3 ∣ n) := by
      unfold classify;
      split_ifs <;> simp_all +decide [ Nat.dvd_iff_mod_eq_zero ]
/-
WATER consists of numbers divisible by 3 but not 2.
-/
theorem water_iff {n : ℕ} (hn : 0 < n) :
    classify n = .water ↔ ¬(2 ∣ n) ∧ (3 ∣ n) := by
      unfold classify; split_ifs <;> simp_all +decide [ Nat.dvd_iff_mod_eq_zero ] ;
/-
AIR consists of numbers divisible by 6.
-/
theorem air_iff {n : ℕ} (hn : 0 < n) :
    classify n = .air ↔ (2 ∣ n) ∧ (3 ∣ n) := by
      unfold classify; split_ifs <;> simp_all +decide [ Nat.dvd_iff_mod_eq_zero ] ;
/-
The four element classes partition ℕ+: every positive natural gets exactly one label.
-/
theorem classify_exhaustive (n : ℕ) :
    classify n = .void ∨ classify n = .fire ∨
    classify n = .water ∨ classify n = .air := by
      unfold classify; split_ifs <;> tauto;
/-
The element classes are pairwise disjoint (immediate from functionality of classify).
-/
theorem elementClass_disjoint {e₁ e₂ : BaseElement} (h : e₁ ≠ e₂) :
    Disjoint (elementClass e₁) (elementClass e₂) := by
      exact Set.disjoint_left.mpr fun n hn₁ hn₂ => h <| hn₁.2.symm.trans hn₂.2
/-
The element classes cover all of ℕ+.
-/
theorem elementClass_cover :
    (⋃ e : BaseElement, elementClass e) = {n : ℕ | 0 < n} := by
      ext; simp [elementClass]
/-! ### Shape Vocabulary -/
/-- A shape is a 25-bit vector, one bit per prime in {2,3,5,7,...,97}. -/
abbrev Shape := Fin 25 → Bool
/-- The first 25 primes, indexed by Fin 25. -/
noncomputable def primeAt : Fin 25 → ℕ := fun i => Nat.nth Nat.Prime i
/-
Bit 0 corresponds to prime 2.
-/
theorem primeAt_zero : primeAt ⟨0, by omega⟩ = 2 := by
  -- By definition of `primeAt`, we know that `primeAt 0 = 2`.
  simp [primeAt]
/-
Bit 1 corresponds to prime 3.
-/
theorem primeAt_one : primeAt ⟨1, by omega⟩ = 3 := by
  unfold primeAt; norm_num
/-- Classify a shape by its bits at positions 0 and 1 (primes 2 and 3). -/
def classifyShape (s : Shape) : BaseElement :=
  match s ⟨0, by omega⟩, s ⟨1, by omega⟩ with
  | false, false => .void
  | true,  false => .fire
  | false, true  => .water
  | true,  true  => .air
/-
A shape is VOID iff both bit₂ and bit₃ are off.
-/
theorem classifyShape_void (s : Shape) :
    classifyShape s = .void ↔ s ⟨0, by omega⟩ = false ∧ s ⟨1, by omega⟩ = false := by
      cases h : s ⟨ 0, by decide ⟩ <;> cases h' : s ⟨ 1, by decide ⟩ <;> simp_all +decide [ classifyShape ]
/-
A shape is FIRE iff bit₂ is on and bit₃ is off.
-/
theorem classifyShape_fire (s : Shape) :
    classifyShape s = .fire ↔ s ⟨0, by omega⟩ = true ∧ s ⟨1, by omega⟩ = false := by
      unfold classifyShape; aesop;
/-
A shape is WATER iff bit₂ is off and bit₃ is on.
-/
theorem classifyShape_water (s : Shape) :
    classifyShape s = .water ↔ s ⟨0, by omega⟩ = false ∧ s ⟨1, by omega⟩ = true := by
      cases h : s ⟨ 0, by decide ⟩ <;> cases h' : s ⟨ 1, by decide ⟩ <;> simp_all +decide [ classifyShape ]
/-
A shape is AIR iff both bit₂ and bit₃ are on.
-/
theorem classifyShape_air (s : Shape) :
    classifyShape s = .air ↔ s ⟨0, by omega⟩ = true ∧ s ⟨1, by omega⟩ = true := by
      cases h : s ⟨ 0, by decide ⟩ <;> cases h' : s ⟨ 1, by decide ⟩ <;> simp_all +decide [ classifyShape ]
/-! ### The D₄ Symmetry Group -/
/-- The 8 symmetries of D₄, acting on a 2D grid. -/
inductive D4Symmetry : Type
  | id | rot90 | rot180 | rot270
  | reflH | reflV | reflD1 | reflD2
  deriving DecidableEq, Fintype, Repr
/-- The 5 traversal modes for reading a grid. -/
inductive TraversalMode : Type
  | rowMajor      -- left-to-right, top-to-bottom
  | boustrophedon  -- alternating direction per row
  | columnMajor   -- top-to-bottom, left-to-right
  | diagonal      -- diagonal sweep
  | spiral        -- outside-in spiral
  deriving DecidableEq, Fintype, Repr
/-- A shape observation records which symmetry and traversal produced it. -/
structure ShapeObservation where
  page : ℕ
  symmetry : D4Symmetry
  traversal : TraversalMode
  shape : Shape
  deriving DecidableEq, Repr
/-
Total number of shape observations per page: 8 × 5 = 40.
-/
theorem observations_per_page :
    Fintype.card D4Symmetry * Fintype.card TraversalMode = 40 := by
      rfl
/-! ### Inverted Index -/
/-- The inverted index: given a set of observations, find all observations
    whose shape has a given element classification. -/
def invertedIndexByElement (obs : List ShapeObservation) (e : BaseElement) :
    List ShapeObservation :=
  obs.filter (fun o => classifyShape o.shape = e)
/-- Find all observations whose shape has a specific bit set (for a specific prime). -/
def invertedIndexByPrime (obs : List ShapeObservation) (i : Fin 25) :
    List ShapeObservation :=
  obs.filter (fun o => o.shape i = true)
/-- Find all observations invariant under a specific symmetry.
    (Placeholder: in practice you'd check if applying the symmetry yields the same shape.) -/
def invertedIndexBySymmetry (obs : List ShapeObservation) (sym : D4Symmetry) :
    List ShapeObservation :=
  obs.filter (fun o => o.symmetry = sym)
/-- Find all observations from a specific traversal mode. -/
def invertedIndexByTraversal (obs : List ShapeObservation) (t : TraversalMode) :
    List ShapeObservation :=
  obs.filter (fun o => o.traversal = t)
end BaseElement
