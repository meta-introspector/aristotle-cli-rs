import Mathlib

-- spec: theorem MicroLean.mutRefBalance.eq_1 : forall (lt : MicroLean.MutLinearType), Eq.{1} Int (MicroLean.mutRefBalance lt) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) (MicroLean.mutCallerInc lt) (MicroLean.mutCalleeDec lt))
theorem MicroLean.mutRefBalance.eq_1 : forall (lt : MicroLean.MutLinearType), Eq.{1} Int (MicroLean.mutRefBalance lt) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) (MicroLean.mutCallerInc lt) (MicroLean.mutCalleeDec lt)) :=
  fun (lt : MicroLean.MutLinearType) => Eq.refl.{1} Int (MicroLean.mutRefBalance lt)
