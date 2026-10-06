import Mathlib

set_option pp.all true
-- spec: Lean.KeyedDeclsAttribute.OLeanEntry.declName : Lean.KeyedDeclsAttribute.OLeanEntry -> Lean.Name
def Lean.KeyedDeclsAttribute.OLeanEntry.declName : Lean.KeyedDeclsAttribute.OLeanEntry -> Lean.Name :=
  fun (self : Lean.KeyedDeclsAttribute.OLeanEntry) => self.2
