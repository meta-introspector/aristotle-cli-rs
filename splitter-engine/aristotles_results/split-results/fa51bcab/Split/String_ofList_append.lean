import Split.String_toByteArray_ofList
import Split.congrArg
import Split.String
import Split.String_toByteArray
import Split.instAppendString
import Split.instHAppendOfAppend
import Split.List
import Split.congr
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.String_toByteArray_append
import Split.ByteArray_instAppend
import Split.Char
import Split.ByteArray
import Split.List_instAppend
import Split.List_utf8Encode
import Split.Eq
import Split.List_utf8Encode_append
import Split.HAppend_hAppend
import Split.String_ofList
import Split.Eq_trans

-- String.ofList_append from environment
-- theorem String.ofList_append : forall {l₁ : List.{0} Char} {l₂ : List.{0} Char}, Eq.{1} String (String.ofList (HAppend.hAppend.{0, 0, 0} (List.{0} Char) (List.{0} Char) (List.{0} Char) (instHAppendOfAppend.{0} (List.{0} Char) (List.instAppend.{0} Char)) l₁ l₂)) (HAppend.hAppend.{0, 0, 0} String String String (instHAppendOfAppend.{0} String instAppendString) (String.ofList l₁) (String.ofList l₂))

-- Stub: this file represents the declaration `String.ofList_append`.
-- In a full split, the body would be extracted from the environment.
