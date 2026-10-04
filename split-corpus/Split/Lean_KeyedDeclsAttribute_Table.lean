import Mathlib

set_option pp.all true
-- spec: Lean.KeyedDeclsAttribute.Table : Type -> Type
def Lean.KeyedDeclsAttribute.Table : Type -> Type :=
  fun (γ : Type) => Lean.SMap.{0, 0} Lean.KeyedDeclsAttribute.Key (List.{0} (Lean.KeyedDeclsAttribute.AttributeEntry γ)) Lean.Name.instBEq Lean.instHashableName
