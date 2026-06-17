import Mathlib

-- spec: theorem imp_not_comm : forall {a : Prop} {b : Prop}, Iff (a -> (Not b)) (b -> (Not a))
theorem imp_not_comm : forall {a : Prop} {b : Prop}, Iff (a -> (Not b)) (b -> (Not a)) :=
  fun {a : Prop} {b : Prop} => imp.swap a b False
