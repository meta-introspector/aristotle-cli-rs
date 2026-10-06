import Mathlib

set_option pp.all true
-- spec: DA51Address.toEigenspace? : DA51Address -> (Option.{0} Eigenspace)
def DA51Address.toEigenspace? : DA51Address -> (Option.{0} Eigenspace) :=
  fun (addr : DA51Address) => ite.{1} (Option.{0} Eigenspace) (Eq.{1} (BitVec (OfNat.ofNat.{0} Nat 4 (instOfNatNat 4))) (DA51Address.typeField addr) (AddressType.toUInt4 AddressType.eigenspace)) (instDecidableEqBitVec (OfNat.ofNat.{0} Nat 4 (instOfNatNat 4)) (DA51Address.typeField addr) (AddressType.toUInt4 AddressType.eigenspace)) (DA51Address.toEigenspace?.match_1.{1} (fun (x._@.RequestProject.DA51.4089292305._hygCtx._hyg.19 : Nat) => Option.{0} Eigenspace) (BitVec.toNat (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) (DA51Address.eigenspaceField addr)) (fun (_ : Unit) => Option.some.{0} Eigenspace Eigenspace.earth) (fun (_ : Unit) => Option.some.{0} Eigenspace Eigenspace.spoke) (fun (_ : Unit) => Option.some.{0} Eigenspace Eigenspace.hub) (fun (x._@.RequestProject.DA51.4089292305._hygCtx._hyg.35 : Nat) => Option.some.{0} Eigenspace Eigenspace.clock)) (Option.none.{0} Eigenspace)
