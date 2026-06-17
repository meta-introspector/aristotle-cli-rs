import Mathlib

-- spec: theorem iff_not_comm : forall {a : Prop} {b : Prop}, Iff (Iff a (Not b)) (Iff b (Not a))
theorem iff_not_comm : forall {a : Prop} {b : Prop}, Iff (Iff a (Not b)) (Iff b (Not a)) :=
  fun {a : Prop} {b : Prop} => Decidable.iff_not_comm a b (Classical.propDecidable a) (Classical.propDecidable b)
