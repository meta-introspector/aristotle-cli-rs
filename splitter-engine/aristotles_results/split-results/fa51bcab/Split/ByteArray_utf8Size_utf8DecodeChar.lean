import Split.UInt8_utf8ByteSize_congr_simp
import Split.Eq_mpr
import Split.ByteArray_lt_size_of_isSome_utf8DecodeChar?
import Split.congrArg
import Split.ByteArray_extract
import Split.GetElem_getElem_congr_simp
import Split.ByteArray_utf8DecodeChar
import Split.UInt8_utf8ByteSize
import Split.id
import Split.instOfNatNat
import Split.ByteArray_isUTF8FirstByte_of_isSome_utf8DecodeChar?
import Split.ByteArray_instGetElemNatUInt8LtSize
import Split.List_toByteArray
import Split.GetElem_getElem
import Split.Bool_true
import Split.UInt8_IsUTF8FirstByte
import Split.List
import Split.instHAdd
import Split.String_utf8EncodeChar
import Split.ByteArray_utf8EncodeChar_utf8DecodeChar
import Split.HAdd_hAdd
import Split.List_getElem_eq_getElem_toByteArray
import Split.String_length_utf8EncodeChar
import Split.Nat
import Split.LT_lt
import Split.True
import Split.eq_self
import Split.ByteArray_getElem_extract_aux
import Split.eq_true
import Split.Bool
import Split.of_eq_true
import Split.Eq_ndrec
import Split.Char_utf8Size_pos
import Split.instAddNat
import Split.Eq_refl
import Split.congrFun'
import Split.Char
import Split.instLTNat
import Split.ByteArray
import Split.Option_isSome
import Split.ByteArray_getElem_extract
import Split.List_instGetElemNatLtLength
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.UInt8
import Split.Eq
import Split.List_length
import Split.Char_utf8Size
import Split.ByteArray_size
import Split.UInt8_isUTF8FirstByte_getElem_zero_utf8EncodeChar
import Split.Eq_trans
import Split.ByteArray_utf8DecodeChar?

-- ByteArray.utf8Size_utf8DecodeChar from environment
-- theorem ByteArray.utf8Size_utf8DecodeChar : forall {b : ByteArray} {i : Nat} {h : Eq.{1} Bool (Option.isSome.{0} Char (ByteArray.utf8DecodeChar? b i)) Bool.true}, Eq.{1} Nat (Char.utf8Size (ByteArray.utf8DecodeChar b i h)) (UInt8.utf8ByteSize (GetElem.getElem.{0, 0, 0} ByteArray Nat UInt8 (fun (xs : ByteArray) (i : Nat) => LT.lt.{0} Nat instLTNat i (ByteArray.size xs)) ByteArray.instGetElemNatUInt8LtSize b i (ByteArray.lt_size_of_isSome_utf8DecodeChar? b i h)) (ByteArray.isUTF8FirstByte_of_isSome_utf8DecodeChar? b i h))

-- Stub: this file represents the declaration `ByteArray.utf8Size_utf8DecodeChar`.
-- In a full split, the body would be extracted from the environment.
