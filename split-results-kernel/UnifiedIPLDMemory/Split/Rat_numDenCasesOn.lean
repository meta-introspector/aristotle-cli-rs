import Split.Eq_mpr
import Split.Nat_Coprime
import Split.Rat
import Split.Rat_divInt
import Split.Ne
import Split.instOfNatNat
import Split.Int
import Split.Nat_cast
import Split.Nat_pos_of_ne_zero
import Split.Nat
import Split.LT_lt
import Split.Int_natAbs
import Split.instNatCastInt
import Split.instLTNat
import Split.Rat_mk'
import Split.OfNat_ofNat
import Split.Rat_numDenCasesOn_match_1

-- Rat.numDenCasesOn from environment
-- def Rat.numDenCasesOn : forall {C : Rat -> Sort.{u}} (a : Rat), (forall (n : [mdata borrowed:1 Int]) (d : Nat), (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) d) -> (Nat.Coprime (Int.natAbs n) d) -> (C (Rat.divInt n (Nat.cast.{0} Int instNatCastInt d)))) -> (C a)
-- (definition body omitted)

-- Stub: this file represents the declaration `Rat.numDenCasesOn`.
-- In a full split, the body would be extracted from the environment.
