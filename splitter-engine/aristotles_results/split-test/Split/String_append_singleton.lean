import Split.String_toByteArray_push
import Split.congrArg
import Split.String
import Split.String_toByteArray
import Split.String_push
import Split.String_toByteArray_singleton
import Split.List_cons
import Split.instAppendString
import Split.instHAppendOfAppend
import Split.congr
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.String_toByteArray_append
import Split.ByteArray_instAppend
import Split.Char
import Split.ByteArray
import Split.List_utf8Encode
import Split.String_singleton
import Split.Eq
import Split.HAppend_hAppend
import Split.Eq_trans
import Split.List_nil

-- String.append_singleton from environment
-- theorem String.append_singleton : forall {s : String} {c : Char}, Eq.{1} String (HAppend.hAppend.{0, 0, 0} String String String (instHAppendOfAppend.{0} String instAppendString) s (String.singleton c)) (String.push s c)

-- Stub: this file represents the declaration `String.append_singleton`.
-- In a full split, the body would be extracted from the environment.
