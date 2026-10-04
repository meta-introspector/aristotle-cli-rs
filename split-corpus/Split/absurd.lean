import Mathlib

set_option pp.all true
-- spec: absurd : forall {a : Prop} {b : Sort.{v}}, a -> (Not a) -> b
def absurd : forall {a : Prop} {b : Sort.{v}}, a -> (Not a) -> b :=
  fun {a : Prop} {b : Sort.{v}} (h₁ : a) (h₂ : Not a) => False.rec.{v} (fun (x._@.Init.Prelude.3867523658._hygCtx._hyg.13 : False) => b) (h₂ h₁)
