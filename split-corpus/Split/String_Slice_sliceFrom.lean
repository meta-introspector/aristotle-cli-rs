import Mathlib

set_option pp.all true
-- spec: String.Slice.sliceFrom : forall (s : String.Slice), (String.Slice.Pos s) -> String.Slice
def String.Slice.sliceFrom : forall (s : String.Slice), (String.Slice.Pos s) -> String.Slice :=
  fun (s : String.Slice) (pos : String.Slice.Pos s) => String.Slice.mk (String.Slice.str s) (String.Slice.Pos.str s pos) (String.Slice.endExclusive s) (String.Slice.Pos.offset_str_le_offset_endExclusive s pos)
