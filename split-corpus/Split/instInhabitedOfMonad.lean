import Mathlib

set_option pp.all true
-- spec: instInhabitedOfMonad : forall {α : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.3036327251._hygCtx._hyg.6 : Monad.{u, v} m] [inst._@.Init.Prelude.3036327251._hygCtx._hyg.9 : Inhabited.{succ u} α], Inhabited.{succ v} (m α)
def instInhabitedOfMonad : forall {α : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.3036327251._hygCtx._hyg.6 : Monad.{u, v} m] [inst._@.Init.Prelude.3036327251._hygCtx._hyg.9 : Inhabited.{succ u} α], Inhabited.{succ v} (m α) :=
  fun {α : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.3036327251._hygCtx._hyg.6 : Monad.{u, v} m] [inst._@.Init.Prelude.3036327251._hygCtx._hyg.9 : Inhabited.{succ u} α] => Inhabited.mk.{succ v} (m α) (Pure.pure.{u, v} m (Applicative.toPure.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Prelude.3036327251._hygCtx._hyg.6)) α (Inhabited.default.{succ u} α inst._@.Init.Prelude.3036327251._hygCtx._hyg.9))
