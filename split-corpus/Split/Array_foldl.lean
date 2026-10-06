import Mathlib

set_option pp.all true
-- spec: Array.foldl : forall {α : Type.{u}} {β : Type.{v}}, (β -> α -> β) -> β -> (forall (as : Array.{u} α), (optParam.{1} Nat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (optParam.{1} Nat (Array.size.{u} α as)) -> β)
def Array.foldl : forall {α : Type.{u}} {β : Type.{v}}, (β -> α -> β) -> β -> (forall (as : Array.{u} α), (optParam.{1} Nat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (optParam.{1} Nat (Array.size.{u} α as)) -> β) :=
  fun {α : Type.{u}} {β : Type.{v}} (f : β -> α -> β) (init : β) (as : Array.{u} α) (start : Nat) (stop : Nat) => Id.run.{v} β (Array.foldlM.{u, v, v} α β Id.{v} Id.instMonad.{v} (fun (x1._@.Init.Data.Array.Basic.1478953397._hygCtx._hyg.26 : β) (x2._@.Init.Data.Array.Basic.1478953397._hygCtx._hyg.26 : α) => Pure.pure.{v, v} Id.{v} (Applicative.toPure.{v, v} Id.{v} (Monad.toApplicative.{v, v} Id.{v} Id.instMonad.{v})) β (f x1._@.Init.Data.Array.Basic.1478953397._hygCtx._hyg.26 x2._@.Init.Data.Array.Basic.1478953397._hygCtx._hyg.26)) init as start stop)
