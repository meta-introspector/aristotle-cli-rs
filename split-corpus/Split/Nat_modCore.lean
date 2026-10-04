import Mathlib

set_option pp.all true
-- spec: Nat.modCore : Nat -> Nat -> Nat
def Nat.modCore : Nat -> Nat -> Nat :=
  fun (x : Nat) (y : Nat) => dite.{1} Nat (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) y) (Nat.decLt (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) y) (fun (hy : LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) y) => Nat.modCore.go y hy (Nat.succ x) x (Nat.lt_succ_self x)) (fun (x._@.Init.Prelude.4249794159._hygCtx._hyg.87 : Not (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) y)) => x)
