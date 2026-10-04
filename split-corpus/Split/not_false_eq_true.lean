import Mathlib

-- spec: theorem not_false_eq_true : Eq.{1} Prop (Not False) True
theorem not_false_eq_true : Eq.{1} Prop (Not False) True :=
  eq_true (Not False) (False.elim.{0} False)
