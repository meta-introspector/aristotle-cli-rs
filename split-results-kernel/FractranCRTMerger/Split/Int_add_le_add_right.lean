import Split.Int_add_le_add_left
import Split.Eq_rec
import Split.Int
import Split.LE_le
import Split.Int_add_comm
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Int_instAdd
import Split.Eq
import Split.Int_instLEInt

-- Int.add_le_add_right from environment
-- theorem Int.add_le_add_right : forall {a : Int} {b : Int}, (LE.le.{0} Int Int.instLEInt a b) -> (forall (c : Int), LE.le.{0} Int Int.instLEInt (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) a c) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) b c))

-- Stub: this file represents the declaration `Int.add_le_add_right`.
-- In a full split, the body would be extracted from the environment.
