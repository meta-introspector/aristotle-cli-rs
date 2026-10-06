import Mathlib

-- spec: theorem Classical.or_iff_not_imp_left : forall {a : Prop} {b : Prop}, Iff (Or a b) ((Not a) -> b)
theorem Classical.or_iff_not_imp_left : forall {a : Prop} {b : Prop}, Iff (Or a b) ((Not a) -> b) :=
  fun {a : Prop} {b : Prop} => Decidable.or_iff_not_imp_left a b (Classical.propDecidable a)
