import Mathlib

set_option pp.all true
-- spec: String.Slice.Pos.next : forall {s : String.Slice} (pos : String.Slice.Pos s), (Ne.{1} (String.Slice.Pos s) pos (String.Slice.endPos s)) -> (String.Slice.Pos s)
def String.Slice.Pos.next : forall {s : String.Slice} (pos : String.Slice.Pos s), (Ne.{1} (String.Slice.Pos s) pos (String.Slice.endPos s)) -> (String.Slice.Pos s) :=
  fun {s : String.Slice} (pos : String.Slice.Pos s) (h : Ne.{1} (String.Slice.Pos s) pos (String.Slice.endPos s)) => String.Slice.Pos.mk s (String.Pos.Raw.increaseBy (String.Slice.Pos.offset s pos) (UInt8.utf8ByteSize (String.Slice.Pos.byte s pos h) (String.Slice.Pos.isUTF8FirstByte_byte s pos h))) (String.Slice.Pos.next._proof_1 s pos h)
