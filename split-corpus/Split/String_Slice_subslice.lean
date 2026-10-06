import Mathlib

set_option pp.all true
-- spec: String.Slice.subslice : forall (s : String.Slice) (newStart : String.Slice.Pos s) (newEnd : String.Slice.Pos s), (LE.le.{0} (String.Slice.Pos s) (String.instLEPos_1 s) newStart newEnd) -> (String.Slice.Subslice s)
def String.Slice.subslice : forall (s : String.Slice) (newStart : String.Slice.Pos s) (newEnd : String.Slice.Pos s), (LE.le.{0} (String.Slice.Pos s) (String.instLEPos_1 s) newStart newEnd) -> (String.Slice.Subslice s) :=
  fun (s : String.Slice) (newStart : String.Slice.Pos s) (newEnd : String.Slice.Pos s) (h : LE.le.{0} (String.Slice.Pos s) (String.instLEPos_1 s) newStart newEnd) => String.Slice.Subslice.mk s newStart newEnd h
