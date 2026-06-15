import Split.String_toList_ofList
import Split.Eq_mpr
import Split.congrArg
import Split.String
import Split.String_length_toList
import Split.String_utf8ByteSize
import Split.List_take_append_drop
import Split.Exists
import Split.Eq_mp
import Split.id
import Split.String_ofList_toList
import Split.String_Pos_Raw
import Split.And_casesOn
import Split.String_rawEndPos
import Split.instAppendString
import Split.instHAppendOfAppend
import Split.List
import Split.And
import Split.Iff
import Split.Exists_casesOn
import Split.List_drop
import Split.Nat
import Split.String_toList
import Split.And_intro
import Split.congr
import Split.True
import Split.Iff_intro
import Split.eq_self
import Split.propext
import Split.Exists_intro
import Split.String_length
import Split.of_eq_true
import Split.Eq_ndrec
import Split.congrFun'
import Split.Char
import Split.List_instAppend
import Split.Eq_symm
import Split.String_Pos_Raw_IsValid
import Split.String_Pos_Raw_byteIdx
import Split.String_Pos_Raw_isValid_iff_exists_append
import Split.Eq
import Split.List_take
import Split.List_length
import Split.String_toList_append
import Split.List_take_left'
import Split.HAppend_hAppend
import Split.String_ofList
import Split.Eq_trans

-- String.Pos.Raw.isValid_ofList from environment
-- theorem String.Pos.Raw.isValid_ofList : forall {l : List.{0} Char} {p : String.Pos.Raw}, Iff (String.Pos.Raw.IsValid (String.ofList l) p) (Exists.{1} Nat (fun (i : Nat) => Eq.{1} Nat (String.Pos.Raw.byteIdx p) (String.utf8ByteSize (String.ofList (List.take.{0} Char i l)))))

-- Stub: this file represents the declaration `String.Pos.Raw.isValid_ofList`.
-- In a full split, the body would be extracted from the environment.
