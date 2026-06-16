import Split.HMul_hMul
import Split.congrArg
import Split.Eq_mp
import Split.Int
import Split.LE_le
import Split.Int_instMul
import Split.instOfNat
import Split.OfNat_ofNat
import Split.Int_instLEInt
import Split.Int_mul_le_mul_of_nonneg_right
import Split.Int_zero_mul
import Split.instHMul

-- Int.mul_nonpos_of_nonpos_of_nonneg from environment
-- theorem Int.mul_nonpos_of_nonpos_of_nonneg : forall {a : Int} {b : Int}, (LE.le.{0} Int Int.instLEInt a (OfNat.ofNat.{0} Int 0 (instOfNat 0))) -> (LE.le.{0} Int Int.instLEInt (OfNat.ofNat.{0} Int 0 (instOfNat 0)) b) -> (LE.le.{0} Int Int.instLEInt (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) a b) (OfNat.ofNat.{0} Int 0 (instOfNat 0)))

-- Stub: this file represents the declaration `Int.mul_nonpos_of_nonpos_of_nonneg`.
-- In a full split, the body would be extracted from the environment.
