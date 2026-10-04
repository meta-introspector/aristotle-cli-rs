import Mathlib

set_option pp.all true
-- spec: Lean.MessageData.nestD : Lean.MessageData -> Lean.MessageData
def Lean.MessageData.nestD : Lean.MessageData -> Lean.MessageData :=
  fun (msg : Lean.MessageData) => Lean.MessageData.nest (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) msg
