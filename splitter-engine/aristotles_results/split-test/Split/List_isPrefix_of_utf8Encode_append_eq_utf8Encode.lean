import Split.Array_instAppend
import Split.Eq_mpr
import Split.congrArg
import Split.Option_some
import Split.Exists
import Split.List_toArray_inj
import Split.Eq_rec
import Split.Eq_mp
import Split.id
import Split.List_utf8Decode?_utf8Encode
import Split.List_rec
import Split.Array_toList
import Split.List_toArray
import Split.List_cons
import Split.List_cons_injEq
import Split.Array
import Split.And_casesOn
import Split.Option_some_get
import Split.Bool_true
import Split.ByteArray_utf8Encode_get_utf8Decode?
import Split.funext
import Split.instHAppendOfAppend
import Split.List
import Split.Option_map
import Split.And
import Split.List_singleton_append
import Split.Exists_casesOn
import Split.Option_get
import Split.List_IsPrefix
import Split.And_intro
import Split.congr
import Split.True
import Split.eq_self
import Split.Exists_intro
import Split.ByteArray_append_assoc
import Split.Option_isSome_map
import Split.Iff_mp
import Split.Option_isSome_of_eq_some
import Split.Bool
import Split.of_eq_true
import Split.Eq_ndrec
import Split.congrFun'
import Split.ByteArray_instAppend
import Split.Char
import Split.ByteArray
import Split.List_instAppend
import Split.Option_isSome
import Split.ByteArray_utf8Decode?_utf8Encode_singleton_append
import Split.List_utf8Encode
import Split.Eq_symm
import Split.ByteArray_utf8Decode?
import Split.Eq
import Split.List_utf8Encode_append
import Split.Option_some_inj
import Split.HAppend_hAppend
import Split.true_and
import Split.Eq_trans
import Split.List_nil
import Split.Option

-- List.isPrefix_of_utf8Encode_append_eq_utf8Encode from environment
-- theorem List.isPrefix_of_utf8Encode_append_eq_utf8Encode : forall {l : List.{0} Char} {m : List.{0} Char} (b : ByteArray), (Eq.{1} ByteArray (HAppend.hAppend.{0, 0, 0} ByteArray ByteArray ByteArray (instHAppendOfAppend.{0} ByteArray ByteArray.instAppend) (List.utf8Encode l) b) (List.utf8Encode m)) -> (List.IsPrefix.{0} Char l m)

-- Stub: this file represents the declaration `List.isPrefix_of_utf8Encode_append_eq_utf8Encode`.
-- In a full split, the body would be extracted from the environment.
