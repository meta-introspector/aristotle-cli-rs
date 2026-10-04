import Mathlib

-- spec: theorem MicroLean.MutMode.allowsMutation.eq_1 : Eq.{1} Bool (MicroLean.MutMode.allowsMutation MicroLean.MutMode.mutBorrow) Bool.true
theorem MicroLean.MutMode.allowsMutation.eq_1 : Eq.{1} Bool (MicroLean.MutMode.allowsMutation MicroLean.MutMode.mutBorrow) Bool.true :=
  Eq.refl.{1} Bool (MicroLean.MutMode.allowsMutation MicroLean.MutMode.mutBorrow)
