import Mathlib

-- spec: theorem Std.Antisymm.antisymm : forall {α : Sort.{u}} {r : α -> α -> Prop} [self : Std.Antisymm.{u} α r] (a : α) (b : α), (r a b) -> (r b a) -> (Eq.{u} α a b)
theorem Std.Antisymm.antisymm : forall {α : Sort.{u}} {r : α -> α -> Prop} [self : Std.Antisymm.{u} α r] (a : α) (b : α), (r a b) -> (r b a) -> (Eq.{u} α a b) :=
  fun (α : Sort.{u}) (r : α -> α -> Prop) [self : Std.Antisymm.{u} α r] => self.1
