import Split.String_Slice_rawEndPos
import Split.String_Slice
import Split.LE_le
import Split.String_Slice_startInclusive
import Split.String_Pos_Raw
import Split.String_Pos_Raw_IsValidForSlice
import Split.String_Slice_str
import Split.String_Pos_Raw_offsetBy
import Split.String_instLERaw
import Split.String_Pos_Raw_IsValid
import Split.String_Pos_offset

-- String.Pos.Raw.IsValidForSlice.mk from environment
-- constructor String.Pos.Raw.IsValidForSlice.mk : forall {s : String.Slice} {p : String.Pos.Raw}, (LE.le.{0} String.Pos.Raw String.instLERaw p (String.Slice.rawEndPos s)) -> (String.Pos.Raw.IsValid (String.Slice.str s) (String.Pos.Raw.offsetBy p (String.Pos.offset (String.Slice.str s) (String.Slice.startInclusive s)))) -> (String.Pos.Raw.IsValidForSlice s p)

-- Stub: this file represents the declaration `String.Pos.Raw.IsValidForSlice.mk`.
-- In a full split, the body would be extracted from the environment.
