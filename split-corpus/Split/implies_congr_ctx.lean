import Mathlib

-- spec: theorem implies_congr_ctx : forall {p₁ : Prop} {p₂ : Prop} {q₁ : Prop} {q₂ : Prop}, (Eq.{1} Prop p₁ p₂) -> (p₂ -> (Eq.{1} Prop q₁ q₂)) -> (Eq.{1} Prop (p₁ -> q₁) (p₂ -> q₂))
theorem implies_congr_ctx : forall {p₁ : Prop} {p₂ : Prop} {q₁ : Prop} {q₂ : Prop}, (Eq.{1} Prop p₁ p₂) -> (p₂ -> (Eq.{1} Prop q₁ q₂)) -> (Eq.{1} Prop (p₁ -> q₁) (p₂ -> q₂)) :=
  fun {p₁ : Prop} {p₂ : Prop} {q₁ : Prop} {q₂ : Prop} (h₁ : Eq.{1} Prop p₁ p₂) (h₂ : p₂ -> (Eq.{1} Prop q₁ q₂)) => implies_dep_congr_ctx p₁ p₂ q₁ h₁ (fun (a._@._internal._hyg.0 : p₂) => q₂) h₂
