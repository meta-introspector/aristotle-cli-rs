import Mathlib

set_option pp.all true
-- spec: String.Slice.slice : forall (s : String.Slice) (newStart : String.Slice.Pos s) (newEnd : String.Slice.Pos s), (LE.le.{0} (String.Slice.Pos s) (String.instLEPos_1 s) newStart newEnd) -> String.Slice
def String.Slice.slice : forall (s : String.Slice) (newStart : String.Slice.Pos s) (newEnd : String.Slice.Pos s), (LE.le.{0} (String.Slice.Pos s) (String.instLEPos_1 s) newStart newEnd) -> String.Slice :=
  fun (s : String.Slice) (newStart : String.Slice.Pos s) (newEnd : String.Slice.Pos s) (h : LE.le.{0} (String.Slice.Pos s) (String.instLEPos_1 s) newStart newEnd) => String.Slice.mk (String.Slice.str s) (String.Slice.Pos.str s newStart) (String.Slice.Pos.str s newEnd) (String.Slice.slice._proof_1 s newStart newEnd h)
