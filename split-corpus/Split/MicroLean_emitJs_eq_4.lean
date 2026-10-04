import Mathlib

-- spec: theorem MicroLean.emitJs.eq_4 : forall (fst : MicroLean.MicroLeanType) (snd : MicroLean.MicroLeanType), Eq.{1} String (MicroLean.emitJs (MicroLean.MicroLeanType.prod fst snd)) "'pointer'"
theorem MicroLean.emitJs.eq_4 : forall (fst : MicroLean.MicroLeanType) (snd : MicroLean.MicroLeanType), Eq.{1} String (MicroLean.emitJs (MicroLean.MicroLeanType.prod fst snd)) "'pointer'" :=
  fun (fst : MicroLean.MicroLeanType) (snd : MicroLean.MicroLeanType) => Eq.refl.{1} String (MicroLean.emitJs (MicroLean.MicroLeanType.prod fst snd))
