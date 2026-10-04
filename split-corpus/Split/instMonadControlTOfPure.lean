import Mathlib

set_option pp.all true
-- spec: instMonadControlTOfPure : forall (m : Type.{u} -> Type.{v}) [inst._@.Init.Control.Basic.1060222278._hygCtx._hyg.12 : Pure.{u, v} m], MonadControlT.{u, v, v} m m
def instMonadControlTOfPure : forall (m : Type.{u} -> Type.{v}) [inst._@.Init.Control.Basic.1060222278._hygCtx._hyg.12 : Pure.{u, v} m], MonadControlT.{u, v, v} m m :=
  fun (m : Type.{u} -> Type.{v}) [inst._@.Init.Control.Basic.1060222278._hygCtx._hyg.12 : Pure.{u, v} m] => MonadControlT.mk.{u, v, v} m m (fun (α : Type.{u}) => α) (fun {α._@.Init.Control.Basic.1060222278._hygCtx._hyg.29 : Type.{u}} (f : (forall {β : Type.{u}}, (m β) -> (m β)) -> (m α._@.Init.Control.Basic.1060222278._hygCtx._hyg.29)) => f (fun {β._@.Init.Control.Basic.1060222278._hygCtx._hyg.34 : Type.{u}} (x : m β._@.Init.Control.Basic.1060222278._hygCtx._hyg.34) => x)) (fun {α._@.Init.Control.Basic.1060222278._hygCtx._hyg.39 : Type.{u}} (x : α._@.Init.Control.Basic.1060222278._hygCtx._hyg.39) => Pure.pure.{u, v} m inst._@.Init.Control.Basic.1060222278._hygCtx._hyg.12 α._@.Init.Control.Basic.1060222278._hygCtx._hyg.39 x)
