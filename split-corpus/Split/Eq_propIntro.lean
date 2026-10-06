import Mathlib

-- spec: theorem Eq.propIntro : forall {a : Prop} {b : Prop}, (a -> b) -> (b -> a) -> (Eq.{1} Prop a b)
theorem Eq.propIntro : forall {a : Prop} {b : Prop}, (a -> b) -> (b -> a) -> (Eq.{1} Prop a b) :=
  fun {a : Prop} {b : Prop} (h₁ : a -> b) (h₂ : b -> a) => propext a b (Iff.intro a b h₁ h₂)
