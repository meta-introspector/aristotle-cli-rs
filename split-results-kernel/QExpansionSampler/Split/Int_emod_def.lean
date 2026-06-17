import Split.Eq_mpr
import Split.Int_instDiv
import Split.instHDiv
import Split.HMul_hMul
import Split.congrArg
import Split.HSub_hSub
import Split.id
import Split.HDiv_hDiv
import Split.instHMod
import Split.Int_add_sub_cancel
import Split.Int
import Split.Int_instMul
import Split.instHAdd
import Split.HMod_hMod
import Split.Int_emod_add_mul_ediv
import Split.instHSub
import Split.HAdd_hAdd
import Split.Int_instAdd
import Split.Int_instMod
import Split.Eq_refl
import Split.Int_instSub
import Split.Eq_symm
import Split.Eq
import Split.instHMul

-- Int.emod_def from environment
-- theorem Int.emod_def : forall (a : Int) (b : Int), Eq.{1} Int (HMod.hMod.{0, 0, 0} Int Int Int (instHMod.{0} Int Int.instMod) a b) (HSub.hSub.{0, 0, 0} Int Int Int (instHSub.{0} Int Int.instSub) a (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) b (HDiv.hDiv.{0, 0, 0} Int Int Int (instHDiv.{0} Int Int.instDiv) a b)))

-- Stub: this file represents the declaration `Int.emod_def`.
-- In a full split, the body would be extracted from the environment.
