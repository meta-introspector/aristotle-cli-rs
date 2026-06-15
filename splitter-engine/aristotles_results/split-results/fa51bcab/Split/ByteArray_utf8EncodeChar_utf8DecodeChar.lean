import Split.Eq_mpr
import Split.congrArg
import Split.ByteArray_extract
import Split.ByteArray_utf8DecodeChar
import Split.Option_some
import Split.Exists
import Split.Eq_mp
import Split.Option_get_congr_simp
import Split.id
import Split.ByteArray_extract_extract
import Split.instOfNatNat
import Split.List_toByteArray
import Split.Option_some_get
import Split.Bool_true
import Split.ByteArray_utf8DecodeChar?_eq_utf8DecodeChar?_extract
import Split.instHAdd
import Split.String_utf8EncodeChar
import Split.Option_isSome_iff_exists
import Split.Exists_casesOn
import Split.String_toByteArray_utf8EncodeChar_of_utf8DecodeChar?_eq_some
import Split.Option_get
import Split.HAdd_hAdd
import Split.ByteArray_le_size_of_utf8DecodeChar?_eq_some
import Split.Nat
import Split.ByteArray_utf8DecodeChar_eq_utf8DecodeChar_extract
import Split.True
import Split.Nat_min_eq_left
import Split.eq_self
import Split.Iff_mp
import Split.Bool
import Split.of_eq_true
import Split.Eq_ndrec
import Split.instAddNat
import Split.Eq_refl
import Split.Nat_add_zero
import Split.ByteArray_utf8DecodeChar_eq_1
import Split.Char
import Split.ByteArray
import Split.Option_isSome
import Split.OfNat_ofNat
import Split.Eq
import Split.Char_utf8Size
import Split.Min_min
import Split.instMinNat
import Split.ByteArray_size
import Split.Eq_trans
import Split.ByteArray_utf8DecodeChar?
import Split.Option

-- ByteArray.utf8EncodeChar_utf8DecodeChar from environment
-- theorem ByteArray.utf8EncodeChar_utf8DecodeChar : forall {b : ByteArray} {i : Nat} {h : Eq.{1} Bool (Option.isSome.{0} Char (ByteArray.utf8DecodeChar? b i)) Bool.true}, Eq.{1} ByteArray (List.toByteArray (String.utf8EncodeChar (ByteArray.utf8DecodeChar b i h))) (ByteArray.extract b i (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) i (Char.utf8Size (ByteArray.utf8DecodeChar b i h))))

-- Stub: this file represents the declaration `ByteArray.utf8EncodeChar_utf8DecodeChar`.
-- In a full split, the body would be extracted from the environment.
