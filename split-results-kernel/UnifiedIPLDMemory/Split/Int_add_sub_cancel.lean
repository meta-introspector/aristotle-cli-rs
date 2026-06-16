import Split.HSub_hSub
import Split.Int_add_neg_cancel_right
import Split.Int
import Split.instHAdd
import Split.instHSub
import Split.HAdd_hAdd
import Split.Int_instAdd
import Split.Int_instSub
import Split.Eq

-- Int.add_sub_cancel from environment
-- theorem Int.add_sub_cancel : forall (a : Int) (b : Int), Eq.{1} Int (HSub.hSub.{0, 0, 0} Int Int Int (instHSub.{0} Int Int.instSub) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) a b) b) a

-- Stub: this file represents the declaration `Int.add_sub_cancel`.
-- In a full split, the body would be extracted from the environment.
