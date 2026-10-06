import Mathlib

-- spec: constructor Seq.mk : forall {f : Type.{u} -> Type.{v}}, (forall {α : Type.{u}} {β : Type.{u}}, (f (α -> β)) -> (Unit -> (f α)) -> (f β)) -> (Seq.{u, v} f)
