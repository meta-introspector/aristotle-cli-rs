import Mathlib

-- spec: recursor MicroLean.MutMode.rec : forall {motive : MicroLean.MutMode -> Sort.{u}}, (motive MicroLean.MutMode.borrowed) -> (motive MicroLean.MutMode.mutBorrow) -> (motive MicroLean.MutMode.owned) -> (forall (t : MicroLean.MutMode), motive t)
