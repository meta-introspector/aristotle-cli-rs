/-
# Moonshine Spiral and Golden Ratio Computations

This module brings together the golden ratio computations for each moonshine group,
the Fibonacci spiral structure of the q-expansion, and the divisor-box-sheaf picture
in its two conformal views.

## The q-expansion as an infinite Fibonacci-like spiral

The j-invariant's q-expansion j(τ) = q⁻¹ + 744 + 196884q + 21493760q² + ...
traces a spiral through the (log₂, log₃) plane. The key properties:

1. **Growth**: c(n) ~ e^(4π√n) / (√2 · n^(3/4)) means the spiral expands
2. **Irrational slope**: ln(3)/ln(2) is irrational, so the spiral never closes
3. **Monster structure**: Each coefficient decomposes into Monster irrep dimensions

## Golden ratios for all sporadic groups

Every sporadic simple group has 2 and 3 as its two smallest prime divisors,
so they all share the primary golden ratio φ = ln(3)/ln(2).
The secondary ratios (using higher primes) distinguish the groups.

## Two conformal views unified

- **Log₃ view (additive)**: The divisor lattice becomes an additive coordinate system
  where multiplicative refinement = additive displacement
- **Graded architecture view**: Each divisor d determines a layer with
  depth = v_p(d) and width = d/p^v_p(d)
-/

import Mathlib
import RequestProject.MonsterLattice
import RequestProject.MonsterDepthWidth
import RequestProject.MonsterSheaf

/-! ## Boxes around divisor sets

The original code defined `boxesAroundDivs`: given a set of divisors DS,
filter those that divide n and map each to its subgroup box.
This gives the collection of sublattices indexed by the divisor set. -/

/-- Given a list of candidate divisors, filter those dividing `n` and
    return the corresponding subgroup boxes. -/
def boxesAroundDivs (n : ℕ) (DS : List ℕ) : List (AddSubgroup (ZMod n)) :=
  (DS.filter (· ∣ n)).map (subgroupBox n)

/-! ## Approximate subset containment in boxes

For a divisor d | n and a subset A of ℤ/nℤ, the "approximate subset in box"
consists of elements of the d-box that are related to elements of A via
multiplication by d. -/

/-- The set of elements in the d-box that are "close to" elements of A,
    in the sense that they are multiples of d that map into A. -/
def approxSubsetInBox (n d : ℕ) (A : Set (ZMod n)) : Set (ZMod n) :=
  { x | x ∈ (subgroupBox n d : Set (ZMod n)) ∧
        ∃ a ∈ A, ∃ k : ℤ, x = k • (d : ZMod n) + a }

/-! ## Golden ratio numerical properties

The moonshine golden ratio ln(3)/ln(2) ≈ 1.585 has deep connections to
the growth of Monster coefficients. Here we prove key algebraic identities. -/

/-- The golden ratio satisfies: logb 2 3 > 1 (since 3 > 2). -/
theorem goldenRatio_gt_one : (1 : ℝ) < Real.logb 2 3 := by
  rw [Real.lt_logb_iff_rpow_lt (by norm_num : (1:ℝ) < 2) (by positivity)]
  simp; norm_num

/-- The golden ratio satisfies: logb 2 3 < 2 (since 3 < 4 = 2²). -/
theorem goldenRatio_lt_two : Real.logb 2 3 < (2 : ℝ) := by
  rw [Real.logb_lt_iff_lt_rpow (by norm_num : (1:ℝ) < 2) (by positivity)]
  simp; norm_num

/-! ## Spiral growth properties

The j-function coefficients grow exponentially. We can verify this for
the first few coefficients and establish structural properties. -/

/-- The j-coefficients are strictly increasing (after the constant term). -/
theorem j_coeffs_increasing :
    (196884 : ℕ) < 21493760 ∧
    (21493760 : ℕ) < 864299970 ∧
    (864299970 : ℕ) < 20245856256 ∧
    (20245856256 : ℕ) < 333202640600 := by
  exact ⟨by norm_num, by norm_num, by norm_num, by norm_num⟩

/-- McKay's observation extended: the first three j-coefficients decompose into
    Monster irrep dimensions.
    c₁ = 196884 = 1 + 196883
    c₂ = 21493760 = 1 + 196883 + 21296876
    c₃ = 864299970 = 2·1 + 2·196883 + 21296876 + 842609326 -/
theorem mckay_extended :
    (196884 : ℕ) = 1 + 196883 ∧
    (21493760 : ℕ) = 1 + 196883 + 21296876 ∧
    (864299970 : ℕ) = 2 * 1 + 2 * 196883 + 21296876 + 842609326 := by
  exact ⟨by norm_num, by norm_num, by norm_num⟩

/-! ## The (v₂, v₃) grid as Fibonacci rectangle

The Monster's grid has 47 × 21 = 987 = F₁₆ points.
We can push this further: 47 and 21 are close to consecutive
Fibonacci numbers (F₈ = 21, and 47 is between F₉ = 34 and F₁₀ = 55).

The fact that 987 = F₁₆ is a Fibonacci number connects the Monster's
prime structure to the golden ratio φ = (1+√5)/2 ≈ 1.618,
while the moonshine golden ratio is ln(3)/ln(2) ≈ 1.585.
These two "golden ratios" are close but distinct. -/

/-- The classical golden ratio φ = (1 + √5)/2. -/
noncomputable def classicalGoldenRatio : ℝ := (1 + Real.sqrt 5) / 2

/-- The classical golden ratio is positive. -/
theorem classicalGoldenRatio_pos : 0 < classicalGoldenRatio := by
  unfold classicalGoldenRatio
  positivity

/-- The classical golden ratio satisfies φ² = φ + 1. -/
theorem classicalGoldenRatio_sq :
    classicalGoldenRatio ^ 2 = classicalGoldenRatio + 1 := by
  unfold classicalGoldenRatio
  have h5 : Real.sqrt 5 ^ 2 = 5 := Real.sq_sqrt (by norm_num)
  ring_nf
  nlinarith

/-- Fibonacci numbers satisfy F(n+2) = F(n) + F(n+1). -/
theorem fib_rec (n : ℕ) : fib (n + 2) = fib n + fib (n + 1) := by rfl

/-- F₁₅ = 610 -/
theorem fib_15_eq : fib 15 = 610 := by native_decide

/-- F₁₇ = 1597 -/
theorem fib_17_eq : fib 17 = 1597 := by native_decide

/-- Fibonacci check: F₁₅ + F₁₆ = F₁₇ -/
theorem fib_15_16_17 : fib 15 + fib 16 = fib 17 := by native_decide

/-! ## Sporadic group golden ratio data

For each sporadic group G, we record:
- |G| (group order)
- (v₂, v₃) (the primary valuation pair)
- Grid size = (v₂+1)(v₃+1)
- Primary golden ratio = ln(3)/ln(2) (shared by all)
- Secondary primes and their valuations

All sporadic simple groups have the same primary golden ratio since
they all have 2 and 3 as their two smallest prime divisors. -/

/-- Order of the Fischer group Fi₂₄'. -/
def Fi24Order : ℕ := 1255205709190661721292800

/-- Order of the Janko group J₁. -/
def J1Order : ℕ := 175560

/-- Order of the Janko group J₂ (Hall-Janko). -/
def J2Order : ℕ := 604800

/-- J₁ valuation pair. -/
theorem j1_val_pair :
    (J1Order.factorization 2, J1Order.factorization 3) = (3, 1) := by
  exact Prod.mk.injEq .. |>.mpr ⟨by native_decide, by native_decide⟩

/-- J₁ grid size = 4 × 2 = 8. -/
theorem j1_grid_size : (3 + 1) * (1 + 1) = 8 := by norm_num

/-- J₂ valuation pair: v₂ = 7, v₃ = 3. -/
theorem j2_val_pair :
    (J2Order.factorization 2, J2Order.factorization 3) = (7, 3) := by
  exact Prod.mk.injEq .. |>.mpr ⟨by native_decide, by native_decide⟩

/-- J₂ grid size = 8 × 4 = 32. -/
theorem j2_grid_size : (7 + 1) * (3 + 1) = 32 := by norm_num

/-- Fi₂₄' valuation pair. -/
theorem fi24_val_pair :
    (Fi24Order.factorization 2, Fi24Order.factorization 3) = (21, 16) := by
  exact Prod.mk.injEq .. |>.mpr ⟨by native_decide, by native_decide⟩

/-- Fi₂₄' grid size = 22 × 17 = 374. -/
theorem fi24_grid_size : (21 + 1) * (16 + 1) = 374 := by norm_num

/-! ## The moonshine golden ratio for each group's secondary prime pair

While all sporadic groups share φ(2,3) = ln(3)/ln(2) as the primary ratio,
the secondary ratio φ(p,q) for the next prime pair varies by group.

For the Monster: the next primes are 5, 7, giving secondary ratios
φ(2,5) = ln(5)/ln(2), φ(3,5) = ln(5)/ln(3), φ(5,7) = ln(7)/ln(5), etc.

Each of these is irrational (proven in MonsterSheaf.lean), so every
secondary spiral also never closes. -/

/-- The secondary golden ratio ln(5)/ln(2) for the Monster's (2,5) axis. -/
noncomputable def monsterSecondaryRatio_2_5 : ℝ := moonshineGoldenRatio 2 5

/-- The tertiary golden ratio ln(7)/ln(2) for the Monster's (2,7) axis. -/
noncomputable def monsterTertiaryRatio_2_7 : ℝ := moonshineGoldenRatio 2 7

/-- logb 2 5 > 2 (since 5 > 4 = 2²). -/
theorem logb_2_5_gt_two : (2 : ℝ) < Real.logb 2 5 := by
  rw [Real.lt_logb_iff_rpow_lt (by norm_num : (1:ℝ) < 2) (by positivity)]
  simp; norm_num

/-- logb 2 5 < 3 (since 5 < 8 = 2³). -/
theorem logb_2_5_lt_three : Real.logb 2 5 < (3 : ℝ) := by
  rw [Real.logb_lt_iff_lt_rpow (by norm_num : (1:ℝ) < 2) (by positivity)]
  simp; norm_num

/-- logb 2 7 > 2 (since 7 > 4 = 2²). -/
theorem logb_2_7_gt_two : (2 : ℝ) < Real.logb 2 7 := by
  rw [Real.lt_logb_iff_rpow_lt (by norm_num : (1:ℝ) < 2) (by positivity)]
  simp; norm_num

/-- logb 2 7 < 3 (since 7 < 8 = 2³). -/
theorem logb_2_7_lt_three : Real.logb 2 7 < (3 : ℝ) := by
  rw [Real.logb_lt_iff_lt_rpow (by norm_num : (1:ℝ) < 2) (by positivity)]
  simp; norm_num

/-! ## Tower law for golden ratios: compositional structure

The golden ratios compose via the change-of-base formula:
  φ(p,r) = φ(p,q) · φ(q,r)

This is the "restriction map" in the sheaf picture: moving from
the (p,r)-stalk to the (p,q) and (q,r) stalks is given by
multiplication of the golden ratios.

This was proven in MonsterSheaf.lean for (2,3,5).
Here we extend it to (2,3,5,7). -/

/-- Tower law for (2,3,7): logb 2 7 = logb 2 3 · logb 3 7. -/
theorem goldenRatio_tower_2_3_7 :
    moonshineGoldenRatio 2 7 = moonshineGoldenRatio 2 3 * moonshineGoldenRatio 3 7 := by
  unfold moonshineGoldenRatio
  ring_nf; norm_num

/-- Tower law for (2,5,7): logb 2 7 = logb 2 5 · logb 5 7. -/
theorem goldenRatio_tower_2_5_7 :
    moonshineGoldenRatio 2 7 = moonshineGoldenRatio 2 5 * moonshineGoldenRatio 5 7 := by
  unfold moonshineGoldenRatio
  ring_nf; norm_num

/-! ## Complete golden ratio table for the Monster's primes

The Monster has 15 prime divisors: 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71.
For each consecutive pair (pᵢ, pᵢ₊₁), there is a golden ratio
φ(pᵢ, pᵢ₊₁) = ln(pᵢ₊₁)/ln(pᵢ). These are the "local slopes" of the
Monster spiral at each prime transition.

The full spiral unfolds through the product:
  φ(2, 71) = φ(2,3) · φ(3,5) · φ(5,7) · ... · φ(59,71)

This product equals logb 2 71, a single number encoding the entire
Monster spiral's end-to-end slope. -/

/-- The Monster's primes, in order. -/
def monsterPrimes : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- Each element of monsterPrimes is indeed prime. -/
theorem monsterPrimes_all_prime : ∀ p ∈ monsterPrimes, Nat.Prime p := by decide

/-- Each element of monsterPrimes divides MonsterOrder. -/
theorem monsterPrimes_all_dvd : ∀ p ∈ monsterPrimes, p ∣ MonsterOrder := by
  simp only [monsterPrimes, List.mem_cons, List.mem_nil_iff, or_false]
  intro p hp
  rcases hp with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;>
    native_decide

/-- The full spiral slope from prime 2 to prime 71:
    logb 2 71, which is the product of all consecutive golden ratios. -/
noncomputable def monsterFullSpiralSlope : ℝ := Real.logb 2 71

/-- The full spiral slope is between 6 and 7 (since 2⁶ = 64 < 71 < 128 = 2⁷). -/
theorem monsterFullSpiralSlope_bounds :
    (6 : ℝ) < monsterFullSpiralSlope ∧ monsterFullSpiralSlope < 7 := by
  constructor
  · unfold monsterFullSpiralSlope
    rw [Real.lt_logb_iff_rpow_lt (by norm_num : (1:ℝ) < 2) (by positivity)]
    simp; norm_num
  · unfold monsterFullSpiralSlope
    rw [Real.logb_lt_iff_lt_rpow (by norm_num : (1:ℝ) < 2) (by positivity)]
    simp; norm_num

/-! ## Neural architecture interpretation

In the graded neural architecture view:
- Each divisor d | |M| defines a "layer" with depth v_p(d) and width d/p^v_p(d)
- A divisor chain d₁ | d₂ | ⋯ | dₖ defines a deepening architecture
- The Monster's full architecture has 47 binary layers and 21 ternary layers

The 987 = F₁₆ grid points enumerate all possible (binary depth, ternary depth)
combinations, each corresponding to a distinct architectural configuration. -/

/-- A "neural layer" is characterized by its depth and width at a given prime. -/
structure NeuralLayer where
  prime : ℕ
  layerDepth : ℕ
  layerWidth : ℕ
  deriving DecidableEq, Repr

/-- Convert a divisor to its neural layer description at a given prime. -/
def toNeuralLayer (p d : ℕ) : NeuralLayer where
  prime := p
  layerDepth := depth p d
  layerWidth := width p d

/-- The Monster's binary layer (at prime 2). -/
def monsterBinaryLayer : NeuralLayer := toNeuralLayer 2 MonsterOrder

/-- The Monster's ternary layer (at prime 3). -/
def monsterTernaryLayer : NeuralLayer := toNeuralLayer 3 MonsterOrder

/-- The Monster's binary layer has depth 46. -/
theorem monsterBinaryLayer_depth :
    monsterBinaryLayer.layerDepth = 46 := by native_decide

/-- The Monster's ternary layer has depth 20. -/
theorem monsterTernaryLayer_depth :
    monsterTernaryLayer.layerDepth = 20 := by native_decide
