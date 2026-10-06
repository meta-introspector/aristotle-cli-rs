import Mathlib

set_option pp.all true
-- spec: Lean.reservedMacroScope : Nat
def Lean.reservedMacroScope : Nat :=
  OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)
