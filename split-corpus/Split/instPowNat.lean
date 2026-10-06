import Mathlib

set_option pp.all true
-- spec: instPowNat : forall {α : Type.{u_1}} [inst._@.Init.Prelude.3231272351._hygCtx._hyg.5 : NatPow.{u_1} α], Pow.{u_1, 0} α Nat
def instPowNat : forall {α : Type.{u_1}} [inst._@.Init.Prelude.3231272351._hygCtx._hyg.5 : NatPow.{u_1} α], Pow.{u_1, 0} α Nat :=
  fun {α : Type.{u_1}} [inst._@.Init.Prelude.3231272351._hygCtx._hyg.5 : NatPow.{u_1} α] => Pow.mk.{u_1, 0} α Nat (fun (a : α) (n : Nat) => NatPow.pow.{u_1} α inst._@.Init.Prelude.3231272351._hygCtx._hyg.5 a n)
