import Mathlib

set_option pp.all true
-- spec: instHashableNat : Hashable.{1} Nat
def instHashableNat : Hashable.{1} Nat :=
  Hashable.mk.{1} Nat (fun (n : Nat) => UInt64.ofNat n)
