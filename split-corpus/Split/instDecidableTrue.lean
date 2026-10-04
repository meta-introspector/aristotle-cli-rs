import Mathlib

set_option pp.all true
-- spec: instDecidableTrue : Decidable True
def instDecidableTrue : Decidable True :=
  Decidable.isTrue True trivial
