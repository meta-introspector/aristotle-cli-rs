import Split.HSub_hSub
import Split.Int_neg_add_cancel_right
import Split.Int
import Split.instHAdd
import Split.instHSub
import Split.HAdd_hAdd
import Split.Int_instAdd
import Split.Int_instSub
import Split.Eq

-- Int.sub_add_cancel from environment
-- theorem Int.sub_add_cancel : forall (a : Int) (b : Int), Eq.{1} Int (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) (HSub.hSub.{0, 0, 0} Int Int Int (instHSub.{0} Int Int.instSub) a b) b) a

-- Stub: this file represents the declaration `Int.sub_add_cancel`.
-- In a full split, the body would be extracted from the environment.
