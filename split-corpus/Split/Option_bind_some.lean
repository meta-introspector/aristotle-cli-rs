import Mathlib

-- spec: theorem Option.bind_some : forall {α : Type.{u_1}} {β : Type.{u_2}} (a : α) (f : α -> (Option.{u_2} β)), Eq.{succ u_2} (Option.{u_2} β) (Option.bind.{u_1, u_2} α β (Option.some.{u_1} α a) f) (f a)
theorem Option.bind_some : forall {α : Type.{u_1}} {β : Type.{u_2}} (a : α) (f : α -> (Option.{u_2} β)), Eq.{succ u_2} (Option.{u_2} β) (Option.bind.{u_1, u_2} α β (Option.some.{u_1} α a) f) (f a) :=
  fun {α : Type.{u_1}} {β : Type.{u_2}} (a : α) (f : α -> (Option.{u_2} β)) => rfl.{succ u_2} (Option.{u_2} β) (Option.bind.{u_1, u_2} α β (Option.some.{u_1} α a) f)
