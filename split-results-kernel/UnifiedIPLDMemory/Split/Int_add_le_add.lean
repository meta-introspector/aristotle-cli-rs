import Split.Int_add_le_add_left
import Split.Int_add_le_add_right
import Split.Int
import Split.LE_le
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Int_le_trans
import Split.Int_instAdd
import Split.Int_instLEInt

-- Int.add_le_add from environment
-- theorem Int.add_le_add : forall {a : Int} {b : Int} {c : Int} {d : Int}, (LE.le.{0} Int Int.instLEInt a b) -> (LE.le.{0} Int Int.instLEInt c d) -> (LE.le.{0} Int Int.instLEInt (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) a c) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) b d))

-- Stub: this file represents the declaration `Int.add_le_add`.
-- In a full split, the body would be extracted from the environment.
