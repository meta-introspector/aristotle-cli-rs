import Mathlib

set_option pp.all true
-- spec: String.Slice.sliceTo : forall (s : String.Slice), (String.Slice.Pos s) -> String.Slice
def String.Slice.sliceTo : forall (s : String.Slice), (String.Slice.Pos s) -> String.Slice :=
  fun (s : String.Slice) (pos : String.Slice.Pos s) => String.Slice.mk (String.Slice.str s) (String.Slice.startInclusive s) (String.Slice.Pos.str s pos) (String.Slice.sliceTo._proof_1 s pos)
