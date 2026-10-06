import Mathlib

set_option pp.all true
-- spec: Array.instMembership : forall {α : Type.{u}}, Membership.{u, u} α (Array.{u} α)
def Array.instMembership : forall {α : Type.{u}}, Membership.{u, u} α (Array.{u} α) :=
  fun {α : Type.{u}} => Membership.mk.{u, u} α (Array.{u} α) (Array.Mem.{u} α)
