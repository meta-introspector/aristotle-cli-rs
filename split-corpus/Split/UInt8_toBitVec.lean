import Mathlib

set_option pp.all true
-- spec: UInt8.toBitVec : UInt8 -> (BitVec (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)))
def UInt8.toBitVec : UInt8 -> (BitVec (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) :=
  fun (self : UInt8) => self.1
