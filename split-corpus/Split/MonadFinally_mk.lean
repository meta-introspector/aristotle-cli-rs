import Mathlib

-- spec: constructor MonadFinally.mk : forall {m : Type.{u} -> Type.{v}}, (forall {α : Type.{u}} {β : Type.{u}}, (m α) -> ((Option.{u} α) -> (m β)) -> (m (Prod.{u, u} α β))) -> (MonadFinally.{u, v} m)
