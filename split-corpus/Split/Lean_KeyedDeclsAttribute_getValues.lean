import Mathlib

set_option pp.all true
-- spec: Lean.KeyedDeclsAttribute.getValues : forall {γ : Type}, (Lean.KeyedDeclsAttribute γ) -> Lean.Environment -> Lean.Name -> (List.{0} γ)
def Lean.KeyedDeclsAttribute.getValues : forall {γ : Type}, (Lean.KeyedDeclsAttribute γ) -> Lean.Environment -> Lean.Name -> (List.{0} γ) :=
  fun {γ : Type} (attr : Lean.KeyedDeclsAttribute γ) (env : Lean.Environment) (key : Lean.Name) => List.map.{0, 0} (Lean.KeyedDeclsAttribute.AttributeEntry γ) γ (Lean.KeyedDeclsAttribute.AttributeEntry.value γ) (Lean.KeyedDeclsAttribute.getEntries γ attr env key)
