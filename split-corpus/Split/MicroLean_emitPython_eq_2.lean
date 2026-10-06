import Mathlib

-- spec: theorem MicroLean.emitPython.eq_2 : Eq.{1} String (MicroLean.emitPython MicroLean.MicroLeanType.bool) "ctypes.c_bool"
theorem MicroLean.emitPython.eq_2 : Eq.{1} String (MicroLean.emitPython MicroLean.MicroLeanType.bool) "ctypes.c_bool" :=
  Eq.refl.{1} String (MicroLean.emitPython MicroLean.MicroLeanType.bool)
