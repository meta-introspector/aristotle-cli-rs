import Mathlib

-- spec: theorem Mathlib.Tactic.Contrapose.contrapose_iff₂ : forall {p : Prop} {q : Prop}, (Iff p (Not q)) -> (Iff (Not p) q)
theorem Mathlib.Tactic.Contrapose.contrapose_iff₂ : forall {p : Prop} {q : Prop}, (Iff p (Not q)) -> (Iff (Not p) q) :=
  fun {p : Prop} {q : Prop} => Iff.mp (Iff p (Not q)) (Iff (Not p) q) (Iff.trans (Iff p (Not q)) (Iff q (Not p)) (Iff (Not p) q) (iff_not_comm p q) (Iff.comm q (Not p)))
