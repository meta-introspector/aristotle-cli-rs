import Split.congrArg
import Split.Option_some
import Split.Option_get_congr_simp
import Split.List_utf8Decode?_utf8Encode
import Split.ByteArray_isSome_utf8Decode?_iff
import Split.ByteArray_IsValidUTF8_casesOn
import Split.Array_toList
import Split.List_toArray
import Split.Array
import Split.Bool_true
import Split.List
import Split.Option_get
import Split.True
import Split.eq_self
import Split.Iff_mp
import Split.Bool
import Split.of_eq_true
import Split.Eq_ndrec
import Split.congrFun'
import Split.Char
import Split.ByteArray
import Split.Option_isSome
import Split.List_utf8Encode
import Split.Eq_symm
import Split.ByteArray_utf8Decode?
import Split.Eq
import Split.Eq_trans
import Split.ByteArray_IsValidUTF8

-- ByteArray.utf8Encode_get_utf8Decode? from environment
-- theorem ByteArray.utf8Encode_get_utf8Decode? : forall {b : ByteArray} {h : Eq.{1} Bool (Option.isSome.{0} (Array.{0} Char) (ByteArray.utf8Decode? b)) Bool.true}, Eq.{1} ByteArray (List.utf8Encode (Array.toList.{0} Char (Option.get.{0} (Array.{0} Char) (ByteArray.utf8Decode? b) h))) b

-- Stub: this file represents the declaration `ByteArray.utf8Encode_get_utf8Decode?`.
-- In a full split, the body would be extracted from the environment.
