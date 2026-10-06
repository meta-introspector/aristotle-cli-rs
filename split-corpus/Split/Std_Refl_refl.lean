import Mathlib

-- spec: theorem Std.Refl.refl : forall {α : Sort.{u}} {r : α -> α -> Prop} [self : Std.Refl.{u} α r] (a : α), r a a
theorem Std.Refl.refl : forall {α : Sort.{u}} {r : α -> α -> Prop} [self : Std.Refl.{u} α r] (a : α), r a a :=
  fun (α : Sort.{u}) (r : α -> α -> Prop) [self : Std.Refl.{u} α r] => self.1
