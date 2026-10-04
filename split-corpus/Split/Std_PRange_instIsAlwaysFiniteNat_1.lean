import Mathlib

-- spec: theorem Std.PRange.instIsAlwaysFiniteNat_1 : Std.Rxo.IsAlwaysFinite.{0} Nat Std.PRange.instUpwardEnumerableNat instLTNat
theorem Std.PRange.instIsAlwaysFiniteNat_1 : Std.Rxo.IsAlwaysFinite.{0} Nat Std.PRange.instUpwardEnumerableNat instLTNat :=
  inferInstance.{0} (Std.Rxo.IsAlwaysFinite.{0} Nat Std.PRange.instUpwardEnumerableNat instLTNat) (Std.Rxo.instIsAlwaysFiniteOfLawfulHasSize.{0} Nat instLTNat Std.PRange.instUpwardEnumerableNat Std.PRange.instLawfulUpwardEnumerableNat Std.PRange.instHasSizeNat_1 Std.PRange.instLawfulHasSizeNat_1)
