import Mathlib

-- spec: theorem MicroLean.refBalance.eq_1 : forall (lt : MicroLean.LinearMicroType), Eq.{1} Int (MicroLean.refBalance lt) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) (MicroLean.callerInc lt) (MicroLean.calleeDec lt))
theorem MicroLean.refBalance.eq_1 : forall (lt : MicroLean.LinearMicroType), Eq.{1} Int (MicroLean.refBalance lt) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) (MicroLean.callerInc lt) (MicroLean.calleeDec lt)) :=
  fun (lt : MicroLean.LinearMicroType) => Eq.refl.{1} Int (MicroLean.refBalance lt)
