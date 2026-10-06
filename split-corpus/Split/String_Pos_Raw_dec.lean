import Mathlib

set_option pp.all true
-- spec: String.Pos.Raw.dec : String.Pos.Raw -> String.Pos.Raw
def String.Pos.Raw.dec : String.Pos.Raw -> String.Pos.Raw :=
  fun (p : String.Pos.Raw) => String.Pos.Raw.mk (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (String.Pos.Raw.byteIdx p) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))
