/-
# Dimension-indexed quantities

A `Qty d` is a rational number tagged, in its type, with a dimension.  Addition
is defined only at a single dimension, so `mass + volume` is an elaboration
error rather than a runtime check.  Multiplication multiplies the dimensions.

**Commodity is deliberately not in the type.** A mass of wheat and a mass of
crude oil have the same type here; commodity agreement is enforced
*structurally* by `Account`, which carries one commodity field for all of its
lines.  (The alternative — indexing `Qty` by commodity as well — makes every
conversion, aggregation and interval lemma carry an extra index for a property
that a single field already gives.)  This is a design decision, stated so that
nobody reads the types as promising more than they do.
-/
import Mathlib
import RequestProject.Economy.Dimensions

namespace RequestProject.Economy

/-- A rational quantity carrying its dimension in its type. -/
structure Qty (d : Dim) where
  value : ℚ
deriving Repr, DecidableEq

namespace Qty

@[ext] theorem ext {d : Dim} {x y : Qty d} (h : x.value = y.value) : x = y := by
  cases x; cases y; simpa using h

instance {d : Dim} : Zero (Qty d) := ⟨⟨0⟩⟩
instance {d : Dim} : Add (Qty d) := ⟨fun x y => ⟨x.value + y.value⟩⟩
instance {d : Dim} : Neg (Qty d) := ⟨fun x => ⟨-x.value⟩⟩
instance {d : Dim} : Sub (Qty d) := ⟨fun x y => ⟨x.value - y.value⟩⟩
instance {d : Dim} : LE (Qty d) := ⟨fun x y => x.value ≤ y.value⟩
instance {d : Dim} : LT (Qty d) := ⟨fun x y => x.value < y.value⟩

@[simp] theorem zero_value {d : Dim} : (0 : Qty d).value = 0 := rfl
@[simp] theorem add_value {d : Dim} (x y : Qty d) : (x + y).value = x.value + y.value := rfl
@[simp] theorem neg_value {d : Dim} (x : Qty d) : (-x).value = -x.value := rfl
@[simp] theorem sub_value {d : Dim} (x y : Qty d) : (x - y).value = x.value - y.value := rfl
@[simp] theorem le_iff {d : Dim} (x y : Qty d) : x ≤ y ↔ x.value ≤ y.value := Iff.rfl
@[simp] theorem lt_iff {d : Dim} (x y : Qty d) : x < y ↔ x.value < y.value := Iff.rfl

/-- Multiplication multiplies dimensions. -/
def mul {d₁ d₂ : Dim} (x : Qty d₁) (y : Qty d₂) : Qty (d₁ * d₂) := ⟨x.value * y.value⟩

@[simp] theorem mul_value {d₁ d₂ : Dim} (x : Qty d₁) (y : Qty d₂) :
    (mul x y).value = x.value * y.value := rfl

/-- Scaling by a dimensionless rational. -/
def scale {d : Dim} (c : ℚ) (x : Qty d) : Qty d := ⟨c * x.value⟩

@[simp] theorem scale_value {d : Dim} (c : ℚ) (x : Qty d) : (scale c x).value = c * x.value := rfl

/-- Transport a quantity along a proof that two dimensions are equal.  Every
change of dimension is explicit and leaves a trace in the proof term. -/
def cast {d₁ d₂ : Dim} (_h : d₁ = d₂) (x : Qty d₁) : Qty d₂ := ⟨x.value⟩

@[simp] theorem cast_value {d₁ d₂ : Dim} (h : d₁ = d₂) (x : Qty d₁) : (cast h x).value = x.value :=
  rfl

theorem add_comm {d : Dim} (x y : Qty d) : x + y = y + x := by ext; simp [_root_.add_comm]

theorem add_assoc {d : Dim} (x y z : Qty d) : x + y + z = x + (y + z) := by
  ext; simp [_root_.add_assoc]

@[simp] theorem add_zero {d : Dim} (x : Qty d) : x + 0 = x := by ext; simp

@[simp] theorem zero_add {d : Dim} (x : Qty d) : 0 + x = x := by ext; simp

@[simp] theorem sub_self {d : Dim} (x : Qty d) : x - x = 0 := by ext; simp

theorem mul_comm_cast {d₁ d₂ : Dim} (x : Qty d₁) (y : Qty d₂) :
    mul x y = cast (Dim.mul_comm d₂ d₁) (mul y x) := by ext; simp [_root_.mul_comm]

/-- Acreage times yield is a mass — the statement the flat unit enumeration
could not even express. -/
def harvest (a : Qty Dim.area) (y : Qty Dim.yield) : Qty Dim.mass :=
  cast Dim.area_mul_yield (mul a y)

@[simp] theorem harvest_value (a : Qty Dim.area) (y : Qty Dim.yield) :
    (harvest a y).value = a.value * y.value := rfl

end Qty

/-- A named conversion between two dimensions.  The factor is an *interval*
(see `Economy.Intervals`) in the uncertainty-aware version; here it is the
point form, kept only for exact, definitional conversions (e.g. hectares to
square metres).  Every other conversion must go through `Economy.Intervals`. -/
structure ExactConversion (a b : Dim) where
  name : String
  factor : ℚ
  factor_pos : 0 < factor

namespace ExactConversion

def apply {a b : Dim} (c : ExactConversion a b) (x : Qty a) : Qty b := ⟨c.factor * x.value⟩

@[simp] theorem apply_value {a b : Dim} (c : ExactConversion a b) (x : Qty a) :
    (c.apply x).value = c.factor * x.value := rfl

theorem apply_add {a b : Dim} (c : ExactConversion a b) (x y : Qty a) :
    c.apply (x + y) = c.apply x + c.apply y := by ext; simp [mul_add]

theorem apply_mono {a b : Dim} (c : ExactConversion a b) {x y : Qty a} (h : x ≤ y) :
    c.apply x ≤ c.apply y := by
  simp only [Qty.le_iff, apply_value]
  exact mul_le_mul_of_nonneg_left h (le_of_lt c.factor_pos)

end ExactConversion

end RequestProject.Economy
