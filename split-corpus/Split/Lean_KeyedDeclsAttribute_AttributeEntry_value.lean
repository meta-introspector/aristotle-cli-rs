import Mathlib

set_option pp.all true
-- spec: Lean.KeyedDeclsAttribute.AttributeEntry.value : forall {γ : Type}, (Lean.KeyedDeclsAttribute.AttributeEntry γ) -> γ
def Lean.KeyedDeclsAttribute.AttributeEntry.value : forall {γ : Type}, (Lean.KeyedDeclsAttribute.AttributeEntry γ) -> γ :=
  fun (γ : Type) (self : Lean.KeyedDeclsAttribute.AttributeEntry γ) => self.3
