import Mathlib

set_option pp.all true
-- spec: ReaderT.bind : forall {ρ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.3640351540._hygCtx._hyg.6 : Monad.{u, v} m] {α : Type.{u}} {β : Type.{u}}, (ReaderT.{u, v} ρ m α) -> (α -> (ReaderT.{u, v} ρ m β)) -> (ReaderT.{u, v} ρ m β)
def ReaderT.bind : forall {ρ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.3640351540._hygCtx._hyg.6 : Monad.{u, v} m] {α : Type.{u}} {β : Type.{u}}, (ReaderT.{u, v} ρ m α) -> (α -> (ReaderT.{u, v} ρ m β)) -> (ReaderT.{u, v} ρ m β) :=
  fun {ρ : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Prelude.3640351540._hygCtx._hyg.6 : Monad.{u, v} m] {α : Type.{u}} {β : Type.{u}} (x : ReaderT.{u, v} ρ m α) (f : α -> (ReaderT.{u, v} ρ m β)) (r : ρ) => Bind.bind.{u, v} m (Monad.toBind.{u, v} m inst._@.Init.Prelude.3640351540._hygCtx._hyg.6) α β (x r) (fun (a : α) => f a r)
