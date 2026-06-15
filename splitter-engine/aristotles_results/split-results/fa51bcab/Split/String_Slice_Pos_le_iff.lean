import Split.String_instLEPos_1
import Split.String_Slice_Pos_offset
import Split.Iff_rfl
import Split.String_Slice
import Split.LE_le
import Split.String_Pos_Raw
import Split.Iff
import Split.String_instLERaw
import Split.String_Slice_Pos

-- String.Slice.Pos.le_iff from environment
-- theorem String.Slice.Pos.le_iff : forall {s : String.Slice} {l : String.Slice.Pos s} {r : String.Slice.Pos s}, Iff (LE.le.{0} (String.Slice.Pos s) (String.instLEPos_1 s) l r) (LE.le.{0} String.Pos.Raw String.instLERaw (String.Slice.Pos.offset s l) (String.Slice.Pos.offset s r))

-- Stub: this file represents the declaration `String.Slice.Pos.le_iff`.
-- In a full split, the body would be extracted from the environment.
