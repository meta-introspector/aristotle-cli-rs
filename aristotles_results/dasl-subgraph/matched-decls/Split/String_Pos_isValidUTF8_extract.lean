import Split.Iff_mpr
import Split.Eq_mpr
import Split.congrArg
import Split.String_byteIdx_rawEndPos
import Split.String
import Split.ByteArray_extract
import Split.ByteArray_extract_eq_empty_iff
import Split.String_toByteArray
import Split.String_utf8ByteSize
import Split.String_instDecidableLePos
import Split.String_Pos_Raw_IsValid_le_rawEndPos
import Split.Eq_mp
import Split.id
import Split.String_Pos_le_iff
import Split.ByteArray_empty
import Split.LE_le
import Split.instLENat
import Split.String_Pos_Raw
import Split.dite
import Split.String_rawEndPos
import Split.And
import Split.String_Pos_isValid
import Split.Nat
import Split.And_intro
import Split.Nat_min_eq_left
import Split.ByteArray_isValidUTF8_empty
import Split.String_instLERaw
import Split.propext
import Split.Iff_mp
import Split.String_Pos
import Split.Decidable_byContradiction
import Split.String_instLEPos
import Split.Or
import Split.ByteArray
import Split.String_Pos_Raw_isValidUTF8_extract_iff
import Split.Eq_symm
import Split.String_Pos_Raw_IsValid
import Split.String_Pos_Raw_byteIdx
import Split.String_Pos_Raw_le_iff
import Split.Eq
import Split.Not
import Split.Nat_decLe
import Split.String_Pos_offset
import Split.Min_min
import Split.Or_inr
import Split.instMinNat
import Split.ByteArray_size
import Split.ByteArray_IsValidUTF8
import Split.String_size_toByteArray

-- String.Pos.isValidUTF8_extract from environment
-- theorem String.Pos.isValidUTF8_extract : forall {s : String} (pos₁ : String.Pos s) (pos₂ : String.Pos s), ByteArray.IsValidUTF8 (ByteArray.extract (String.toByteArray s) (String.Pos.Raw.byteIdx (String.Pos.offset s pos₁)) (String.Pos.Raw.byteIdx (String.Pos.offset s pos₂)))

-- Stub: this file represents the declaration `String.Pos.isValidUTF8_extract`.
-- In a full split, the body would be extracted from the environment.
