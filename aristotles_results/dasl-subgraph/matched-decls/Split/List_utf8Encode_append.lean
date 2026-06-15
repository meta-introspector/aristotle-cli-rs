import Split.congrArg
import Split.List_toByteArray
import Split.instHAppendOfAppend
import Split.List
import Split.String_utf8EncodeChar
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.congrFun'
import Split.ByteArray_instAppend
import Split.Char
import Split.ByteArray
import Split.List_instAppend
import Split.List_utf8Encode
import Split.UInt8
import Split.Eq
import Split.List_flatMap_append
import Split.HAppend_hAppend
import Split.List_flatMap
import Split.List_toByteArray_append
import Split.Eq_trans

-- List.utf8Encode_append from environment
-- theorem List.utf8Encode_append : forall {l : List.{0} Char} {l' : List.{0} Char}, Eq.{1} ByteArray (List.utf8Encode (HAppend.hAppend.{0, 0, 0} (List.{0} Char) (List.{0} Char) (List.{0} Char) (instHAppendOfAppend.{0} (List.{0} Char) (List.instAppend.{0} Char)) l l')) (HAppend.hAppend.{0, 0, 0} ByteArray ByteArray ByteArray (instHAppendOfAppend.{0} ByteArray ByteArray.instAppend) (List.utf8Encode l) (List.utf8Encode l'))

-- Stub: this file represents the declaration `List.utf8Encode_append`.
-- In a full split, the body would be extracted from the environment.
