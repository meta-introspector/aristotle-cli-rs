import Mathlib

set_option pp.all true
-- spec: Lean.PersistentEnvExtensionState.state : forall {α : Type} {σ : Type}, (Lean.PersistentEnvExtensionState α σ) -> σ
def Lean.PersistentEnvExtensionState.state : forall {α : Type} {σ : Type}, (Lean.PersistentEnvExtensionState α σ) -> σ :=
  fun (α : Type) (σ : Type) (self : Lean.PersistentEnvExtensionState α σ) => self.2
