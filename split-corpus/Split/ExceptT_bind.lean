import Mathlib

set_option pp.all true
-- spec: ExceptT.bind : forall {ε : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.Except.3640351541._hygCtx._hyg.6 : Monad.{u, v} m] {α : Type.{u}} {β : Type.{u}}, (ExceptT.{u, v} ε m α) -> (α -> (ExceptT.{u, v} ε m β)) -> (ExceptT.{u, v} ε m β)
def ExceptT.bind : forall {ε : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.Except.3640351541._hygCtx._hyg.6 : Monad.{u, v} m] {α : Type.{u}} {β : Type.{u}}, (ExceptT.{u, v} ε m α) -> (α -> (ExceptT.{u, v} ε m β)) -> (ExceptT.{u, v} ε m β) :=
  fun {ε : Type.{u}} {m : Type.{u} -> Type.{v}} [inst._@.Init.Control.Except.3640351541._hygCtx._hyg.6 : Monad.{u, v} m] {α : Type.{u}} {β : Type.{u}} (ma : ExceptT.{u, v} ε m α) (f : α -> (ExceptT.{u, v} ε m β)) => ExceptT.mk.{u, v} ε m β (Bind.bind.{u, v} m (Monad.toBind.{u, v} m inst._@.Init.Control.Except.3640351541._hygCtx._hyg.6) (Except.{u, u} ε α) (Except.{u, u} ε β) ma (ExceptT.bindCont.{u, v} ε m inst._@.Init.Control.Except.3640351541._hygCtx._hyg.6 α β f))
