import Split.Rat_num
import Split.HMul_hMul
import Split.congrArg
import Split.Rat
import Split.Rat_den
import Split.Eq_mp
import Split.Int
import Split.LE_le
import Split.Rat_instLE
import Split.Nat_cast
import Split.Int_instMul
import Split.Int_instLTInt
import Split.Iff
import Split.Rat_lt_iff
import Split.congr
import Split.LT_lt
import Split.Rat_instLT
import Split.instNatCastInt
import Split.Not
import Split.not_congr
import Split.Int_instLEInt
import Split.instHMul

-- Rat.le_iff from environment
-- theorem Rat.le_iff : forall (a : Rat) (b : Rat), Iff (LE.le.{0} Rat Rat.instLE a b) (LE.le.{0} Int Int.instLEInt (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) (Rat.num a) (Nat.cast.{0} Int instNatCastInt (Rat.den b))) (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) (Rat.num b) (Nat.cast.{0} Int instNatCastInt (Rat.den a))))

-- Stub: this file represents the declaration `Rat.le_iff`.
-- In a full split, the body would be extracted from the environment.
