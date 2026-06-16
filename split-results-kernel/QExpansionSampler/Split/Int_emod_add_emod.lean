import Split.Int_instDiv
import Split.Int_add_right_comm
import Split.instHDiv
import Split.HMul_hMul
import Split.congrArg
import Split.Int_add_mul_emod_self_left
import Split.Eq_mp
import Split.HDiv_hDiv
import Split.instHMod
import Split.Int
import Split.Int_instMul
import Split.instHAdd
import Split.HMod_hMod
import Split.Int_emod_add_mul_ediv
import Split.HAdd_hAdd
import Split.Int_instAdd
import Split.Int_instMod
import Split.Eq_symm
import Split.Eq
import Split.instHMul

-- Int.emod_add_emod from environment
-- theorem Int.emod_add_emod : forall (m : Int) (n : Int) (k : Int), Eq.{1} Int (HMod.hMod.{0, 0, 0} Int Int Int (instHMod.{0} Int Int.instMod) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) (HMod.hMod.{0, 0, 0} Int Int Int (instHMod.{0} Int Int.instMod) m n) k) n) (HMod.hMod.{0, 0, 0} Int Int Int (instHMod.{0} Int Int.instMod) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) m k) n)

-- Stub: this file represents the declaration `Int.emod_add_emod`.
-- In a full split, the body would be extracted from the environment.
