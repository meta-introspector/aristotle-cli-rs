import Mathlib

set_option pp.all true
-- spec: instOrdNat : Ord.{0} Nat
def instOrdNat : Ord.{0} Nat :=
  Ord.mk.{0} Nat (fun (x : Nat) (y : Nat) => compareOfLessAndEq.{0} Nat x y instLTNat (Nat.decLt x y) instDecidableEqNat)
