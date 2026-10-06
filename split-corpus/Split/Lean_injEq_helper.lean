import Mathlib

-- spec: theorem Lean.injEq_helper : forall {P : Prop} {Q : Prop} {R : Prop}, (P -> Q -> R) -> (And P Q) -> R
theorem Lean.injEq_helper : forall {P : Prop} {Q : Prop} {R : Prop}, (P -> Q -> R) -> (And P Q) -> R :=
  fun {P : Prop} {Q : Prop} {R : Prop} (h : P -> Q -> R) (h._@.Init.Core.1013481719._hygCtx._hyg.30 : And P Q) => _private.Init.Core.0.Lean.injEq_helper.match_1_1 P Q (fun (h._@.Init.Core.1013481719._hygCtx.30.Init.Core.1013481719._hygCtx._hyg.42 : And P Q) => [mdata noImplicitLambda:1 R]) h._@.Init.Core.1013481719._hygCtx._hyg.30 (fun (h₁ : P) (h₂ : Q) => h h₁ h₂)
