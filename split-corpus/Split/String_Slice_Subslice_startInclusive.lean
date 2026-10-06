import Mathlib

set_option pp.all true
-- spec: String.Slice.Subslice.startInclusive : forall {s : String.Slice}, (String.Slice.Subslice s) -> (String.Slice.Pos s)
def String.Slice.Subslice.startInclusive : forall {s : String.Slice}, (String.Slice.Subslice s) -> (String.Slice.Pos s) :=
  fun (s : String.Slice) (self : String.Slice.Subslice s) => self.1
