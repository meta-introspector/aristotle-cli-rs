import Mathlib

-- spec: constructor SeqRight.mk : forall {f : Type.{u} -> Type.{v}}, (forall {α : Type.{u}} {β : Type.{u}}, (f α) -> (Unit -> (f β)) -> (f β)) -> (SeqRight.{u, v} f)
