import Mathlib

-- spec: constructor Alternative.mk : forall {f : Type.{u} -> Type.{v}} [toApplicative : Applicative.{u, v} f], (forall {α : Type.{u}}, f α) -> (forall {α : Type.{u}}, (f α) -> (Unit -> (f α)) -> (f α)) -> (Alternative.{u, v} f)
