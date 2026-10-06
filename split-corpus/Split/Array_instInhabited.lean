import Mathlib

set_option pp.all true
-- spec: Array.instInhabited : forall {α : Type.{u}}, Inhabited.{succ u} (Array.{u} α)
def Array.instInhabited : forall {α : Type.{u}}, Inhabited.{succ u} (Array.{u} α) :=
  fun {α : Type.{u}} => Inhabited.mk.{succ u} (Array.{u} α) (Array.empty.{u} α)
