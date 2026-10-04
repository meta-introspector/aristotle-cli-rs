import Mathlib

set_option pp.all true
-- spec: Lean.KeyedDeclsAttribute.ExtensionState.erased : forall {γ : Type}, (Lean.KeyedDeclsAttribute.ExtensionState γ) -> (Lean.PHashSet.{0} Lean.Name Lean.Name.instBEq Lean.instHashableName)
def Lean.KeyedDeclsAttribute.ExtensionState.erased : forall {γ : Type}, (Lean.KeyedDeclsAttribute.ExtensionState γ) -> (Lean.PHashSet.{0} Lean.Name Lean.Name.instBEq Lean.instHashableName) :=
  fun (γ : Type) (self : Lean.KeyedDeclsAttribute.ExtensionState γ) => self.4
