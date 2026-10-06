import Mathlib

set_option pp.all true
-- spec: Lean.KeyedDeclsAttribute.ExtensionState.table : forall {γ : Type}, (Lean.KeyedDeclsAttribute.ExtensionState γ) -> (Lean.KeyedDeclsAttribute.Table γ)
def Lean.KeyedDeclsAttribute.ExtensionState.table : forall {γ : Type}, (Lean.KeyedDeclsAttribute.ExtensionState γ) -> (Lean.KeyedDeclsAttribute.Table γ) :=
  fun (γ : Type) (self : Lean.KeyedDeclsAttribute.ExtensionState γ) => self.2
