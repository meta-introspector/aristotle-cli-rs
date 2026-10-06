import Mathlib

set_option pp.all true
-- spec: String.instHSubRaw : HSub.{0, 0, 0} String.Pos.Raw String String.Pos.Raw
def String.instHSubRaw : HSub.{0, 0, 0} String.Pos.Raw String String.Pos.Raw :=
  HSub.mk.{0, 0, 0} String.Pos.Raw String String.Pos.Raw (fun (p : String.Pos.Raw) (s : String) => String.Pos.Raw.mk (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (String.Pos.Raw.byteIdx p) (String.utf8ByteSize s)))
