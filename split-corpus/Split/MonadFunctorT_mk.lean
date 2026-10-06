import Mathlib

-- spec: constructor MonadFunctorT.mk : forall {m : Type.{u} -> Type.{v}} {n : Type.{u} -> Type.{w}}, (forall {α : Type.{u}}, (forall {β : Type.{u}}, (m β) -> (m β)) -> (n α) -> (n α)) -> (MonadFunctorT.{u, v, w} m n)
