import Mathlib

set_option pp.all true
-- spec: instToStringNat : ToString.{0} Nat
def instToStringNat : ToString.{0} Nat :=
  ToString.mk.{0} Nat (fun (n : Nat) => Nat.repr n)
