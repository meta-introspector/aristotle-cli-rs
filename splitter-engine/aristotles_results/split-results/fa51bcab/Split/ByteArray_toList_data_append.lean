import Split.congrArg
import Split.Array_toList
import Split.instHAppendOfAppend
import Split.List
import Split.ByteArray_data
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.congrFun'
import Split.ByteArray_instAppend
import Split.ByteArray
import Split.List_instAppend
import Split.UInt8
import Split.Eq
import Split.HAppend_hAppend
import Split.ByteArray_toList_data_append'
import Split.Eq_trans

-- ByteArray.toList_data_append from environment
-- theorem ByteArray.toList_data_append : forall {l : ByteArray} {l' : ByteArray}, Eq.{1} (List.{0} UInt8) (Array.toList.{0} UInt8 (ByteArray.data (HAppend.hAppend.{0, 0, 0} ByteArray ByteArray ByteArray (instHAppendOfAppend.{0} ByteArray ByteArray.instAppend) l l'))) (HAppend.hAppend.{0, 0, 0} (List.{0} UInt8) (List.{0} UInt8) (List.{0} UInt8) (instHAppendOfAppend.{0} (List.{0} UInt8) (List.instAppend.{0} UInt8)) (Array.toList.{0} UInt8 (ByteArray.data l)) (Array.toList.{0} UInt8 (ByteArray.data l')))

-- Stub: this file represents the declaration `ByteArray.toList_data_append`.
-- In a full split, the body would be extracted from the environment.
