import Mathlib

set_option pp.all true
-- spec: Lean.mkAppN : Lean.Expr -> (Array.{0} Lean.Expr) -> Lean.Expr
def Lean.mkAppN : Lean.Expr -> (Array.{0} Lean.Expr) -> Lean.Expr :=
  fun (f : Lean.Expr) (args : Array.{0} Lean.Expr) => Array.foldl.{0, 0} Lean.Expr Lean.Expr Lean.mkApp f args (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (Array.size.{0} Lean.Expr args)
