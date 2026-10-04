import Mathlib

set_option pp.all true
-- spec: Lean.KeyedDeclsAttribute.ext : forall {γ : Type}, (Lean.KeyedDeclsAttribute γ) -> (Lean.KeyedDeclsAttribute.Extension γ)
def Lean.KeyedDeclsAttribute.ext : forall {γ : Type}, (Lean.KeyedDeclsAttribute γ) -> (Lean.KeyedDeclsAttribute.Extension γ) :=
  fun (γ : Type) (self : Lean.KeyedDeclsAttribute γ) => self.3
