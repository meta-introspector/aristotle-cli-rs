import Mathlib

-- spec: theorem LawfulMonad.toLawfulApplicative : forall {m : Type.{u} -> Type.{v}} {inst._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.5 : Monad.{u, v} m} [self : LawfulMonad.{u, v} m inst._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.5], LawfulApplicative.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.5)
theorem LawfulMonad.toLawfulApplicative : forall {m : Type.{u} -> Type.{v}} {inst._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.5 : Monad.{u, v} m} [self : LawfulMonad.{u, v} m inst._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.5], LawfulApplicative.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.5) :=
  fun (m : Type.{u} -> Type.{v}) {inst._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.5 : Monad.{u, v} m} [self : LawfulMonad.{u, v} m inst._@.Init.Control.Lawful.Basic.1965207783._hygCtx._hyg.5] => self.1
