import Split.List_size_toByteArray
import Split.String_toByteArray_push
import Split.congrArg
import Split.String
import Split.String_toByteArray
import Split.String_utf8ByteSize
import Split.String_push
import Split.List_toByteArray
import Split.List_cons
import Split.instHAppendOfAppend
import Split.instHAdd
import Split.String_utf8EncodeChar
import Split.HAdd_hAdd
import Split.String_length_utf8EncodeChar
import Split.Nat
import Split.True
import Split.eq_self
import Split.List_utf8Encode_singleton
import Split.of_eq_true
import Split.instAddNat
import Split.congrFun'
import Split.ByteArray_instAppend
import Split.Char
import Split.ByteArray
import Split.List_utf8Encode
import Split.UInt8
import Split.ByteArray_size_append
import Split.Eq
import Split.List_length
import Split.HAppend_hAppend
import Split.Char_utf8Size
import Split.ByteArray_size
import Split.Eq_trans
import Split.List_nil

-- String.utf8ByteSize_push from environment
-- theorem String.utf8ByteSize_push : forall {s : String} {c : Char}, Eq.{1} Nat (String.utf8ByteSize (String.push s c)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (String.utf8ByteSize s) (Char.utf8Size c))

-- Stub: this file represents the declaration `String.utf8ByteSize_push`.
-- In a full split, the body would be extracted from the environment.
