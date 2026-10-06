import Mathlib

set_option pp.all true
-- spec: Function.const : forall {α : Sort.{u}} (β : Sort.{v}), α -> β -> α
def Function.const : forall {α : Sort.{u}} (β : Sort.{v}), α -> β -> α :=
  fun {α : Sort.{u}} (β : Sort.{v}) (a : α) (x._@.Init.Prelude.3831309539._hygCtx._hyg.10 : β) => a
