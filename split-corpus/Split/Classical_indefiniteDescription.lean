import Mathlib

set_option pp.all true
-- spec: Classical.indefiniteDescription : forall {α : Sort.{u}} (p : α -> Prop), (Exists.{u} α (fun (x : α) => p x)) -> (Subtype.{u} α (fun (x : α) => p x))
def Classical.indefiniteDescription : forall {α : Sort.{u}} (p : α -> Prop), (Exists.{u} α (fun (x : α) => p x)) -> (Subtype.{u} α (fun (x : α) => p x)) :=
  fun {α : Sort.{u}} (p : α -> Prop) (h : Exists.{u} α (fun (x : α) => p x)) => Classical.choice.{max 1 u} (Subtype.{u} α (fun (x : α) => p x)) (Classical.indefiniteDescription._proof_1.{u} α p h)
