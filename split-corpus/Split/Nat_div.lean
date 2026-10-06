import Mathlib

set_option pp.all true
-- spec: Nat.div : ([mdata borrowed:1 Nat]) -> ([mdata borrowed:1 Nat]) -> Nat
def Nat.div : ([mdata borrowed:1 Nat]) -> ([mdata borrowed:1 Nat]) -> Nat :=
  fun (x : Nat) (y : Nat) => dite.{1} Nat (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) y) (Nat.decLt (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) y) (fun (hy : LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) y) => Nat.div.go y hy (Nat.succ x) x (Nat.lt_succ_self x)) (fun (x._@.Init.Prelude.2515639154._hygCtx._hyg.93 : Not (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) y)) => OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))
