import Split.Eq_mpr
import Split.List_utf8Encode_eq_1
import Split.congrArg
import Split.ByteArray_utf8DecodeChar?_utf8EncodeChar_append
import Split.Option_some
import Split.List_flatMap_nil
import Split.id
import Split.ByteArray_empty
import Split.instOfNatNat
import Split.List_toByteArray
import Split.List_cons
import Split.List_flatMap_cons
import Split.instHAppendOfAppend
import Split.List
import Split.String_utf8EncodeChar
import Split.Nat
import Split.Eq_refl
import Split.ByteArray_instAppend
import Split.Char
import Split.ByteArray_append_empty
import Split.ByteArray
import Split.List_instAppend
import Split.OfNat_ofNat
import Split.List_utf8Encode
import Split.UInt8
import Split.List_toByteArray_nil
import Split.Eq
import Split.HAppend_hAppend
import Split.List_flatMap
import Split.List_toByteArray_append
import Split.ByteArray_utf8DecodeChar?
import Split.List_nil
import Split.Option

-- List.utf8DecodeChar?_utf8Encode_singleton_append from environment
-- theorem List.utf8DecodeChar?_utf8Encode_singleton_append : forall {b : ByteArray} {c : Char}, Eq.{1} (Option.{0} Char) (ByteArray.utf8DecodeChar? (HAppend.hAppend.{0, 0, 0} ByteArray ByteArray ByteArray (instHAppendOfAppend.{0} ByteArray ByteArray.instAppend) (List.utf8Encode (List.cons.{0} Char c (List.nil.{0} Char))) b) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (Option.some.{0} Char c)

-- Stub: this file represents the declaration `List.utf8DecodeChar?_utf8Encode_singleton_append`.
-- In a full split, the body would be extracted from the environment.
