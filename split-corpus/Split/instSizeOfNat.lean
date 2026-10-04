import Mathlib

set_option pp.all true
-- spec: instSizeOfNat : SizeOf.{1} Nat
def instSizeOfNat : SizeOf.{1} Nat :=
  SizeOf.mk.{1} Nat (fun (n : Nat) => n)
