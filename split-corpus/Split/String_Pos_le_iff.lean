import Mathlib

-- spec: theorem String.Pos.le_iff : forall {s : String} {l : String.Pos s} {r : String.Pos s}, Iff (LE.le.{0} (String.Pos s) (String.instLEPos s) l r) (LE.le.{0} String.Pos.Raw String.instLERaw (String.Pos.offset s l) (String.Pos.offset s r))
theorem String.Pos.le_iff : forall {s : String} {l : String.Pos s} {r : String.Pos s}, Iff (LE.le.{0} (String.Pos s) (String.instLEPos s) l r) (LE.le.{0} String.Pos.Raw String.instLERaw (String.Pos.offset s l) (String.Pos.offset s r)) :=
  fun {s : String} {l : String.Pos s} {r : String.Pos s} => Iff.rfl (LE.le.{0} (String.Pos s) (String.instLEPos s) l r)
