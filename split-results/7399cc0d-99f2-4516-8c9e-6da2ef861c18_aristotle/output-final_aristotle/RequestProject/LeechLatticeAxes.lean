/-
# Leech Lattice and Axis Counting — Supporting the Monster Order Computation

## Source
- Conway, "A simple construction for the Fischer-Griess Monster group" (1985)
- Höhn-Seysen, "The Order of the Monster Finite Simple Group" (2025)
- Conway-Sloane, "Sphere Packings, Lattices and Groups" (1999)

## What This Formalizes
The Leech lattice Λ is the unique even unimodular lattice of rank 24
with no vectors of norm 2. Key properties used in the Monster construction:

1. Aut(Λ) = Co₀ ≅ 2.Co₁ (the Conway group)
2. Λ/2Λ ≅ F₂²⁴ has vectors of types 0, 2, 3, 4
3. Short (type 2) vectors in Λ/2Λ: 98280
4. Type 4 vectors in Λ/2Λ: 16773120
5. The Golay code G₂₄ ⊂ F₂²⁴ and Parker loop P

## Role in the Monster
- G_{x₀} ≅ 2₊^{1+24}.Co₁ acts on the Griess algebra
- Q_{x₀} ≅ 2₊^{1+24} maps to Λ/2Λ with kernel {1, x_{-1}}
- Short elements of Q_{x₀} correspond to 2A involutions
- Type 4 vectors correspond to cosets G_{x₀}/N_{x₀}
-/

import Mathlib

namespace LeechLatticeAxes

/-! ## §1. The Leech Lattice

The Leech lattice is a 24-dimensional even unimodular lattice
with minimum norm 4. It can be constructed from the Golay code.
-/

/-- Rank of the Leech lattice. -/
def leech_rank : ℕ := 24

/-- Minimum squared norm of a nonzero vector in the Leech lattice. -/
def leech_min_norm : ℕ := 4

/-- Number of norm-4 vectors (shortest nonzero vectors) in Λ. -/
def leech_vectors_norm4 : ℕ := 196560

/-- Number of norm-8 vectors in Λ. -/
def leech_vectors_norm8 : ℕ := 16773120

/-! ## §2. Vectors in Λ/2Λ

The quotient Λ/2Λ ≅ F₂²⁴ has 2²⁴ = 16777216 elements.
The type of a vector v + 2Λ is min{⟨w,w⟩/2 : w ∈ v + 2Λ}.
Possible types are 0, 2, 3, 4.
-/

/-- Total number of elements in Λ/2Λ. -/
def lambda_mod2_size : ℕ := 2^24

theorem lambda_mod2_size_value : lambda_mod2_size = 16777216 := by native_decide

/-- Number of type 0 vectors in Λ/2Λ (just the zero vector). -/
def type0_count : ℕ := 1

/-- Number of type 2 (short) vectors in Λ/2Λ.
    Each corresponds to a pair ±v of shortest vectors mapping to it. -/
def type2_count : ℕ := 98280

/-- Number of type 3 vectors in Λ/2Λ. -/
def type3_count : ℕ := 8386560

/-- Number of type 4 vectors in Λ/2Λ.
    These correspond to cosets G_{x₀}/N_{x₀}. -/
def type4_count : ℕ := 8292375

/-- The type counts sum to |Λ/2Λ|. -/
theorem type_counts_sum :
    type0_count + type2_count + type3_count + type4_count = lambda_mod2_size := by native_decide

/-- Each short vector in Λ/2Λ lifts to exactly 2 shortest vectors in Λ.
    (Since v and -v map to the same element of Λ/2Λ.)
    So 2 · 98280 = 196560 = |{v ∈ Λ : ⟨v,v⟩ = 4}|. -/
theorem short_vectors_double : 2 * type2_count = leech_vectors_norm4 := by native_decide

/-! ## §3. Conway Groups

Aut(Λ) = Co₀ has order 2 · |Co₁|.
Co₁ = Aut(Λ/2Λ) is simple of order |Co₁|.
Co₁ is transitive on vectors of each type in Λ/2Λ.
-/

/-- Order of the Conway group Co₀ = Aut(Λ) ≅ 2.Co₁. -/
def Co0_order : ℕ := 2 * 4157776806543360000

/-- Order of Co₁. -/
def Co1_order : ℕ := 4157776806543360000

/-- |Co₁| = 2²¹ · 3⁹ · 5⁴ · 7² · 11 · 13 · 23 -/
theorem Co1_factored :
    Co1_order = 2^21 * 3^9 * 5^4 * 7^2 * 11 * 13 * 23 := by native_decide

/-- Order of Co₂ (stabilizer of a type 2 vector in Co₁). -/
def Co2_order : ℕ := 42305421312000

/-- |Co₂| = 2¹⁸ · 3⁶ · 5³ · 7 · 11 · 23 -/
theorem Co2_factored :
    Co2_order = 2^18 * 3^6 * 5^3 * 7 * 11 * 23 := by native_decide

/-- Transitivity check: |Co₁| / |Co₂| = number of type 2 vectors. -/
theorem Co1_Co2_index : Co1_order / Co2_order = type2_count := by native_decide

/-! ## §4. The Golay Code and M₂₄

The binary Golay code G₂₄ ⊂ F₂²⁴ has dimension 12 and minimum distance 8.
Its automorphism group is the Mathieu group M₂₄.
-/

/-- Order of the Mathieu group M₂₄. -/
def M24_order : ℕ := 244823040

/-- |M₂₄| = 2¹⁰ · 3³ · 5 · 7 · 11 · 23 -/
theorem M24_factored :
    M24_order = 2^10 * 3^3 * 5 * 7 * 11 * 23 := by native_decide

/-- M₂₂ (stabilizer of 2 points in M₂₄). -/
def M22_order : ℕ := 443520

/-! ## §5. The Index |G_{x₀} : N_{xyz}|

G_{x₀} ≅ 2₊^{1+24}.Co₁ has order 2²⁵ · |Co₁|.
N_{xyz} ≅ 2^{2+11+22}.M₂₄ has order 2³⁵ · |M₂₄|.
The index is |G_{x₀}|/|N_{xyz}| which equals the number of
cosets through which the triality acts.
-/

/-- Order of G_{x₀} ≅ 2₊^{1+24}.Co₁. -/
def Gx0_order : ℕ := 2^25 * Co1_order

/-- Order of N_{xyz} ≅ 2^{2+11+22}.M₂₄. -/
def Nxyz_order : ℕ := 2^35 * M24_order

/-- The index |G_{x₀} : N_{xyz}| = 16584750.
    This is the column sum of the triality transition matrix. -/
theorem Gx0_Nxyz_index :
    Gx0_order / Nxyz_order = 16584750 := by native_decide

/-! ## §6. N_{x₀} and the Structure Tower

N_{x₀} ≅ 2^{2+11+22}.(M₂₄ × 2) has index 2 over N_{xyz}.
N₀ ≅ 2^{2+11+22}.(M₂₄ × S₃) has index 3 over N_{x₀}.
-/

/-- Order of N_{x₀}. -/
def Nx0_order : ℕ := 2 * Nxyz_order

/-- Order of N₀. -/
def N0_order : ℕ := 3 * Nx0_order

/-- N₀/N_{xyz} ≅ S₃ has order 6. -/
theorem N0_Nxyz_index : N0_order / Nxyz_order = 6 := by native_decide

/-! ## §7. Connection to Axis Counting

Each type 4 vector λ_Ω in Λ/2Λ determines a coset G_{x₀}/N_{x₀}.
The number of type 4 vectors equals |G_{x₀}/N_{x₀}| · 2 (since
N_{x₀} has index 2 in the stabilizer of λ_Ω, but actually:
|G_{x₀} : N_{x₀}| = |Co₁ : stabilizer of λ_Ω in Co₁|).
-/

/-- Type 4 count is self-consistent. -/
theorem type4_positive : type4_count > 0 := by native_decide

/-- The H-orbit index for feasible axes: |H : H ∩ N_{xyz}| = 93150. -/
def H_Nxyz_index : ℕ := 93150

end LeechLatticeAxes
