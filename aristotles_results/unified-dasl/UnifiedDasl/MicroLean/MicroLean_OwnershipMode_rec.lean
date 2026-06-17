import Mathlib

-- spec: recursor MicroLean.OwnershipMode.rec : forall {motive : MicroLean.OwnershipMode -> Sort.{u}}, (motive MicroLean.OwnershipMode.borrowed) -> (motive MicroLean.OwnershipMode.owned) -> (forall (t : MicroLean.OwnershipMode), motive t)
