import Mathlib

set_option pp.all true
-- spec: String.Slice.Pos.byte : forall {s : String.Slice} (pos : String.Slice.Pos s), (Ne.{1} (String.Slice.Pos s) pos (String.Slice.endPos s)) -> UInt8
def String.Slice.Pos.byte : forall {s : String.Slice} (pos : String.Slice.Pos s), (Ne.{1} (String.Slice.Pos s) pos (String.Slice.endPos s)) -> UInt8 :=
  fun {s : String.Slice} (pos : String.Slice.Pos s) (h : Ne.{1} (String.Slice.Pos s) pos (String.Slice.endPos s)) => String.Slice.getUTF8Byte s (String.Slice.Pos.offset s pos) (String.Slice.Pos.byte._proof_4 s pos h)
