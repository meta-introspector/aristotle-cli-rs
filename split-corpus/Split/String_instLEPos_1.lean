import Mathlib

set_option pp.all true
-- spec: String.instLEPos_1 : forall {s : String.Slice}, LE.{0} (String.Slice.Pos s)
def String.instLEPos_1 : forall {s : String.Slice}, LE.{0} (String.Slice.Pos s) :=
  fun {s : String.Slice} => LE.mk.{0} (String.Slice.Pos s) (fun (l : String.Slice.Pos s) (r : String.Slice.Pos s) => LE.le.{0} String.Pos.Raw String.instLERaw (String.Slice.Pos.offset s l) (String.Slice.Pos.offset s r))
