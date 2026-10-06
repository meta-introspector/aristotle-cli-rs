import Mathlib

-- spec: constructor MonadControlT.mk : forall {m : Type.{u} -> Type.{v}} {n : Type.{u} -> Type.{w}} (stM : Type.{u} -> Type.{u}), (forall {α : Type.{u}}, ((forall {β : Type.{u}}, (n β) -> (m (stM β))) -> (m α)) -> (n α)) -> (forall {α : Type.{u}}, (stM α) -> (n α)) -> (MonadControlT.{u, v, w} m n)
