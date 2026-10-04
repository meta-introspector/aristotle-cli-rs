import Mathlib

set_option pp.all true
-- spec: System.Platform.numBits : Nat
def System.Platform.numBits : Nat :=
  Subtype.val.{1} Nat (fun (n : Nat) => Or (Eq.{1} Nat n (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (Eq.{1} Nat n (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64)))) (System.Platform.getNumBits Unit.unit)
