import Mathlib

-- spec: recursor Array.rec : forall {α : Type.{u}} {motive : (Array.{u} α) -> Sort.{u_1}}, (forall (toList : List.{u} α), motive (Array.mk.{u} α toList)) -> (forall (t : Array.{u} α), motive t)
