import Mathlib

/-!
# Eisenstein Integers

The Eisenstein integers ℤ[ω], where ω = (-1 + √(-3))/2 is a primitive cube root of unity.
Elements are of the form a + bω with a, b ∈ ℤ.
-/

/-- The Eisenstein integers ℤ[ω]. An element is `a + b·ω` where `ω² + ω + 1 = 0`. -/
@[ext]
structure Eisenstein where
  a : ℤ
  b : ℤ
  deriving DecidableEq, Repr

namespace Eisenstein

instance : Zero Eisenstein := ⟨⟨0, 0⟩⟩
instance : One Eisenstein := ⟨⟨1, 0⟩⟩

@[simp] lemma zero_a : (0 : Eisenstein).a = 0 := rfl
@[simp] lemma zero_b : (0 : Eisenstein).b = 0 := rfl
@[simp] lemma one_a : (1 : Eisenstein).a = 1 := rfl
@[simp] lemma one_b : (1 : Eisenstein).b = 0 := rfl

instance : Add Eisenstein := ⟨fun x y => ⟨x.a + y.a, x.b + y.b⟩⟩
instance : Neg Eisenstein := ⟨fun x => ⟨-x.a, -x.b⟩⟩
instance : Sub Eisenstein := ⟨fun x y => ⟨x.a - y.a, x.b - y.b⟩⟩

/-- Multiplication using ω² = -1 - ω:
  (a + bω)(c + dω) = (ac - bd) + (ad + bc - bd)ω -/
instance : Mul Eisenstein := ⟨fun x y =>
  ⟨x.a * y.a - x.b * y.b, x.a * y.b + x.b * y.a - x.b * y.b⟩⟩

instance : SMul ℤ Eisenstein := ⟨fun n x => ⟨n * x.a, n * x.b⟩⟩

instance : NatCast Eisenstein := ⟨fun n => ⟨↑n, 0⟩⟩
instance : IntCast Eisenstein := ⟨fun n => ⟨n, 0⟩⟩

@[simp] lemma add_a (x y : Eisenstein) : (x + y).a = x.a + y.a := rfl
@[simp] lemma add_b (x y : Eisenstein) : (x + y).b = x.b + y.b := rfl
@[simp] lemma neg_a (x : Eisenstein) : (-x).a = -x.a := rfl
@[simp] lemma neg_b (x : Eisenstein) : (-x).b = -x.b := rfl
@[simp] lemma sub_a (x y : Eisenstein) : (x - y).a = x.a - y.a := rfl
@[simp] lemma sub_b (x y : Eisenstein) : (x - y).b = x.b - y.b := rfl
@[simp] lemma mul_a (x y : Eisenstein) : (x * y).a = x.a * y.a - x.b * y.b := rfl
@[simp] lemma mul_b (x y : Eisenstein) : (x * y).b = x.a * y.b + x.b * y.a - x.b * y.b := rfl

instance : CommRing Eisenstein where
  add_assoc := by intros; ext <;> simp <;> ring
  zero_add := by intros; ext <;> simp
  add_zero := by intros; ext <;> simp
  add_comm := by intros; ext <;> simp <;> omega
  mul_assoc := by intros; ext <;> simp <;> ring
  one_mul := by intros; ext <;> simp
  mul_one := by intros; ext <;> simp
  mul_comm := by intros; ext <;> simp <;> ring
  left_distrib := by intros; ext <;> simp <;> ring
  right_distrib := by intros; ext <;> simp <;> ring
  zero_mul := by intros; ext <;> simp
  mul_zero := by intros; ext <;> simp
  neg_add_cancel := by intros; ext <;> simp
  nsmul := nsmulRec
  zsmul := zsmulRec
  natCast_zero := by ext <;> simp [NatCast.natCast]
  natCast_succ := by
    intro n
    show (⟨↑(n + 1), 0⟩ : Eisenstein) = ⟨↑n, 0⟩ + ⟨1, 0⟩
    ext <;> simp [Nat.cast_add, Nat.cast_one]
  intCast_negSucc := by
    intro n
    show (⟨Int.negSucc n, 0⟩ : Eisenstein) = -(⟨↑(n + 1), 0⟩ : Eisenstein)
    ext <;> simp [Int.negSucc_eq, Nat.cast_add, Nat.cast_one]

/-- The norm (field norm) of an Eisenstein integer: N(a + bω) = a² - ab + b². -/
def norm (z : Eisenstein) : ℤ := z.a ^ 2 - z.a * z.b + z.b ^ 2

/-- Complex conjugate in ℤ[ω]: conj(a + bω) = (a - b) + (-b)ω. -/
def conj (z : Eisenstein) : Eisenstein := ⟨z.a - z.b, -z.b⟩

@[simp] lemma conj_a (z : Eisenstein) : (conj z).a = z.a - z.b := rfl
@[simp] lemma conj_b (z : Eisenstein) : (conj z).b = -z.b := rfl

@[simp] theorem norm_zero : norm 0 = 0 := by unfold norm; simp

theorem norm_nonneg (z : Eisenstein) : 0 ≤ norm z := by
  unfold norm
  -- a² - ab + b² = (2a - b)²/4 + 3b²/4, so 4·(a² - ab + b²) = (2a-b)² + 3b² ≥ 0
  have h : 4 * (z.a ^ 2 - z.a * z.b + z.b ^ 2) = (2 * z.a - z.b) ^ 2 + 3 * z.b ^ 2 := by ring
  nlinarith [sq_nonneg (2 * z.a - z.b), sq_nonneg z.b]

theorem norm_eq_zero_iff (z : Eisenstein) : norm z = 0 ↔ z = 0 := by
  constructor
  · intro h
    unfold norm at h
    have h4 : 4 * (z.a ^ 2 - z.a * z.b + z.b ^ 2) = (2 * z.a - z.b) ^ 2 + 3 * z.b ^ 2 := by ring
    have h4zero : (2 * z.a - z.b) ^ 2 + 3 * z.b ^ 2 = 0 := by linarith
    have hb : z.b = 0 := by nlinarith [sq_nonneg (2 * z.a - z.b), sq_nonneg z.b]
    have ha : z.a = 0 := by nlinarith [sq_nonneg (2 * z.a - z.b)]
    ext <;> assumption
  · intro h; rw [h]; exact norm_zero

theorem conj_mul_self (z : Eisenstein) : z * conj z = ⟨norm z, 0⟩ := by
  ext
  · simp [norm]; ring
  · simp; ring

theorem norm_mul (x y : Eisenstein) : norm (x * y) = norm x * norm y := by
  unfold norm; simp; ring

theorem norm_conj (z : Eisenstein) : norm (conj z) = norm z := by
  unfold norm conj; simp; ring

end Eisenstein
