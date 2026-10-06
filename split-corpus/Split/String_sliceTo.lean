import Mathlib

set_option pp.all true
-- spec: String.sliceTo : forall (s : String), (String.Pos s) -> String.Slice
def String.sliceTo : forall (s : String), (String.Pos s) -> String.Slice :=
  fun (s : String) (p : String.Pos s) => String.Slice.sliceTo (String.toSlice s) (String.Pos.toSlice s p)
