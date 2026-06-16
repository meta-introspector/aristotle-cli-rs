import Split.Nat_Coprime
import Split.Int_instDiv
import Split.Dvd_dvd
import Split.instHDiv
import Split.Rat
import Split.Int_divExact
import Split.HDiv_hDiv
import Split.Ne
import Split.instOfNatNat
import Split.Int
import Split.Nat_cast
import Split.dite
import Split.Int_instDvd
import Split.Nat_instDvd
import Split.Nat
import Split.Int_natAbs
import Split.Nat_instDiv
import Split.instDecidableEqNat
import Split.instNatCastInt
import Split.Rat_mk'
import Split.OfNat_ofNat
import Split.Eq
import Split.Not
import Split.Nat_divExact

-- Rat.maybeNormalize from environment
-- def Rat.maybeNormalize : forall (num : Int) (den : Nat) (g : Nat), (Dvd.dvd.{0} Int Int.instDvd (Nat.cast.{0} Int instNatCastInt g) num) -> (Dvd.dvd.{0} Nat Nat.instDvd g den) -> (Ne.{1} Nat (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) den g) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (Nat.Coprime (Int.natAbs (HDiv.hDiv.{0, 0, 0} Int Int Int (instHDiv.{0} Int Int.instDiv) num (Nat.cast.{0} Int instNatCastInt g))) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) den g)) -> Rat
-- (definition body omitted)

-- Stub: this file represents the declaration `Rat.maybeNormalize`.
-- In a full split, the body would be extracted from the environment.
