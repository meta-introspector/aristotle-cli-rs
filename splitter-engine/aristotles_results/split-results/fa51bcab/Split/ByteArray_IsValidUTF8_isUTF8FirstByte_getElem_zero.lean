import Split.List_utf8Encode_nil
import Split.List_head
import Split.Iff_mpr
import Split.List_size_toByteArray
import Split.Eq_mpr
import Split.ByteArray_getElem_append_left
import Split.GetElem
import Split.False
import Split.List_cons_head_tail
import Split.ByteArray_size_empty
import Split.congrArg
import Split.False_elim
import Split.Eq_rec
import Split.Eq_mp
import Split.id
import Split.Ne
import Split.ByteArray_empty
import Split.instOfNatNat
import Split.ByteArray_instGetElemNatUInt8LtSize
import Split.ByteArray_IsValidUTF8_casesOn
import Split.List_toByteArray
import Split.List_tail
import Split.List_cons
import Split.GetElem_getElem
import Split.UInt8_IsUTF8FirstByte
import Split.instHAppendOfAppend
import Split.List
import Split.String_utf8EncodeChar
import Split.List_singleton_append
import Split.String_length_utf8EncodeChar
import Split.Nat
import Split.LT_lt
import Split.True
import Split.List_utf8Encode_singleton
import Split.List_isUTF8FirstByte_getElem_utf8Encode_singleton
import Split.of_eq_true
import Split.Eq_ndrec
import Split.Eq_refl
import Split.ByteArray_instAppend
import Split.Char
import Split.instLTNat
import Split.ByteArray
import Split.List_instAppend
import Split.OfNat_ofNat
import Split.List_utf8Encode
import Split.Eq_symm
import Split.UInt8
import Split.Eq
import Split.List_length
import Split.List_utf8Encode_append
import Split.HAppend_hAppend
import Split.Char_utf8Size
import Split.rfl
import Split.ByteArray_size
import Split.Eq_trans
import Split.ByteArray_IsValidUTF8
import Split.List_nil

-- ByteArray.IsValidUTF8.isUTF8FirstByte_getElem_zero from environment
-- theorem ByteArray.IsValidUTF8.isUTF8FirstByte_getElem_zero : forall {b : ByteArray}, (ByteArray.IsValidUTF8 b) -> (forall (h₀ : LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (ByteArray.size b)), UInt8.IsUTF8FirstByte (GetElem.getElem.{0, 0, 0} ByteArray Nat UInt8 (fun (xs : ByteArray) (i : Nat) => LT.lt.{0} Nat instLTNat i (ByteArray.size xs)) ByteArray.instGetElemNatUInt8LtSize b (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) h₀))

-- Stub: this file represents the declaration `ByteArray.IsValidUTF8.isUTF8FirstByte_getElem_zero`.
-- In a full split, the body would be extracted from the environment.
