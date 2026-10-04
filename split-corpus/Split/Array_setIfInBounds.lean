import Mathlib

set_option pp.all true
-- spec: Array.setIfInBounds : forall {α : Type.{u_1}}, (Array.{u_1} α) -> Nat -> α -> (Array.{u_1} α)
def Array.setIfInBounds : forall {α : Type.{u_1}}, (Array.{u_1} α) -> Nat -> α -> (Array.{u_1} α) :=
  fun {α : Type.{u_1}} (xs : Array.{u_1} α) (i : Nat) (v : α) => dite.{succ u_1} (Array.{u_1} α) (LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs)) (Nat.decLt i (Array.size.{u_1} α xs)) (fun (h : LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs)) => Array.set.{u_1} α xs i v h) (fun (x._@.Init.Data.Array.Set.1095466134._hygCtx._hyg.29 : Not (LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α xs))) => xs)
