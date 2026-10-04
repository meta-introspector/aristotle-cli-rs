import Mathlib

set_option pp.all true
-- spec: Lean.PersistentArray.any : forall {α : Type.{u}}, (Lean.PersistentArray.{u} α) -> (α -> Bool) -> Bool
def Lean.PersistentArray.any : forall {α : Type.{u}}, (Lean.PersistentArray.{u} α) -> (α -> Bool) -> Bool :=
  fun {α : Type.{u}} (a : Lean.PersistentArray.{u} α) (p : α -> Bool) => Id.run.{0} Bool (Lean.PersistentArray.anyM.{u, 0} α Id.{0} Id.instMonad.{0} a (fun (x._@.Lean.Data.PersistentArray.4234178961._hygCtx._hyg.16 : α) => Pure.pure.{0, 0} Id.{0} (Applicative.toPure.{0, 0} Id.{0} (Monad.toApplicative.{0, 0} Id.{0} Id.instMonad.{0})) Bool (p x._@.Lean.Data.PersistentArray.4234178961._hygCtx._hyg.16)))
