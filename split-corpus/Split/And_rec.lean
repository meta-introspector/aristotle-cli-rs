import Mathlib

-- spec: recursor And.rec : forall {a : Prop} {b : Prop} {motive : (And a b) -> Sort.{u}}, (forall (left : a) (right : b), motive (And.intro a b left right)) -> (forall (t : And a b), motive t)
