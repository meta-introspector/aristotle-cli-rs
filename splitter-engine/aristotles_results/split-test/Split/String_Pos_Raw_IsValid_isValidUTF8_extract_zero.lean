import Split.String
import Split.ByteArray_extract
import Split.String_toByteArray
import Split.instOfNatNat
import Split.String_Pos_Raw
import Split.Nat
import Split.OfNat_ofNat
import Split.String_Pos_Raw_IsValid
import Split.String_Pos_Raw_byteIdx
import Split.ByteArray_IsValidUTF8

-- String.Pos.Raw.IsValid.isValidUTF8_extract_zero from environment
-- theorem String.Pos.Raw.IsValid.isValidUTF8_extract_zero : forall {s : String} {off : String.Pos.Raw}, (String.Pos.Raw.IsValid s off) -> (ByteArray.IsValidUTF8 (ByteArray.extract (String.toByteArray s) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (String.Pos.Raw.byteIdx off)))

-- Stub: this file represents the declaration `String.Pos.Raw.IsValid.isValidUTF8_extract_zero`.
-- In a full split, the body would be extracted from the environment.
