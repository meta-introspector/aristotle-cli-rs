import Mathlib

set_option pp.all true
-- spec: reprArg : forall {α : Type.{u_1}} [inst._@.Init.Data.Repr.3167227760._hygCtx._hyg.5 : Repr.{u_1} α], α -> Std.Format
def reprArg : forall {α : Type.{u_1}} [inst._@.Init.Data.Repr.3167227760._hygCtx._hyg.5 : Repr.{u_1} α], α -> Std.Format :=
  fun {α : Type.{u_1}} [inst._@.Init.Data.Repr.3167227760._hygCtx._hyg.5 : Repr.{u_1} α] (a : α) => Repr.reprPrec.{u_1} α inst._@.Init.Data.Repr.3167227760._hygCtx._hyg.5 a (OfNat.ofNat.{0} Nat 1024 (instOfNatNat 1024))
