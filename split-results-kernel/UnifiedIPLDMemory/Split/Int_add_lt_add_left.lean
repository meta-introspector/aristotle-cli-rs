import Split.Iff_mpr
import Split.Int_add_le_add_left
import Split.Int_add_left_cancel
import Split.congrArg
import Split.Eq_mp
import Split.Ne
import Split.Int
import Split.LE_le
import Split.Int_lt_iff_le_and_ne
import Split.Int_instLTInt
import Split.instHAdd
import Split.And
import Split.HAdd_hAdd
import Split.And_intro
import Split.LT_lt
import Split.Int_instAdd
import Split.Int_lt_irrefl
import Split.Eq
import Split.Int_le_of_lt
import Split.Int_instLEInt

-- Int.add_lt_add_left from environment
-- theorem Int.add_lt_add_left : forall {a : Int} {b : Int}, (LT.lt.{0} Int Int.instLTInt a b) -> (forall (c : Int), LT.lt.{0} Int Int.instLTInt (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) c a) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) c b))

-- Stub: this file represents the declaration `Int.add_lt_add_left`.
-- In a full split, the body would be extracted from the environment.
