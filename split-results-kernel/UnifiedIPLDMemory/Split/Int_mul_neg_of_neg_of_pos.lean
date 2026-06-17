import Split.HMul_hMul
import Split.congrArg
import Split.Int_mul_lt_mul_of_pos_right
import Split.Eq_mp
import Split.Int
import Split.Int_instMul
import Split.Int_instLTInt
import Split.instOfNat
import Split.LT_lt
import Split.OfNat_ofNat
import Split.Int_zero_mul
import Split.instHMul

-- Int.mul_neg_of_neg_of_pos from environment
-- theorem Int.mul_neg_of_neg_of_pos : forall {a : Int} {b : Int}, (LT.lt.{0} Int Int.instLTInt a (OfNat.ofNat.{0} Int 0 (instOfNat 0))) -> (LT.lt.{0} Int Int.instLTInt (OfNat.ofNat.{0} Int 0 (instOfNat 0)) b) -> (LT.lt.{0} Int Int.instLTInt (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) a b) (OfNat.ofNat.{0} Int 0 (instOfNat 0)))

-- Stub: this file represents the declaration `Int.mul_neg_of_neg_of_pos`.
-- In a full split, the body would be extracted from the environment.
