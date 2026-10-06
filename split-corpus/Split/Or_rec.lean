import Mathlib

-- spec: recursor Or.rec : forall {a : Prop} {b : Prop} {motive : (Or a b) -> Prop}, (forall (h : a), motive (Or.inl a b h)) -> (forall (h : b), motive (Or.inr a b h)) -> (forall (t : Or a b), motive t)
