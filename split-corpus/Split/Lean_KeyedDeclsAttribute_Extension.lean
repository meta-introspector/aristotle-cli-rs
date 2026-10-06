import Mathlib

set_option pp.all true
-- spec: Lean.KeyedDeclsAttribute.Extension : Type -> Type
def Lean.KeyedDeclsAttribute.Extension : Type -> Type :=
  fun (γ : Type) => Lean.ScopedEnvExtension Lean.KeyedDeclsAttribute.OLeanEntry (Lean.KeyedDeclsAttribute.AttributeEntry γ) (Lean.KeyedDeclsAttribute.ExtensionState γ)
