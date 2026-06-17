import Mathlib

-- spec: axiom propext : forall {a : Prop} {b : Prop}, (Iff a b) -> (Eq.{1} Prop a b)
axiom propext : forall {a : Prop} {b : Prop}, (Iff a b) -> (Eq.{1} Prop a b)
