import Mathlib

set_option pp.all true
-- spec: Lean.mkNatLit : Nat -> Lean.Expr
def Lean.mkNatLit : Nat -> Lean.Expr :=
  fun (n : Nat) => Lean.mkNatLitCore (Lean.mkRawNatLit n)
