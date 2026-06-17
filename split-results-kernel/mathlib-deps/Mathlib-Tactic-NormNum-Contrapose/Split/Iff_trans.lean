import Mathlib

-- spec: theorem Iff.trans : forall {a : Prop} {b : Prop} {c : Prop}, (Iff a b) -> (Iff b c) -> (Iff a c)
theorem Iff.trans : forall {a : Prop} {b : Prop} {c : Prop}, (Iff a b) -> (Iff b c) -> (Iff a c) :=
  fun {a : Prop} {b : Prop} {c : Prop} (h₁ : Iff a b) (h₂ : Iff b c) => Iff.intro a c (Function.comp.{0, 0, 0} a b c (Iff.mp b c h₂) (Iff.mp a b h₁)) (Function.comp.{0, 0, 0} c b a (Iff.mpr a b h₁) (Iff.mpr b c h₂))
