import Mathlib

-- spec: theorem MicroLean.emitEmoji.eq_2 : Eq.{1} String (MicroLean.emitEmoji MicroLean.MicroLeanType.bool) "🔘"
theorem MicroLean.emitEmoji.eq_2 : Eq.{1} String (MicroLean.emitEmoji MicroLean.MicroLeanType.bool) "🔘" :=
  Eq.refl.{1} String (MicroLean.emitEmoji MicroLean.MicroLeanType.bool)
