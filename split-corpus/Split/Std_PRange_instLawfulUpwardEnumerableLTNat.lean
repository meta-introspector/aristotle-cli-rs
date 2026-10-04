import Mathlib

-- spec: theorem Std.PRange.instLawfulUpwardEnumerableLTNat : Std.PRange.LawfulUpwardEnumerableLT.{0} Nat Std.PRange.instUpwardEnumerableNat instLTNat
theorem Std.PRange.instLawfulUpwardEnumerableLTNat : Std.PRange.LawfulUpwardEnumerableLT.{0} Nat Std.PRange.instUpwardEnumerableNat instLTNat :=
  inferInstance.{0} (Std.PRange.LawfulUpwardEnumerableLT.{0} Nat Std.PRange.instUpwardEnumerableNat instLTNat) (Std.instLawfulUpwardEnumerableLTOfLawfulUpwardEnumerableOfLawfulUpwardEnumerableLEOfLawfulOrderLT.{0} Nat instLENat instLTNat Std.PRange.instUpwardEnumerableNat Std.PRange.instLawfulUpwardEnumerableNat Std.PRange.instLawfulUpwardEnumerableLENat Nat.instLawfulOrderLT)
