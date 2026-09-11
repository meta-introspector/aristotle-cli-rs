import Mathlib

/-!
# Clifford Algebra Cl(3,0) and Geometric Algebra

We formalize the key structures from the Solfunmeme geometric algebra framework:
- The Clifford algebra Cl(3,0) over ℝ with the standard positive-definite quadratic form
- The geometric product (which is the algebra multiplication)
- Rotors as invertible elements satisfying R * R† = 1 and R† * R = 1
- The sandwich product R * M * R† preserves the algebra structure

## Emoji-to-Component Mapping
- Scalar (🟢): grade 0
- Vectors (➡️, ⬆️, 🔼): grade 1 (eₓ, eᵧ, e_z)
- Bivectors (🔲, 🔳, 🟥): grade 2 (eₓᵧ, eᵧ_z, e_zₓ)
- Trivector (🧊): grade 3 (eₓᵧ_z)
-/

noncomputable section

/-- The standard positive-definite quadratic form on ℝ³, Q(v) = v·v. -/
def stdQuadForm3 : QuadraticForm ℝ (EuclideanSpace ℝ (Fin 3)) :=
  LinearMap.BilinMap.toQuadraticMap
    ((innerₛₗ (𝕜 := ℝ) (E := EuclideanSpace ℝ (Fin 3))).restrictScalars ℝ
      |>.flip.restrictScalars ℝ)

/-- The Clifford algebra Cl(3,0) over ℝ. -/
abbrev Cl3 := CliffordAlgebra stdQuadForm3

/-- The embedding of ℝ³ into Cl(3,0). -/
def ι3 : EuclideanSpace ℝ (Fin 3) →ₗ[ℝ] Cl3 :=
  CliffordAlgebra.ι stdQuadForm3

/-- The standard basis vectors of ℝ³. -/
def stdBasis3 (i : Fin 3) : EuclideanSpace ℝ (Fin 3) :=
  EuclideanSpace.single i 1

/-- The basis vectors eₓ, eᵧ, e_z in the Clifford algebra. -/
def eVec (i : Fin 3) : Cl3 := ι3 (stdBasis3 i)

/-- The reverse (†) anti-automorphism of the Clifford algebra. -/
def clReverse : Cl3 →ₗ[ℝ] Cl3 := CliffordAlgebra.reverse

/-- A rotor is an element R whose reverse is a two-sided inverse:
    R * R† = 1 and R† * R = 1. -/
structure Rotor where
  val : Cl3
  mul_reverse : val * clReverse val = 1
  reverse_mul : clReverse val * val = 1

/-- The sandwich product: conjugation by a rotor. -/
def sandwichProduct (R : Rotor) (M : Cl3) : Cl3 :=
  R.val * M * clReverse R.val

/-
The reverse of a product reverses the order: (ab)† = b†a†.
-/
theorem reverse_mul_eq (a b : Cl3) :
    clReverse (a * b) = clReverse b * clReverse a := by
  unfold clReverse; aesop;

/-
The sandwich product by a rotor preserves multiplication.
-/
theorem sandwich_preserves_mul (R : Rotor) (M N : Cl3) :
    sandwichProduct R (M * N) = sandwichProduct R M * sandwichProduct R N := by
  unfold sandwichProduct; simp +decide [ mul_assoc ] ;
  simp +decide [ ← mul_assoc, R.reverse_mul ]

/-
The sandwich product preserves the unit element.
-/
theorem sandwich_preserves_one (R : Rotor) :
    sandwichProduct R 1 = 1 := by
  unfold sandwichProduct;
  simpa using R.mul_reverse

end