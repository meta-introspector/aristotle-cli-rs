import Split.congrArg
import Split.ByteArray_IsValidUTF8_casesOn
import Split.instHAppendOfAppend
import Split.List
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.Eq_ndrec
import Split.ByteArray_IsValidUTF8_intro
import Split.ByteArray_instAppend
import Split.Char
import Split.ByteArray
import Split.List_instAppend
import Split.List_utf8Encode
import Split.Eq_symm
import Split.Eq
import Split.List_utf8Encode_append
import Split.HAppend_hAppend
import Split.Eq_trans
import Split.ByteArray_IsValidUTF8

-- ByteArray.IsValidUTF8.append from environment
-- theorem ByteArray.IsValidUTF8.append : forall {b : ByteArray} {b' : ByteArray}, (ByteArray.IsValidUTF8 b) -> (ByteArray.IsValidUTF8 b') -> (ByteArray.IsValidUTF8 (HAppend.hAppend.{0, 0, 0} ByteArray ByteArray ByteArray (instHAppendOfAppend.{0} ByteArray ByteArray.instAppend) b b'))

-- Stub: this file represents the declaration `ByteArray.IsValidUTF8.append`.
-- In a full split, the body would be extracted from the environment.
