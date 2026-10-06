import Mathlib

set_option pp.all true
-- spec: String.Slice.Subslice.toSlice : forall {s : String.Slice}, (String.Slice.Subslice s) -> String.Slice
def String.Slice.Subslice.toSlice : forall {s : String.Slice}, (String.Slice.Subslice s) -> String.Slice :=
  fun {s : String.Slice} (sl : String.Slice.Subslice s) => String.Slice.slice s (String.Slice.Subslice.startInclusive s sl) (String.Slice.Subslice.endExclusive s sl) (String.Slice.Subslice.startInclusive_le_endExclusive s sl)
