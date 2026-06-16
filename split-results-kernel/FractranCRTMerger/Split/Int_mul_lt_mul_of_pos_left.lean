import Split.Int_mul_pos
import Split.HMul_hMul
import Split.congrArg
import Split.Int_lt_of_sub_pos
import Split.HSub_hSub
import Split.Int_mul_sub
import Split.Eq_mp
import Split.Int
import Split.Int_instMul
import Split.Int_instLTInt
import Split.instHSub
import Split.instOfNat
import Split.LT_lt
import Split.Int_instSub
import Split.OfNat_ofNat
import Split.Int_sub_pos_of_lt
import Split.instHMul

-- Int.mul_lt_mul_of_pos_left from environment
-- theorem Int.mul_lt_mul_of_pos_left : forall {a : Int} {b : Int} {c : Int}, (LT.lt.{0} Int Int.instLTInt a b) -> (LT.lt.{0} Int Int.instLTInt (OfNat.ofNat.{0} Int 0 (instOfNat 0)) c) -> (LT.lt.{0} Int Int.instLTInt (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) c a) (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) c b))

-- Stub: this file represents the declaration `Int.mul_lt_mul_of_pos_left`.
-- In a full split, the body would be extracted from the environment.
