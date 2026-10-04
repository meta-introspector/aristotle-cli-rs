import Mathlib

set_option pp.all true
-- spec: String.Slice.Pos.get : forall {s : String.Slice} (pos : String.Slice.Pos s), (Ne.{1} (String.Slice.Pos s) pos (String.Slice.endPos s)) -> Char
def String.Slice.Pos.get : forall {s : String.Slice} (pos : String.Slice.Pos s), (Ne.{1} (String.Slice.Pos s) pos (String.Slice.endPos s)) -> Char :=
  fun {s : String.Slice} (pos : String.Slice.Pos s) (h : Ne.{1} (String.Slice.Pos s) pos (String.Slice.endPos s)) => String.decodeChar (String.Slice.str s) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (String.Pos.Raw.byteIdx (String.Pos.offset (String.Slice.str s) (String.Slice.startInclusive s))) (String.Pos.Raw.byteIdx (String.Slice.Pos.offset s pos))) (String.Slice.Pos.get._proof_1 s pos h)
