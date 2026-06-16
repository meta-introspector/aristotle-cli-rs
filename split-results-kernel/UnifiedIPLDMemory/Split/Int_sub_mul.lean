import Split.HMul_hMul
import Split.congrArg
import Split.HSub_hSub
import Split.Int_instNegInt
import Split.Int
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
import Split.Int_neg_mul
import Split.Int_add_mul
import Split.Eq
import Split.Neg_neg
import Split.Eq_trans
import Split.instHMul

-- Int.sub_mul from environment
-- theorem Int.sub_mul : forall (a : Int) (b : Int) (c : Int), Eq.{1} Int (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) (HSub.hSub.{0, 0, 0} Int Int Int (instHSub.{0} Int Int.instSub) a b) c) (HSub.hSub.{0, 0, 0} Int Int Int (instHSub.{0} Int Int.instSub) (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) a c) (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) b c))

-- Stub: this file represents the declaration `Int.sub_mul`.
-- In a full split, the body would be extracted from the environment.
