import Split.instOfNatNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.OfNat_ofNat
import Split.Nat_casesOn

-- Nat.casesAuxOn from environment
-- def Nat.casesAuxOn : forall {motive : Nat -> Sort.{u}} (t : Nat), (motive (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (forall (n : Nat), motive (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `Nat.casesAuxOn`.
-- In a full split, the body would be extracted from the environment.
