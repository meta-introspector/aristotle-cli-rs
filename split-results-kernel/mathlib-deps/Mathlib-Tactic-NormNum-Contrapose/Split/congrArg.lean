import Mathlib

-- spec: theorem congrArg : forall {α : Sort.{u}} {β : Sort.{v}} {a₁ : α} {a₂ : α} (f : α -> β), (Eq.{u} α a₁ a₂) -> (Eq.{v} β (f a₁) (f a₂))
theorem congrArg : forall {α : Sort.{u}} {β : Sort.{v}} {a₁ : α} {a₂ : α} (f : α -> β), (Eq.{u} α a₁ a₂) -> (Eq.{v} β (f a₁) (f a₂)) :=
  fun {α : Sort.{u}} {β : Sort.{v}} {a₁ : α} {a₂ : α} (f : α -> β) (h : Eq.{u} α a₁ a₂) => Eq.rec.{0, u} α a₁ (fun (x._@.Init.Prelude.2375064143._hygCtx._hyg.24 : α) (h._@.Init.Prelude.2375064143._hygCtx._hyg.25 : Eq.{u} α a₁ x._@.Init.Prelude.2375064143._hygCtx._hyg.24) => Eq.{v} β (f a₁) (f x._@.Init.Prelude.2375064143._hygCtx._hyg.24)) (rfl.{v} β (f a₁)) a₂ h
