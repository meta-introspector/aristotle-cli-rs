import Mathlib

set_option pp.all true
-- spec: namedPattern : forall {α : Sort.{u}} (x : α) (a : α), (Eq.{u} α x a) -> α
def namedPattern : forall {α : Sort.{u}} (x : α) (a : α), (Eq.{u} α x a) -> α :=
  fun {α : Sort.{u}} (x : α) (a : α) (h : Eq.{u} α x a) => a
