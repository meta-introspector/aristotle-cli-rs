import Mathlib

set_option pp.all true
-- spec: panic : forall {α : Sort.{u}} [inst._@.Init.Prelude.2928479692._hygCtx._hyg.3 : Inhabited.{u} α], String -> α
def panic : forall {α : Sort.{u}} [inst._@.Init.Prelude.2928479692._hygCtx._hyg.3 : Inhabited.{u} α], String -> α :=
  fun {α : Sort.{u}} [inst._@.Init.Prelude.2928479692._hygCtx._hyg.3 : Inhabited.{u} α] (msg : String) => panicCore.{u} α inst._@.Init.Prelude.2928479692._hygCtx._hyg.3 msg
