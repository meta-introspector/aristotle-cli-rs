import Mathlib

-- spec: theorem Eq.mpr_not : forall {p : Prop} {q : Prop}, (Eq.{1} Prop p q) -> (Not q) -> (Not p)
theorem Eq.mpr_not : forall {p : Prop} {q : Prop}, (Eq.{1} Prop p q) -> (Not q) -> (Not p) :=
  fun {p : Prop} {q : Prop} (h₁ : Eq.{1} Prop p q) (h₂ : Not q) => Eq.rec.{0, 1} Prop q (fun (x._@.Init.SimpLemmas.3231060952._hygCtx._hyg.20 : Prop) (h._@.Init.SimpLemmas.3231060952._hygCtx._hyg.21 : Eq.{1} Prop q x._@.Init.SimpLemmas.3231060952._hygCtx._hyg.20) => Not x._@.Init.SimpLemmas.3231060952._hygCtx._hyg.20) h₂ p (Eq.symm.{1} Prop p q h₁)
