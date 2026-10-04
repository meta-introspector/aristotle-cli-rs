import Mathlib

-- spec: constructor Std.Antisymm.mk : forall {α : Sort.{u}} {r : α -> α -> Prop}, (forall (a : α) (b : α), (r a b) -> (r b a) -> (Eq.{u} α a b)) -> (Std.Antisymm.{u} α r)
