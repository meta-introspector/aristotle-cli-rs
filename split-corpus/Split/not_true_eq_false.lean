import Mathlib

-- spec: theorem not_true_eq_false : Eq.{1} Prop (Not True) False
theorem not_true_eq_false : Eq.{1} Prop (Not True) False :=
  of_decide_eq_true (Eq.{1} Prop (Not True) False) (instDecidableEqOfIff (Not True) False (instDecidableIff (Not True) False (instDecidableNot True instDecidableTrue) instDecidableFalse)) (id.{0} (Eq.{1} Bool (Decidable.decide (Eq.{1} Prop (Not True) False) (instDecidableEqOfIff (Not True) False (instDecidableIff (Not True) False (instDecidableNot True instDecidableTrue) instDecidableFalse))) Bool.true) (Eq.refl.{1} Bool Bool.true))
