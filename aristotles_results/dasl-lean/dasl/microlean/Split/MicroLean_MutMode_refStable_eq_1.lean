import Mathlib

-- spec: theorem MicroLean.MutMode.refStable.eq_1 : Eq.{1} Bool (MicroLean.MutMode.refStable MicroLean.MutMode.owned) Bool.false
theorem MicroLean.MutMode.refStable.eq_1 : Eq.{1} Bool (MicroLean.MutMode.refStable MicroLean.MutMode.owned) Bool.false :=
  Eq.refl.{1} Bool (MicroLean.MutMode.refStable MicroLean.MutMode.owned)
