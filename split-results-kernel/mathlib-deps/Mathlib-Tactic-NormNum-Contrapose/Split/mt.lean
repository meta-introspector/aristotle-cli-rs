import Mathlib

-- spec: theorem mt : forall {a : Prop} {b : Prop}, (a -> b) -> (Not b) -> (Not a)
theorem mt : forall {a : Prop} {b : Prop}, (a -> b) -> (Not b) -> (Not a) :=
  fun {a : Prop} {b : Prop} (h₁ : a -> b) (h₂ : Not b) (ha : a) => h₂ (h₁ ha)
