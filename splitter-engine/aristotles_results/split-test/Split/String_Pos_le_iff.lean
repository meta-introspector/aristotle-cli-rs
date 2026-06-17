import Split.String
import Split.Iff_rfl
import Split.LE_le
import Split.String_Pos_Raw
import Split.Iff
import Split.String_instLERaw
import Split.String_Pos
import Split.String_instLEPos
import Split.String_Pos_offset

-- String.Pos.le_iff from environment
-- theorem String.Pos.le_iff : forall {s : String} {l : String.Pos s} {r : String.Pos s}, Iff (LE.le.{0} (String.Pos s) (String.instLEPos s) l r) (LE.le.{0} String.Pos.Raw String.instLERaw (String.Pos.offset s l) (String.Pos.offset s r))

-- Stub: this file represents the declaration `String.Pos.le_iff`.
-- In a full split, the body would be extracted from the environment.
