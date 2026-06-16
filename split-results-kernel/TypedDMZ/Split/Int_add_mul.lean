import Split.HMul_hMul
import Split.congrArg
import Split.Int
import Split.Int_instMul
import Split.instHAdd
import Split.HAdd_hAdd
import Split.congr
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.Int_instAdd
import Split.congrFun'
import Split.Int_mul_comm
import Split.Int_mul_add
import Split.Eq
import Split.Eq_trans
import Split.instHMul

-- Int.add_mul from environment
-- theorem Int.add_mul : forall (a : Int) (b : Int) (c : Int), Eq.{1} Int (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) a b) c) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) a c) (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) b c))

-- Stub: this file represents the declaration `Int.add_mul`.
-- In a full split, the body would be extracted from the environment.
