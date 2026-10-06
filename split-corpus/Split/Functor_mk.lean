import Mathlib

-- spec: constructor Functor.mk : forall {f : Type.{u} -> Type.{v}}, (forall {α : Type.{u}} {β : Type.{u}}, (α -> β) -> (f α) -> (f β)) -> (forall {α : Type.{u}} {β : Type.{u}}, α -> (f β) -> (f α)) -> (Functor.{u, v} f)
