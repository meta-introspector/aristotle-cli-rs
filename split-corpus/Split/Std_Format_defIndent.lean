import Mathlib

set_option pp.all true
-- spec: Std.Format.defIndent : Nat
def Std.Format.defIndent : Nat :=
  OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)
