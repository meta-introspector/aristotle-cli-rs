import Split.Eq_mpr
import Split.congrArg
import Split.Int_emod_neg
import Split.id
import Split.instHMod
import Split.Int_instNegInt
import Split.Int
import Split.Nat_cast
import Split.Int_instLTInt
import Split.instHAdd
import Split.HMod_hMod
import Split.instOfNat
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.Decidable_byContradiction
import Split.Int_instAdd
import Split.Int_instMod
import Split.congrFun'
import Split.Int_decLt
import Split.instNatCastInt
import Split.Int_negSucc
import Split.Int_emod_lt_of_pos
import Split.OfNat_ofNat
import Split.Eq
import Split.Not
import Split.Neg_neg

-- Int.emod_lt_of_neg from environment
-- theorem Int.emod_lt_of_neg : forall (a : Int) {b : Int}, (LT.lt.{0} Int Int.instLTInt b (OfNat.ofNat.{0} Int 0 (instOfNat 0))) -> (LT.lt.{0} Int Int.instLTInt (HMod.hMod.{0, 0, 0} Int Int Int (instHMod.{0} Int Int.instMod) a b) (Neg.neg.{0} Int Int.instNegInt b))

-- Stub: this file represents the declaration `Int.emod_lt_of_neg`.
-- In a full split, the body would be extracted from the environment.
