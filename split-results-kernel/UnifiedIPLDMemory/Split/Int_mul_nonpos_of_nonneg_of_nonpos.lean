import Split.HMul_hMul
import Split.congrArg
import Split.Eq_mp
import Split.Int
import Split.LE_le
import Split.Int_instMul
import Split.instOfNat
import Split.Int_mul_zero
import Split.Int_mul_le_mul_of_nonneg_left
import Split.OfNat_ofNat
import Split.Int_instLEInt
import Split.instHMul

-- Int.mul_nonpos_of_nonneg_of_nonpos from environment
-- theorem Int.mul_nonpos_of_nonneg_of_nonpos : forall {a : Int} {b : Int}, (LE.le.{0} Int Int.instLEInt (OfNat.ofNat.{0} Int 0 (instOfNat 0)) a) -> (LE.le.{0} Int Int.instLEInt b (OfNat.ofNat.{0} Int 0 (instOfNat 0))) -> (LE.le.{0} Int Int.instLEInt (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) a b) (OfNat.ofNat.{0} Int 0 (instOfNat 0)))

-- Stub: this file represents the declaration `Int.mul_nonpos_of_nonneg_of_nonpos`.
-- In a full split, the body would be extracted from the environment.
