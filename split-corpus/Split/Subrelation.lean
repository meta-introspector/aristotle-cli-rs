import Mathlib

set_option pp.all true
-- spec: Subrelation : forall {α : Sort.{u}}, (α -> α -> Prop) -> (α -> α -> Prop) -> Prop
def Subrelation : forall {α : Sort.{u}}, (α -> α -> Prop) -> (α -> α -> Prop) -> Prop :=
  fun {α : Sort.{u}} (q : α -> α -> Prop) (r : α -> α -> Prop) => forall {x : α} {y : α}, (q x y) -> (r x y)
