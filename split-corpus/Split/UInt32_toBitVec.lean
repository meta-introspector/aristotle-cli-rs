import Mathlib

set_option pp.all true
-- spec: UInt32.toBitVec : UInt32 -> (BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32)))
def UInt32.toBitVec : UInt32 -> (BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) :=
  fun (self : UInt32) => self.1
