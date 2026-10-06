import Mathlib

set_option pp.all true
-- spec: repr : forall {α : Type.{u_1}} [inst._@.Init.Data.Repr.682344310._hygCtx._hyg.5 : Repr.{u_1} α], α -> Std.Format
def repr : forall {α : Type.{u_1}} [inst._@.Init.Data.Repr.682344310._hygCtx._hyg.5 : Repr.{u_1} α], α -> Std.Format :=
  fun {α : Type.{u_1}} [inst._@.Init.Data.Repr.682344310._hygCtx._hyg.5 : Repr.{u_1} α] (a : α) => Repr.reprPrec.{u_1} α inst._@.Init.Data.Repr.682344310._hygCtx._hyg.5 a (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))
