import Mathlib

-- spec: theorem MicroLean.emitJs.eq_3 : forall (elem : MicroLean.MicroLeanType), Eq.{1} String (MicroLean.emitJs (MicroLean.MicroLeanType.array elem)) "'pointer'"
theorem MicroLean.emitJs.eq_3 : forall (elem : MicroLean.MicroLeanType), Eq.{1} String (MicroLean.emitJs (MicroLean.MicroLeanType.array elem)) "'pointer'" :=
  fun (elem : MicroLean.MicroLeanType) => Eq.refl.{1} String (MicroLean.emitJs (MicroLean.MicroLeanType.array elem))
