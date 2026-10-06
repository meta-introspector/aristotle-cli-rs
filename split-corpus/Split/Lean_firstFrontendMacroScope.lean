import Mathlib

set_option pp.all true
-- spec: Lean.firstFrontendMacroScope : Nat
def Lean.firstFrontendMacroScope : Nat :=
  HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) Lean.reservedMacroScope (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))
