import Split.ByteArray_utf8DecodeChar?_parseFirstByte
import Split.Iff_mpr
import Split.Eq_mpr
import Split.ByteArray_utf8DecodeChar?_assemble₃
import Split.congrArg
import Split.List_eq_getElem_of_length_eq_one
import Split.Char_utf8Size_le_four
import Split.List_eq_getElem_of_length_eq_two
import Split.Option_some
import Split.Exists
import Split.ByteArray_utf8DecodeChar?_FirstByte_threeMore
import Split.Eq_rec
import Split.ByteArray_utf8DecodeChar?_FirstByte_twoMore
import Split.id
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.List_toByteArray
import Split.List_eq_getElem_of_length_eq_four
import Split.ByteArray_utf8DecodeChar?_assemble₄
import Split.ByteArray_utf8DecodeChar?_assemble₁
import Split.List_cons
import Split.GetElem_getElem
import Split.instHAppendOfAppend
import Split.List
import Split.String_utf8EncodeChar
import Split.And
import Split.And_right
import Split.String_length_utf8EncodeChar
import Split.Nat
import Split.LT_lt
import Split.Decidable_byContradiction
import Split.Nat_decLt
import Split.Char_utf8Size_pos
import Split.ByteArray_utf8DecodeChar?_assemble₂
import Split.ByteArray_utf8DecodeChar?_FirstByte_done
import Split.ByteArray_utf8DecodeChar?_FirstByte
import Split.ByteArray_instAppend
import Split.Char
import Split.instLTNat
import Split.ByteArray
import Split.List_instGetElemNatLtLength
import Split.ByteArray_utf8DecodeChar?_FirstByte_oneMore
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.UInt8
import Split.Eq
import Split.List_length
import Split.Not
import Split.HAppend_hAppend
import Split.Char_utf8Size
import Split.ByteArray_utf8DecodeChar?
import Split.List_eq_getElem_of_length_eq_three
import Split.List_nil
import Split.Option

-- ByteArray.utf8DecodeChar?_utf8EncodeChar_append from environment
-- theorem ByteArray.utf8DecodeChar?_utf8EncodeChar_append : forall {b : ByteArray} {c : Char}, Eq.{1} (Option.{0} Char) (ByteArray.utf8DecodeChar? (HAppend.hAppend.{0, 0, 0} ByteArray ByteArray ByteArray (instHAppendOfAppend.{0} ByteArray ByteArray.instAppend) (List.toByteArray (String.utf8EncodeChar c)) b) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (Option.some.{0} Char c)

-- Stub: this file represents the declaration `ByteArray.utf8DecodeChar?_utf8EncodeChar_append`.
-- In a full split, the body would be extracted from the environment.
