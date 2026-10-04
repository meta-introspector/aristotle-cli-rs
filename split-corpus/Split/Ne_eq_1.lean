import Mathlib

-- spec: theorem Ne.eq_1 : forall {α : Sort.{u}} (a : α) (b : α), Eq.{1} Prop (Ne.{u} α a b) (Not (Eq.{u} α a b))
theorem Ne.eq_1 : forall {α : Sort.{u}} (a : α) (b : α), Eq.{1} Prop (Ne.{u} α a b) (Not (Eq.{u} α a b)) :=
  fun {α : Sort.{u}} (a : α) (b : α) => Eq.refl.{1} Prop (Ne.{u} α a b)
