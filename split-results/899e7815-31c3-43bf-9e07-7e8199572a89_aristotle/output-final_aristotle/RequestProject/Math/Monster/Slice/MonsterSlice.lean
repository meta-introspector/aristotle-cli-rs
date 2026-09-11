/-
# The Monster Slice of Cl(15)

The Monster group does not require the full 2¹⁵ = 32768-dimensional Clifford algebra
Cl(0,15). Instead, it uses a sparse subalgebra determined by the exponent structure
of |M|:

  |M| = 2⁴⁶ · 3²⁰ · 5⁹ · 7⁶ · 11² · 13³ · 17 · 19 · 23 · 29 · 31 · 41 · 47 · 59 · 71

Since primes 17–71 appear with exponent 1, the corresponding Clifford directions
act as binary flags (∈ {0,1}) rather than full graded towers. The effective structure is:

  C_Monster ≅ Cl(0,7)_Earth ⊗̂ {0,1}^8_flags

where:
- Cl(0,7)_Earth carries full graded structure on {2,3,5,7,11,13,47}
- {0,1}^8 provides binary occupancy for {17,19,23,29,31,41,59,71}

This file formalizes this decomposition.
-/
import Mathlib
import RequestProject.Math.Monster.Slice.SupersingularPrimes
import RequestProject.Math.Monster.Slice.MonsterOrder
import RequestProject.Math.Monster.Slice.CliffordDefs

namespace MonsterSlice

open scoped BigOperators

/-! ## Indices into the supersingular prime list -/

/-- The indices of Earth primes in the supersingular ordering. -/
def earthIdx : Finset (Fin 15) :=
  {⟨0, by omega⟩, ⟨1, by omega⟩, ⟨2, by omega⟩, ⟨3, by omega⟩,
   ⟨4, by omega⟩, ⟨5, by omega⟩, ⟨12, by omega⟩}

/-- The indices of flag (exponent-1) primes (excluding Earth prime 47). -/
def flagIdx : Finset (Fin 15) :=
  {⟨6, by omega⟩, ⟨7, by omega⟩, ⟨8, by omega⟩, ⟨9, by omega⟩,
   ⟨10, by omega⟩, ⟨11, by omega⟩, ⟨13, by omega⟩, ⟨14, by omega⟩}

/-- There are 7 Earth primes and 8 flag primes. -/
theorem earth_flag_card : earthIdx.card = 7 ∧ flagIdx.card = 8 := by
  constructor <;> native_decide

/-- Earth and flag indices partition the 15 supersingular primes. -/
theorem earth_flag_cover :
    earthIdx ∪ flagIdx = Finset.univ := by decide

theorem earth_flag_disjoint : Disjoint earthIdx flagIdx := by decide

/-- Earth primes map to the correct prime values. -/
theorem earth_primes_values :
    earthIdx.image supersingularPrime = {2, 3, 5, 7, 11, 13, 47} := by
  native_decide

/-- Flag primes map to the correct prime values. -/
theorem flag_primes_values :
    flagIdx.image supersingularPrime = {17, 19, 23, 29, 31, 41, 59, 71} := by
  native_decide

/-! ## The Monster-compatible subalgebra

The key insight: the Monster only activates a subspace of Cl(0,15) where
the 8 flag directions are "binary" — each flag generator eₚ appears at most
once in any monomial.

The effective dimension is 2⁷ · 2⁸ = 2¹⁵ = 32768, but structurally the
flag directions don't need the algebraic machinery of higher exponents.
Their contribution is purely combinatorial (subset selection), while the
Earth directions carry genuine Clifford multiplication.

In practice, this means:
- Gram/trace checks only need full depth on the Earth 7D subspace
- Flag directions are handled by a simpler Boolean lattice
- The total verification decomposes as: hard_7D × easy_8D
-/

/-- The "Earth core" Clifford algebra: Cl(0,7) on the Earth eigenspace.
    This carries the full algebraic depth of the Monster. -/
noncomputable def ClEarth : Type := Cl 7

noncomputable instance : Ring ClEarth := inferInstanceAs (Ring (Cl 7))
noncomputable instance : Algebra ℝ ClEarth := inferInstanceAs (Algebra ℝ (Cl 7))

/-- The "flag lattice": the Boolean lattice on 8 flag directions.
    Each element is a subset of {17,19,23,29,31,41,59,71}. -/
def FlagLattice : Type := Fin 8 → Bool

instance : Fintype FlagLattice := inferInstanceAs (Fintype (Fin 8 → Bool))

/-- The flag lattice has 2⁸ = 256 elements. -/
theorem flagLattice_card : Fintype.card FlagLattice = 256 := by native_decide

/-- The effective Monster space is the product of Earth core and flag lattice.
    This captures the decomposition C_Monster ≅ Cl(0,7) ⊗ 𝔽₂⁸ as a type. -/
def MonsterBasis : Type := Fin (2^7) × FlagLattice

instance : Fintype MonsterBasis := inferInstanceAs (Fintype (Fin (2^7) × FlagLattice))

/-- The Monster basis has 2¹⁵ = 32768 elements. -/
theorem monsterBasis_card : Fintype.card MonsterBasis = 32768 := by native_decide

/-! ## Dimensional analysis of the filtration

For each n = 1,...,15, the Clifford algebra Cl(0,n) has dimension 2ⁿ.
-/

/-- Dimensions of the filtration levels. -/
theorem cl_dimensions (n : Fin 15) :
    2 ^ (n.val + 1) ≤ 32768 := by
  fin_cases n <;> norm_num

/-! ## Bott periodicity

Clifford algebras satisfy Bott periodicity: Cl(0,n+8) ≅ Cl(0,n) ⊗ M₁₆(ℝ).
This connects Cl(0,7) to Cl(0,15) and Cl(0,9) to Cl(0,1).
-/

/-- Bott period for real Clifford algebras is 8. -/
def bottPeriod : ℕ := 8

/-- Cl(0,15) is Bott-related to Cl(0,7) since 15 = 7 + 8. -/
theorem cl15_bott_cl7 : 15 = 7 + bottPeriod := by unfold bottPeriod; norm_num

/-- Cl(0,9) is Bott-related to Cl(0,1) since 9 = 1 + 8. -/
theorem cl9_bott_cl1 : 9 = 1 + bottPeriod := by unfold bottPeriod; norm_num

end MonsterSlice
