import Split.Int_tmod
import Split.Eq_mpr
import Split.HMul_hMul
import Split.congrArg
import Split.HSub_hSub
import Split.Int_tmod_add_mul_tdiv
import Split.id
import Split.Int_add_sub_cancel
import Split.Int
import Split.Int_instMul
import Split.Int_tdiv
import Split.instHAdd
import Split.instHSub
import Split.HAdd_hAdd
import Split.Int_instAdd
import Split.Eq_refl
import Split.Int_instSub
import Split.Eq_symm
import Split.Eq
import Split.instHMul

-- Int.tmod_def from environment
-- theorem Int.tmod_def : forall (a : Int) (b : Int), Eq.{1} Int (Int.tmod a b) (HSub.hSub.{0, 0, 0} Int Int Int (instHSub.{0} Int Int.instSub) a (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) b (Int.tdiv a b)))

-- Stub: this file represents the declaration `Int.tmod_def`.
-- In a full split, the body would be extracted from the environment.
