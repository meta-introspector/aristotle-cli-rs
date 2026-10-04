import Mathlib

set_option pp.all true
-- spec: DA51Address.typeField : DA51Address -> (BitVec (OfNat.ofNat.{0} Nat 4 (instOfNatNat 4)))
def DA51Address.typeField : DA51Address -> (BitVec (OfNat.ofNat.{0} Nat 4 (instOfNatNat 4))) :=
  fun (addr : DA51Address) => BitVec.extractLsb (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64)) (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47)) (OfNat.ofNat.{0} Nat 44 (instOfNatNat 44)) (DA51Address.bits addr)
