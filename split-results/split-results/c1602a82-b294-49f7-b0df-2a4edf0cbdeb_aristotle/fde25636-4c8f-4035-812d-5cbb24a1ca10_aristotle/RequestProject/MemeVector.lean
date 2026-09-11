/-
# Meme Vector Space and Transformation Matrix (T_SF)

Formalizes memes as vectors in ℝⁿ and the transformation matrix T_SF
as a linear operator. We prove that:
  1. Meme vectors form a finite-dimensional vector space
  2. The T_SF matrix acts as a linear map
  3. The Quasi Meta Eigenvector (V_QM) is characterized as an eigenvector
  4. Iterated application of T_SF scales eigenvectors by λ^n
-/
import Mathlib

open Matrix

/-!
## The Meme Vector Space

A meme is a vector in ℝ³ with components:
  - Blue Eye Intensity (E_b)
  - Red Claw Strength (C_r)
  - Mycelium Spread (T_m)
-/

/-- The three fungal trait indices for meme vectors. -/
inductive MemeIndex
  | BlueEye    -- E_b: Blue Eye Intensity
  | RedClaw    -- C_r: Red Claw Strength
  | Mycelium   -- T_m: Mycelium Spread
  deriving DecidableEq, Fintype, Repr

/-- A meme vector is a function from MemeIndex to ℝ. -/
abbrev MemeVector := MemeIndex → ℝ

/-- MemeVector forms a module over ℝ (i.e., a vector space). -/
noncomputable example : Module ℝ MemeVector := inferInstance

/-- The meme vector space is finite-dimensional with dimension 3. -/
theorem memeVector_finrank : Module.finrank ℝ MemeVector = Fintype.card MemeIndex := by
  exact Module.finrank_pi ℝ

/-- MemeIndex has cardinality 3. -/
theorem memeIndex_card : Fintype.card MemeIndex = 3 := by rfl

/-!
## The Transformation Matrix T_SF

T_SF is a 3×3 real matrix acting as a linear operator on MemeVector.
- Diagonal terms: self-amplification coefficients
- Off-diagonal terms: cross-infection coefficients
-/

/-- A transformation matrix in the ZOS meme system. -/
abbrev TransformationMatrix := Matrix MemeIndex MemeIndex ℝ

/-- T_SF acts as a linear map on meme vectors via matrix-vector multiplication. -/
noncomputable def applyTransformation (T : TransformationMatrix) : MemeVector →ₗ[ℝ] MemeVector :=
  Matrix.toLin' T

/-- Matrix-vector multiplication preserves the linear map structure. -/
theorem transformation_is_linear (T : TransformationMatrix) :
    IsLinearMap ℝ (fun v : MemeVector => T.mulVec v) :=
  { map_add := fun x y => by simp [Matrix.mulVec_add]
    map_smul := fun c x => by simp [Matrix.mulVec_smul] }

/-!
## The Quasi Meta Eigenvector (V_QM)

The stable resonant identity V_QM is characterized as an eigenvector of T_SF:
  T_SF • V_QM = λ_m • V_QM
where λ_m is the Meta Scalar (dominant eigenvalue).
-/

/-- An eigenvector-eigenvalue pair for a transformation matrix. -/
structure EigenPair (T : TransformationMatrix) where
  /-- The eigenvector (must be nonzero) -/
  vector : MemeVector
  /-- The eigenvalue (Meta Scalar λ_m) -/
  eigenvalue : ℝ
  /-- The eigenvector is nonzero -/
  nonzero : vector ≠ 0
  /-- The defining eigenvalue equation: T v = λ v -/
  eigen_eq : T.mulVec vector = eigenvalue • vector

/-
The "Stable Infected State": after n iterations of T_SF, the result
    is λ_m^n times the eigenvector.
-/
theorem eigen_iteration (T : TransformationMatrix) (ep : EigenPair T) (n : ℕ) :
    (T ^ n).mulVec ep.vector = ep.eigenvalue ^ n • ep.vector := by
  induction n <;> simp_all +decide [ pow_succ', Matrix.mulVec_smul ];
  simp_all +decide [ ← Matrix.mulVec_mulVec];
  rw [ Matrix.mulVec_smul, ep.eigen_eq, smul_smul, mul_comm ]

/-!
## Environmental Modifiers

Market conditions modulate the transformation matrix.
-/

/-- Soil state representing market conditions. -/
inductive SoilState
  | Mesic  -- Bull market: high transfer rate
  | Xeric  -- Bear market: resource scarcity
  deriving DecidableEq, Repr

/-- A modulated transformation scales T_SF by a market factor. -/
def modulateTransformation (T : TransformationMatrix) (factor : ℝ) :
    TransformationMatrix :=
  factor • T

/-
Modulation preserves eigenvectors (only scales eigenvalue).
-/
theorem modulation_preserves_eigenvector (T : TransformationMatrix)
    (ep : EigenPair T) (factor : ℝ) :
    (modulateTransformation T factor).mulVec ep.vector =
      (factor * ep.eigenvalue) • ep.vector := by
  unfold modulateTransformation;
  convert congr_arg ( fun x => factor • x ) ep.eigen_eq using 1;
  · exact smul_mulVec factor T ep.vector;
  · module