import Split.congrArg
import Split.String
import Split.String_ofList_toList
import Split.instAppendString
import Split.instHAppendOfAppend
import Split.List
import Split.String_ofList_append
import Split.String_toList
import Split.congr
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.Char
import Split.List_instAppend
import Split.Eq
import Split.HAppend_hAppend
import Split.String_ofList
import Split.Eq_trans

-- String.toList_append from environment
-- theorem String.toList_append : forall {s : String} {t : String}, Eq.{1} (List.{0} Char) (String.toList (HAppend.hAppend.{0, 0, 0} String String String (instHAppendOfAppend.{0} String instAppendString) s t)) (HAppend.hAppend.{0, 0, 0} (List.{0} Char) (List.{0} Char) (List.{0} Char) (instHAppendOfAppend.{0} (List.{0} Char) (List.instAppend.{0} Char)) (String.toList s) (String.toList t))

-- Stub: this file represents the declaration `String.toList_append`.
-- In a full split, the body would be extracted from the environment.
