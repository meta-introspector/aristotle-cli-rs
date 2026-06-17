import Split.HSub_hSub
import Split.Int_instNegInt
import Split.Int
import Split.instHAdd
import Split.instHSub
import Split.HAdd_hAdd
import Split.Int_instAdd
import Split.Int_instSub
import Split.Eq
import Split.Neg_neg
import Split.rfl

-- Int.add_neg_eq_sub from environment
-- theorem Int.add_neg_eq_sub : forall {a : Int} {b : Int}, Eq.{1} Int (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) a (Neg.neg.{0} Int Int.instNegInt b)) (HSub.hSub.{0, 0, 0} Int Int Int (instHSub.{0} Int Int.instSub) a b)

-- Stub: this file represents the declaration `Int.add_neg_eq_sub`.
-- In a full split, the body would be extracted from the environment.
