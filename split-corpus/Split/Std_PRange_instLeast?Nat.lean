import Mathlib

set_option pp.all true
-- spec: Std.PRange.instLeast?Nat : Std.PRange.Least?.{0} Nat
def Std.PRange.instLeast?Nat : Std.PRange.Least?.{0} Nat :=
  Std.PRange.Least?.mk.{0} Nat (Option.some.{0} Nat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))
