import Split.congrArg
import Split.String
import Split.String_toByteArray
import Split.String_utf8ByteSize
import Split.instAppendString
import Split.instHAppendOfAppend
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.String_toByteArray_append
import Split.instAddNat
import Split.congrFun'
import Split.ByteArray_instAppend
import Split.ByteArray
import Split.ByteArray_size_append
import Split.Eq
import Split.HAppend_hAppend
import Split.ByteArray_size
import Split.Eq_trans

-- String.utf8ByteSize_append from environment
-- theorem String.utf8ByteSize_append : forall {s : String} {t : String}, Eq.{1} Nat (String.utf8ByteSize (HAppend.hAppend.{0, 0, 0} String String String (instHAppendOfAppend.{0} String instAppendString) s t)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (String.utf8ByteSize s) (String.utf8ByteSize t))

-- Stub: this file represents the declaration `String.utf8ByteSize_append`.
-- In a full split, the body would be extracted from the environment.
