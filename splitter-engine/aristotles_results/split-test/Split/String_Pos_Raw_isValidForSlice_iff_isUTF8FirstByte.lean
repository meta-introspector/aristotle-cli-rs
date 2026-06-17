import Split.Iff_mpr
import Split.String_instLTRaw
import Split.Iff_of_eq
import Split.congrArg
import Split.String_Slice_rawEndPos
import Split.String_Slice
import Split.Exists
import Split.String_getUTF8Byte
import Split.String_Pos_Raw
import Split.String_Pos_Raw_IsValidForSlice
import Split.iff_self
import Split.String_rawEndPos
import Split.String_Slice_copy
import Split.UInt8_IsUTF8FirstByte
import Split.Iff
import Split.exists_prop_congr
import Split.congr
import Split.LT_lt
import Split.True
import Split.propext
import Split.of_eq_true
import Split.congrFun'
import Split.String_Slice_getUTF8Byte_copy
import Split.Or
import Split.String_Slice_getUTF8Byte
import Split.String_Pos_Raw_IsValid
import Split.UInt8
import Split.Eq
import Split.Eq_trans
import Split.String_Slice_rawEndPos_copy

-- String.Pos.Raw.isValidForSlice_iff_isUTF8FirstByte from environment
-- theorem String.Pos.Raw.isValidForSlice_iff_isUTF8FirstByte : forall {s : String.Slice} {p : String.Pos.Raw}, Iff (String.Pos.Raw.IsValidForSlice s p) (Or (Eq.{1} String.Pos.Raw p (String.Slice.rawEndPos s)) (Exists.{0} (LT.lt.{0} String.Pos.Raw String.instLTRaw p (String.Slice.rawEndPos s)) (fun (h : LT.lt.{0} String.Pos.Raw String.instLTRaw p (String.Slice.rawEndPos s)) => UInt8.IsUTF8FirstByte (String.Slice.getUTF8Byte s p h))))

-- Stub: this file represents the declaration `String.Pos.Raw.isValidForSlice_iff_isUTF8FirstByte`.
-- In a full split, the body would be extracted from the environment.
