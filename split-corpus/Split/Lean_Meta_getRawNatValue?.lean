import Mathlib

set_option pp.all true
-- spec: Lean.Meta.getRawNatValue? : Lean.Expr -> (Option.{0} Nat)
def Lean.Meta.getRawNatValue? : Lean.Expr -> (Option.{0} Nat) :=
  fun (e : Lean.Expr) => _private.Lean.Meta.LitValues.0.Lean.Meta.getRawNatValue?.match_1.{1} (fun (x._@.Lean.Meta.LitValues.1689258173._hygCtx._hyg.8 : Lean.Expr) => Option.{0} Nat) (Lean.Expr.consumeMData e) (fun (n : Nat) => Option.some.{0} Nat n) (fun (x._@.Lean.Meta.LitValues.1689258173._hygCtx._hyg.21 : Lean.Expr) => Option.none.{0} Nat)
