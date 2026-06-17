import Mathlib

-- spec: theorem Mathlib.Tactic.Contrapose.contrapose_iff₃ : forall {p : Prop} {q : Prop}, (Iff (Not p) q) -> (Iff p (Not q))
theorem Mathlib.Tactic.Contrapose.contrapose_iff₃ : forall {p : Prop} {q : Prop}, (Iff (Not p) q) -> (Iff p (Not q)) :=
  fun {p : Prop} {q : Prop} => Iff.mp (Iff (Not p) q) (Iff p (Not q)) (Iff.trans (Iff (Not p) q) (Iff (Not q) p) (Iff p (Not q)) (not_iff_comm p q) (Iff.comm (Not q) p))
