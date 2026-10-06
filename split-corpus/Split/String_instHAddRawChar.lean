import Mathlib

set_option pp.all true
-- spec: String.instHAddRawChar : HAdd.{0, 0, 0} String.Pos.Raw Char String.Pos.Raw
def String.instHAddRawChar : HAdd.{0, 0, 0} String.Pos.Raw Char String.Pos.Raw :=
  HAdd.mk.{0, 0, 0} String.Pos.Raw Char String.Pos.Raw (fun (p : String.Pos.Raw) (c : Char) => String.Pos.Raw.mk (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (String.Pos.Raw.byteIdx p) (Char.utf8Size c)))
