import Split.Eq_mpr
import Split.congrArg
import Split.Int_add_assoc
import Split.id
import Split.Int
import Split.Int_add_comm
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Int_instAdd
import Split.Eq_refl
import Split.Eq_symm
import Split.Eq

-- Int.add_right_comm from environment
-- theorem Int.add_right_comm : forall (a : Int) (b : Int) (c : Int), Eq.{1} Int (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) a b) c) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) a c) b)

-- Stub: this file represents the declaration `Int.add_right_comm`.
-- In a full split, the body would be extracted from the environment.
