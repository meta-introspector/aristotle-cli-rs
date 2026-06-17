import Split.Eq_mpr
import Split.HMul_hMul
import Split.congrArg
import Split.id
import Split.Int
import Split.LE_le
import Split.Int_instMul
import Split.instOfNat
import Split.Int_mul_le_mul_of_nonneg_left
import Split.Int_mul_comm
import Split.OfNat_ofNat
import Split.Eq
import Split.Int_instLEInt
import Split.instHMul

-- Int.mul_le_mul_of_nonneg_right from environment
-- theorem Int.mul_le_mul_of_nonneg_right : forall {a : Int} {b : Int} {c : Int}, (LE.le.{0} Int Int.instLEInt a b) -> (LE.le.{0} Int Int.instLEInt (OfNat.ofNat.{0} Int 0 (instOfNat 0)) c) -> (LE.le.{0} Int Int.instLEInt (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) a c) (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) b c))

-- Stub: this file represents the declaration `Int.mul_le_mul_of_nonneg_right`.
-- In a full split, the body would be extracted from the environment.
