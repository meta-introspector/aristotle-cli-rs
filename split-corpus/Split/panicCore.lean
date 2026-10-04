import Mathlib

set_option pp.all true
-- spec: panicCore : forall {α : Sort.{u}} [inst._@.Init.Prelude.4048948229._hygCtx._hyg.3 : Inhabited.{u} α], String -> α
def panicCore : forall {α : Sort.{u}} [inst._@.Init.Prelude.4048948229._hygCtx._hyg.3 : Inhabited.{u} α], String -> α :=
  fun {α : Sort.{u}} [inst._@.Init.Prelude.4048948229._hygCtx._hyg.3 : Inhabited.{u} α] (msg : String) => Inhabited.default.{u} α inst._@.Init.Prelude.4048948229._hygCtx._hyg.3
