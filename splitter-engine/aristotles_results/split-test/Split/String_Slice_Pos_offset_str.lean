import Split.String_Slice_Pos_str
import Split.String_Slice_Pos_offset
import Split.String_Slice
import Split.String_Slice_startInclusive
import Split.String_Pos_Raw
import Split.String_Slice_str
import Split.String_Pos_Raw_offsetBy
import Split.String_Slice_Pos
import Split.Eq
import Split.String_Pos_offset
import Split.rfl

-- String.Slice.Pos.offset_str from environment
-- theorem String.Slice.Pos.offset_str : forall {s : String.Slice} {pos : String.Slice.Pos s}, Eq.{1} String.Pos.Raw (String.Pos.offset (String.Slice.str s) (String.Slice.Pos.str s pos)) (String.Pos.Raw.offsetBy (String.Slice.Pos.offset s pos) (String.Pos.offset (String.Slice.str s) (String.Slice.startInclusive s)))

-- Stub: this file represents the declaration `String.Slice.Pos.offset_str`.
-- In a full split, the body would be extracted from the environment.
