import Mathlib

set_option pp.all true
-- spec: UInt64.toBitVec : UInt64 -> (BitVec (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64)))
def UInt64.toBitVec : UInt64 -> (BitVec (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64))) :=
  fun (self : UInt64) => self.1
