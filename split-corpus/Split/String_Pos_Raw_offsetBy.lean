import Mathlib

set_option pp.all true
-- spec: String.Pos.Raw.offsetBy : String.Pos.Raw -> String.Pos.Raw -> String.Pos.Raw
def String.Pos.Raw.offsetBy : String.Pos.Raw -> String.Pos.Raw -> String.Pos.Raw :=
  fun (p : String.Pos.Raw) (offset : String.Pos.Raw) => String.Pos.Raw.mk (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (String.Pos.Raw.byteIdx offset) (String.Pos.Raw.byteIdx p))
