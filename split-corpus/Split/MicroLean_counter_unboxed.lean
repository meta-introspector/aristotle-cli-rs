import Mathlib

-- spec: theorem MicroLean.counter_unboxed : Eq.{1} Bool (MicroLean.isBoxed MicroLean.counterTerm) Bool.false
theorem MicroLean.counter_unboxed : Eq.{1} Bool (MicroLean.isBoxed MicroLean.counterTerm) Bool.false :=
  rfl.{1} Bool (MicroLean.isBoxed MicroLean.counterTerm)
