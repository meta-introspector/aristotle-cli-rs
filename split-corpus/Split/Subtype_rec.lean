import Mathlib

-- spec: recursor Subtype.rec : forall {α : Sort.{u}} {p : α -> Prop} {motive : (Subtype.{u} α p) -> Sort.{u_1}}, (forall (val : α) (property : p val), motive (Subtype.mk.{u} α p val property)) -> (forall (t : Subtype.{u} α p), motive t)
