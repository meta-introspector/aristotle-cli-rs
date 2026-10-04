import Mathlib

-- spec: recursor MicroLean.MutLinearType.rec : forall {motive : MicroLean.MutLinearType -> Sort.{u}}, (forall (mode : MicroLean.MutMode) (type : MicroLean.MicroLeanType), motive (MicroLean.MutLinearType.qualified mode type)) -> (forall (t : MicroLean.MutLinearType), motive t)
