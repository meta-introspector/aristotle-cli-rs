import Mathlib

set_option pp.all true
-- spec: Classical.choose : forall {α : Sort.{u}} {p : α -> Prop}, (Exists.{u} α (fun (x : α) => p x)) -> α
def Classical.choose : forall {α : Sort.{u}} {p : α -> Prop}, (Exists.{u} α (fun (x : α) => p x)) -> α :=
  fun {α : Sort.{u}} {p : α -> Prop} (h : Exists.{u} α (fun (x : α) => p x)) => Subtype.val.{u} α (fun (x : α) => p x) (Classical.indefiniteDescription.{u} α p h)
