import Mathlib

set_option pp.all true
-- spec: Lean.ScopedEnvExtension.ext : forall {α : Type} {β : Type} {σ : Type}, (Lean.ScopedEnvExtension α β σ) -> (Lean.PersistentEnvExtension (Lean.ScopedEnvExtension.Entry α) (Lean.ScopedEnvExtension.Entry β) (Lean.ScopedEnvExtension.StateStack α β σ))
def Lean.ScopedEnvExtension.ext : forall {α : Type} {β : Type} {σ : Type}, (Lean.ScopedEnvExtension α β σ) -> (Lean.PersistentEnvExtension (Lean.ScopedEnvExtension.Entry α) (Lean.ScopedEnvExtension.Entry β) (Lean.ScopedEnvExtension.StateStack α β σ)) :=
  fun (α : Type) (β : Type) (σ : Type) (self : Lean.ScopedEnvExtension α β σ) => self.2
