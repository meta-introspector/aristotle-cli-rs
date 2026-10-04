import Mathlib

set_option pp.all true
-- spec: String.Pos.Raw.byteDistance : String.Pos.Raw -> String.Pos.Raw -> Nat
def String.Pos.Raw.byteDistance : String.Pos.Raw -> String.Pos.Raw -> Nat :=
  fun (lo : String.Pos.Raw) (hi : String.Pos.Raw) => HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (String.Pos.Raw.byteIdx hi) (String.Pos.Raw.byteIdx lo)
