import Mathlib

-- spec: theorem implies_dep_congr_ctx : forall {p₁ : Prop} {p₂ : Prop} {q₁ : Prop}, (Eq.{1} Prop p₁ p₂) -> (forall {q₂ : p₂ -> Prop}, (forall (h : p₂), Eq.{1} Prop q₁ (q₂ h)) -> (Eq.{1} Prop (p₁ -> q₁) (forall (h : p₂), q₂ h)))
theorem implies_dep_congr_ctx : forall {p₁ : Prop} {p₂ : Prop} {q₁ : Prop}, (Eq.{1} Prop p₁ p₂) -> (forall {q₂ : p₂ -> Prop}, (forall (h : p₂), Eq.{1} Prop q₁ (q₂ h)) -> (Eq.{1} Prop (p₁ -> q₁) (forall (h : p₂), q₂ h))) :=
  fun {p₁ : Prop} {p₂ : Prop} {q₁ : Prop} (h₁ : Eq.{1} Prop p₁ p₂) {q₂ : p₂ -> Prop} (h₂ : forall (h : p₂), Eq.{1} Prop q₁ (q₂ h)) => propext (p₁ -> q₁) (forall (h : p₂), q₂ h) (Iff.intro (p₁ -> q₁) (forall (h : p₂), q₂ h) (fun (hl : p₁ -> q₁) (hp₂ : p₂) => Eq.mp.{0} q₁ (q₂ hp₂) (h₂ hp₂) (hl (Eq.mpr.{0} p₁ p₂ h₁ hp₂))) (fun (hr : forall (h : p₂), q₂ h) (hp₁ : p₁) => Eq.mpr.{0} q₁ (q₂ (Eq.mp.{0} p₁ p₂ h₁ hp₁)) (h₂ (Eq.mp.{0} p₁ p₂ h₁ hp₁)) (hr (Eq.mp.{0} p₁ p₂ h₁ hp₁))))
