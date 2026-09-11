import Lean

/-!
# Stage 8 — Define q-Series Structure

Begin constructing the modular object itself.
The reflective machine now contains algebraic atoms —
the beginning of the j-invariant has materialized.

We avoid `#eval` and instead use kernel-checked `example` declarations
to verify the structure.
-/

structure QTerm where
  coeff : Int
  power : Int
deriving Repr, DecidableEq

def qinv : QTerm :=
  ⟨1, -1⟩

def q0 : QTerm :=
  ⟨744, 0⟩

-- Kernel-checked assertions (no #eval needed)
example : qinv.coeff = 1 := rfl
example : qinv.power = -1 := rfl
example : q0.coeff = 744 := rfl
example : q0.power = 0 := rfl

#check qinv
#check q0
