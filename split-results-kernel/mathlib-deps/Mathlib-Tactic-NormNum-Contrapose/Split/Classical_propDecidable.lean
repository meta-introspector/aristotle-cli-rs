import Mathlib

set_option pp.all true
-- spec: Classical.propDecidable : forall (a : Prop), Decidable a
def Classical.propDecidable : forall (a : Prop), Decidable a :=
  fun (a : Prop) => Classical.choice.{1} (Decidable a) (Classical.propDecidable._proof_1 a)
