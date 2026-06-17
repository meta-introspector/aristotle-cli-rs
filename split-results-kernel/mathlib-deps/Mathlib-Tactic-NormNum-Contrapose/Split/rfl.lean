import Mathlib

set_option pp.all true
-- spec: rfl : forall {α : Sort.{u}} {a : α}, Eq.{u} α a a
def rfl : forall {α : Sort.{u}} {a : α}, Eq.{u} α a a :=
  fun {α : Sort.{u}} {a : α} => Eq.refl.{u} α a
