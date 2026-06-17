import Split.List_utf8Encode_nil
import Split.Array_instAppend
import Split.Eq_mpr
import Split.congrArg
import Split.Option_some
import Split.Exists
import Split.id
import Split.ByteArray_empty
import Split.List_rec
import Split.Array_toList
import Split.List_toArray
import Split.List_cons
import Split.List_cons_injEq
import Split.Array
import Split.funext
import Split.instHAppendOfAppend
import Split.List
import Split.Option_map
import Split.And
import Split.List_singleton_append
import Split.And_intro
import Split.True
import Split.eq_self
import Split.Exists_intro
import Split.of_eq_true
import Split.congrFun'
import Split.ByteArray_instAppend
import Split.Char
import Split.ByteArray
import Split.List_instAppend
import Split.ByteArray_utf8Decode?_utf8Encode_singleton_append
import Split.List_utf8Encode
import Split.Eq_symm
import Split.ByteArray_utf8Decode?
import Split.Eq
import Split.List_utf8Encode_append
import Split.HAppend_hAppend
import Split.true_and
import Split.Eq_trans
import Split.ByteArray_utf8Decode?_empty
import Split.List_nil
import Split.Option

-- List.utf8Decode?_utf8Encode from environment
-- theorem List.utf8Decode?_utf8Encode : forall {l : List.{0} Char}, Eq.{1} (Option.{0} (Array.{0} Char)) (ByteArray.utf8Decode? (List.utf8Encode l)) (Option.some.{0} (Array.{0} Char) (List.toArray.{0} Char l))

-- Stub: this file represents the declaration `List.utf8Decode?_utf8Encode`.
-- In a full split, the body would be extracted from the environment.
