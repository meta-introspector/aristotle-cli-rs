import Mathlib

set_option pp.all true
-- spec: Std.PRange.instHasSizeNat_1 : Std.Rxo.HasSize.{0} Nat
def Std.PRange.instHasSizeNat_1 : Std.Rxo.HasSize.{0} Nat :=
  Std.Rxo.HasSize.ofClosed.{0} Nat Std.PRange.instHasSizeNat
