import Split.String
import Split.String_toByteArray
import Split.instAppendString
import Split.instHAppendOfAppend
import Split.ByteArray_instAppend
import Split.ByteArray
import Split.Eq
import Split.HAppend_hAppend
import Split.rfl

-- String.toByteArray_append from environment
-- theorem String.toByteArray_append : forall {s : String} {t : String}, Eq.{1} ByteArray (String.toByteArray (HAppend.hAppend.{0, 0, 0} String String String (instHAppendOfAppend.{0} String instAppendString) s t)) (HAppend.hAppend.{0, 0, 0} ByteArray ByteArray ByteArray (instHAppendOfAppend.{0} ByteArray ByteArray.instAppend) (String.toByteArray s) (String.toByteArray t))

-- Stub: this file represents the declaration `String.toByteArray_append`.
-- In a full split, the body would be extracted from the environment.
