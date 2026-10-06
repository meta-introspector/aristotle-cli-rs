import Mathlib

set_option pp.all true
-- spec: Lean.KeyedDeclsAttribute.instInhabitedOLeanEntry.default : Lean.KeyedDeclsAttribute.OLeanEntry
def Lean.KeyedDeclsAttribute.instInhabitedOLeanEntry.default : Lean.KeyedDeclsAttribute.OLeanEntry :=
  Lean.KeyedDeclsAttribute.OLeanEntry.mk (Inhabited.default.{1} Lean.KeyedDeclsAttribute.Key Lean.instInhabitedName) (Inhabited.default.{1} Lean.Name Lean.instInhabitedName)
