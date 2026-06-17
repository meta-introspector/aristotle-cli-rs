import Mathlib

-- spec: theorem not_iff_not : forall {a : Prop} {b : Prop}, Iff (Iff (Not a) (Not b)) (Iff a b)
theorem not_iff_not : forall {a : Prop} {b : Prop}, Iff (Iff (Not a) (Not b)) (Iff a b) :=
  fun {a : Prop} {b : Prop} => Decidable.not_iff_not a b (Classical.propDecidable a) (Classical.propDecidable b)
