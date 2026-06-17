import Split.ByteArray_utf8DecodeChar?_parseFirstByte
import Split.Eq_mpr
import Split.ByteArray_extract_add_one
import Split.ByteArray_extract_add_two
import Split.ByteArray_utf8DecodeChar?_assemble₃
import Split.congrArg
import Split.ByteArray_extract
import Split.Char_utf8Size_le_four
import Split.Option_some
import Split.Exists
import Split.ByteArray_utf8DecodeChar?_FirstByte_threeMore
import Split.Eq_rec
import Split.Eq_mp
import Split.ByteArray_utf8DecodeChar?_FirstByte_twoMore
import Split.id
import Split.instOfNatNat
import Split.ByteArray_instGetElemNatUInt8LtSize
import Split.LE_le
import Split.instLENat
import Split.List_toByteArray
import Split.ByteArray_utf8DecodeChar?_assemble₄
import Split.ByteArray_utf8DecodeChar?_assemble₁
import Split.List_cons
import Split.GetElem_getElem
import Split.List
import Split.instHAdd
import Split.String_utf8EncodeChar
import Split.And
import Split.HAdd_hAdd
import Split.Nat
import Split.And_intro
import Split.LT_lt
import Split.propext
import Split.Exists_intro
import Split.Decidable_byContradiction
import Split.ByteArray_extract_add_four
import Split.Nat_decLt
import Split.Char_utf8Size_pos
import Split.instAddNat
import Split.Eq_refl
import Split.ByteArray_utf8DecodeChar?_assemble₂
import Split.ByteArray_utf8DecodeChar?_FirstByte_done
import Split.ByteArray_utf8DecodeChar?_FirstByte
import Split.Char
import Split.instLTNat
import Split.ByteArray
import Split.ByteArray_utf8DecodeChar?_FirstByte_oneMore
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.UInt8
import Split.Eq
import Split.Not
import Split.ByteArray_extract_add_three
import Split.Nat_decLe
import Split.Char_utf8Size
import Split.ByteArray_size
import Split.ByteArray_utf8DecodeChar?
import Split.List_nil
import Split.Option

-- String.toByteArray_utf8EncodeChar_of_utf8DecodeChar?_eq_some from environment
-- theorem String.toByteArray_utf8EncodeChar_of_utf8DecodeChar?_eq_some : forall {b : ByteArray} {c : Char}, (Eq.{1} (Option.{0} Char) (ByteArray.utf8DecodeChar? b (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (Option.some.{0} Char c)) -> (Eq.{1} ByteArray (List.toByteArray (String.utf8EncodeChar c)) (ByteArray.extract b (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (Char.utf8Size c)))

-- Stub: this file represents the declaration `String.toByteArray_utf8EncodeChar_of_utf8DecodeChar?_eq_some`.
-- In a full split, the body would be extracted from the environment.
