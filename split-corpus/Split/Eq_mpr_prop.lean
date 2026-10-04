import Mathlib

-- spec: theorem Eq.mpr_prop : forall {p : Prop} {q : Prop}, (Eq.{1} Prop p q) -> q -> p
theorem Eq.mpr_prop : forall {p : Prop} {q : Prop}, (Eq.{1} Prop p q) -> q -> p :=
  fun {p : Prop} {q : Prop} (h₁ : Eq.{1} Prop p q) (h₂ : q) => Eq.rec.{0, 1} Prop q (fun (x._@.Init.SimpLemmas.544047425._hygCtx._hyg.14 : Prop) (h._@.Init.SimpLemmas.544047425._hygCtx._hyg.15 : Eq.{1} Prop q x._@.Init.SimpLemmas.544047425._hygCtx._hyg.14) => x._@.Init.SimpLemmas.544047425._hygCtx._hyg.14) h₂ p (Eq.symm.{1} Prop p q h₁)
