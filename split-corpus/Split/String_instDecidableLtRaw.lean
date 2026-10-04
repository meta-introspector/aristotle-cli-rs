import Mathlib

set_option pp.all true
-- spec: String.instDecidableLtRaw : forall (p₁ : String.Pos.Raw) (p₂ : String.Pos.Raw), Decidable (LT.lt.{0} String.Pos.Raw String.instLTRaw p₁ p₂)
def String.instDecidableLtRaw : forall (p₁ : String.Pos.Raw) (p₂ : String.Pos.Raw), Decidable (LT.lt.{0} String.Pos.Raw String.instLTRaw p₁ p₂) :=
  fun (p₁ : String.Pos.Raw) (p₂ : String.Pos.Raw) => String.instDecidableLtRaw._aux_1 p₁ p₂
