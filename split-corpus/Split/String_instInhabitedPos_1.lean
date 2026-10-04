import Mathlib

set_option pp.all true
-- spec: String.instInhabitedPos_1 : forall {s : String.Slice}, Inhabited.{1} (String.Slice.Pos s)
def String.instInhabitedPos_1 : forall {s : String.Slice}, Inhabited.{1} (String.Slice.Pos s) :=
  fun {s : String.Slice} => Inhabited.mk.{1} (String.Slice.Pos s) (String.Slice.startPos s)
