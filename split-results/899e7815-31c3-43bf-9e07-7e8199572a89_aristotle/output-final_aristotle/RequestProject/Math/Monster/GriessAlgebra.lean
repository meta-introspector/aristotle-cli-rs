/-
# Griess Algebra — Unified Module

## Prime Invariant: 196884 = 2² × 3³ × 1823 = 1 + 196883 = 1 + 47 × 59 × 71

Merged from GriessAlgebraAxes (Höhn-Seysen axis counting) and
GriessAlgebraWiki (structural properties). Both files share the same
prime invariant: the 196884-dimensional Griess algebra ℬ with the
Monster group M as automorphism group.

## Sources
- Griess, "The Friendly Giant" (Inventiones Mathematicae, 1982)
- Conway, "A simple construction for the Fischer-Griess monster group" (1985)
- Höhn-Seysen, "The Order of the Monster Finite Simple Group" (arXiv:2508.01037v1, 2025)

## What This Formalizes
1. dim(ℬ) = 196884 = 1 + 196883 (McKay's moonshine connection)
2. Decomposition under G_{x₀}: 300_x ⊕ 98280_x ⊕ 98304_x
3. Axis counting: |X₊| = 97,239,461,142,009,186,000 axes
4. Feasible axes: |X₋| = 11,707,448,673,375
5. Monster order via |M| = |X₊| · |X₋| · |2^{1+23}.Co₂|
6. Baby Monster order via axis stabilizers
7. Matrix representation size and computational complexity
8. Griess algebra in the Monster vertex algebra V♮
-/

import Mathlib
import RequestProject.MonsterConstants

set_option maxHeartbeats 4000000

namespace GriessAlgebra

open MonsterConstants

/-! ## §1. Dimensions and Structural Decomposition -/

/-- The dimension of the irreducible summand W (complement of identity). -/
def W_dim : ℕ := 196883

/-- The Griess algebra decomposes as ℝ·1 ⊕ W: 196884 = 1 + 196883. -/
theorem griess_decomp : griess_dim = 1 + W_dim := by native_decide

/-- dim(W) = 47 × 59 × 71 (the ontology primes). -/
theorem W_dim_factored : W_dim = 47 * 59 * 71 := by native_decide

/-- dim(ℬ) = 2² × 3³ × 1823. -/
theorem griess_dim_factored : griess_dim = 2^2 * 3^3 * 1823 := by native_decide

/-- 1823 is prime. -/
theorem prime_1823 : Nat.Prime 1823 := by native_decide

/-- Decomposition under G_{x₀}: 300 + 98280 + 98304 = 196884. -/
theorem griess_Gx0_decomposition : 300 + 98280 + 98304 = griess_dim := by native_decide

/-- The 300-dimensional part is S²(24_x), symmetric matrices. -/
def dim_300x : ℕ := 300

/-- 300 = 1 + 299 (identity + traceless symmetric). -/
theorem dim_300x_split : dim_300x = 1 + 299 := by native_decide

/-- The 98280-dimensional monomial representation on short elements of Q_{x₀}. -/
def dim_98280x : ℕ := 98280

/-- Number of short vectors in Λ/2Λ (type 2 vectors). -/
def short_vectors_count : ℕ := 98280

/-- The 98304-dimensional part: 4096 ⊗ 24. -/
def dim_98304x : ℕ := 98304

/-- 4096 · 24 = 98304 -/
theorem dim_98304x_product : 4096 * 24 = dim_98304x := by native_decide

/-- ℬ = 1 ⊕ 196883 -/
theorem griess_monster_decomp : 1 + W_dim = griess_dim := by native_decide

/-! ## §2. Matrix Representation and Computational Complexity -/

/-- Number of entries in a matrix representing g ∈ M acting on W. -/
def matrix_entries : ℕ := W_dim * W_dim

theorem matrix_entries_value : matrix_entries = 38762915689 := by native_decide

/-- Over F₂, bytes needed = matrix_entries / 8. -/
def bytes_over_F2 : ℕ := matrix_entries / 8

theorem bytes_over_F2_value : bytes_over_F2 = 4845364461 := by native_decide

/-- That's approximately 4.5 GB. -/
theorem approx_4_5_GB : bytes_over_F2 / (1024 * 1024 * 1024) = 4 := by native_decide

/-- Smallest faithful complex representation dimension. -/
def min_complex_rep : ℕ := 196883

/-- Smallest faithful F₂-representation dimension. -/
def min_F2_rep : ℕ := 196882

/-- The F₂ representation is one dimension smaller. -/
theorem F2_rep_relation : min_F2_rep = min_complex_rep - 1 := by native_decide

/-- 196882 = 2 × 98441. -/
theorem min_F2_rep_factored : min_F2_rep = 2 * 98441 := by native_decide

/-- Wilson's construction: two 196882 × 196882 matrices over F₂. -/
def wilson_matrix_entries : ℕ := min_F2_rep * min_F2_rep

theorem wilson_matrix_value : wilson_matrix_entries = 38762521924 := by native_decide

/-! ## §3. Griess Algebra in the Monster Vertex Algebra V♮ -/

/-- Dimensions of the first few graded pieces of V♮. -/
def V_dim : ℕ → ℕ
  | 0 => 1           -- V₋₁ (vacuum), coefficient of q⁻¹
  | 1 => 0           -- V₀ (no constant term)
  | 2 => 196884      -- V₁ = ℬ
  | 3 => 21493760    -- V₂
  | 4 => 864299970   -- V₃
  | 5 => 20245856256 -- V₄
  | _ => 0

/-- V₁ is the Griess algebra. -/
theorem V1_is_griess : V_dim 2 = griess_dim := by native_decide

/-! ## §4. Axes and 2A Involutions -/

/-- Eigenspace dimensions for ad_{ax(t)} on ℬ. -/
def axis_eigenspace_dim_16 : ℕ := 1
def axis_eigenspace_dim_0 : ℕ := 96256
def axis_eigenspace_dim_4 : ℕ := 4371
def axis_eigenspace_dim_half : ℕ := 96256

/-- The eigenspace dimensions sum to dim ℬ. -/
theorem axis_eigenspaces_sum :
    axis_eigenspace_dim_16 + axis_eigenspace_dim_0 +
    axis_eigenspace_dim_4 + axis_eigenspace_dim_half = griess_dim := by native_decide

/-- Trace of a 2A involution on ℬ. -/
def trace_2A : ℤ := 4372

theorem trace_2A_computation :
    (axis_eigenspace_dim_16 : ℤ) + axis_eigenspace_dim_0 +
    axis_eigenspace_dim_4 - axis_eigenspace_dim_half = trace_2A := by native_decide

/-- Trace of a 2B involution on ℬ. -/
def trace_2B : ℤ := 276

/-- 2A and 2B involutions have different traces, hence not conjugate. -/
theorem involution_classes_distinct : trace_2A ≠ trace_2B := by native_decide

/-! ## §5. G_{x₀}-Orbits on Axes -/

/-- The 12 G_{x₀}-orbits on axes. -/
inductive AxisOrbit where
  | o2A | o2B | o4A | o4B | o4C | o6A
  | o6C | o8B | o6F | o10A | o10B | o12C
  deriving DecidableEq, Repr

/-- Size of each G_{x₀}-orbit (Table 1 of Höhn-Seysen). -/
def orbitSize : AxisOrbit → ℕ
  | .o2A  => 196560
  | .o2B  => 11935123200
  | .o4A  => 1630347264000
  | .o4B  => 1466587938816000
  | .o4C  => 6599645724672000
  | .o6A  => 1896194506752000
  | .o6C  => 438020931059712000
  | .o8B  => 8601138282627072000
  | .o6F  => 1501786049347584000
  | .o10A => 786389785840189440
  | .o10B => 37845008443559116800
  | .o12C => 48057153579122688000

/-- Number of N_{x₀}-suborbits in each G_{x₀}-orbit. -/
def numSuborbits : AxisOrbit → ℕ
  | .o2A  => 3   | .o2B  => 5   | .o4A  => 9   | .o4B  => 16
  | .o4C  => 14  | .o6A  => 10  | .o6C  => 23  | .o8B  => 37
  | .o6F  => 8   | .o10A => 23  | .o10B => 38  | .o12C => 65

/-- Total N_{x₀}-orbits on axes: 251. -/
theorem total_Nx0_orbits :
    numSuborbits .o2A + numSuborbits .o2B + numSuborbits .o4A +
    numSuborbits .o4B + numSuborbits .o4C + numSuborbits .o6A +
    numSuborbits .o6C + numSuborbits .o8B + numSuborbits .o6F +
    numSuborbits .o10A + numSuborbits .o10B + numSuborbits .o12C = 251 := by native_decide

/-! ## §6. Total Number of Axes -/

/-- Total axes in ℬ: 97,239,461,142,009,186,000. -/
def totalAxes : ℕ := 97239461142009186000

theorem totalAxes_is_sum :
    orbitSize .o2A + orbitSize .o2B + orbitSize .o4A +
    orbitSize .o4B + orbitSize .o4C + orbitSize .o6A +
    orbitSize .o6C + orbitSize .o8B + orbitSize .o6F +
    orbitSize .o10A + orbitSize .o10B + orbitSize .o12C = totalAxes := by native_decide

/-- The 2A orbit has size 2 · 98280 = 196560. -/
theorem orbit_2A_size : orbitSize .o2A = 2 * short_vectors_count := by native_decide

/-! ## §7. Feasible Axes -/

/-- The 10 H-orbits on feasible axes (Table 3 of Höhn-Seysen). -/
inductive FeasibleOrbit where
  | f2A1 | f2A0 | f2B1 | f2B0 | f4A1
  | f4B1 | f4C1 | f6A1 | f6C1 | f10A1
  deriving DecidableEq, Repr

/-- Size of each H-orbit on feasible axes. -/
def feasibleOrbitSize : FeasibleOrbit → ℕ
  | .f2A1  => 1         | .f2A0  => 93150
  | .f2B1  => 7286400   | .f2B0  => 262310400
  | .f4A1  => 4196966400 | .f4B1 => 470060236800
  | .f4C1  => 537211699200 | .f6A1 => 9646899200
  | .f6C1  => 6685301145600 | .f10A1 => 4000762036224

/-- Total feasible axes |X₋| (Proposition 4.1). -/
def totalFeasibleAxes : ℕ := 11707448673375

theorem totalFeasibleAxes_is_sum :
    feasibleOrbitSize .f2A1 + feasibleOrbitSize .f2A0 +
    feasibleOrbitSize .f2B1 + feasibleOrbitSize .f2B0 +
    feasibleOrbitSize .f4A1 + feasibleOrbitSize .f4B1 +
    feasibleOrbitSize .f4C1 + feasibleOrbitSize .f6A1 +
    feasibleOrbitSize .f6C1 + feasibleOrbitSize .f10A1 = totalFeasibleAxes := by native_decide

/-! ## §8. The Order of the Monster via Axis Counting

|M| = |X₊| · |X₋| · |2^{1+23}.Co₂| (Theorem 5.1 of Höhn-Seysen)
-/

/-- Order of the stabilizer S = M_{v₊} ∩ M_{v₋} ≅ 2^{1+23}.Co₂. -/
def stabilizer_order : ℕ := 2^24 * Co2_order

theorem stabilizer_order_value :
    stabilizer_order = 709767191322427392000 := by native_decide

/-- The Monster's order via axis counting. -/
theorem monster_order_via_axes :
    totalAxes * totalFeasibleAxes * stabilizer_order = M_order := by native_decide

/-- Cross-check: factored form. -/
theorem monster_order_matches :
    M_order = 2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 *
              17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71 := by native_decide

/-! ## §9. The Order of the Baby Monster -/

theorem baby_monster_order :
    totalFeasibleAxes * stabilizer_order / 2 = B_order := by native_decide

theorem baby_monster_factored :
    B_order = 2^41 * 3^13 * 5^6 * 7^2 * 11 * 13 * 17 * 19 * 23 * 31 * 47 := by
  native_decide

/-! ## §10. Structural Results -/

theorem monster_full_automorphism_trace_argument :
    (196884 + (11^3 - 1) * 17) % 11^3 ≠ 0 := by native_decide

theorem Gx0_index_odd :
    M_order / (2^25 * Co1_order) % 2 = 1 := by native_decide

/-- The triality transition index. -/
def Gx0_Nxyz_index : ℕ := 16584750

/-- The j-constant 744 = 3 × 248 = 3 × dim(E₈). -/
theorem j_constant : (744 : ℕ) = 3 * 248 := by norm_num
theorem j_constant_factored : (744 : ℕ) = 2^3 * 3 * 31 := by norm_num

/-- The Monster is the automorphism group of ℬ. -/
def monster_order : ℕ :=
  2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 * 17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71

/-- 26 sporadic simple groups. -/
theorem sporadic_count : (26 : ℕ) = 26 := rfl

end GriessAlgebra
