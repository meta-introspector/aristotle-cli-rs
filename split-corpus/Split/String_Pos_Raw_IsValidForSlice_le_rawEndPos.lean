import Mathlib

-- spec: theorem String.Pos.Raw.IsValidForSlice.le_rawEndPos : forall {s : String.Slice} {p : String.Pos.Raw}, (String.Pos.Raw.IsValidForSlice s p) -> (LE.le.{0} String.Pos.Raw String.instLERaw p (String.Slice.rawEndPos s))
theorem String.Pos.Raw.IsValidForSlice.le_rawEndPos : forall {s : String.Slice} {p : String.Pos.Raw}, (String.Pos.Raw.IsValidForSlice s p) -> (LE.le.{0} String.Pos.Raw String.instLERaw p (String.Slice.rawEndPos s)) :=
  fun (s : String.Slice) (p : String.Pos.Raw) (self : String.Pos.Raw.IsValidForSlice s p) => self.1
