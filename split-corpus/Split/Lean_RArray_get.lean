import Mathlib

set_option pp.all true
-- spec: Lean.RArray.get : forall {α : Type.{u}}, (Lean.RArray.{u} α) -> Nat -> α
def Lean.RArray.get : forall {α : Type.{u}}, (Lean.RArray.{u} α) -> Nat -> α :=
  fun {α : Type.{u}} (a : Lean.RArray.{u} α) (n : Nat) => Lean.RArray.rec.{succ u, u} α (fun (x._@.Init.Data.RArray.1017806716._hygCtx._hyg.9 : Lean.RArray.{u} α) => α) (fun (x : α) => x) (fun (p : Nat) (x._@.Init.Data.RArray.1017806716._hygCtx._hyg.21 : Lean.RArray.{u} α) (x._@.Init.Data.RArray.1017806716._hygCtx._hyg.23 : Lean.RArray.{u} α) (l : α) (r : α) => Bool.rec.{succ u} (fun (x._@.Init.Data.RArray.1017806716._hygCtx._hyg.33 : Bool) => α) l r (Nat.ble p n)) a
