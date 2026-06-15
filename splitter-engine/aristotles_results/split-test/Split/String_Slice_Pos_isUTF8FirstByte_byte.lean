import Split.String_instLTRaw
import Split.String_Slice_Pos_offset
import Split.False_elim
import Split.String_Slice_Pos_isValidForSlice
import Split.String_Slice_rawEndPos
import Split.String_Slice
import Split.Exists
import Split.Ne
import Split.String_Pos_Raw
import Split.String_Slice_Pos_byte
import Split.String_Pos_Raw_IsValidForSlice
import Split.UInt8_IsUTF8FirstByte
import Split.String_Slice_endPos
import Split.LT_lt
import Split.Iff_mp
import Split.String_Slice_Pos
import Split.Or
import Split.String_Slice_getUTF8Byte
import Split.String_Pos_Raw_isValidForSlice_iff_isUTF8FirstByte
import Split.Or_elim
import Split.Eq
import Split.String_Slice_Pos_ext

-- String.Slice.Pos.isUTF8FirstByte_byte from environment
-- theorem String.Slice.Pos.isUTF8FirstByte_byte : forall {s : String.Slice} {pos : String.Slice.Pos s} {h : Ne.{1} (String.Slice.Pos s) pos (String.Slice.endPos s)}, UInt8.IsUTF8FirstByte (String.Slice.Pos.byte s pos h)

-- Stub: this file represents the declaration `String.Slice.Pos.isUTF8FirstByte_byte`.
-- In a full split, the body would be extracted from the environment.
