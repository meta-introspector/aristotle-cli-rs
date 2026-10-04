import Mathlib

set_option pp.all true
-- spec: guard : forall {f : Type -> Type.{v}} [inst._@.Init.Control.Basic.3377467048._hygCtx._hyg.12 : Alternative.{0, v} f] (p : Prop) [inst._@.Init.Control.Basic.3377467048._hygCtx._hyg.16 : Decidable p], f Unit
def guard : forall {f : Type -> Type.{v}} [inst._@.Init.Control.Basic.3377467048._hygCtx._hyg.12 : Alternative.{0, v} f] (p : Prop) [inst._@.Init.Control.Basic.3377467048._hygCtx._hyg.16 : Decidable p], f Unit :=
  fun {f : Type -> Type.{v}} [inst._@.Init.Control.Basic.3377467048._hygCtx._hyg.12 : Alternative.{0, v} f] (p : Prop) [inst._@.Init.Control.Basic.3377467048._hygCtx._hyg.16 : Decidable p] => ite.{succ v} (f Unit) p inst._@.Init.Control.Basic.3377467048._hygCtx._hyg.16 (Pure.pure.{0, v} f (Applicative.toPure.{0, v} f (Alternative.toApplicative.{0, v} f inst._@.Init.Control.Basic.3377467048._hygCtx._hyg.12)) Unit Unit.unit) (Alternative.failure.{0, v} f inst._@.Init.Control.Basic.3377467048._hygCtx._hyg.12 Unit)
