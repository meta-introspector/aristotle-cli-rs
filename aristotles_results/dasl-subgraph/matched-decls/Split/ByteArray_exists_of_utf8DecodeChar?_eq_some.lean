import Split.ByteArray_extract
import Split.ByteArray_eq_of_utf8DecodeChar?_eq_some
import Split.Option_some
import Split.Exists
import Split.instOfNatNat
import Split.List_toByteArray
import Split.instHAppendOfAppend
import Split.String_utf8EncodeChar
import Split.Nat
import Split.Exists_intro
import Split.ByteArray_instAppend
import Split.Char
import Split.ByteArray
import Split.OfNat_ofNat
import Split.Eq
import Split.HAppend_hAppend
import Split.Char_utf8Size
import Split.ByteArray_size
import Split.ByteArray_utf8DecodeChar?
import Split.Option

-- ByteArray.exists_of_utf8DecodeChar?_eq_some from environment
-- theorem ByteArray.exists_of_utf8DecodeChar?_eq_some : forall {b : ByteArray} {c : Char}, (Eq.{1} (Option.{0} Char) (ByteArray.utf8DecodeChar? b (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (Option.some.{0} Char c)) -> (Exists.{1} ByteArray (fun (l : ByteArray) => Eq.{1} ByteArray b (HAppend.hAppend.{0, 0, 0} ByteArray ByteArray ByteArray (instHAppendOfAppend.{0} ByteArray ByteArray.instAppend) (List.toByteArray (String.utf8EncodeChar c)) l)))

-- Stub: this file represents the declaration `ByteArray.exists_of_utf8DecodeChar?_eq_some`.
-- In a full split, the body would be extracted from the environment.
