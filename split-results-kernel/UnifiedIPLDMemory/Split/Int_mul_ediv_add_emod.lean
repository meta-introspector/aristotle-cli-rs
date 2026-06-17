import Split.Eq_mpr
import Split.Int_instDiv
import Split.instHDiv
import Split.HMul_hMul
import Split.congrArg
import Split.id
import Split.HDiv_hDiv
import Split.instHMod
import Split.Int
import Split.Int_add_comm
import Split.Int_instMul
import Split.instHAdd
import Split.HMod_hMod
import Split.Int_emod_add_mul_ediv
import Split.HAdd_hAdd
import Split.Int_instAdd
import Split.Int_instMod
import Split.Eq
import Split.instHMul

-- Int.mul_ediv_add_emod from environment
-- theorem Int.mul_ediv_add_emod : forall (a : Int) (b : Int), Eq.{1} Int (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) b (HDiv.hDiv.{0, 0, 0} Int Int Int (instHDiv.{0} Int Int.instDiv) a b)) (HMod.hMod.{0, 0, 0} Int Int Int (instHMod.{0} Int Int.instMod) a b)) a

-- Stub: this file represents the declaration `Int.mul_ediv_add_emod`.
-- In a full split, the body would be extracted from the environment.
