import Mathlib

set_option pp.all true
-- spec: String.Pos.offset : forall {s : String}, (String.Pos s) -> String.Pos.Raw
def String.Pos.offset : forall {s : String}, (String.Pos s) -> String.Pos.Raw :=
  fun (s : String) (self : String.Pos s) => self.1
