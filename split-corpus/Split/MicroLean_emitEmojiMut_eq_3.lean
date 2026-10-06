import Mathlib

-- spec: theorem MicroLean.emitEmojiMut.eq_3 : forall (t : MicroLean.MicroLeanType), Eq.{1} String (MicroLean.emitEmojiMut (MicroLean.MutLinearType.qualified MicroLean.MutMode.owned t)) (HAppend.hAppend.{0, 0, 0} String String String (instHAppendOfAppend.{0} String instAppendString) (ToString.toString.{0} String instToStringString "📦") (ToString.toString.{0} String instToStringString (MicroLean.emitEmoji t)))
theorem MicroLean.emitEmojiMut.eq_3 : forall (t : MicroLean.MicroLeanType), Eq.{1} String (MicroLean.emitEmojiMut (MicroLean.MutLinearType.qualified MicroLean.MutMode.owned t)) (HAppend.hAppend.{0, 0, 0} String String String (instHAppendOfAppend.{0} String instAppendString) (ToString.toString.{0} String instToStringString "📦") (ToString.toString.{0} String instToStringString (MicroLean.emitEmoji t))) :=
  fun (t : MicroLean.MicroLeanType) => Eq.refl.{1} String (MicroLean.emitEmojiMut (MicroLean.MutLinearType.qualified MicroLean.MutMode.owned t))
