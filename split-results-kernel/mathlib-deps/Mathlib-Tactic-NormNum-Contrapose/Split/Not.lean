import Mathlib

set_option pp.all true
-- spec: Not : Prop -> Prop
def Not : Prop -> Prop :=
  fun (a : Prop) => a -> False
