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

-- Int.sub_eq_add_neg from environment
-- theorem Int.sub_eq_add_neg : forall {a : Int} {b : Int}, Eq.{1} Int (HSub.hSub.{0, 0, 0} Int Int Int (instHSub.{0} Int Int.instSub) a b) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) a (Neg.neg.{0} Int Int.instNegInt b))

-- Stub: this file represents the declaration `Int.sub_eq_add_neg`.
-- In a full split, the body would be extracted from the environment.
