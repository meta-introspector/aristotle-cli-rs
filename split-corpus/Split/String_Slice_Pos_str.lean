import Mathlib

set_option pp.all true
-- spec: String.Slice.Pos.str : forall {s : String.Slice}, (String.Slice.Pos s) -> (String.Pos (String.Slice.str s))
def String.Slice.Pos.str : forall {s : String.Slice}, (String.Slice.Pos s) -> (String.Pos (String.Slice.str s)) :=
  fun {s : String.Slice} (pos : String.Slice.Pos s) => String.Pos.mk (String.Slice.str s) (String.Pos.Raw.offsetBy (String.Slice.Pos.offset s pos) (String.Pos.offset (String.Slice.str s) (String.Slice.startInclusive s))) (_private.Init.Data.String.Basic.0.String.Slice.Pos.str._proof_1 s pos)
