/-
# Physical dimensions as exponent vectors

A closed enumeration of units (`tonnes | barrels | … | dollars`) cannot express
the milestone statement `area × yield = mass`: there is no type at which the
product lives.  So a dimension here is an exponent vector over five base
dimensions, and multiplication of quantities adds the vectors.

Nothing in this file mentions economics, data or evidence; it is the
parameter-free base of the theory layer.
-/

namespace RequestProject.Economy

/-- A physical dimension: integer exponents over mass, length, time, currency
and count.  `Dim` is an abelian group under multiplication of quantities. -/
structure Dim where
  mExp : Int := 0
  lExp : Int := 0
  tExp : Int := 0
  curExp : Int := 0
  cntExp : Int := 0
deriving DecidableEq, Repr, Inhabited

namespace Dim

/-- The dimension of a pure number. -/
protected def one : Dim := {}

protected def mul (a b : Dim) : Dim :=
  { mExp := a.mExp + b.mExp
    lExp := a.lExp + b.lExp
    tExp := a.tExp + b.tExp
    curExp := a.curExp + b.curExp
    cntExp := a.cntExp + b.cntExp }

protected def inv (a : Dim) : Dim :=
  { mExp := -a.mExp, lExp := -a.lExp, tExp := -a.tExp
    curExp := -a.curExp, cntExp := -a.cntExp }

protected def div (a b : Dim) : Dim := Dim.mul a (Dim.inv b)

instance : Mul Dim := ⟨Dim.mul⟩
instance : Inv Dim := ⟨Dim.inv⟩
instance : Div Dim := ⟨Dim.div⟩
instance : One Dim := ⟨Dim.one⟩

@[simp] theorem mul_def (a b : Dim) : a * b = Dim.mul a b := rfl
@[simp] theorem inv_def (a : Dim) : a⁻¹ = Dim.inv a := rfl
@[simp] theorem one_def : (1 : Dim) = Dim.one := rfl

theorem mul_comm (a b : Dim) : a * b = b * a := by
  simp only [mul_def, Dim.mul]; congr 1 <;> omega

theorem mul_assoc (a b c : Dim) : a * b * c = a * (b * c) := by
  simp only [mul_def, Dim.mul]; congr 1 <;> omega

@[simp] theorem mul_one (a : Dim) : a * 1 = a := by
  simp only [mul_def, one_def, Dim.mul, Dim.one]; congr 1 <;> omega

@[simp] theorem one_mul (a : Dim) : 1 * a = a := by
  simp only [mul_def, one_def, Dim.mul, Dim.one]; congr 1 <;> omega

@[simp] theorem mul_inv (a : Dim) : a * a⁻¹ = 1 := by
  simp only [mul_def, inv_def, one_def, Dim.mul, Dim.inv, Dim.one]; congr 1 <;> omega

@[simp] theorem div_self (a : Dim) : a / a = 1 := mul_inv a

/-- The base dimensions actually used by the economic model. -/
def mass : Dim := { mExp := 1 }
def length : Dim := { lExp := 1 }
def time : Dim := { tExp := 1 }
def currency : Dim := { curExp := 1 }
def count : Dim := { cntExp := 1 }

/-- Area is `length²`. -/
def area : Dim := length * length
/-- Volume is `length³`. -/
def volume : Dim := area * length
/-- Yield is mass per unit area. -/
def yield : Dim := mass / area
/-- Energy is `mass · length² · time⁻²`. -/
def energy : Dim := mass * area / (time * time)
/-- A flow is a quantity per unit time. -/
def perTime (d : Dim) : Dim := d / time

/-- The point of the exponent vector: acreage times yield really is a mass,
definitionally, so `Qty area → Qty yield → Qty mass` typechecks. -/
theorem area_mul_yield : area * yield = mass := by decide

theorem volume_ne_mass : volume ≠ mass := by decide
theorem currency_ne_mass : currency ≠ mass := by decide
theorem energy_ne_mass : energy ≠ mass := by decide

end Dim

end RequestProject.Economy
