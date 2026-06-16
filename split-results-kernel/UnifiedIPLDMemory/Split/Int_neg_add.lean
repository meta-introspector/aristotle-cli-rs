import Split.Eq_mpr
import Split.Int_add_left_cancel
import Split.congrArg
import Split.Int_add_assoc
import Split.id
import Split.Int_instNegInt
import Split.Int
import Split.Int_add_comm
import Split.Int_add_right_neg
import Split.instHAdd
import Split.instOfNat
import Split.HAdd_hAdd
import Split.Int_instAdd
import Split.Eq_refl
import Split.Int_add_zero
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq
import Split.Neg_neg

-- Int.neg_add from environment
-- theorem Int.neg_add : forall {a : Int} {b : Int}, Eq.{1} Int (Neg.neg.{0} Int Int.instNegInt (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) a b)) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) (Neg.neg.{0} Int Int.instNegInt a) (Neg.neg.{0} Int Int.instNegInt b))

-- Stub: this file represents the declaration `Int.neg_add`.
-- In a full split, the body would be extracted from the environment.
