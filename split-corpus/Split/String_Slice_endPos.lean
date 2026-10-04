import Mathlib

set_option pp.all true
-- spec: String.Slice.endPos : forall (s : String.Slice), String.Slice.Pos s
def String.Slice.endPos : forall (s : String.Slice), String.Slice.Pos s :=
  fun (s : String.Slice) => String.Slice.Pos.mk s (String.Slice.rawEndPos s) (String.Pos.Raw.isValidForSlice_rawEndPos s)
