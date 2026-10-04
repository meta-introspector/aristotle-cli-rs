import Mathlib

-- spec: theorem Std.Total.total : forall {α : Sort.{u}} {r : α -> α -> Prop} [self : Std.Total.{u} α r] (a : α) (b : α), Or (r a b) (r b a)
theorem Std.Total.total : forall {α : Sort.{u}} {r : α -> α -> Prop} [self : Std.Total.{u} α r] (a : α) (b : α), Or (r a b) (r b a) :=
  fun (α : Sort.{u}) (r : α -> α -> Prop) [self : Std.Total.{u} α r] => self.1
