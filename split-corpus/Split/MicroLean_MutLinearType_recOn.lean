import Mathlib

set_option pp.all true
-- spec: MicroLean.MutLinearType.recOn : forall {motive : MicroLean.MutLinearType -> Sort.{u}} (t : MicroLean.MutLinearType), (forall (mode : MicroLean.MutMode) (type : MicroLean.MicroLeanType), motive (MicroLean.MutLinearType.qualified mode type)) -> (motive t)
def MicroLean.MutLinearType.recOn : forall {motive : MicroLean.MutLinearType -> Sort.{u}} (t : MicroLean.MutLinearType), (forall (mode : MicroLean.MutMode) (type : MicroLean.MicroLeanType), motive (MicroLean.MutLinearType.qualified mode type)) -> (motive t) :=
  fun {motive : MicroLean.MutLinearType -> Sort.{u}} (t : MicroLean.MutLinearType) (qualified : forall (mode : MicroLean.MutMode) (type : MicroLean.MicroLeanType), motive (MicroLean.MutLinearType.qualified mode type)) => MicroLean.MutLinearType.rec.{u} motive qualified t
