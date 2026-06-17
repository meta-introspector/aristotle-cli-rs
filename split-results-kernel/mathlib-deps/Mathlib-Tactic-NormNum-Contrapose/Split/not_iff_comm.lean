import Mathlib

-- spec: theorem not_iff_comm : forall {a : Prop} {b : Prop}, Iff (Iff (Not a) b) (Iff (Not b) a)
theorem not_iff_comm : forall {a : Prop} {b : Prop}, Iff (Iff (Not a) b) (Iff (Not b) a) :=
  fun {a : Prop} {b : Prop} => Decidable.not_iff_comm a b (Classical.propDecidable a) (Classical.propDecidable b)
