import Mathlib

set_option pp.all true
-- spec: String.Slice.subsliceFrom : forall (s : String.Slice), (String.Slice.Pos s) -> (String.Slice.Subslice s)
def String.Slice.subsliceFrom : forall (s : String.Slice), (String.Slice.Pos s) -> (String.Slice.Subslice s) :=
  fun (s : String.Slice) (newStart : String.Slice.Pos s) => String.Slice.subslice s newStart (String.Slice.endPos s) (String.Slice.Pos.le_endPos s newStart)
