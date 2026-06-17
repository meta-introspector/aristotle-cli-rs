import Split.Eq_mpr
import Split.Nat_Coprime
import Split.Rat
import Split.Rat_divInt
import Split.Ne
import Split.instOfNatNat
import Split.Int
import Split.Nat_cast
import Split.Nat
import Split.LT_lt
import Split.Rat_numDenCasesOn
import Split.Int_natAbs
import Split.instNatCastInt
import Split.instLTNat
import Split.Rat_mk'
import Split.OfNat_ofNat

-- Rat.numDenCasesOn'' from environment
-- def Rat.numDenCasesOn'' : forall {C : Rat -> Sort.{u}} (a : Rat), (forall (n : Int) (d : Nat) (nz : Ne.{1} Nat d (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (red : Nat.Coprime (Int.natAbs n) d), C (Rat.mk' n d nz red)) -> (C a)
-- (definition body omitted)

-- Stub: this file represents the declaration `Rat.numDenCasesOn''`.
-- In a full split, the body would be extracted from the environment.
