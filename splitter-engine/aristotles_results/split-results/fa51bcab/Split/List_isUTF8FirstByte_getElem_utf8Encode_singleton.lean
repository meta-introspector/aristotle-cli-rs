import Split.List_getElem_toByteArray
import Split.congrArg
import Split.GetElem_getElem_congr_simp
import Split.instOfNatNat
import Split.ByteArray_instGetElemNatUInt8LtSize
import Split.List_toByteArray
import Split.List_cons
import Split.GetElem_getElem
import Split.iff_self
import Split.UInt8_IsUTF8FirstByte
import Split.List
import Split.String_utf8EncodeChar
import Split.Iff
import Split.Nat
import Split.LT_lt
import Split.True
import Split.List_utf8Encode_singleton
import Split.of_eq_true
import Split.Eq_ndrec
import Split.Eq_refl
import Split.congrFun'
import Split.Char
import Split.instLTNat
import Split.ByteArray
import Split.List_instGetElemNatLtLength
import Split.OfNat_ofNat
import Split.List_utf8Encode
import Split.UInt8
import Split.Eq
import Split.List_length
import Split.ByteArray_size
import Split.Eq_trans
import Split.List_nil

-- List.isUTF8FirstByte_getElem_utf8Encode_singleton from environment
-- theorem List.isUTF8FirstByte_getElem_utf8Encode_singleton : forall {c : Char} {i : Nat} {hi : LT.lt.{0} Nat instLTNat i (ByteArray.size (List.utf8Encode (List.cons.{0} Char c (List.nil.{0} Char))))}, Iff (UInt8.IsUTF8FirstByte (GetElem.getElem.{0, 0, 0} ByteArray Nat UInt8 (fun (xs : ByteArray) (i : Nat) => LT.lt.{0} Nat instLTNat i (ByteArray.size xs)) ByteArray.instGetElemNatUInt8LtSize (List.utf8Encode (List.cons.{0} Char c (List.nil.{0} Char))) i hi)) (Eq.{1} Nat i (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))

-- Stub: this file represents the declaration `List.isUTF8FirstByte_getElem_utf8Encode_singleton`.
-- In a full split, the body would be extracted from the environment.
