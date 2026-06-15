import Split.String_instLTRaw
import Split.congrArg
import Split.String_Slice_toByteArray_copy
import Split.ByteArray_extract
import Split.String_toByteArray
import Split.GetElem_getElem_congr_simp
import Split.String_Slice_rawEndPos
import Split.String_Slice
import Split.String_getUTF8Byte
import Split.ByteArray_instGetElemNatUInt8LtSize
import Split.String_Slice_startInclusive
import Split.String_Pos_Raw
import Split.String_Pos_Raw_byteIdx_offsetBy
import Split.String_Slice_str
import Split.GetElem_getElem
import Split.String_Slice_copy
import Split.instHAdd
import Split.String_Pos_Raw_offsetBy
import Split.HAdd_hAdd
import Split.Nat
import Split.congr
import Split.LT_lt
import Split.True
import Split.eq_self
import Split.ByteArray_getElem_extract_aux
import Split.String_Slice_endExclusive
import Split.of_eq_true
import Split.Eq_ndrec
import Split.instAddNat
import Split.Eq_refl
import Split.String_Slice_getUTF8Byte
import Split.instLTNat
import Split.ByteArray
import Split.ByteArray_getElem_extract
import Split.String_Pos_Raw_byteIdx
import Split.UInt8
import Split.Eq
import Split.String_Pos_offset
import Split.ByteArray_size
import Split.Eq_trans

-- String.Slice.getUTF8Byte_eq_getUTF8Byte_copy from environment
-- theorem String.Slice.getUTF8Byte_eq_getUTF8Byte_copy : forall {s : String.Slice} {p : String.Pos.Raw} {h : LT.lt.{0} String.Pos.Raw String.instLTRaw p (String.Slice.rawEndPos s)}, Eq.{1} UInt8 (String.Slice.getUTF8Byte s p h) (String.getUTF8Byte (String.Slice.copy s) p (String.Slice.getUTF8Byte_eq_getUTF8Byte_copy._proof_1 s p h))

-- Stub: this file represents the declaration `String.Slice.getUTF8Byte_eq_getUTF8Byte_copy`.
-- In a full split, the body would be extracted from the environment.
