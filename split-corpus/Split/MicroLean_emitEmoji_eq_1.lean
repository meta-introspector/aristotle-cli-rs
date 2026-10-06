import Mathlib

-- spec: theorem MicroLean.emitEmoji.eq_1 : Eq.{1} String (MicroLean.emitEmoji MicroLean.MicroLeanType.nat) "🔢"
theorem MicroLean.emitEmoji.eq_1 : Eq.{1} String (MicroLean.emitEmoji MicroLean.MicroLeanType.nat) "🔢" :=
  Eq.refl.{1} String (MicroLean.emitEmoji MicroLean.MicroLeanType.nat)
