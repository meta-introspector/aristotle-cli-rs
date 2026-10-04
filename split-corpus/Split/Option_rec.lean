import Mathlib

-- spec: recursor Option.rec : forall {α : Type.{u}} {motive : (Option.{u} α) -> Sort.{u_1}}, (motive (Option.none.{u} α)) -> (forall (val : α), motive (Option.some.{u} α val)) -> (forall (t : Option.{u} α), motive t)
