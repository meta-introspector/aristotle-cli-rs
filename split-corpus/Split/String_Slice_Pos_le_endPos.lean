import Mathlib

-- spec: theorem String.Slice.Pos.le_endPos : forall {s : String.Slice} (p : String.Slice.Pos s), LE.le.{0} (String.Slice.Pos s) (String.instLEPos_1 s) p (String.Slice.endPos s)
theorem String.Slice.Pos.le_endPos : forall {s : String.Slice} (p : String.Slice.Pos s), LE.le.{0} (String.Slice.Pos s) (String.instLEPos_1 s) p (String.Slice.endPos s) :=
  fun {s : String.Slice} (p : String.Slice.Pos s) => String.Pos.Raw.IsValidForSlice.le_rawEndPos s (String.Slice.Pos.offset s p) (String.Slice.Pos.isValidForSlice s p)
