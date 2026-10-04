import Mathlib

set_option pp.all true
-- spec: DA51Address.bits : DA51Address -> (BitVec (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64)))
def DA51Address.bits : DA51Address -> (BitVec (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64))) :=
  fun (self : DA51Address) => self.1
