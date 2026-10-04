import Mathlib

-- spec: theorem MicroLean.isBoxed.eq_1 : Eq.{1} Bool (MicroLean.isBoxed MicroLean.MicroLeanType.bool) Bool.false
theorem MicroLean.isBoxed.eq_1 : Eq.{1} Bool (MicroLean.isBoxed MicroLean.MicroLeanType.bool) Bool.false :=
  Eq.refl.{1} Bool (MicroLean.isBoxed MicroLean.MicroLeanType.bool)
