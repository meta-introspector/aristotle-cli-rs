import Mathlib

/-!
# A concrete real Clifford algebra `Cl(2,0)` and its defining relations

This file builds, from scratch and entirely concretely, the real Clifford algebra
`Cl(2,0)` — the geometric algebra of the Euclidean plane — as a four-dimensional real
algebra with basis `{1, e₁, e₂, e₁₂}`, and proves its characteristic relations directly by
component computation (`ring`).

The point of the file is *elementary but genuine*: rather than invoking Mathlib's abstract
`CliffordAlgebra`, we give the explicit multiplication table and check that

* the generators square to `1`:  `e₁ * e₁ = 1`,  `e₂ * e₂ = 1`;
* the generators **anticommute**:  `e₁ * e₂ = -(e₂ * e₁)`;
* the pseudoscalar squares to `-1`:  `e₁₂ * e₁₂ = -1`  (so `Cl(2,0)` contains a copy of `ℂ`);
* multiplication is **associative** and **bilinear**, with `1` a two-sided unit;
* the **fundamental Clifford identity** holds: for a vector `v = a·e₁ + b·e₂`,
  `v * v = (a² + b²)·1`, i.e. squaring a vector returns its squared Euclidean length.

Each proof closes by `ring`/`ext` on the four real components.
-/

namespace Clifford

/-- An element of the real Clifford algebra `Cl(2,0)`, written in the basis
`{1, e₁, e₂, e₁₂}` as `s·1 + x·e₁ + y·e₂ + b·e₁₂`. -/
@[ext]
structure Cl2 where
  /-- The scalar (grade-0) component, coefficient of `1`. -/
  s : ℝ
  /-- The `e₁` (grade-1) component. -/
  x : ℝ
  /-- The `e₂` (grade-1) component. -/
  y : ℝ
  /-- The `e₁₂` (grade-2, pseudoscalar) component. -/
  b : ℝ

namespace Cl2

/-- The zero element. -/
instance : Zero Cl2 := ⟨⟨0, 0, 0, 0⟩⟩

/-- The unit `1` (the scalar `1`). -/
instance : One Cl2 := ⟨⟨1, 0, 0, 0⟩⟩

/-- Addition is componentwise. -/
instance : Add Cl2 := ⟨fun p q => ⟨p.s + q.s, p.x + q.x, p.y + q.y, p.b + q.b⟩⟩

/-- Negation is componentwise. -/
instance : Neg Cl2 := ⟨fun p => ⟨-p.s, -p.x, -p.y, -p.b⟩⟩

/-- Scalar multiplication by a real number. -/
instance : SMul ℝ Cl2 := ⟨fun r p => ⟨r * p.s, r * p.x, r * p.y, r * p.b⟩⟩

/-- The Clifford product, given by the explicit multiplication table for the basis
`{1, e₁, e₂, e₁₂}` with `e₁² = e₂² = 1`, `e₁e₂ = e₁₂` and `e₂e₁ = -e₁₂`. -/
instance : Mul Cl2 :=
  ⟨fun p q =>
    ⟨ p.s * q.s + p.x * q.x + p.y * q.y - p.b * q.b,
      p.s * q.x + p.x * q.s - p.y * q.b + p.b * q.y,
      p.s * q.y + p.y * q.s + p.x * q.b - p.b * q.x,
      p.s * q.b + p.b * q.s + p.x * q.y - p.y * q.x ⟩⟩

@[simp] theorem zero_s : (0 : Cl2).s = 0 := rfl
@[simp] theorem zero_x : (0 : Cl2).x = 0 := rfl
@[simp] theorem zero_y : (0 : Cl2).y = 0 := rfl
@[simp] theorem zero_b : (0 : Cl2).b = 0 := rfl
@[simp] theorem one_s : (1 : Cl2).s = 1 := rfl
@[simp] theorem one_x : (1 : Cl2).x = 0 := rfl
@[simp] theorem one_y : (1 : Cl2).y = 0 := rfl
@[simp] theorem one_b : (1 : Cl2).b = 0 := rfl
@[simp] theorem add_s (p q : Cl2) : (p + q).s = p.s + q.s := rfl
@[simp] theorem add_x (p q : Cl2) : (p + q).x = p.x + q.x := rfl
@[simp] theorem add_y (p q : Cl2) : (p + q).y = p.y + q.y := rfl
@[simp] theorem add_b (p q : Cl2) : (p + q).b = p.b + q.b := rfl
@[simp] theorem neg_s (p : Cl2) : (-p).s = -p.s := rfl
@[simp] theorem neg_x (p : Cl2) : (-p).x = -p.x := rfl
@[simp] theorem neg_y (p : Cl2) : (-p).y = -p.y := rfl
@[simp] theorem neg_b (p : Cl2) : (-p).b = -p.b := rfl
@[simp] theorem smul_s (r : ℝ) (p : Cl2) : (r • p).s = r * p.s := rfl
@[simp] theorem smul_x (r : ℝ) (p : Cl2) : (r • p).x = r * p.x := rfl
@[simp] theorem smul_y (r : ℝ) (p : Cl2) : (r • p).y = r * p.y := rfl
@[simp] theorem smul_b (r : ℝ) (p : Cl2) : (r • p).b = r * p.b := rfl
@[simp] theorem mul_s (p q : Cl2) :
    (p * q).s = p.s * q.s + p.x * q.x + p.y * q.y - p.b * q.b := rfl
@[simp] theorem mul_x (p q : Cl2) :
    (p * q).x = p.s * q.x + p.x * q.s - p.y * q.b + p.b * q.y := rfl
@[simp] theorem mul_y (p q : Cl2) :
    (p * q).y = p.s * q.y + p.y * q.s + p.x * q.b - p.b * q.x := rfl
@[simp] theorem mul_b (p q : Cl2) :
    (p * q).b = p.s * q.b + p.b * q.s + p.x * q.y - p.y * q.x := rfl

/-- The generator `e₁`. -/
def e1 : Cl2 := ⟨0, 1, 0, 0⟩

/-- The generator `e₂`. -/
def e2 : Cl2 := ⟨0, 0, 1, 0⟩

/-- The pseudoscalar `e₁₂ = e₁e₂`. -/
def e12 : Cl2 := ⟨0, 0, 0, 1⟩

/-! ### The defining relations of `Cl(2,0)` -/

/-- `1` is a left unit. -/
theorem one_mul' (p : Cl2) : (1 : Cl2) * p = p := by ext <;> simp

/-- `1` is a right unit. -/
theorem mul_one' (p : Cl2) : p * (1 : Cl2) = p := by ext <;> simp

/-- Multiplication is associative. -/
theorem mul_assoc' (p q r : Cl2) : p * q * r = p * (q * r) := by ext <;> simp <;> ring

/-- The Clifford product is left-distributive over addition. -/
theorem mul_add' (p q r : Cl2) : p * (q + r) = p * q + p * r := by ext <;> simp <;> ring

/-- The Clifford product is right-distributive over addition. -/
theorem add_mul' (p q r : Cl2) : (p + q) * r = p * r + q * r := by ext <;> simp <;> ring

/-- The first generator squares to `1`. -/
theorem e1_sq : e1 * e1 = 1 := by ext <;> simp [e1]

/-- The second generator squares to `1`. -/
theorem e2_sq : e2 * e2 = 1 := by ext <;> simp [e2]

/-- The product of the two generators is the pseudoscalar. -/
theorem e1_mul_e2 : e1 * e2 = e12 := by ext <;> simp [e1, e2, e12]

/-- The generators **anticommute**: `e₁e₂ = -(e₂e₁)`. -/
theorem e1_e2_anticomm : e1 * e2 = -(e2 * e1) := by ext <;> simp [e1, e2]

/-- The pseudoscalar squares to `-1`: `Cl(2,0)` contains a copy of the complex numbers. -/
theorem e12_sq : e12 * e12 = -1 := by ext <;> simp [e12]

/-- **Fundamental Clifford identity.** For a vector `v = a·e₁ + b·e₂`, squaring returns its
squared Euclidean length: `v * v = (a² + b²)·1`. -/
theorem vector_sq (a c : ℝ) :
    (a • e1 + c • e2) * (a • e1 + c • e2) = (a ^ 2 + c ^ 2) • (1 : Cl2) := by
  ext <;> simp [e1, e2] <;> ring

end Cl2

end Clifford
