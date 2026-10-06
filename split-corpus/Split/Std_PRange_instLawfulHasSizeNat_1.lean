import Mathlib

-- spec: theorem Std.PRange.instLawfulHasSizeNat_1 : Std.Rxo.LawfulHasSize.{0} Nat instLTNat Std.PRange.instUpwardEnumerableNat Std.PRange.instHasSizeNat_1
theorem Std.PRange.instLawfulHasSizeNat_1 : Std.Rxo.LawfulHasSize.{0} Nat instLTNat Std.PRange.instUpwardEnumerableNat Std.PRange.instHasSizeNat_1 :=
  inferInstance.{0} (Std.Rxo.LawfulHasSize.{0} Nat instLTNat Std.PRange.instUpwardEnumerableNat Std.PRange.instHasSizeNat_1) (Std.Rxo.LawfulHasSize.of_closed.{0} Nat Std.PRange.instUpwardEnumerableNat instLENat Nat.decLe instLTNat Nat.decLt Nat.instLawfulOrderLT (Std.IsLinearOrder.toIsPartialOrder.{0} Nat instLENat Nat.instIsLinearOrder) Std.PRange.instLawfulUpwardEnumerableNat Std.PRange.instLawfulUpwardEnumerableLENat Std.PRange.instHasSizeNat Std.PRange.instLawfulHasSizeNat)
