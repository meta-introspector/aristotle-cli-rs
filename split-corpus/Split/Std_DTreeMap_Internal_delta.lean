import Mathlib

set_option pp.all true
-- spec: Std.DTreeMap.Internal.delta : Nat
def Std.DTreeMap.Internal.delta : Nat :=
  OfNat.ofNat.{0} Nat 3 (instOfNatNat 3)
