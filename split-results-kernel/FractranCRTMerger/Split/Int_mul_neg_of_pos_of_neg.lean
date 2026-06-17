import Split.HMul_hMul
import Split.congrArg
import Split.Eq_mp
import Split.Int
import Split.Int_instMul
import Split.Int_instLTInt
import Split.instOfNat
import Split.Int_mul_zero
import Split.LT_lt
import Split.Int_mul_lt_mul_of_pos_left
import Split.OfNat_ofNat
import Split.instHMul

-- Int.mul_neg_of_pos_of_neg from environment
-- theorem Int.mul_neg_of_pos_of_neg : forall {a : Int} {b : Int}, (LT.lt.{0} Int Int.instLTInt (OfNat.ofNat.{0} Int 0 (instOfNat 0)) a) -> (LT.lt.{0} Int Int.instLTInt b (OfNat.ofNat.{0} Int 0 (instOfNat 0))) -> (LT.lt.{0} Int Int.instLTInt (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) a b) (OfNat.ofNat.{0} Int 0 (instOfNat 0)))

-- Stub: this file represents the declaration `Int.mul_neg_of_pos_of_neg`.
-- In a full split, the body would be extracted from the environment.
