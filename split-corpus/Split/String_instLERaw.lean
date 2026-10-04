import Mathlib

set_option pp.all true
-- spec: String.instLERaw : LE.{0} String.Pos.Raw
def String.instLERaw : LE.{0} String.Pos.Raw :=
  LE.mk.{0} String.Pos.Raw (fun (p₁ : String.Pos.Raw) (p₂ : String.Pos.Raw) => LE.le.{0} Nat instLENat (String.Pos.Raw.byteIdx p₁) (String.Pos.Raw.byteIdx p₂))
