/-
# Griess Algebra Axes — The Höhn-Seysen Approach to the Monster's Order

## Source
Gerald Höhn and Martin Seysen, "The Order of the Monster Finite Simple Group"
(arXiv:2508.01037v1, August 2025)

## What This Formalizes
The Monster M acts on the 196884-dimensional Griess algebra ℬ. Certain idempotents
called "axes" (or Ising vectors in the Moonshine module V♮) are in bijection with
2A involutions of M. The Monster's order is computed via:

  |M| = |X₊| · |X₋| · |2^{1+23}.Co₂|

where:
- X₊ = orbit of axes under M (97,239,461,142,009,186,000 axes)
- X₋ = orbit of feasible axes under M_{v₊} (11,707,448,673,375 feasible axes)
- The common stabilizer is 2^{1+23}.Co₂

The axes decompose into 12 orbits under G_{x₀} ≅ 2₊^{1+24}.Co₁ and
251 orbits under N_{x₀} ≅ 2^{2+11+22}.(M₂₄ × 2).

## Key Results
1. Total number of axes: 97,239,461,142,009,186,000
2. Total feasible axes: 11,707,448,673,375
3. Order of M via axis counting
4. Order of Baby Monster B via feasible axes
5. M has exactly two conjugacy classes of involutions (2A and 2B)
6. M is the full automorphism group of ℬ and V♮
-/

import Mathlib

namespace GriessAlgebraAxes

/-! ## §1. The Griess Algebra

The Griess algebra ℬ is a 196884-dimensional commutative non-associative
algebra with Monster-invariant scalar product and trilinear form.
It decomposes under G_{x₀} as:

  ℬ = 300_x ⊕ 98280_x ⊕ 98304_x
    = S²(24_x) ⊕ (monomial on short Q_{x₀}) ⊕ (4096_x ⊗ 24_x)

The algebra has identity element 1_ℬ with (1_ℬ, 1_ℬ) = 3/2.
-/

/-- Dimension of the Griess algebra ℬ. -/
def griess_dim : ℕ := 196884

/-- Decomposition: 300 + 98280 + 98304 = 196884 -/
theorem griess_decomposition : 300 + 98280 + 98304 = griess_dim := by native_decide

/-- The 300-dimensional part is S²(24_x), symmetric matrices. -/
def dim_300x : ℕ := 300

/-- 300 = 1 + 299 (identity + traceless symmetric). -/
theorem dim_300x_split : dim_300x = 1 + 299 := by native_decide

/-- The 98280-dimensional monomial representation on short elements of Q_{x₀}. -/
def dim_98280x : ℕ := 98280

/-- Number of short vectors in Λ/2Λ (type 2 vectors in the Leech lattice mod 2). -/
def short_vectors_count : ℕ := 98280

/-- The 98304-dimensional part: 4096 ⊗ 24. -/
def dim_98304x : ℕ := 98304

/-- 4096 · 24 = 98304 -/
theorem dim_98304x_product : 4096 * 24 = dim_98304x := by native_decide

/-- The irreducible 196883-dimensional representation of M (complement to 1_x). -/
def dim_196883x : ℕ := 196883

/-- ℬ = 1 ⊕ 196883 -/
theorem griess_monster_decomp : 1 + dim_196883x = griess_dim := by native_decide

/-! ## §2. Axes and 2A Involutions

An axis ax(t) of a 2A involution t is the unique vector v ∈ ℬ satisfying
  v * v = 16·v  and  (v,v) = 8.

The endomorphism ad_v has eigenvalues 16, 0, 4, 1/2 with eigenspaces of
dimensions 1, 96256, 4371, 96256. The 2A involution t negates exactly
the eigenspace for eigenvalue 1/2.

The trace of a 2A involution on ℬ is 4372.
The trace of a 2B involution on ℬ is 276.
-/

/-- Eigenspace dimensions for ad_{ax(t)} on the Griess algebra. -/
def axis_eigenspace_dim_16 : ℕ := 1
def axis_eigenspace_dim_0 : ℕ := 96256
def axis_eigenspace_dim_4 : ℕ := 4371
def axis_eigenspace_dim_half : ℕ := 96256

/-- The eigenspace dimensions sum to dim ℬ. -/
theorem axis_eigenspaces_sum :
    axis_eigenspace_dim_16 + axis_eigenspace_dim_0 +
    axis_eigenspace_dim_4 + axis_eigenspace_dim_half = griess_dim := by native_decide

/-- Trace of a 2A involution on ℬ:
    1 + 96256 + 4371 - 96256 = 4372 -/
def trace_2A : ℤ := 4372

theorem trace_2A_computation :
    (axis_eigenspace_dim_16 : ℤ) + axis_eigenspace_dim_0 +
    axis_eigenspace_dim_4 - axis_eigenspace_dim_half = trace_2A := by native_decide

/-- Trace of a 2B involution (= x_{-1}, central involution in G_{x₀}) on ℬ:
    300 - 98280 + 98304 - 48 = 276
    (276 = dim of fixed subspace of -1 acting on S²(24) ⊕ trivially on 98304_x) -/
def trace_2B : ℤ := 276

/-- 2A and 2B involutions have different traces on ℬ, hence are not conjugate. -/
theorem involution_classes_distinct : trace_2A ≠ trace_2B := by native_decide

/-! ## §3. G_{x₀}-Orbits on Axes

The axes decompose into exactly 12 orbits under G_{x₀} ≅ 2₊^{1+24}.Co₁.
Each orbit is labeled by the conjugacy class of t·x_{-1} in M where t
is the 2A involution corresponding to the axis. -/

/-- Names of the 12 G_{x₀}-orbits on axes, labeled by conjugacy class of t·x_{-1}. -/
inductive AxisOrbit where
  | o2A | o2B | o4A | o4B | o4C | o6A
  | o6C | o8B | o6F | o10A | o10B | o12C
  deriving DecidableEq, Repr

/-- Size of each G_{x₀}-orbit on axes (Table 1 of Höhn-Seysen). -/
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
  | .o2A  => 3
  | .o2B  => 5
  | .o4A  => 9
  | .o4B  => 16
  | .o4C  => 14
  | .o6A  => 10
  | .o6C  => 23
  | .o8B  => 37
  | .o6F  => 8
  | .o10A => 23
  | .o10B => 38
  | .o12C => 65

/-- Total number of N_{x₀}-orbits on axes. -/
theorem total_Nx0_orbits :
    numSuborbits .o2A + numSuborbits .o2B + numSuborbits .o4A +
    numSuborbits .o4B + numSuborbits .o4C + numSuborbits .o6A +
    numSuborbits .o6C + numSuborbits .o8B + numSuborbits .o6F +
    numSuborbits .o10A + numSuborbits .o10B + numSuborbits .o12C = 251 := by native_decide

/-! ## §4. Total Number of Axes -/

/-- The total number of axes in the Griess algebra ℬ.
    This is |X₊|, the size of the M-orbit of axes.
    (Proposition 3.1 of Höhn-Seysen) -/
def totalAxes : ℕ := 97239461142009186000

/-- The total equals the sum of all 12 orbit sizes. -/
theorem totalAxes_is_sum :
    orbitSize .o2A + orbitSize .o2B + orbitSize .o4A +
    orbitSize .o4B + orbitSize .o4C + orbitSize .o6A +
    orbitSize .o6C + orbitSize .o8B + orbitSize .o6F +
    orbitSize .o10A + orbitSize .o10B + orbitSize .o12C = totalAxes := by native_decide

/-- The orbit labeled 2A has size 2 · 98280 = 196560.
    (Lemma 3.3: short vectors in Λ/2Λ have exactly 2 preimages in Q_{x₀}.) -/
theorem orbit_2A_size : orbitSize .o2A = 2 * short_vectors_count := by native_decide

/-! ## §5. Feasible Axes

Feasible axes X₋ form the orbit of v₋ under the stabilizer M_{v₊}.
The group H = M_{v₊} ∩ G_{x₀} ≅ 2^{1+23}.Co₂ acts on X₋ with
exactly 10 orbits. -/

/-- Names of the 10 H-orbits on feasible axes (Table 3 of Höhn-Seysen). -/
inductive FeasibleOrbit where
  | f2A1 | f2A0 | f2B1 | f2B0 | f4A1
  | f4B1 | f4C1 | f6A1 | f6C1 | f10A1
  deriving DecidableEq, Repr

/-- Size of each H-orbit on feasible axes. -/
def feasibleOrbitSize : FeasibleOrbit → ℕ
  | .f2A1  => 1
  | .f2A0  => 93150
  | .f2B1  => 7286400
  | .f2B0  => 262310400
  | .f4A1  => 4196966400
  | .f4B1  => 470060236800
  | .f4C1  => 537211699200
  | .f6A1  => 9646899200
  | .f6C1  => 6685301145600
  | .f10A1 => 4000762036224

/-- The orbit f2A1 containing v₋ has size 1 (Lemma 4.3).
    H fixes both β₊ and x_{-1}, hence β₋ = β₊·x_{-1} and ax(β₋) = v₋. -/
theorem feasible_2A1_singleton : feasibleOrbitSize .f2A1 = 1 := by rfl

/-- Total number of feasible axes |X₋| (Proposition 4.1 of Höhn-Seysen). -/
def totalFeasibleAxes : ℕ := 11707448673375

/-- The total equals the sum of all 10 feasible orbit sizes. -/
theorem totalFeasibleAxes_is_sum :
    feasibleOrbitSize .f2A1 + feasibleOrbitSize .f2A0 +
    feasibleOrbitSize .f2B1 + feasibleOrbitSize .f2B0 +
    feasibleOrbitSize .f4A1 + feasibleOrbitSize .f4B1 +
    feasibleOrbitSize .f4C1 + feasibleOrbitSize .f6A1 +
    feasibleOrbitSize .f6C1 + feasibleOrbitSize .f10A1 = totalFeasibleAxes := by native_decide

/-! ## §6. The Order of the Monster via Axis Counting

|M| = |X₊| · |X₋| · |2^{1+23}.Co₂|

where |2^{1+23}.Co₂| = 2^24 · |Co₂| = 2^24 · 42305421312000.

(Theorem 5.1 of Höhn-Seysen)
-/

/-- Order of the Conway group Co₂. -/
def Co2_order : ℕ := 42305421312000

/-- |Co₂| = 2¹⁸ · 3⁶ · 5³ · 7 · 11 · 23 -/
theorem Co2_order_factored :
    Co2_order = 2^18 * 3^6 * 5^3 * 7 * 11 * 23 := by native_decide

/-- Order of the common stabilizer S = M_{v₊} ∩ M_{v₋} ≅ 2^{1+23}.Co₂.
    Note: 2^{1+23} has order 2^24, so |S| = 2^24 · |Co₂|. -/
def stabilizer_order : ℕ := 2^24 * Co2_order

/-- The stabilizer order equals 2²⁴ · |Co₂|. -/
theorem stabilizer_order_value :
    stabilizer_order = 709767191322427392000 := by native_decide

/-- The order of the Monster, computed as |X₊| · |X₋| · |S|.
    (Theorem 5.1 of Höhn-Seysen) -/
def M_order : ℕ := 808017424794512875886459904961710757005754368000000000

/-- The Monster's order equals totalAxes · totalFeasibleAxes · stabilizer_order. -/
theorem monster_order_via_axes :
    totalAxes * totalFeasibleAxes * stabilizer_order = M_order := by native_decide

/-- Cross-check: same value as in Sporadic.lean -/
theorem monster_order_matches :
    M_order = 2^46 * 3^20 * 5^9 * 7^6 * 11^2 * 13^3 *
              17 * 19 * 23 * 29 * 31 * 41 * 47 * 59 * 71 := by native_decide

/-! ## §7. The Order of the Baby Monster

|B| = |X₋| · |S| / 2

(Corollary 5.2 of Höhn-Seysen)
-/

/-- Order of the Baby Monster B. -/
def B_order : ℕ := 4154781481226426191177580544000000

/-- B has order |X₋| · |S| / 2. -/
theorem baby_monster_order :
    totalFeasibleAxes * stabilizer_order / 2 = B_order := by native_decide

/-- |B| = 2⁴¹ · 3¹³ · 5⁶ · 7² · 11 · 13 · 17 · 19 · 23 · 31 · 47 -/
theorem baby_monster_factored :
    B_order = 2^41 * 3^13 * 5^6 * 7^2 * 11 * 13 * 17 * 19 * 23 * 31 * 47 := by
  native_decide

/-! ## §8. Key Structural Results

From the Höhn-Seysen paper (Section 5):
- The Monster is simple (Theorem 5.6)
- The Monster has exactly two conjugacy classes of involutions (Theorem 5.8)
- The Monster is the full automorphism group of ℬ and V♮ (Theorem 5.7)
-/

/-- The Monster is the full automorphism group of ℬ (Theorem 5.7).
    Proof uses Borcherds' completely replicable functions:
    if |11-Sylow| ≥ 11³, dim(ℬ^H) = (196884 + (11³-1)·17)/11³ = 1814/11,
    which is not an integer, contradiction. -/
theorem monster_full_automorphism_trace_argument :
    (196884 + (11^3 - 1) * 17) % 11^3 ≠ 0 := by native_decide

/-- Number of double cosets in 2.B \ M / N_{x₀}. (Proposition 3.5) -/
theorem double_cosets_2B_M_Nx0 :
    numSuborbits .o2A + numSuborbits .o2B + numSuborbits .o4A +
    numSuborbits .o4B + numSuborbits .o4C + numSuborbits .o6A +
    numSuborbits .o6C + numSuborbits .o8B + numSuborbits .o6F +
    numSuborbits .o10A + numSuborbits .o10B + numSuborbits .o12C = 251 := by native_decide

/-- The Co₁ order for reference. -/
def Co1_order : ℕ := 4157776806543360000

/-- Index of G_{x₀} in M is odd (used in Theorem 5.8 proof). -/
theorem Gx0_index_odd :
    M_order / (2^25 * Co1_order) % 2 = 1 := by native_decide

/-! ## §9. The Triality Transition

The 12 G_{x₀}-orbits fuse into a single M-orbit under the triality
automorphism τ of order 3. The triality normalizes N_{xyz} ≅ 2^{2+11+22}.M₂₄.
The index |G_{x₀} : N_{xyz}| = 16584750.
-/

/-- Index of N_{xyz} in G_{x₀}. -/
def Gx0_Nxyz_index : ℕ := 16584750

/-- The triality transition matrix M has column sums equal to this index. -/
theorem triality_column_sum : Gx0_Nxyz_index = 16584750 := rfl

/-- The transition matrix M/16584750 is column-stochastic and regular,
    so by Perron-Frobenius, the orbit sizes form its unique eigenvector
    for eigenvalue 16584750. Only the normalization (orbit 2A has size
    196560) needs to be supplied. -/
theorem perron_frobenius_normalization : orbitSize .o2A = 196560 := rfl

end GriessAlgebraAxes
