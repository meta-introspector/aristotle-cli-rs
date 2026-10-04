import Mathlib

set_option pp.all true
-- spec: Std.DTreeMap.Internal.ratio : Nat
def Std.DTreeMap.Internal.ratio : Nat :=
  OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)
