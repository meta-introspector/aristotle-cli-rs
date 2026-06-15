import Split.String
import Split.ByteArray_extract
import Split.String_toByteArray
import Split.instOfNatNat
import Split.LE_le
import Split.String_Pos_Raw
import Split.String_rawEndPos
import Split.And
import Split.Iff
import Split.Nat
import Split.And_intro
import Split.String_instLERaw
import Split.Iff_intro
import Split.OfNat_ofNat
import Split.String_Pos_Raw_IsValid
import Split.String_Pos_Raw_byteIdx
import Split.ByteArray_IsValidUTF8

-- String.Pos.Raw.isValid_iff_isValidUTF8_extract_zero from environment
-- theorem String.Pos.Raw.isValid_iff_isValidUTF8_extract_zero : forall {s : String} {p : String.Pos.Raw}, Iff (String.Pos.Raw.IsValid s p) (And (LE.le.{0} String.Pos.Raw String.instLERaw p (String.rawEndPos s)) (ByteArray.IsValidUTF8 (ByteArray.extract (String.toByteArray s) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (String.Pos.Raw.byteIdx p))))

-- Stub: this file represents the declaration `String.Pos.Raw.isValid_iff_isValidUTF8_extract_zero`.
-- In a full split, the body would be extracted from the environment.
