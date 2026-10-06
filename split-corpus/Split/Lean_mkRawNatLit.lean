import Mathlib

set_option pp.all true
-- spec: Lean.mkRawNatLit : Nat -> Lean.Expr
def Lean.mkRawNatLit : Nat -> Lean.Expr :=
  fun (n : Nat) => Lean.mkLit (Lean.Literal.natVal n)
