import Mathlib

set_option pp.all true
-- spec: MicroLean.MicroLeanType.brecOn : forall {motive : MicroLean.MicroLeanType -> Sort.{u}} (t : MicroLean.MicroLeanType), (forall (t : MicroLean.MicroLeanType), (MicroLean.MicroLeanType.below.{u} motive t) -> (motive t)) -> (motive t)
def MicroLean.MicroLeanType.brecOn : forall {motive : MicroLean.MicroLeanType -> Sort.{u}} (t : MicroLean.MicroLeanType), (forall (t : MicroLean.MicroLeanType), (MicroLean.MicroLeanType.below.{u} motive t) -> (motive t)) -> (motive t) :=
  fun {motive : MicroLean.MicroLeanType -> Sort.{u}} (t : MicroLean.MicroLeanType) (F_1 : forall (t : MicroLean.MicroLeanType), (MicroLean.MicroLeanType.below.{u} motive t) -> (motive t)) => (MicroLean.MicroLeanType.brecOn.go.{u} motive t F_1).1
