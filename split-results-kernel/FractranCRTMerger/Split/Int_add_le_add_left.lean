import Split.Eq_mpr
import Split.congrArg
import Split.Int_add_assoc
import Split.Int_le_intro
import Split.Exists
import Split.id
import Split.Int_le_dest
import Split.Int
import Split.LE_le
import Split.Nat_cast
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.Int_instAdd
import Split.Eq_refl
import Split.instNatCastInt
import Split.Eq
import Split.Int_instLEInt

-- Int.add_le_add_left from environment
-- theorem Int.add_le_add_left : forall {a : Int} {b : Int}, (LE.le.{0} Int Int.instLEInt a b) -> (forall (c : Int), LE.le.{0} Int Int.instLEInt (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) c a) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) c b))

-- Stub: this file represents the declaration `Int.add_le_add_left`.
-- In a full split, the body would be extracted from the environment.
