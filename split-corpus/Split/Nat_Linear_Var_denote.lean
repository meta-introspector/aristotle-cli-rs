import Mathlib

set_option pp.all true
-- spec: Nat.Linear.Var.denote : Nat.Linear.Context -> Nat.Linear.Var -> Nat
def Nat.Linear.Var.denote : Nat.Linear.Context -> Nat.Linear.Var -> Nat :=
  fun (ctx : Nat.Linear.Context) (v : Nat.Linear.Var) => Bool.rec.{1} (fun (x._@.Init.Data.Nat.Linear.331617648._hygCtx._hyg.11 : Bool) => Nat) (Lean.RArray.get.{0} Nat ctx v) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (Nat.beq v Nat.Linear.fixedVar)
