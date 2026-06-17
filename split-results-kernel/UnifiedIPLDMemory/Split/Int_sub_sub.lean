import Split.congrArg
import Split.Int_add_assoc
import Split.HSub_hSub
import Split.Int_instNegInt
import Split.Int
import Split.instHAdd
import Split.instHSub
import Split.HAdd_hAdd
import Split.Int_neg_add
import Split.congr
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.Int_instAdd
import Split.Int_instSub
import Split.Eq
import Split.Neg_neg
import Split.Eq_trans

-- Int.sub_sub from environment
-- theorem Int.sub_sub : forall (a : Int) (b : Int) (c : Int), Eq.{1} Int (HSub.hSub.{0, 0, 0} Int Int Int (instHSub.{0} Int Int.instSub) (HSub.hSub.{0, 0, 0} Int Int Int (instHSub.{0} Int Int.instSub) a b) c) (HSub.hSub.{0, 0, 0} Int Int Int (instHSub.{0} Int Int.instSub) a (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) b c))

-- Stub: this file represents the declaration `Int.sub_sub`.
-- In a full split, the body would be extracted from the environment.
