import Split.congrArg
import Split.ByteArray_append
import Split.List_toByteArray
import Split.Array_toList
import Split.instHAppendOfAppend
import Split.List
import Split.ByteArray_data
import Split.congr
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.ByteArray
import Split.List_instAppend
import Split.UInt8
import Split.Eq
import Split.HAppend_hAppend
import Split.ByteArray_toList_data_append'
import Split.ByteArray_ext
import Split.Eq_trans
import Split.List_toList_data_toByteArray

-- List.toByteArray_append' from environment
-- theorem List.toByteArray_append' : forall {l : List.{0} UInt8} {l' : List.{0} UInt8}, Eq.{1} ByteArray (List.toByteArray (HAppend.hAppend.{0, 0, 0} (List.{0} UInt8) (List.{0} UInt8) (List.{0} UInt8) (instHAppendOfAppend.{0} (List.{0} UInt8) (List.instAppend.{0} UInt8)) l l')) (ByteArray.append (List.toByteArray l) (List.toByteArray l'))

-- Stub: this file represents the declaration `List.toByteArray_append'`.
-- In a full split, the body would be extracted from the environment.
