import Mathlib

set_option pp.all true
-- spec: String.instDecidableLePos_1 : forall {s : String.Slice} (l : String.Slice.Pos s) (r : String.Slice.Pos s), Decidable (LE.le.{0} (String.Slice.Pos s) (String.instLEPos_1 s) l r)
def String.instDecidableLePos_1 : forall {s : String.Slice} (l : String.Slice.Pos s) (r : String.Slice.Pos s), Decidable (LE.le.{0} (String.Slice.Pos s) (String.instLEPos_1 s) l r) :=
  fun {s : String.Slice} (l : String.Slice.Pos s) (r : String.Slice.Pos s) => decidable_of_iff' (LE.le.{0} (String.Slice.Pos s) (String.instLEPos_1 s) l r) (LE.le.{0} String.Pos.Raw String.instLERaw (String.Slice.Pos.offset s l) (String.Slice.Pos.offset s r)) (String.Slice.Pos.le_iff s l r) (String.instDecidableLeRaw (String.Slice.Pos.offset s l) (String.Slice.Pos.offset s r))
