import Split.Eq_mpr
import Split.congrArg
import Split.id
import Split.ByteArray_isUTF8FirstByte_of_isSome_utf8DecodeChar?
import Split.ByteArray_validateUTF8At_eq_isSome_utf8DecodeChar?
import Split.ByteArray_instGetElemNatUInt8LtSize
import Split.GetElem_getElem
import Split.Bool_true
import Split.forall_prop_domain_congr
import Split.UInt8_IsUTF8FirstByte
import Split.ByteArray_lt_size_of_validateUTF8At
import Split.Nat
import Split.LT_lt
import Split.Eq_substr
import Split.Bool
import Split.Eq_refl
import Split.congrFun'
import Split.Char
import Split.instLTNat
import Split.ByteArray
import Split.Option_isSome
import Split.ByteArray_validateUTF8At
import Split.UInt8
import Split.Eq
import Split.ByteArray_size
import Split.ByteArray_utf8DecodeChar?

-- ByteArray.isUTF8FirstByte_of_validateUTF8At from environment
-- theorem ByteArray.isUTF8FirstByte_of_validateUTF8At : forall {b : ByteArray} {i : Nat} (h : Eq.{1} Bool (ByteArray.validateUTF8At b i) Bool.true), UInt8.IsUTF8FirstByte (GetElem.getElem.{0, 0, 0} ByteArray Nat UInt8 (fun (xs : ByteArray) (i : Nat) => LT.lt.{0} Nat instLTNat i (ByteArray.size xs)) ByteArray.instGetElemNatUInt8LtSize b i (ByteArray.lt_size_of_validateUTF8At b i h))

-- Stub: this file represents the declaration `ByteArray.isUTF8FirstByte_of_validateUTF8At`.
-- In a full split, the body would be extracted from the environment.
