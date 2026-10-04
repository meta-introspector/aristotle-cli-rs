import Mathlib

set_option pp.all true
-- spec: String.Slice.endExclusive : forall (self : String.Slice), String.Pos (String.Slice.str self)
def String.Slice.endExclusive : forall (self : String.Slice), String.Pos (String.Slice.str self) :=
  fun (self : String.Slice) => self.3
