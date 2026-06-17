import Split.Array_instAppend
import Split.Array_append_assoc
import Split.congrArg
import Split.Array
import Split.instHAppendOfAppend
import Split.ByteArray_data_append
import Split.ByteArray_data
import Split.congr
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.congrFun'
import Split.ByteArray_instAppend
import Split.ByteArray
import Split.UInt8
import Split.Eq
import Split.HAppend_hAppend
import Split.ByteArray_ext
import Split.Eq_trans

-- ByteArray.append_assoc from environment
-- theorem ByteArray.append_assoc : forall {a : ByteArray} {b : ByteArray} {c : ByteArray}, Eq.{1} ByteArray (HAppend.hAppend.{0, 0, 0} ByteArray ByteArray ByteArray (instHAppendOfAppend.{0} ByteArray ByteArray.instAppend) (HAppend.hAppend.{0, 0, 0} ByteArray ByteArray ByteArray (instHAppendOfAppend.{0} ByteArray ByteArray.instAppend) a b) c) (HAppend.hAppend.{0, 0, 0} ByteArray ByteArray ByteArray (instHAppendOfAppend.{0} ByteArray ByteArray.instAppend) a (HAppend.hAppend.{0, 0, 0} ByteArray ByteArray ByteArray (instHAppendOfAppend.{0} ByteArray ByteArray.instAppend) b c))

-- Stub: this file represents the declaration `ByteArray.append_assoc`.
-- In a full split, the body would be extracted from the environment.
