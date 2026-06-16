import Split.congrArg
import Split.Int_add_neg_cancel_right
import Split.Eq_mp
import Split.instHMod
import Split.Int_instNegInt
import Split.Int
import Split.Int_add_emod_eq_add_emod_right
import Split.instHAdd
import Split.HMod_hMod
import Split.Iff
import Split.HAdd_hAdd
import Split.Iff_intro
import Split.Int_instAdd
import Split.Int_instMod
import Split.Eq
import Split.Neg_neg

-- Int.emod_add_cancel_right from environment
-- theorem Int.emod_add_cancel_right : forall {m : Int} {n : Int} {k : Int} (i : Int), Iff (Eq.{1} Int (HMod.hMod.{0, 0, 0} Int Int Int (instHMod.{0} Int Int.instMod) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) m i) n) (HMod.hMod.{0, 0, 0} Int Int Int (instHMod.{0} Int Int.instMod) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) k i) n)) (Eq.{1} Int (HMod.hMod.{0, 0, 0} Int Int Int (instHMod.{0} Int Int.instMod) m n) (HMod.hMod.{0, 0, 0} Int Int Int (instHMod.{0} Int Int.instMod) k n))

-- Stub: this file represents the declaration `Int.emod_add_cancel_right`.
-- In a full split, the body would be extracted from the environment.
