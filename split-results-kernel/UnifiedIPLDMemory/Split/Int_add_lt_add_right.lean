import Split.Eq_rec
import Split.Int
import Split.Int_add_comm
import Split.Int_add_lt_add_left
import Split.Int_instLTInt
import Split.instHAdd
import Split.HAdd_hAdd
import Split.LT_lt
import Split.Int_instAdd
import Split.Eq

-- Int.add_lt_add_right from environment
-- theorem Int.add_lt_add_right : forall {a : Int} {b : Int}, (LT.lt.{0} Int Int.instLTInt a b) -> (forall (c : Int), LT.lt.{0} Int Int.instLTInt (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) a c) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) b c))

-- Stub: this file represents the declaration `Int.add_lt_add_right`.
-- In a full split, the body would be extracted from the environment.
