import Mathlib

set_option pp.all true
-- spec: Lean.ScopedEnvExtension.StateStack.stateStack : forall {α : Type} {β : Type} {σ : Type}, (Lean.ScopedEnvExtension.StateStack α β σ) -> (List.{0} (Lean.ScopedEnvExtension.State σ))
def Lean.ScopedEnvExtension.StateStack.stateStack : forall {α : Type} {β : Type} {σ : Type}, (Lean.ScopedEnvExtension.StateStack α β σ) -> (List.{0} (Lean.ScopedEnvExtension.State σ)) :=
  fun (α : Type) (β : Type) (σ : Type) (self : Lean.ScopedEnvExtension.StateStack α β σ) => self.1
