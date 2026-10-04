import Mathlib

-- spec: constructor Acc.intro : forall {α : Sort.{u}} {r : α -> α -> Prop} (x : α), (forall (y : α), (r y x) -> (Acc.{u} α r y)) -> (Acc.{u} α r x)
