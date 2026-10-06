import Mathlib

-- spec: theorem Subtype.property : forall {α : Sort.{u}} {p : α -> Prop} (self : Subtype.{u} α p), p (Subtype.val.{u} α p self)
theorem Subtype.property : forall {α : Sort.{u}} {p : α -> Prop} (self : Subtype.{u} α p), p (Subtype.val.{u} α p self) :=
  fun (α : Sort.{u}) (p : α -> Prop) (self : Subtype.{u} α p) => self.2
