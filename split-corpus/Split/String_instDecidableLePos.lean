import Mathlib

set_option pp.all true
-- spec: String.instDecidableLePos : forall {s : String} (l : String.Pos s) (r : String.Pos s), Decidable (LE.le.{0} (String.Pos s) (String.instLEPos s) l r)
def String.instDecidableLePos : forall {s : String} (l : String.Pos s) (r : String.Pos s), Decidable (LE.le.{0} (String.Pos s) (String.instLEPos s) l r) :=
  fun {s : String} (l : String.Pos s) (r : String.Pos s) => decidable_of_iff' (LE.le.{0} (String.Pos s) (String.instLEPos s) l r) (LE.le.{0} String.Pos.Raw String.instLERaw (String.Pos.offset s l) (String.Pos.offset s r)) (String.Pos.le_iff s l r) (String.instDecidableLeRaw (String.Pos.offset s l) (String.Pos.offset s r))
