import Mathlib

set_option pp.all true
-- spec: instInhabitedForallOfMonad : forall {α : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.3621997913._hygCtx._hyg.6 : Monad.{u, v} m], Inhabited.{max (succ u) (succ v)} (α -> (m α))
def instInhabitedForallOfMonad : forall {α : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.3621997913._hygCtx._hyg.6 : Monad.{u, v} m], Inhabited.{max (succ u) (succ v)} (α -> (m α)) :=
  fun {α : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.3621997913._hygCtx._hyg.6 : Monad.{u, v} m] => Inhabited.mk.{max (succ u) (succ v)} (α -> (m α)) (Pure.pure.{u, v} m (Applicative.toPure.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Prelude.3621997913._hygCtx._hyg.6)) α)
