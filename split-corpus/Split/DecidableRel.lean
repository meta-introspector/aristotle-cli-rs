import Mathlib

set_option pp.all true
-- spec: DecidableRel : forall {α : Sort.{u}} {β : Sort.{v}}, (α -> β -> Prop) -> Sort.{max (max 1 u) v}
def DecidableRel : forall {α : Sort.{u}} {β : Sort.{v}}, (α -> β -> Prop) -> Sort.{max (max 1 u) v} :=
  fun {α : Sort.{u}} {β : Sort.{v}} (r : α -> β -> Prop) => forall (a : α) (b : β), Decidable (r a b)
