import Mathlib

set_option pp.all true
-- spec: Lean.PersistentEnvExtension.toEnvExtension : forall {α : Type} {β : Type} {σ : Type}, (Lean.PersistentEnvExtension α β σ) -> (Lean.EnvExtension (Lean.PersistentEnvExtensionState α σ))
def Lean.PersistentEnvExtension.toEnvExtension : forall {α : Type} {β : Type} {σ : Type}, (Lean.PersistentEnvExtension α β σ) -> (Lean.EnvExtension (Lean.PersistentEnvExtensionState α σ)) :=
  fun (α : Type) (β : Type) (σ : Type) (self : Lean.PersistentEnvExtension α β σ) => self.1
