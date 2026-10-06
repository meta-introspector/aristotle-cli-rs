import Mathlib

set_option pp.all true
-- spec: String.instLTRaw : LT.{0} String.Pos.Raw
def String.instLTRaw : LT.{0} String.Pos.Raw :=
  LT.mk.{0} String.Pos.Raw (fun (p₁ : String.Pos.Raw) (p₂ : String.Pos.Raw) => LT.lt.{0} Nat instLTNat (String.Pos.Raw.byteIdx p₁) (String.Pos.Raw.byteIdx p₂))
