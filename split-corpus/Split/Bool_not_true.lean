import Mathlib

-- spec: theorem Bool.not_true : Eq.{1} Bool (Bool.not Bool.true) Bool.false
theorem Bool.not_true : Eq.{1} Bool (Bool.not Bool.true) Bool.false :=
  of_decide_eq_true (Eq.{1} Bool (Bool.not Bool.true) Bool.false) (instDecidableEqBool (Bool.not Bool.true) Bool.false) (id.{0} (Eq.{1} Bool (Decidable.decide (Eq.{1} Bool (Bool.not Bool.true) Bool.false) (instDecidableEqBool (Bool.not Bool.true) Bool.false)) Bool.true) (Eq.refl.{1} Bool Bool.true))
