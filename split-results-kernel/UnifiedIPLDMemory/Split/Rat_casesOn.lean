import Split.Nat_Coprime
import Split.Rat
import Split.Ne
import Split.instOfNatNat
import Split.Int
import Split.Rat_rec
import Split.Nat
import Split.Int_natAbs
import Split.Rat_mk'
import Split.OfNat_ofNat

-- Rat.casesOn from environment
-- def Rat.casesOn : forall {motive : Rat -> Sort.{u}} (t : Rat), (forall (num : Int) (den : Nat) (den_nz : Ne.{1} Nat den (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (reduced : Nat.Coprime (Int.natAbs num) den), motive (Rat.mk' num den den_nz reduced)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `Rat.casesOn`.
-- In a full split, the body would be extracted from the environment.
