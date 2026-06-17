import Split.List_getElem_toByteArray
import Split.List_size_toByteArray
import Split.Eq_mpr
import Split.ByteArray_getElem_append_left
import Split.UInt8_isUTF8FirstByte_getElem_utf8EncodeChar
import Split.congrArg
import Split.id
import Split.instOfNatNat
import Split.ByteArray_instGetElemNatUInt8LtSize
import Split.List_toByteArray
import Split.GetElem_getElem
import Split.UInt8_IsUTF8FirstByte
import Split.instHAppendOfAppend
import Split.List
import Split.String_utf8EncodeChar
import Split.String_length_utf8EncodeChar
import Split.Nat
import Split.LT_lt
import Split.True
import Split.propext
import Split.eq_true
import Split.of_eq_true
import Split.Char_utf8Size_pos
import Split.Eq_refl
import Split.ByteArray_instAppend
import Split.Char
import Split.instLTNat
import Split.ByteArray
import Split.List_instGetElemNatLtLength
import Split.OfNat_ofNat
import Split.UInt8
import Split.Eq
import Split.List_length
import Split.HAppend_hAppend
import Split.Char_utf8Size
import Split.ByteArray_size
import Split.Eq_trans

-- ByteArray.isUTF8FirstByte_getElem_zero_utf8EncodeChar_append from environment
-- theorem ByteArray.isUTF8FirstByte_getElem_zero_utf8EncodeChar_append : forall {c : Char} {b : ByteArray}, UInt8.IsUTF8FirstByte (GetElem.getElem.{0, 0, 0} ByteArray Nat UInt8 (fun (xs : ByteArray) (i : Nat) => LT.lt.{0} Nat instLTNat i (ByteArray.size xs)) ByteArray.instGetElemNatUInt8LtSize (HAppend.hAppend.{0, 0, 0} ByteArray ByteArray ByteArray (instHAppendOfAppend.{0} ByteArray ByteArray.instAppend) (List.toByteArray (String.utf8EncodeChar c)) b) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (ByteArray.isUTF8FirstByte_getElem_zero_utf8EncodeChar_append._proof_2 c b))

-- Stub: this file represents the declaration `ByteArray.isUTF8FirstByte_getElem_zero_utf8EncodeChar_append`.
-- In a full split, the body would be extracted from the environment.
