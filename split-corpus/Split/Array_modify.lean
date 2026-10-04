import Mathlib

set_option pp.all true
-- spec: Array.modify : forall {α : Type.{u}}, (Array.{u} α) -> Nat -> (α -> α) -> (Array.{u} α)
def Array.modify : forall {α : Type.{u}}, (Array.{u} α) -> Nat -> (α -> α) -> (Array.{u} α) :=
  fun {α : Type.{u}} (xs : Array.{u} α) (i : Nat) (f : α -> α) => Id.run.{u} (Array.{u} α) (Array.modifyM.{u, u} α Id.{u} Id.instMonad.{u} xs i (fun (x._@.Init.Data.Array.Basic.1101553765._hygCtx._hyg.19 : α) => Pure.pure.{u, u} Id.{u} (Applicative.toPure.{u, u} Id.{u} (Monad.toApplicative.{u, u} Id.{u} Id.instMonad.{u})) α (f x._@.Init.Data.Array.Basic.1101553765._hygCtx._hyg.19)))
