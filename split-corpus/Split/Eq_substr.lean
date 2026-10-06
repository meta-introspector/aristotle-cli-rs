import Mathlib

-- spec: theorem Eq.substr : forall {α : Sort.{u}} {p : α -> Prop} {a : α} {b : α}, (Eq.{u} α b a) -> (p a) -> (p b)
theorem Eq.substr : forall {α : Sort.{u}} {p : α -> Prop} {a : α} {b : α}, (Eq.{u} α b a) -> (p a) -> (p b) :=
  fun {α : Sort.{u}} {p : α -> Prop} {a : α} {b : α} (h₁ : Eq.{u} α b a) (h₂ : p a) => Eq.rec.{0, u} α a (fun (x._@.Init.Core.3719311228._hygCtx._hyg.20 : α) (h._@.Init.Core.3719311228._hygCtx._hyg.21 : Eq.{u} α a x._@.Init.Core.3719311228._hygCtx._hyg.20) => p x._@.Init.Core.3719311228._hygCtx._hyg.20) h₂ b (Eq.symm.{u} α b a h₁)
