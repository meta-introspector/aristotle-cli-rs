import Mathlib

set_option pp.all true
-- spec: String.Slice.subslice! : forall (s : String.Slice), (String.Slice.Pos s) -> (String.Slice.Pos s) -> (String.Slice.Subslice s)
def String.Slice.subslice! : forall (s : String.Slice), (String.Slice.Pos s) -> (String.Slice.Pos s) -> (String.Slice.Subslice s) :=
  fun (s : String.Slice) (newStart : String.Slice.Pos s) (newEnd : String.Slice.Pos s) => dite.{1} (String.Slice.Subslice s) (LE.le.{0} (String.Slice.Pos s) (String.instLEPos_1 s) newStart newEnd) (String.instDecidableLePos_1 s newStart newEnd) (fun (h : LE.le.{0} (String.Slice.Pos s) (String.instLEPos_1 s) newStart newEnd) => String.Slice.subslice s newStart newEnd h) (fun (h : Not (LE.le.{0} (String.Slice.Pos s) (String.instLEPos_1 s) newStart newEnd)) => panicWithPosWithDecl.{1} (String.Slice.Subslice s) (String.Slice.instInhabitedSubslice s) "Init.Data.String.Subslice" "String.Slice.subslice!" (OfNat.ofNat.{0} Nat 111 (instOfNatNat 111)) (OfNat.ofNat.{0} Nat 4 (instOfNatNat 4)) "Trying to construct a degenerate subslice")
