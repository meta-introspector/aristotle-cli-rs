import Mathlib

set_option pp.all true
-- spec: Lean.PersistentArray.findSomeRev? : forall {α : Type.{u}} {β : Type.{u_1}}, (Lean.PersistentArray.{u} α) -> (α -> (Option.{u_1} β)) -> (Option.{u_1} β)
def Lean.PersistentArray.findSomeRev? : forall {α : Type.{u}} {β : Type.{u_1}}, (Lean.PersistentArray.{u} α) -> (α -> (Option.{u_1} β)) -> (Option.{u_1} β) :=
  fun {α : Type.{u}} {β : Type.{u_1}} (t : Lean.PersistentArray.{u} α) (f : α -> (Option.{u_1} β)) => Id.run.{u_1} (Option.{u_1} β) (Lean.PersistentArray.findSomeRevM?.{u, u_1, u_1} α Id.{u_1} Id.instMonad.{u_1} β t (fun (x._@.Lean.Data.PersistentArray.3530091042._hygCtx._hyg.20 : α) => Pure.pure.{u_1, u_1} Id.{u_1} (Applicative.toPure.{u_1, u_1} Id.{u_1} (Monad.toApplicative.{u_1, u_1} Id.{u_1} Id.instMonad.{u_1})) (Option.{u_1} β) (f x._@.Lean.Data.PersistentArray.3530091042._hygCtx._hyg.20)))
