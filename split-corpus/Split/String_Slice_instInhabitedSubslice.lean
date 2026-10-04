import Mathlib

set_option pp.all true
-- spec: String.Slice.instInhabitedSubslice : forall {s : String.Slice}, Inhabited.{1} (String.Slice.Subslice s)
def String.Slice.instInhabitedSubslice : forall {s : String.Slice}, Inhabited.{1} (String.Slice.Subslice s) :=
  fun {s : String.Slice} => Inhabited.mk.{1} (String.Slice.Subslice s) (String.Slice.Subslice.mk s (String.Slice.endPos s) (String.Slice.endPos s) (String.Slice.instInhabitedSubslice._proof_1 s))
