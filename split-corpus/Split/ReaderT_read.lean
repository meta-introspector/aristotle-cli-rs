import Mathlib

set_option pp.all true
-- spec: ReaderT.read : forall {ρ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.4232613360._hygCtx._hyg.6 : Monad.{u, v} m], ReaderT.{u, v} ρ m ρ
def ReaderT.read : forall {ρ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.4232613360._hygCtx._hyg.6 : Monad.{u, v} m], ReaderT.{u, v} ρ m ρ :=
  fun {ρ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.4232613360._hygCtx._hyg.6 : Monad.{u, v} m] => Pure.pure.{u, v} m (Applicative.toPure.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Prelude.4232613360._hygCtx._hyg.6)) ρ
