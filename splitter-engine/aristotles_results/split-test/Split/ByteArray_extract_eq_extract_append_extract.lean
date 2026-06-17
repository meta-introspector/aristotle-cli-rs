import Split.Eq_mpr
import Split.congrArg
import Split.ByteArray_extract_append_extract
import Split.ByteArray_extract
import Split.id
import Split.LE_le
import Split.instLENat
import Split.instHAppendOfAppend
import Split.Nat_max_eq_right
import Split.Max_max
import Split.Nat
import Split.Nat_min_eq_left
import Split.Eq_refl
import Split.ByteArray_instAppend
import Split.Nat_instMax
import Split.ByteArray
import Split.Eq
import Split.HAppend_hAppend
import Split.Min_min
import Split.instMinNat

-- ByteArray.extract_eq_extract_append_extract from environment
-- theorem ByteArray.extract_eq_extract_append_extract : forall {a : ByteArray} {i : Nat} {k : Nat} (j : Nat), (LE.le.{0} Nat instLENat i j) -> (LE.le.{0} Nat instLENat j k) -> (Eq.{1} ByteArray (ByteArray.extract a i k) (HAppend.hAppend.{0, 0, 0} ByteArray ByteArray ByteArray (instHAppendOfAppend.{0} ByteArray ByteArray.instAppend) (ByteArray.extract a i j) (ByteArray.extract a j k)))

-- Stub: this file represents the declaration `ByteArray.extract_eq_extract_append_extract`.
-- In a full split, the body would be extracted from the environment.
