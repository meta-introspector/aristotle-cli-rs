import Lean

/-!
# Stage 9 — Construct Initial j-Series

Assemble the first terms. We now possess:

  q⁻¹ + 744 + 196884·q

This is the famous beginning of monstrous moonshine.
All facts are kernel-checked via `example` declarations.
-/

structure QTerm where
  coeff : Int
  power : Int
deriving Repr, DecidableEq

abbrev QSeries := List QTerm

def j0 : QSeries :=
[
  ⟨1, -1⟩,
  ⟨744, 0⟩,
  ⟨196884, 1⟩
]

-- Kernel-checked: three terms present
example : j0.length = 3 := rfl

-- Kernel-checked: coefficients are correct
example : (j0[0]'(by decide)).coeff = 1 := rfl
example : (j0[1]'(by decide)).coeff = 744 := rfl
example : (j0[2]'(by decide)).coeff = 196884 := rfl

-- Kernel-checked: powers are correct
example : (j0[0]'(by decide)).power = -1 := rfl
example : (j0[1]'(by decide)).power = 0 := rfl
example : (j0[2]'(by decide)).power = 1 := rfl

#check j0
