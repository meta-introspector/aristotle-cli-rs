import Mathlib

set_option pp.all true
-- spec: Classical.ofNonempty : forall {α : Sort.{u}} [inst._@.Init.Prelude.3055515865._hygCtx._hyg.3 : Nonempty.{u} α], α
def Classical.ofNonempty : forall {α : Sort.{u}} [inst._@.Init.Prelude.3055515865._hygCtx._hyg.3 : Nonempty.{u} α], α :=
  fun {α : Sort.{u}} [inst._@.Init.Prelude.3055515865._hygCtx._hyg.3 : Nonempty.{u} α] => Classical.choice.{u} α (Classical.ofNonempty._proof_1.{u} α inst._@.Init.Prelude.3055515865._hygCtx._hyg.3)
