import Split.congrArg
import Split.List_toByteArray
import Split.instHAppendOfAppend
import Split.List
import Split.List_toByteArray_append'
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
import Split.Eq_trans

-- List.toByteArray_append from environment
-- theorem List.toByteArray_append : forall {l : List.{0} UInt8} {l' : List.{0} UInt8}, Eq.{1} ByteArray (List.toByteArray (HAppend.hAppend.{0, 0, 0} (List.{0} UInt8) (List.{0} UInt8) (List.{0} UInt8) (instHAppendOfAppend.{0} (List.{0} UInt8) (List.instAppend.{0} UInt8)) l l')) (HAppend.hAppend.{0, 0, 0} ByteArray ByteArray ByteArray (instHAppendOfAppend.{0} ByteArray ByteArray.instAppend) (List.toByteArray l) (List.toByteArray l'))

-- Stub: this file represents the declaration `List.toByteArray_append`.
-- In a full split, the body would be extracted from the environment.
