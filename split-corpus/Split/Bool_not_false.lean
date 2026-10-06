import Mathlib

-- spec: theorem Bool.not_false : Eq.{1} Bool (Bool.not Bool.false) Bool.true
theorem Bool.not_false : Eq.{1} Bool (Bool.not Bool.false) Bool.true :=
  of_decide_eq_true (Eq.{1} Bool (Bool.not Bool.false) Bool.true) (instDecidableEqBool (Bool.not Bool.false) Bool.true) (id.{0} (Eq.{1} Bool (Decidable.decide (Eq.{1} Bool (Bool.not Bool.false) Bool.true) (instDecidableEqBool (Bool.not Bool.false) Bool.true)) Bool.true) (Eq.refl.{1} Bool Bool.true))
