import Mathlib

set_option pp.all true
-- spec: String.Pos.Raw.byteIdx : String.Pos.Raw -> Nat
def String.Pos.Raw.byteIdx : String.Pos.Raw -> Nat :=
  fun (self : String.Pos.Raw) => self.1
