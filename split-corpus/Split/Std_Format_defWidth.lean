import Mathlib

set_option pp.all true
-- spec: Std.Format.defWidth : Nat
def Std.Format.defWidth : Nat :=
  OfNat.ofNat.{0} Nat 120 (instOfNatNat 120)
