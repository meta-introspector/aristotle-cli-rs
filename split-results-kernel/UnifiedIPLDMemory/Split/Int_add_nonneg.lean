import Split.Eq_rec
import Split.Int
import Split.LE_le
import Split.Int_add_le_add
import Split.instHAdd
import Split.instOfNat
import Split.HAdd_hAdd
import Split.Int_instAdd
import Split.OfNat_ofNat
import Split.Int_zero_add
import Split.Eq
import Split.Int_instLEInt

-- Int.add_nonneg from environment
-- theorem Int.add_nonneg : forall {a : Int} {b : Int}, (LE.le.{0} Int Int.instLEInt (OfNat.ofNat.{0} Int 0 (instOfNat 0)) a) -> (LE.le.{0} Int Int.instLEInt (OfNat.ofNat.{0} Int 0 (instOfNat 0)) b) -> (LE.le.{0} Int Int.instLEInt (OfNat.ofNat.{0} Int 0 (instOfNat 0)) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) a b))

-- Stub: this file represents the declaration `Int.add_nonneg`.
-- In a full split, the body would be extracted from the environment.
