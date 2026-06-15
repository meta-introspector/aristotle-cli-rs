import Split.Eq_mpr
import Split.String_Pos_Raw_IsValid_isValidUTF8_extract_zero
import Split.String_toByteArray_inj
import Split.String_toByteArray_ofList
import Split.congrArg
import Split.String
import Split.ByteArray_extract
import Split.String_toByteArray
import Split.List_isPrefix_of_utf8Encode_append_eq_utf8Encode
import Split.Exists
import Split.String_Pos_Raw_IsValid_le_rawEndPos
import Split.Eq_mp
import Split.id
import Split.instOfNatNat
import Split.LE_le
import Split.ByteArray_extract_zero_size
import Split.instLENat
import Split.ByteArray_IsValidUTF8_casesOn
import Split.String_Pos_Raw
import Split.instAppendString
import Split.instHAppendOfAppend
import Split.List
import Split.And
import Split.Exists_casesOn
import Split.List_IsPrefix
import Split.String_ofList_append
import Split.Nat
import Split.And_intro
import Split.congr
import Split.Exists_intro
import Split.Iff_mp
import Split.of_eq_true
import Split.Eq_ndrec
import Split.String_toByteArray_append
import Split.String_isValidUTF8
import Split.Eq_refl
import Split.congrFun'
import Split.ByteArray_instAppend
import Split.Char
import Split.ByteArray
import Split.List_instAppend
import Split.ByteArray_extract_eq_extract_append_extract
import Split.OfNat_ofNat
import Split.List_utf8Encode
import Split.Eq_symm
import Split.String_Pos_Raw_IsValid
import Split.String_Pos_Raw_byteIdx
import Split.Eq
import Split.List_utf8Encode_append
import Split.HAppend_hAppend
import Split.String_ofList
import Split.ByteArray_size
import Split.Eq_trans
import Split.ByteArray_IsValidUTF8

-- String.Pos.Raw.IsValid.exists from environment
-- theorem String.Pos.Raw.IsValid.exists : forall {s : String} {p : String.Pos.Raw}, (String.Pos.Raw.IsValid s p) -> (Exists.{1} (List.{0} Char) (fun (m₁ : List.{0} Char) => Exists.{1} (List.{0} Char) (fun (m₂ : List.{0} Char) => And (Eq.{1} ByteArray (List.utf8Encode m₁) (ByteArray.extract (String.toByteArray s) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (String.Pos.Raw.byteIdx p))) (Eq.{1} String (String.ofList (HAppend.hAppend.{0, 0, 0} (List.{0} Char) (List.{0} Char) (List.{0} Char) (instHAppendOfAppend.{0} (List.{0} Char) (List.instAppend.{0} Char)) m₁ m₂)) s))))

-- Stub: this file represents the declaration `String.Pos.Raw.IsValid.exists`.
-- In a full split, the body would be extracted from the environment.
