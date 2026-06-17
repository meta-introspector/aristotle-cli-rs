import Split.HMul_hMul
import Split.congrArg
import Split.HSub_hSub
import Split.Int_instNegInt
import Split.Int
import Split.Int_mul_neg
import Split.Int_instMul
import Split.instHAdd
import Split.instHSub
import Split.HAdd_hAdd
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.Int_instAdd
import Split.Int_instSub
import Split.congrFun'
import Split.Int_mul_add
import Split.Eq
import Split.Neg_neg
import Split.Eq_trans
import Split.instHMul

-- Int.mul_sub from environment
-- theorem Int.mul_sub : forall (a : Int) (b : Int) (c : Int), Eq.{1} Int (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) a (HSub.hSub.{0, 0, 0} Int Int Int (instHSub.{0} Int Int.instSub) b c)) (HSub.hSub.{0, 0, 0} Int Int Int (instHSub.{0} Int Int.instSub) (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) a b) (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) a c))

-- Stub: this file represents the declaration `Int.mul_sub`.
-- In a full split, the body would be extracted from the environment.
