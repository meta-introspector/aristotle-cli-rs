import Mathlib

-- spec: theorem MicroLean.callerInc.eq_2 : forall (type : MicroLean.MicroLeanType), Eq.{1} Int (MicroLean.callerInc (MicroLean.LinearMicroType.qualified MicroLean.OwnershipMode.borrowed type)) (OfNat.ofNat.{0} Int 0 (instOfNat 0))
theorem MicroLean.callerInc.eq_2 : forall (type : MicroLean.MicroLeanType), Eq.{1} Int (MicroLean.callerInc (MicroLean.LinearMicroType.qualified MicroLean.OwnershipMode.borrowed type)) (OfNat.ofNat.{0} Int 0 (instOfNat 0)) :=
  fun (type : MicroLean.MicroLeanType) => Eq.refl.{1} Int (MicroLean.callerInc (MicroLean.LinearMicroType.qualified MicroLean.OwnershipMode.borrowed type))
