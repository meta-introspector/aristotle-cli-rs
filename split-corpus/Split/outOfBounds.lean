import Mathlib

set_option pp.all true
-- spec: outOfBounds : forall {α : Sort.{u_1}} [inst._@.Init.GetElem.4292658080._hygCtx._hyg.5 : Inhabited.{u_1} α], α
def outOfBounds : forall {α : Sort.{u_1}} [inst._@.Init.GetElem.4292658080._hygCtx._hyg.5 : Inhabited.{u_1} α], α :=
  fun {α : Sort.{u_1}} [inst._@.Init.GetElem.4292658080._hygCtx._hyg.5 : Inhabited.{u_1} α] => panicWithPosWithDecl.{u_1} α inst._@.Init.GetElem.4292658080._hygCtx._hyg.5 "Init.GetElem" "outOfBounds" (OfNat.ofNat.{0} Nat 18 (instOfNatNat 18)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) "index out of bounds"
