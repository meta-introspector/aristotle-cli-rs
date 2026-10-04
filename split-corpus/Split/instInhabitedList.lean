import Mathlib

set_option pp.all true
-- spec: instInhabitedList : forall {α : Type.{u_1}}, Inhabited.{succ u_1} (List.{u_1} α)
def instInhabitedList : forall {α : Type.{u_1}}, Inhabited.{succ u_1} (List.{u_1} α) :=
  fun {α : Type.{u_1}} => Inhabited.mk.{succ u_1} (List.{u_1} α) (List.nil.{u_1} α)
