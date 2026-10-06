import Mathlib

set_option pp.all true
-- spec: default.sizeOf : forall (α : Sort.{u}), α -> Nat
def default.sizeOf : forall (α : Sort.{u}), α -> Nat :=
  fun (α : Sort.{u}) (x._@.Init.SizeOf.3898511741._hygCtx._hyg.6 : α) => default.sizeOf.match_1.{1, u} α (fun (x._@.Init.SizeOf.3898511741._hygCtx.6.Init.SizeOf.3898511741._hygCtx._hyg.17 : α) => Nat) x._@.Init.SizeOf.3898511741._hygCtx._hyg.6 (fun (x._@.Init.SizeOf.3898511741._hygCtx._hyg.21 : α) => OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))
