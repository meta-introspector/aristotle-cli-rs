import Mathlib

set_option pp.all true
-- spec: Array.get!Internal : forall {α : Type.{u}} [inst._@.Init.Prelude.3471936409._hygCtx._hyg.3 : Inhabited.{succ u} α], ([mdata borrowed:1 Array.{u} α]) -> ([mdata borrowed:1 Nat]) -> α
def Array.get!Internal : forall {α : Type.{u}} [inst._@.Init.Prelude.3471936409._hygCtx._hyg.3 : Inhabited.{succ u} α], ([mdata borrowed:1 Array.{u} α]) -> ([mdata borrowed:1 Nat]) -> α :=
  fun {α : Type.{u}} [inst._@.Init.Prelude.3471936409._hygCtx._hyg.3 : Inhabited.{succ u} α] (a : Array.{u} α) (i : Nat) => Array.getD.{u} α a i (Inhabited.default.{succ u} α inst._@.Init.Prelude.3471936409._hygCtx._hyg.3)
