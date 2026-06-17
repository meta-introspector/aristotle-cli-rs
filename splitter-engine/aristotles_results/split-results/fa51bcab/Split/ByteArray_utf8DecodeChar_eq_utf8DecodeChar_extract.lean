import Split.congrArg
import Split.ByteArray_extract
import Split.ByteArray_utf8DecodeChar
import Split.Option_get_congr_simp
import Split.instOfNatNat
import Split.Bool_true
import Split.Option_get
import Split.Nat
import Split.True
import Split.eq_self
import Split.Bool
import Split.of_eq_true
import Split.Eq_ndrec
import Split.Char
import Split.ByteArray
import Split.Option_isSome
import Split.OfNat_ofNat
import Split.Eq
import Split.ByteArray_size
import Split.Eq_trans
import Split.ByteArray_utf8DecodeChar?
import Split.Option

-- ByteArray.utf8DecodeChar_eq_utf8DecodeChar_extract from environment
-- theorem ByteArray.utf8DecodeChar_eq_utf8DecodeChar_extract : forall {b : ByteArray} {i : Nat} {h : Eq.{1} Bool (Option.isSome.{0} Char (ByteArray.utf8DecodeChar? b i)) Bool.true}, Eq.{1} Char (ByteArray.utf8DecodeChar b i h) (ByteArray.utf8DecodeChar (ByteArray.extract b i (ByteArray.size b)) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (ByteArray.utf8DecodeChar_eq_utf8DecodeChar_extract._proof_1 b i h))

-- Stub: this file represents the declaration `ByteArray.utf8DecodeChar_eq_utf8DecodeChar_extract`.
-- In a full split, the body would be extracted from the environment.
