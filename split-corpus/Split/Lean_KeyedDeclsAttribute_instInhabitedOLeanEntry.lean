import Mathlib

set_option pp.all true
-- spec: Lean.KeyedDeclsAttribute.instInhabitedOLeanEntry : Inhabited.{1} Lean.KeyedDeclsAttribute.OLeanEntry
def Lean.KeyedDeclsAttribute.instInhabitedOLeanEntry : Inhabited.{1} Lean.KeyedDeclsAttribute.OLeanEntry :=
  Inhabited.mk.{1} Lean.KeyedDeclsAttribute.OLeanEntry Lean.KeyedDeclsAttribute.instInhabitedOLeanEntry.default
