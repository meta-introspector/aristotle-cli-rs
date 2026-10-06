import Mathlib

set_option pp.all true
-- spec: instDecidableFalse : Decidable False
def instDecidableFalse : Decidable False :=
  Decidable.isFalse False not_false
