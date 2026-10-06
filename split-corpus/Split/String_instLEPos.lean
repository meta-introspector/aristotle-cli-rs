import Mathlib

set_option pp.all true
-- spec: String.instLEPos : forall {s : String}, LE.{0} (String.Pos s)
def String.instLEPos : forall {s : String}, LE.{0} (String.Pos s) :=
  fun {s : String} => LE.mk.{0} (String.Pos s) (fun (l : String.Pos s) (r : String.Pos s) => LE.le.{0} String.Pos.Raw String.instLERaw (String.Pos.offset s l) (String.Pos.offset s r))
