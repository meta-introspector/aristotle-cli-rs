import Mathlib

-- spec: recursor MicroLean.LinearMicroType.rec : forall {motive : MicroLean.LinearMicroType -> Sort.{u}}, (forall (mode : MicroLean.OwnershipMode) (type : MicroLean.MicroLeanType), motive (MicroLean.LinearMicroType.qualified mode type)) -> (forall (t : MicroLean.LinearMicroType), motive t)
