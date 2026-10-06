import Mathlib

-- spec: theorem Ne.symm : forall {α : Sort.{u}} {a : α} {b : α}, (Ne.{u} α a b) -> (Ne.{u} α b a)
theorem Ne.symm : forall {α : Sort.{u}} {a : α} {b : α}, (Ne.{u} α a b) -> (Ne.{u} α b a) :=
  fun {α : Sort.{u}} {a : α} {b : α} (h : Ne.{u} α a b) (h₁ : Eq.{u} α b a) => h (Eq.symm.{u} α b a h₁)
