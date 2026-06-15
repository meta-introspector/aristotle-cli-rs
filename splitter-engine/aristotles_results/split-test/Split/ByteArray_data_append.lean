import Split.Array_instAppend
import Split.congrArg
import Split.Array_toList_append
import Split.Array_toList
import Split.Array
import Split.instHAppendOfAppend
import Split.List
import Split.ByteArray_data
import Split.congr
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.ByteArray_instAppend
import Split.ByteArray
import Split.List_instAppend
import Split.UInt8
import Split.Eq
import Split.HAppend_hAppend
import Split.Eq_trans
import Split.ByteArray_toList_data_append

-- ByteArray.data_append from environment
-- theorem ByteArray.data_append : forall {l : ByteArray} {l' : ByteArray}, Eq.{1} (Array.{0} UInt8) (ByteArray.data (HAppend.hAppend.{0, 0, 0} ByteArray ByteArray ByteArray (instHAppendOfAppend.{0} ByteArray ByteArray.instAppend) l l')) (HAppend.hAppend.{0, 0, 0} (Array.{0} UInt8) (Array.{0} UInt8) (Array.{0} UInt8) (instHAppendOfAppend.{0} (Array.{0} UInt8) (Array.instAppend.{0} UInt8)) (ByteArray.data l) (ByteArray.data l'))

-- Stub: this file represents the declaration `ByteArray.data_append`.
-- In a full split, the body would be extracted from the environment.
