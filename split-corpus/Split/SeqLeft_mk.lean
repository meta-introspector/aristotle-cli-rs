import Mathlib

-- spec: constructor SeqLeft.mk : forall {f : Type.{u} -> Type.{v}}, (forall {α : Type.{u}} {β : Type.{u}}, (f α) -> (Unit -> (f β)) -> (f α)) -> (SeqLeft.{u, v} f)
