import Split.String
import Split.String_toByteArray
import Split.String_push
import Split.List_cons
import Split.instHAppendOfAppend
import Split.eq_self
import Split.of_eq_true
import Split.ByteArray_instAppend
import Split.Char
import Split.ByteArray
import Split.List_utf8Encode
import Split.Eq
import Split.HAppend_hAppend
import Split.List_nil

-- String.toByteArray_push from environment
-- theorem String.toByteArray_push : forall {s : String} {c : Char}, Eq.{1} ByteArray (String.toByteArray (String.push s c)) (HAppend.hAppend.{0, 0, 0} ByteArray ByteArray ByteArray (instHAppendOfAppend.{0} ByteArray ByteArray.instAppend) (String.toByteArray s) (List.utf8Encode (List.cons.{0} Char c (List.nil.{0} Char))))

-- Stub: this file represents the declaration `String.toByteArray_push`.
-- In a full split, the body would be extracted from the environment.
