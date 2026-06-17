import Split.ByteArray_mk
import Split.ByteArray_append
import Split.Array_toList
import Split.instHAppendOfAppend
import Split.List
import Split.ByteArray_data
import Split.Eq_refl
import Split.ByteArray
import Split.List_instAppend
import Split.Array_mk
import Split.UInt8
import Split.Eq
import Split.HAppend_hAppend

-- ByteArray.toList_data_append' from environment
-- theorem ByteArray.toList_data_append' : forall {a : ByteArray} {b : ByteArray}, Eq.{1} (List.{0} UInt8) (Array.toList.{0} UInt8 (ByteArray.data (ByteArray.append a b))) (HAppend.hAppend.{0, 0, 0} (List.{0} UInt8) (List.{0} UInt8) (List.{0} UInt8) (instHAppendOfAppend.{0} (List.{0} UInt8) (List.instAppend.{0} UInt8)) (Array.toList.{0} UInt8 (ByteArray.data a)) (Array.toList.{0} UInt8 (ByteArray.data b)))

-- Stub: this file represents the declaration `ByteArray.toList_data_append'`.
-- In a full split, the body would be extracted from the environment.
