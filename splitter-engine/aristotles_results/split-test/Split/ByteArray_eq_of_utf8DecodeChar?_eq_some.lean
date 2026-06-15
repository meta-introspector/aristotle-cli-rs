import Split.Eq_mpr
import Split.congrArg
import Split.ByteArray_extract_append_extract
import Split.ByteArray_extract
import Split.Option_some
import Split.id
import Split.instOfNatNat
import Split.ByteArray_extract_zero_size
import Split.List_toByteArray
import Split.instHAppendOfAppend
import Split.String_utf8EncodeChar
import Split.Nat_max_eq_right
import Split.String_toByteArray_utf8EncodeChar_of_utf8DecodeChar?_eq_some
import Split.Max_max
import Split.Nat
import Split.Eq_refl
import Split.ByteArray_instAppend
import Split.Char
import Split.Nat_instMax
import Split.ByteArray
import Split.OfNat_ofNat
import Split.Eq
import Split.HAppend_hAppend
import Split.Char_utf8Size
import Split.Min_min
import Split.instMinNat
import Split.ByteArray_size
import Split.ByteArray_utf8DecodeChar?
import Split.Option
import Split.Nat_zero_min

-- ByteArray.eq_of_utf8DecodeChar?_eq_some from environment
-- theorem ByteArray.eq_of_utf8DecodeChar?_eq_some : forall {b : ByteArray} {c : Char}, (Eq.{1} (Option.{0} Char) (ByteArray.utf8DecodeChar? b (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (Option.some.{0} Char c)) -> (Eq.{1} ByteArray b (HAppend.hAppend.{0, 0, 0} ByteArray ByteArray ByteArray (instHAppendOfAppend.{0} ByteArray ByteArray.instAppend) (List.toByteArray (String.utf8EncodeChar c)) (ByteArray.extract b (Char.utf8Size c) (ByteArray.size b))))

-- Stub: this file represents the declaration `ByteArray.eq_of_utf8DecodeChar?_eq_some`.
-- In a full split, the body would be extracted from the environment.
