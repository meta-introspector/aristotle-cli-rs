import Mathlib

-- spec: theorem Classical.choose_spec : forall {α : Sort.{u}} {p : α -> Prop} (h : Exists.{u} α (fun (x : α) => p x)), p (Classical.choose.{u} α p h)
theorem Classical.choose_spec : forall {α : Sort.{u}} {p : α -> Prop} (h : Exists.{u} α (fun (x : α) => p x)), p (Classical.choose.{u} α p h) :=
  fun {α : Sort.{u}} {p : α -> Prop} (h : Exists.{u} α (fun (x : α) => p x)) => Subtype.property.{u} α (fun (x : α) => p x) (Classical.indefiniteDescription.{u} α p h)
