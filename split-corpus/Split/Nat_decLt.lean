import Mathlib

set_option pp.all true
-- spec: Nat.decLt : forall (n : [mdata borrowed:1 Nat]) (m : [mdata borrowed:1 Nat]), Decidable (LT.lt.{0} ([mdata borrowed:1 Nat]) instLTNat n m)
def Nat.decLt : forall (n : [mdata borrowed:1 Nat]) (m : [mdata borrowed:1 Nat]), Decidable (LT.lt.{0} ([mdata borrowed:1 Nat]) instLTNat n m) :=
  fun (n : Nat) (m : Nat) => Nat.decLe (Nat.succ n) m
