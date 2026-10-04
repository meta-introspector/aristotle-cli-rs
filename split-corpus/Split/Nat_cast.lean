import Mathlib

set_option pp.all true
-- spec: Nat.cast : forall {R : Type.{u}} [inst._@.Init.Data.Cast.135197979._hygCtx._hyg.3 : NatCast.{u} R], Nat -> R
def Nat.cast : forall {R : Type.{u}} [inst._@.Init.Data.Cast.135197979._hygCtx._hyg.3 : NatCast.{u} R], Nat -> R :=
  fun {R : Type.{u}} [inst._@.Init.Data.Cast.135197979._hygCtx._hyg.3 : NatCast.{u} R] => NatCast.natCast.{u} R inst._@.Init.Data.Cast.135197979._hygCtx._hyg.3
