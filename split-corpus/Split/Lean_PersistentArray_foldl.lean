import Mathlib

set_option pp.all true
-- spec: Lean.PersistentArray.foldl : forall {α : Type.{u}} {β : Type.{u_1}}, (Lean.PersistentArray.{u} α) -> (β -> α -> β) -> β -> (optParam.{1} Nat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> β
def Lean.PersistentArray.foldl : forall {α : Type.{u}} {β : Type.{u_1}}, (Lean.PersistentArray.{u} α) -> (β -> α -> β) -> β -> (optParam.{1} Nat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> β :=
  fun {α : Type.{u}} {β : Type.{u_1}} (t : Lean.PersistentArray.{u} α) (f : β -> α -> β) (init : β) (start : Nat) => Id.run.{u_1} β (Lean.PersistentArray.foldlM.{u, u_1, u_1} α Id.{u_1} Id.instMonad.{u_1} β t (fun (x1._@.Lean.Data.PersistentArray.1478953397._hygCtx._hyg.25 : β) (x2._@.Lean.Data.PersistentArray.1478953397._hygCtx._hyg.25 : α) => Pure.pure.{u_1, u_1} Id.{u_1} (Applicative.toPure.{u_1, u_1} Id.{u_1} (Monad.toApplicative.{u_1, u_1} Id.{u_1} Id.instMonad.{u_1})) β (f x1._@.Lean.Data.PersistentArray.1478953397._hygCtx._hyg.25 x2._@.Lean.Data.PersistentArray.1478953397._hygCtx._hyg.25)) init start)
