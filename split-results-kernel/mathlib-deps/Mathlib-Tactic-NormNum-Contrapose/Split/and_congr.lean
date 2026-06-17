import Mathlib

-- spec: theorem and_congr : forall {a : Prop} {c : Prop} {b : Prop} {d : Prop}, (Iff a c) -> (Iff b d) -> (Iff (And a b) (And c d))
theorem and_congr : forall {a : Prop} {c : Prop} {b : Prop} {d : Prop}, (Iff a c) -> (Iff b d) -> (Iff (And a b) (And c d)) :=
  fun {a : Prop} {c : Prop} {b : Prop} {d : Prop} (h₁ : Iff a c) (h₂ : Iff b d) => Iff.intro (And a b) (And c d) (And.imp a c b d (Iff.mp a c h₁) (Iff.mp b d h₂)) (And.imp c a d b (Iff.mpr a c h₁) (Iff.mpr b d h₂))
