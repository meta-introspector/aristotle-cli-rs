import Mathlib

-- spec: theorem eq_self : forall {α : Sort.{u_1}} (a : α), Eq.{1} Prop (Eq.{u_1} α a a) True
theorem eq_self : forall {α : Sort.{u_1}} (a : α), Eq.{1} Prop (Eq.{u_1} α a a) True :=
  fun {α : Sort.{u_1}} (a : α) => eq_true (Eq.{u_1} α a a) (rfl.{u_1} α a)
