import Mathlib

-- spec: theorem MicroLean.emitPython.eq_1 : Eq.{1} String (MicroLean.emitPython MicroLean.MicroLeanType.nat) "ctypes.c_void_p"
theorem MicroLean.emitPython.eq_1 : Eq.{1} String (MicroLean.emitPython MicroLean.MicroLeanType.nat) "ctypes.c_void_p" :=
  Eq.refl.{1} String (MicroLean.emitPython MicroLean.MicroLeanType.nat)
