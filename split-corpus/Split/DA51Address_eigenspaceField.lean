import Mathlib

set_option pp.all true
-- spec: DA51Address.eigenspaceField : DA51Address -> (BitVec (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)))
def DA51Address.eigenspaceField : DA51Address -> (BitVec (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2))) :=
  fun (addr : DA51Address) => BitVec.extractLsb (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64)) (OfNat.ofNat.{0} Nat 43 (instOfNatNat 43)) (OfNat.ofNat.{0} Nat 42 (instOfNatNat 42)) (DA51Address.bits addr)
