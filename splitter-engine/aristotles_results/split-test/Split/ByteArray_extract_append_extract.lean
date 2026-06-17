import Split.Array_instAppend
import Split.congrArg
import Split.ByteArray_extract
import Split.Array_extract
import Split.Array
import Split.instHAppendOfAppend
import Split.Max_max
import Split.ByteArray_data_append
import Split.Nat
import Split.ByteArray_data
import Split.congr
import Split.True
import Split.eq_self
import Split.ByteArray_data_extract
import Split.of_eq_true
import Split.Array_extract_append_extract
import Split.ByteArray_instAppend
import Split.Nat_instMax
import Split.ByteArray
import Split.UInt8
import Split.Eq
import Split.HAppend_hAppend
import Split.Min_min
import Split.instMinNat
import Split.ByteArray_ext
import Split.Eq_trans

-- ByteArray.extract_append_extract from environment
-- theorem ByteArray.extract_append_extract : forall {a : ByteArray} {i : Nat} {j : Nat} {k : Nat}, Eq.{1} ByteArray (HAppend.hAppend.{0, 0, 0} ByteArray ByteArray ByteArray (instHAppendOfAppend.{0} ByteArray ByteArray.instAppend) (ByteArray.extract a i j) (ByteArray.extract a j k)) (ByteArray.extract a (Min.min.{0} Nat instMinNat i j) (Max.max.{0} Nat Nat.instMax j k))

-- Stub: this file represents the declaration `ByteArray.extract_append_extract`.
-- In a full split, the body would be extracted from the environment.
