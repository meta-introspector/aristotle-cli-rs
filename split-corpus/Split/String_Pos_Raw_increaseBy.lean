import Mathlib

set_option pp.all true
-- spec: String.Pos.Raw.increaseBy : String.Pos.Raw -> Nat -> String.Pos.Raw
def String.Pos.Raw.increaseBy : String.Pos.Raw -> Nat -> String.Pos.Raw :=
  fun (p : String.Pos.Raw) (n : Nat) => String.Pos.Raw.mk (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (String.Pos.Raw.byteIdx p) n)
