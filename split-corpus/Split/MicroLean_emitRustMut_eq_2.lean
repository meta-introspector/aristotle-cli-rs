import Mathlib

-- spec: theorem MicroLean.emitRustMut.eq_2 : forall (t : MicroLean.MicroLeanType), Eq.{1} String (MicroLean.emitRustMut (MicroLean.MutLinearType.qualified MicroLean.MutMode.mutBorrow t)) (HAppend.hAppend.{0, 0, 0} String String String (instHAppendOfAppend.{0} String instAppendString) (ToString.toString.{0} String instToStringString "&mut ") (ToString.toString.{0} String instToStringString (MicroLean.emitRust t)))
theorem MicroLean.emitRustMut.eq_2 : forall (t : MicroLean.MicroLeanType), Eq.{1} String (MicroLean.emitRustMut (MicroLean.MutLinearType.qualified MicroLean.MutMode.mutBorrow t)) (HAppend.hAppend.{0, 0, 0} String String String (instHAppendOfAppend.{0} String instAppendString) (ToString.toString.{0} String instToStringString "&mut ") (ToString.toString.{0} String instToStringString (MicroLean.emitRust t))) :=
  fun (t : MicroLean.MicroLeanType) => Eq.refl.{1} String (MicroLean.emitRustMut (MicroLean.MutLinearType.qualified MicroLean.MutMode.mutBorrow t))
