import Mathlib

-- spec: theorem Eq.trans : forall {α : Sort.{u}} {a : α} {b : α} {c : α}, (Eq.{u} α a b) -> (Eq.{u} α b c) -> (Eq.{u} α a c)
theorem Eq.trans : forall {α : Sort.{u}} {a : α} {b : α} {c : α}, (Eq.{u} α a b) -> (Eq.{u} α b c) -> (Eq.{u} α a c) :=
  fun {α : Sort.{u}} {a : α} {b : α} {c : α} (h₁ : Eq.{u} α a b) (h₂ : Eq.{u} α b c) => Eq.rec.{0, u} α b (fun (x._@.Init.Prelude.4164849530._hygCtx._hyg.18 : α) (h._@.Init.Prelude.4164849530._hygCtx._hyg.19 : Eq.{u} α b x._@.Init.Prelude.4164849530._hygCtx._hyg.18) => Eq.{u} α a x._@.Init.Prelude.4164849530._hygCtx._hyg.18) h₁ c h₂
