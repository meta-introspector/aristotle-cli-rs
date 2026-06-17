import Mathlib

-- spec: recursor Decidable.rec : forall {p : Prop} {motive : (Decidable p) -> Sort.{u}}, (forall (h : Not p), motive (Decidable.isFalse p h)) -> (forall (h : p), motive (Decidable.isTrue p h)) -> (forall (t : Decidable p), motive t)
