import Mathlib

-- spec: recursor Ordering.rec : forall {motive : Ordering -> Sort.{u}}, (motive Ordering.lt) -> (motive Ordering.eq) -> (motive Ordering.gt) -> (forall (t : Ordering), motive t)
