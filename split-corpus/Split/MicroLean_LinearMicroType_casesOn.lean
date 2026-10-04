import Mathlib

set_option pp.all true
-- spec: MicroLean.LinearMicroType.casesOn : forall {motive : MicroLean.LinearMicroType -> Sort.{u}} (t : MicroLean.LinearMicroType), (forall (mode : MicroLean.OwnershipMode) (type : MicroLean.MicroLeanType), motive (MicroLean.LinearMicroType.qualified mode type)) -> (motive t)
def MicroLean.LinearMicroType.casesOn : forall {motive : MicroLean.LinearMicroType -> Sort.{u}} (t : MicroLean.LinearMicroType), (forall (mode : MicroLean.OwnershipMode) (type : MicroLean.MicroLeanType), motive (MicroLean.LinearMicroType.qualified mode type)) -> (motive t) :=
  fun {motive : MicroLean.LinearMicroType -> Sort.{u}} (t : MicroLean.LinearMicroType) (qualified : forall (mode : MicroLean.OwnershipMode) (type : MicroLean.MicroLeanType), motive (MicroLean.LinearMicroType.qualified mode type)) => MicroLean.LinearMicroType.rec.{u} motive (fun (mode : MicroLean.OwnershipMode) (type : MicroLean.MicroLeanType) => qualified mode type) t
