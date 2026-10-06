import Mathlib

set_option pp.all true
-- spec: Lean.KeyedDeclsAttribute.AttributeEntry.toOLeanEntry : forall {γ : Type}, (Lean.KeyedDeclsAttribute.AttributeEntry γ) -> Lean.KeyedDeclsAttribute.OLeanEntry
def Lean.KeyedDeclsAttribute.AttributeEntry.toOLeanEntry : forall {γ : Type}, (Lean.KeyedDeclsAttribute.AttributeEntry γ) -> Lean.KeyedDeclsAttribute.OLeanEntry :=
  fun (γ : Type) (self : Lean.KeyedDeclsAttribute.AttributeEntry γ) => self.1
