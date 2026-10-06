import Mathlib

set_option pp.all true
-- spec: String.Slice.Pos.offset : forall {s : String.Slice}, (String.Slice.Pos s) -> String.Pos.Raw
def String.Slice.Pos.offset : forall {s : String.Slice}, (String.Slice.Pos s) -> String.Pos.Raw :=
  fun (s : String.Slice) (self : String.Slice.Pos s) => self.1
