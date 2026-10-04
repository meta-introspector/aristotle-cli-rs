import Mathlib

-- spec: theorem MicroLean.emitJs.eq_5 : forall (domain : MicroLean.MicroLeanType) (codomain : MicroLean.MicroLeanType), Eq.{1} String (MicroLean.emitJs (MicroLean.MicroLeanType.function domain codomain)) "'pointer'"
theorem MicroLean.emitJs.eq_5 : forall (domain : MicroLean.MicroLeanType) (codomain : MicroLean.MicroLeanType), Eq.{1} String (MicroLean.emitJs (MicroLean.MicroLeanType.function domain codomain)) "'pointer'" :=
  fun (domain : MicroLean.MicroLeanType) (codomain : MicroLean.MicroLeanType) => Eq.refl.{1} String (MicroLean.emitJs (MicroLean.MicroLeanType.function domain codomain))
