import Mathlib

-- spec: theorem String.Slice.Pos.le_iff : forall {s : String.Slice} {l : String.Slice.Pos s} {r : String.Slice.Pos s}, Iff (LE.le.{0} (String.Slice.Pos s) (String.instLEPos_1 s) l r) (LE.le.{0} String.Pos.Raw String.instLERaw (String.Slice.Pos.offset s l) (String.Slice.Pos.offset s r))
theorem String.Slice.Pos.le_iff : forall {s : String.Slice} {l : String.Slice.Pos s} {r : String.Slice.Pos s}, Iff (LE.le.{0} (String.Slice.Pos s) (String.instLEPos_1 s) l r) (LE.le.{0} String.Pos.Raw String.instLERaw (String.Slice.Pos.offset s l) (String.Slice.Pos.offset s r)) :=
  fun {s : String.Slice} {l : String.Slice.Pos s} {r : String.Slice.Pos s} => Iff.rfl (LE.le.{0} (String.Slice.Pos s) (String.instLEPos_1 s) l r)
