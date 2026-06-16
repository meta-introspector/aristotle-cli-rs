import Split.HSub_hSub
import Split.instHMod
import Split.Int_instNegInt
import Split.Int
import Split.HMod_hMod
import Split.Iff
import Split.instHSub
import Split.Int_emod_add_cancel_right
import Split.Int_instMod
import Split.Int_instSub
import Split.Eq
import Split.Neg_neg

-- Int.emod_sub_cancel_right from environment
-- theorem Int.emod_sub_cancel_right : forall {m : Int} {n : Int} {k : Int} (i : Int), Iff (Eq.{1} Int (HMod.hMod.{0, 0, 0} Int Int Int (instHMod.{0} Int Int.instMod) (HSub.hSub.{0, 0, 0} Int Int Int (instHSub.{0} Int Int.instSub) m i) n) (HMod.hMod.{0, 0, 0} Int Int Int (instHMod.{0} Int Int.instMod) (HSub.hSub.{0, 0, 0} Int Int Int (instHSub.{0} Int Int.instSub) k i) n)) (Eq.{1} Int (HMod.hMod.{0, 0, 0} Int Int Int (instHMod.{0} Int Int.instMod) m n) (HMod.hMod.{0, 0, 0} Int Int Int (instHMod.{0} Int Int.instMod) k n))

-- Stub: this file represents the declaration `Int.emod_sub_cancel_right`.
-- In a full split, the body would be extracted from the environment.
