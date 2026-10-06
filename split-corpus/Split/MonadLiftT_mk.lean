import Mathlib

-- spec: constructor MonadLiftT.mk : forall {m : Type.{u} -> Type.{v}} {n : Type.{u} -> Type.{w}}, (forall {α : Type.{u}}, (m α) -> (n α)) -> (MonadLiftT.{u, v, w} m n)
