import Mathlib

set_option pp.all true
-- spec: Not.elim : forall {a : Prop} {α : Sort.{u_1}}, (Not a) -> a -> α
def Not.elim : forall {a : Prop} {α : Sort.{u_1}}, (Not a) -> a -> α :=
  fun {a : Prop} {α : Sort.{u_1}} (H1 : Not a) (H2 : a) => absurd.{u_1} a α H2 H1
