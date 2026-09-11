import Mathlib

/-!
# Eisenstein Integers

The ring `ℤ[ω]` where `ω` is a primitive cube root of unity satisfying `ω² + ω + 1 = 0`.
An Eisenstein integer is represented as `a + bω` with `a b : ℤ`.
-/

/-- An Eisenstein integer `a + bω`. -/
@[ext]
structure Eisenstein where
  a : ℤ
  b : ℤ
  deriving DecidableEq, Repr

namespace Eisenstein

/-- The cube root of unity `ω`. -/
def omega : Eisenstein := ⟨0, 1⟩

scoped notation "ω" => Eisenstein.omega

instance : Zero Eisenstein := ⟨⟨0, 0⟩⟩
instance : One Eisenstein := ⟨⟨1, 0⟩⟩

@[simp] lemma zero_a : (0 : Eisenstein).a = 0 := rfl
@[simp] lemma zero_b : (0 : Eisenstein).b = 0 := rfl
@[simp] lemma one_a : (1 : Eisenstein).a = 1 := rfl
@[simp] lemma one_b : (1 : Eisenstein).b = 0 := rfl

instance : Add Eisenstein := ⟨fun z w => ⟨z.a + w.a, z.b + w.b⟩⟩
instance : Neg Eisenstein := ⟨fun z => ⟨-z.a, -z.b⟩⟩
instance : Sub Eisenstein := ⟨fun z w => ⟨z.a - w.a, z.b - w.b⟩⟩

/-- Multiplication: `(a+bω)(c+dω) = (ac-bd) + (ad+bc-bd)ω`
using `ω² = -1 - ω`. -/
instance : Mul Eisenstein := ⟨fun z w => ⟨z.a * w.a - z.b * w.b, z.a * w.b + z.b * w.a - z.b * w.b⟩⟩

@[simp] lemma add_a (z w : Eisenstein) : (z + w).a = z.a + w.a := rfl
@[simp] lemma add_b (z w : Eisenstein) : (z + w).b = z.b + w.b := rfl
@[simp] lemma neg_a (z : Eisenstein) : (-z).a = -z.a := rfl
@[simp] lemma neg_b (z : Eisenstein) : (-z).b = -z.b := rfl
@[simp] lemma sub_a (z w : Eisenstein) : (z - w).a = z.a - w.a := rfl
@[simp] lemma sub_b (z w : Eisenstein) : (z - w).b = z.b - w.b := rfl
@[simp] lemma mul_a (z w : Eisenstein) : (z * w).a = z.a * w.a - z.b * w.b := rfl
@[simp] lemma mul_b (z w : Eisenstein) : (z * w).b = z.a * w.b + z.b * w.a - z.b * w.b := rfl

instance : NatCast Eisenstein := ⟨fun n => ⟨n, 0⟩⟩
instance : IntCast Eisenstein := ⟨fun n => ⟨n, 0⟩⟩

@[simp] lemma natCast_a (n : ℕ) : (n : Eisenstein).a = n := rfl
@[simp] lemma natCast_b (n : ℕ) : (n : Eisenstein).b = 0 := rfl
@[simp] lemma intCast_a (n : ℤ) : (n : Eisenstein).a = n := rfl
@[simp] lemma intCast_b (n : ℤ) : (n : Eisenstein).b = 0 := rfl

instance : CommRing Eisenstein where
  zero := 0
  one := 1
  add := (· + ·)
  neg := (- ·)
  sub := (· - ·)
  mul := (· * ·)
  natCast := (fun n => ⟨n, 0⟩)
  intCast := (fun n => ⟨n, 0⟩)
  add_assoc := by intros; ext <;> simp [add_assoc]
  zero_add := by intros; ext <;> simp
  add_zero := by intros; ext <;> simp
  add_comm := by intros; ext <;> simp [add_comm]
  mul_assoc := by intros; ext <;> simp <;> ring
  one_mul := by intros; ext <;> simp
  mul_one := by intros; ext <;> simp
  mul_comm := by intros; ext <;> simp <;> ring
  left_distrib := by intros; ext <;> simp <;> ring
  right_distrib := by intros; ext <;> simp <;> ring
  sub_eq_add_neg := by intros; ext <;> simp [sub_eq_add_neg]
  neg_add_cancel := by intros; ext <;> simp
  zero_mul := by intros; ext <;> simp
  mul_zero := by intros; ext <;> simp
  nsmul := nsmulRec
  zsmul := zsmulRec
  natCast_zero := by ext <;> simp
  natCast_succ := by intros; ext <;> simp [Nat.cast_succ]
  intCast_negSucc := by intros; ext <;> simp [Int.negSucc_eq]

/-- The norm of an Eisenstein integer: `N(a + bω) = a² - ab + b²`. -/
def norm (z : Eisenstein) : ℤ := z.a ^ 2 - z.a * z.b + z.b ^ 2

@[simp]
theorem norm_zero : norm 0 = 0 := by
  simp [norm]

/-- The norm is multiplicative: `N(z * w) = N(z) * N(w)`. -/
theorem norm_mul (z w : Eisenstein) : norm (z * w) = norm z * norm w := by
  simp [norm]
  ring

end Eisenstein
