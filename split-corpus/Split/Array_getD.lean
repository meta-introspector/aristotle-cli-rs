import Mathlib

set_option pp.all true
-- spec: Array.getD : forall {α : Type.{u_1}}, (Array.{u_1} α) -> Nat -> α -> α
def Array.getD : forall {α : Type.{u_1}}, (Array.{u_1} α) -> Nat -> α -> α :=
  fun {α : Type.{u_1}} (a : Array.{u_1} α) (i : Nat) (v₀ : α) => dite.{succ u_1} α (LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α a)) (Nat.decLt i (Array.size.{u_1} α a)) (fun (h : LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α a)) => Array.getInternal.{u_1} α a i h) (fun (x._@.Init.Prelude.3502629365._hygCtx._hyg.27 : Not (LT.lt.{0} Nat instLTNat i (Array.size.{u_1} α a))) => v₀)
