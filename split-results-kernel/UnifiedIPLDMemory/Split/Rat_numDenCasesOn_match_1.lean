import Split.Nat_Coprime
import Split.Rat
import Split.Rat_divInt
import Split.Ne
import Split.instOfNatNat
import Split.Int
import Split.Nat_cast
import Split.Rat_casesOn
import Split.Nat
import Split.LT_lt
import Split.Int_natAbs
import Split.instNatCastInt
import Split.instLTNat
import Split.Rat_mk'
import Split.OfNat_ofNat

-- Rat.numDenCasesOn.match_1 from environment
-- def Rat.numDenCasesOn.match_1 : forall {C : Rat -> Sort.{u_2}} (motive : Rat -> (forall (n : [mdata borrowed:1 Int]) (d : Nat), (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) d) -> (Nat.Coprime (Int.natAbs n) d) -> (C (Rat.divInt n (Nat.cast.{0} Int instNatCastInt d)))) -> Sort.{u_1}) (x._@.Init.Data.Rat.Lemmas.380424763._hygCtx.36.Init.Data.Rat.Lemmas.380424763._hygCtx._hyg.55 : Rat) (x._@.Init.Data.Rat.Lemmas.380424763._hygCtx.37.Init.Data.Rat.Lemmas.380424763._hygCtx._hyg.58 : forall (n : [mdata borrowed:1 Int]) (d : Nat), (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) d) -> (Nat.Coprime (Int.natAbs n) d) -> (C (Rat.divInt n (Nat.cast.{0} Int instNatCastInt d)))), (forall (n : Int) (d : Nat) (h : Ne.{1} Nat d (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (c : Nat.Coprime (Int.natAbs n) d) (H : forall (n : [mdata borrowed:1 Int]) (d : Nat), (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) d) -> (Nat.Coprime (Int.natAbs n) d) -> (C (Rat.divInt n (Nat.cast.{0} Int instNatCastInt d)))), motive (Rat.mk' n d h c) H) -> (motive x._@.Init.Data.Rat.Lemmas.380424763._hygCtx.36.Init.Data.Rat.Lemmas.380424763._hygCtx._hyg.55 x._@.Init.Data.Rat.Lemmas.380424763._hygCtx.37.Init.Data.Rat.Lemmas.380424763._hygCtx._hyg.58)
-- (definition body omitted)

-- Stub: this file represents the declaration `Rat.numDenCasesOn.match_1`.
-- In a full split, the body would be extracted from the environment.
