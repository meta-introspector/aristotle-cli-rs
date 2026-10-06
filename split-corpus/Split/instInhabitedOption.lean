import Mathlib

set_option pp.all true
-- spec: instInhabitedOption : forall {α : Type.{u_1}}, Inhabited.{succ u_1} (Option.{u_1} α)
def instInhabitedOption : forall {α : Type.{u_1}}, Inhabited.{succ u_1} (Option.{u_1} α) :=
  fun {α : Type.{u_1}} => Inhabited.mk.{succ u_1} (Option.{u_1} α) (Option.none.{u_1} α)
